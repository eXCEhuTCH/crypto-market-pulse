USE [cryptomarket]
GO

/****** Object:  View [crypto].[dim_platform_info]    Script Date: 30/05/2026 8:35:30 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [crypto].[dim_platform_info] AS
SELECT
    id                                          AS coin_id,
    [platform.id]                               AS platform_id,
    ISNULL(CAST([platform.id] AS VARCHAR),'Native')  AS platform_type,
    ISNULL([platform.name],   'Native chain')   AS platform_name,
    ISNULL([platform.slug],   'native')         AS platform_slug,
    ISNULL([platform.symbol], 'N/A')            AS platform_symbol,
    ISNULL([platform.token_address], 'N/A')     AS platform_token_address
FROM raw.Crypto_data
WHERE loaded_at = (SELECT MAX(loaded_at) FROM raw.Crypto_data);
GO

