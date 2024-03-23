DECLARE @sql nvarchar(MAX)
SELECT
    @sql = COALESCE(@sql + ' UNION ALL ', '') +
        'SELECT
            ''' + s.name + ''' AS ''Schema'',
            ''' + t.name + ''' AS ''Table'',
            COUNT(*) AS Total_Count,
            CAST(0 AS BIT) AS LTR_Enabled,
            SUM(0) AS LTR_Count
            FROM ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) 
        + ' WHERE IsDelete is null'
        + ' HAVING COUNT(*) > 1000'
    FROM sys.schemas s
    JOIN sys.tables t ON t.schema_id = s.schema_id
    LEFT JOIN sys.columns c ON c.object_id = t.object_id and c.name = 'msft_datastate'
    JOIN sys.columns d ON d.object_id = t.object_id and d.name = 'IsDelete'
    WHERE c.object_id IS NULL
    ORDER BY
        s.name,
        t.name
SELECT
    @sql = COALESCE(@sql + ' UNION ALL ', '') +
        'SELECT
            ''' + s.name + ''' AS ''Schema'',
            ''' + t.name + ''' AS ''Table'',
            COUNT(*) AS Total_Count,
            CAST(1 AS BIT) AS LTR_Enabled,
            ISNULL(SUM(msft_datastate),0) AS LTR_Count
            FROM ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) 
            + ' WHERE IsDelete is null'
    FROM sys.schemas s
    JOIN sys.tables t ON t.schema_id = s.schema_id
    LEFT JOIN sys.columns c ON c.object_id = t.object_id and c.name = 'msft_datastate'
    JOIN sys.columns d ON d.object_id = t.object_id and d.name = 'IsDelete'
    WHERE c.object_id IS NOT NULL
    ORDER BY
        s.name,
        t.name
EXEC(@sql)
