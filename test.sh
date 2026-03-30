# определяет директорию скрипта автоматически
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# С использованием readlink (надёжно разрешает символические ссылки):
PROJECT_DIR1=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# Способы отображения переменной 
echo "$PROJECT_DIR"
printf '%s\n' "$PROJECT_DIR"
declare -p PROJECT_DIR
env | grep PROJECT_DIR
if [ -n "$PROJECT_DIR" ]; then
  echo "PROJECT_DIR=$PROJECT_DIR"
else
  echo "Переменная PROJECT_DIR не задана"
fi

echo "$PROJECT_DIR1"
printf '%s\n' "$PROJECT_DIR1"
declare -p PROJECT_DIR1
env | grep PROJECT_DIR1
if [ -n "$PROJECT_DIR1" ]; then
  echo "PROJECT_DIR1=$PROJECT_DIR1"
else
  echo "Переменная PROJECT_DIR1 не задана"
fi