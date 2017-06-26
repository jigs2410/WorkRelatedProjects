
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETHARDWAREPRICE" 
(
  IN_TYPE IN VARCHAR2 
, IN_COLOR IN VARCHAR2 
, IN_ACCESSORY IN VARCHAR2
, IN_EGRESS IN VARCHAR2
, IN_SERIES IN VARCHAR2 
, IN_STYLE IN VARCHAR2 
, IN_EFFECTIVEUNIT IN NUMBER 
, IN_SECTIONS IN NUMBER 
, IN_CATEGORY IN VARCHAR2
, IN_HARDWARETYPE_COLORPRICE IN OUT NUMBER 
, IN_HARDWAREEGRESSPRICE IN OUT NUMBER 
, IN_HARDWAREACCESSORYPRICE IN OUT NUMBER 
, IN_HARDWAREID IN OUT NUMBER 
, IN_HARDWAREACCESSORYID IN OUT NUMBER 
, IN_HARDWAREEGRESSID IN OUT NUMBER 

) RETURN NUMBER AS 

lv_price number :=0;

lv_hardwaretype_colorprice number :=0;
lv_hardwareaccessoryprice number :=0;
lv_hardwareegressprice number :=0;

lv_sections  option_hardware.sections%type;
lv_pricetype option_hardware.price_type%TYPE;
--lv_pricemul option_hardware.pricemul%type;
lv_hardwareid option_hardware.ID%type;
lv_accessoryid option_hardware.ID%type;

lv_egressid option_hardware.ID%type;


BEGIN

--get hardwarecolor _type price---

  if (IN_SECTIONS >= 3) then lv_sections :=3 ;
  else lv_sections := 2; end if;
  
  if (IN_TYPE !='0' or IN_COLOR !='0') then
  begin --1
    select price,price_type,id  into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from option_hardware 
    where ( regexp_like (type,''''||IN_TYPE||'''','i') ) and color ='0'
    and  regexp_like (category,''''||IN_CATEGORY||'''','i') ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      begin --2
        select price,price_type,id  into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from option_hardware 
        where ( regexp_like (type,''''||IN_TYPE||'''','i'))  and color ='0'
        and  regexp_like (SERIES,''''||IN_SERIES||'''','i') ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
          begin --3
          select price,price_type,id  into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from option_hardware 
          where ( regexp_like (type,''''||IN_TYPE||'''','i'))  and color ='0'
          and  regexp_like (STYLE,''''||IN_STYLE||'''','i') ;
          EXCEPTION WHEN NO_DATA_FOUND THEN
            begin --4 
              select price,price_type,id  into lv_hardwaretype_colorprice,lv_pricetype,lv_hardwareid from option_hardware 
              where ( regexp_like (color,''''||IN_COLOR||'''','i'))  and type ='0'
              and  (regexp_like (STYLE,''''||IN_STYLE||'''','i') or style = 'ALL' )
              and  (regexp_like (SERIES,''''||IN_SERIES||'''','i') or series = 'ALL' )
              and sections = lv_sections
              order by style desc, series;
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

--NOW get accessory

  if (IN_ACCESSORY!='0') then
    begin
      select price,price_type,id  into lv_hardwareaccessoryprice,lv_pricetype,lv_accessoryid from option_hardware 
      where ( regexp_like (accessory,''''||IN_ACCESSORY||'''','i') ) and color ='0' and type = '0'
      and  regexp_like (SERIES,''''||IN_SERIES||'''','i');
      EXCEPTION WHEN NO_DATA_FOUND THEN
      begin 
        lv_hardwareaccessoryprice :=0;
        lv_accessoryid :=0;
      end;
    end ;
  end if;
  
  ---Get egrress
  
  if (IN_EGRESS!='0') then
      begin
        select price,price_type,id  into lv_hardwareegressprice,lv_pricetype,lv_egressid from option_hardware 
        where ( regexp_like (egress,''''||IN_EGRESS||'''','i') ) and color ='0' and type = '0' and accessory = '0'
        and  regexp_like (STYLE,''''||IN_STYLE||'''','i');
        EXCEPTION WHEN NO_DATA_FOUND THEN
        begin 
          lv_hardwareegressprice :=0;
          lv_egressid :=0;
        end;
      end ;
  end if;
  
  IN_HARDWARETYPE_COLORPRICE := lv_hardwaretype_colorprice;
  IN_HARDWAREACCESSORYPRICE :=lv_hardwareaccessoryprice;
  IN_HARDWAREEGRESSPRICE    :=lv_hardwareegressprice;
  IN_HARDWAREID  := lv_hardwareid;
  IN_HARDWAREACCESSORYID := lv_accessoryid;
  IN_HARDWAREEGRESSID := lv_egressid;


  
lv_price := lv_hardwaretype_colorprice + lv_hardwareaccessoryprice + lv_hardwareegressprice;


Return lv_price;
END NEW_GETHARDWAREPRICE;