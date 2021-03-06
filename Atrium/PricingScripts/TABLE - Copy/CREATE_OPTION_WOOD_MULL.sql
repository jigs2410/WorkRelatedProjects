
  CREATE TABLE "MSSQL"."OPTION_WOOD_MULL" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"WOODSURR_MULLTYPE" VARCHAR2(200), 
	"UNIT_1" NUMBER DEFAULT 0, 
	"UNIT_2" NUMBER DEFAULT 0, 
	"UNIT_3" NUMBER DEFAULT 0, 
	"UNIT_4" NUMBER DEFAULT 0, 
	"UNIT_5" NUMBER DEFAULT 0, 
	"UNIT_6" NUMBER DEFAULT 0, 
	"UNIT_7" NUMBER DEFAULT 0, 
	"SHAPES" NUMBER DEFAULT 0, 
	"STYLE" VARCHAR2(200) DEFAULT 'ALL', 
	"STDSIZE" NUMBER DEFAULT 1, 
	"PRICETYPE" VARCHAR2(20) DEFAULT 'FIXED', 
	"PARTS" NUMBER DEFAULT 0, 
	 CONSTRAINT "OPTION_MULL_PK" PRIMARY KEY ("ID")
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