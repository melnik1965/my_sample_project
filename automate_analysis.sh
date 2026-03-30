#!/bin/bash

# Скрипт для автоматизации:
# 1. установки окружения,
# 2. загрузки данных и
# 3. запуска Python‑аналитики
# Автор: Студент УИИ Мельничук Ю.А.

TODAY=$(date +%Y-%m-%d)
echo "Сегодня: $TODAY"

set -e  # Прерывать выполнение при любой ошибке
# 1. Установка окружения
# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { 
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() { 
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() { 
    echo -e "${RED}[ERROR]${NC} $1"
}

# Конфигурация
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # определяет директорию скрипта автоматически
VENV_DIR="$PROJECT_DIR/venv"
DATA_DIR="$PROJECT_DIR/data"
PYTHON_SCRIPT="$PROJECT_DIR/analyze_data.py"
# CSV_FILE="$DATA_DIR/dataset.csv"  # Файл данных

# Зависимости Python
REQUIREMENTS=(
    "pandas"
    "numpy"
    "matplotlib"
    "seaborn"
)

# Функция установки окружения
setup_environment() {
    log_info "Установка виртуального окружения..."

    if [ ! -d "$VENV_DIR" ]; then # Если venv отсутствует
        python3 -m venv "$VENV_DIR" || {
            log_error "Не удалось создать виртуальное окружение"
            exit 1
        }
        log_info "Виртуальное окружение создано в $VENV_DIR"
    else
        log_warn "Виртуальное окружение уже существует"
    fi

    # Активируем виртуальное окружение
    VENV_DIR="${VENV_DIR:-./venv}"  # Если VENV_DIR пуста, используем ./venv
    source "$VENV_DIR/bin/activate"

    log_info "Обновление pip..."
    pip install --upgrade pip || {
        log_error "Ошибка обновления pip3"
        exit 1
    }

    log_info "Установка Python=зависимостей..."
    for package in "${REQUIREMENTS[@]}"; do
        pip install "$package" || {
            log_error "Ошибка установки $package"
            exit 1
        }
    done
    log_info "Все зависимости установлены"
}

# 2. Загрузка данных
# Функция загрузки данных
download_data() {
    # Проверяем, есть ли уже данные
    if [ -f "$DATA_DIR/dataset.csv" ]; then
        log_warn "Файл данных уже существует, пропускаем загрузку"
        return 0
    fi
    log_info "Загрузка данных из $DATA_URL..."

    mkdir -p "$DATA_DIR"

    # Пробуем разные способы загрузки
    if command -v wget &> /dev/null; then
        wget -O "$DATA_DIR/dataset.csv" "$DATA_URL" || {
            log_error "Ошибка загрузки через wget"
            return 1
        }
    elif command -v curl &> /dev/null; then
        curl -o "$DATA_DIR/dataset.csv" "$DATA_URL" || {
            log_error "Ошибка загрузки через curl"
            return 1
        }
    else
        log_error "Не найдены утилиты wget или curl для загрузки данных"
        return 1
    fi

    log_info "Данные успешно загружены в $DATA_DIR/dataset.csv"
}

# Функция запуска аналитического скрипта
run_analysis() {
    log_info "Запуск аналитического скрипта $PYTHON_SCRIPT..."

    if [ ! -f "$PYTHON_SCRIPT" ]; then
        log_error "Аналитический скрипт не найден: $PYTHON_SCRIPT"
        log_info "Создаём шаблон скрипта..."
        cat > "$PYTHON_SCRIPT" << 'EOF'
#!/venv/bin python3
import pandas as pd
import sys

def main():
    print("Запуск анализа данных...")
    try:
        # Загружаем данные
        df = pd.read_csv('data/dataset.csv')
        print(f"Загружено {len(df)} строк данных")
        print("\nОсновные статистики:")
        print(df.describe())
        print("\nАнализ завершён успешно!")

    except Exception as e:
        print(f"Ошибка при анализе: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF
        log_info "Шаблон скрипта создан"
    fi

    # Запускаем скрипт
    python "$PYTHON_SCRIPT" || {
        log_error "Ошибка выполнения аналитического скрипта"
        exit 1
    }
    log_info "Анализ успешно завершён"
}

# Основная функция
main() {
    log_info "Начало выполнения автоматизации..."

    setup_environment
    download_data
    run_analysis

    log_info "Автоматизация завершена успешно!"
}

# Обработчик прерывания
trap 'log_error "Скрипт прерван пользователем"; exit 1' INT TERM

# Запуск основной функции
main "$@"
