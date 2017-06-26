
  CREATE OR REPLACE EDITIONABLE PACKAGE "MSSQL"."NEW_PRICING" AS

  G_UNITID NUMBER ;
  G_ITEMID NUMBER ;
  G_ORDERID NUMBER ;
  G_MODEL l2_unit.model%TYPE;
  G_series l2_unit.series%TYPE;
  G_style  l2_unit.style%TYPE; 
  

--accountid,customerid--
lv_accountid Ordermaster.accountid%Type;
lv_customerid Ordermaster.customerid%Type;
lv_gbwselected Ordermaster.gbwselected%type;

--- size params ---
lv_model              l2_unit.model%TYPE;
lv_series             l2_unit.series%TYPE;
lv_style              l2_unit.style%TYPE; 
lv_widthes            l2_unit.widthes%TYPE;
lv_heightes           l2_unit.heightes%TYPE;
lv_cottageoriel       l2_unit.cottageoriel%TYpe;
lv_clmr               l2_unit.clmr%Type;
lv_panetype           l2_unit.pane_type%TYPE;
lv_hardwareaccessory  l2_unit.hardwareaccessory%TYPE;
lv_egress             l2_unit.egress%type;
lv_linetypeid         l2_unit.LINETYPEID%TYPE;
lv_smr                l2_unit.smr%TYPE;
lv_tripleeyebrow      number := 0;
lv_nfrc               l2_unit.northern_energy_star%type;

--L1_Item
lv_construction  L1_ITEM.CONSTRUCTION%TYPE;
lv_rendercode    L1_ITEM.RENDERCODE%TYPE;
lv_woodsurround  L1_ITEM.WOODSURROUND%TYPE;
lv_linenumber    L1_ITEM.LINENUMBER%TYPE;
lv_seat          L1_ITEM.SEAT%TYPE;
lv_foamwrap      L1_ITEM.FOAMWRAP%TYPE;
lv_gridplacement L1_ITEM.GRIDPLACEMENT%TYPE;
lv_fins          L1_ITEM.FINS%TYPE;
lv_configuration  L1_ITEM.CONFIGURATION%TYPE;
   


--STYLE
lv_category       STYLE.CATEGORY%TYPE;
lv_part           STYLE.PART%TYPE;
lv_effectiveunit  STYLE.ORCL_EFFECT_UNIT%TYPE;


--CONFIGURATIONS
lv_lowercount CONFIGURATIONS.LOWERCOUNT%TYPE;
lv_uppercount CONFIGURATIONS.UPPERCOUNT%TYPE;

--L5_glass
lv_tintin         l5_glass.tintin%type;
lv_energy         l5_glass.energy%type;
lv_safety         l5_glass.safetyin%type;
lv_gridtype       l5_glass.gridtypein%type;
lv_gridstyle      L5_GLASS.GRIDSTYLE%type;
lv_gridpattern    L5_GLASS.GRIDPATTERN%type;
lv_spacertype     L5_GLASS.SPACERTYPE%type;
lv_gridcolorin    L5_GLASS.GRIDCOLORIN%type;
lv_gridcolorout   L5_GLASS.GRIDCOLOROUT%TYPE;
lv_breathertube   L5_GLASS.BREATHERTUBE%TYPE;

--L3_FRAME--
lv_frameid        L3_FRAME.frameid%TYPE;
lv_framecolorin   L3_FRAME.FRAMECOLORIN%TYPE;

--L3_MULL
lv_mulltype       L3_MULL.MULLTYPE%TYPE;


--L3_SCREEN
lv_screentype     L3_SCREEN.SCREENTYPE%TYPE;
lv_screenmeshtype L3_SCREEN.SCREENMESHTYPE%TYPE;


--L3_Hardware

lv_hardwaretype   l3_hardware.hardwaretype%type;
lv_hardwarecolor  l3_hardware.hardwarecolor%type;
lv_sashaccessory  l3_hardware.sashaccessorytype%type;

-- L4_SASH---
lv_sashid l4_Sash.sashid%type;



lv_lites number :=0;
lv_sash number :=0;
lv_doorpanel number :=0;
lv_doorid number :=0;
lv_doorenergy number :=0;
lv_doorenergy_pricetype varchar2(20) :='';
lv_doortint number:=0;
lv_doortint_pricetype varchar2(20) :='';

lv_panels_clear number := 0;
lv_panels_withgrid number :=0;
lv_panels_pricetype varchar2(50) :='';


--NEW_PRICINGSIZE_EXACT


---PRICING PARAMETERS
lv_baseprice number:=0;
lv_gridprice number:=0;

lv_glassprice number:=0;
lv_tintprice number;
lv_energyprice number;
lv_safetyprice number;
lv_breathertubeprice number :=0;

lv_colorprice number :=0;
lv_wood_mullprice number :=0;

lv_screenprice number :=0;
lv_screenmeshprice number :=0;
lv_seatprice number:=0;
lv_cottageorielprice number := 0;
lv_foamwrapprice number :=0;
lv_spacerprice number:=0;
lv_lockprice number:=0;

lv_hardwareprice number:=0;

lv_hardwaretype_colorprice number :=0;
lv_hardwareaccessoryprice number :=0;
lv_hardwareegressprice number :=0;

LV_WOODCUSTOMADDON NUMBER :=0;


lv_sashaccessoryprice number :=0;
lv_drywallprice number :=0;
lv_smrprice number :=0;

lv_warrantyprice number :=0;
lv_finprice number :=0;
lv_high_performanceprice number :=0;
lv_hingedeductprice number :=0;

lv_atriumprice number :=0;
lv_finalprice number :=0;

lv_totalperc number :=0; ---this for total deduct only applicatble for FGO/TOP SASH ONLY etc



-- OTHER VARIABLES
lv_stdsize NUMBER :=0;
lv_hasgrid NUMBER :=0;
lv_newgridupcharge number :=0;
lv_gridstdsize varchar(20) :='';
lv_mulledunits number :=0;
lv_totalunits number :=0; -- mulled units may have more than 2 effective unit items eg CTTW & TR will be 2 mulled units but total of 3 effective unit.
lv_sections number  :=0;
lv_isshape number :=0;
lv_screendeduct number :=0;

--Log variables
lv_sizeid number :=0;
lv_sizetype varchar(250) :='';
--lv_gridid number :=0;
lv_tintid number :=0;
lv_energyid number :=0;
lv_safetyid number :=0;
--lv_colorid number :=0;
--lv_wood_mullid number :=0;
lv_screenid number :=0;

lv_hardwareid number:=0;
lv_hardwareaccessoryid number:=0;
lv_hardwareegressid number :=0;
lv_sashaccessoryid number :=0;

lv_gridpatternid number:=0;
lv_gridpatternprice number:=0;

lv_count number :=0;

lv_ruleid number :=0;

----
lv_colorpricetype OPTION_COLOR.PRICETYPE%type;
lv_gridpricetype option_grid.pricetype%TYPE;
lv_gridpatternpricetype option_grid.pricetype%TYPE;
lv_gridcolorpricetype option_grid.pricetype%TYPE;
lv_gridcolorprice number :=0;

---Exceptions

--lv_exvalue      NEW_EXCEPTIONDESC.VALUE%TYPE;
lv_exapplyon    NEW_EXCEPTIONDESC.APPLYON%TYPE;
lv_exdescid     NEW_EXCEPTIONDESC.ID%TYPE;


lv_exvariable1  NEW_EXCEPTIONDESC.VARIABLE1%TYPE;
lv_exoperator1  NEW_EXCEPTIONDESC.OPERATOR1%TYPE;
lv_exvalue1     NEW_EXCEPTIONDESC.VALUE1%TYPE;
lv_exoperator2  NEW_EXCEPTIONDESC.OPERATOR2%TYPE;
lv_exvariable2  NEW_EXCEPTIONDESC.VARIABLE2%TYPE;
lv_exvalue2     NEW_EXCEPTIONDESC.VALUE2%TYPE;

lv_exvariable3  NEW_EXCEPTIONDESC.VARIABLE3%TYPE;
lv_exoperator3  NEW_EXCEPTIONDESC.OPERATOR3%TYPE;
lv_exvalue3     NEW_EXCEPTIONDESC.VALUE3%TYPE;

lv_exvariable4  NEW_EXCEPTIONDESC.VARIABLE4%TYPE;
lv_exoperator4  NEW_EXCEPTIONDESC.OPERATOR4%TYPE;
lv_exvalue4     NEW_EXCEPTIONDESC.VALUE4%TYPE;

lv_exvariable5  NEW_EXCEPTIONDESC.VARIABLE5%TYPE;
lv_exoperator5  NEW_EXCEPTIONDESC.OPERATOR5%TYPE;
lv_exvalue5     NEW_EXCEPTIONDESC.VALUE5%TYPE;


lv_exassignid      NEW_EXCEPTIONS.ID%TYPE;
lv_exdiscounttype  NEW_EXCEPTIONS.DISCOUNTTYPE%TYPE;
lv_exdiscountvalue NEW_EXCEPTIONS.DiscountValue%TYPE;

lv_appliedon   new_pricenexceptlog.appliedon%TYPE;

lv_exprice number :=0;
lv_exOrigPrice number :=0;
lv_lognexcept number :=0;
lv_ex_sizeid number :=0; 

lv_otherid number :=0;

lv_stopprocessing number :=0 ; -- dont process any further. (at this point using in doors in case its top/bottom or fixd glass only doors has constant price irrespective of options)

FUNCTION GETPRICE (IN_UNITID IN NUMBER , IN_ITEMID IN NUMBER , IN_ORDERID IN NUMBER, OUT_WARRPRICE OUT NUMBER , OUT_PRICE OUT NUMBER  ) return number;

--FUNCTION  FUNC_GETLITES  RETURN NUMBER;
--
--PROCEDURE PROC_WRITETOPRICINGLOG (IN_APPLIEDON IN VARCHAR2, IN_OPTIONTABLEID IN NUMBER, IN_PRICE IN NUMBER , IN_SIZETYPE IN VARCHAR2 DEFAULT '');
--
--PROCEDURE  PROC_WRITEEXCEPTIONLOG ( IN_ASSIGNID IN NUMBER , IN_DESCID IN NUMBER , IN_DISCOUNTTYPE IN VARCHAR2 , IN_DISCOUNTVALUE IN NUMBER, IN_APPLIEDON IN VARCHAR2, IN_INITIALVALUE IN NUMBER, IN_EXCEPTVALUE IN NUMBER );
--
--FUNCTION NEW_GETGLASSPRICE RETURN NUMBER;
--
--FUNCTION NEW_APPLYPRICETYPE (IN_PRICE IN NUMBER,IN_PRICETYPE IN VARCHAR2 DEFAULT 1 , IN_WIDTHES IN NUMBER DEFAULT 1 , IN_HEIGHTES IN NUMBER DEFAULT 1 , IN_VARIABLEPRICE NUMBER DEFAULT 1, IN_LITE NUMBER DEFAULT 1) RETURN NUMBER ;
--
--FUNCTION NEW_APPLYPRICEMUL (IN_PRICE IN NUMBER , IN_PRICEMUL IN VARCHAR2 DEFAULT 1 , IN_LITES IN NUMBER DEFAULT 1 ) RETURN NUMBER;
--
--FUNCTION NEW_GETGRIDPRICE RETURN NUMBER;
--
--FUNCTION NEW_GETBASEPRICE (IN_WIDTHES IN NUMBER ,IN_HEIGHTES IN NUMBER)RETURN NUMBER;
--
--FUNCTION  FUNC_ES_TO_ES_UNIT (p_ESSIZE IN VARCHAR2,p_TYPE IN NUMBER,p_EFFECTIVEUNIT IN number) RETURN VARCHAR2;
--
--FUNCTION NEW_GETCOLOR(IN_MULLEDUNITS IN NUMBER)RETURN NUMBER;
--
--FUNCTION NEW_GETWOODMULLPRICE( IN_WOOD_MULL IN VARCHAR2) RETURN NUMBER;
-- 
--FUNCTION  NEW_GETSEATPRICE RETURN NUMBER;
--
--FUNCTION  NEW_GETSCREENMESHPRICE(IN_SECTIONS IN NUMBER ) RETURN NUMBER ;
--
--FUNCTION NEW_GETCOTTAGEORIELPRICE RETURN NUMBER;
--
--FUNCTION NEW_GETFOAMPRICE RETURN NUMBER;
--
--FUNCTION  NEW_GETHARDWAREPRICE (IN_SECTIONS IN NUMBER ) RETURN NUMBER ;
--
--FUNCTION NEW_GETDRYWALLPRICE RETURN NUMBER;
--
--FUNCTION NEW_GETSASHACCESSORYPRICE RETURN NUMBER;
--
--FUNCTION  NEW_GETSCREENPRICE (IN_SECTIONS IN NUMBER ) RETURN NUMBER ;
--
--FUNCTION NEW_PROCESSEXCEPTIONS RETURN NUMBER;
--
--FUNCTION  NEW_APPLYEXCEPTION(IN_PRICE IN NUMBER, IN_DISCOUNTTYPE IN VARCHAR2 , IN_DISCOUNTVALUE IN NUMBER ) RETURN NUMBER;
--
----THIS function is copy of getbase price except it just pick based on exceptionid.
--FUNCTION NEW_EXCEPTION_GETBASEPRICE (IN_WIDTHES IN NUMBER ,IN_HEIGHTES IN NUMBER, EXCEPTION_ID IN NUMBER)RETURN NUMBER;
--
--FUNCTION NEW_EXCEPTION_EVALUATE (IN_VARIABLE IN VARCHAR2,IN_OPERATOR IN VARCHAR2 , IN_VALUE IN VARCHAR2 )RETURN NUMBER;
--
--FUNCTION NEW_OPERATORS(IN_VAL1 IN VARCHAR2,IN_OPERATOR IN VARCHAR2,IN_VAL2 IN VARCHAR2) RETURN NUMBER;

--FUNCTION  "NEW_GETPRICE11" (IN_UNITID IN NUMBER , IN_ITEMID IN NUMBER , IN_ORDERID IN NUMBER ) RETURN NUMBER;

--PROCEDURE PROC_WRITETOPRICINGLOG ( IN_ORDERID IN NUMBER, IN_ITEMID IN NUMBER , IN_UNITID IN NUMBER, IN_LINENUMBER IN NUMBER, IN_LINETYPEID IN NUMBER, IN_LOGNEXCEPT IN NUMBER, IN_APPLIEDON IN VARCHAR2, IN_OPTIONTABLEID IN NUMBER
--, IN_PRICE IN NUMBER , IN_STDSIZE IN NUMBER DEFAULT 0, IN_ISSHAPE IN NUMBER DEFAULT 0, IN_HASGRID IN NUMBER DEFAULT 0, IN_SCREENDEDUCT IN NUMBER DEFAULT 0, IN_ISPART IN NUMBER DEFAULT 0, IN_SIZETYPE IN VARCHAR2 DEFAULT ''
--, IN_WIDTH  IN NUMBER DEFAULT 0, IN_HEIGHT  IN NUMBER DEFAULT 0, IN_MULLEDUNITS  IN NUMBER DEFAULT 0, IN_EFFECTIVEUNIT  IN NUMBER DEFAULT 0, IN_SECTIONS  IN NUMBER DEFAULT 0);

--FUNCTION NEW_GETGLASSPRICE
--( IN_TINT IN VARCHAR2 , IN_ENERGY IN VARCHAR2, IN_SAFETY IN VARCHAR2, IN_SERIES IN VARCHAR2, IN_STYLE IN VARCHAR2, IN_WIDTHES IN NUMBER, IN_HEIGHTES IN NUMBER, IN_EFFECTIVEUNIT IN NUMBER, IN_SHAPE IN VARCHAR2, IN_NFRC IN NUMBER
--, IN_TINTPRICE   IN OUT NUMBER, IN_ENERGYPRICE IN OUT NUMBER, IN_SAFETYPRICE IN OUT NUMBER, IN_TINTID IN OUT NUMBER, IN_ENERGYID IN OUT NUMBER, IN_SAFETYID IN OUT NUMBER) RETURN NUMBER;


