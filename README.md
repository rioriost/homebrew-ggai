# GGAI

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/Python-3.10%2B-blue)

Helper for GeoGuessr training using OpenAI

## Table of Contents

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Usage](#usage)
- [Release Notes](#release-notes)
- [License](#license)

## Prerequisites

- macOS
- Python 3.10 and above

## Install

- with brew

```bash
brew tap rioriost/ggai
brew install ggai
```

## Usage

```bash
ggai --help
usage: ggai [-h] [-k KEY] [-m MODEL] [-f FILENAME]

ggai

options:
  -h, --help            show this help message and exit
  -k KEY, --key KEY     OpenAI API key
  -m MODEL, --model MODEL
                        OpenAI Model to use, default: gpt-4o
  -f FILENAME, --filename FILENAME
                        Filename for screencapture
```

## Release Notes

### 0.1.1 Release
- Initial release

## License

MIT License
