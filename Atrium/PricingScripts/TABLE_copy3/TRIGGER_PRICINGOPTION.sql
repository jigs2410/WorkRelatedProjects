
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."BI_PRICINGOPTION" 
  before insert on "PRICINGOPTION"
  for each row
begin
  if :NEW."PRICINGOPTIONID" is null then
    select "PRICINGOPTION_SEQ".nextval into :NEW."PRICINGOPTIONID" from dual;
  end if;
  :new.rec_create_date := SYSDATE;
end;

