
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_APPLYPRICETYPE" 
(
  IN_PRICE IN NUMBER 
, IN_PRICETYPE IN VARCHAR2 DEFAULT 1 
, IN_WIDTHES IN NUMBER DEFAULT 1 
, IN_HEIGHTES IN NUMBER DEFAULT 1 
, IN_VARIABLEPRICE NUMBER DEFAULT 1
, IN_LITE NUMBER DEFAULT 1
) RETURN NUMBER AS 
lv_price number := 0;
lv_unitedinches number :=0;

BEGIN
  
  
  lv_unitedinches := IN_WIDTHES + IN_HEIGHTES;
  
  case IN_PRICETYPE 
  when 'UNITEDINCHES' then lv_price:= IN_PRICE * lv_unitedinches;
  when 'FIXED' then lv_price := IN_PRICE;
  when 'DEDUCT' then lv_price := -1 * IN_PRICE;
  when 'PERC_OF_BASE'  then lv_price := IN_VARIABLEPRICE * IN_PRICE/100;
  when 'SQFT'     then lv_price := IN_PRICE * (IN_Widthes *IN_heightes)/144;
  when 'PER_LITE' then lv_price := IN_PRICE * IN_LITE;
  when '6 LITE' then lv_price := IN_PRICE * 6;
  when '9 LITE' then lv_price := IN_PRICE * 9;
  when 'PERC_OPTION' then lv_price := IN_VARIABLEPRICE- ( IN_VARIABLEPRICE * IN_PRICE/100);
  else 
  lv_price := IN_PRICE;
  end case ;
  
  RETURN ROUND (lv_PRICE,3);
END NEW_APPLYPRICETYPE;