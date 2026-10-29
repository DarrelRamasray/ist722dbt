#!/usr/bin/env bash
# =====================================================================
# key_fingerprint.sh
# Run in: Git Bash (Windows) or Terminal (Mac), from this folder:
#     bash key_fingerprint.sh "/c/Users/<you>/path/to/your_key_file.p8"
# What it does: prints the fingerprint of a private key file, so you can
#   compare it with RSA_PUBLIC_KEY_FP in Snowflake's DESC USER output.
#   If they match (ignoring the "SHA256:" at the start), this is the key
#   Snowflake knows. If the key has a passphrase, openssl asks for it.
# =====================================================================

set -e

if [ -z "$1" ] || [ ! -f "$1" ]; then
  echo "Give the path to your private key file in quotes, for example:"
  echo '  bash key_fingerprint.sh "/c/Users/darre/snowflake_keys/rsa_key.p8"'
  exit 1
fi

echo "First line of the file (tells you whether it has a passphrase):"
head -1 "$1"
echo
echo "Fingerprint (compare with RSA_PUBLIC_KEY_FP, without SHA256:):"
openssl rsa -in "$1" -pubout -outform DER | openssl dgst -sha256 -binary | openssl enc -base64
