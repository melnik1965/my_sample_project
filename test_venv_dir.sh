#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # определяет директорию скрипта автоматически
VENV_DIR="$PROJECT_DIR/venv"
VENV_DIR="${VENV_DIR:-./venv}"  # Если VENV_DIR пуста, используем ./venv
VENV_ACTIVATE="$VENV_DIR/bin/activate"

# Указываем shellcheck, где искать файл активации
# shellcheck source=./venv/bin/activate
if [[ ! -f "$VENV_ACTIVATE" ]]; then
    echo "Создаём виртуальное окружение в $VENV_DIR..."
    python3 -m venv "$VENV_DIR" || {
        echo "Не удалось создать виртуальное окружение" >&2
        exit 1
    }
fi
# Снова указываем shellcheck путь к файлу
if [[ -f "$VENV_ACTIVATE" ]]; then
    # shellcheck disable=SC1090,SC1091
    source "$VENV_ACTIVATE"
    echo "Виртуальное окружение активировано: $VENV_DIR"
else
    echo "Ошибка: файл активации не найден: $VENV_ACTIVATE" >&2
    exit 1
fi
