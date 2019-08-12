Select Datepart(HH,'12/12/2014 02:01:00')

SELECT CONVERT(VARCHAR(8),'12/12/2014 02:01:00',108)

select left(cast(dateadd(hh, datediff(hh, 0,GETDATE()), 0) as time), 2) As Hour					
select Right(Left(cast(dateadd(MI, datediff(MI, 0,GETDATE()), 0) as time), 5),2) As Minute		 

Select datediff(hh, 0,'12/12/2014 02:01:00')
Select Left(cast(DATEADD(hh,1007594,0) As Time),2)
Select cast(DATEADD(hh,1007594,0) As Time)

Select datediff(MI, 0,'12/12/2014 02:01:00')
Select Right(Left(cast(DATEADD(MI,60455641,0) As Time),5),2)