
  CREATE OR REPLACE EDITIONABLE PROCEDURE "MSSQL"."PROC_INSERTEXCEPTIONS" 
(
  IN_ACCOUNTID IN VARCHAR2 
--, IN_SERIES IN VARCHAR2 
--, IN_MODEL IN VARCHAR2 
--, IN_EXCEPTIONDESC IN NUMBER 
--, IN_DISCOUNTTYPE IN VARCHAR2 
--, IN_DISCOUNTVALUE IN VARCHAR2 
--, IN_STYLE IN VARCHAR2 
--, IN_CUSTOMERID IN VARCHAR2 
--, IN_EX_APPLYON IN VARCHAR2 
, 
ERRORMESSAGE OUT VARCHAR2 
, RETVALUE OUT NUMBER 
) AS 

--IN_ACCOUNTID VARCHAR2(200):='''AA8108,AA0108''';

singleaccount varchar2(20);
singlemodel varchar2(20);
singleseries varchar2(20);
singlestyle varchar2(20);



cursor c1 is 

select regexp_substr(replace(IN_ACCOUNTID,'''',''),'[^,]+', 1, level) from dual
connect by regexp_substr(IN_ACCOUNTID, '[^,]+', 1, level) is not null;


-----RULES / VALIDATION etc
-- 1) Check if series,style,model in the exception assignment are correct if not return error
-- 2) if assignment are correct check if accounts passed is valid
-- 3) now check if account/series/style/model already exist for same exception if so 
--    dont add this accountentry at all even if there series is being passed this time around 
--    although report error on this account but continue processing on other accounts.
-- 4) if account/series/style/model combo doesnt exist then add or append to existing rule with same discount type and value
-----

BEGIN

--  open c_exception;
--    loop fetch c_exception into lv_temp,lv_exassignid,lv_exdiscounttype,lv_exdescid,lv_exapplyon,lv_exdiscountvalue,
  if (IN_ACCOUNTID like '%,%' ) then
  begin
    open c1 ;
    loop fetch c1 into singleaccount;
    exit when c1%notfound;
    
    DBMS_OUTPUT.PUT_LINE ('Single account IS ' || singleACCOUNT);
    end loop;
    close c1;
    exception when others then 
    begin
       DBMS_OUTPUT.PUT_LINE ('Single account IS larger than expected ' );
    end;
 end; 
   end if;
   
   
  
--First validate account ,series ,model , discounttype,style

 -- insert into new_exceptions (accountid,series,model,exceptiondesc,discounttype,discountvalue,style,customerid,ex_applyon) values (IN_accountid,IN_series,IN_model,IN_exceptiondesc,IN_discounttype,IN_discountvalue,IN_style,IN_customerid,IN_ex_applyon);

-- select regexp_substr(IN_ACCOUNTID,'[^,]+', 1, level) from dual
--connect by regexp_substr(IN_ACCOUNTID, '[^,]+', 1, level) is not null;

 
 DBMS_OUTPUT.PUT_LINE ('ACCOUNTID IS ' || IN_ACCOUNTID);
 
  ERRORMESSAGE:='';
  RETVALUE :=0;
  
  
END PROC_INSERTEXCEPTIONS;