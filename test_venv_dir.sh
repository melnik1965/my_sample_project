#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # определяет директорию скрипта автоматически
VENV_DIR="$PROJECT_DIR/venv"
VENV_DIR="${VENV_DIR:-./venv}"  # Если VENV_DIR пуста, используем ./venv

echo "$VENV_DIR"

VENV_DIR=""

VENV_DIR="${VENV_DIR:-./venv}"  # Если VENV_DIR пуста, используем ./venv

echo "$VENV_DIR"