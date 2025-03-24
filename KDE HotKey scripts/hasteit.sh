#!/bin/bash

HASTE_SERVER=https://haste.logixy.net

# Check if xclip or xsel is installed
if ! command -v xclip &> /dev/null && ! command -v xsel &> /dev/null; then
  echo "Error: xclip or xsel is required but not installed."
  exit 1
fi

# Get clipboard content
if command -v xclip &> /dev/null; then
  CLIPBOARD_CONTENT=$(xclip -selection clipboard -o)
elif command -v xsel &> /dev/null; then
  CLIPBOARD_CONTENT=$(xsel --clipboard --output)
fi

# Check if clipboard is empty
if [ -z "$CLIPBOARD_CONTENT" ]; then
  echo "Error: Clipboard is empty."
  if [ -x "$(command -v notify-send)" ]; then
        notify-send -a HasteIt Logixy "Error: Clipboard is empty."
  fi
  exit 1
fi

# Upload to Hastebin
RESPONSE=$(echo -e "$CLIPBOARD_CONTENT" | curl -s -X POST -H "Content-Type: text/plain" --data-binary @- $HASTE_SERVER/documents)


# Extract the key from the response
KEY=$(echo "$RESPONSE" | jq -r .key)

# Check if the upload was successful
if [ "$KEY" == "null" ]; then
  echo "Error: Failed to upload to Hastebin."
  exit 1
fi

# Construct the Hastebin URL
URL="$HASTE_SERVER/$KEY"

# Copy the URL to the clipboard
if command -v xclip &> /dev/null; then
  echo -n "$URL" | xclip -selection clipboard
elif command -v xsel &> /dev/null; then
  echo -n "$URL" | xsel --clipboard --input
fi

# Output the URL
HURL="Hastebin URL: $URL"
echo $HURL

if [ -x "$(command -v notify-send)" ]; then
        notify-send -a HasteIt Logixy "Saved to clipboard\n$URL"
fi

