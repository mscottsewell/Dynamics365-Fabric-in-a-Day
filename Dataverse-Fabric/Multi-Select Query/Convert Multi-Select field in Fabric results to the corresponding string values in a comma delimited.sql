
-- I created a multi-select option set field in on the contact entity to serve as an example. 
-- I want to use this field in my report, but the endpoint only returns a ';'-delimited list of numeric values.
-- I need to convert these numeric values to their corresponding string values.
-- Update the query to concatenate these strings with commas back into a single field.
-- Format the query as a CTE and join the results back to the contact entity to get the contact name.
--
-- The multi-select option set field is called pbi_channelactivities and is on the contact entity.
SELECT  Base.contactid
      , Base.pbi_channelactivities
    FROM contact AS Base
    WHERE
        Base.pbi_channelactivities IS NOT NULL;
/*
contactid	                            pbi_channelactivities
5a92810e-1f51-ee11-be6d-6045bd009e0b	4202;4212;10420
683a4130-1f51-ee11-be6d-6045bd009e0b	4210;4212;10422
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4201;4202;4210;4212;4214;4216;10086;10410;10420;10422;10523;10540;10803;10995;10996
76e60efe-1e51-ee11-be6d-6045bd009e0b	4210
b690810e-1f51-ee11-be6d-6045bd009e0b	10540;10995;10996
*/


--
-- Step 1: Split the concatenated list of numeric choices into individual values using string_split.
--
SELECT  Base.contactid
      , string.value
    FROM [dbo].[contact]                                        AS Base
    CROSS APPLY string_split (Base.pbi_channelactivities , ';') AS string
    WHERE
        Base.pbi_channelactivities IS NOT NULL;
/*
The above step results in the following output:
contactid	                            value
5a92810e-1f51-ee11-be6d-6045bd009e0b	4202
5a92810e-1f51-ee11-be6d-6045bd009e0b	4212
5a92810e-1f51-ee11-be6d-6045bd009e0b	10420
683a4130-1f51-ee11-be6d-6045bd009e0b	4210
683a4130-1f51-ee11-be6d-6045bd009e0b	4212
683a4130-1f51-ee11-be6d-6045bd009e0b	10422
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4201
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4202
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4210
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4212
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4214
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4216
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10086
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10410
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10420
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10422
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10523
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10540
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10803
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10995
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10996
76e60efe-1e51-ee11-be6d-6045bd009e0b	4210
b690810e-1f51-ee11-be6d-6045bd009e0b	10540
b690810e-1f51-ee11-be6d-6045bd009e0b	10995
b690810e-1f51-ee11-be6d-6045bd009e0b	10996
*/


--
--Step 2: Join the string values to the stringmap table to get the corresponding string values.
--
SELECT  Base.contactid
      , string.value
      , contact_channelactivity.value                           AS channelactivities_string
    FROM [dbo].[contact]                                        AS Base
    CROSS APPLY string_split (Base.pbi_channelactivities , ';') AS string
    JOIN stringmap contact_channelactivity
        ON  contact_channelactivity.attributename = 'pbi_channelactivities'
        AND contact_channelactivity.objecttypecode = 'contact'
        AND contact_channelactivity.langid = 1033
        AND contact_channelactivity.attributevalue = string.value
    WHERE
        Base.pbi_channelactivities IS NOT NULL;
/*
The above step results in the following output:
contactid	                            value	channelactivities_string
5a92810e-1f51-ee11-be6d-6045bd009e0b	4202	Email
5a92810e-1f51-ee11-be6d-6045bd009e0b	4212	Task
5a92810e-1f51-ee11-be6d-6045bd009e0b	10420	Customer Voice survey invite
683a4130-1f51-ee11-be6d-6045bd009e0b	4210	Phone Call
683a4130-1f51-ee11-be6d-6045bd009e0b	4212	Task
683a4130-1f51-ee11-be6d-6045bd009e0b	10422	Customer Voice survey response
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4201	Appointment
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4202	Email
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4210	Phone Call
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4212	Task
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4214	Service Activity
6c7f810e-1f51-ee11-be6d-6045bd009e0b	4216	Social Activity
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10086	Teams chat
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10410	Customer Voice alert
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10420	Customer Voice survey invite
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10422	Customer Voice survey response
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10523	Conversation
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10540	Session
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10803	Copilot Transcript
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10995	Invite Redemption
6c7f810e-1f51-ee11-be6d-6045bd009e0b	10996	Portal Comment
76e60efe-1e51-ee11-be6d-6045bd009e0b	4210	Phone Call
b690810e-1f51-ee11-be6d-6045bd009e0b	10540	Session
b690810e-1f51-ee11-be6d-6045bd009e0b	10995	Invite Redemption
b690810e-1f51-ee11-be6d-6045bd009e0b	10996	Portal Comment
*/


