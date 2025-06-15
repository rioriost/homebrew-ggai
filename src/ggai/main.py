#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import asyncio
import base64
from datetime import datetime
import logging
import os
import subprocess
import sys

from PIL import Image, ImageDraw, ImageFont
from openai import AsyncOpenAI

from AppKit import NSWorkspace
from Quartz import (
    CGWindowListCopyWindowInfo,
    kCGWindowListOptionOnScreenOnly,
    kCGNullWindowID,
)

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)


def parse_arguments() -> argparse.Namespace:
    """
    Parse command-line arguments.

    Returns:
        argparse.Namespace: Parsed arguments.
    """
    DEFAULT_MODEL = "gpt-4o"
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
        help=f"Language to be embedded, default: {DEFAULT_LANG}",
    )
    parser.add_argument(
        "-m",
        "--model",
        type=str,
        default=DEFAULT_MODEL,
        help=f"OpenAI Model to use, default: {DEFAULT_MODEL}",
    )
    parser.add_argument(
        "-f",
        "--filename",
        type=str,
        default=f"ggai-{timestamp}.png",
        help="Filename for screencapture",
    )
    parser.add_argument(
        "-d",
        "--directory",
        type=str,
        default=os.path.join(os.path.expanduser("~"), "Desktop"),
        help="Directory to save screencapture",
    )

    return parser.parse_args()


def get_frontmost_window_id() -> int | None:
    """
    PyObjC を使って、最前面アプリのウインドウの CGWindowID を取得する。
    """
    # 最前面アプリのプロセス ID を得る
    ws = NSWorkspace.sharedWorkspace()
    front_app = ws.frontmostApplication()
    pid = front_app.processIdentifier()

    # 画面上にあるすべてのウインドウ情報を取得
    options = kCGWindowListOptionOnScreenOnly
    window_list = CGWindowListCopyWindowInfo(options, kCGNullWindowID)

    # PID が一致する最初のウインドウを選ぶ
    for win in window_list:
        if win.get("kCGWindowOwnerPID") == pid:
            # PyObjC の OC_PythonLong → Python 組み込み int へ変換
            raw = win.get("kCGWindowNumber")
            try:
                return int(raw)
            except Exception:
                # 万が一変換できなければスキップ
                continue

    return None


def capture_front_window(file_path: str) -> None:
    """
    screencapture で最前面のウインドウをキャプチャし、
    ~/Desktop/filename.png に保存する。
    """
    window_id = get_frontmost_window_id()
    if not window_id:
        print("Error: 最前面のウインドウIDが取得できませんでした。", file=sys.stderr)
        sys.exit(1)

    # -l <windowid>: 指定ウィンドウのみキャプチャ
    # -o         : 撮影時のシャドウ(影)を省略
    cmd = ["screencapture", "-l", str(window_id), "-o", file_path]

    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        sys.exit(1)


def encode_image_to_b64(path: str) -> str:
    with open(path, "rb") as f:
        data = f.read()
    b64 = base64.b64encode(data).decode("utf-8")
    return f"data:image/png;base64,{b64}"


