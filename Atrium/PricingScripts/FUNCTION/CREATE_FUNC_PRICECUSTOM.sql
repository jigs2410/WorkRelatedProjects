
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_PRICECUSTOM" 
(
  IN_MODEL IN VARCHAR2,
  IN_STYLE IN VARCHAR2 
, IN_PATTERN IN VARCHAR2 
, IN_RETPRICE IN NUMBER
, IN_RETSDLPRICE IN NUMBER
, IN_CUSTOMTYPE IN VARCHAR2
) RETURN NUMBER AS 

lv_price number :=0;
lv_liteprice number :=0;
iscolor number :=0;
doorpanel number :=0;

BEGIN

  if ((IN_CUSTOMTYPE = 'GRIDPATTERN') OR (IN_CUSTOMTYPE = 'SCREEN')) then
  begin
    select price, case when bent=0 then lites * 18 when bent =1 then lites * 45 end as liteprice into lv_price,lv_liteprice 
    from pricingcustom where style =IN_STYLE and type = in_customtype and  value = in_pattern ;
     EXCEPTION
          WHEN NO_DATA_FOUND THEN
          begin
           lv_price :=0;
            lv_liteprice :=0;
          end;
   end;
   
     if (in_retsdlprice = 1) then
    return lv_liteprice;
    else 
    return lv_price;
   end if ;
   
  end if;

    
 if (IN_CUSTOMTYPE = 'INTERIORLAMINATE' OR IN_CUSTOMTYPE = 'EXTERIORPAINT') then
  begin
     select count(*) into iscolor from pricingcustom where type = IN_CUSTOMTYPE and value =in_pattern;
     EXCEPTION
          WHEN NO_DATA_FOUND THEN
          begin
          iscolor :=0;
          end;
   end;
   
    return iscolor;

  end if;  


 if (IN_CUSTOMTYPE = 'DOORPANEL' ) then
  begin
     select value into doorpanel from pricingcustom where type = IN_CUSTOMTYPE and model =IN_MODEL;
     EXCEPTION
          WHEN NO_DATA_FOUND THEN
          begin
          doorpanel :=0;
          end;
   end;
   
    return doorpanel;

  end if;  

  

  
END FUNC_PRICECUSTOM;