END NEW_PRICING;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "MSSQL"."NEW_PRICING" AS
  
  FUNCTION OPERATORS
  (
  IN_VAL1 IN VARCHAR2,
  IN_OPERATOR IN VARCHAR2,
  IN_VAL2 IN VARCHAR2
  )
  
  RETURN NUMBER AS
  
  lv_return number := 0;
  Begin
  
  case trim(IN_OPERATOR)
  
    when '=' then 
        if (in_val1 = in_val2 ) then 
             lv_return := 1;
        end if;
        
    when '>=' then 
        if (to_number(in_val1) >= to_number(in_val2) ) then 
             lv_return := 1;
        end if;
    
    when '<=' then 
        if (to_number(in_val1) <= to_number(in_val2) ) then 
             lv_return := 1;
        end if;    
   
    when '!=' then 
        if (in_val1 != in_val2 ) then 
             lv_return := 1;
        end if;    
   
     when 'IN' then 
     --eg select case when regexp_like ('''Obscure'',''Clear/Obscure''','''obscure''','i') then 1 else 0 end   from dual; --val2 would be list of parameter supplied wherease val1 would only 1.
        select case when regexp_like (in_val2,''''||in_val1||'''','i') then 1 else 0 end into lv_return from dual;
  --      if (in_val1 in in_val2 ) then 
  --           lv_return := 1;
  --      end if;    
   
   
     when 'NOT IN' then 
        select case when not regexp_like (in_val2,''''||in_val1||'''','i') then 1 else 0 end into lv_return from dual;
   
   else 
      lv_return := 0;
  
  end case;
  
  
  RETURN lv_return;
  END OPERATORS;
  
  FUNCTION EXCEPTION_EVALUATE(
  IN_VARIABLE IN VARCHAR2,
  IN_OPERATOR IN VARCHAR2,
  IN_VALUE IN VARCHAR2)
  
  RETURN NUMBER AS
  
  lv_return number :=0;
  
  Begin
  
  case
   when in_variable = 'STD SIZE'     then 
          --if (lv_stdsize = to_number(IN_value)) then 
              --lv_return := operators(to_char(lv_stdsize),in_operator,to_char(in_value)); 
              lv_return := operators(lv_stdsize,in_operator,in_value); 
          --end if;
          
   when in_variable = 'MULLED UNITS' then 
          --if (lv_mulledunits = to_number(IN_value)) 
          --then lv_return := 1; 
          --end if;
           lv_return := operators(to_char(lv_mulledunits),in_operator,to_char(in_value)); 
           
   when in_variable = 'WIDTH ES'     then 
         -- if (lv_widthes = to_number(IN_value)) then
           -- lv_return := 1; 
         -- end if;
          lv_return := operators(to_char(lv_widthes),in_operator,to_char(in_value)); 
          
          
   when in_variable = 'HEIGHT ES'     then 
  --        if (lv_heightes = to_number(IN_value)) then 
  --          lv_return := 1; 
  --        end if; 
         lv_return := operators(to_char(lv_heightes),in_operator,to_char(in_value)); 
         
   when in_variable = 'COLOR' then
        lv_return := operators(lv_framecolorin,in_operator,in_value); 
  
   when in_variable = 'TINT' then
        lv_return := operators(lv_tintin,in_operator,in_value);       
        
   when in_variable = 'ENERGY' then
        lv_return := operators(lv_energy,in_operator,in_value);       
        
   when in_variable = 'SAFETY' then
        lv_return := operators(lv_safety,in_operator,in_value);       
   
   when in_variable = 'GRID STYLE' then
        lv_return := operators(lv_gridstyle,in_operator,in_value);       
   when in_variable = 'GRID TYPE' then
        lv_return := operators(lv_gridtype,in_operator,in_value);  
   when in_variable = 'GRID PATTERN' then
        lv_return := operators(lv_gridpattern,in_operator,in_value);        
   
   when in_variable = 'SCREEN' then
        lv_return := operators(lv_screentype,in_operator,in_value);       
   
   when in_variable = 'WOOD/MULL' then
        if (lv_woodsurround!='0') then
        lv_return := operators(lv_woodsurround,in_operator,in_value);       
        else 
        lv_return := operators(lv_mulltype,in_operator,in_value);       
        end if;
   
   when in_variable = 'LOCKS' then
        lv_return := operators(lv_hardwaretype,in_operator,in_value);       
   
   when in_variable = 'COTTAGE/ORIEL' then
        lv_return := operators(lv_cottageoriel,in_operator,in_value);       
   
   when in_variable = 'FOAMWRAP' then
        lv_return := operators(lv_foamwrap,in_operator,in_value);       
   
   when in_variable = 'DRYWALL' then
        lv_return := operators(lv_style,in_operator,in_value);       
   
    when in_variable = 'SHAPES' then
        lv_return := operators(lv_isshape,in_operator,in_value);      
  
     when in_variable = 'STYLE' then
        lv_return := operators(lv_style,in_operator,in_value);      
      
      when in_variable = 'PANE TYPE' then
        lv_return := operators(lv_panetype,in_operator,in_value);    
   
  else 
    lv_return := 0;
  
  end case;
  
  return lv_return;
  end EXCEPTION_EVALUATE;
  
  FUNCTION FUNC_ES_TO_ES_UNIT ( p_ESSIZE IN VARCHAR2,p_TYPE IN NUMBER,p_EFFECTIVEUNIT IN number) RETURN VARCHAR2 AS 
  
  lv_essize number;
  lv_esunitsize number := P_ESSIZE; -- JUST SO WE RETURN SAME DATA INSTEAD OF EXCEPTION
  lv_wide varchar2(5);
  lv_high varchar2(5);
  
  BEGIN
    BEGIN
    select wide_deduct, high_deduct into lv_wide, lv_high from deductions where model_number = lv_MODEL and sizing_system='O';
    lv_esunitsize:= (p_ESSIZE + lv_wide)  / p_EFFECTIVEUNIT;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            LV_WIDE:= 0;
          end;
   end; 
    if (p_TYPE=1) then --width, divide and deduct
      lv_essize := lv_esunitsize - lv_wide;
    --elsif (p_TYPE=2) then --height, just deduct
     -- lv_essize := p_ESSIZE - lv_high;
    --elsif (p_TYPE=3) then --stacked units height, divide and deduct
      --lv_essize := lv_esunitsize - lv_high;
    end if;
    RETURN round(lv_essize,3);
  END FUNC_ES_TO_ES_UNIT;
  
  PROCEDURE PROC_WRITETOPRICINGLOG
  (
  
   IN_APPLIEDON IN VARCHAR2
  , IN_OPTIONTABLEID IN NUMBER
  , IN_PRICE IN NUMBER 
  , IN_SIZETYPE IN VARCHAR2 DEFAULT ''
  
  ) AS 
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
  --DBMS_OUTPUT.PUT_LINE('G_orderid '||G_orderid);
  --DBMS_OUTPUT.PUT_LINE('G_itemid '||G_itemid);
  --DBMS_OUTPUT.PUT_LINE('G_unitid '||G_unitid);
  --DBMS_OUTPUT.PUT_LINE('lv_linenumber '||lv_linenumber);
  --DBMS_OUTPUT.PUT_LINE('lv_linetypeid '||lv_linetypeid);
  --DBMS_OUTPUT.PUT_LINE('lv_lognexcept '||lv_lognexcept);
  --DBMS_OUTPUT.PUT_LINE('in_appliedon '||in_appliedon);
  --DBMS_OUTPUT.PUT_LINE('in_optiontableid '||in_optiontableid);
  --DBMS_OUTPUT.PUT_LINE('in_price '||in_price);
  --DBMS_OUTPUT.PUT_LINE('lv_stdsize '||lv_stdsize);
  --DBMS_OUTPUT.PUT_LINE('lv_isshape '||lv_isshape);
  --DBMS_OUTPUT.PUT_LINE('lv_hasgrid '||lv_hasgrid);
  --DBMS_OUTPUT.PUT_LINE('lv_screendeduct '||lv_screendeduct);
  --DBMS_OUTPUT.PUT_LINE('lv_part '||lv_part);
  --DBMS_OUTPUT.PUT_LINE('lv_sizetype '||lv_sizetype);
  --DBMS_OUTPUT.PUT_LINE('lv_widthes '||lv_widthes);
  --DBMS_OUTPUT.PUT_LINE('lv_heightes '||lv_heightes);
  --DBMS_OUTPUT.PUT_LINE('lv_mulledunits '||lv_mulledunits);
  --DBMS_OUTPUT.PUT_LINE('lv_effectiveunit '||lv_effectiveunit);
  --DBMS_OUTPUT.PUT_LINE('lv_sections '||lv_sections);
  --DBMS_OUTPUT.PUT_LINE('lv_totalunits '||lv_totalunits);
  --DBMS_OUTPUT.PUT_LINE('lv_category '||lv_category);
    
     insert into new_pricinglog (orderid,itemid,unitid,linenumber,linetypeid,lognexcept,appliedon,optiontableid,price,stdsize, isshape,hasgrid, 
                                screendeduct,ispart,sizetype,orderwidth,orderheight,mulledunits,effectiveunit,sections,totalunit,category) 
                                values
                                
                                 (G_orderid,G_itemid,G_unitid,lv_linenumber,lv_linetypeid,lv_lognexcept,in_appliedon,in_optiontableid,in_price,lv_stdsize, lv_isshape,lv_hasgrid,
                                lv_screendeduct,lv_part,lv_sizetype,lv_widthes,lv_heightes,lv_mulledunits,lv_effectiveunit,lv_sections,lv_totalunits,lv_category);
      
      COMMIT;
  END PROC_WRITETOPRICINGLOG;
  
  PROCEDURE PROC_WRITEEXCEPTIONLOG
  (
  
   IN_ASSIGNID IN NUMBER 
  , IN_DESCID IN NUMBER 
  , IN_DISCOUNTTYPE IN VARCHAR2 
  , IN_DISCOUNTVALUE IN NUMBER
  , IN_APPLIEDON IN VARCHAR2
  , IN_INITIALVALUE IN NUMBER
  , IN_EXCEPTVALUE IN NUMBER 
  ) AS 
  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    insert into new_pricenexceptlog (LOGNEXCEPT,UNITID,itemid,ASSIGNID,DESCID,DISCOUNTTYPE,DISCOUNTVALUE,APPLIEDON,INITIALVALUE,EXCEPTVALUE)
    values
    (lv_LOGNEXCEPT,G_UNITID,G_ITEMID,IN_ASSIGNID,IN_DESCID,IN_DISCOUNTTYPE,IN_DISCOUNTVALUE,IN_APPLIEDON,IN_INITIALVALUE,IN_EXCEPTVALUE);
  
    COMMIT;
  END PROC_WRITEEXCEPTIONLOG;
  
  FUNCTION APPLYPRICETYPE 
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
    when 'CLEARUI+FIXED' then lv_price := IN_PRICE + IN_VARIABLEPRICE * lv_unitedinches;
    when 'SQFT'     then lv_price := IN_PRICE * (IN_Widthes *IN_heightes)/144;
    when 'PER_LITE' then lv_price := IN_PRICE * IN_LITE;
    when '6 LITE' then lv_price := IN_PRICE * 6;
    when '9 LITE' then lv_price := IN_PRICE * 9;
    when 'PER_INCH' then lv_price := IN_PRICE * (IN_WIDTHES + IN_HEIGHTES);
     when 'MAXUI_FIXED' then lv_price := IN_PRICE; -- no change needed as of now .
    
   -- when '6 LITE * SASH' then lf (lv_sash > 0) then lv_price := IN_PRICE * 6 * lv_sash; else  lv_price := IN_PRICE * 6 end if;
    when '6 LITE * SASH' then case when lv_sash > 0 then  lv_price := IN_PRICE * 6 * lv_sash; else  lv_price := IN_PRICE * 6; end case;
    when '9 LITE * SASH' then case when lv_sash > 0 then  lv_price := IN_PRICE * 9 * lv_sash; else  lv_price := IN_PRICE * 9; end case;
    
    when 'PERC_OPTION' then lv_price := IN_VARIABLEPRICE- ( IN_VARIABLEPRICE * IN_PRICE/100);
    when 'PERC_OPTION_UPCHARGE' then lv_price := IN_VARIABLEPRICE + ( IN_VARIABLEPRICE * IN_PRICE/100);
    when 'CLEARUI+FIXED' then lv_price := IN_VARIABLEPRICE  * lv_unitedinches + IN_PRICE;
    else 
    lv_price := IN_PRICE;
    end case ;
    
    RETURN ROUND (lv_PRICE,3);
  END APPLYPRICETYPE;
  
  FUNCTION APPLYMULTONPRICE(
  IN_APPLYON IN VARCHAR2,
  IN_EXCEPTVALUE IN VARCHAR2,
  IN_PRICE IN NUMBER
  --IN_LITES IN NUMBER DEFAULT 1 
  )
  RETURN NUMBER AS
  
  mul_effunit varchar2(50) := 'NO';
  mul_sections varchar2(50) := 'NO';
  mul_lites varchar2(50) := 'NO';
  multvalue varchar2(100) := '1';
  
  lv_price number:=0;
  
  BEGIN
    
    lv_price := IN_PRICE;
  
  
  
  if (lv_price >0 ) then
    begin
    
     
      select  *
      into multvalue from (select 
     nvl(multvalue,'1')
      from new_pricemultiplier
      where applyon = IN_APPLYON
      and regexp_like (construction,''''||lv_construction||'''','i')
      and ( regexp_like (exceptvalues,''''||IN_EXCEPTVALUE||'''','i') or exceptvalues ='-' )
      and (regexp_like (style,''''||lv_style||'''','i') or style = '-')
      and (regexp_like (series,''''||lv_series||'''','i') or series = '-')
      and ( (regexp_like (gridplacement,''''||LV_GRIDPLACEMENT||'''','i') and IN_APPLYON= 'GRID') OR gridplacement= '''0''' )
      
      order by exceptvalues,style,series) x where rownum <2 ;
      EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
       
        multvalue    :='1' ;
      end; 
    end;
    
    DBMS_OUTPUT.put_line ('IN MULTON DOORPANLE IS ' || lv_doorpanel || ' price is ' || IN_PRICE || ' mult value is ' || multvalue);
    
    
    if ( multvalue !='1') then
    
       case multvalue
        when 'EFFECTIVEUNIT OR SECTIONS'  then  
                    if lv_sections > 1 then 
                         lv_price := IN_price * lv_SECTIONS;
                    else
                        lv_price := IN_price * lv_effectiveunit;
                        
                    end if;
        when 'EFFECTIVEUNIT'  then lv_price := IN_price * lv_EFFECTIVEUNIT;            
        when 'SECTIONS' then lv_price := IN_price * lv_SECTIONS;
        when 'DOORPANEL' then lv_price := IN_price * lv_doorpanel;
        when 'LITES' then lv_price := IN_price * LV_LITES;
        when 'EFFECTIVEUNIT * SECTIONS' then lv_price := IN_price * lv_EFFECTIVEUNIT * lv_SECTIONS;
        when 'EFFECTIVEUNIT * (SECTIONS - 2)' then lv_price := IN_price * lv_EFFECTIVEUNIT * (lv_SECTIONS-2);
        when '(SECTIONS - 2)' then lv_price := IN_price * (lv_SECTIONS-2);
        when 'EFFECTIVEUNIT * SECTIONS * LITES' then lv_price := IN_price * lv_EFFECTIVEUNIT * lv_SECTIONS * LV_LITES;
        
      else lv_price := IN_PRICE;
        
      end case; 
  
    end if;
  end if ; -- if price > 0  
  
  DBMS_OUTPUT.put_line ('Now  price is ' || lv_PRICE);
    RETURN lv_PRICE;
    
  END APPLYMULTONPRICE;
  
  FUNCTION APPLYPRICEMUL
  (
    IN_PRICE IN NUMBER 
  , IN_PRICEMUL IN VARCHAR2 DEFAULT 1 
  , IN_LITES IN NUMBER DEFAULT 1 
  ) RETURN NUMBER AS 
  lv_price number := 0;
  BEGIN
    
    case IN_PriceMUL
    when 'EFFECTIVEUNIT'  then lv_price := IN_price * lv_EFFECTIVEUNIT;
    when 'SECTIONS' then lv_price := IN_price * lv_SECTIONS;
    when 'LITES' then lv_price := IN_price * IN_LITES;
    when 'EFFECTIVEUNIT * SECTIONS' then lv_price := IN_price * lv_EFFECTIVEUNIT * lv_SECTIONS;
    when 'EFFECTIVEUNIT * (SECTIONS - 2)' then lv_price := IN_price * lv_EFFECTIVEUNIT * (lv_SECTIONS-2);
    when '(SECTIONS - 2)' then lv_price := IN_price * (lv_SECTIONS-2);
    when 'EFFECTIVEUNIT * SECTIONS * LITES' then lv_price := IN_price * lv_EFFECTIVEUNIT * lv_SECTIONS * IN_LITES;
    
    else lv_price := IN_PRICE;
    
    end case; 
        
    RETURN lv_PRICE;
  END APPLYPRICEMUL;
  
  function FUNC_GETLITES  
    --(
     -- P_GRIDPATTERN VARCHAR2 
    --)
    return number as 
    
    lv_lites number :=1;
    lv_toplite number:=0;
    lv_topliteH number:=0;
    lv_topliteV number:=0;
    lv_bottomlite number :=0;
    lv_bottomliteH number :=0;
    lv_bottomliteV number :=0;
    --lv_gridpattern varchar2(200);
    
    BEGIN
    
     DBMS_OUTPUT.PUT_LINE(G_UNITID);
     
     DBMS_OUTPUT.PUT_LINE(lv_GRIDPATTERN);
     
     -- lv_GRIDPATTERN := upper(P_GRIDPATTERN);
       lv_GRIDPATTERN := upper(lv_GRIDPATTERN);
       
       --prairie = '2h2v-2h2v' --permieter or perimeter prairie = '1h2v-1h2v'
       
       
      if lv_gridpattern like '%HX%' or lv_gridpattern like '%HEX%'  then
      begin 
       lv_topliteH := substr ( lv_gridpattern,0,Instr(lv_gridpattern,'H',1)-1);
       lv_topliteV := substr ( lv_gridpattern,Instr(lv_gridpattern,'X',1)+1,Instr(lv_gridpattern,'V',1)-(Instr(lv_gridpattern,'X',1)+1));
      
        lv_toplite := (lv_topliteH +1) * (lv_topliteV +1);
        if (lv_toplite = 1) then
          lv_toplite :=0;
        end if ;
      
        if lv_gridpattern  like '%-%' then 
        begin
          lv_bottomliteH:= substr ( lv_gridpattern,Instr(lv_gridpattern,'-',1)+1,Instr(lv_gridpattern,'H',1,2)-(Instr(lv_gridpattern,'-',1)+1));
          lv_bottomliteV:= substr ( lv_gridpattern,Instr(lv_gridpattern,'X',1,2)+1,Instr(lv_gridpattern,'V',1,2)-(Instr(lv_gridpattern,'X',1,2)+1));
          lv_bottomlite := (lv_bottomliteH +1) * (lv_bottomliteV +1);
      
          if (lv_bottomlite = 1) then
            lv_bottomlite :=0;
          end if ;
      
        end ;
        end if;
      end;
      end if;
      
    lv_lites := lv_toplite+lv_bottomlite;
    
      
    RETURN lv_lites;
  
  END FUNC_GETLITES;
  
  function getwarrantyprice 
  
  return number as 
  
  lv_price number :=0;
  lv_pricetype option_warranty.pricetype%TYPE;
  --lv_pricemul option_warranty.pricemul%type;
  lv_warrantyid option_warranty.ID%type;
  lv_warranty_desc option_warranty.warranty_desc%type;
  
  
  BEGIN
  
    begin
  
       select price,pricetype,id  into lv_price,lv_pricetype,lv_warrantyid from
        (select price,pricetype,pricemul,id  from  option_warranty
        where 
        warranty= lv_gbwselected
        and regexp_like ( construction,''''||LV_CONSTRUCTION||'''','i') 
        and (regexp_like (series,''''||LV_SERIES||'''','i') or series = 'ALL')
        and (regexp_like (model,''''||LV_model||'''','i') or model = 'ALL')
        and (regexp_like (accountid,''''||LV_accountid||'''','i') or accountid = 'ALL')
        and (regexp_like (customerid,''''||LV_customerid||'''','i') or customerid = 'ALL')
        and (regexp_like (style,''''||LV_Style||'''','i') or style = 'ALL') order by accountid,customerid,model,series,style)
        x where rownum < 2;
  
        EXCEPTION WHEN NO_DATA_FOUND THEN
          begin 
            lv_price :=0;
            lv_warrantyid :=0;
          end;  
    end;  
    
    
   if (lv_price > 0) then 
  --     if lv_pricemul != '1' then
  --      lv_price := applypricemul(lv_price,lv_pricemul);
  --    end if;
      proc_WriteToPricingLog ('WARRANTY',lv_warrantyid,lv_price);   
    end if ; 
  
    RETURN lv_price;
    
    
  END getwarrantyprice;
  
  FUNCTION GETGLASSPRICE
  
  RETURN NUMBER AS 
  
  lv_tint  OPTION_GLASS.TINT%TYPE;
  lv_tintpricetype OPTION_GLASS.TINT_PRICE_TYPE%TYPE;
  lv_energypricetype OPTION_GLASS.energy_PRICE_TYPE%TYPE;
  lv_tintsafety OPTION_GLASS.SAFETY%TYPE;
  
  lv_tintenergy OPTION_GLASS.ENERGY%TYPE;
  
  lv_safetypricetype OPTION_GLASS.safety_PRICE_TYPE%TYPE;
  
  
  lv_calc_safety number :=1;
  lv_energy_safety number :=0;
  lv_calc_energy number :=1;
  
--  cursor c_tint is 
--  select id, nvl(tint_price,0), tint_price_type,safety,nvl(safety_price,0), safety_price_type from option_glass
--  where  regexp_like (tint , lv_tintin,'i') and (regexp_like (series,''''||lv_series||'''','i') or series = 'ALL')
--  and (regexp_like (style,''''||lv_style||'''','i') or style = 'ALL') order by series,style,safety;
--  
  
  BEGIN
  ---Note :- that if sections > 1 then we multiply by sections instead of effectiveunit.
  
  lv_tintprice   :=0;
  lv_energyprice :=0;
  lv_safetyprice :=0;
  lv_glassprice :=0;
  
  if ( lv_series not in ('300','330','375') ) then 
              if (lv_tintin not in  ('Clear','CLEAR')) then
                if (lv_doortint !=0) then -- if its door we have already got the price and pricetype while calculating base.
                  lv_tintprice := lv_doortint;
                  lv_tintpricetype := lv_doortint_pricetype;
                  lv_tintid := lv_sizeid;
                
                else
                  begin 
                      select *  into lv_TINTID,lv_tintprice,lv_tintpricetype,lv_tintsafety,lv_safetyprice,lv_safetypricetype ,lv_tintenergy ,lv_energyprice,lv_energypricetype from 
                      ( select id, nvl(tint_price,0), tint_price_type,safety,nvl(safety_price,0), safety_price_type, nvl(energy,'0') ,nvl(energy_price,0), energy_price_type from option_glass
                      where  regexp_like (tint , ''''||lv_tintin||'''','i') and (regexp_like (series,''''||lv_series||'''','i') or series = 'ALL')
                      and (regexp_like (style,''''||lv_style||'''','i') or style = 'ALL') 
                      and (regexp_like (safety,''''||lv_safety||'''','i') or safety = '-')
                      and (regexp_like (energy,''''||lv_energy||'''','i') or energy = '-')
                      order by series,style,safety,energy)x where  rownum < 2;
                  
                    --open c_tint;
                  --  loop fetch c_tint into lv_TINTID,lv_tintprice,lv_tintpricetype,lv_tintsafety,lv_safetyprice,lv_safetypricetype;
                   -- EXIT WHEN c_tint%NOTFOUND;
                      if ( (lv_tintsafety is not null and lv_tintsafety!='-') or  --had to change since now tint,energy and safety default value is '-'
                            lv_safetyprice is not null or lv_tintin like '%''Tempered' or lv_tintin like '%''TEMPERED') then -- made change so for bronze double strength is not charged
                            if lv_tintsafety = ''''||lv_safety||'''' then
                                lv_calc_safety :=0;
                                 lv_safetyID:=lv_TINTID;
                             --   exit;
                            end if;
                            if lv_tintin like '%''Tempered' or lv_tintin like '%''TEMPERED' then
                            lv_safetyID:=lv_TINTID;
                              lv_calc_safety :=0;
                            end if;
                      end if ;
                      
                      
                     if lv_tintenergy = ''''||lv_energy||'''' then
                                lv_calc_energy :=0;
                                 lv_energyID:=lv_TINTID;
                             --   exit;
                      end if;
                            
                    --end loop;
                    --close c_tint;
                        
                        EXCEPTION WHEN NO_DATA_FOUND THEN
                          begin 
                            lv_tintprice := 0;
                            lv_TINTID:=0;
                          end;
                    
                  end; 
                  end if;-- lv_doortint!=0
              end if; 
              
              
              ---energy 
              begin
               if (lv_doorenergy !=0) then -- for doors we have already calculated energy
                         lv_energyprice := lv_doorenergy;
                         lv_energyID:=lv_sizeid;
                         lv_energypricetype := lv_doorenergy_pricetype;
                         
                     else  if (lv_calc_energy = 1) then
                      begin
                           select id,nvl(energy_price,0), energy_price_type,energysafety into  lv_energyID,lv_energyprice,lv_energypricetype,lv_energy_safety from (
                            select id,energy_price, energy_price_type ,
                            case when safety = ''''||lv_safety||'''' then 1
                            else 0 end as energysafety  
                            from option_glass
                            where regexp_like(energy,''''||lv_energy||'''','i') and regexp_like(pane_type,''''||lv_panetype||'''','i')
                            and (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL')
                            and (regexp_like (style,''''||lv_Style||'''','i') or style = 'ALL') and nfrc =lv_NFRC 
                            and (regexp_like (safety,''''||lv_safety||'''','i') or safety = '-')
                            order by series,style,energysafety desc) x where rownum < 2;
                          
                              if (lv_calc_safety =1 and lv_energy_safety = 1 ) then -- to make surein case safety is matched we dont calculate safety.
                                  lv_calc_safety :=0;
                                  lv_safetyID:=lv_energyID;
                              end if;
                            
                            EXCEPTION WHEN NO_DATA_FOUND THEN
                              begin 
                                lv_energyprice := 0;
                                lv_energyID:=0;
                              end;
                           end;
                        end if;   
                end if;
              end;  
                
                --safety only if we have to calcualte it
            
            if (lv_calc_safety = 1 and lv_safety not in ('Single Strength','SINGLE STRENGTH')) then 
               begin 
                  select ID,nvl(safety_price,0), safety_price_type into lv_safetyID, lv_safetyprice,lv_safetypricetype  from (
                  select id,safety_price, safety_price_type from option_glass
                  where regexp_like(safety,''''||lv_safety||'''','i') and (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL')
                  and (regexp_like (style,''''||lv_Style||'''','i') or style = 'ALL') 
                  and (shape = lv_isSHAPE or shape = 'ALL')
                   and nfrc =lv_NFRC 
                  and tint = '-' and energy = '-' order by series,style,shape) y where  rownum < 2;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                 begin 
                    lv_safetyprice := 0;
                  end;
              end;
             end if ; 
    else
        --tint
         if (lv_tintin not in  ('Clear','CLEAR')) then
           begin
         
              select id,
              case 
              when lv_widthes +  lv_heightes <= 61 then  UI_0_61
              when lv_widthes +  lv_heightes > 61  and  lv_widthes +  lv_heightes <=73 then UI_62_73
              when lv_widthes +  lv_heightes > 73  and  lv_widthes +  lv_heightes <=83 then UI_74_83
              when lv_widthes +  lv_heightes > 83  and  lv_widthes +  lv_heightes <=93 then UI_84_93
              when lv_widthes +  lv_heightes > 93  and  lv_widthes +  lv_heightes <=101 then UI_94_101
              when lv_widthes +  lv_heightes > 101 and  lv_widthes +  lv_heightes <=110 then UI_102_110
              when lv_widthes +  lv_heightes > 110 and  lv_widthes +  lv_heightes <=156 then UI_111_156
              else 0
              end
              , tint_price_type,
              
              case 
              when regexp_like(safety,lv_safety,'i') then 1 
              else 0
              end
              ,nvl(safety_price,0), safety_price_type
               into lv_TINTID,lv_tintprice,lv_tintpricetype,lv_calc_safety,lv_safetyprice,lv_safetypricetype
              from option_glass_alum
              where  regexp_like (tint , lv_tintin,'i') 
               ;
             
           EXCEPTION WHEN NO_DATA_FOUND THEN
            begin 
              lv_tintprice := 0;
              lv_tintID:=0;
            end;
  
        end;
        end if;
        
         ---energy 
          begin
          
            select id,
            case 
              when lv_widthes +  lv_heightes <= 61 then  UI_0_61
              when lv_widthes +  lv_heightes > 61  and  lv_widthes +  lv_heightes <=73 then UI_62_73
              when lv_widthes +  lv_heightes > 73  and  lv_widthes +  lv_heightes <=83 then UI_74_83
              when lv_widthes +  lv_heightes > 83  and  lv_widthes +  lv_heightes <=93 then UI_84_93
              when lv_widthes +  lv_heightes > 93  and  lv_widthes +  lv_heightes <=101 then UI_94_101
              when lv_widthes +  lv_heightes > 101 and  lv_widthes +  lv_heightes <=110 then UI_102_110
              when lv_widthes +  lv_heightes > 110 and  lv_widthes +  lv_heightes <=156 then UI_111_156
              else 0
            end
              ,
              energy_price_type into  lv_energyID,lv_energyprice,lv_energypricetype  from option_glass_alum
            where regexp_like(''''||energy||'''',''''||lv_energy||'''','i') ; -- because low e and low e/argon will always return true for low e
            EXCEPTION WHEN NO_DATA_FOUND THEN
              begin 
                lv_energyprice := 0;
                lv_energyID:=0;
              end;
           end;
          
          --safety
          
            if (lv_calc_safety = 1 and lv_safety not in ('Single Strength','SINGLE STRENGTH')) then 
               begin 
                  
                  select ID, 
                  case 
                when lv_widthes +  lv_heightes <= 61 then  UI_0_61
                when lv_widthes +  lv_heightes > 61  and  lv_widthes +  lv_heightes <=73 then UI_62_73
                when lv_widthes +  lv_heightes > 73  and  lv_widthes +  lv_heightes <=83 then UI_74_83
                when lv_widthes +  lv_heightes > 83  and  lv_widthes +  lv_heightes <=93 then UI_84_93
                when lv_widthes +  lv_heightes > 93  and  lv_widthes +  lv_heightes <=101 then UI_94_101
                when lv_widthes +  lv_heightes > 101 and  lv_widthes +  lv_heightes <=110 then UI_102_110
                when lv_widthes +  lv_heightes > 110 and  lv_widthes +  lv_heightes <=156 then UI_111_156
                else 0
              end
                ,
                  
                  
                  safety_price_type into lv_safetyID, lv_safetyprice,lv_safetypricetype   from option_glass_alum
                  where regexp_like(safety,lv_safety,'i')
                  and (shape = lv_isSHAPE or shape = 'ALL') --so far its only safety which needed shapes exclusion ..eg double strength.
                  and tint is null 
                  ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                 begin 
                    lv_safetyprice := 0;
                  end;
              end;
             end if ; 
              
         
         
    end if; --
   
   
  
  -- Apply price type and multon TINT and energy
    if (lv_tintprice > 0)  then
      lv_tintprice := applypricetype (lv_tintprice,lv_tintpricetype,lv_WIDTHES,lv_HEIGHTES);
      lv_tintprice := applymultonprice ('TINT',lv_tintin,lv_tintprice);
    end if;
    
    if (lv_energyprice > 0)  then
      lv_energyprice := applypricetype (lv_energyprice,lv_energypricetype,lv_WIDTHES,lv_HEIGHTES);
      lv_energyprice := applymultonprice ('ENERGY',lv_energy,lv_energyprice);
    end if;
    
    
    if (lv_safetyprice > 0)  then
      lv_safetyprice := applypricetype (lv_safetyprice,lv_safetypricetype,lv_WIDTHES,lv_HEIGHTES);
      lv_safetyprice := applymultonprice ('SAFETY',lv_safety,lv_safetyprice);
    end if;
    
  
    lv_glassprice := lv_TINTPRICE + lv_energyPRICE + lv_safetyPRICE;
    
    if ( lv_series not in ('300','330','375') ) then 
    if (lv_tintprice!=0) then  proc_WriteToPricingLog ('TINT',lv_tintid,lv_tintprice); end if;
    if (lv_energyprice!=0) then proc_WriteToPricingLog ('ENERGY',lv_energyid,lv_energyprice); end if;
    if (lv_safetyprice!=0) then proc_WriteToPricingLog ('SAFETY',lv_safetyid,lv_safetyprice); end if;
    else 
      
    if (lv_tintprice!=0) then  proc_WriteToPricingLog ('TINT ALUMINUM',lv_tintid,lv_tintprice); end if;
    if (lv_energyprice!=0) then proc_WriteToPricingLog ('ENERGY  ALUMINUM',lv_energyid,lv_energyprice); end if;
    if (lv_safetyprice!=0) then proc_WriteToPricingLog ('SAFETY ALUMINUM',lv_safetyid,lv_safetyprice); end if;
    
    end if;
    if (lv_glassprice!=0) then proc_WriteToPricingLog ('GLASS',0,lv_glassprice); end if;
    
    RETURN lv_glassprice;
  END GETGLASSPRICE;
  
  FUNCTION GETGRIDPRICE
  
  RETURN NUMBER AS 
  
  lv_price number;
  
  lv_pricemul option_grid.pricemul%TYPE;
  --lv_lites number := 0;
  lv_gridpatternid number :=0;
  lv_gridpatternprice number :=0;
  
  lv_gridid number:=0;
  lv_gridcolorid number :=0;
  
  
  
  
  BEGIN
  
  --lv_lites := IN_LITES;
  lv_HASGRID :=0;
  lv_GRIDPATTERNID :=0;
  lv_GRIDPATTERNPRICE :=0;
  lv_gridpricetype :='';
  lv_gridpatternpricetype :='';
  lv_gridcolorpricetype :='';
  lv_gridcolorprice :=0;
  lv_newgridupcharge :=0;
  lv_gridstdsize :='';
  
  ---Logic
  -- 1) Determine if shape (go to step 2) or not (go to step 4)
  -- 2) And then get correct record.
  -- 3) check if TSO / BSL or gridpattern has 0Hx0V and do 50% of the price.
  ---
  
  begin 
  if (lv_isSHAPE = 1) then
    
        lv_price :=0;
        
          select * INTO lv_GRIDID,LV_PRICE , LV_gridPRICETYPE ,LV_PRICEMUL,lv_gridstdsize from (select id, price , pricetype, pricemul,stdsize from  option_grid
          where regexp_like ( construction,''''||LV_CONSTRUCTION||'''','i') 
          and regexp_like (type,''''||LV_GRIDTYPE||'''','i') 
          and regexp_like (gridstyle,''''||LV_GRIDSTYLE||'''','i') 
          and regexp_like (pattern,''''||LV_GRIDPATTERN||'''','i') 
          and (regexp_like (style,''''||LV_STYLE||'''','i'))
          and regexp_like (stdsize,lv_stdsize)
          and shapes = 1 order by style desc)x where rownum < 2;
          
          lv_HASGRID := 1;
          
    else -- not a shape
      begin --1  
       /* 
          DBMS_OUTPUT.put_line('lv_construction '||lv_construction);
          DBMS_OUTPUT.put_line('LV_GRIDTYPE '||LV_GRIDTYPE);
          DBMS_OUTPUT.put_line('LV_GRIDSTYLE '||LV_GRIDSTYLE);
          DBMS_OUTPUT.put_line('LV_STYLE '||LV_STYLE);
          DBMS_OUTPUT.put_line('LV_SERIES '||LV_SERIES);
          DBMS_OUTPUT.put_line('LV_GRIDCOLOROUT '||LV_GRIDCOLOROUT);
          DBMS_OUTPUT.put_line('LV_GRIDPLACEMENT '||LV_GRIDPLACEMENT);
          DBMS_OUTPUT.put_line('LV_SAFETY '||LV_SAFETY);
          */
          
          select * INTO LV_GRIDID,LV_PRICE , LV_gridPRICETYPE ,LV_PRICEMUL,lv_gridstdsize from (select id, price , pricetype, pricemul,stdsize from  option_grid
          where regexp_like ( construction,''''||LV_CONSTRUCTION||'''','i') 
          and regexp_like (type,''''||LV_GRIDTYPE||'''','i') 
          and regexp_like (gridstyle,''''||LV_GRIDSTYLE||'''','i') 
          and (regexp_like (style,''''||LV_STYLE||'''','i') or style = 'ALL')
          and (regexp_like (series,''''||LV_SERIES||'''','i') or series = 'ALL')
          and (regexp_like  (gridcolorout,''''||LV_GRIDCOLOROUT||'''','i') or gridcolorout = 'ALL')
          and regexp_like (gridplacement,''''||LV_GRIDPLACEMENT||'''','i') 
          and (regexp_like (safety,''''||LV_SAFETY||'''','i') or safety = 'ALL')
          and regexp_like (stdsize,lv_stdsize)
          and shapes = 0 order by style,series,gridcolorout,safety )x where rownum < 2;
        
        --- EXCEPTION :- for this grid style only we compute base price as if it has grid for other grid styles we compute as non grid base price .
        -- if (IN_GRIDSTYLE not in ('Diamond','DIAMOND','Prairie','PRAIRIE','Perimeter','PERIMETER','SDL','7/8') ) then
         if (LV_GRIDSTYLE in ('Colonial','Contour','Contour Valance','COLONIAL','CONTOUR','CONTOUR VALANCE')) then
          LV_HASGRID := 1;
         end if;
         
         if (lv_hasgrid = 1 and lv_gridstyle in  ('Colonial','COLONIAL') and LV_GRIDTYPE in ('3/4','5/8','1') and lv_construction ='N') then -- for new ccontruction we dont charge for colonial if its std size but at this point of time we havent computed base price and so we dont know if its std size or custom.
            lv_newgridupcharge :=1;
         end if;
          
      end; --1
      
  end if;
  
        EXCEPTION WHEN NO_DATA_FOUND THEN
        BEGIN
          LV_PRICE :=0;
          LV_GRIDPRICETYPE:=0;
          LV_PRICEMUL :=0;
          LV_HASGRID :=0;   
          LV_GRIDID := 0;
        END ;
        
     end ;
        
          --- get the price
          if (lv_price > 0)  then
                  lv_price := applypricetype(lv_price,lv_gridpricetype,LV_WIDTHES,LV_HEIGHTES,LV_BASEPRICE,LV_LITES);
                 
                  lv_price := applymultonprice ('GRID',lv_gridstyle,lv_price);
                 
                 
  --                if lv_pricemul != '1' then
  --                  lv_price := applypricemul(lv_price,lv_pricemul);
  --                end if;
                   --- now see if its a TSO or has OHxOV grid pattern
                   
                   if (lv_isSHAPE = 0) then --tso bso etc applies only 
                      begin 
                        select id,price,pricetype into lv_gridpatternid, lv_gridpatternprice, lv_gridpatternpricetype from option_grid 
                        where regexp_like ( construction,''''||LV_CONSTRUCTION||'''','i')
                        and regexp_like (gridstyle,''''||LV_GRIDSTYLE||'''','i') 
                        and regexp_like (pattern,''''||LV_GRIDPATTERN||'''','i') ;
                        
                       
                          
                        if (lv_gridpatternprice > 0) then
                          lv_gridpatternprice := applypricetype(lv_gridpatternprice,lv_gridpatternpricetype,LV_WIDTHES,LV_HEIGHTES,lv_price,lv_LITES);
                         -- IN_GRIDPATTERNPRICE := lv_gridpatternprice;
                          --IN_GRIDpatternID := lv_gridpatternid;
                           proc_WriteToPricingLog ('GRID TSO ONLY',lv_gridpatternid,lv_gridpatternprice);
                           
                           lv_price := lv_gridpatternprice;
                         end if ;
                        
                        
                          EXCEPTION WHEN NO_DATA_FOUND THEN
                          BEGIN
                            LV_gridpatternPRICE :=0;
                            LV_gridpatternPRICETYPE:=0;
                            lv_GRIDpatternID := 0;
                           -- IN_gridpatternPRICE :=0;
                           -- IN_GRIDpatternID := 0;
                          END ;
                          
                      end;   
                   end if; -- IN_SHApES
                  
                  if ((LV_GRIDCOLOROUT not in ('White','WHITE')) or (LV_GRIDCOLORIN not in ('White','WHITE'))) then
                  
                    begin 
                          select id,price,pricetype into lv_gridcolorid, lv_gridcolorprice, lv_gridcolorpricetype from (select id,price,pricetype from option_grid 
                          where regexp_like ( construction,''''||LV_CONSTRUCTION||'''','i')
                          and gridstyle= 'ALL' 
                          and pattern ='ALL' 
                          and shapes = lv_isshape
                          and (regexp_like (series,''''||LV_SERIES||'''','i') or series = 'ALL')
                          and (regexp_like  (gridcolorout,''''||LV_GRIDCOLOROUT||'''','i') or  regexp_like  (gridcolorout,''''||LV_GRIDCOLORIN||'''','i')) order by series )x where rownum < 2;
                          
                         
                            
                          if (lv_gridcolorprice > 0) then
                            lv_gridcolorprice := applypricetype(lv_gridcolorprice,lv_gridcolorpricetype,LV_WIDTHES,LV_HEIGHTES,lv_price,lv_LITES);
                           -- IN_GRIDPATTERNPRICE := lv_gridpatternprice;
                            --IN_GRIDpatternID := lv_gridpatternid;
                             lv_gridcolorprice := lv_gridcolorprice-lv_price;
                             proc_WriteToPricingLog ('GRID COLOR',lv_gridcolorid,lv_gridcolorprice);
                             
                             lv_price := lv_price + lv_gridcolorprice;
                           end if ;
                          
                            EXCEPTION WHEN NO_DATA_FOUND THEN
                            BEGIN
                              LV_gridcolorPRICE :=0;
                              LV_gridcolorPRICETYPE:=0;
                              lv_GRIDcolorID := 0;
                             -- IN_gridpatternPRICE :=0;
                             -- IN_GRIDpatternID := 0;
                            END ;
                            
                      end;   
                      
                  end if ; --(LV_GRIDCOLOROUT not in ('White','WHITE') ) -- upcharge for grid color
                  
                  
                  
                   proc_WriteToPricingLog ('GRID',lv_gridid,lv_price);
            end if ; --lv_price >0
  
  ---Just get grid price for now and they   figure out effective unit etc...
    RETURN LV_PRICE;
  END GETGRIDPRICE;
  
  --
  ----FOR DOOR ALONG WITH BASE PRICE WE ALSO CALCULATE OTHER OPTION PRICES LIKE ENERGY COLOR ETC.
  --FUNCTION GETBASEPRICE_DOOR
  --(
  --
  ----
  --  IN_WIDTHES IN NUMBER
  --, IN_HEIGHTES IN NUMBER
  --
  --) 
  --RETURN NUMBER AS 
  --
  --lv_widthes NUMBER := IN_WIDTHES;
  --lv_heightes NUMBER := IN_HEIGHTES;
  --lv_unitedinches number:= lv_WIDTHES + lv_HEIGHTES;
  --
  --lv_clear                    new_pricingsize.clear%type;
  --lv_clear_pricetype          new_pricingsize.clear_Pricetype%type;
  --lv_withgrid                 new_pricingsize.withgrid%type;
  --lv_withgrid_pricetype       new_pricingsize.withgrid_pricetype%type;
  --lv_screen_deduct            new_pricingsize.screen_deduct%type;  
  --lv_screen_deduct_pricetype  new_pricingsize.screen_deduct_pricetype%type;
  ----lv_clear_minui              new_pricingsize.clear_minui%type;
  ----lv_withgrid_minui           new_pricingsize.withgrid_minui%type;
  --
  --BEGIN
  --  
  --  BEGIN -- 1
  --
  --    
  --  
  --  END; --1 
  --  
  --RETURN 0;
  --END GETBASEPRICE_DOOR;
  
  
  FUNCTION GETBASEPRICE
  (
  
  --
    IN_WIDTHES IN NUMBER
  , IN_HEIGHTES IN NUMBER
  , IN_DOOR NUMBER DEFAULT 0
  
  ) 
  RETURN NUMBER AS 
  
  lv_widthes NUMBER := IN_WIDTHES;
  lv_heightes NUMBER := IN_HEIGHTES;
  
  lv_unitedinches number:= 0;
  --lv_WIDTHES + lv_HEIGHTES;
  
  lv_clear                    new_pricingsize.clear%type;
  lv_clear_pricetype          new_pricingsize.clear_Pricetype%type;
  lv_withgrid                 new_pricingsize.withgrid%type;
  lv_withgrid_pricetype       new_pricingsize.withgrid_pricetype%type;
  lv_screen_deduct            new_pricingsize.screen_deduct%type :=0;  
  lv_screen_deduct_pricetype  new_pricingsize.screen_deduct_pricetype%type;
  lv_clear_minui              new_pricingsize.clear_minui%type;
  lv_withgrid_minui           new_pricingsize.withgrid_minui%type;
  
  
  lv_door_color number:=0;
  lv_door_color_pricetype VARCHAR2(50) :='';
  
  --lv_nonwhite                     new_door_pricingsize.nonwhite%type;
  --lv_nonwhite_pricetype           new_door_pricingsize.nonwhite_pricetype%type;
  --lv_painted                      new_door_pricingsize.painted%type;
  --lv_painted_pricetype            new_door_pricingsize.painted_pricetype%type;
  --lv_doorenergy number := 0;
  lv_heavy_duty_screen            new_door_pricingsize.heavy_duty_screen%type;
  lv_heavy_duty_screen_pricetype  new_door_pricingsize.heavy_duty_screen_pricetype%type;
  
  
  
  lv_door_baseprice number := 0;
  lv_HD_SS number :=0; -- HD stacking sill.
  lv_HD_SS_Pricetype varchar2(50):='';
  
  BEGIN
   lv_baseprice :=0;
   lv_stdsize :=0; 
   lv_SIZETYPE :='';
   --lv_SCREENDEDUCT :=0;
   lv_STDSIZE :=0;
   lv_sizeid  :=0; 
   
   lv_panels_clear  := 0;
   lv_panels_withgrid  :=0;
   lv_panels_pricetype :='0';
   
   ---FOR NEW CONSTRUCTION UNited inches  = CEIL(WIDTHES) + CEIL(HEIGHTES) and for replacement  floor(...
   
    --DETERMINE WHICH FIELDS to choose what orders etc ---
    
    --IF (IN_gridtype in ('No Grid','SDL') or (IN_gridstyle not in ('Colonial','Contour' , 'Contour Valance' ))) then
    
        if (LV_CONSTRUCTION = 'N') then -- for new constr we round up.
          lv_unitedinches := ceil(lv_widthes) + ceil(lv_heightes);
        else
          ---lv_unitedinches :=floor(lv_WIDTHES+lv_HEIGHTES);
          lv_unitedinches :=floor (lv_WIDTHES+lv_HEIGHTES);
        end if;
        
        
        if (IN_DOOR = 0) then 
    
                   IF lv_effectiveunit > 1 THEN
                          --we need to "resize" the unit to a fundamental component size based on oracle effective units
                           --select func_es_to_es_unit(lv_widthes,1,lv_effectiveunit) into lv_widthes from dual;
                           lv_widthes := func_es_to_es_unit(lv_widthes,1,lv_effectiveunit);
                           lv_unitedinches := LV_WIDTHES + IN_HEIGHTES;
                   END IF;
                   
                    if (lv_isSHAPE !=1) then       
                                
                          if (LV_CONSTRUCTION = 'N') THEN
                            begin --1
                                  select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1 
                                  into lv_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                                  from new_pricingsize where width = LV_WIDTHES and height=in_heightes 
                                  and  regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0';
                                  
                                   lv_sizetype :='NEW_STDSIZE';
                                  EXCEPTION WHEN NO_DATA_FOUND THEN
                                  begin --2
                                      select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1 
                                      into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                                      from new_pricingsize where width = LV_WIDTHES and height=in_heightes 
                                      and  regexp_like ( SERIES,''''||lv_series||'''','i') and model ='0' and style ='0';
                                      
                                       lv_sizetype :='NEW_STDSIZE';
                                      EXCEPTION WHEN NO_DATA_FOUND THEN
                                      begin --3
                                        select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1 
                                        into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                                        from new_pricingsize where width = LV_WIDTHES and height=in_heightes 
                                        and  regexp_like ( STYLE,''''||lv_style||'''','i')and model ='0' and series ='0';
                                      
                                         lv_sizetype :='NEW_STDSIZE';
                                        EXCEPTION WHEN NO_DATA_FOUND THEN
                                      begin --4  -- try united inchees now.
                                          select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype ,clear_minui,withgrid_minui
                                          into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                          from new_pricingsize where ui= 1 and lowerui =0 and upperui=0
                                          and  regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0';
                                           
                                           lv_sizetype :='NEW_CUSTOM';
                                       
                                          EXCEPTION WHEN NO_DATA_FOUND THEN
                                          begin--5
                                              select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,clear_minui,withgrid_minui
                                              into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                              from new_pricingsize where  ui= 1 and lowerui =0 and upperui=0
                                              and  regexp_like ( SERIES,''''||lv_series||'''','i') and model ='0' and style ='0';
                                              lv_sizetype :='NEW_CUSTOM';
                                       
                                              EXCEPTION WHEN NO_DATA_FOUND THEN
                                              begin --6
                                                select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,clear_minui,withgrid_minui
                                                into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                                from new_pricingsize where  ui= 1 and lowerui =0 and upperui=0
                                                and  regexp_like ( STYLE,''''||lv_style||'''','i')and model ='0' and series ='0';
                                                lv_sizetype :='NEW_CUSTOM';
                                                EXCEPTION WHEN NO_DATA_FOUND THEN
                                                begin --7  -- try united inchees with bracket.
                                                select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype ,clear_minui,withgrid_minui
                                                into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                                from new_pricingsize where ui= 1 and lowerui < lv_unitedinches and upperui >= lv_unitedinches
                                                and  maxui=0 
                                                and  regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0';
                                                 lv_sizetype :='NEW_CUSTOM_BRACKET';
                                                
                                                EXCEPTION WHEN NO_DATA_FOUND THEN --so far only one case where bracket price with united inches over maxui
                                                begin --8  -- try united inchees with bracket.
                                                
--                                                 select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into lv_sizeid,lv_baseprice from new_pricingsize 
--                                                  where regexp_like ( MODEL,''''||lv_model||'''','i') and style ='0' and series ='0'
--                                                  and maxui!=0 and maxui < lv_unitedinches;
                                                  
                                                select sizeid,clear + (round(lv_widthes) + round(lv_heightes) - maxui)*  maxperui ,clear_pricetype,withgrid + (round(lv_widthes) + round(lv_heightes) - maxui) * maxperui ,withgrid_pricetype,screen_deduct,screen_deduct_pricetype ,clear_minui,withgrid_minui
                                                into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                                from new_pricingsize where ui= 1 and lowerui <= lv_unitedinches 
                                                and upperui >= lv_unitedinches
                                                and  maxui!=0 and maxui < lv_unitedinches
                                                and  regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0';
                                                 lv_sizetype :='NEW_CUSTOM_BRACKET';
                                                EXCEPTION WHEN NO_DATA_FOUND THEN
                                                begin--9
                                                    select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,clear_minui,withgrid_minui
                                                    into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                                    from new_pricingsize where  ui= 1 and lowerui <= lv_unitedinches and upperui >= lv_unitedinches
                                                    and  maxui=0 
                                                    and  regexp_like ( SERIES,''''||lv_series||'''','i') and model ='0' and style ='0';
                                                     lv_sizetype :='NEW_CUSTOM_BRACKET';
                                                    EXCEPTION WHEN NO_DATA_FOUND THEN
                                                    begin --10
                                                      select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,clear_minui,withgrid_minui
                                                      into lv_sizeid,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                                      from new_pricingsize where  ui= 1 and lowerui <= lv_unitedinches and upperui >= lv_unitedinches
                                                      and  maxui=0 
                                                      and  regexp_like ( STYLE,''''||lv_style||'''','i')and model ='0' and series ='0';
                                                       lv_sizetype :='NEW_CUSTOM_BRACKET';
                                                EXCEPTION WHEN NO_DATA_FOUND THEN
                                                begin --11
                                                  lv_clear:=0;
                                                  lv_clear_pricetype:=0;
                                                  lv_withgrid:=0;
                                                  lv_withgrid_pricetype:=0;
                                                  lv_stdsize := 0;
                                                  lv_screen_deduct :=0;
                                                  lv_screen_deduct_pricetype :=0;
                                                  lv_sizetype :='';
                                                  end;--11
                                                end;--10
                                              end;--9
                                          end;--8
                                        end;--7
                                      end;--6  
                                  end;--5
                                end;--4
                              end;--3  
                            end;--2
                        end;
                         
                        --- we check if we have price and then check if its united inches if not apply price type 
                        --if its united inches but less than mininum ui then apply min price or else apply price type.
                        
                               IF lv_effectiveunit > 1 THEN
                                 lv_clear := lv_effectiveunit * lv_clear;
                                 lv_withgrid := lv_effectiveunit * lv_withgrid;
                                 lv_screen_deduct := lv_effectiveunit * lv_screen_deduct;
                               end if ;
                               
                                  if (lv_clear > 0) then 
                                    if (lv_clear_pricetype = 'UNITEDINCHES' and lv_clear_minui > 0) then
                                        if (LV_WIDTHES+IN_HEIGHTES < lv_clear_minui) then
                                               lv_clear := round (lv_clear_minui * lv_clear,2);
                                        else
                                              lv_clear := applypricetype (lv_clear,lv_clear_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                                         end if;   
                                    else
                                        lv_clear := applypricetype (lv_clear,lv_clear_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                                    end if;
                                 end if ;
                                  
                                  
                                  if (lv_withgrid > 0) then
                                      if (lv_withgrid_pricetype = 'UNITEDINCHES' and lv_withgrid_minui > 0) then
                                          if (LV_WIDTHES+IN_HEIGHTES < lv_withgrid_minui) then
                                              lv_withgrid := round (lv_withgrid_minui/lv_withgrid,2);
                                           else     
                                              lv_withgrid := applypricetype (lv_withgrid,lv_withgrid_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));   
                                           end if; 
                                      else     
                                        lv_withgrid := applypricetype (lv_withgrid,lv_withgrid_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                                     end if;
                                 end if; 
                                 
--                                  if (lv_withgrid_pricetype = 'UNITEDINCHES' or lv_clear_pricetype = 'UNITEDINCHES') then
--                                    lv_sizetype :='NEW_CUSTOM';
--                                  end if;
--                                  
                                  --IN_STDSIZE := lv_stdsize;
                              
                            
                                  --NOw check if part or no screen and handle accordingly.
                                  if (lv_part = 1) then
                                    lv_screendeduct :=1;
                                    
                                    --proc_WriteToPricingLog ('BASE',lv_sizeid,lv_screen_deduct);
                                    
                                    RETURN lv_screen_deduct;
                                  else
                                  
                                    --if (LV_SCREENTYPE = 'No Screen' ) then --we decide whether screendeduct for windows in func_getprice itself
                                    if (lv_screendeduct =1) then
                                      lv_clear := lv_clear - lv_screen_deduct;
                                      lv_withgrid := lv_withgrid - lv_screen_deduct;
                                    end if;
                                    
                                    if (lv_hasgrid = 0) then
                                      --proc_WriteToPricingLog ('BASE',lv_sizeid,lv_clear);
                                      RETURN lv_clear;
                                    else 
                                      --proc_WriteToPricingLog ('BASE',lv_sizeid,lv_withgrid);
                                      RETURN lv_withgrid;
                                    end if ;     
                                  
                                  end if; -- lv_part =1 
                                  
                                  
                        else  --replacemenet
                               
                                    if ((lv_sections >=3) or (lv_style = 'GW')) then --only baybow
                                      begin--1
                                        select sizeid,bb_price into lv_sizeid,lv_baseprice  from new_pricingsize 
                                          where regexp_like ( style,''''||lv_style||'''','i') and model ='0' and series ='0'
                                          and sections = lv_sections
                                          and width_lower <= floor(IN_WIDTHES) and width_upper >= floor(IN_WIDTHES)
                                          and height_lower <= floor(IN_HEIGHTES) and height_upper >= floor(IN_HEIGHTES);
                                          
                                          lv_sizetype :='REPL_BRACKET';
                                          EXCEPTION WHEN NO_DATA_FOUND THEN           
                                            begin --2
                                              lv_baseprice:=0;
                                              lv_sizetype :='';
                                            end; --2
                                      
                                      end;--1
                                    
                                    
                                    else -- not baybow
                                            begin --1
                                            
--                                              IF lv_effectiveunit > 1 THEN -- even replacement have continuous so price accordingly
--                                              --we need to "resize" the unit to a fundamental component size based on oracle effective units
--                                              --select func_es_to_es_unit(lv_widthes,1,lv_effectiveunit) into lv_widthes from dual;
--                                              lv_widthes := func_es_to_es_unit(lv_widthes,1,lv_effectiveunit);
--                                              lv_unitedinches := LV_WIDTHES + IN_HEIGHTES;
--                                              
--                                              END IF;
                                                 select sizeid,bracketprice into lv_sizeid,lv_baseprice  from new_pricingsize 
                                                where regexp_like ( MODEL,''''||lv_model||'''','i') and style ='0' and series ='0'
                                                and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                                                lv_sizetype :='REPL_BRACKET';
                                                 EXCEPTION WHEN NO_DATA_FOUND THEN
                                                  begin --2
                                                  select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into lv_sizeid,lv_baseprice from new_pricingsize 
                                                  where regexp_like ( MODEL,''''||lv_model||'''','i') and style ='0' and series ='0'
                                                  and maxui!=0 and maxui < lv_unitedinches;
                                                  lv_sizetype :='REPL_OVERMAXUI';
                                                  EXCEPTION WHEN NO_DATA_FOUND THEN
                                                  begin --3
                                              
                                                    select sizeid,bracketprice into lv_sizeid,lv_baseprice  from new_pricingsize 
                                                    where regexp_like ( SERIES,''''||lv_series||'''','i') and style ='0' and model ='0'
                                                    and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                                                    lv_sizetype :='REPL_BRACKET';
                                                     EXCEPTION WHEN NO_DATA_FOUND THEN
                                                      begin --4
                                                      select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into lv_sizeid,lv_baseprice from new_pricingsize 
                                                      where regexp_like ( SERIES,''''||lv_series||'''','i') and style ='0' and model ='0'
                                                      and maxui!=0 and maxui < lv_unitedinches;
                                                      lv_sizetype :='REPL_OVERMAXUI';
                                                      EXCEPTION WHEN NO_DATA_FOUND THEN
                                                      begin --5
                                                        select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into lv_sizeid,lv_baseprice  from new_pricingsize 
                                                        where regexp_like ( STYLE,''''||lv_style||'''','i') and series ='0' and model ='0'
                                                        and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                                                        lv_sizetype :='REPL_BRACKET';
                                                         EXCEPTION WHEN NO_DATA_FOUND THEN
                                                          begin --6
                                                          select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into lv_sizeid,lv_baseprice from new_pricingsize 
                                                          where regexp_like ( STYLE,''''||lv_style||'''','i') and series ='0' and model ='0'
                                                          and maxui!=0 and maxui < lv_unitedinches;
                                                          lv_sizetype :='REPL_OVERMAXUI';
                                                          EXCEPTION WHEN NO_DATA_FOUND THEN           
                                                          begin --7
                                                            lv_baseprice:=0;
                                                            lv_sizetype :='';
                                                          end; --7
                                                        end; --6
                                                      end; --5
                                                    end;--4
                                                   end;--3
                                                  end;--2
                                                 end;--1
                                        end if; 
                                        --proc_WriteToPricingLog ('BASE',lv_sizeid,lv_baseprice);
                                    IF lv_effectiveunit > 1 THEN
                                       lv_baseprice:= lv_effectiveunit * lv_baseprice;
                                    end if ;
                                 RETURN lv_baseprice;
                              end if; --construction
                  
                  --end if;
                  else --shapes
                  
                  
                   begin --1
                                  select sizeid,clear,clear_pricetype,screen_deduct,screen_deduct_pricetype,1 
                                  into lv_sizeid,lv_clear,lv_clear_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                                  from new_pricingsize where width = LV_WIDTHES and height=in_heightes  and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                                  and  regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0';
                                  lv_stdsize := 1;
                                   lv_sizetype :='SHAPE_STDSIZE';
                                  EXCEPTION WHEN NO_DATA_FOUND THEN
                                  begin --2
                                      select sizeid,clear,clear_pricetype,screen_deduct,screen_deduct_pricetype,1 
                                      into lv_sizeid,lv_clear,lv_clear_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                                      from new_pricingsize where width = LV_WIDTHES and height=in_heightes  and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                                      and  regexp_like ( SERIES,''''||lv_series||'''','i') and model ='0' and style ='0';
                                      lv_stdsize := 1;
                                       lv_sizetype :='SHAPE_STDSIZE';
                                      EXCEPTION WHEN NO_DATA_FOUND THEN
                                      begin --3
                                        select sizeid,clear,clear_pricetype,screen_deduct,screen_deduct_pricetype,1 
                                        into lv_sizeid,lv_clear,lv_clear_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                                        from new_pricingsize where width = LV_WIDTHES and height=in_heightes  and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                                        and  regexp_like ( STYLE,''''||lv_style||'''','i')and model ='0' and series ='0';
                                        lv_stdsize := 1;
                                         lv_sizetype :='SHAPE_STDSIZE';
                                        EXCEPTION WHEN NO_DATA_FOUND THEN
                                      begin --4  -- try united inchees now.
                                      
                                        select sizeid,clear,clear_pricetype
                                          into lv_sizeid,lv_clear,lv_clear_pricetype
                                          from new_pricingsize where ui= 1
                                          and  regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0' and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                                          and ((lowerui < lv_unitedinches and upperui >= lv_unitedinches) or (lowerui=0 and upperui = 0)) ;
                
                                          lv_sizetype :='SHAPE_BRACKET';
                                       
                                          EXCEPTION WHEN NO_DATA_FOUND THEN
                                          begin--5
                                          
                                            select sizeid,clear,clear_pricetype
                                              into lv_sizeid,lv_clear,lv_clear_pricetype
                                              from new_pricingsize where  ui= 1 
                                              and  regexp_like ( SERIES,''''||lv_series||'''','i') and model ='0' and style ='0' and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                                              and ((lowerui < lv_unitedinches and upperui >= lv_unitedinches) or (lowerui=0 and upperui = 0)) ;
                                              
                                              
                                              lv_sizetype :='SHAPE_BRACKET';
                                       
                                              EXCEPTION WHEN NO_DATA_FOUND THEN
                                              begin --6
                                              
                                               select sizeid,clear,clear_pricetype
                                                into lv_sizeid,lv_clear,lv_clear_pricetype
                                                from new_pricingsize where  ui= 1
                                                and  regexp_like ( STYLE,''''||lv_style||'''','i')and model ='0' and series ='0' and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                                                and ((lowerui < lv_unitedinches and upperui >= lv_unitedinches) or (lowerui=0 and upperui = 0)) ;
                                                
                                                lv_sizetype :='SHAPE_BRACKET';
                                       
                                                EXCEPTION WHEN NO_DATA_FOUND THEN
                                                begin --7
                                                  lv_clear:=0;
                                                  lv_clear_pricetype:=0;
                                                 -- lv_baseprice:=0;
                                                  lv_sizetype :='';
                                                end;--7
                                              end;--6  
                                          end;--5
                                        end;--4
                                      end;--3  
                                    end;--2
                              end;
                          
                           -- IN_STDSIZE := lv_stdsize;
                            
                             if (lv_clear > 0)  then
                                
                                if (lv_part = 1) then -- check if its a screen only or has no screen
                                      lv_screendeduct :=1;
                                      RETURN lv_screen_deduct;
                                else
                                     -- if (LV_SCREENTYPE = 'No Screen') then
                                       if (lv_screendeduct =1) then
                                        lv_clear := lv_clear - lv_screen_deduct;
                                       end if;
                                end if;
                                
                                
                              
                              if (lv_construction = 'R') then 
                                lv_clear := applypricetype (lv_clear,lv_clear_pricetype,FLOOR(IN_WIDTHES),FLOOR(IN_HEIGHTES));
                              else
                                lv_clear := applypricetype (lv_clear,lv_clear_pricetype,CEIL(IN_WIDTHES),CEIL(IN_HEIGHTES));
                              end if;
                              
                              ------now check if its HD stacking sill if so add the price addon.
                              begin
                                select price,pricetype into lv_HD_SS, lv_HD_SS_pricetype from new_pricing_config where type = 'SHAPE_HD' and value = lv_style;
                                exception when no_data_found then
                                begin
                                  lv_hd_ss :=0;
                                  lv_hd_ss_pricetype := '';
                                
                                end;
                             end;
                             if lv_HD_SS >0 then
                                  lv_clear := lv_clear + lv_HD_SS;
                                  proc_WriteToPricingLog ('HD Stacking Sill Charge',0,lv_HD_SS);
                                end if;
                            end if;
                            
                            return lv_clear;
                  
                  end if ; -- if shapes
                  
         else --doors
            begin 
                  begin --1
                      select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1,
                      
                      case 
                        when regexp_like (nonwhite_color,''''||lv_FRAMECOLORIN||'''','i') then nonwhite
                        when regexp_like (painted_color,''''||lv_FRAMECOLORIN||'''','i') then painted
                        when regexp_like (laminate_color,''''||lv_FRAMECOLORIN||'''','i') then laminate
                        else 
                          0 end,
                          
                      case 
                        when regexp_like (nonwhite_color,''''||lv_FRAMECOLORIN||'''','i') then nonwhite_pricetype
                        when regexp_like (painted_color,''''||lv_FRAMECOLORIN||'''','i') then painted_pricetype
                        when regexp_like (laminate_color,''''||lv_FRAMECOLORIN||'''','i') then laminate_pricetype
                        else 
                          '' end,
                      
                      --,nvl(nonwhite,0),nonwhite_pricetype,nvl(painted,0),painted_pricetype
                      nvl(heavy_duty_screen,0), heavy_duty_screen_pricetype,
                      
                      case 
                      when lv_energy in ('Low-E 270','LOW-E 270') then energy_low_e 
                      when lv_energy in ('Low-E 270/Argon','LOW-E 270/ARGON') then energy_low_e_argon 
                      when lv_energy in ('Ultra Low-E','ULTRA LOW-E') then energy_ultra_low_e 
                      when lv_energy in ('Ultra Low-E/Argon','ULTRA LOW-E/ARGON') then energy_ultra_low_e_argon
                      when lv_energy in ('Non Reflective Low-E','NON REFLECTIVE LOW-E') then energy_turtle_low_e 
                      when lv_energy in ('Non Reflective Low-E/Argon','NON REFLECTIVE LOW-E/ARGON') then energy_turtle_low_e_argon
                      else 0 end,
                      energy_pricetype
                      ,
                      case 
                      when regexp_like (moving_panels,''''||lv_screentype||'''','i') then moving_panels_clear
                      when regexp_like (fixed_panels,''''||lv_screentype||'''','i') then fixed_panels_clear
                      else 0 end,
                      
                      case 
                      when regexp_like (moving_panels,''''||lv_screentype||'''','i') then moving_panels_withgrid
                      when regexp_like (fixed_panels,''''||lv_screentype||'''','i') then fixed_panels_withgrid
                      else 0 end
                      ,
                      case 
                      when regexp_like (moving_panels,''''||lv_screentype||'''','i') then moving_panels_pricetype
                      when regexp_like (fixed_panels,''''||lv_screentype||'''','i') then fixed_panels_pricetype
                      else '' end
                      ,
                     
                      case when lv_tintin in ('Gray','Bronze','GRAY','BRONE') then tint_nonclear
                      else 0 end,
                      
                      case when lv_tintin in ('Gray','Bronze','GRAY','BRONE') then tint_nonclear_pricetype
                      else '' end
                          
                      
                      
                      into lv_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize,
                      --lv_nonwhite , lv_nonwhite_pricetype,lv_painted,lv_painted_pricetype
                      lv_door_color , lv_door_color_pricetype
                      ,lv_heavy_duty_screen,lv_heavy_duty_screen_pricetype,lv_doorenergy,lv_doorenergy_pricetype
                      ,lv_panels_clear, lv_panels_withgrid,lv_panels_pricetype
                      ,lv_doortint , lv_doortint_pricetype
                      from new_door_pricingsize where width = LV_WIDTHES and height=in_heightes 
                      and  regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0' and ui = 0
                      and gridstyle  in (case when lv_gridstyle in ('BBG','bbg') then 'BBG' else 'ALL' end) 
                      
                      ;
                      
                       lv_sizetype :='NEW_STDSIZE';
                        EXCEPTION WHEN NO_DATA_FOUND THEN 
                        begin --2
                          
                          
                          select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,0,
                          case 
                        when regexp_like (nonwhite_color,''''||lv_FRAMECOLORIN||'''','i') then nonwhite
                        when regexp_like (painted_color,''''||lv_FRAMECOLORIN||'''','i') then painted
                        when regexp_like (laminate_color,''''||lv_FRAMECOLORIN||'''','i') then laminate
                        else 
                          0 end,
                          
                      case 
                        when regexp_like (nonwhite_color,''''||lv_FRAMECOLORIN||'''','i') then nonwhite_pricetype
                        when regexp_like (painted_color,''''||lv_FRAMECOLORIN||'''','i') then painted_pricetype
                        when regexp_like (laminate_color,''''||lv_FRAMECOLORIN||'''','i') then laminate_pricetype
                        else 
                          '' end,
                          
                          --,nvl(nonwhite,0),nonwhite_pricetype,nvl(painted,0),painted_pricetype,
                          nvl(heavy_duty_screen,0), heavy_duty_screen_pricetype,
                          case 
                          when lv_energy in ('Low-E 270/Argon','LOW-E 270/ARGON') then energy_low_e_argon 
                          when lv_energy in ('Ultra Low-E','ULTRA LOW-E') then energy_ultra_low_e 
                          when lv_energy in ('Ultra Low-E/Argon','ULTRA LOW-E/ARGON') then energy_ultra_low_e_argon
                          when lv_energy in ('Non Reflective Low-E','NON REFLECTIVE LOW-E') then energy_turtle_low_e 
                          when lv_energy in ('Non Reflective Low-E/Argon','NON REFLECTIVE LOW-E/ARGON') then energy_turtle_low_e_argon
                          else 0 end
                           ,
                            energy_pricetype
                            ,
                          case when lv_tintin in ('Gray','Bronze','GRAY','BRONE') then tint_nonclear
                          else 0 end,
                            
                          case when lv_tintin in ('Gray','Bronze','GRAY','BRONE') then tint_nonclear_pricetype
                          else '' end
                          into lv_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize,
                           --lv_nonwhite , lv_nonwhite_pricetype,lv_painted,lv_painted_pricetype
                          lv_door_color , lv_door_color_pricetype
                          
                          ,lv_heavy_duty_screen,lv_heavy_duty_screen_pricetype,lv_doorenergy,lv_doorenergy_pricetype
                          ,lv_doortint, lv_doortint_pricetype
                          from new_door_pricingsize where regexp_like ( MODEL,''''||lv_model||'''','i') and series ='0' and style ='0' and ui = 1;
                          
                          lv_sizetype :='NEW_CUSTOM';
                      
                              EXCEPTION WHEN NO_DATA_FOUND THEN 
                                begin --3
                              
                                lv_clear:=0;
                                lv_clear_pricetype:=0;
                                -- lv_baseprice:=0;
                                lv_sizetype :='';
                                lv_sizeid := 0;
                              end; --3
                        end; --2
                    end; -- 1     
                    
                    
              ---if top or bottom sash or fixed glass is selected not need to calcualte any further pricing.
                       ---if top or bottom sash or fixed glass is selected not need to calcualte any further pricing.
            ---we calcualte lv_lcear and lv_grid becuse of fixed nad moving glass can come in PERC_OF_BASE option.
              if ((lv_panels_clear = 0 and  lv_panels_withgrid = 0 ) or (lv_panels_pricetype = 'TOTALPERC' and lv_panels_clear!=0 and lv_panels_withgrid!=0)) then 
              
                          if lv_clear > 0 then
                            if (LV_GRIDTYPE not in  ('No Grid','SDL' )) then
                              lv_withgrid := applypricetype (lv_withgrid,lv_withgrid_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES),lv_clear);      
                              lv_door_baseprice := lv_withgrid;
                            else 
                              lv_clear := applypricetype (lv_clear,lv_clear_pricetype,CEIL(IN_WIDTHES),CEIL(IN_HEIGHTES));
                              lv_door_baseprice := lv_clear;
                            end if;    
                            
                            if ((LV_SCREENTYPE = 'No Screen' and lv_seat != 'Footbolt' ) or (lv_panels_clear!=0 and lv_panels_withgrid!=0 ))then -- if no screen footbolt is chosen price is same as with screen for doors.
                            -- also for fixed and moving panels we do screen dedduct.,
                              lv_clear := lv_clear - lv_screen_deduct;
                              lv_withgrid := lv_withgrid - lv_screen_deduct;
                            elsif LV_SCREENTYPE in ('Heavy Screen') then
                                
                                lv_heavy_duty_screen := applypricetype (lv_heavy_duty_screen,lv_heavy_duty_screen_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));      
                                 proc_WriteToPricingLog ('HEAVY DUTY SCREEN',lv_sizeid,lv_heavy_duty_screen);
                                 
                                 lv_clear := lv_clear + lv_heavy_duty_screen;
                                lv_withgrid := lv_withgrid + lv_heavy_duty_screen;
                            
                            end if; -- no screen
                          end if ; --lv_clear> 0
                          
                          
                       if lv_door_color > 0 then
                          lv_colorprice := applypricetype (lv_door_color,lv_door_color_pricetype,CEIL(IN_WIDTHES),CEIL(IN_HEIGHTES),lv_door_BASEPRICE);
                          lv_colorprice  := applymultonprice ('COLOR',lv_framecolorin,lv_colorprice);
                           proc_WriteToPricingLog ('COLOR',lv_sizeid,lv_colorprice);
                        end if ;
                    
                    
                      
                      
                    
                          if (LV_GRIDTYPE not in  ('No Grid','SDL' )) then
                            return lv_withgrid;
                          else  
                            return lv_clear;
                          end if;    
                    
            else  
                  lv_stopprocessing := 1; -- switch the stop processing flag on so we dont calculate any other option pricing.
                  if (LV_GRIDTYPE not in  ('No Grid','SDL' )) then
                     lv_panels_withgrid := applypricetype (lv_panels_withgrid,lv_panels_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES),lv_withgrid);    
                     proc_WriteToPricingLog ('FIXED / MOVING SCREEN',lv_sizeid,lv_panels_withgrid);
                      return lv_panels_withgrid;
                  else
                    lv_panels_clear := applypricetype (lv_panels_clear,lv_panels_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES),lv_clear); 
                     proc_WriteToPricingLog ('FIXED / MOVING SCREEN',lv_sizeid,lv_panels_clear);
                      return lv_panels_clear;
                  end if;   
            
            end if ; --  if (lv_panels_clear = 0 and  lv_panels_withgrid = 0 )
                    
            end;  
            
           
         end if ; -- IN_DOOR = 0         
    
  END GETBASEPRICE;
  
  FUNCTION GETCOLOR
  (
  IN_MULLEDUNITS IN NUMBER
  ) RETURN NUMBER AS 
  
  lv_price option_color.price%type;
  
  lv_pricemul OPTION_COLOR.PRICEMUL%type;
  lv_mulledunits number;
  lv_colorid number :=0;
  
  BEGIN
  
  ----NOTE:- ANYTHING ABOVE MULLEDUNITS 1 has different set of rule
    lv_colorpricetype:='';
    
    begin
    
    if (IN_MULLEDUNITS > 1) then
      lv_mulledunits := 2;
    else 
      lv_mulledunits := 1;
    end if ;
    
    select colorID,price ,pricetype,pricemul into lv_COLORID,lv_price,lv_colorpricetype,lv_pricemul from (
     select colorID,price ,pricetype,pricemul  from  option_color
    where (REGEXP_LIKE (style ,''''||lv_style||'''','i') or style = 'ALL') 
    and (sections =lv_SECTIONS or sections = 0)
    and mulledunits = lv_mulledunits
    and REGEXP_LIKE (color ,''''||lv_framecolorin||'''','i')  order by style ,mulledunits desc ,sections desc ) where rownum < 2;
     EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
        lv_price :=0;
      end;
    end;
    
    if (lv_price > 0) then 
  
       lv_price := applypricetype (lv_price,lv_colorpricetype,1,1,lv_BASEPRICE);
       
     -- if ( lv_pricemul != '1') then   
       --lv_price := applypricemul(lv_price,lv_pricemul);
       
        lv_price := applymultonprice ('COLOR',lv_framecolorin,lv_price);
     -- end if;
      proc_WriteToPricingLog ('COLOR',lv_colorid,lv_price);
    end if ;
    
    DBMS_OUTPUT.PUT_LINE('Color price '|| lv_price);
    RETURN lv_price;
  END GETCOLOR;
  
  FUNCTION GETWOODMULLPRICE
  (
    IN_WOOD_MULL IN VARCHAR2 
  ) 
  RETURN NUMBER AS 
  lv_price number :=0;
  lv_pricetype varchar2(50) :='';
  
  lv_wood_mullid number :=0;
  BEGIN
  ---Logic is based on effectiveunit in a window.
  --for eg mulledunits = 1 , item = Cont. TW then it should get effeciveunit_2 price
  --for eg mulleunits = 2 , items = SH & TR then it should get SH -> effectunit = 1 & TR -> effectunit = 1, total effectunit = 2 sp get unit_2 price and then divide and multiply by effect unit for each unit call.
  -- for eg eg mulleunits = 2 , items = Cont TW & TR then it should get Cont TW -> effectunit = 2 & TR -> effectunit = 1, total effectunit = 3 sp get unit_3 price and then divide and multiply by effect unit for each unit call.
    
  
    begin
          if (lv_part = 1 ) then
           select ID, unit_1,pricetype into lv_WOOD_MULLID,lv_price,lv_pricetype
           from OPTION_WOOD_MULL
            where regexp_like (woodsurr_mulltype , ''''||IN_WOOD_MULL||'''','i')
            and (REGEXP_LIKE (style ,''''||lv_STYLE||'''','i') or style = 'ALL')
            and shapes =lv_isSHAPE and parts= lv_part;
          
          else 
    
              if (lv_MULLEDUNITS > 1) then 
      --            begin
                  select * into lv_WOOD_MULLID,lv_price,lv_pricetype from (select ID, case 
                              when lv_TOTALUNITS =1 then unit_1 -- if two same styles are mulled than total unit is 1 so we need to consider mulled units.
                              when lv_TOTALUNITS =2 then unit_2
                              when lv_TOTALUNITS =3 then unit_3
                              when lv_TOTALUNITS =4 then unit_4
                              when lv_TOTALUNITS =5 then unit_5
                              when lv_TOTALUNITS =6 then unit_6
                              end,pricetype  from OPTION_WOOD_MULL
                          where regexp_like (woodsurr_mulltype , ''''||IN_WOOD_MULL||'''','i')
                          and (REGEXP_LIKE (style ,''''||lv_STYLE||'''','i') or style = 'ALL')
                          and shapes =lv_isSHAPE and stdsize =1 order by style) x where  rownum < 2;
              else 
                select * into lv_WOOD_MULLID,lv_price,lv_pricetype from (select ID, case 
                            when lv_EFFECTIVEUNIT =1 or lv_EFFECTIVEUNIT =0 then unit_1
                            when lv_EFFECTIVEUNIT =2 then unit_2
                            when lv_EFFECTIVEUNIT =3 then unit_3
                            when lv_EFFECTIVEUNIT =4 then unit_4
                            when lv_EFFECTIVEUNIT =5 then unit_5
                            when lv_EFFECTIVEUNIT =6 then unit_6
                            end ,pricetype from OPTION_WOOD_MULL
                        where regexp_like (woodsurr_mulltype , ''''||IN_WOOD_MULL||'''','i')
                        and (REGEXP_LIKE (style ,''''||lv_STYLE||'''','i') or style = 'ALL')
                        and shapes =lv_isSHAPE and stdsize =1 order by style) x where  rownum < 2;
                end if;
             end if; 
             Exception when  no_data_found then
                begin 
                  lv_price := 0;
                end;
          
    end ;
  
    if (lv_price > 0) then
      if (lv_MULLEDUNITS >1) then
        lv_price := lv_price/lv_TOTALUNITS * lv_EFFECTIVEUNIT ;
      end if;
       lv_price := applypricetype (lv_price,lv_pricetype,lv_widthes,lv_heightes);
    end if;
  
  --custom size u add 20$ additional per effective unit
    if (lv_STDSIZE != 1 and lv_price >0 and lv_part = 0) then
      BEGIN 
         
         SELECT UNIT_1  INTO LV_WOODCUSTOMADDON  FROM (SELECT UNIT_1 from OPTION_WOOD_MULL
          where regexp_like (woodsurr_mulltype , ''''||IN_WOOD_MULL||'''','i')
          and (REGEXP_LIKE (style ,''''||lv_STYLE||'''','i') or style = 'ALL')
          AND SHAPES = lv_isSHAPE AND STDSIZE = 0 ORDER BY STYLE ) X WHERE ROWNUM < 2;
          Exception when  no_data_found then
          begin 
            LV_WOODCUSTOMADDON  := 0;
          end;
    
        END;
      IF (LV_WOODCUSTOMADDON  >0) THEN 
        ---making sure customaddon gets multiplied.
        lv_price := lv_price + ( LV_WOODCUSTOMADDON * lv_EFFECTIVEUNIT);
        
        proc_WriteToPricingLog ('WOOD/MULL CUSTOM SIZE',0,LV_WOODCUSTOMADDON );
      END IF;
    end if ; --if (lv_STDSIZE != 1) and (lv_price >0 ) then
  
    if (lv_price > 0) then
      proc_WriteToPricingLog ('WOOD/MULL',lv_wood_mullid,round(lv_price,2));
    end if;
    DBMS_OUTPUT.PUT_LINE('WOOD_MULL PRICE IS ' || lv_price);
    
    RETURN round(lv_price,2);
  END GETWOODMULLPRICE;
  
  FUNCTION GETSEATPRICE
  
  RETURN NUMBER AS 
  
  lv_price number :=0;
  lv_pricetype option_seat.price_type%TYPE;
  --lv_pricemul option_seat.pricemul%type;
  lv_seatid option_seat.ID%TYPE;
  
  
  BEGIN
  
    begin
      --select * into lv_price,lv_pricetype,lv_pricemul,lv_seatid from ( select price,price_type,pricemul,id  from option_seat
      select * into lv_price,lv_pricetype,lv_seatid from ( select price,price_type,id  from option_seat
      where regexp_like (constructioncode,''''||lv_construction||'''','i')
      and regexp_like (seat,''''||lv_SEAT||'''','i') 
      and (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL')
      and (regexp_like (style,''''||lv_Style||'''','i') or style = 'ALL')  
      and (regexp_like (framecolorin,''''||lv_FRAMECOLORIN||'''','i') or framecolorin = 'ALL')
      order by series,style) x where rownum < 2;
      
      EXCEPTION WHEN NO_DATA_FOUND THEN
        begin 
          lv_price :=0;
          lv_seatid:=0;
        end;
      end;  
      
      if (lv_price > 0) then 
        --IN_SEATID := lv_seatid;
        proc_WriteToPricingLog ('SEAT',lv_seatid,lv_price); 
      end if ;
      
      RETURN lv_price;
  END GETSEATPRICE;
  
  FUNCTION GETSCREENMESHPRICE
  (
   IN_SECTIONS IN NUMBER 
  ) 
  RETURN NUMBER AS 
  
  
  lv_price number :=0;
  lv_pricetype option_screenmesh.price_type%TYPE;
  lv_pricemul option_screenmesh.pricemul%type;
  lv_section option_screenmesh.sections%type ;
  lv_screenmeshid option_screenmesh.ID%TYPE;
  --lv_screentype option_screenmesh.screentype%TYPE;
  
  ----nOTE ON SECTIONS IF >=3 IS CONSIDERED 3
  
  BEGIN
    lv_screenmeshid :=0;
  
    if (IN_SECTIONS >= 3) then 
      lv_section :=3 ;
    else 
      lv_section := 2; 
    end if;
    
    begin
    select * into lv_price,lv_pricetype,lv_pricemul,lv_screenmeshid from ( select price,price_type,pricemul,id  from option_screenmesh 
    where regexp_like (constructioncode,''''||lv_construction||'''','i')
    and
    --sections = lv_section and 
    regexp_like (screenmesh,''''||lv_SCREENMESHtype||'''','i') 
    and (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL')
    and (regexp_like (style,''''||lv_Style||'''','i') or style = 'ALL')  
    and part = LV_PART
    and (regexp_like (screentype,''''||lv_SCREENTYPE||'''','i') or screentype = 'ALL')
    order by series,style,screentype) x where rownum < 2;
    
    --IN_SCREENMESHID :=lv_screenmeshid;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
        lv_price :=0;
        lv_SCREENMESHID :=0;
      end;
    end;  
    
       if (lv_price > 0) then
       
       lv_price := applymultonprice ('SCREENMESH',lv_screenmeshtype,lv_price);
       
       
  --     if lv_pricemul != '1' then
  --      lv_price := applypricemul(lv_price,lv_pricemul);
  --    end if;
      proc_WriteToPricingLog ('SCREENMESH',lv_screenmeshid,lv_price);
     end if ; 
  
  RETURN lv_price;
  END GETSCREENMESHPRICE;
  
  FUNCTION GETCOTTAGEORIELPRICE
  RETURN NUMBER AS 
  
  lv_price number :=0;
  lv_pricetype option_cottageoriel.price_type%TYPE;
  lv_pricemul option_cottageoriel.price_mul%type;
  lv_cottageorielid option_cottageoriel.ID%type;
  
  BEGIN
  
  
  begin
    select price,price_type,price_mul,id  into lv_price,lv_pricetype,lv_pricemul,lv_cottageorielid from  option_cottageoriel
    where 
    constructioncode= lv_construction
    and regexp_like (type,''''||lv_cottageoriel||'''','i')
    and clmr = LV_CLMR;
  
    
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
        lv_price :=0;
        lv_cottageorielid :=0;
      end;
    end;  
    
    
   if (lv_price > 0) then 
          lv_price := applymultonprice ('COTTAGE/ORIEL',lv_cottageoriel,lv_price);
  --     if lv_pricemul != '1' then
  --      lv_price := applypricemul(lv_price,lv_pricemul);
  --    end if;
     proc_WriteToPricingLog ('COTTAGE/ORIEL',lv_cottageorielid, lv_price);
     end if ; 
  
    RETURN lv_price;
    
    
  END GETCOTTAGEORIELPRICE;
  
  FUNCTION GETFOAMPRICE
  
  RETURN NUMBER AS 
  
  lv_price number :=0;
  lv_pricetype option_foamwrap.price_type%TYPE;
  lv_pricemul option_foamwrap.pricemul%type;
  lv_foamwrapid option_foamwrap.ID%type;
  
  
  BEGIN
  
    begin
  
    select price,price_type,pricemul,id  into lv_price,lv_pricetype,lv_pricemul,lv_foamwrapid from
    (select price,price_type,pricemul,id  from  option_foamwrap
    where 
    type= lv_foamwrap
    and (regexp_like (series,''''||LV_SERIES||'''','i') or series = 'ALL')
    and (regexp_like (style,''''||LV_Style||'''','i') or style = 'ALL') order by series,style) x where rownum < 2;
  
    EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
        lv_price :=0;
        lv_foamwrapid :=0;
      end;
    end;  
    
    
   if (lv_price > 0) then 
  --     if lv_pricemul != '1' then
  --      lv_price := applypricemul(lv_price,lv_pricemul);
  --    end if;
      proc_WriteToPricingLog ('FOAMWRAP',lv_ruleid,lv_foamwrapprice);   
    end if ; 
   
    RETURN lv_price;
  END GETFOAMPRICE;
  
  FUNCTION GETHARDWAREPRICE
  (
   IN_SECTIONS IN NUMBER 
  ) 
  RETURN NUMBER AS 
  
  lv_price number :=0;
  
  --lv_sections  option_hardware.sections%type;
  lv_pricetype option_hardware.price_type%TYPE;
  --lv_pricemul option_hardware.pricemul%type;
  
  lv_hardwareid option_hardware.ID%type;
  lv_accessoryid option_hardware.ID%type;
  lv_egressid option_hardware.ID%type;
  lv_color_mult number := 0;
  
  
  BEGIN
  
  --get hardwarecolor _type price---
    lv_hardwaretype_colorprice :=0;
    lv_hardwareaccessoryprice  :=0;
    lv_hardwareegressprice     :=0;
  
  --  if (IN_SECTIONS >= 3) then lv_sections :=3 ;
  --  else lv_sections := 2; end if;
    
    if (lv_hardwareTYPE !='0' or lv_hardwareCOLOR !='0') then
    begin --1
     select *   into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from (  select price,price_type,id  from option_hardware 
      where ( regexp_like (type,''''||lv_hardwareTYPE||'''','i') ) and color ='0'
      and  regexp_like (category,''''||lv_CATEGORY||'''','i') 
      and  (regexp_like (frame_color,''''||lv_framecolorin||'''','i') or frame_color = 'ALL') order by category,frame_color ) x  where rownum <2;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        begin --2
          select price,price_type,id  into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from option_hardware 
          where ( regexp_like (type,''''||lv_hardwareTYPE||'''','i'))  and color ='0'
          and  regexp_like (SERIES,''''||lv_SERIES||'''','i') ;
          EXCEPTION WHEN NO_DATA_FOUND THEN
            begin --3
            select price,price_type,id  into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from option_hardware 
            where ( regexp_like (type,''''||lv_hardwareTYPE||'''','i'))  and color ='0'
            and  regexp_like (STYLE,''''||lv_STYLE||'''','i') ;
            EXCEPTION WHEN NO_DATA_FOUND THEN
              begin --4 
                select price,price_type,id  into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from option_hardware 
                where ( regexp_like (color,''''||lv_hardwareCOLOR||'''','i'))  and type ='0'
                and  (regexp_like (STYLE,''''||lv_STYLE||'''','i') or style = 'ALL' )
                and  (regexp_like (SERIES,''''||lv_SERIES||'''','i') or series = 'ALL' )
               -- and sections = lv_sections
                order by style desc, series;
              
                lv_color_mult :=1;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                begin --5
                  lv_hardwaretype_colorprice := 0;
                  lv_hardwareid :=0;
                end; --5
              end; --4
            end;--3
          end ;--2
        end;--1
    end if ;
    
    if (lv_hardwaretype_colorprice > 0 )then
      if (lv_color_mult = 0) then
        lv_hardwaretype_colorprice := applymultonprice ('HARDWARE COLOR/TYPE',lv_hardwareTYPE,lv_hardwaretype_colorprice);
      else
        lv_hardwaretype_colorprice := applymultonprice ('HARDWARE COLOR/TYPE',lv_hardwareCOLOR,lv_hardwaretype_colorprice);
      end if;
    end if;
          
    
  --NOW get accessory
  
    if (lv_hardwareACCESSORY!='0') then
      begin
        select price,price_type,id  into lv_hardwareaccessoryprice,lv_pricetype,lv_accessoryid from option_hardware 
        where ( regexp_like (accessory,''''||lv_hardwareACCESSORY||'''','i') ) and color ='0' and type = '0'
        and  regexp_like (SERIES,''''||lv_SERIES||'''','i');
        EXCEPTION WHEN NO_DATA_FOUND THEN
        begin 
          lv_hardwareaccessoryprice :=0;
          lv_accessoryid :=0;
        end;
      end ;
    end if;
    
    if (lv_hardwareaccessoryprice > 0 )then
      lv_hardwareaccessoryprice := applymultonprice ('HARDWARE ACCESSORY',lv_hardwareACCESSORY,lv_hardwareaccessoryprice);
    end if;
    
    ---Get egrress
    
    if (lv_EGRESS!='0') then
        begin
          select price,price_type,id  into lv_hardwareegressprice,lv_pricetype,lv_egressid from option_hardware 
          where ( regexp_like (egress,''''||lv_EGRESS||'''','i') ) and color ='0' and type = '0' and accessory = '0'
          and  regexp_like (STYLE,''''||lv_STYLE||'''','i');
          EXCEPTION WHEN NO_DATA_FOUND THEN
          begin 
            lv_hardwareegressprice :=0;
            lv_egressid :=0;
          end;
        end ;
    end if;
    
     if (lv_hardwareegressprice > 0 )then
      lv_hardwareegressprice := applymultonprice ('HARDWARE EGRESS',lv_EGRESS,lv_hardwareegressprice);
    end if;
  
    
  lv_price := lv_hardwaretype_colorprice + lv_hardwareaccessoryprice + lv_hardwareegressprice;
  
    if (lv_hardwaretype_colorprice!=0) then proc_WriteToPricingLog ('HARDWARE COLOR/TYPE',lv_hardwareid,lv_hardwaretype_colorprice); end if;
    if (lv_hardwareegressprice!=0) then proc_WriteToPricingLog ('HARDWARE EGRESS',lv_egressid,lv_hardwareegressprice); end if;
    if (lv_hardwareaccessoryprice!=0) then proc_WriteToPricingLog ('HARDWARE ACCESSORY',lv_accessoryid,lv_hardwareaccessoryprice); end if;
    if (lv_price!=0) then proc_WriteToPricingLog ('HARDWARE',0,lv_price); end if;
  
  
  Return lv_price;
  END GETHARDWAREPRICE;
  
  FUNCTION GETDRYWALLPRICE
  RETURN NUMBER AS 
  
  lv_price number :=0;
  lv_pricetype option_drywall.pricetype%TYPE;
  lv_pricemul option_drywall.pricemul%type;
  lv_drywallid option_drywall.ID%type;
  
  
  BEGIN
  
  begin
    select * into lv_price,lv_pricetype,lv_pricemul,lv_drywallid from ( select price,pricetype,pricemul,id  from option_drywall
    where regexp_like (style,''''||lv_STYLE||'''','i') 
    and (regexp_like (framecolor,''''||lv_FRAMECOLORin||'''','i') )
    order by style) x where rownum < 2;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
        lv_price :=0;
        lv_drywallid:=0;
      end;
    end;  
    
    --IN_DRYWALLID := lv_drywallid;
  
    if (lv_price!=0) then proc_WriteToPricingLog ('DRYWALL',lv_drywallid,lv_price); end if;
  
    RETURN lv_price;
  END GETDRYWALLPRICE;
  
  FUNCTION GETSASHACCESSORYPRICE
  RETURN NUMBER AS 
  
  lv_price number :=0;
  lv_pricetype option_sashaccessory.pricetype%TYPE;
  --lv_pricemul option_sashaccessory.pricemul%type;
  lv_sashaccessoryid option_sashaccessory.ID%type;
  
  
  BEGIN
    begin
        select * into lv_price,lv_pricetype,lv_sashaccessoryid from ( select price,pricetype,id  from option_sashaccessory
        where type = lv_sashaccessory
        and construction = lv_CONSTRUCTION
        and (regexp_like (style,''''||lv_STYLE||'''','i') or style = 'ALL' )
        and (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL' )
        and part = lv_PART
        order by style,series) x where rownum < 2;
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
          begin 
            lv_price :=0;
            lv_sashaccessoryid:=0;
          end;
     end ;
    
    if (lv_price > 0) then
     -- lv_price := applypricemul(lv_price,lv_pricemul);
        lv_price := applymultonprice ('SASH ACCESSORY',lv_sashaccessory,lv_price);
    end if;
    
    --IN_sashaccessoryID := lv_sashaccessoryid;
    if (lv_price!=0) then proc_WriteToPricingLog ('SASH ACCESSORY',lv_sashaccessoryid,lv_price); end if;
    RETURN lv_price;
    
  END GETSASHACCESSORYPRICE;
  
  FUNCTION GETOTHEROPTIONPRICE (IN_OPTIONNAME IN VARCHAR2 , IN_VALUE IN VARCHAR2 , OUT_ID OUT NUMBER)
  
  RETURN NUMBER AS 
  lv_price number := 0;
  lv_ID number := 0;
  lv_otherspricetype option_others.pricetype%TYPE;
  
  BEGIN
    begin 
      select price,id,pricetype into lv_price,lv_id,lv_otherspricetype from 
      (select price ,id,pricetype from option_others 
      where optionname = IN_optionname
      
  --and ( case when ( IN_optionname = '') then (1)
  --            when ( :p1_linenumber is null ) then (1)
  --            else 0 end)=1
      and (regexp_like (value,''''||IN_VALUE||'''','i') or value = '-')
      and (regexp_like (style,''''||lv_STYLE||'''','i') or style = 'ALL' )
      and (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL' )
      
      and ( ( IN_OPTIONNAME = 'LOCKS' and (widthes != 1 or heightes != 1 ) ) 
      or (IN_OPTIONNAME != 'LOCKS' and widthes = 1 and heightes = 1) --need to check if this is redundant condition
       or (IN_OPTIONNAME = 'LOCKS' and (series!='ALL' or style!='ALL'))) 
      
      and ( ( IN_OPTIONNAME = 'FINS' and mulledunits <= lv_mulledunits ) or (IN_OPTIONNAME != 'FINS' and mulledunits=0))
      order by series,style) x where rownum < 2;
    
      exception when no_data_found then 
      begin 
        lv_price := 0;
        lv_id := 0;
      end;
    
    end ;
    
    if (lv_price > 0) then
      if (lv_otherspricetype != 'FIXED') then
        lv_price := applypricetype (lv_price,lv_otherspricetype,lv_WIDTHES,lv_HEIGHTES);
      end if;
      lv_price := applymultonprice (IN_OPTIONNAME,IN_VALUE,lv_price);
    end if;
    OUT_ID := lv_id;
  RETURN lv_price;
  
  END GETOTHEROPTIONPRICE; 
  
  FUNCTION GETSCREENPRICE
  (
   IN_SECTIONS IN NUMBER
  ) 
  RETURN NUMBER AS 
  
  lv_price number :=0;
  lv_pricetype option_screen.price_type%TYPE;
  --lv_pricemul option_screen.pricemul%type;
  lv_section option_screen.sections%type ;
  lv_screenid option_screen.ID%TYPE;
  
  --changes
  -- 1/21  :- c1:-  removed classification based on sections instead used stylecode. 
  
  BEGIN
    
    lv_TOTALPERC :=0;
    --if sections >=3 has same price
  --  if (IN_SECTIONS >= 3) then lv_section :=3 ;
  --  else lv_section := 2; end if;
    
    -- make different version of fixed glass value to be standard.
    if (LV_SCREENTYPE like 'FIXED%') then 
    lv_screentype := 'FIXED GLASS ONLY';
    --else
    --lv_screentype := IN_SCREENTYPE;
    end if;
    
  if (lv_panels_pricetype !='TOTALPERC'  and lv_panels_clear=0 and lv_panels_withgrid=0  ) then -- we are applying door fixed and moving screen price....
  begin
    select * into lv_price,lv_pricetype,lv_screenid from ( select price,price_type,id  from option_screen 
    where regexp_like (constructioncode,''''||lv_construction||'''','i')
   -- and (sections = lv_section or sections = 0) -- c1
    and regexp_like (screen,''''||lv_screentype||'''','i') 
    and (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL')
    and (regexp_like (style,''''||lv_Style||'''','i') or style = 'ALL') 
    and parts =lv_part
    and regexp_like(stdsize, lv_stdsize)
    order by series,style) x where rownum < 2;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
        lv_price :=0;
        lv_SCREENID :=0;
      end;
      
    end;  
     
      if (lv_price > 0) then 
       
  --     if lv_pricemul != '1' then
  --      lv_price := applypricemul(lv_price,lv_pricemul);
  --    end if;
      
      lv_price := applymultonprice ('SCREEN',lv_screentype,lv_price);
      
      if (lv_pricetype = 'TOTALPERC') then
            lv_TOTALPERC:= lv_price;
            proc_WriteToPricingLog ('FIXED / MOVING SCREEN',lv_screenid,lv_price);
            
            --sum everything so far and do percent on that.
            
            lv_price := - ((lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice +lv_cottageorielprice + lv_foamwrapprice + lv_spacerprice+lv_lockprice+lv_hardwareprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice +lv_smrprice +lv_screenmeshprice + lv_warrantyprice+lv_finprice+lv_hingedeductprice+lv_high_performanceprice)
             *(100-lv_totalperc)/100 );
         
       else 
         lv_TOTALPERC:= 0;
       end if; 
       
      
       
       
       proc_WriteToPricingLog ('SCREEN',lv_screenid,lv_price);
    
     end if ; --lv_price > 0
    else 
           if (lv_panels_pricetype ='TOTALPERC'  and lv_panels_clear!=0 and lv_panels_withgrid!=0 ) then --redundand but making sure nothing other than doors go in this otherwise it would be zero priced.
                  if (lv_hasgrid =0) then
                   proc_WriteToPricingLog ('FIXED / MOVING SCREEN',lv_doorid,lv_panels_clear);
                   lv_price := - ((lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice +lv_cottageorielprice + lv_foamwrapprice + lv_spacerprice+lv_lockprice+lv_hardwareprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice +lv_smrprice +lv_screenmeshprice + lv_warrantyprice+lv_finprice+lv_hingedeductprice+lv_high_performanceprice)
                    *(100-lv_panels_clear)/100 );
                     
                else
                 proc_WriteToPricingLog ('FIXED / MOVING SCREEN',lv_doorid,lv_panels_withgrid);
                  lv_price := - ((lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice +lv_cottageorielprice + lv_foamwrapprice + lv_spacerprice+lv_lockprice+lv_hardwareprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice +lv_smrprice +lv_screenmeshprice + lv_warrantyprice+lv_finprice+lv_hingedeductprice+lv_high_performanceprice)
                    *(100-lv_panels_withgrid)/100 );
                end if;
              
                proc_WriteToPricingLog ('SCREEN',lv_doorid,lv_price);
              end if;
    
    end if;
  
   --IN_SCREENID :=lv_screenid;
   
    RETURN lv_price;
    
  END GETSCREENPRICE;
  
  FUNCTION EXCEPTION_GETBASEPRICE
  (
    IN_WIDTHES IN NUMBER
  , IN_HEIGHTES IN NUMBER
  , EXCEPTION_ID IN VARCHAR2
  ) 
  RETURN NUMBER AS 
  
  lv_widthes NUMBER := IN_WIDTHES;
  lv_heightes NUMBER := IN_HEIGHTES;
  lv_unitedinches number:= lv_WIDTHES + lv_HEIGHTES;
  
  lv_clear                    new_exceptions_base.clear%type;
  lv_clear_pricetype          new_exceptions_base.clear_Pricetype%type;
  lv_withgrid                 new_exceptions_base.withgrid%type;
  lv_withgrid_pricetype       new_exceptions_base.withgrid_pricetype%type;
  lv_screen_deduct            new_exceptions_base.screen_deduct%type;  
  lv_screen_deduct_pricetype  new_exceptions_base.screen_deduct_pricetype%type;
  lv_clear_minui              new_exceptions_base.clear_minui%type;
  lv_withgrid_minui           new_exceptions_base.withgrid_minui%type;
  
  BEGIN
   lv_ex_sizeid  :=0; 
   ---FOR NEW CONSTRUCTION UNited inches  = CEIL(WIDTHES) + CEIL(HEIGHTES) and for replacement  floor(...
   --since we are getting records baased on descid we dont have to look for model ,series ,style 
    --DETERMINE WHICH FIELDS to choose what orders etc ---
    
    --IF (IN_gridtype in ('No Grid','SDL') or (IN_gridstyle not in ('Colonial','Contour' , 'Contour Valance' ))) then
    
     IF lv_effectiveunit > 1 THEN
            --we need to "resize" the unit to a fundamental component size based on oracle effective units
             --select func_es_to_es_unit(lv_widthes,1,lv_effectiveunit) into lv_widthes from dual;
             lv_widthes := func_es_to_es_unit(lv_widthes,1,lv_effectiveunit);
             lv_unitedinches := LV_WIDTHES + IN_HEIGHTES;
     END IF;
     
      if (lv_isSHAPE !=1) then       
                  
            if (LV_CONSTRUCTION = 'N') THEN
              begin --1
                    select ex_sizeid ,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1
                    into lv_ex_sizeid ,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                    from new_exceptions_base where width = LV_WIDTHES and height=in_heightes 
                    and desc_base= exception_id;
                          EXCEPTION WHEN NO_DATA_FOUND THEN
                        begin --4  -- try united inchees now.
                            select ex_sizeid ,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype ,clear_minui,withgrid_minui,0
                            into lv_ex_sizeid ,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui,lv_stdsize
                            from new_exceptions_base where ui= 1
                            and desc_base= exception_id;
                                  EXCEPTION WHEN NO_DATA_FOUND THEN
                                  begin --7
                                    lv_clear:=0;
                                    lv_clear_pricetype:=0;
                                    lv_withgrid:=0;
                                    lv_withgrid_pricetype:=0;
                                  --  lv_stdsize := 0;
                                    lv_screen_deduct :=0;
                                    lv_screen_deduct_pricetype :=0;
                                    lv_sizetype :='';
                                  end;--7
                          end;--4
                end;
   
          
          --- we check if we have price and then check if its united inches if not apply price type 
          --if its united inches but less than mininum ui then apply min price or else apply price type.
          
                 IF lv_effectiveunit > 1 THEN
                   lv_clear := lv_effectiveunit * lv_clear;
                   lv_withgrid := lv_effectiveunit * lv_withgrid;
                   lv_screen_deduct := lv_effectiveunit * lv_screen_deduct;
                 end if ;
                 
                    if (lv_clear > 0) then 
                      if (lv_clear_pricetype = 'UNITEDINCHES' and lv_clear_minui > 0) then
                          if (LV_WIDTHES+IN_HEIGHTES < lv_clear_minui) then
                                 lv_clear := round (lv_clear_minui / lv_clear,2);
                          else
                                lv_clear := applypricetype (lv_clear,lv_clear_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                           end if;   
                      else
                          lv_clear := applypricetype (lv_clear,lv_clear_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                      end if;
                   end if ;
                    
                    
                    if (lv_withgrid > 0) then
                        if (lv_withgrid_pricetype = 'UNITEDINCHES' and lv_withgrid_minui > 0) then
                            if (LV_WIDTHES+IN_HEIGHTES < lv_withgrid_minui) then
                                lv_withgrid := round (lv_withgrid_minui/lv_withgrid,2);
                             else     
                                lv_withgrid := applypricetype (lv_withgrid,lv_withgrid_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));   
                             end if; 
                        else     
                          lv_withgrid := applypricetype (lv_withgrid,lv_withgrid_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                       end if;
                   end if; 
                   
                    if (lv_withgrid_pricetype = 'UNITEDINCHES' or lv_clear_pricetype = 'UNITEDINCHES') then
                      lv_sizetype :='NEW_CUSTOM';
                    end if;
                    
                    --IN_STDSIZE := lv_stdsize;
                
              
                    --NOw check if part or no screen and handle accordingly.
                    if (lv_part = 1) then
                      lv_screendeduct :=1;
                      
                      --proc_WriteToPricingLog ('BASE',lv_ex_sizeid ,lv_screen_deduct);
                      
                      RETURN lv_screen_deduct;
                    else
                    
                      if (LV_SCREENTYPE = 'No Screen' ) then
                        lv_screendeduct :=1;
                        lv_clear := lv_clear - lv_screen_deduct;
                        lv_withgrid := lv_withgrid - lv_screen_deduct;
                      end if;
                      
                      if (lv_hasgrid = 0) then
                        --proc_WriteToPricingLog ('BASE',lv_ex_sizeid ,lv_clear);
                        RETURN lv_clear;
                      else 
                        --proc_WriteToPricingLog ('BASE',lv_ex_sizeid ,lv_withgrid);
                        RETURN lv_withgrid;
                      end if ;     
                    
                    end if; -- lv_part =1 
                    
                    
          else  --replacemenet
                 
                      if (lv_sections >=3) then --only baybow
                        begin--1
                          select ex_sizeid ,bb_price into lv_ex_sizeid ,lv_baseprice  from new_exceptions_base 
                            where regexp_like ( style,''''||lv_style||'''','i') and (model ='0'  or model ='-' ) and (series ='0' or series = '-')
                            and sections = lv_sections
                            and width_lower <= floor(IN_WIDTHES) and width_upper >= floor(IN_WIDTHES)
                            and height_lower <= floor(IN_HEIGHTES) and height_upper >= floor(IN_HEIGHTES) and desc_base= exception_id;
                            
                            lv_sizetype :='REPL_BRACKET';
                            EXCEPTION WHEN NO_DATA_FOUND THEN           
                              begin --2
                                lv_baseprice:=0;
                                lv_sizetype :='';
                              end; --2
                        
                        end;--1
                      
                      
                      else -- not baybow
                              begin --1
                                 select ex_sizeid ,bracketprice into lv_ex_sizeid ,lv_baseprice  from new_exceptions_base 
                                  where 
                                  lowerui < lv_unitedinches and upperui >= lv_unitedinches and desc_base= exception_id;
                                   EXCEPTION WHEN NO_DATA_FOUND THEN
                                    begin --2
                                    select ex_sizeid ,maxuiprice + (lv_unitedinches - maxui)*maxperui into lv_ex_sizeid ,lv_baseprice from new_exceptions_base 
                                    where 
                                    desc_base= exception_id
                                    and maxui!=0 and maxui < lv_unitedinches;
                                    lv_sizetype :='REPL_OVERMAXUI'; 
                                            EXCEPTION WHEN NO_DATA_FOUND THEN           
                                            begin --7
                                              lv_baseprice:=0;
                                              lv_sizetype :='';
                                            end; --7
                                    end;--2
                                   end;--1
                          end if; 
                   RETURN lv_baseprice;
                end if; --construction
    
    --end if;
    else
    
    
     begin --1
                    select ex_sizeid ,clear,clear_pricetype,screen_deduct,screen_deduct_pricetype
                    into lv_ex_sizeid ,lv_clear,lv_clear_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype
                    from new_exceptions_base where width = LV_WIDTHES and height=in_heightes  and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                    and desc_base= exception_id ;
                     lv_sizetype :='SHAPE_STDSIZE';
                          EXCEPTION WHEN NO_DATA_FOUND THEN
                        begin --4  -- try united inchees now.
                        
                          select ex_sizeid ,clear,clear_pricetype
                            into lv_ex_sizeid ,lv_clear,lv_clear_pricetype
                            from new_exceptions_base where ui= 1
                            and regexp_like(tripleeyebrow, lv_tripleeyebrow)
                            and ((lowerui < lv_unitedinches and upperui >= lv_unitedinches) or (lowerui=0 and upperui = 0)) and desc_base= exception_id ;
                            lv_sizetype :='SHAPE_BRACKET';
                         
                         
                                  EXCEPTION WHEN NO_DATA_FOUND THEN
                                  begin --7
                                    lv_clear:=0;
                                    lv_clear_pricetype:=0;
                                    lv_sizetype :='';
                                  end;--7
                          end;--4
                end;
               if (lv_clear > 0)  then
                  
                  if (lv_part = 1) then -- check if its a screen only or has no screen
                        lv_screendeduct :=1;
                        RETURN lv_screen_deduct;
                  else
                        if (LV_SCREENTYPE = 'No Screen') then
                          lv_screendeduct :=1;
                          lv_clear := lv_clear - lv_screen_deduct;
                         end if;
                  end if;
                
                if (lv_construction = 'R') then 
                  lv_clear := applypricetype (lv_clear,lv_clear_pricetype,FLOOR(IN_WIDTHES),FLOOR(IN_HEIGHTES));
                else
                  lv_clear := applypricetype (lv_clear,lv_clear_pricetype,CEIL(IN_WIDTHES),CEIL(IN_HEIGHTES));
                end if;
              end if;
            
              
              return lv_clear;
    
    end if ; -- if shapes
    
  END EXCEPTION_GETBASEPRICE;
  
  FUNCTION  APPLYEXCEPTION
  (
    IN_APPLYON IN VARCHAR2
  , IN_PRICE IN NUMBER
  , IN_DISCOUNTTYPE IN VARCHAR2 
  , IN_DISCOUNTVALUE IN NUMBER
  ) RETURN NUMBER AS 
  lv_discountvalue number := IN_DISCOUNTVALUE;
  lv_retprice number := IN_PRICE;
  lv_exvariable varchar2(50) :='';
  lv_multiplier number := 0;
  BEGIN
  --COTTAGE/ORIEL
  --COLOR
  --SCREEN
  --SASH ACCESSORY
  --TINT
  --GRID
  --ENERGY
  --SCREENMESH
  
  --- we are trying to get appropriate discountvalue based on effective unit and sections.
  
  if IN_DISCOUNTTYPE IN (
  --'FIXED','DEDUCTFIXED',
  'FIXED WITH EFFECTIVE UNIT/SECTIONS') then
      
        case IN_APPLYON
      
        when 'COLOR' then lv_discountvalue :=  applymultonprice ('COLOR',lv_framecolorin,lv_discountvalue);
        when 'COTTAGE/ORIEL' then  lv_discountvalue := applymultonprice ('COTTAGE/ORIEL',lv_cottageoriel,lv_discountvalue);
        when 'SCREEN' then  lv_discountvalue := applymultonprice ('SCREEN',lv_screentype,lv_discountvalue); 
        when 'SASH ACCESSORY' then  lv_discountvalue := applymultonprice ('SASH ACCESSORY',lv_sashaccessory,lv_discountvalue);
        when 'TINT' then   lv_discountvalue := applymultonprice ('TINT',lv_tintin,lv_discountvalue);
        when 'GRID' then  lv_discountvalue := applymultonprice ('GRID',lv_gridstyle,lv_discountvalue);
        when 'ENERGY' then  lv_discountvalue := applymultonprice ('ENERGY',lv_energy,lv_discountvalue);
        when 'SCREENMESH' then  lv_discountvalue := applymultonprice ('SCREENMESH',lv_screenmeshtype,lv_discountvalue);
            
      end case;
  
  end if;
  
      case IN_DISCOUNTTYPE 
      
      when 'DEDUCTPERCENTAGE' then 
        lv_retprice := IN_PRICE - (IN_PRICE * IN_DISCOUNTVALUE)/100;
        
      when 'DEDUCTFIXED'  then
      if (lv_sections > 1) then
        lv_retprice := IN_PRICE - (LV_SECTIONS * IN_DISCOUNTVALUE);
       else 
        lv_retprice := IN_PRICE - (LV_EFFECTIVEUNIT * IN_DISCOUNTVALUE);
      end if;
      
      when 'FIXED'  then
        lv_retprice := IN_DISCOUNTVALUE;
    
      when 'FIXED WITH EFFECTIVE UNIT/SECTIONS'  then
        if (lv_sections > 1) then
          lv_retprice := IN_DISCOUNTVALUE * lv_sections;
        elsif (lv_effectiveunit >1) then
          lv_retprice := IN_DISCOUNTVALUE * lv_effectiveunit;
        end if;  
      
       when 'SQFT'     then 
       lv_retprice := IN_DISCOUNTVALUE * (lv_Widthes *lv_heightes)/144;
       
       when 'DEDUCT SQFT'     then 
       lv_retprice := IN_PRICE - IN_DISCOUNTVALUE * (lv_Widthes *lv_heightes)/144;
       
      when '0 - 101'  then
        select NVL(func_get_mult(lv_accountid,lv_customerid,lv_series,lv_style,lv_model,100),0) into lv_multiplier from dual;
        if (lv_multiplier !=0) then 
          lv_retprice:= ROUND((IN_PRICE)/lv_multiplier * 100,2) ;
        else 
          lv_retprice := IN_PRICE;
        end if;
      
      else 
      lv_retprice := IN_PRICE;
      end case;
      
      
      
    RETURN round(lv_retprice,3);
  END APPLYEXCEPTION;
  
  FUNCTION PROCESSEXCEPTIONS
  
  RETURN NUMBER AS
  
  lv_evaluate number :=1;
  lv_temp  number :=0;
  lv_exceptiondesc NEW_EXCEPTIONDESC.descr%type;
  cursor c_exception is 
  --select 
  --case when ( ed.applyon = 'BASE' and (ed.variable1 = 'WIDTH ES' or  ed.variable2 = 'WIDTH ES' or  ed.variable3 = 'WIDTH ES'   or  ed.variable4 = 'WIDTH ES'   or  ed.variable5 = 'WIDTH ES'  )) then 1 
  --else 2 end, -- this is so that we always grab stock size related base rules first and then in that process we will change lv_stdsize = 1 and unitedinches rule wont kick in.
  --EA.ID,EA.DISCOUNTTYPE,ED.ID,ED.applyon,EA.DiscountVALUE ,
  --nvl(ED.Variable1,'0'),nvl(ED.Operator1,'0'),nvl(ED.Value1,'0')
  --,nvl(ED.Variable2,'0'),nvl(ED.Operator2,'0'),nvl(ED.Value2,'0')
  --,nvl(ED.Variable3,'0'),nvl(ED.Operator3,'0'),nvl(ED.Value3,'0')
  --,nvl(ED.Variable4,'0'),nvl(ED.Operator4,'0'),nvl(ED.Value4,'0')
  --,nvl(ED.Variable5,'0'),nvl(ED.Operator5,'0'),nvl(ED.Value5,'0')
  --
  --from NEW_EXCEPTIONS EA 
  --left join NEW_EXCEPTIONDESC ED on EA.EXCEPTIONDESC = ED.ID
  --where accountid = lv_accountid 
  
  -- this OrderIndex just priortizes based on model then series and style once model is exexuted series and style rules wotn be executed similarly once series rules are exceuted style rules ownt be executed.
  select 
  case when ( ed.applyon = 'BASE' and (ed.variable1 = 'WIDTH ES' or  ed.variable2 = 'WIDTH ES' or  ed.variable3 = 'WIDTH ES'   or  ed.variable4 = 'WIDTH ES'   or  ed.variable5 = 'WIDTH ES'  )) then 1 
      when ( ed.applyon = 'BASE' and (ed.variable1 != 'WIDTH ES' and nvl(ed.variable2,'0') != 'WIDTH ES' and nvl(ed.variable3,'0') != 'WIDTH ES' and nvl(ed.variable4,'0') != 'WIDTH ES' and nvl(ed.variable5,'0') != 'WIDTH ES')) then 2
      when ea.model is not null and ea.model!='ALL' and ed.applyon!= 'BASE' then 3
      when ea.series is not null and ea.series!='ALL' and ed.applyon!= 'BASE' then 4
      when ea.style is not null and ea.style!='ALL' and ed.applyon!= 'BASE' then 5
      when  ea.model='ALL' and ed.applyon!= 'BASE' then 6
      when  ea.series='ALL' and ed.applyon!= 'BASE' then 7
      when  ea.style='ALL' and ed.applyon!= 'BASE' then 8
      
      
      else 100 end OrderIndex, -- this is so that we always grab stock size related base rules first and then in that process we will change lv_stdsize = 1 and unitedinches rule wont kick in.
  EA.ID,EA.DISCOUNTTYPE,ED.ID,ED.applyon,EA.DiscountVALUE , ED.DESCR,
  nvl(ED.Variable1,'0'),nvl(ED.Operator1,'0'),nvl(ED.Value1,'0')
  ,nvl(ED.Variable2,'0'),nvl(ED.Operator2,'0'),nvl(ED.Value2,'0')
  ,nvl(ED.Variable3,'0'),nvl(ED.Operator3,'0'),nvl(ED.Value3,'0')
  ,nvl(ED.Variable4,'0'),nvl(ED.Operator4,'0'),nvl(ED.Value4,'0')
  ,nvl(ED.Variable5,'0'),nvl(ED.Operator5,'0'),nvl(ED.Value5,'0')
  from NEW_EXCEPTIONS EA 
  left join NEW_EXCEPTIONDESC ED on EA.EXCEPTIONDESC = ED.ID
  where ((accountid =lv_accountid and customerid = '-') or  (accountid = '-' and customerid = lv_customerid))
  
  and 
  ((regexp_like (model,''''||lv_model||'''','i') and series = '-' and style = '-')
  or  (regexp_like (series,''''||lv_SERIES||'''','i') and model ='-')
  or (regexp_like (style,''''||lv_style||'''','i') and model = '-'))
  order by OrderIndex,ED.applyon,model,series,style;
  
  
  
  --declared some exception variables to see if model rule has been applied if so dont evaluate any more per ex_applyon category.
  -- eg if color rule are model is already executed then we need to remember it and not apply color rule at series level
  --below variables records and remembers it.
  lv_excolorlevel number :=0;
  
  lv_extintlevel number :=0;
  lv_exenergylevel number :=0;
  lv_exsafetylevel number :=0;
  lv_exglasslevel number :=0;
  
  lv_exgridlevel number :=0;
  lv_exscreenlevel number :=0;
  lv_exwood_mulllevel number :=0;
  lv_exlockslevel number :=0;
  
  lv_excottageoriellevel number :=0;
  lv_exfoamwraplevel number :=0;
  lv_exdrywalllevel number :=0;
  
  
  
  BEGIN
  
   --Now apply exception and record into log table if any
     begin 
      open c_exception;
      loop fetch c_exception into lv_temp,lv_exassignid,lv_exdiscounttype,lv_exdescid,lv_exapplyon,lv_exdiscountvalue,lv_exceptiondesc,
      lv_exVariable1,lv_exOperator1,lv_exValue1,
      lv_exVariable2,lv_exOperator2,lv_exValue2,
      lv_exVariable3,lv_exOperator3,lv_exValue3,
      lv_exVariable4,lv_exOperator4,lv_exValue4,
      lv_exVariable5,lv_exOperator5,lv_exValue5;
      EXIT WHEN c_exception%NOTFOUND;
       
         lv_exprice:=0;
         --lv_exapplyon :='';
       --case when 
       DBMS_OUTPUT.PUT_LINE ('lv_exassignid ' ||lv_exassignid|| ' lv_exdiscounttype ' ||lv_exdiscounttype||' lv_exdescid ' ||lv_exdescid|| ' lv_exapplyon '||lv_exapplyon||' lv_exdiscountvalue '||lv_exdiscountvalue);
       
  --BASE	lv_baseprice
  --BREATHER TUBE	lv_breathertubeprice
  --COLOR	lv_colorprice
  --COTTAGE/ORIEL	lv_cottageorielprice
  --DRYWALL	lv_drywallprice
  --ENERGY	lv_energyprice
  --FINAL	lv_finalprice
  --FIXED SCREEN	lv_screenprice
  --FOAMWRAP	lv_foamwrapprice
  --GLASS	lv_glassprice
  --GRID	lv_gridprice
  --GRID COLOR UPCHARGE	lv_gridcolorprice
  --GRID TSO ONLY	lv_gridpatternprice
  --HARDWARE	lv_hardwareprice
  --HARDWARE ACCESSORY	lv_hardwareaccessoryprice
  --HARDWARE COLOR/TYPE	lv_hardwaretype_colorprice
  --HARDWARE EGRESS	lv_hardwareegressprice
  --INFO	lv_info
  --LOCKS	lv_lockprice
  --SAFETY	lv_safetyprice
  --SASH ACCESSORY	lv_sashaccessoryprice
  --SCREEN	lv_screenprice
  --SCREENMESH	lv_screenmeshprice
  --SEAT	lv_seatprice
  --SIMULATED MEETING RAIL	lv_smrprice
  --SUPER SPACER	lv_spacerprice
  --TINT	lv_tintprice
  --WOOD/MULL	lv_wood_mullprice
  --WOOD/MULL CUSTOM SIZE	lv_woodcustomaddon
  
  --Base
  --Color
  --Glass
  --Grid
  --Screen
  --Mull
  --Locks----
  --OrielCottage
  --Foamwrap
  --Breakage
  --MullType
  
  
  
  
      if (lv_exvariable1 !='0') then --for the first variable always check and the n preceding variables needs to be check if previous variable evaluation was true.
        lv_evaluate :=exception_evaluate(lv_exvariable1,lv_exOperator1,lv_exvalue1);
        if (lv_exvariable2 !='0' and lv_evaluate =1 ) then
          lv_evaluate :=exception_evaluate(lv_exvariable2,lv_exOperator2,lv_exvalue2);
          if (lv_exvariable3 !='0' and lv_evaluate =1 ) then
            lv_evaluate :=exception_evaluate(lv_exvariable3,lv_exOperator3,lv_exvalue3);
            if (lv_exvariable4 !='0' and lv_evaluate =1 ) then
              lv_evaluate :=exception_evaluate(lv_exvariable4,lv_exOperator4,lv_exvalue4);
              if (lv_exvariable5 !='0' and lv_evaluate =1 ) then
                  lv_evaluate :=exception_evaluate(lv_exvariable5,lv_exOperator5,lv_exvalue5);
               end if; --5 
            end if; --4       
          end if; --3
        end if;   --2
      end if ; --1
  
      if (lv_evaluate = 1) then --if all conditions that are available if evaluated to be true then go ahead and apply exceptions.
           case 
               when (lv_exapplyon = 'BASE' and lv_baseprice > 0)   then
                    
                        lv_exprice := EXCEPTION_GETBASEPRICE (LV_WIDTHES ,LV_HEIGHTES, LV_Exceptiondesc);
                        
                       -- if (lv_exprice < lv_baseprice) then
                          lv_exOrigprice := lv_baseprice;
                          lv_baseprice := lv_exprice;
                         ---we recalculate color and grid price if they were variable of base price) 
                          
                          if (lv_colorpricetype = 'PERC_OF_BASE') then
                            lv_colorprice := GETCOLOR(lv_mulledunits);
                          end if ;
                          
                          if (lv_gridpricetype = 'PERC_OF_BASE' or lv_gridcolorpricetype = 'PERC_OF_BASE' or lv_gridpatternpricetype ='PERC_OF_BASE') then
                            lv_gridprice := getgridprice();
                          end if;
                     --  end if; 
                        
                 when (lv_exapplyon = 'COLOR' and lv_colorprice > 0 --and regexp_like (lv_exvalue,''''||lv_framecolorin||'''','i')
                 and (lv_excolorlevel= 0 or  lv_excolorlevel=lv_temp) -- so we apply the very first exception or exception at same level i.e model level or series level or style level
                 )   then       
                        lv_exprice := applyexception (lv_exapplyon,lv_colorprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_colorprice;
                        lv_colorprice := lv_exprice;
                        lv_excolorlevel := lv_temp;
                        
                when (lv_exapplyon = 'TINT' and lv_tintprice > 0 --and regexp_like (lv_exvalue,''''||lv_tintin||'''','i')
                and ( lv_extintlevel=0 or lv_extintlevel =lv_temp)
                )   then       
                        lv_exprice := applyexception (lv_exapplyon,lv_tintprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_tintprice;
                        lv_tintprice := lv_exprice; 
                         
  --                       if (lv_sections > 1) then -- if more of this pattern occur then add new column to exceptions
  --                          lv_TINTPRICE :=lv_tintprice* lv_sections;
  --                          --lv_safetyPRICE := lv_safetyprice;
  --                        else
  --                          lv_TINTPRICE :=lv_tintprice* lv_EFFECTIVEUNIT;
  --                          --lv_safetyPRICE := lv_safetyprice;
  --                        end if;
                          
                        lv_glassprice := lv_tintprice+lv_energyprice+lv_safetyprice;
                        lv_extintlevel := lv_temp;
                        
                
                when (lv_exapplyon = 'ENERGY' and lv_energyprice > 0 --and regexp_like (lv_exvalue,''''||lv_energy||'''','i')
                and ( lv_exenergylevel = 0  or lv_exenergylevel =lv_temp )
                )   then       
                        lv_exprice := applyexception (lv_exapplyon,lv_energyprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_energyprice;
                        lv_energyprice := lv_exprice;
  --                       if (lv_sections > 1) then
  --                           lv_energyPRICE := lv_energyprice* lv_sections;
  --                        --lv_safetyPRICE := lv_safetyprice;
  --                      else
  --                       lv_energyPRICE := lv_energyprice* lv_EFFECTIVEUNIT;
  --                        --lv_safetyPRICE := lv_safetyprice;
  --                      end if;
                        lv_glassprice := lv_tintprice+lv_energyprice+lv_safetyprice;
                        lv_exenergylevel :=lv_temp;
                        
                      
                          
                when (lv_exapplyon = 'SAFETY' and lv_safetyprice > 0 --and regexp_like (lv_exvalue,''''||lv_safety||'''','i')
                and (lv_exsafetylevel=0 or  lv_exsafetylevel=lv_temp)
                )   then       
                        lv_exprice := applyexception (lv_exapplyon,lv_safetyprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_safetyprice;
                        lv_safetyprice := lv_exprice;
                        lv_glassprice := lv_tintprice+lv_energyprice+lv_safetyprice;
                        lv_exsafetylevel:=lv_temp;
                        
                        --- make accomodation for grid upcharge as well. gridcolorprice.
                when (lv_exapplyon = 'GRID' and lv_gridprice > 0 --and regexp_like (lv_exvalue,''''||lv_gridstyle||'''','i')
                and (lv_exgridlevel=0 or  lv_exgridlevel=lv_temp)
                )   then       
                        lv_exprice := applyexception (lv_exapplyon,lv_gridprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_gridprice;
                        lv_gridprice := lv_exprice;
                        lv_exgridlevel:=lv_temp;
                 
                when (lv_exapplyon = 'GRID COLOR' and lv_gridcolorprice > 0 --and regexp_like (lv_exvalue,''''||lv_gridstyle||'''','i')
                and (lv_exgridlevel=0 or  lv_exgridlevel=lv_temp)
                )   then       
                        lv_exprice := applyexception (lv_exapplyon,lv_gridcolorprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_gridcolorprice;
                        lv_gridcolorprice := lv_exprice;
                        lv_exgridlevel:=lv_temp;
                        lv_gridprice := lv_gridprice-lv_gridcolorprice;
                        
                        
                 when (lv_exapplyon = 'SCREEN' and lv_screenprice > 0 --and regexp_like (lv_exvalue,''''||lv_screentype||'''','i')
                 and (lv_exscreenlevel=0 or  lv_exscreenlevel=lv_temp)
                 )   then       
                        lv_exprice := applyexception (lv_exapplyon,lv_screenprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_screenprice;
                        lv_screenprice := lv_exprice;       
                        lv_exscreenlevel:=lv_temp;
                        
                when (lv_exapplyon = 'WOOD/MULL'-- and ( regexp_like (lv_exvalue,''''||lv_woodsurround||'''','i') or regexp_like (lv_exvalue,''''||lv_mulltype||'''','i'))  
                and (lv_exwood_mulllevel=0 or lv_exwood_mulllevel=lv_temp)
                and lv_wood_mullprice > 0)  then
                
                        
                        lv_exprice := applyexception (lv_exapplyon,lv_wood_mullprice,lv_exdiscounttype,lv_exdiscountvalue);
                        
                        --make sure custom price is taken care of
                        if (LV_WOODCUSTOMADDON !=0 ) then
                          lv_exprice := lv_exprice + LV_WOODCUSTOMADDON;
                        end if;
                        
                        lv_exOrigPrice := lv_wood_mullprice;
                        lv_wood_mullprice := lv_exprice;     
                        lv_exwood_mulllevel:=lv_temp;
                        
                 when (lv_exapplyon = 'LOCKS'  and lv_lockprice > 0 --and  regexp_like (lv_exvalue,''''||lv_hardwaretype||'''','i')
                 and (lv_exlockslevel=0 or lv_exlockslevel=lv_temp)
                 ) then
                        lv_exprice := applyexception (lv_exapplyon,lv_lockprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_lockprice;
                        lv_lockprice := lv_exprice;
                        lv_exlockslevel:=lv_temp;
                        
                 when (lv_exapplyon = 'COTTAGE/ORIEL'  and lv_cottageorielprice > 0 --and  regexp_like (lv_exvalue,''''||lv_cottageoriel||'''','i')
                 and (lv_excottageoriellevel=0 or  lv_excottageoriellevel=lv_temp)
                 ) then
                        lv_exprice := applyexception (lv_exapplyon,lv_cottageorielprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_cottageorielprice;
                        lv_cottageorielprice := lv_exprice;       
                        lv_excottageoriellevel:=lv_temp;
                        
                 when (lv_exapplyon = 'FOAMWRAP'  and lv_foamwrapprice > 0 --and  regexp_like (lv_exvalue,''''||lv_foamwrap||'''','i')
                 and (lv_exfoamwraplevel=lv_temp or lv_exfoamwraplevel=0)
                 ) then
                        lv_exprice := applyexception (lv_exapplyon,lv_foamwrapprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_foamwrapprice;
                        lv_foamwrapprice := lv_exprice;          
                        lv_exfoamwraplevel:=lv_temp;
      
                 when (lv_exapplyon = 'DRYWALL'  and lv_drywallprice > 0 --and  regexp_like (lv_exvalue,''''||lv_style||'''','i')
                 and ( lv_exdrywalllevel=0 or  lv_exdrywalllevel=lv_temp)
                 ) then
                        lv_exprice := applyexception (lv_exapplyon,lv_drywallprice,lv_exdiscounttype,lv_exdiscountvalue);
                        lv_exOrigPrice := lv_drywallprice;
                        lv_drywallprice := lv_exprice;     
                        lv_exdrywalllevel:=lv_temp;
           else 
            lv_exprice :=0;
           end case;
       else -- lv_evaluate ! = '0'
             lv_exprice :=0;
        
       end if ; 
        
          if (lv_exprice >0 or (lv_exdiscounttype= 'DEDUCTPERCENTAGE' and lv_exdiscountvalue ='100') ) then
            PROC_WRITEEXCEPTIONLOG ( LV_EXASSIGNID,LV_EXDESCID,LV_EXDISCOUNTTYPE,LV_EXDISCOUNTVALUE,lv_exapplyon,lv_exOrigprice,lv_exprice);
           end if; 
  --         
        
        DBMS_OUTPUT.PUT_LINE (lv_exprice);
      end loop;
      close c_exception;
    end; 
    
    
    
    
     if (lv_totalperc!=0) then
          lv_finalprice :=lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice +lv_cottageorielprice+ lv_foamwrapprice+ lv_spacerprice+lv_lockprice+lv_hardwareprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice+lv_smrprice+lv_screenmeshprice+lv_warrantyprice+lv_finprice+lv_hingedeductprice+lv_high_performanceprice;
          lv_screenprice :=  - (lv_finalprice *(100-lv_totalperc)/100);
          lv_exprice :=lv_finalprice+lv_screenprice;
        
        PROC_WRITEEXCEPTIONLOG (0,0,0,0,'FIXED SCREEN',lv_finalprice,lv_exprice);
     
    end if;
    
  --  proc_WriteToPricingLog ('BASEPRICE',0,lv_baseprice);
  --  proc_WriteToPricingLog ('GRIDPRICE',0,lv_GRIDprice);
  --  proc_WriteToPricingLog ('COLORPRICE',0,lv_COLORprice);
  --  proc_WriteToPricingLog ('GLASSPRICE',0,lv_GLASSprice);
  --  proc_WriteToPricingLog ('WOOD_MULLPRICE',0,lv_WOOD_MULLprice);
  --  proc_WriteToPricingLog ('SCREENPRICE',0,lv_SCREENprice);
  --  proc_WriteToPricingLog ('SEATPRICE',0,lv_SEATprice);
  --  proc_WriteToPricingLog ('COTTAGEORIELPRICE',0,lv_COTTAGEORIELprice);
  --  proc_WriteToPricingLog ('FOAMWRAPPRICE',0,lv_FOAMWRAPprice);
  --  proc_WriteToPricingLog ('SUPERSPACEPRICE',0,lv_spacerprice);
  --  proc_WriteToPricingLog ('LOCKPRICE',0,lv_LOCKprice);
  --  proc_WriteToPricingLog ('DRYWALLPRICE',0,lv_DRYWALLprice);
  --  proc_WriteToPricingLog ('BREATHERTUBEPRICE',0,lv_BREATHERTUBEprice);
    
      lv_finalprice :=lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice+lv_screenprice +lv_cottageorielprice+ lv_foamwrapprice+ lv_spacerprice+lv_lockprice+lv_hardwareprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice+lv_smrprice+lv_screenmeshprice + lv_warrantyprice+lv_finprice+lv_hingedeductprice+lv_high_performanceprice;
     
       
       
       
  RETURN lv_finalprice;
  
  END PROCESSEXCEPTIONS;
  
  function getprice (IN_UNITID IN NUMBER , IN_ITEMID IN NUMBER , IN_ORDERID IN NUMBER 
  ,OUT_WARRPRICE OUT NUMBER , OUT_PRICE OUT NUMBER  ) return number as 
  
  
  begin
  
      G_UNITID := IN_UNITID;
      G_ITEMID := IN_ITEMID;
      G_ORDERID := IN_ORDERID;
      
      --INITIATE AGAIN FOR SOME REASON OLD PRICE WHERE PLUGGED IN FROM PREVIOUS CALCUATIONS
      
      lv_baseprice :=0;
      lv_gridprice :=0;
      lv_glassprice :=0;
      lv_tintprice :=0;
      lv_energyprice :=0;
      lv_safetyprice :=0;
      lv_breathertubeprice :=0;
      lv_colorprice :=0;
      lv_wood_mullprice :=0;
      lv_screenprice  :=0;
      lv_screenmeshprice  :=0;
      lv_seatprice :=0;
      lv_cottageorielprice := 0;
      lv_foamwrapprice  :=0;
      lv_spacerprice :=0;
      lv_lockprice :=0;
      lv_hardwareprice :=0;
      lv_hardwaretype_colorprice  :=0;
      lv_hardwareaccessoryprice  :=0;
      lv_hardwareegressprice  :=0;
      lv_sashaccessoryprice  :=0;
      lv_drywallprice  :=0;
      lv_smrprice  :=0;
      lv_gbwselected := 0;
      lv_warrantyprice :=0;
      lv_configuration :='';
      
      
      lv_lites := 0;
      lv_sash :=0;
      lv_doorpanel := 0;
      lv_doorid := 0;
      lv_doorenergy :=0;
      lv_doorenergy_pricetype :='';
      lv_doortint :=0;
      lv_doortint_pricetype :='';
      lv_panels_pricetype :='0';
      
      lv_atriumprice  :=0;
      lv_finalprice  :=0;
      lv_totalperc :=0; ---this for total deduct only applicatble for FGO/TOP SASH ONLY etc
      
      
      -- OTHER VARIABLES
      lv_stdsize  :=0;
      lv_hasgrid :=0;
      lv_mulledunits  :=0;
      lv_totalunits  :=0; -- mulled units may have more than 2 effective unit items eg CTTW & TR will be 2 mulled units but total of 3 effective unit.
      lv_sections   :=0;
      lv_isshape  :=0;
      lv_screendeduct  :=0;
      
      --Log variables
      lv_sizeid  :=0;
      lv_sizetype  :='';
      --lv_gridid number :=0;
      lv_tintid  :=0;
      lv_energyid  :=0;
      lv_safetyid  :=0;
      --lv_colorid number :=0;
      --lv_wood_mullid number :=0;
      lv_screenid  :=0;
      
      lv_hardwareid :=0;
      lv_hardwareaccessoryid :=0;
      lv_hardwareegressid  :=0;
      lv_sashaccessoryid  :=0;
      
      LV_WOODCUSTOMADDON :=0;
      
      lv_gridpatternid :=0;
      lv_gridpatternprice :=0;
      lv_gridcolorprice :=0;
      
      lv_count  :=0;
      lv_ruleid  :=0;
      lv_exprice  :=0;
      lv_exOrigPrice  :=0;
      lv_lognexcept  :=0;
      
      lv_exvariable1:='0';
      lv_exoperator1:='0';
      lv_exvalue1:='0';
  
      lv_exvariable2:='0';
      lv_exoperator2:='0';
      lv_exvalue2:='0';
      lv_exvariable3:='0';
      lv_exoperator3:='0';
      lv_exvalue3:='0';
      lv_exvariable4:='0';
      lv_exoperator4:='0';
      lv_exvalue4:='0';
      lv_exvariable5:='0';
      lv_exoperator5:='0';
      lv_exvalue5:='0';
      
      
      lv_colorpricetype :='';
      lv_gridpricetype :='';
      lv_gridpatternpricetype :='';
      lv_gridcolorpricetype :='';
      
      lv_otherid := 0;
      
      OUT_WARRPRICE :=0;
      OUT_PRICE :=0;
      lv_stopprocessing := 0;
      
    --ORdermaster
      select accountid,customerid,nvl(GBWSELECTED,0) into lv_accountid,lv_customerid,lv_gbwselected 
      from ordermaster where orderid = IN_Orderid;
    --L1_item
      select construction,rendercode,nvl(woodsurround,0),linenumber,nvl(seat,'0') , nvl(foamwrap,'0'),nvl(gridplacement,'0'),nvl(fins,0),nvl(configuration,'0')
      into lv_construction,lv_rendercode,lv_woodsurround,lv_linenumber,lv_seat ,lv_foamwrap,lv_gridplacement,lv_fins,lv_configuration
      from l1_item where itemid = IN_itemid;
      
    --L2_unit
      select widthes,heightes,model,series,style,nvl(cottageoriel,0) , nvl(clmr,0), nvl(pane_type,0)  , nvl(hardwareaccessory,0),nvl(egress,0),linetypeid ,nvl(smr,0), 
      case when tripleeyebrow in ('Triple Eyebrow') then 1 else 0 end ,nvl(northern_energy_star,0)
      
      into lv_widthes,lv_heightes,lv_model,lv_series,lv_style,lv_cottageoriel,lv_clmr,lv_panetype, lv_hardwareaccessory, lv_egress ,lv_linetypeid,lv_smr
      ,lv_tripleeyebrow,lv_nfrc
      from l2_unit where unitid = IN_UNITID;
      
    --STYLE
    select 
   -- case when lv_series in (	'312','313','314','315','316','318','323','332','333','334','335','336','373','374','378','383','384','388','351','361','358','368','390','394','392','396','354','319','340','305','337','338') then 'Door'
    case when lv_series in (select value from NEW_PRICING_CONFIG where type ='DOOR' and value = lv_series) then 'DOOR'
    else category
    end 
    ,part,
    --case when stylecode in ( 'C2','C3','C4','C5','3LB','4LB','5LB','30B','45B','A2H','A2V','A3H','A3V' ) then 1 
      case when stylecode in (select style  from NEW_PRICING_CONFIG where type ='EFFECTIVEUNIT' and value = 1 and style = lv_style )  then 1  
          when part = 1 then 1 -- we make sure effective unit is not 0 for parts.
          else orcl_effect_unit   
    end, greatest (horsashcount,versashcount)
    into lv_category,lv_part,lv_effectiveunit ,lv_sash
      from style where stylecode = lv_style;
     --Configurations
      select lowercount+uppercount into lv_mulledunits from CONFIGURATIONS where rendercode = lv_rendercode;
    
      if(lv_mulledunits >1) then
       -- select sum (orcl_effect_unit) into lv_totalunits from style where stylecode in (select style from l2_unit where itemid =IN_itemid);
       select sum (orcl_effect_unit)  into lv_totalunits from style s left join l2_unit u on s.stylecode = u.style  where u.itemid =IN_itemid ;
      end if;
      
    --MULL
      select nvl(mulltype , 0) into lv_mulltype from L3_MULL where unitid = IN_UNITID;
    
    --SCREEN
      select nvl(screentype,0) , nvl(screenmeshtype,0) into lv_screentype,lv_screenmeshtype from l3_screen where unitid = IN_UNITID;
      
--      select case  when lv_screentype in ('BOTTOM SASH ONLY','Bottom Sash Only','FIXED GLASS ONLY','Fixed Glass Only','Fixed Glass Only-01','Fixed Glass Only-02','Fixed Glass Only-03',
--                              'Fixed Glass Only-04','Fixed Glass Only-05','Fixed Glass Only-06','Fixed Glass Only-07','Fixed Glass Only-08','Fixed Glass Only-09',
--                              'Fixed Glass Only-10','Fixed Glass Only-11','Fixed Glass Only-12','Fixed Glass Only-13','Fixed Glass Only-14','Fixed Glass Only-21','Fixed Glass Only-22',
--                              'Fixed Glass Only-23','Fixed Glass Only-25','Fixed Glass Only-26','Fixed Glass only','NO SCREEN','NO SCREEN/FOOT LOCK','No Screen',
--                              'No Screen/Footbolt','OPERATING GLASS ONLY','Operating Glass Only','TOP REPLACEMENT SASH','TOP SASH ONLY','Top Sash Only') 
--                  then 1
--              else 0 end into lv_screendeduct from dual;

      select case  when lv_screentype in ( select lv_screentype from new_pricing_config where type = 'SCREENDEDUCT' and regexp_like (value,lv_screentype,'i'))
                  then 1
              else 0 end into lv_screendeduct from dual;
      
    --HARDWARE
      select nvl(hardwaretype,0) , nvl(hardwarecolor,0),nvl(sashaccessorytype,0) into lv_hardwaretype,lv_hardwarecolor,lv_sashaccessory from l3_hardware where unitid = IN_UNITID;
    
    -- determine sections.
    
--      select  case 
--                when lv_style in ('C2','A2H','A2V') then 2 
--                when lv_style in ('30B','45B','3LB','C3','A3H','A3V') then 3 
--                when lv_style in ('4LB','C4') then 4 
--                when lv_style in ('5LB','C5') then 5 else 1 end  into lv_sections from dual;
--    
      select case when lv_style in (select style from new_pricing_config where type = 'SECTION' and style = lv_style  ) then (select to_number(value) from new_pricing_config where type = 'SECTION' and style = lv_style)
              else 0
              end 
      into lv_sections from dual ;
      
    --GET sash and frameid.
      
      select frameid,framecolorin into lv_frameid,lv_framecolorin from l3_frame where unitid = IN_UNITID;
      select sashid into lv_sashid from l4_sash where frameid = lv_frameid and rownum < 2 order by sashid;
      
      --Determin if shapes
--      select case when exists(SELECT STYLE
--                           from option_grid where regexp_like (style,''''||lv_style||'''','i') and shapes =1)
--             then 1
--             else 0
--           end  into lv_isshape from dual;
      --- changed so we can use the config table.
      select case when exists(SELECT value
                           from new_pricing_config where value = lv_style and type = 'SHAPE' )
             then 1
             else 0
           end  into lv_isshape from dual;
           
      --L5_GLASS
      select tintin,energy,safetyin,nvl(gridtypein,0),nvl(gridstyle,0),nvl(gridpattern ,0),nvl(spacertype,0),nvl(gridcolorin,'0') , nvl(gridcolorout,'0'), nvl(breathertube,'0')
      into lv_tintin,lv_energy,lv_safety,lv_gridtype,lv_gridstyle,lv_gridpattern , lv_spacertype,lv_gridcolorin,lv_gridcolorout,lv_breathertube  from l5_glass where sashid =lv_sashid;
    
       --determine actual gridpatterns and lite only when gridtype is  SDL.
      -- we get grid pattern irrespective of gridtype but only if its non shape 
      --- for casements and awnings we just use top sash or bottom sash since its going to be same.
      if (lv_isshape = 0) then
        select *  into lv_gridpattern from ( 
        
        select case when lv_style not in ('C2','A2H','A2V','C3','A3H','A3V','C4','C5') then nvl(listagg(gridpattern,'-')  within group (order by sashid desc),0) 
                        else  nvl (gridpattern,0)
                        end
                         from l5_glass where sashid in (select sashid from l4_sash where frameid = lv_frameid) group by gridpattern )x where rownum <2;
     
      --determine lites  
        if (lv_gridpattern!='0' and lv_gridtype  in ('SDL','7/8')) then
         -- select NVL(func_getlites(lv_gridpattern),0) into lv_lites from dual;
          --select NVL(func_getlites(),0) into lv_lites from dual;
          lv_lites := NVL(func_getlites(),0);
          
        end if ;
      
     end if;   
        
        
       --Get Doorpanel value
       select 
            case 
                 when  lv_model in ('311','312','332','378','388','4D5','4H2','4H8','4K2','4K5','4W2','4W5','4W8') then 2
                 when  lv_model in ('313','318','323','333','373','384','4K3','4K6','4W3','4W6','4W9') then 3
                 when  lv_model in ('314','334','374','384') then 4
                 else 1
       end  into lv_doorpanel from dual;   
      
      
      
      
    --Get exceptnlog 
    select pricelognexception.nextval into lv_lognexcept from dual;
  
    -- ###### START COMPUTING PRICING  ###########
    
    --Get glass price.
      --lv_glassprice := getglassprice (lv_tintin,lv_energy,lv_safety,lv_series,lv_style,lv_widthes,lv_heightes,lv_effectiveunit,lv_isshape,lv_nfrc,lv_tintprice,lv_energyprice,lv_safetyprice,lv_tintid ,lv_energyid,lv_safetyid);
    if not regexp_like (lv_category,'DOOR','i') then 
                  lv_glassprice:= getglassprice();
              --    DBMS_OUTPUT.put_line('Glass  '|| lv_glassprice);
              --    DBMS_OUTPUT.put_line('Tintprice '||lv_tintprice);
              --    DBMS_OUTPUT.put_line('energyprice '||lv_energyprice);
              --    DBMS_OUTPUT.put_line('safetyprice '||lv_safetyprice);
                  
              
               --Get gridp price and also determination if grid exists.
                
                if (lv_isshape = 0) then -- for shapes we compute grid pricing after base pricing.
                  if (LV_GRIDTYPE!= 'No Grid') then
              
                      lv_gridprice := getgridprice();
                  end if;
                  
                    DBMS_OUTPUT.put_line('GRID  '|| lv_gridprice ||'  - ' ||lv_hasgrid);  
               end if;   
              --    
              --    
              --  --Base calculation
              --  -- DEtermination of  which sizing table to choose.
              --  --select getbaseprice (lv_model,lv_series,lv_style,lv_widthes,lv_heightes,IN_PARAM1) into lv_baseprice from dual;
              --  
              --  ---calculate base price but write to log later as we are calculating grid later.
                  lv_baseprice := getbaseprice (lv_widthes,lv_heightes);
                
                DBMS_OUTPUT.put_line('BASE  '|| lv_baseprice ||  ' - '|| lv_stdsize || ' - ' ||lv_sizetype);
              --  
              --  
                  if (lv_isshape = 1) then -- for shapes we compute grid pricing after base pricing.
                  if (LV_GRIDTYPE!= 'No Grid') then
                  lv_gridprice := getgridprice();
                  
              --      --- there is no tso or ohx0v for shapes.
                  end if;
                  
                    DBMS_OUTPUT.put_line('GRID  '|| lv_gridprice ||'  - ' ||lv_hasgrid);  
                 end if;   
                 
                 if (lv_newgridupcharge = 1 and lv_gridstdsize= '0' and lv_stdsize='1') then --make sure we dont upcharge if lv_newgridupcharge is 1 and its std size.
                      lv_gridprice := 0;
                      proc_WriteToPricingLog ('GRID NO UPCHARGE',0,0);
                  end if;  
                  
              -- 
              --  --Write to log after checking after grid calculation for shape.
                  proc_WriteToPricingLog ('BASE',lv_sizeid,lv_baseprice);
                  
                  --  --Get color  price
                lv_colorprice := GETCOLOR(lv_mulledunits);
              
               DBMS_OUTPUT.put_line('Color '|| lv_colorprice );
               
               ----get hardwarerelated prices
                  if (lv_hardwaretype!='0' or lv_hardwarecolor !='0' or lv_hardwareaccessory!='0' or lv_egress!='0') then
                      lv_hardwareprice := GETHARDWAREPRICE (lv_sections);
                  end if;
              
                  
      else --- get base ,glass ,grid ,color  for  DOORS
           
             
           
            lv_baseprice := getbaseprice (lv_widthes,lv_heightes,1);
             proc_WriteToPricingLog ('BASE',lv_sizeid,lv_baseprice);
             
             ----get hardwarerelated price irrespective of stop processing flag.
                  if (lv_hardwaretype!='0' or lv_hardwarecolor !='0' or lv_hardwareaccessory!='0' or lv_egress!='0') then
                      lv_hardwareprice := GETHARDWAREPRICE (lv_sections);
                  end if;
            
              
                if (LV_GRIDTYPE!= 'No Grid' and lv_stopprocessing = 0 ) then --make sure we dont upcharge if lv_newgridupcharge is 1
              
                      lv_gridprice := getgridprice();
                  end if;
                  
                    DBMS_OUTPUT.put_line('GRID  '|| lv_gridprice ||'  - ' ||lv_hasgrid);  
                  
                 lv_glassprice:= getglassprice();   
             
            --lv_colorprice := 0;
            --lv_gridprice := 0;
           -- lv_glassprice := 0;
      end if;
      
      
      if (lv_stopprocessing = 0) then
              
              --  --Get Mull / Wood Price
              --  --Only do this if mulltype and wood surr is not null or has some values
                if (lv_mulltype !='0' or lv_woodsurround is not null) then
                    if (lv_mulltype !='0') then
                        lv_wood_mullprice := GETWOODMULLPRICE(lv_mulltype);
                    else 
                        lv_wood_mullprice := GETWOODMULLPRICE(lv_woodsurround);
                    end if ;
              --        
                end if ;
              --  
              --  
              --  --- get seat price
              --  
                if (lv_seat != '0') then
                    lv_seatprice := GETSEATPRICE();
                end if;
              --  
              --  ---get screenmesh price
                 if (lv_screenmeshtype!='0') then
                    lv_screenmeshprice := GETSCREENMESHPRICE(LV_SECTIONS);
              --    
                  end if;
              --    
              --    
                  ---get cottageoriel
              --    
                 if (lv_cottageoriel in ('ORIEL','Oriel','Cottage','COTTAGE')) then
              --   
                  if (lv_clmr != '0' and lv_clmr != '000' ) then
                      lv_clmr := '1';
                    end if ;
                    lv_cottageorielprice := GETCOTTAGEORIELPRICE ();
                  end if;
              --  
                ----get foamwrap
              --    
                   if (lv_foamwrap != '0') then
                      lv_foamwrapprice := GETFOAMPRICE();
                   end if;
              
                
                  ---get drywall price only if style matches
              --    
                 if (lv_style in   ('DW','DWHP','DWTW','DWTR','HPDW','DWHPTR','2DW','3DW')) then
                     lv_drywallprice := getdrywallprice ();
                 end if;
              --    
                 --get sash accessory price only if its not null and not 'No accessory'
              --    
                  if (lv_sashaccessory not in ('0','No Accessory')) then 
              --    
                      lv_sashaccessoryprice := getsashaccessoryprice ();
              
                  
                  end if;
              --    
              
                  if (lv_gbwselected != 0) then
                    lv_warrantyprice := getwarrantyprice();
                    OUT_WARRPRICE := lv_warrantyprice;
                  end if;
              
                  ---get superspacer price --- no table needed 
              --    
                  if ((lv_spacertype in ('Super Spacer','SUPER SPACER')) and lv_panetype!='0' and lv_panetype not in ('TRIPLE PANE','Triple Pane')) then
              --      if (lv_Sections >=3) then 
              --        lv_spacerprice := 16 * lv_sections  * 1.5 ;
              --      else
              --        lv_spacerprice := 16 * 1.5 ;
              --      end if;
              --      
                      lv_spacerprice := getotheroptionprice ('SPACER' , lv_spacertype,lv_otherid);
                    
                     if (lv_spacerprice!=0) then proc_WriteToPricingLog ('SPACER',lv_otherid,lv_spacerprice); end if;
                  end if ;
                  
                  --get locks --no table needed
                  
                  if (lv_hardwaretype in ( '2 LOCKS','2 Locks')) then 
              --        if ( lv_style in ('DH','SH') and lv_widthes < 27.25 ) or ( lv_style in ('2SL','3SL') and lv_heightes < 27.25 ) then
              --          lv_lockprice := 7 * 1.5 ;
              --        end if;
              
                      lv_lockprice := getotheroptionprice ('LOCKS' , lv_hardwaretype,lv_otherid);
                      
                     if (lv_lockprice!=0) then proc_WriteToPricingLog ('LOCKS',lv_otherid,lv_lockprice); end if;
                  end if;
                  
                    ---get breather tube charge -- no table needed
                  
                  if (lv_breathertube = 1) then
              --       if (lv_series in ('4000','4002','R4000')) then
              --        lv_breathertubeprice := 5 * 1.5;
              --       else
              --        lv_breathertubeprice := 2.5 * 1.5;
              --       end if; 
                     
                     lv_breathertubeprice := getotheroptionprice ('BREATHER TUBE' , lv_breathertube,lv_otherid);
                     
                     if (lv_breathertubeprice!=0) then proc_WriteToPricingLog ('BREATHER TUBE',lv_otherid,lv_breathertubeprice); end if;
                  end if;
                  
                  ---get smr price --no table needed.
                  if (lv_smr = 'Simulated Meeting Rail') then
                  
              --        if (lv_style in ('C2','C3','C4','C5') or lv_sections >= 3) then
              --          lv_smrprice := 38 * 1.5;
              --        else
              --          lv_smrprice := 19 * 1.5 ;
              --        end if;
                     
                     lv_smrprice := getotheroptionprice ('SMR' , lv_smr,lv_otherid);
                     
                      if (lv_smrprice!=0) then proc_WriteToPricingLog ('SMR',lv_otherid,lv_smrprice); end if;
                  end if;
                  
                  --get nail fin price
                  
                  --if (lv_fins != 0 or lv_category in ('Door','Door')) then
                    
                    lv_finprice := getotheroptionprice('FINS',lv_fins,lv_otherid);
                    if (lv_finprice!=0) then proc_WriteToPricingLog ('FINS',lv_otherid,lv_finprice); end if;  

                    lv_hingedeductprice := getotheroptionprice('HINGE_DEDUCT',lv_configuration,lv_otherid);
                    if (lv_hingedeductprice!=0) then proc_WriteToPricingLog ('HINGE_DEDUCT',lv_otherid,lv_hingedeductprice); end if;  
                    
                    if (lv_style like '%HP%') then
                      lv_high_performanceprice := getotheroptionprice('HIGH_PERFORMANCE','-',lv_otherid);
                      if (lv_high_performanceprice!=0) then proc_WriteToPricingLog ('HIGH_PERFORMANCE',lv_otherid,lv_high_performanceprice); end if;  
                    
                    end if;
                  --end if;
                  
                  -----Calculate screen last
                
                     if ((lv_screentype!='No Screen' and lv_screentype!='0' ) or lv_part =1) then
                        
                        lv_screenprice := GETSCREENPRICE (lv_sections);
                  end if;
                
         end if ; -- if lv_stopprocessing = 0;       
     
  --  
   ------Write final atrium price
      lv_atriumprice :=lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice + lv_screenprice+lv_seatprice +lv_cottageorielprice+ lv_foamwrapprice+ lv_spacerprice+lv_lockprice+lv_hardwareprice+lv_drywallprice+lv_breathertubeprice
      +lv_sashaccessoryprice+lv_smrprice+lv_screenmeshprice+lv_warrantyprice+lv_finprice+lv_hingedeductprice+lv_high_performanceprice;  
  -- 
  --  
    --this string may not be needed
    proc_WriteToPricingLog ('INFO',0,0);
    
  --  proc_WriteToPricingLog ('BASEPRICE',0,lv_baseprice);
  --  proc_WriteToPricingLog ('GRIDPRICE',0,lv_GRIDprice);
  --  proc_WriteToPricingLog ('COLORPRICE',0,lv_COLORprice);
  --  proc_WriteToPricingLog ('GLASSPRICE',0,lv_GLASSprice);
  --  proc_WriteToPricingLog ('WOOD_MULLPRICE',0,lv_WOOD_MULLprice);
  --  proc_WriteToPricingLog ('SCREENPRICE',0,lv_SCREENprice);
  --  proc_WriteToPricingLog ('SEATPRICE',0,lv_SEATprice);
  --  proc_WriteToPricingLog ('COTTAGEORIELPRICE',0,lv_COTTAGEORIELprice);
  --  proc_WriteToPricingLog ('FOAMWRAPPRICE',0,lv_FOAMWRAPprice);
  --  proc_WriteToPricingLog ('SUPERSPACEPRICE',0,lv_spacerprice);
  --  proc_WriteToPricingLog ('LOCKPRICE',0,lv_LOCKprice);
  --  proc_WriteToPricingLog ('DRYWALLPRICE',0,lv_DRYWALLprice);
  --  proc_WriteToPricingLog ('BREATHERTUBEPRICE',0,lv_BREATHERTUBEprice);
  --  
    
    
  --  
    proc_WriteToPricingLog ('ATRIUMPRICE',0,lv_atriumprice);
       
       lv_finalprice := processexceptions();
       
       PROC_WRITEEXCEPTIONLOG ( 0,0,0,0,'FINAL',lv_atriumprice,lv_finalprice);
       
  
    
      
      OUT_PRICE := lv_finalprice;
      
  RETURN ROUND(lv_finalprice,3) ;
  
  exception when others then
      begin
        lv_finalprice :=-1;
        OUT_WARRPRICE := -1;
        OUT_PRICE := lv_finalprice;
        RETURN ROUND(lv_finalprice,3) ;    
      end ;
  end getprice;
  
  
  END NEW_PRICING;