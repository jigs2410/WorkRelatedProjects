
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETDRYWALLPRICE" 
(
  IN_STYLE IN VARCHAR2 
, IN_FRAMECOLOR IN VARCHAR2 
, IN_EFFECTIVEUNIT IN NUMBER 
, IN_SECTIONS IN NUMBER 
, IN_DRYWALLID IN OUT NUMBER 
) RETURN NUMBER AS 

lv_price number :=0;
lv_pricetype option_drywall.pricetype%TYPE;
lv_pricemul option_drywall.pricemul%type;
lv_drywallid option_drywall.ID%type;


BEGIN

begin
  select * into lv_price,lv_pricetype,lv_pricemul,lv_drywallid from ( select price,pricetype,pricemul,id  from option_drywall
  where regexp_like (style,''''||IN_STYLE||'''','i') 
  and (regexp_like (framecolor,''''||IN_FRAMECOLOR||'''','i') )
  order by style) x where rownum < 2;
  
  EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_price :=0;
      lv_drywallid:=0;
    end;
  end;  
  
  IN_DRYWALLID := lv_drywallid;
  
  RETURN lv_price;
END NEW_GETDRYWALLPRICE;