#!/bin/bash

# Проверяем, доступен ли xsel
if ! command -v xsel &> /dev/null; then
  echo "xsel не установлен. Установите его для работы скрипта."
  if [ -x "$(command -v notify-send)" ]; then
    notify-send -a TempshIt FileUploader "Please, install xsel"
  fi
  exit 1
fi

# Получаем содержимое буфера обмена
CLIPBOARD_CONTENT=$(xsel --clipboard)

# Проверяем, является ли содержимое буфера путем к файлу
if [[ -f $(echo "$CLIPBOARD_CONTENT" | sed 's|file://||') ]]; then
  # Удаляем file:// из пути
  CLEAN_PATH=$(echo "$CLIPBOARD_CONTENT" | sed 's|file://||')
  FILE_TO_UPLOAD="$CLEAN_PATH"
else
  # Если это не путь, создаем временный текстовый файл
  TEMP_FILE=$(mktemp --suffix=.txt)
  echo "$CLIPBOARD_CONTENT" > "$TEMP_FILE"
  FILE_TO_UPLOAD="$TEMP_FILE"
fi

# Загружаем файл на temp.sh
RESULT_URL=$(curl -F "file=@$FILE_TO_UPLOAD" https://temp.sh/upload)

# Copy the URL to the clipboard
if command -v xclip &> /dev/null; then
  echo -n "$RESULT_URL" | xclip -selection clipboard
elif command -v xsel &> /dev/null; then
  echo -n "$RESULT_URL" | xsel --clipboard --input
fi

if [ -x "$(command -v notify-send)" ]; then
    notify-send -a TempshIt FileUploader "Saved to clipboard\n$RESULT_URL"
fi

