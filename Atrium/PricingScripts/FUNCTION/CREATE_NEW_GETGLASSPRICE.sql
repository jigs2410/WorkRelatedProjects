
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETGLASSPRICE" 
(
 IN_TINT IN VARCHAR2 
, IN_ENERGY IN VARCHAR2
, IN_SAFETY IN VARCHAR2
, IN_SERIES IN VARCHAR2
, IN_STYLE IN VARCHAR2
, IN_WIDTHES IN NUMBER
, IN_HEIGHTES IN NUMBER
, IN_EFFECTIVEUNIT IN NUMBER
--, IN_GRIDPATTERN IN VARCHAR2
--, IN_ACCOUNTID IN VARCHAR2 
--, IN_CUSTOMERID IN VARCHAR2 
, IN_SHAPE IN VARCHAR2
, IN_NFRC IN NUMBER
, IN_TINTPRICE   IN OUT NUMBER
, IN_ENERGYPRICE IN OUT NUMBER
, IN_SAFETYPRICE IN OUT NUMBER
, IN_TINTID IN OUT NUMBER
, IN_ENERGYID IN OUT NUMBER
, IN_SAFETYID IN OUT NUMBER

) RETURN NUMBER AS 

lv_glassprice number :=0;

lv_tintprice number :=0;
lv_energyprice number :=0;
lv_safetyprice number:=0;

lv_tint  OPTION_GLASS.TINT%TYPE;
lv_tintpricetype OPTION_GLASS.TINT_PRICE_TYPE%TYPE;
lv_energypricetype OPTION_GLASS.energy_PRICE_TYPE%TYPE;
lv_safety OPTION_GLASS.SAFETY%TYPE;
lv_safetypricetype OPTION_GLASS.safety_PRICE_TYPE%TYPE;
lv_panetype          OPTION_GLASS.PANE_TYPE%type;
lv_series OPTION_GLASS.SERIES%TYPE;
lv_style  option_glass.style%type;

lv_calc_safety number :=1;

cursor c_tint is 
select id, tint_price, tint_price_type,safety,safety_price, safety_price_type from option_glass
where  regexp_like (tint , IN_TINT,'i') and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL') order by series,style,safety;

--cursor c_energy is
--select energy_price, energy_price_type from option_glass
--where  energy = IN_ENERGY and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
--and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL') order by series,style;

--cursor c_safety is 
--select tint,tint_price, tint_price_type,safety_price, safety_price_type from option_glass
--where safety = IN_safety and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
--and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL') order by series,style;


BEGIN

  if (IN_TINT not in  ('Clear','CLEAR')) then
  begin 
    open c_tint;
    loop fetch c_tint into IN_TINTID,lv_tintprice,lv_tintpricetype,lv_safety,lv_safetyprice,lv_safetypricetype;
    EXIT WHEN c_tint%NOTFOUND;
      if lv_safetyprice is not null or IN_Tint like '%Tempered' or IN_Tint like '%TEMPERED' then
         if lv_safety = IN_SAFETY then
            lv_calc_safety :=0;
                exit;
            end if;
            if IN_Tint like '%Tempered' or IN_Tint like '%TEMPERED' then
              lv_calc_safety :=0;
            end if;
      end if ;
    
    end loop;
    close c_tint;
  end; 
  end if; 
  
  
  ---energy 
  begin
   
    select id,energy_price, energy_price_type into  IN_ENERGYID,lv_energyprice,lv_energypricetype from (
    select id,energy_price, energy_price_type   from option_glass
    where regexp_like(energy,IN_ENERGY,'i') and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
    and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL') and nfrc =IN_NFRC  order by series,style) x where rownum < 2;
    EXCEPTION WHEN NO_DATA_FOUND THEN
    begin 
      lv_energyprice := 0;
      IN_ENERGYID:=0;
    end;
  end;  
    
    --safety only if we have to calcualte it

if (lv_calc_safety = 1 and IN_SAFETY not in ('Single Strength','SINGLE STRENGTH')) then 
   begin 
      select ID,safety_price, safety_price_type into IN_SAFETYID, lv_safetyprice,lv_safetypricetype  from (
      select id,safety_price, safety_price_type from option_glass
      where regexp_like(safety,IN_Safety,'i') and (regexp_like (series,''''||IN_SERIES||'''','i') or series = 'ALL')
      and (regexp_like (style,''''||IN_Style||'''','i') or style = 'ALL') 
      and (shape = IN_SHAPE or shape = 'ALL')
       and nfrc =IN_NFRC 
      and tint is null  order by series,style,shape) y where  rownum < 2;
      EXCEPTION WHEN NO_DATA_FOUND THEN
     begin 
        lv_safetyprice := 0;
      end;
  end;
 end if ; 

-- Apply price type
  if (lv_tintprice > 0)  then
    lv_tintprice := new_applypricetype (lv_tintprice,lv_tintpricetype,IN_WIDTHES,IN_HEIGHTES);
  end if;
  
  if (lv_energyprice > 0)  then
    lv_energyprice := new_applypricetype (lv_energyprice,lv_energypricetype,IN_WIDTHES,IN_HEIGHTES);
  end if;
  
  
  if (lv_safetyprice > 0)  then
    lv_safetyprice := new_applypricetype (lv_safetyprice,lv_safetypricetype,IN_WIDTHES,IN_HEIGHTES);
  end if;
  
  
  IN_TINTPRICE :=lv_tintprice* IN_EFFECTIVEUNIT;
  IN_ENERGYPRICE := lv_energyprice* IN_EFFECTIVEUNIT;
  IN_SAFETYPRICE := lv_safetyprice;
  lv_glassprice := IN_TINTPRICE + IN_ENERGYPRICE + IN_SAFETYPRICE;
  RETURN lv_glassprice;
END NEW_GETGLASSPRICE;