
  CREATE TABLE "MSSQL"."NEW_EXCEPTIONS_BASE" 
   (	"EX_SIZEID" NUMBER NOT NULL ENABLE, 
	"SERIES" VARCHAR2(200) DEFAULT '0', 
	"MODEL" VARCHAR2(200) DEFAULT '0', 
	"STYLE" VARCHAR2(200) DEFAULT '0', 
	"WIDTH" NUMBER DEFAULT 0, 
	"HEIGHT" NUMBER DEFAULT 0, 
	"UI" NUMBER DEFAULT 0, 
	"UI_PRICETYPE" VARCHAR2(20) DEFAULT '0', 
	"CLEAR" NUMBER DEFAULT 0, 
	"CLEAR_PRICETYPE" VARCHAR2(20) DEFAULT '0', 
	"WITHGRID" NUMBER DEFAULT 0, 
	"WITHGRID_PRICETYPE" VARCHAR2(20) DEFAULT '0', 
	"SCREEN_DEDUCT" NUMBER DEFAULT 0, 
	"SCREEN_DEDUCT_PRICETYPE" VARCHAR2(20) DEFAULT '0', 
	"LOWERUI" NUMBER DEFAULT 0, 
	"UPPERUI" NUMBER DEFAULT 0, 
	"BRACKETPRICE" NUMBER DEFAULT 0, 
	"MAXUI" NUMBER DEFAULT 0, 
	"MAXUIPRICE" NUMBER DEFAULT 0, 
	"MAXPERUI" NUMBER DEFAULT 0, 
	"CLEAR_MINUI" NUMBER DEFAULT 0, 
	"WITHGRID_MINUI" NUMBER DEFAULT 0, 
	"TRIPLEEYEBROW" VARCHAR2(20) DEFAULT '0', 
	"WIDTH_LOWER" NUMBER DEFAULT 0, 
	"WIDTH_UPPER" NUMBER DEFAULT 0, 
	"HEIGHT_LOWER" NUMBER DEFAULT 0, 
	"HEIGHT_UPPER" NUMBER DEFAULT 0, 
	"BB_PRICE" NUMBER DEFAULT 0, 
	"SECTIONS" NUMBER DEFAULT 0, 
	"BB_PRICE_TYPE" VARCHAR2(20) DEFAULT '0', 
	"DESC_BASE" VARCHAR2(200) DEFAULT '0', 
	"GRIDTYPE" VARCHAR2(200) DEFAULT '0', 
	"GRIDSTYLE" VARCHAR2(200) DEFAULT '0', 
	"GRIDPATTERN" VARCHAR2(200) DEFAULT '0', 
	"COLOR" VARCHAR2(200) DEFAULT '0', 
	"EX_ID" NUMBER, 
	 CONSTRAINT "NEW_EXCEPTIONS_BASE_PK" PRIMARY KEY ("EX_SIZEID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MSSQL"  ENABLE, 
	 CONSTRAINT "NEW_EXCEPTIONS_BASE_UK1" UNIQUE ("DESC_BASE")
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