async def async_main():
    """
    Main asynchronous entry point: Initialize the application and run the main loop.
    """
    args = parse_arguments()
    file_path = os.path.join(args.directory, args.filename)
    capture_front_window(file_path)
    image_b64 = encode_image_to_b64(file_path)

    prompt = f"""
    {args.language}で以下のフォーマットで回答してください。()内は根拠のカテゴリーです。写真内にその要素が無い場合は、「〜は写っていない。」あるいは「判別出来ない。」と明記してください。例「1.(言語):写っていない。」「5.(道路の左右通行):判別出来ない」

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

    client = AsyncOpenAI(api_key=args.key)
    response = await client.responses.create(
        model=args.model,
        input=[
            {
                "role": "system",
                "content": [
                    {
                        "type": "input_text",
                        "text": (
                            "あなたはGeoGuessrのトッププレイヤーです。"
                            "高度な観察眼で、与えられた風景写真から以下の107の国・地域のいずれであるかを特定してください。必ずこの中から1ヶ国を選択して回答してください。"
                            "Andorra, Austria, Belgium, France, Germany, Greece, Ireland, Isle of Man, Italy, Luxembourg, Malta, Monaco, Netherlands, Portugal, Spain, Switzerland, United Kingdom, Albania, Bulgaria, Croatia, Czech Republic, Hungary, Montenegro, North Macedonia, Poland, Romania, Russia, Serbia, Slovakia, Slovenia, Ukraine, Denmark, Faroe Islands, Finland, Greenland, Iceland, Norway, Sweden, Estonia, Latvia, Lithuania, Argentina, Bolivia, Brazil, Chile, Colombia, Costa Rica, Curaçao, Dominican Republic, Ecuador, Guatemala, Mexico, Panama, Peru, Puerto Rico, Uruguay, U.S. Virgin Islands, Bermuda, Canada, United States of America, Bangladesh, Bhutan, Cambodia, Christmas Island, India, Indonesia, Laos, Malaysia, Pakistan, Philippines, Singapore, Sri Lanka, Thailand, Vietnam, China, Hong Kong, Japan, Kazakhstan, Kyrgyzstan, Mongolia, South Korea, Taiwan, American Samoa, Australia, Guam, New Zealand, Northern Mariana Islands, U.S. Minor Outlying Islands, Botswana, Eswatini, Ghana, Kenya, Lesotho, Madagascar, Nigeria, Réunion, Rwanda, Senegal, South Africa, Uganda, Israel, Jordan, Palestine, Qatar, Tunisia, Turkey, United Arab Emirates"
                            "これらの国・地域以外は無効な回答なので、検討を最初からやり直してください。"
                            "画像右下のミニマップと白いX印は分析に使用しないでください。"
                            "特定した根拠を明確かつ詳細に説明してください。"
                            "「ヨーロッパ的な特徴を持つ標識」といったあいまいな説明ではなく、例えば「スペインでしか見られない横断歩道標識」といった特定に繋がる知識を重視してください。"
                            "国・地域別のGoogle Carの特徴（Car Meta）も根拠として利用し、具体的にその特徴を挙げてください。"
                            "道路のラインの判別は注意深く行ってください。側線と中央線を間違えないようにしてください。"
                        ),
                    }
                ],
            },
            {
                "role": "user",
                "content": [
                    {"type": "input_text", "text": prompt},
                    {"type": "input_image", "image_url": image_b64},
                ],
            },
        ],
    )

    img = Image.open(file_path).convert("RGBA")
    draw = ImageDraw.Draw(img)
    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    overlay_draw = ImageDraw.Draw(overlay)

    try:
        font = ImageFont.truetype("/Library/Fonts/ヒラギノ角ゴシック W3.ttc", 16)
    except IOError:
        font = ImageFont.load_default()

    text = response.output_text
    margin = 20
    max_width = img.width - 2 * margin
    lines = []
    for paragraph in text.split("\n"):
        words = paragraph.split(" ")
        line = ""
        for w in words:
            test = f"{line} {w}".strip()
            # textbbox で幅を取得
            bbox = draw.textbbox((0, 0), test, font=font)
            w_px = bbox[2] - bbox[0]
            if w_px <= max_width:
                line = test
            else:
                lines.append(line)
                line = w
        lines.append(line)

    _, _, _, h = draw.textbbox((0, 0), "Ay", font=font)
    line_height = h + 4
    total_height = line_height * len(lines)
    y = img.height - total_height - margin

    bg_height = total_height + margin
    rectangle = (0, img.height - bg_height, img.width, img.height)
    overlay_draw.rectangle(rectangle, fill=(63, 63, 63, 127))

    for line in lines:
        overlay_draw.text((margin, y), line, font=font, fill=(255, 255, 255, 255))
        y += line_height

    img = Image.alpha_composite(img, overlay)
    img.convert("RGB").save(file_path)
    print(f"Embedded text into image: {file_path}")


def main():
    """
    Main entry point: Initialize the application and run the main loop.
    """
    asyncio.run(async_main())


if __name__ == "__main__":
    main()
