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
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    parser = argparse.ArgumentParser(description="ggai")
    parser.add_argument(
        "-k",
        "--key",
        type=str,
        default="",
        help="OpenAI API key",
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
        "--description",
        type=str,
        default=f"ggai-{timestamp}.txt",
        help="Description for screencapture",
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
    file_path = os.path.join(os.path.expanduser("~"), "Desktop", args.filename)
    capture_front_window(file_path)
    image_b64 = encode_image_to_b64(file_path)

    prompt = """
    以下のフォーマットで回答してください。

    1) 結論：<国名>（確信度：<数値>%）
    2) 根拠（5つの箇条書き）：
       1. …
       2. …
       3. …
       4. …
       5. …

    3) 「特定できません」といった表現は禁止します。
    4) 画像右下のミニマップと白いX印は分析に使用しないでください。

    まず、画像から判別に有用な特徴を5つ挙げ、その後総合して結論を述べてください。
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
                            "高度な観察眼で、与えられた風景写真から以下の107の国・地域のいずれであるかを特定してください。"
                            "Andorra, Austria, Belgium, France, Germany, Greece, Ireland, Isle of Man, Italy, Luxembourg, Malta, Monaco, Netherlands, Portugal, Spain, Switzerland, United Kingdom, Albania, Bulgaria, Croatia, Czech Republic, Hungary, Montenegro, North Macedonia, Poland, Romania, Russia, Serbia, Slovakia, Slovenia, Ukraine, Denmark, Faroe Islands, Finland, Greenland, Iceland, Norway, Sweden, Estonia, Latvia, Lithuania, Argentina, Bolivia, Brazil, Chile, Colombia, Costa Rica, Curaçao, Dominican Republic, Ecuador, Guatemala, Mexico, Panama, Peru, Puerto Rico, Uruguay, U.S. Virgin Islands, Bermuda, Canada, United States of America, Bangladesh, Bhutan, Cambodia, Christmas Island, India, Indonesia, Laos, Malaysia, Pakistan, Philippines, Singapore, Sri Lanka, Thailand, Vietnam, China, Hong Kong, Japan, Kazakhstan, Kyrgyzstan, Mongolia, South Korea, Taiwan, American Samoa, Australia, Guam, New Zealand, Northern Mariana Islands, U.S. Minor Outlying Islands, Botswana, Eswatini, Ghana, Kenya, Lesotho, Madagascar, Nigeria, Réunion, Rwanda, Senegal, South Africa, Uganda, Israel, Jordan, Palestine, Qatar, Tunisia, Turkey, United Arab Emirates"
                            "特定した根拠を明確かつ詳細に説明してください。"
                            "国・地域別のGoogle Carの特徴（Car Meta）も根拠として利用してください。"
                            "これらの国・地域以外は無効な回答なので、検討を最初からやり直してください。"
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

    print(response.output_text)
    desc_path = os.path.join(os.path.expanduser("~"), "Desktop", args.description)
    with open(desc_path, "w") as f:
        f.write(response.output_text)


def main():
    """
    Main entry point: Initialize the application and run the main loop.
    """
    asyncio.run(async_main())


if __name__ == "__main__":
    main()
