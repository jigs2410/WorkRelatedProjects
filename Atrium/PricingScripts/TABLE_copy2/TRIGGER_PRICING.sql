
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."BI_PRICING" 
  before insert on "PRICING"
  for each row
begin
  if :NEW."LISTPRICEID" is null then
    select "PRICING_SEQ".nextval into :NEW."LISTPRICEID" from dual;
  end if;
end;

