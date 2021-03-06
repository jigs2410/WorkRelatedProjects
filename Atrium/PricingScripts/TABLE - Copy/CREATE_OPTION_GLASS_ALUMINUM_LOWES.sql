
  CREATE TABLE "MSSQL"."OPTION_GLASS_ALUMINUM_LOWES" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"UI_LOW" NUMBER DEFAULT 0, 
	"UI_HIGH" NUMBER DEFAULT 0, 
	"LOW_E" NUMBER DEFAULT 0, 
	"LOW_E_ARGON" NUMBER DEFAULT 0, 
	"ULTRA_LOW_E" NUMBER DEFAULT 0, 
	"ULTRA_LOW_E_ARGON" NUMBER DEFAULT 0, 
	"DOUBLE_STRENGTH" NUMBER DEFAULT 0, 
	"OBSCURE" NUMBER DEFAULT 0, 
	"TEMPERED" NUMBER, 
	"ENERGY_PRICETYPE" VARCHAR2(50), 
	"DOUBLESTRENGTH_PRICETYPE" VARCHAR2(50), 
	"TEMPERED_PRICETYPE" VARCHAR2(50), 
	 CONSTRAINT "OPTION_GLASS_ALUMINUM_LOWE_PK" PRIMARY KEY ("ID")
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