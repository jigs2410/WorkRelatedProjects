
  CREATE OR REPLACE EDITIONABLE PROCEDURE "MSSQL"."PROC_WRITETOPRICINGLOG" 
(
  IN_ORDERID IN NUMBER
, IN_ITEMID IN NUMBER 
, IN_UNITID IN NUMBER
, IN_LINENUMBER IN NUMBER
, IN_LINETYPEID IN NUMBER
, IN_LOGNEXCEPT IN NUMBER
, IN_APPLIEDON IN VARCHAR2
, IN_OPTIONTABLEID IN NUMBER
, IN_PRICE IN NUMBER 
, IN_STDSIZE IN NUMBER DEFAULT 0
, IN_ISSHAPE IN NUMBER DEFAULT 0
, IN_HASGRID IN NUMBER DEFAULT 0
, IN_SCREENDEDUCT IN NUMBER DEFAULT 0
, IN_ISPART IN NUMBER DEFAULT 0
, IN_SIZETYPE IN VARCHAR2 DEFAULT ''
, IN_WIDTH  IN NUMBER DEFAULT 0
, IN_HEIGHT  IN NUMBER DEFAULT 0
, IN_MULLEDUNITS  IN NUMBER DEFAULT 0
, IN_EFFECTIVEUNIT  IN NUMBER DEFAULT 0
, IN_SECTIONS  IN NUMBER DEFAULT 0

) AS 
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  
   insert into new_pricinglog (orderid,itemid,unitid,linenumber,linetypeid,lognexcept,appliedon,optiontableid,price,stdsize, isshape,hasgrid, 
                              screendeduct,ispart,sizetype,orderwidth,orderheight,mulledunits,effectiveunit,sections) 
                              values
                              (in_orderid,in_itemid,in_unitid,in_linenumber,in_linetypeid,in_lognexcept,in_appliedon,in_optiontableid,in_price,in_stdsize, in_isshape,in_hasgrid,
                              in_screendeduct,in_ispart,in_sizetype,in_width,in_height,in_mulledunits,in_effectiveunit,in_sections);
    
    COMMIT;
END PROC_WRITETOPRICINGLOG;