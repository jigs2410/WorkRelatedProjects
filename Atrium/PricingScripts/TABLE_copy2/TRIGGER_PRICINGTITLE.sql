
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."BI_PRICINGTITLE" 
  before insert on "PRICINGTITLE"
  for each row
begin
  if :NEW."PRICINGGROUPID" is null then
    select "PRICINGTITLE_SEQ".nextval into :NEW."PRICINGGROUPID" from dual;
  end if;
end;

