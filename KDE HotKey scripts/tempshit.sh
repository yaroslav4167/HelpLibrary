#!/bin/bash

# Проверяем, используется ли Wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  # Проверяем, установлен ли wl-paste
  if ! command -v wl-paste &> /dev/null; then
    echo "wl-paste не установлен. Установите его для работы скрипта."
    if [ -x "$(command -v notify-send)" ]; then
      notify-send -a TempshIt FileUploader "Please, install wl-clipboard"
    fi
    exit 1
  fi

  # Получаем содержимое буфера обмена с помощью wl-paste

  CLIPBOARD_CONTENT=$(wl-paste)
  # Декодируем URL
  CLIPBOARD_CONTENT=$(echo -e "$(echo "$CLIPBOARD_CONTENT" | sed 'y/+/ /; s/%/\\x/g')")
  echo "Содержимое буфера обмена (Wayland): $CLIPBOARD_CONTENT"
else
  # Проверяем, установлен ли xsel
  if ! command -v xsel &> /dev/null; then
    echo "xsel не установлен. Установите его для работы скрипта."
    if [ -x "$(command -v notify-send)" ]; then
      notify-send -a TempshIt FileUploader "Please, install xsel"
    fi
    exit 1
  fi

  # Получаем содержимое буфера обмена с помощью xsel
  CLIPBOARD_CONTENT=$(xsel --clipboard)
  echo "Содержимое буфера обмена (X11): $CLIPBOARD_CONTENT"
fi

if [ -x "$(command -v notify-send)" ]; then
      notify-send -a TempshIt FileUploader "Загрузка $CLIPBOARD_CONTENT..."
    fi

# Проверяем, является ли содержимое буфера путем к файлу
if [[ "$CLIPBOARD_CONTENT" =~ ^file:// ]]; then
  # Удаляем file:// из пути
  CLEAN_PATH=$(echo "$CLIPBOARD_CONTENT" | sed -e 's|file://||' -e 's|\r||g')
  FILE_TO_UPLOAD="$CLEAN_PATH"
  echo $FILE_TO_UPLOAD
else
  # Если это не путь, создаем временный текстовый файл
  TEMP_FILE=$(mktemp --suffix=.txt)
  echo "$CLIPBOARD_CONTENT" > "$TEMP_FILE"
  FILE_TO_UPLOAD="$TEMP_FILE"
fi

# Загружаем файл на temp.sh
RESULT_URL=$(curl -F "file=@$FILE_TO_UPLOAD" https://temp.sh/upload)

# Copy the URL to the clipboard
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  if command -v wl-copy &> /dev/null; then
    echo -n "$RESULT_URL" | wl-copy
  fi
else
  if command -v xclip &> /dev/null; then
    echo -n "$RESULT_URL" | xclip -selection clipboard
  elif command -v xsel &> /dev/null; then
    echo -n "$RESULT_URL" | xsel --clipboard --input
  fi
fi

if [ -x "$(command -v notify-send)" ]; then
    notify-send -a TempshIt FileUploader "Saved to clipboard\n$RESULT_URL"
fi

