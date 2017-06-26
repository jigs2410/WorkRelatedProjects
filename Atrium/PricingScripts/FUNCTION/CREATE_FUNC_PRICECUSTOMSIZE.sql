
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_PRICECUSTOMSIZE" 
(
  IN_MODEL IN VARCHAR2 
, IN_WIDTH IN VARCHAR2 
, IN_HEIGHT IN VARCHAR2 
,IN_SIZE NUMBER
,IN_SCREEN NUMBER
,IN_EFFECTIVEUNIT NUMBER
) RETURN NUMBER AS 
p_sizegroupid number :=0;
p_custom number :=0;
p_width VARCHAR(25) :=IN_WIDTH;

BEGIN
IF IN_EFFECTIVEUNIT > 1 THEN
      --we need to "resize" the unit to a fundamental component size based on oracle effective units
      
      
       --select func_ns_to_ns_unit(lv_widthns,lv_effectiveunit),func_os_to_es_unit(lv_model,lv_itemwidthos,1,lv_effectiveunit) into lv_widthns, lv_widthes from dual;
       --select func_ns_to_os(lv_widthns) into lv_itemwidthos from dual;
       -- changed to always calculate nominal size
       select func_es_to_es_unit(IN_MODEL,IN_WIDTH,1,IN_EFFECTIVEUNIT) into p_width from dual;
       
    END IF;
    
 if ( IN_SCREEN =1) then --calculate for screen
  begin  
    select prevalue into p_sizegroupid from pricing p
    left join pricingoption po on p.pricinggroupid = po.PRICINGGROUPID
    
    where 
    --model = IN_MODEL 
    regexp_like ( p.model,IN_MODEL,'i')
    and p.optionid = 0 and po.fieldtypeid= 22  and rownum =1 order by p.pricinggroupid desc;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        p_sizegroupid := 0;
  end;
  else 
    begin  
    select prevalue into p_sizegroupid from pricing p
    left join pricingoption po on p.pricinggroupid = po.PRICINGGROUPID
    where
    --model = IN_MODEL 
    regexp_like ( p.model,IN_MODEL,'i')
    and p.optionid = 0 and po.fieldtypeid= 2   and rownum =1 order by p.pricinggroupid desc;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        p_sizegroupid := 0;
  end;
  end if;
  
  if (p_sizegroupid !=0) then
    begin  
      select 1 into p_custom from pricingsize
           where pricingsizegroupid= p_sizegroupid and sizingsystem='E' and width=to_char(p_width) and height=to_char(in_height);
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
          p_custom:= 0;
    end;
  end if;


  RETURN p_custom;
END FUNC_PRICECUSTOMSIZE;