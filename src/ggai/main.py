#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import base64
import logging
import os
import subprocess
import sys
from datetime import datetime

import openai
from PIL import Image, ImageDraw, ImageFont
from AppKit import NSWorkspace
from Quartz import (
    CGWindowListCopyWindowInfo,
    kCGWindowListOptionOnScreenOnly,
    kCGNullWindowID,
)

# Logging setup
logging.basicConfig(level=logging.ERROR, format="[%(levelname)s] %(message)s")
log = logging.getLogger(__name__)


def parse_arguments() -> argparse.Namespace:
    DEFAULT_MODEL = "gpt-5"
    DEFAULT_LANG = "Japanese"
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")

    parser = argparse.ArgumentParser(description="ggai")
    parser.add_argument(
        "-k",
        "--key",
        type=str,
        default=os.environ.get("OPENAI_API_KEY", ""),
        help="OpenAI API key",
    )
    parser.add_argument(
        "-l",
        "--language",
        type=str,
        default=DEFAULT_LANG,
        help=f"Language to embed (default: {DEFAULT_LANG})",
    )
    parser.add_argument(
        "-m",
        "--model",
        type=str,
        default=DEFAULT_MODEL,
        help=f"OpenAI model (default: {DEFAULT_MODEL})",
    )
    parser.add_argument(
        "-f",
        "--filename",
        type=str,
        default=f"ggai-{timestamp}.png",
        help="Screenshot filename",
    )
    parser.add_argument(
        "-d",
        "--directory",
        type=str,
        default=os.path.join(os.path.expanduser("~"), "Desktop"),
        help="Save directory",
    )
    return parser.parse_args()


def get_frontmost_window_id() -> int | None:
    ws = NSWorkspace.sharedWorkspace()
    front_app = ws.frontmostApplication()
    pid = front_app.processIdentifier()

    window_list = CGWindowListCopyWindowInfo(
        kCGWindowListOptionOnScreenOnly, kCGNullWindowID
    )

    for win in window_list:
        if win.get("kCGWindowOwnerPID") == pid:
            try:
                return int(win.get("kCGWindowNumber"))
            except Exception as e:
                log.warning(f"Failed to get window ID: {e}")
                continue
    return None


def capture_front_window(file_path: str) -> None:
    window_id = get_frontmost_window_id()
    if not window_id:
        log.error("Failed to get window id in the frontmost")
        sys.exit(1)

    cmd = ["screencapture", "-l", str(window_id), "-o", file_path]

    try:
        subprocess.run(cmd, check=True)
        log.info(f"Saved screenshot: {file_path}")
    except subprocess.CalledProcessError as e:
        log.error(f"Failed to execute screencapture: {e}")
        sys.exit(1)


def encode_image_to_b64(path: str) -> str:
    with open(path, "rb") as f:
        b64 = base64.b64encode(f.read()).decode("utf-8")
    return f"data:image/png;base64,{b64}"


def build_prompt(language: str) -> str:
    return f"""
{language}で以下のフォーマットで回答してください。()内は根拠のカテゴリーです。写真内にその要素が無い場合は、「〜は写っていない。」あるいは「判別出来ない。」と明記してください。

1) 結論：<国名>
2) 根拠：
   1.(言語):...
   2.(道路標識):...
   3.(ナンバープレート):...
   4.(カーメタ):...
   5.(道路の左右通行):...
   6.(環境・植生・地形):...
   7.(電柱・電線):...
   8.(道路のペイント・ライン):...
   9.(建築スタイル):...
   10.(その他):...
"""


