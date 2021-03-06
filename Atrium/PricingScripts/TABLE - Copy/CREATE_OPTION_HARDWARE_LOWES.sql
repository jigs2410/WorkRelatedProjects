
  CREATE TABLE "MSSQL"."OPTION_HARDWARE_LOWES" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"TYPE" VARCHAR2(200) DEFAULT '0', 
	"COLOR" VARCHAR2(200) DEFAULT '0', 
	"ACCESSORY" VARCHAR2(200) DEFAULT '0', 
	"EGRESS" VARCHAR2(200) DEFAULT '0', 
	"STYLE" VARCHAR2(200) DEFAULT 'ALL', 
	"SERIES" VARCHAR2(200) DEFAULT 'ALL', 
	"CATEGORY" VARCHAR2(20) DEFAULT 'ALL', 
	"SECTIONS" NUMBER DEFAULT 2, 
	"PRICE" NUMBER, 
	"PRICE_TYPE" VARCHAR2(20) DEFAULT 'FIXED', 
	"FRAME_COLOR" VARCHAR2(200) DEFAULT 'ALL', 
	 CONSTRAINT "OPTION_HARDWARE_LOWES_PK" PRIMARY KEY ("ID")
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