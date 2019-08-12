CREATE TABLE Contacts (EmailAddress VARCHAR(100))
INSERT INTO Contacts (EmailAddress)
SELECT 'first,hgd@validemail.com'
UNION ALL
SELECT 'first@validemail'
UNION ALL
SELECT '@validemail.com'
UNION ALL
SELECT 'second@validemail.com'
UNION ALL
SELECT 'firstvalidemail.com'
--Drop Table Contacts
--Declare @Email  Varchar(250)
--Set @Email = 'first@validemail.com'
SELECT EmailAddress AS ValidEmail
FROM Contacts
WHERE EmailAddress   LIKE '%_@__%.__%'
        AND PATINDEX('%[^a-z,0-9,@,.,_,\-]%', EmailAddress)= 0

		Select dbo.udf_ValidateEmail('first,valid@email.com')

Alter FUNCTION udf_ValidateEmail (@email varChar(255))

RETURNS bit
AS
begin
return
(
select 
	Case 
		When 	@Email is null then 0	                	--NULL Email is invalid
		When	charindex(' ', @email) 	<> 0 or		--Check for invalid character
				charindex('/', @email) 	<> 0 or --Check for invalid character
				charindex(',', @email) 	<> 0 or --Check for invalid character
				charindex('#', @email) 	<> 0 or --Check for invalid character
				charindex(':', @email) 	<> 0 or --Check for invalid character
				charindex(';', @email) 	<> 0 then 0 --Check for invalid character
		When len(@Email)-1 <= charindex('.', @Email) then 0--check for '%._' at end of string
		When 	@Email like '%@%@%'or 
				@Email Not Like '%@%.%'  then 0--Check for duplicate @ or invalid format
		Else 1
	END
)
end