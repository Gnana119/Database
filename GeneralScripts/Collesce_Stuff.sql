


--create table #user (username varchar(25))

--insert into #user (username) values ('Paul')
--insert into #user (username) values ('John')
--insert into #user (username) values ('Mary')

declare @tmp varchar(250)
SET @tmp = ''
select @tmp = @tmp + ''''+username +''''+ ', ' from #user 

select SUBSTRING(@tmp, 0, LEN(@tmp))



select
   distinct  
    stuff((
        select ',''' + u.username+''''
        from #user u
        where u.username = username
        order by u.username
        for xml path('')
    ),1,1,'') as userlist
from #user
group by username


	select
								   distinct  
									stuff((
										select ',''' + u.Value+''''
										from #TempFilter u
										where u.AttributeName = AttributeName
										
										order by u.AttributeName
										for xml path('')
									),1,1,'') as Attributelist
								from #TempFilter
								group by AttributeName


declare @tmp varchar(250)
							SET @tmp = ''
							select @tmp = @tmp + ''''+value +''''+ ', ' from #TempFilter 
							select SUBSTRING(@tmp, 0, LEN(@tmp))