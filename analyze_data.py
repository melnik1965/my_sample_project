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
