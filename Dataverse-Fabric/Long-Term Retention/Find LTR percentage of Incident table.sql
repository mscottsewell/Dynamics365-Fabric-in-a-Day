SELECT
    'dbo' as [Schema],
    'incident' AS [Table],
    COUNT(*) AS Total_Count,
    CAST(1 AS BIT) AS LTR_Enabled,
    ISNULL(SUM(msft_datastate),0) AS LTR_Count
    FROM dbo.incident
    WHERE IsDelete is null