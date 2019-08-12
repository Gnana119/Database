Create Table SAM_tDelDuplicate
(
PK_ID	Int Identity(1,1),
Emp_ID	Varchar(50),
Empname	Varchar(50)
)

Insert Into SAM_tDelDuplicate Values ('101','Emp1'),('101','Emp1') ,('101','Emp1'),('102','Emp2'),
('102','Emp2'),('102','Emp2'),('103','Emp3'),('103','Emp3'),('103','Emp3')
Select * from SAM_tDelDuplicate
Delete A from SAM_tDelDuplicate A Where PK_ID not in(Select MIN(PK_Id) From SAM_tDelDuplicate B Where A.Emp_ID = B.Emp_ID
Group By B.Emp_ID)

select Emp_ID,MIN(PK_ID) from SAM_tDelDuplicate Group By Emp_ID Having COUNT(*) > 1


With Ordered As
(
	Select * ,ROW_NUMBER() over(partition by CustomerID order By CustomerID) As Rownum
	From Mst_CarrierDetails
)
Delete From Ordered Where Rownum > 1

--Truncate Table Mst_CarrierDetails 


Select * From Mst_CarrierDetails 
Select * From [DW_ProductionOrderDetails]