CREATE FUNCTION dbo.rudfGetTableFromCSV ( @Value VARCHAR(4000) )

RETURNS @ValuesTable TABLE

   (

    Value VARCHAR(4000)

   )

AS

BEGIN

   DECLARE 	@Tally 	TABLE ([ID] SMALLINT )

   DECLARE	@i 	SMALLINT

   

   SET @i=0

   WHILE @i < 1000 

   BEGIN

	INSERT @Tally VALUES( @i)

	SET @i = @i + 1

   END



   INSERT @ValuesTable

	SELECT RTrim(LTrim(SUBSTRING(',' + @Value + ',' , ID , 

	CHARINDEX(',' , ',' + @Value + ',' , ID) - ID))) AS Word 

	FROM @Tally

	WHERE ID <= LEN(',' + @Value + ',') 

	AND SUBSTRING(',' + @Value + ',' , ID - 1, 1) = ','

   RETURN

END
