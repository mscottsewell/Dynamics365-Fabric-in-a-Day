SELECT  Base.name
--      , Base.statuscode
      , [account_statuscode].value AS [Status]
--      , Base.industrycode
      , [account_industrycode].value AS [Industry]
    FROM account                     AS Base

    LEFT JOIN [dbo].[stringmap]      AS [account_statuscode]
        ON  [account_statuscode].langid = 1033
        AND [account_statuscode].objecttypecode = 'account'
        AND [account_statuscode].attributename = 'statuscode'
        AND [account_statuscode].attributevalue = [Base].statuscode

    LEFT JOIN [dbo].[stringmap] AS [account_industrycode]
        ON  [account_industrycode].langid = 1033
        AND [account_industrycode].objecttypecode = 'account'
        AND [account_industrycode].attributename = 'industrycode'
        AND [account_industrycode].attributevalue = [Base].industrycode

    WHERE
        Base.IsDelete IS NULL
        

/*
    LEFT JOIN [dbo].[stringmap] AS [entityname_attributename] 
      ON [entityname_attributename].langid = 1033 
        AND [entityname_attributename].objecttypecode = ''  
        AND [entityname_attributename].attributename = '' 
        AND [entityname_attributename].attributevalue = [Base].choicefieldname 

Guide to using the above snippit: 
    langid 	= the language code of values needed - 1033 = US English 
    objecttypecode 	= entity name 
    attributename 	= choice value field name 
    attributevalue 	= choice numeric value from the record
    choicenamefield = choice value field name 

In the list of fields in the query, just reference it in this form: 
	[entityname_attributename].value AS [My Field Alias]

*/                