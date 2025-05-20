# ctfpeek

**ctfpeek** is a lightweight Bash script for rapid triage of files in Capture The Flag (CTF) competitions. It automates the initial analysis process by scanning files with a suite of common forensic, steganographic, and reverse engineering tools.

---

## Features

- Detects file type and encoding
- Searches for flag-like strings
- Extracts embedded files (binwalk, foremost)
- Analyzes metadata in images and documents
- Checks for steganography (zsteg, stegseek)
- Performs OCR on images (tesseract)
- Performs entropy analysis (optional)
- Logs results to a file for later review

---

## Example Usage

```bash
ctfpeek challenge_file.jpg
```

You’ll see output like:

```
==================== FILE TYPE ====================
...
==================== STRINGS (flag-like content) ====================
...
==================== BINWALK ====================
...
```

And a log file like:

```
ctfpeek-challenge_file.jpg.log
```

---

## Installation

1. Clone the repo:

```bash
git clone https://github.com/yourusername/ctfpeek.git
cd ctfpeek
```

2. Make the script executable:

```bash
chmod +x ctfpeek
```

3. (Optional) Move it to your system path:

```bash
sudo mv ctfpeek /usr/local/bin/
```

Now you can run `ctfpeek` from anywhere.

---

## Dependencies

`ctfpeek` uses the following tools if available:

- `file`
- `strings`
- `binwalk`
- `foremost`
- `exiftool`
- `zsteg`
- `stegseek`
- `pdfinfo`
- `rabin2` (from radare2)
- `tesseract`
- `identify` (ImageMagick)
- `xxd`
- `ent` (optional)

To install them on Debian-based systems (e.g., Kali Linux):

```bash
sudo apt update && sudo apt install -y \
  binwalk foremost exiftool zsteg stegseek \
  poppler-utils radare2 tesseract-ocr imagemagick \
  xxd ent
```

---

## Why Use ctfpeek?

- Saves time on repetitive file inspection tasks
- Quickly surfaces useful leads
- Works with many common CTF file types (images, binaries, archives, documents)
- Lightweight and portable — no Python, just Bash

---

## License

MIT License

---

## Contributing

Pull requests and suggestions are welcome! If you have tool ideas, edge cases, or performance tweaks, feel free to submit an issue or PR.

---

## Author

Created by [Your Name or Handle]
