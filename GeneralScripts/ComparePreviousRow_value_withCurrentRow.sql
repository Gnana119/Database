--Select * from UserActivity
-----------till SQL Server 2018 R2 --------------------
;with  UserActivitySplit (rownumber,[user],activity,activitytime,activitydate)
AS
(
Select ROW_NUMBER() OVER (Order by [user],activitytime) As RowNumber
,[user]
,Activity
,ActivityTime
,CAST(Activitytime as date) activitydate
From UserActivity
)
SELECT
		logon."user" As UserID
		,Logon.activity
		,Logon.activitydate
		,Logoff.activitytime as logofftime
		,logon.activitytime as LoginTime
		,Datediff(minute,logoff.activitytime,logon.activitytime) As IdelTime

FROM
(Select * from UserActivitySplit where activity = 'LogON') As LogOn
INNER JOIN (Select * from Useractivitysplit where activity = 'LogOff') As LogOff 
ON	logon."user" = logoff."user" 
AND	logon.activitydate = logoff.activitydate
and logoff.rownumber = logon.rownumber-1

----------------------------SQL Server 2012 and above------------------------
SELECT *,
IdelTime = 
CASE Activity WHEN 'LogOn' THEN 
			DATEDIFF(minute,LAG(activitytime,1) OVER (Order BY "user",activitytime),ActivityTime)
			ELSE 
			NULL
			END
FROM 
useractivity 


;With LAGOptionUserActivities
As
(
Select Activity,
CAST(Activitytime as date) as Activitydate,
		"user" as LogOnUser
		,LAG("user",1) over(order by "user",activitytime) As LogoffUser
		,activitytime as LogOnActivityTime
		,LAG(activitytime,1) over(Order By "user",ActivityTime) As LogOffActivityTime
		,CAST(ActivityTime As Date) As LogOnActivityDate
		,CAST(LAG(activitytime,1) Over(Order By "user",ActivityTime) As Date) As LogOffActivityDate
FROM 
UserActivity
)
Select 
		Activity
		,logonuser
		,Activitydate
		,LogOnActivityTime
		,LogOffActivityTime
		,DATEDIFF(minute,LogOffActivityTime,LogOnActivityTime) As Ideltime
FROM LAGOptionUserActivities
Where	Activity = 'LogOn'
AND		LogOffActivityTime is not null
and		LogOffActivityDate	=	LogOnActivityDate
and		LogoffUser	=	LogOnUser