def call_openai(api_key: str, model: str, prompt: str, image_b64: str) -> str:
    openai_client = openai.OpenAI(api_key=api_key)

    try:
        response = openai_client.chat.completions.create(
            model=model,
            messages=[
                {
                    "role": "system",
                    "content": "あなたはGeoGuessrのトッププレイヤーです。"
                    "高度な観察眼で、与えられた風景写真から以下の107の国・地域のいずれであるかを特定してください。必ずこの中から1ヶ国を選択して回答してください。"
                    "Andorra, Austria, Belgium, France, Germany, Greece, Ireland, Isle of Man, Italy, Luxembourg, Malta, Monaco, Netherlands, Portugal, Spain, Switzerland, United Kingdom, Albania, Bulgaria, Croatia, Czech Republic, Hungary, Montenegro, North Macedonia, Poland, Romania, Russia, Serbia, Slovakia, Slovenia, Ukraine, Denmark, Faroe Islands, Finland, Greenland, Iceland, Norway, Sweden, Estonia, Latvia, Lithuania, Argentina, Bolivia, Brazil, Chile, Colombia, Costa Rica, Curaçao, Dominican Republic, Ecuador, Guatemala, Mexico, Panama, Peru, Puerto Rico, Uruguay, U.S. Virgin Islands, Bermuda, Canada, United States of America, Bangladesh, Bhutan, Cambodia, Christmas Island, India, Indonesia, Laos, Malaysia, Pakistan, Philippines, Singapore, Sri Lanka, Thailand, Vietnam, China, Hong Kong, Japan, Kazakhstan, Kyrgyzstan, Mongolia, South Korea, Taiwan, American Samoa, Australia, Guam, New Zealand, Northern Mariana Islands, U.S. Minor Outlying Islands, Botswana, Eswatini, Ghana, Kenya, Lesotho, Madagascar, Nigeria, Réunion, Rwanda, Senegal, South Africa, Uganda, Israel, Jordan, Palestine, Qatar, Tunisia, Turkey, United Arab Emirates"
                    "これらの国・地域以外は無効な回答なので、検討を最初からやり直してください。"
                    "画像右下のミニマップと白いX印は分析に使用しないでください。"
                    "特定した根拠を明確かつ詳細に説明してください。"
                    "「ヨーロッパ的な特徴を持つ標識」といったあいまいな説明ではなく、例えば「スペインでしか見られない横断歩道標識」といった特定に繋がる知識を重視してください。"
                    "国・地域別のGoogle Carの特徴（Car Meta）も根拠として利用し、具体的にその特徴を挙げてください。"
                    "道路のラインの判別は注意深く行ってください。側線と中央線を間違えないようにしてください。"
                    "人物を特定するリクエストではありません。",
                },
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": prompt},
                        {"type": "image_url", "image_url": {"url": image_b64}},
                    ],
                },
            ],
        )
        return response.choices[0].message.content
    except Exception as e:
        log.error(f"Error to call OpenAI API: {e}")
        sys.exit(1)


def draw_overlay_text(img_path: str, text: str) -> None:
    try:
        img = Image.open(img_path).convert("RGBA")
        draw = ImageDraw.Draw(img)
        overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
        overlay_draw = ImageDraw.Draw(overlay)

        try:
            font = ImageFont.truetype("/Library/Fonts/ヒラギノ角ゴシック W3.ttc", 16)
        except IOError:
            font = ImageFont.load_default()

        margin = 20
        max_width = img.width - 2 * margin
        lines = []

        for paragraph in text.split("\n"):
            words = paragraph.split(" ")
            line = ""
            for word in words:
                test_line = f"{line} {word}".strip()
                bbox = draw.textbbox((0, 0), test_line, font=font)
                if bbox[2] - bbox[0] <= max_width:
                    line = test_line
                else:
                    lines.append(line)
                    line = word
            lines.append(line)

        _, _, _, h = draw.textbbox((0, 0), "Ay", font=font)
        line_height = h + 4
        total_height = line_height * len(lines)
        y = img.height - total_height - margin

        overlay_draw.rectangle(
            (0, img.height - total_height - margin, img.width, img.height),
            fill=(63, 63, 63, 127),
        )

        for line in lines:
            overlay_draw.text((margin, y), line, font=font, fill=(255, 255, 255, 255))
            y += line_height

        img = Image.alpha_composite(img, overlay)
        img.convert("RGB").save(img_path)
        log.info(f"Embedded text to the image: {img_path}")

    except Exception as e:
        log.error(f"Error to draw: {e}")
        sys.exit(1)


def main():
    RETRY_MAX = 5
    args = parse_arguments()

    if not args.key:
        log.error("OpenAI API key not specified")
        sys.exit(1)

    file_path = os.path.join(args.directory, args.filename)
    capture_front_window(file_path)

    prompt = build_prompt(args.language)
    image_b64 = encode_image_to_b64(file_path)

    start_time = datetime.now()
    retry_cnt = 1
    while retry_cnt < RETRY_MAX:
        result_text = call_openai(args.key, args.model, prompt, image_b64)
        if "I'm unable" not in result_text and "I'm sorry" not in result_text:
            break
        retry_cnt += 1
    draw_overlay_text(file_path, result_text)
    duration = datetime.now() - start_time

    print(f"Duration to guess: {duration}")


if __name__ == "__main__":
    main()
