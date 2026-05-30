import requests
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
from datetime import datetime
import os

load_dotenv()

URL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"

HEADERS = {
    "Accepts": "application/json",
    "X-CMC_PRO_API_KEY": os.getenv("CMC_API_KEY"),
}

SERVER   = r"EXCEL_HUNTCH\SQLEXPRESS"
DATABASE = "cryptomarket"

CONNECTION_STRING = (
    f"mssql+pyodbc://{SERVER}/{DATABASE}?"
    f"driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"
)

DROP_COLS = [
    "platform",
    "quote.USD.last_updated",
    "self_reported_circulating_supply",
    "self_reported_market_cap",
]

print("=" * 50)
print(f"Pipeline started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print("=" * 50)

print("\n[1/3] Fetching data from CoinMarketCap...")
all_batches = []

for start_row in range(1, 1000, 100):
    print(f"  Fetching rows {start_row} to {start_row + 99}...")
    params = {
        "start": str(start_row),
        "limit": "100",
        "convert": "USD",
    }
    response = requests.get(URL, headers=HEADERS, params=params)

    if response.status_code != 200:
        print(f"  ERROR at batch {start_row}: {response.status_code}")
        print(f"  {response.json().get('status', {}).get('error_message', 'Unknown error')}")
        break

    data = response.json()
    df_batch = pd.json_normalize(data["data"])
    all_batches.append(df_batch)

if not all_batches:
    print("No data fetched. Exiting.")
    exit()

print("\n[2/3] Cleaning data...")
df = pd.concat(all_batches, ignore_index=True)
df = df.drop(columns=DROP_COLS, errors="ignore")
df["loaded_at"] = datetime.now()
df["tags"] = df["tags"] . astype(str)  # Convert list to string for SQL storage
print(f"  {len(df)} coins fetched and cleaned.")
print(f"  Columns loaded: {len(df.columns)}")

print("\n[3/3] Loading into SQL Server...")
try:
    engine = create_engine(CONNECTION_STRING)
    df.to_sql(
        name      = "Crypto_data",
        con       = engine,
        if_exists = "append",
        index     = False,
        schema    = "raw"
    )
    print(f"  {len(df)} rows loaded into raw.Crypto_data successfully.")

except Exception as e:
    print(f"  SQL ERROR: {e}")

print("\n" + "=" * 50)
print(f"Pipeline finished: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print("All done. Open SQL Server to query your views.")
print("=" * 50)