--
-- Step 3: Aggregate the string values into a single string for each contact.
--
SELECT  Base.contactid
      , STRING_AGG(contact_channelactivity.value, ', ')         AS channelactivities_string
    FROM [dbo].[contact]                                        AS Base
    CROSS APPLY string_split (Base.pbi_channelactivities , ';') AS string
    JOIN stringmap contact_channelactivity
        ON  contact_channelactivity.attributename = 'pbi_channelactivities'
        AND contact_channelactivity.objecttypecode = 'contact'
        AND contact_channelactivity.langid = 1033
        AND contact_channelactivity.attributevalue = string.value
    WHERE
        Base.pbi_channelactivities IS NOT NULL
    GROUP BY
        Base.contactid;
/*
The above step results in the following output:
contactid	                            channelactivities_string
5a92810e-1f51-ee11-be6d-6045bd009e0b	Email, Task, Customer Voice survey invite
683a4130-1f51-ee11-be6d-6045bd009e0b	Phone Call, Task, Customer Voice survey response
6c7f810e-1f51-ee11-be6d-6045bd009e0b	Appointment, Email, Phone Call, Task, Service Activity, Social Activity, Teams chat, Customer Voice alert, Customer Voice survey invite, Customer Voice survey response, Conversation, Session, Copilot Transcript, Invite Redemption, Portal Comment
76e60efe-1e51-ee11-be6d-6045bd009e0b	Phone Call
b690810e-1f51-ee11-be6d-6045bd009e0b	Session, Invite Redemption, Portal Comment
*/


--
--STEP 4: Format the previous query as a CTE 
--Join the results back to the contact entity to get the contact name.
--(This pattern can be re-used multiple times to convert all needed multi-select option set field to their corresponding string values.)
--
WITH CTE_contact_channelactivity AS
        (
            SELECT  Base.contactid
                  , STRING_AGG(contact_channelactivity.value, ', ')         AS channelactivities_string
                FROM [dbo].[contact]                                        AS Base
                CROSS APPLY string_split (Base.pbi_channelactivities , ';') AS string
                JOIN stringmap contact_channelactivity
                    ON  contact_channelactivity.attributename = 'pbi_channelactivities'
                    AND contact_channelactivity.objecttypecode = 'contact'
                    AND contact_channelactivity.langid = 1033
                    AND contact_channelactivity.attributevalue = string.value
                WHERE
                    Base.pbi_channelactivities IS NOT NULL
                GROUP BY
                    Base.contactid )
SELECT  Base.contactid
      , Base.fullname                                        AS [Contact Name]
      , CTE_contact_channelactivity.channelactivities_string AS [Channel Activities]
    FROM [dbo].[contact]                                     AS Base
    JOIN CTE_contact_channelactivity
        ON  CTE_contact_channelactivity.contactid = Base.contactid
    WHERE
        Base.pbi_channelactivities IS NOT NULL;

/*
The above step results in the following output:
contactid	                            Contact Name	Channel Activities
5a92810e-1f51-ee11-be6d-6045bd009e0b	Aaron Alexander	Email, Task, Customer Voice survey invite
683a4130-1f51-ee11-be6d-6045bd009e0b	Aaron Adams	    Phone Call, Task, Customer Voice survey response
6c7f810e-1f51-ee11-be6d-6045bd009e0b	Aaron Baker	    Appointment, Email, Phone Call, Task, Service Activity, Social Activity, Teams chat, Customer Voice alert, Customer Voice survey invite, Customer Voice survey response, Conversation, Session, Copilot Transcript, Invite Redemption, Portal Comment
76e60efe-1e51-ee11-be6d-6045bd009e0b	Aaron Bryant	Phone Call
b690810e-1f51-ee11-be6d-6045bd009e0b	Aaron Allen	    Session, Invite Redemption, Portal Comment
*/        