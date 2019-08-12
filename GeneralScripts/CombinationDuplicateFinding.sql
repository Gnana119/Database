Select *  from staging. Int_ExtractRelianceSelfRepairUnit where rsn = 'RMPXBLDF0393393'--'RMPXBAEF0257422'


SELECT d.ServceOrder, d.RSN,  CONvert(Date,d.CompletionDate) As CompletionDate
FROM staging. Int_ExtractRelianceSelfRepairUnit d
INNER JOIN (
    SELECT  RSN,  CONvert(Date,CompletionDate) As  CompletionDate
    FROM staging. Int_ExtractRelianceSelfRepairUnit 
    GROUP BY  RSN, CONvert(Date,CompletionDate)
    HAVING COUNT(distinct ServceOrder) > 1
) dup
    ON dup.RSN = d.RSN AND  CONvert(Date,dup.CompletionDate) =  CONvert(Date,d.CompletionDate)



SELECT d.symptom, d.RSN,  CONvert(Date,d.CompletionDate) As CompletionDate
FROM staging. Int_ExtractRelianceSelfRepairUnit d
INNER JOIN (
    SELECT  RSN,  symptom
    FROM staging. Int_ExtractRelianceSelfRepairUnit
    GROUP BY  RSN, symptom
    HAVING COUNT(distinct CONvert(Date,CompletionDate)) > 1
) dup
    ON dup.RSN = d.RSN AND  dup.symptom =  d.symptom

--Select *  from staging. Int_ExtractRelianceSelfRepairUnit where rsn = 'RMPXBLDE0049896'--'RMPXBAEF0257422'
Select *  from Dw_Fact_RelianceSelfRepair where unit_id = 1140444--'RMPXBAEF0257422'
Select *  from Dw_Fact_RelianceSelfRepair where unit_id = 3303191--'RMPXBAEF0257422'

select * from DW_Fact_unit where Unit_id = 1140444 --eg for 2 rows
select * from DW_Fact_unit where Unit_id = 3303191 -- eg for 3 rows

SELECT DW.ServiceOrder, DW.Unit_id ,  CONvert(Date,DW.CompletionDate) As CompletionDate
FROM Dw_Fact_RelianceSelfRepair   DW with (nolock ) 
INNER JOIN (
    SELECT  SDW.Unit_ID As RSN,  CONvert(Date,SDW.CompletionDate) As  CompletionDate
    FROM Dw_Fact_RelianceSelfRepair SDW with (nolock ) 
    GROUP BY  SDW.Unit_ID, CONvert(Date,SDW.CompletionDate)
    HAVING COUNT(distinct SDW.ServiceOrder) > 1
) dup
    ON dup.RSN = DW.Unit_id AND  CONvert(Date,dup.CompletionDate) =  CONvert(Date,DW.CompletionDate) 
	order by unit_id 
	--------------Same device same date and different service order number-------------------------------------
Begin Tran
Go
With CTE_DiffServiceOrder
As
	(
		Select A.* ,row_number() over (partition by  Unit_id, CompletionDate
                                order by Unit_id
                               ) as seqnum
							   from
										(SELECT DW.SelfRepairUnit_Id,DW.ServiceOrder, DW.Unit_id ,  CONvert(Date,DW.CompletionDate) As CompletionDate
													FROM Dw_Fact_RelianceSelfRepair   DW with (nolock ) 
													INNER JOIN (
													SELECT  SDW.Unit_ID As RSN,  CONvert(Date,SDW.CompletionDate) As  CompletionDate
													FROM Dw_Fact_RelianceSelfRepair SDW with (nolock ) 
													GROUP BY  SDW.Unit_ID, CONvert(Date,SDW.CompletionDate)
													HAVING COUNT(distinct SDW.ServiceOrder) > 1
										) dup
										ON dup.RSN = DW.Unit_id AND  CONvert(Date,dup.CompletionDate) =  CONvert(Date,DW.CompletionDate) 
										Where ISNULL(DW.Duplicate_RefID,0) = 0
										) A
	)
	
						Update DWS Set DWS.Duplicate_RefID = A.SelfRepairUnit_Id From  CTE_DiffServiceOrder A INNER JOIN Dw_Fact_RelianceSelfRepair DWS
						ON A.unit_id = DWS.unit_id    and Seqnum = 1

GO
Select * from Dw_Fact_RelianceSelfRepair Where unit_id = '64091'

GO
Rollback Tran

-------------------Same Device and same Symptom with differtent date------------------------------

Begin Tran
Go
With CTE_SameSymptomDiffDate 
As
	(
		Select A.* ,row_number() over (partition by  Unit_id, Symptom
                                order by Unit_id
                               ) as seqnum
							   from
										(SELECT DW.SelfRepairUnit_Id,DW.ServiceOrder, DW.Unit_id ,DW.Symptom ,CONvert(Date,DW.CompletionDate) As CompletionDate
													FROM Dw_Fact_RelianceSelfRepair   DW with (nolock ) 
													INNER JOIN (
																SELECT  SDW.Unit_ID As RSN,  Symptom
																FROM Dw_Fact_RelianceSelfRepair SDW with (nolock ) 
																GROUP BY  SDW.Unit_ID, SDW.Symptom
																HAVING COUNT(distinct CONvert(Date,SDW.CompletionDate)) > 1
																) dup
										ON dup.RSN = DW.Unit_id AND  dup.Symptom =  DW.Symptom 
										) A
	)
Update DWS Set DWS.Duplicate_RefID = A.SelfRepairUnit_Id From  CTE_SameSymptomDiffDate A INNER JOIN Dw_Fact_RelianceSelfRepair DWS
ON A.unit_id = DWS.unit_id    and Seqnum = 1
GO
Select * from Dw_Fact_RelianceSelfRepair 

GO
Rollback Tran


SELECT d.dept, d.role1, d.role2, DEF
FROM data d
INNER JOIN (
    SELECT dept, role1, role2 
    FROM data
    GROUP BY dept, role1, role2
    HAVING COUNT(distinct DEF) > 1
) dup
    ON dup.dept = d.dept AND dup.role1 = d.role1 AND dup.role2 = d.role2
;

with toupdate as (
      select ap.*,
             row_number() over (partition by act, plan, active, date
                                order by id
                               ) as seqnum
      from acct_plan
     )
update toupdate
    set date = getdate(),
        active = 0
    where seqnum > 1;