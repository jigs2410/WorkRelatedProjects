
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETSEATPRICE" 
(

  IN_SEAT IN VARCHAR2 
, IN_EFFECTIVEUNIT IN NUMBER
, IN_SECTIONS IN NUMBER
, IN_CONSTRUCTIONCODE IN VARCHAR2
, IN_FRAMECOLORIN IN VARCHAR2
, IN_SERIES IN VARCHAR2
, IN_STYLE IN VARCHAR2

, IN_SEATID IN OUT NUMBER
)

RETURN NUMBER AS 

lv_price number :=0;
lv_pricetype option_seat.price_type%TYPE;
lv_pricemul option_seat.pricemul%type;
lv_seatid option_seat.ID%TYPE;


BEGIN

begin
  select * into lv_price,lv_pricetype,lv_pricemul,lv_seatid from ( select price,price_type,pricemul,id  from option_seat
  where regexp_like (constructioncode,''''||IN_constructioncode||'''','i')
  and regexp_like (seat,''''||IN_SEAT||'''','i') 
  and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
  and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL')  
  and (regexp_like (framecolorin,''''||IN_FRAMECOLORIN||'''','i') or framecolorin = 'ALL')
  order by series,style) x where rownum < 2;
  
  EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_price :=0;
      lv_seatid:=0;
    end;
  end;  
  
  IN_SEATID := lv_seatid;
  
  RETURN lv_price;
END NEW_GETSEATPRICE;