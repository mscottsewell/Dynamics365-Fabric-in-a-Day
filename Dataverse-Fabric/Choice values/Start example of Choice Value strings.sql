SELECT  Base.name
      , Base.statuscode
      , Base.industrycode
    FROM account                     AS Base
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