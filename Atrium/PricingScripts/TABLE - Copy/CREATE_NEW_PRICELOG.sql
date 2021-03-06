
  CREATE TABLE "MSSQL"."NEW_PRICELOG" 
   (	"LOGID" NUMBER NOT NULL ENABLE, 
	"ORDERID" NUMBER, 
	"ITEMID" NUMBER, 
	"UNITID" NUMBER, 
	"LINENUMBER" NUMBER, 
	"ATRIUMPRICE" NUMBER DEFAULT 0, 
	"SIZEID" NUMBER DEFAULT 0, 
	"SIZEPRICE" NUMBER DEFAULT 0, 
	"GRIDID" NUMBER DEFAULT 0, 
	"GRIDPRICE" NUMBER DEFAULT 0, 
	"TINTID" NUMBER DEFAULT 0, 
	"TINTPRICE" NUMBER DEFAULT 0, 
	"ENERGYID" NUMBER DEFAULT 0, 
	"ENERGYPRICE" NUMBER DEFAULT 0, 
	"SAFETYID" NUMBER DEFAULT 0, 
	"SAFETYPRICE" NUMBER DEFAULT 0, 
	"COLORID" NUMBER DEFAULT 0, 
	"COLORPRICE" NUMBER DEFAULT 0, 
	"WOOD_MULLID" NUMBER DEFAULT 0, 
	"WOOD_MULLPRICE" NUMBER DEFAULT 0, 
	"TIMESTAMP" TIMESTAMP (6) DEFAULT Sysdate, 
	"STDSIZE" NUMBER DEFAULT 0, 
	"ISSHAPE" NUMBER DEFAULT 0, 
	"HASGRID" NUMBER DEFAULT 0, 
	"SCREENDEDUCT" NUMBER DEFAULT 0, 
	"ISPART" NUMBER DEFAULT 0, 
	"LOGNEXCEPT" NUMBER DEFAULT 0, 
	"FINALPRICE" NUMBER DEFAULT 0, 
	"SIZETYPE" VARCHAR2(50), 
	 CONSTRAINT "NEW_PRICELOG_PK" PRIMARY KEY ("LOGID")
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