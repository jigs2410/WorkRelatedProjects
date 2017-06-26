
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_ISSHAPE" 
(
  INSTYLE IN VARCHAR2 
) RETURN NUMBER AS 

i_res number :=0;
BEGIN
  select case 
           when exists(SELECT STYLE
                         FROM PRICINGCUSTOM PS
                        WHERE PS.STYLE=INSTYLE and shape = 1
                        )
           then 1
           else 0
         end  into i_res
  from dual;

  RETURN i_res;
END FUNC_ISSHAPE;