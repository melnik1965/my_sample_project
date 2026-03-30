import pandas as pd
import requests
from io import StringIO

url = 'https://raw.githubusercontent.com/Aurindom/Bulldozer-price-Prediction/main/.csv%20files/TrainAndValid.csv'

try:
    response = requests.get(url, stream=True)
    response.raise_for_status()  # Проверка HTTP‑статуса

    # Читаем файл по частям, чтобы избежать проблем с памятью
    chunks = []
    for chunk in response.iter_lines(decode_unicode=True):
        chunks.append(chunk)


    # Объединяем и парсим CSV
    csv_data = '\n'.join(chunks)
    df = pd.read_csv(StringIO(csv_data))
    print(f"Загружено {len(df)} строк данных")
    print(df)
except Exception as e:
    print(f"Ошибка загрузки: {e}")
