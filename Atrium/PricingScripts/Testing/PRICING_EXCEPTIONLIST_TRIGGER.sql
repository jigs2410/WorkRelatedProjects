
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."PRICING_EXCEPTIONLIST_TRG1" 
BEFORE INSERT ON PRICING_EXCEPTIONLIST 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT PRICING_EXCEPTIONLIST_SEQ1.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
 ALTER TRIGGER "MSSQL"."PRICING_EXCEPTIONLIST_TRG1" ENABLE