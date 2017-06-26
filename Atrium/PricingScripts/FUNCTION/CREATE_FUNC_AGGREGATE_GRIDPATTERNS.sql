
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_AGGREGATE_GRIDPATTERNS" 
(
  P_UNITID IN NUMBER 
) RETURN VARCHAR2 AS 
lv_gridpattern VARCHAR(200);

BEGIN

  select listagg(l5_glass.gridpattern, '-') 
  within group (order by l4_sash.frameid, l4_sash.sashlocation desc) gridpattern into lv_gridpattern
  from l4_sash, l5_glass 
  where l4_sash.frameid in (select frameid from l3_frame where unitid = P_UNITID) 
  and l5_glass.sashid = l4_sash.sashid group by l4_sash.FRAMEID;
  
  
  RETURN lv_gridpattern;

END FUNC_AGGREGATE_GRIDPATTERNS;