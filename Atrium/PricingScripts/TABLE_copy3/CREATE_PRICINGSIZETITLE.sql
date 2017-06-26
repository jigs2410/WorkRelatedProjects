
  CREATE TABLE "MSSQL"."PRICINGSIZETITLE" 
   (	"PRICINGSIZEGROUPID" NUMBER NOT NULL ENABLE, 
	"PRICINGSIZEGROUPDESC" VARCHAR2(80) NOT NULL ENABLE, 
	"REC_CREATE_DATE" DATE, 
	"REC_UPDATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(20), 
	"UPDATED_BY" VARCHAR2(20), 
	 CONSTRAINT "PK_PRICINGSIZETITLE" PRIMARY KEY ("PRICINGSIZEGROUPID")
  USING INDEX PCTFREE 3 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING 
  STORAGE(INITIAL 131072 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "INDX"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 1 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MSSQL" 