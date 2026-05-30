# Crypto Market Pulse Dashboard

A live data pipeline that pulls 1000 cryptocurrencies from the 
CoinMarketCap API, stores them in a SQL Server data warehouse, 
and visualises key market insights in Excel.

## Tools Used
- Python (requests, pandas, sqlalchemy, dotenv)
- Microsoft SQL Server
- Excel Dashboard
- CoinMarketCap Pro API

## Project Structure
- pipeline/ — Python scripts for fetching and loading data
- sql/ — All SQL views and schema definitions
- screenshots/ — Dashboard previews

## How It Works
1. Run `pipeline/run_pipeline.py` to fetch 1000 coins from CoinMarketCap
2. Data lands in `raw.Crypto_data` in SQL Server
3. 5 analytical views transform the raw data
4. Run `pipeline/export.py` to export views to CSV
5. Open `crypto_dashboard.xlsx` to see the dashboard

## Dashboard Charts
- **Market Dominance** — Which coins control the largest market cap share
- **Top 10 Gainers** — Biggest 24h price increases
- **Top 10 Losers** — Biggest 24h price drops
- **Platform Analysis** — Which blockchains host the most tokens

## Database Schema
Star schema with:
- `raw.Crypto_data` — landing table
- `crypto.dim_crypto_info` — coin identity and metadata
- `crypto.dim_platform_info` — blockchain platform per token
- `crypto.fact_data` — price, volume and market cap metrics
- `crypto.market_dominance` — market cap dominance ranking
- `crypto.gainers_losers` — 24h performance classification

## Screenshots
![Market Dominance](screenshots/market_dominance_chart.png)
![Gainers and Losers](screenshots/gainers_losers_chart.png)
![Platform Analysis](screenshots/platform_analysis_chart.png)
![Dashboard README](screenshots/readme_tab.png)
## Notes
Pipeline is triggered manually by running `run_pipeline.py`.
API key is stored securely in a `.env` file and never committed to GitHub.

## Author
Your Name — Data Analyst
