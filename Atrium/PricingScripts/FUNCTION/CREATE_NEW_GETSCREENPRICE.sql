
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETSCREENPRICE" 
(
  IN_SCREENTYPE IN VARCHAR2 
, IN_EFFECTIVEUNIT IN NUMBER
, IN_SECTIONS IN NUMBER
, IN_CONSTRUCTIONCODE IN VARCHAR2
, IN_SERIES IN VARCHAR2
, IN_STYLE IN VARCHAR2
, IN_SCREENID IN OUT NUMBER
, IN_TOTALPERC IN OUT NUMBER
) RETURN NUMBER AS 

lv_price number :=0;
lv_pricetype option_screen.price_type%TYPE;
lv_pricemul option_screen.pricemul%type;
lv_section option_screen.sections%type ;
lv_screenid option_screen.ID%TYPE;
lv_screentype option_screen.screen%TYPE;

--changes
-- 1/21  :- c1:-  removed classification based on sections instead used stylecode. 



BEGIN
  
  IN_TOTALPERC :=0;
  --if sections >=3 has same price
  if (IN_SECTIONS >= 3) then lv_section :=3 ;
  else lv_section := 2; end if;
  
  -- make different version of fixed glass value to be standard.
  if (IN_SCREENTYPE like 'FIXED%') then 
  lv_screentype := 'FIXED GLASS ONLY';
  else
  lv_screentype := IN_SCREENTYPE;
  end if;
  
  
begin
  select * into lv_price,lv_pricetype,lv_pricemul,lv_screenid from ( select price,price_type,pricemul,id  from option_screen 
  where regexp_like (constructioncode,''''||IN_constructioncode||'''','i')
 -- and (sections = lv_section or sections = 0) -- c1
  and regexp_like (screen,''''||lv_screentype||'''','i') 
  and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
  and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL')  order by series,style) x where rownum < 2;
  
  EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_price :=0;
      IN_SCREENID :=0;
    end;
  end;  
  
   
    if (lv_price > 0) then 
     
     if lv_pricemul != '1' then
      lv_price := new_applypricemul(lv_price,lv_pricemul,IN_EFFECTIVEUNIT,IN_SECTIONS);
    end if;
    
    if (lv_pricetype = 'TOTALPERC') then
     IN_TOTALPERC:= lv_price;
     else 
      IN_TOTALPERC:= 0;
     end if; 
   end if ; 

 IN_SCREENID :=lv_screenid;
 
  RETURN lv_price;
  
END NEW_GETSCREENPRICE;