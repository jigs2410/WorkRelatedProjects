
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."BI_PRICINGFIELDTYPE" 
  before insert ON MSSQL.PRICINGFIELDTYPE
  for each row
begin
  if :NEW.PRICINGFIELDTYPEID is null then
    select PRICINGFIELDTYPE_SEQ.nextval into :NEW.PRICINGFIELDTYPEID from dual;
  end if;
end;

