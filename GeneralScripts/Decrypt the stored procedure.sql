create  PROCEDURE sp_decrypt_sp (@objectName varchar(50))
AS
DECLARE  @OrigSpText1 nvarchar(4000),  @OrigSpText2 nvarchar(4000) , @OrigSpText3 nvarchar(4000), @resultsp nvarchar(4000)
declare  @i int , @t bigint , @ct nvarchar(max)
 
--get encrypted data
SET @OrigSpText1= (SELECT top 1 ctext FROM syscomments  WHERE id = object_id(@objectName) order by colid)
SET @OrigSpText2='ALTER PROCEDURE '+ @objectName +' WITH ENCRYPTION AS '+REPLICATE('-', 3938)
EXECUTE (@OrigSpText2)
print @OrigSpText1
 
SET @OrigSpText3=(SELECT top 1 ctext FROM syscomments  WHERE id = object_id(@objectName) order by colid)
SET @OrigSpText2='CREATE PROCEDURE '+ @objectName +' WITH ENCRYPTION AS '+REPLICATE('-', 4000-62)
 
--start counter
SET @i=1
--fill temporary variable
SET @resultsp = replicate(N'A', (datalength(@OrigSpText1) / 2))
 
--loop
WHILE @i<=datalength(@OrigSpText1)/2
BEGIN
--reverse encryption (XOR original+bogus+bogus encrypted)
SET @resultsp = stuff(@resultsp, @i, 1, NCHAR(UNICODE(substring(@OrigSpText1, @i, 1)) ^
                                (UNICODE(substring(@OrigSpText2, @i, 1)) ^
                                UNICODE(substring(@OrigSpText3, @i, 1)))))
print @resultsp
 SET @i=@i+1
END
--drop original SP
--EXECUTE ('drop PROCEDURE '+ @objectName)
--remove encryption
--preserve case
SET @resultsp=REPLACE((@resultsp),'WITH ENCRYPTION', '')
SET @resultsp=REPLACE((@resultsp),'With Encryption', '')
SET @resultsp=REPLACE((@resultsp),'with encryption', '')
IF CHARINDEX('WITH ENCRYPTION',UPPER(@resultsp) )>0 
  SET @resultsp=REPLACE(UPPER(@resultsp),'WITH ENCRYPTION', '')
--replace Stored procedure without enryption
set @ct = (SELECT ctext FROM syscomments WHERE id = object_id(@objectName))
print @ct
execute( @resultsp)
GO
