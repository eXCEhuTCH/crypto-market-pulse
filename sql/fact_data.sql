USE [cryptomarket]
GO

/****** Object:  View [crypto].[fact_data]    Script Date: 30/05/2026 8:35:58 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [crypto].[fact_data] AS
SELECT
    id                                                AS coin_id,
    [last_updated]                                    AS snapshot_time,
    loaded_at,
    ROUND([quote.USD.price], 6)                       AS price_usd,
    ROUND([quote.USD.volume_24h], 2)                  AS volume_24h,
    ROUND([quote.USD.cex_volume_24h], 2)              AS cex_volume_24h,
    ROUND([quote.USD.dex_volume_24h], 2)              AS dex_volume_24h,
    ROUND([quote.USD.volume_change_24h], 2)           AS volume_change_24h,
    ROUND([quote.USD.percent_change_1h],  2)          AS pct_change_1h,
    ROUND([quote.USD.percent_change_24h], 2)          AS pct_change_24h,
    ROUND([quote.USD.percent_change_7d],  2)          AS pct_change_7d,
    ROUND([quote.USD.percent_change_30d], 2)          AS pct_change_30d,
    ROUND([quote.USD.percent_change_60d], 2)          AS pct_change_60d,
    ROUND([quote.USD.percent_change_90d], 2)          AS pct_change_90d,
    ROUND([quote.USD.market_cap], 2)                  AS market_cap,
    ROUND([quote.USD.market_cap_dominance], 4)        AS market_cap_dominance,
    ROUND([quote.USD.fully_diluted_market_cap], 2)    AS fully_diluted_market_cap,
    ROUND([quote.USD.tvl], 2)                         AS tvl,
    [tvl_ratio]                                       AS tvl_ratio,
    [circulating_supply]                              AS circulating_supply,
    [total_supply]                                    AS total_supply,
    [max_supply]                                      AS max_supply,
    [minted_market_cap]                               AS minted_market_cap
FROM raw.Crypto_data
WHERE loaded_at = (SELECT MAX(loaded_at) FROM raw.Crypto_data);
GO

