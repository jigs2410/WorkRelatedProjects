
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETSCREENMESHPRICE" 
(
  IN_SCREENMESH IN VARCHAR2 
, IN_EFFECTIVEUNIT IN NUMBER 
, IN_SECTIONS IN NUMBER 
, IN_CONSTRUCTIONCODE IN VARCHAR2
, IN_SERIES IN VARCHAR2
, IN_STYLE IN VARCHAR2
, IN_SCREENTYPE IN VARCHAR2 
, IN_PART IN VARCHAR2 
, IN_SCREENMESHID IN OUT VARCHAR2 
) RETURN NUMBER AS 


lv_price number :=0;
lv_pricetype option_screenmesh.price_type%TYPE;
lv_pricemul option_screenmesh.pricemul%type;
lv_section option_screenmesh.sections%type ;
lv_screenmeshid option_screenmesh.ID%TYPE;
lv_screentype option_screenmesh.screentype%TYPE;



BEGIN
  lv_screenmeshid :=0;

   if (IN_SECTIONS >= 3) then lv_section :=3 ;
  else lv_section := 2; end if;
  
  begin
  select * into lv_price,lv_pricetype,lv_pricemul,lv_screenmeshid from ( select price,price_type,pricemul,id  from option_screenmesh 
  where regexp_like (constructioncode,''''||IN_constructioncode||'''','i')
  and sections = lv_section 
  and regexp_like (screenmesh,''''||IN_SCREENMESH||'''','i') 
  and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
  and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL')  
  and part = IN_PART
  and (regexp_like (screentype,''''||IN_SCREENTYPE||'''','i') or screentype = 'ALL')
  order by series,style desc) x where rownum < 2;
  
  IN_SCREENMESHID :=lv_screenmeshid;
  
  EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_price :=0;
      IN_SCREENMESHID :=0;
    end;
  end;  
  
     if (lv_price > 0) then 
     if lv_pricemul != '1' then
      lv_price := new_applypricemul(lv_price,lv_pricemul,IN_EFFECTIVEUNIT,IN_SECTIONS);
    end if;
   end if ; 

 
 
 
  
  RETURN lv_price;
END NEW_GETSCREENMESHPRICE;