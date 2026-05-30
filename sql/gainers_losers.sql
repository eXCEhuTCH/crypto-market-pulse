USE [cryptomarket]
GO

/****** Object:  View [crypto].[gainers_losers]    Script Date: 30/05/2026 8:36:26 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [crypto].[gainers_losers] AS
SELECT
    id                                                          AS coin_id,
    name                                                        AS coin_name,
    symbol                                                      AS ticker,
    cmc_rank                                                    AS market_rank,
    ROUND([quote.USD.price], 6)                                 AS price_usd,
    ROUND([quote.USD.percent_change_1h],  2)                    AS pct_change_1h,
    ROUND([quote.USD.percent_change_24h], 2)                    AS pct_change_24h,
    ROUND([quote.USD.percent_change_7d],  2)                    AS pct_change_7d,
    ROUND([quote.USD.percent_change_30d], 2)                    AS pct_change_30d,
    ROUND([quote.USD.percent_change_60d], 2)                    AS pct_change_60d,
    ROUND([quote.USD.percent_change_90d], 2)                    AS pct_change_90d,
    ROUND([quote.USD.volume_24h], 2)                            AS volume_24h,
    ROUND([quote.USD.market_cap], 2)                            AS market_cap,
    CASE
        WHEN [quote.USD.percent_change_24h] >=  10 THEN 'Major Gainer'
        WHEN [quote.USD.percent_change_24h] >=   3 THEN 'Gainer'
        WHEN [quote.USD.percent_change_24h] <= -10 THEN 'Major Loser'
        WHEN [quote.USD.percent_change_24h] <=  -3 THEN 'Loser'
        ELSE 'Stable'
    END                                                         AS performance_24h_label,
    RANK() OVER (ORDER BY [quote.USD.percent_change_24h] DESC)  AS gainer_rank_24h,
    RANK() OVER (ORDER BY [quote.USD.percent_change_24h] ASC)   AS loser_rank_24h,
    RANK() OVER (ORDER BY [quote.USD.percent_change_7d]  DESC)  AS gainer_rank_7d
FROM raw.Crypto_data
WHERE [quote.USD.price] IS NOT NULL
AND loaded_at = (SELECT MAX(loaded_at) FROM raw.Crypto_data);
GO

