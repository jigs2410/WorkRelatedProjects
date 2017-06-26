
  CREATE OR REPLACE EDITIONABLE PROCEDURE "MSSQL"."PROC_WRITETOPRICELOG" 
(
  IN_ORDERID IN VARCHAR2 
, IN_ITEMID IN VARCHAR2 
, IN_UNITID IN VARCHAR2 
, IN_LINENUMBER IN VARCHAR2 
, IN_ATRIUMPRICE IN VARCHAR2 
, IN_SIZEID IN VARCHAR2 
, IN_SIZEPRICE IN VARCHAR2 
, IN_GRIDID IN VARCHAR2 
, IN_GRIDPRICE IN VARCHAR2 
, IN_TINTID IN VARCHAR2 
, IN_TINTPRICE IN VARCHAR2 
, IN_ENERGYID IN VARCHAR2 
, IN_ENERGYPRICE IN VARCHAR2 
, IN_SAFETYID IN VARCHAR2 
, IN_SAFETYPRICE IN VARCHAR2 
, IN_COLORID IN VARCHAR2 
, IN_COLORPRICE IN VARCHAR2 
, IN_WOOD_MULLID IN VARCHAR2 
, IN_WOOD_MULLPRICE IN VARCHAR2 
, IN_TIMESTAMP IN VARCHAR2 
, IN_STDSIZE IN VARCHAR2 
, IN_ISSHAPE IN VARCHAR2 
, IN_HASGRID IN VARCHAR2 
, IN_SCREENDEDUCT IN VARCHAR2 
, IN_ISPART IN VARCHAR2 
, IN_LOGNEXCEPT IN NUMBER
, IN_FINALPRICE IN NUMBER
, IN_SIZETYPE IN VARCHAR2
) AS 
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  
  
   
   insert into new_pricelog (orderid,itemid,unitid,linenumber, atriumprice,sizeid,sizeprice,gridid,gridprice,tintid,tintprice,
    energyid,energyprice,safetyid,safetyprice,colorid,colorprice,wood_mullid,wood_mullprice,timestamp,stdsize, isshape,hasgrid, screendeduct,ispart,lognexcept,finalprice,sizetype) values
    (in_orderid,in_itemid,in_unitid,in_linenumber,in_atriumprice,in_sizeid,in_sizeprice,in_gridid,in_gridprice,in_tintid,in_tintprice,
    in_energyid,in_energyprice,in_safetyid,in_safetyprice,in_colorid,in_colorprice,in_wood_mullid,in_wood_mullprice,sysdate,in_stdsize, in_isshape,in_hasgrid, in_screendeduct,in_ispart,IN_LOGNEXCEPT,IN_FINALPRICE,IN_SIZETYPE);
    
    COMMIT;
END PROC_WRITETOPRICELOG;