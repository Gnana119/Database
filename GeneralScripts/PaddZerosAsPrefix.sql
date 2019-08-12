Select 'PRO' + Replicate(0,6-LEN(Right(34 +  4, 6)) )+CONVERT(Varchar(100),94)

DECLARE @myInt INT = 1;
PRINT FORMAT(@myInt,'00#');

declare @x     int     = 123 -- value to be padded
declare @width int     = 25  -- desired width
declare @pad   char(1) = '0' -- pad character

select right_justified = replicate(
                           @pad ,
                           @width-len(convert(varchar(100),@x))
                           )
                       + convert(varchar(100),@x)



					   