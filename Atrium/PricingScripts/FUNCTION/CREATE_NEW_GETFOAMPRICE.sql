
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETFOAMPRICE" 
(
  IN_TYPE IN NUMBER 
, IN_EFFECTIVEUNIT IN NUMBER 
, IN_SECTIONS IN NUMBER 
, IN_SERIES IN VARCHAR2
, IN_STYLE IN VARCHAR2
, IN_FOAMID IN OUT NUMBER 
) RETURN NUMBER AS 

lv_price number :=0;
lv_pricetype option_foamwrap.price_type%TYPE;
lv_pricemul option_foamwrap.pricemul%type;
lv_foamwrapid option_foamwrap.ID%type;


BEGIN

  begin

  select price,price_type,pricemul,id  into lv_price,lv_pricetype,lv_pricemul,lv_foamwrapid from
  (select price,price_type,pricemul,id  from  option_foamwrap
  where 
  type= IN_TYPE
  and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
  and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL') order by series,style) x where rownum < 2;

  EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_price :=0;
      lv_foamwrapid :=0;
    end;
  end;  
  
  
 if (lv_price > 0) then 
     if lv_pricemul != '1' then
      lv_price := new_applypricemul(lv_price,lv_pricemul,IN_EFFECTIVEUNIT,IN_SECTIONS);
    end if;
    
   end if ; 

  IN_FOAMID := lv_foamwrapid;
  
  
  RETURN lv_price;
END NEW_GETFOAMPRICE;