
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_ES_TO_ES_UNIT" 
(
  p_MODEL IN VARCHAR2,
  p_ESSIZE IN VARCHAR2,
  p_TYPE IN NUMBER,
  p_EFFECTIVEUNIT IN number
) RETURN VARCHAR2 AS 
lv_essize number;
lv_esunitsize number := P_ESSIZE; -- JUST SO WE RETURN SAME DATA INSTEAD OF EXCEPTION
lv_wide varchar2(5);
lv_high varchar2(5);

BEGIN
  BEGIN
  select wide_deduct, high_deduct into lv_wide, lv_high from deductions where model_number = p_MODEL and sizing_system='O';
  lv_esunitsize:= (p_ESSIZE + lv_wide)  / p_EFFECTIVEUNIT;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          LV_WIDE:= 0;
        end;
 end; 
  if (p_TYPE=1) then --width, divide and deduct
    lv_essize := lv_esunitsize - lv_wide;
  --elsif (p_TYPE=2) then --height, just deduct
   -- lv_essize := p_ESSIZE - lv_high;
  --elsif (p_TYPE=3) then --stacked units height, divide and deduct
    --lv_essize := lv_esunitsize - lv_high;
  end if;
  RETURN round(lv_essize,3);
END FUNC_ES_TO_ES_UNIT;