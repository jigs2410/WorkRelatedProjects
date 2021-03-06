
  CREATE OR REPLACE EDITIONABLE TRIGGER "MSSQL"."OPTION_HARDWARE_LOWES_TRG" 
BEFORE INSERT ON OPTION_HARDWARE_LOWES 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT OPTION_HARDWARE_LOWES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;

