Select * from Sys.types
Select * from Sys.Objects
Select * from Sys.indexes
Select * from Sys.index_columns
Select COL_NAME(3,3)
Select Object_name(3)


Select [RowLog Contents 0] FROM   sys.fn_dblog(NULL, NULL) WHERE  AllocUnitName = 'dbo.DW_Dim_Station'
        AND Context IN ( 'LCX_MARK_AS_GHOST', 'LCX_HEAP' )        AND Operation in ( 'LOP_DELETE_ROWS' )
        
Select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
Select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE  
        
        SELECT KU.table_name as tablename,column_name as primarykeycolumn
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
INNER JOIN
INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND
TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME

ORDER BY KU.TABLE_NAME, KU.ORDINAL_POSITION;

Select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
Select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
