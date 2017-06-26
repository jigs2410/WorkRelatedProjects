
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETCOLOR" 
(
 IN_COLOR IN VARCHAR2 
, IN_MULLEDUNITS IN NUMBER
, IN_BASEPRICE IN NUMBER

, IN_EFFECTIVEUNIT IN NUMBER
, IN_SECTIONS IN NUMBER
, IN_STYLE IN VARCHAR2
--, IN_GRIDPATTERN IN VARCHAR2
--, IN_ACCOUNTID IN VARCHAR2 
--, IN_CUSTOMERID IN VARCHAR2 
--, IN_HASGRID IN OUT NUMBER
,IN_COLORID IN OUT NUMBER

) RETURN NUMBER AS 

lv_price option_color.price%type;
lv_pricetype OPTION_COLOR.PRICETYPE%type;
lv_pricemul OPTION_COLOR.PRICEMUL%type;
lv_mulledunits number;

BEGIN

  begin
  
  if (IN_MULLEDUNITS > 1) then
    lv_mulledunits := 2;
  else 
    lv_mulledunits := 1;
  end if ;
  
  select colorID,price ,pricetype,pricemul into IN_COLORID,lv_price,lv_pricetype,lv_pricemul from (
   select colorID,price ,pricetype,pricemul  from  option_color
  where (REGEXP_LIKE (style ,''''||IN_style||'''','i') or style = 'ALL') 
  and sections =IN_SECTIONS
  and mulledunits = lv_mulledunits
  and REGEXP_LIKE (color ,''''||IN_color||'''','i')  order by style ,mulledunits desc ) where rownum < 2;
   EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_price :=0;
    end;
  end;
  
  if (lv_price > 0) then 

     lv_price := new_applypricetype (lv_price,lv_pricetype,1,1,IN_BASEPRICE);
     
    if ( lv_pricemul != '1') then   
     lv_price := new_applypricemul(lv_price,lv_pricemul,IN_EFFECTIVEUNIT,IN_SECTIONS);
    end if;
  end if ;
  
  DBMS_OUTPUT.PUT_LINE('Color price '|| lv_price);
  RETURN lv_price;
END NEW_GETCOLOR;