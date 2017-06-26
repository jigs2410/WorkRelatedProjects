
  CREATE TABLE "MSSQL"."OPTION_GLASS_ALUM" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"TINT" VARCHAR2(100), 
	"TINT_PRICE_TYPE" VARCHAR2(20), 
	"ENERGY" VARCHAR2(100), 
	"ENERGY_PRICE_TYPE" VARCHAR2(20), 
	"SAFETY" VARCHAR2(100), 
	"SAFETY_PRICE_TYPE" VARCHAR2(20), 
	"SHAPE" VARCHAR2(20), 
	"NFRC" NUMBER, 
	"CALC_SAFETY" NUMBER DEFAULT 0, 
	"UI_0_61" NUMBER DEFAULT 0, 
	"UI_62_73" NUMBER DEFAULT 0, 
	"UI_74_83" NUMBER DEFAULT 0, 
	"UI_84_93" NUMBER DEFAULT 0, 
	"UI_94_101" NUMBER DEFAULT 0, 
	"UI_102_110" NUMBER DEFAULT 0, 
	"UI_111_156" NUMBER DEFAULT 0, 
	"SAFETY_PRICE" NUMBER DEFAULT 0, 
	 CONSTRAINT "OPTION_GLASS_ALUM_PK" PRIMARY KEY ("ID")
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