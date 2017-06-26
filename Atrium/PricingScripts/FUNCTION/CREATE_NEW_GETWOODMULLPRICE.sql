
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETWOODMULLPRICE" 
(
  IN_WOOD_MULL IN VARCHAR2 
, IN_STYLE IN VARCHAR2 
, IN_SHAPES IN NUMBER 
, IN_TOTALUNITS IN NUMBER
, IN_MULLEDUNITS IN NUMBER 
, IN_EFFECTIVEUNIT IN NUMBER 
, IN_STDSIZE IN NUMBER 
, IN_WOOD_MULLID IN OUT NUMBER
) RETURN NUMBER AS 
lv_price number :=0;
LV_CUSTOMADDON NUMBER :=0;

BEGIN
---Logic is based on effectiveunit in a window.
--for eg mulledunits = 1 , item = Cont. TW then it should get effeciveunit_2 price
--for eg mulleunits = 2 , items = SH & TR then it should get SH -> effectunit = 1 & TR -> effectunit = 1, total effectunit = 2 sp get unit_2 price and then divide and multiply by effect unit for each unit call.
-- for eg eg mulleunits = 2 , items = Cont TW & TR then it should get Cont TW -> effectunit = 2 & TR -> effectunit = 1, total effectunit = 3 sp get unit_3 price and then divide and multiply by effect unit for each unit call.


  begin
  
        if (IN_MULLEDUNITS > 1) then 
--            begin
            select * into IN_WOOD_MULLID,lv_price from (select ID, case 
                        when IN_TOTALUNITS =1 then unit_1 -- if two same styles are mulled than total unit is 1 so we need to consider mulled units.
                        when IN_TOTALUNITS =2 then unit_2
                        when IN_TOTALUNITS =3 then unit_3
                        when IN_TOTALUNITS =4 then unit_4
                        when IN_TOTALUNITS =5 then unit_5
                        when IN_TOTALUNITS =6 then unit_6
                        end  from OPTION_WOOD_MULL
                    where regexp_like (woodsurr_mulltype , ''''||IN_WOOD_MULL||'''','i')
                    and (REGEXP_LIKE (style ,''''||IN_STYLE||'''','i') or style = 'ALL')
                    and shapes =IN_SHAPES and stdsize =1 order by style) x where  rownum < 2;
--              Exception when  no_data_found then
--            begin 
--              lv_price := 0;
--            end;
--          end;
        else 
         --begin 
          select * into IN_WOOD_MULLID,lv_price from (select ID, case 
                      when IN_EFFECTIVEUNIT =1 or IN_EFFECTIVEUNIT =0 then unit_1
                      when IN_EFFECTIVEUNIT =2 then unit_2
                      when IN_EFFECTIVEUNIT =3 then unit_3
                      when IN_EFFECTIVEUNIT =4 then unit_4
                      when IN_EFFECTIVEUNIT =5 then unit_5
                      when IN_EFFECTIVEUNIT =6 then unit_6
                      end  from OPTION_WOOD_MULL
                  where regexp_like (woodsurr_mulltype , ''''||IN_WOOD_MULL||'''','i')
                  and (REGEXP_LIKE (style ,''''||IN_STYLE||'''','i') or style = 'ALL')
                  and shapes =IN_SHAPES and stdsize =1 order by style) x where  rownum < 2;
--            Exception when  no_data_found then
--          begin 
--            lv_price := 0;
--          end;
         -- end;
        end if;
       Exception when  no_data_found then
          begin 
            lv_price := 0;
          end;
  end ;

  if (lv_price > 0) then
    if (IN_MULLEDUNITS >1) then
      lv_price := lv_price/IN_TOTALUNITS * IN_EFFECTIVEUNIT ;
    --else 
      --lv_price := lv_price/IN_MULLEDUNITS ;
    end if;
  end if;

--custom size u add 20$ additional per effective unit
  if (IN_STDSIZE != 1) and (lv_price >0 ) then
    BEGIN 
       
       SELECT UNIT_1  INTO LV_CUSTOMADDON FROM (SELECT UNIT_1 from OPTION_WOOD_MULL
        where regexp_like (woodsurr_mulltype , ''''||IN_WOOD_MULL||'''','i')
        and (REGEXP_LIKE (style ,''''||IN_STYLE||'''','i') or style = 'ALL')
        AND SHAPES = IN_SHAPES AND STDSIZE = 0 ORDER BY STYLE ) X WHERE ROWNUM < 2;
        Exception when  no_data_found then
        begin 
          lv_CUSTOMADDON := 0;
        end;
  
    END;
    
    IF (LV_CUSTOMADDON >0) THEN 
      lv_price := lv_price +  LV_CUSTOMADDON;
    END IF;
    
  end if ;

--DBMS_OUTPUT.PUT_LINE('WOOD_MULL PRICE IS ' || lv_price);
  RETURN round(lv_price,2);
END NEW_GETWOODMULLPRICE;