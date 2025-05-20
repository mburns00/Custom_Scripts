#!/usr/bin/env bash
# ctfpeek – enhanced CTF triage tool
set -euo pipefail
IFS=$'\n\t'

if [[ $# -ne 1 ]]; then
  echo "Usage: ctfpeek <file>" >&2
  exit 1
fi

f="$1"
tmpdir=$(mktemp -d -t ctfpeek-XXXX)
log="ctfpeek-$(basename "$f").log"
exec > >(tee -a "$log") 2>&1

section() {
  echo
  echo "==================== $1 ===================="
}

info() {
  echo "[+] $1"
}

error() {
  echo "[-] $1" >&2
}

run_if_exists() {
  local cmd=$1
  shift
  if command -v "$cmd" &>/dev/null; then
    "$@"
  else
    error "$cmd not found – skipping"
  fi
}

# --- Start Triage ---
section "FILE TYPE"
file "$f" || true

section "STRINGS (flag-like content)"
strings -a "$f" 2>/dev/null | grep -aiE "flag|ctf|key|token|pass" | head -n 30 || true

section "BINWALK"
run_if_exists binwalk binwalk --extract --matryoshka "$f"

section "FOREMOST (file carving)"
run_if_exists foremost foremost -T -q -i "$f" -o "$tmpdir"
[ -d "$tmpdir" ] && find "$tmpdir" -type f | head -n 15 || true

section "EXIF METADATA"
run_if_exists exiftool exiftool "$f" | head -n 20

section "ZSTEG (LSB steganography)"
run_if_exists zsteg zsteg "$f" | head -n 20

section "STEGSEEK (common password steg)"
if command -v stegseek >/dev/null && [ -f /usr/share/wordlists/rockyou.txt ]; then
  stegseek --quiet "$f" /usr/share/wordlists/rockyou.txt | head -n 10 || true
else
  error "stegseek or rockyou.txt not found – skipping"
fi

section "PDF INFO"
[[ "$f" == *.pdf ]] && run_if_exists pdfinfo pdfinfo "$f" || true

section "RADARE2 STRINGS (rabin2)"
run_if_exists rabin2 rabin2 -zz "$f" | head -n 25

# OCR only for image files
if command -v identify >/dev/null && identify "$f" >/dev/null 2>&1; then
  section "OCR (tesseract)"
  run_if_exists tesseract tesseract "$f" stdout | head -n 20
fi

section "HEXDUMP"
run_if_exists xxd xxd -g1 -C "$f" | head -n 25

section "ENTROPY SCAN"
if command -v ent >/dev/null; then
  ent "$f" | head -n 10
else
  error "ent (entropy) not found – skipping"
fi

section "STRINGS (all)"
strings "$f" | head -n 50 || true

# Cleanup
rm -rf "$tmpdir"

info "Output saved to $log"
