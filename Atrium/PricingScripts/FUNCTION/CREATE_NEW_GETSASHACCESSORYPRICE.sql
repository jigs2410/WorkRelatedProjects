
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETSASHACCESSORYPRICE" 
(
  IN_TYPE IN VARCHAR2 
, IN_CONSTRUCTION IN VARCHAR2 
, IN_STYLE IN VARCHAR2 
, IN_SERIES IN VARCHAR2 
, IN_PART IN NUMBER
, IN_EFFECTIVEUNIT IN VARCHAR2 
, IN_SECTIONS IN VARCHAR2 
, IN_SASHACCESSORYID IN OUT VARCHAR2 
) RETURN NUMBER AS 

lv_price number :=0;
lv_pricetype option_sashaccessory.pricetype%TYPE;
lv_pricemul option_sashaccessory.pricemul%type;
lv_sashaccessoryid option_sashaccessory.ID%type;


BEGIN
  begin
      select * into lv_price,lv_pricetype,lv_pricemul,lv_sashaccessoryid from ( select price,pricetype,pricemul,id  from option_sashaccessory
      where type = IN_TYPE
      and construction = IN_CONSTRUCTION
      and (regexp_like (style,''''||IN_STYLE||'''','i') or style = 'ALL' )
      and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL' )
      and part = IN_PART
      order by style,series) x where rownum < 2;
      
      EXCEPTION WHEN NO_DATA_FOUND THEN
        begin 
          lv_price :=0;
          lv_sashaccessoryid:=0;
        end;
   end ;
  
  if (lv_price > 0) then
    lv_price := new_applypricemul(lv_price,lv_pricemul,IN_EFFECTIVEUNIT,IN_SECTIONS);
  end if;
  
  IN_sashaccessoryID := lv_sashaccessoryid;
  
  RETURN lv_price;
  
END NEW_GETSASHACCESSORYPRICE;