import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
from datetime import datetime
import os

load_dotenv()

SERVER   = r"EXCEL_HUNTCH\SQLEXPRESS"
DATABASE = "cryptomarket"

CONNECTION_STRING = (
    f"mssql+pyodbc://{SERVER}/{DATABASE}?"
    f"driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"
)

# ── connect ───────────────────────────────────────────
engine = create_engine(CONNECTION_STRING)

# ── output folder ─────────────────────────────────────
output_folder = r"C:\Users\bosur\OneDrive\Desktop\crypto_market_pulse\dashboard"
os.makedirs(output_folder, exist_ok=True)

# ── views to export ───────────────────────────────────
views = {
    "market_dominance" : "SELECT * FROM crypto.market_dominance",
    "gainers_losers"   : "SELECT * FROM crypto.gainers_losers",
    "fact_data"        : "SELECT * FROM crypto.fact_data",
    "dim_crypto_info"  : "SELECT * FROM crypto.dim_crypto_info",
    "dim_platform_info": "SELECT * FROM crypto.dim_platform_info",
}

# ── export each view to CSV ───────────────────────────
print("=" * 50)
print(f"Export started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print("=" * 50)

for view_name, query in views.items():
    print(f"\n  Exporting {view_name}...")
    df = pd.read_sql(query, engine)
    filepath = os.path.join(output_folder, f"{view_name}.csv")
    df.to_csv(filepath, index=False)
    print(f"  {len(df)} rows saved to {view_name}.csv")

print("\n" + "=" * 50)
print("All views exported to dashboard folder.")
print("=" * 50)