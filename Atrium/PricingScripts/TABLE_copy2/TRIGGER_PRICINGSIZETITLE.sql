
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."BI_PRICINGSIZETITLE" 
  before insert on "PRICINGSIZETITLE"
  for each row
begin
  if :NEW."PRICINGSIZEGROUPID" is null then
    select "PRICINGSIZETITLE_SEQ".nextval into :NEW."PRICINGSIZEGROUPID" from dual;
  end if;
end;

