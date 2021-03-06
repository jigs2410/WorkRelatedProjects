
  CREATE TABLE "MSSQL"."PRICING_DESC" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"OPTIONID" NUMBER, 
	"OPTIONVALUE" VARCHAR2(800), 
	"VALUETYPE" VARCHAR2(20), 
	"VALUE" NUMBER, 
	"DESC_NAME" VARCHAR2(200), 
	"SERIES" VARCHAR2(20), 
	"MODEL" VARCHAR2(20), 
	"STYLE" VARCHAR2(20), 
	"SQLCONDITION" VARCHAR2(500), 
	"WIDTHES" VARCHAR2(20), 
	"HEIGHTES" VARCHAR2(20), 
	"LOWERUI" VARCHAR2(20), 
	"UPPERUI" VARCHAR2(20), 
	"PRICEUPTOHIGHUI" VARCHAR2(20), 
	"PRICEOVERHIGHUI" VARCHAR2(20), 
	 CONSTRAINT "PRICING_DESC_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MSSQL"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MSSQL" 