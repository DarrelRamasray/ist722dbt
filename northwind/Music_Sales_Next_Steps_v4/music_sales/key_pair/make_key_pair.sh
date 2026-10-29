#!/usr/bin/env bash
# =====================================================================
# make_key_pair.sh
# Run in: Git Bash (Windows) or Terminal (Mac). From the folder that
#   holds this file, type:   bash make_key_pair.sh
# What it does: creates one RSA key pair for Snowflake key-pair sign-in.
#   rsa_key.p8                 private key: dbt and Power BI use this.
#                              Keep it secret. Never upload it to GitHub.
#   rsa_key.pub                public key, full PEM file
#   rsa_key_public_oneline.txt public key on one line, for 06_set_public_key.sql
# All three files go in a folder named snowflake_keys in your home folder
# (Windows: C:\Users\<you>\snowflake_keys).
# =====================================================================

set -e

KEYDIR="$HOME/snowflake_keys"
mkdir -p "$KEYDIR"
cd "$KEYDIR"

# Stop instead of replacing a key you may already be using
if [ -f rsa_key.p8 ]; then
  echo "rsa_key.p8 already exists in $KEYDIR"
  echo "Stopping so the existing key is not overwritten."
  exit 1
fi

# 1. Private key, PKCS#8 format, no passphrase
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt

# 2. Public key that matches it
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

# 3. Public key body on one line (no BEGIN/END lines, no line breaks)
grep -v "PUBLIC KEY" rsa_key.pub | tr -d '\r\n' > rsa_key_public_oneline.txt

echo
echo "Done. Your key files are in: $KEYDIR"
ls -l
echo
echo "Your public key on one line (paste it into 06_set_public_key.sql):"
echo
cat rsa_key_public_oneline.txt
echo
