# GGAI

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/Python-3.10%2B-blue)

Helper for GeoGuessr training using OpenAI

## Table of Contents

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Usage](#usage)
- [Setup](#setup)
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

## Setup

Create a quickaction with Automator.

![Automator](https://raw.githubusercontent.com/rioriost/homebrew-ggai/refs/heads/main/images/automator-01.png)
![Automator](https://raw.githubusercontent.com/rioriost/homebrew-ggai/refs/heads/main/images/automator-02.png)
![Automator](https://raw.githubusercontent.com/rioriost/homebrew-ggai/refs/heads/main/images/automator-03.png)

And, put a script with API key for OpenAI.

```bash
result=$(/opt/homebrew/bin/ggai -k "sk-proj-......")

osascript <<EOD
display dialog "$(echo "$result" | sed 's/"/\\"/g')" buttons {"OK"} default button 1
EOD
```

After saving the quickaction as 'ggai', you can call it from 'Services...' menu.

![Automator](https://raw.githubusercontent.com/rioriost/homebrew-ggai/refs/heads/main/images/automator-04.png)

![Sample](https://raw.githubusercontent.com/rioriost/homebrew-ggai/refs/heads/main/images/ggai.png)

## Release Notes

### 0.2.0 Release
- Added a feature to write a file of guess

### 0.1.6 Release
- Improved prompt

### 0.1.5 Release
- Improved prompt

### 0.1.4 Release
- Improved prompt

### 0.1.3 Release
- Fixed package size

### 0.1.2 Release
- Added detailed README

### 0.1.1 Release
- Initial release

## License

MIT License
