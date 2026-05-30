USE [cryptomarket]
GO

/****** Object:  View [crypto].[market_dominance]    Script Date: 30/05/2026 8:36:51 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [crypto].[market_dominance] AS
WITH total_market AS (
    SELECT SUM([quote.USD.market_cap]) AS total_market_cap
    FROM raw.Crypto_data
    WHERE [quote.USD.market_cap] IS NOT NULL
    AND loaded_at = (SELECT MAX(loaded_at) FROM raw.Crypto_data)
),
market_dominance AS (
    SELECT
        r.id                                                           AS coin_id,
        r.name                                                         AS coin_name,
        r.symbol                                                       AS ticker,
        r.slug                                                         AS url_slug,
        r.cmc_rank                                                     AS market_rank,
        ROUND([quote.USD.market_cap], 2)                               AS market_cap,
        ROUND([quote.USD.market_cap_dominance], 4)                     AS reported_dominance_pct,
        ROUND(([quote.USD.market_cap] / t.total_market_cap) * 100, 4) AS calculated_dominance_pct,
        RANK() OVER (ORDER BY [quote.USD.market_cap] DESC)             AS market_cap_rank
    FROM raw.Crypto_data AS r
    CROSS JOIN total_market AS t
    WHERE [quote.USD.market_cap] IS NOT NULL
    AND loaded_at = (SELECT MAX(loaded_at) FROM raw.Crypto_data)
)
SELECT * FROM market_dominance;
GO

