USE [cryptomarket]
GO

/****** Object:  View [crypto].[dim_crypto_info]    Script Date: 30/05/2026 8:34:08 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [crypto].[dim_crypto_info] AS
SELECT
    id                                AS coin_id,
    name                              AS coin_name,
    symbol                            AS ticker,
    slug                              AS url_slug,
    cmc_rank                          AS market_rank,
    CAST(date_added AS DATE)          AS listed_date,
    num_market_pairs                  AS market_pairs,
    tags                              AS tags,
    CASE
        WHEN infinite_supply = 1 THEN 'Unlimited'
        ELSE 'Capped'
    END                               AS supply_type
FROM raw.Crypto_data
WHERE loaded_at = (SELECT MAX(loaded_at) FROM raw.Crypto_data);
GO

