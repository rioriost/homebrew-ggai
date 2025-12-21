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
usage: ggai [-h] [-k KEY] [-m MODEL] [-f FILENAME] [-d DIRECTORY]

ggai

options:
  -h, --help            show this help message and exit
  -k KEY, --key KEY     OpenAI API key
  -m MODEL, --model MODEL
                        OpenAI Model to use, default: gpt-4o
  -f FILENAME, --filename FILENAME
                        Filename for screencapture
  -d DIRECTORY, --directory DIRECTORY
                        Directory to save screencapture
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

### 0.4.23 Release
- Dependency Update

### 0.4.22 Release
- Dependency Update

### 0.4.21 Release
- Dependency Update

### 0.4.20 Release
- Security Update

### 0.4.19 Release
- Dependency Update

### 0.4.18 Release
- Dependency Update

### 0.4.17 Release
- Dependency Update

### 0.4.16 Release
- Dependency Update

### 0.4.15 Release
- Dependency Update

### 0.4.14 Release
- Dependency Update

### 0.4.13 Release
- Dependency Update

### 0.4.12 Release
- Dependency Update

### 0.4.11 Release
- Dependency Update

### 0.4.10 Release
- Dependency Update

### 0.4.9 Release
- Dependency Update

### 0.4.8 Release
- Changed the default model to GPT-5, it takes much longer to guess than gpt-4o

### 0.4.7 Release
- Dependency Update

### 0.4.6 Release
- Dependency Update

### 0.4.5 Release
- Dependency Update

### 0.4.4 Release
- Dependency Update

### 0.4.3 Release
- Dependency Update

### 0.4.2 Release
- Dependency Update

### 0.4.1 Release
- Improved robustness

### 0.4.0 Release
- Refactored

### 0.3.2 Release
- Show guessing duration

### 0.3.1 Release
- Improved prompt

### 0.3.0 Release
- Added directory argument

### 0.2.2 Release
- Improved prompt

### 0.2.1 Release
- Added text embedding

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
