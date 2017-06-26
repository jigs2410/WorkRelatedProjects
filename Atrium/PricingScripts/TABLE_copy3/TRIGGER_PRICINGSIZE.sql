
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."BI_PRICINGSIZE" 
  before insert on "PRICINGSIZE"
  for each row
begin
  if :NEW."PRICINGSIZEID" is null then
    select "PRICINGSIZE_SEQ".nextval into :NEW."PRICINGSIZEID" from dual;

  end if;
  :new.rec_create_date := SYSDATE;
end;

