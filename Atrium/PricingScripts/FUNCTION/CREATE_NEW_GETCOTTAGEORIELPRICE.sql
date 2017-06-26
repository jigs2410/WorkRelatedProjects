
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETCOTTAGEORIELPRICE" 
(
  IN_TYPE IN VARCHAR2 
, IN_CONSTRUCTIONCODE IN VARCHAR2 
, IN_CLMR IN VARCHAR2 
, IN_EFFECTIVEUNIT IN VARCHAR2 
, IN_SECTIONS IN VARCHAR2 
, IN_COTTAGEORIELID IN OUT NUMBER
) RETURN NUMBER AS 

lv_price number :=0;
lv_pricetype option_cottageoriel.price_type%TYPE;
lv_pricemul option_cottageoriel.price_mul%type;
lv_cottageorielid option_cottageoriel.ID%type;

BEGIN


begin
  select price,price_type,price_mul,id  into lv_price,lv_pricetype,lv_pricemul,lv_cottageorielid from  option_cottageoriel
  where 
  constructioncode= IN_constructioncode
  and regexp_like (type,''''||IN_TYPE||'''','i')
  and clmr = IN_CLMR;

  
  
  EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_price :=0;
      lv_cottageorielid :=0;
    end;
  end;  
  
  
 if (lv_price > 0) then 
     if lv_pricemul != '1' then
      lv_price := new_applypricemul(lv_price,lv_pricemul,IN_EFFECTIVEUNIT,IN_SECTIONS);
    end if;
   end if ; 

  IN_COTTAGEORIELID := lv_cottageorielid;
  RETURN lv_price;
  
  
END NEW_GETCOTTAGEORIELPRICE;