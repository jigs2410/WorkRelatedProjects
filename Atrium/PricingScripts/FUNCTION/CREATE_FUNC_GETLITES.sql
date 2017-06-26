
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_GETLITES" 
(
  P_GRIDPATTERN VARCHAR2 
) RETURN NUMBER AS 
lv_lites number :=0;
lv_toplite number:=0;
lv_topliteH number:=0;
lv_topliteV number:=0;
lv_bottomlite number :=0;
lv_bottomliteH number :=0;
lv_bottomliteV number :=0;
lv_gridpattern varchar2(200);

BEGIN

 --DBMS_OUTPUT.PUT_LINE(P_GRIDPATTERN);
 
  lv_GRIDPATTERN := upper(P_GRIDPATTERN);
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