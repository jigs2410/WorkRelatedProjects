
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETGRIDPRICE" 
(
 IN_CONSTRUCTION IN VARCHAR2 
--, IN_CATEGORY IN VARCHAR2
--, IN_PART IN NUMBER
, IN_EFFECTIVEUNIT IN NUMBER
, IN_SECTIONS IN NUMBER
, IN_LITES IN NUMBER
, IN_GRIDTYPE IN VARCHAR2
, IN_GRIDSTYLE IN VARCHAR2
, IN_GRIDCOLORIN IN VARCHAR2
, IN_GRIDCOLOROUT IN VARCHAR2
, IN_GRIDPLACEMENT IN VARCHAR2
, IN_GRIDPATTERN IN VARCHAR2
--, IN_ACCOUNTID IN VARCHAR2 
--, IN_CUSTOMERID IN VARCHAR2 
, IN_STYLE IN VARCHAR2
, IN_SHAPES IN NUMBER
, IN_WIDTHES IN NUMBER
, IN_HEIGHTES IN NUMBER
, IN_SAFETY IN VARCHAR2
, IN_BASEPRICE IN NUMBER
, IN_HASGRID IN OUT NUMBER
, IN_GRIDID IN OUT NUMBER
, IN_GRIDPATTERNID IN OUT NUMBER
, IN_GRIDPATTERNPRICE IN OUT NUMBER

) RETURN NUMBER AS 

lv_price number;
lv_pricetype option_grid.pricetype%TYPE;
lv_pricemul option_grid.pricemul%TYPE;
lv_lites number := 0;
lv_gridpatternid number :=0;
lv_gridpatternprice number :=0;
lv_gridpatternpricetype option_grid.pricetype%TYPE;

BEGIN

lv_lites := IN_LITES;
IN_HASGRID :=0;
IN_GRIDPATTERNID :=0;
IN_GRIDPATTERNPRICE :=0;

---Logic
-- 1) Determine if shape (go to step 2) or not (go to step 4)
-- 2) And then get correct record.
-- 3) check if TSO / BSL or gridpattern has 0Hx0V and do 50% of the price.


---

begin 
if (IN_SHAPES = 1) then
  
      lv_price :=0;
      
        select * INTO IN_GRIDID,LV_PRICE , LV_PRICETYPE ,LV_PRICEMUL from (select id, price , pricetype, pricemul from  option_grid
        where regexp_like ( construction,''''||IN_CONSTRUCTION||'''','i') 
        and regexp_like (type,''''||IN_GRIDTYPE||'''','i') 
        and regexp_like (gridstyle,''''||IN_GRIDSTYLE||'''','i') 
        and regexp_like (pattern,''''||IN_GRIDPATTERN||'''','i') 
        and (regexp_like (style,''''||IN_STYLE||'''','i'))
        and shapes = 1 order by style desc)x where rownum < 2;
        
        IN_HASGRID := 1;
        
  else -- not a shape
    begin --1  
       
        select * INTO IN_GRIDID,LV_PRICE , LV_PRICETYPE ,LV_PRICEMUL from (select id, price , pricetype, pricemul from  option_grid
        where regexp_like ( construction,''''||IN_CONSTRUCTION||'''','i') 
        and regexp_like (type,''''||IN_GRIDTYPE||'''','i') 
        and regexp_like (gridstyle,''''||IN_GRIDSTYLE||'''','i') 
        and (regexp_like (style,''''||IN_STYLE||'''','i') or style = 'ALL')
        and (regexp_like  (gridcolorout,''''||IN_GRIDCOLOROUT||'''','i') or gridcolorout = 'ALL')
        and regexp_like (gridplacement,''''||IN_GRIDPLACEMENT||'''','i') 
        and (regexp_like (safety,''''||IN_SAFETY||'''','i') or safety = 'ALL')
        and shapes = 0 order by style,gridcolorout,safety )x where rownum < 2;
      
      --- EXCEPTION :- for this grid style only we compute base price as if it has grid for other grid styles we compute as non grid base price .
      -- if (IN_GRIDSTYLE not in ('Diamond','DIAMOND','Prairie','PRAIRIE','Perimeter','PERIMETER','SDL','7/8') ) then
       if (IN_GRIDSTYLE in ('Colonial','Contour','Contour Valance','COLONIAL','CONTOUR','CONTOUR VALANCE')) then
        IN_HASGRID := 1;
       end if; 
        
    end; --1
    
end if;

      EXCEPTION WHEN NO_DATA_FOUND THEN
      BEGIN
        LV_PRICE :=0;
        LV_PRICETYPE:=0;
        LV_PRICEMUL :=0;
        IN_HASGRID :=0;   
        IN_GRIDID := 0;
      END ;
      
   end ;
      
      
        --- get the price
        if (lv_price > 0)  then
                lv_price := new_applypricetype(lv_price,lv_pricetype,IN_WIDTHES,IN_HEIGHTES,IN_BASEPRICE,IN_LITES);
                if lv_pricemul != '1' then
                  lv_price := new_applypricemul(lv_price,lv_pricemul,IN_EFFECTIVEUNIT,IN_SECTIONS);
                end if;
                 --- now see if its a TSO or has OHxOV grid pattern
                 
                 if (IN_SHAPES = 0) then --tso bso etc applies only 
                    begin 
                      select id,price,pricetype into lv_gridpatternid, lv_gridpatternprice, lv_gridpatternpricetype from option_grid 
                      where regexp_like ( construction,''''||IN_CONSTRUCTION||'''','i')
                      and regexp_like (gridstyle,''''||IN_GRIDSTYLE||'''','i') 
                      and regexp_like (pattern,''''||IN_GRIDPATTERN||'''','i') ;
                      
                     
                        
                      if (lv_gridpatternprice > 0) then
                        lv_gridpatternprice := new_applypricetype(lv_gridpatternprice,lv_gridpatternpricetype,IN_WIDTHES,IN_HEIGHTES,lv_price,IN_LITES);
                        IN_GRIDPATTERNPRICE := lv_gridpatternprice;
                        IN_GRIDpatternID := lv_gridpatternid;
                       end if ;
                      
                      
                        EXCEPTION WHEN NO_DATA_FOUND THEN
                        BEGIN
                          LV_gridpatternPRICE :=0;
                          LV_gridpatternPRICETYPE:=0;
                          lv_GRIDpatternID := 0;
                          IN_gridpatternPRICE :=0;
                          IN_GRIDpatternID := 0;
                        END ;
                        
                    end;   
                end if; -- IN_SHApES
          end if ; --lv_price >0

---Just get grid price for now and they   figure out effective unit etc...
  RETURN LV_PRICE;
END NEW_GETGRIDPRICE;