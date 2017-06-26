
  CREATE OR REPLACE EDITIONABLE PACKAGE "MSSQL"."INSERT_COPY_EXCEPTIONS" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
G_ACCOUNTID VARCHAR2 (20000);
G_SERIES VARCHAR2 (20000);
G_MODEL VARCHAR2 (20000); 
G_STYLE VARCHAR2 (20000);
G_CUSTOMERID VARCHAR2 (20000); 
G_USER_ID VARCHAR2(20);


G_EXCEPTIONDESC NUMBER :=0;
G_DISCOUNTTYPE VARCHAR2 (100);
G_DISCOUNTVALUE NUMBER;

G_SINGLEACCOUNT Varchar2(20);

G_EX_APPLYON VARCHAR2 (50);
G_ERRORMESSAGE VARCHAR2 (20000);
G_RETVALUE NUMBER :=0;

PROCEDURE PROC_INSERTEXCEPTIONS 
(
  IN_ACCOUNTID IN VARCHAR2 

, IN_MODEL IN VARCHAR2  DEFAULT '-'
, IN_SERIES IN VARCHAR2 DEFAULT '-'
, IN_STYLE IN VARCHAR2 DEFAULT '-'
, IN_CUSTOMERID IN VARCHAR2 DEFAULT '-'
, IN_EXCEPTIONDESC IN NUMBER 
, IN_DISCOUNTTYPE IN VARCHAR2 
, IN_DISCOUNTVALUE IN NUMBER 
, IN_EX_APPLYON IN VARCHAR2
, IN_USER_ID IN VARCHAR2
 
, ERRORMESSAGE OUT VARCHAR2 
, RETVALUE OUT NUMBER 
) ;

PROCEDURE PROC_COPYEXCEPTIONS
(
  IN_COPYFROM IN VARCHAR2
, IN_COPYTO IN VARCHAR2
, IN_EXCEPTIONID IN NUMBER
, IN_USER_ID IN VARCHAR2
, ERRORMESSAGE OUT VARCHAR2 
);



END INSERT_COPY_EXCEPTIONS;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "MSSQL"."INSERT_COPY_EXCEPTIONS" AS

function checkSeriesStyleModel (IN_withAccount in number  DEFAULT 0, OUT_EXCEPTIONID OUT NUMBER )return number as

singleseries varchar2(200):='';
singlestyle varchar2(200):='';
singlemodel varchar2(200):='';

cursor c_model is 
select trim(regexp_substr(replace(G_MODEL,'''',''),'[^,]+', 1, level)) from dual
connect by regexp_substr(G_MODEL, '[^,]+', 1, level) is not null;

cursor c_series is 
select trim(regexp_substr(replace(G_SERIES,'''',''),'[^,]+', 1, level)) from dual
connect by regexp_substr(G_SERIES, '[^,]+', 1, level) is not null;


cursor c_STYLE is 
select trim(regexp_substr(replace(G_STYLE,'''',''),'[^,]+', 1, level)) from dual
connect by regexp_substr(G_STYLE, '[^,]+', 1, level) is not null;


lv_return number:=1;

begin
  OUT_EXCEPTIONID := 0;

--  if (G_MODEL = 'ALL') then -- if applys to all then ok
--     lv_return := 1;
-- else 
     if (G_MODEL = '-'    and  (G_STYLE!='-' or G_SERIES!='-') )then -- if series is zero we need to make sure eiether model or style is supplied
      lv_return := 1;
      else 
          begin
              open c_model ;
              loop fetch c_model into singlemodel;
              exit when c_model%notfound;
               if (IN_WITHACCOUNT =1 ) then -- check if account model combo exisits in exception. this is for insert loop in exceptions. --since model is already checked dont have to worry about its validity.
                  begin
                    select 0,id into lv_return,out_exceptionid from new_exceptions where accountid =G_Singleaccount and regexp_like (model, ''''||SingleModel||'''','i') and exceptiondesc = G_EXCEPTIONDESC ;
                    G_ERRORMESSAGE := G_ERRORMESSAGE||' DUPLICATE MODEL ENTRY: '|| singlemodel || ' for account '|| G_Singleaccount ;
                    return lv_return; -- as soon as we intercept duplicate we exit
                    exception when no_data_found then
                    begin 
                      lv_return := 1;
                    end;
                  end;
                  else 
                    select distinct model into singlemodel from modelnumberMAP where model = singleMODEL; --we do this initially
                    DBMS_OUTPUT.PUT_LINE ('CheckSeriesStyleModel model '|| singlemodel );   
                end if; --if (IN_WITHACCOUNT =1 )
              end loop;
              close c_model;
              exception when others then 
              begin
                -- DBMS_OUTPUT.PUT_LINE ('Single account IS larger than expected ' );
                 G_ERRORMESSAGE := G_ERRORMESSAGE||'MODEL : '|| singlemodel || ' . ';
                 lv_return := 0;
              end; --exception
            end; 
      end if;
   --end if;


IF (LV_RETURN = 1 ) THEN ---CONTINUE CHECKING SERIES AND STYLE IF MODEL IS GOOD.

--    if (G_SERIES = 'ALL') then -- if applys to all then ok
--         lv_return := 1;
--     else 
      if (G_SERIES = '-'    and  (G_STYLE!='-' or G_MODEL!='-') )then -- if series is zero we need to make sure eiether model or style is supplied
          lv_return := 1;
          else 
              begin
                  open c_series ;
                  loop fetch c_series into singleseries;
                  exit when c_series%notfound;
                    if (IN_WITHACCOUNT =1 ) then -- check if account model combo exisits in exception. this is for insert loop in exceptions.
                      begin
                        
                        
                        select 0,id into lv_return,out_exceptionid from new_exceptions where accountid =G_Singleaccount  and regexp_like (series, ''''||Singleseries||'''','i') and exceptiondesc = G_EXCEPTIONDESC ;
                      
                        G_ERRORMESSAGE := G_ERRORMESSAGE||' DUPLICATE SERIES ENTRY: '|| singleseries || ' for account '|| G_Singleaccount ;
                        return lv_return;
                        exception when no_data_found then
                        begin 
                          lv_return := 1;
                         end;
                        end;
                      else 
                        select distinct series into singleseries from modelnumberMAP where series = singleseries;
                        DBMS_OUTPUT.PUT_LINE ('CheckSeriesStyleModel series '|| singleseries );
                      end if;
                    end loop;
                    close c_series;
                    exception when others then 
                    begin
                     G_ERRORMESSAGE := G_ERRORMESSAGE||'Series : '|| singleseries|| ' . ';
                     lv_return := 0;
                    end;
                end; 
            end if;--g_series=-
       --end if;--g_series= all
END IF;--lv_return

IF (LV_RETURN = 1 ) THEN ---CONTINUE CHECKING SERIES AND STYLE IF MODEL IS GOOD.
--    if (G_STYLE = 'ALL') then -- if applys to all then ok
--         lv_return := 1;
--     else 
       if (G_STYLE = '-'    and  (G_SERIES!='-' or G_MODEL!='-') )then -- if series is zero we need to make sure eiether model or style is supplied
          lv_return := 1;
          else 
              begin
                  open c_sTYLE ;
                  loop fetch c_STYLE into singleSTYLE;
                  exit when c_sTYLE%notfound;
                  
                    if (IN_WITHACCOUNT =1 ) then -- check if account model combo exisits in exception. this is for insert loop in exceptions.
                      begin
                        select 0,id into lv_return,out_exceptionid from new_exceptions where accountid =G_Singleaccount and regexp_like (style, ''''||Singlestyle||'''','i') and exceptiondesc = G_EXCEPTIONDESC ;
                        G_ERRORMESSAGE := G_ERRORMESSAGE||' DUPLICATE style ENTRY: '|| singlestyle || ' for account '|| G_Singleaccount ;
                        return lv_return;
                        exception when no_data_found then
                        begin 
                          lv_return := 1;
                        end;
                      end;
                    else
                        select distinct sTYLE into singlesTYLE from modelnumberMAP where sTYLE = singleSTYLE;
                        DBMS_OUTPUT.PUT_LINE ('CheckSeriesStyleModel style '|| singlestyle );
                    end if;
                    
                  end loop;
                  close c_sTYLE;
                  exception when others then 
                  begin
                     G_ERRORMESSAGE := G_ERRORMESSAGE||'STYLE : '|| singleSTYLE|| ' . ';
                     lv_return := 0;
                  end;
                end; 
            end if;
     -- end if;
END IF;

return lv_return;

end checkSeriesSTYLEMODEL;



function checkCustomerId return number as 

LV_RETURN NUMBER := 1;
singleID varchar2(200);
cursor c1 is 
select trim(regexp_substr(G_CUSTOMERID,'[^,]+', 1, level)) from dual
connect by regexp_substr(G_CUSTOMERID, '[^,]+', 1, level) is not null;

begin

--  if (G_ACCOUNTID = 'ALL' ) then
--      LV_RETURN := 1;
--  ElSE  
      if ( (G_CUSTOMERID = '-' and G_ACCOUNTID !='-') ) then
            LV_RETURN := 1;
        ElSE 
            begin
                open c1 ;
                loop fetch c1 into singleID;
                exit when c1%notfound;
                  select CUSTOMERid into singleID from accountsmaster where CUSTOMERid = singleID;
                end loop;
                close c1;
                exception when others then 
                begin
                     G_ERRORMESSAGE := G_ERRORMESSAGE||' CUSTOMER : '|| singleID|| ' . ';
                      LV_RETURN := 0;     
                end;
              end; 
          end if;
  -- end if;

return LV_RETURN;
end checkCustomerId;

Procedure checkAccountId_Insert --(retvalue out number)
as 
PRAGMA AUTONOMOUS_TRANSACTION;

singleaccount varchar2(200);
exceptionid number :=0;
match_exceptionid number :=0;
exceptiondescr new_exceptiondesc.descr%type;



cursor c1 is 
--select replace(replace(trim(regexp_substr(G_ACCOUNTID,'[^,]+', 1, level)),chr(10),''),chr(13),'') from dual
--connect by regexp_substr(G_ACCOUNTID, '[^,]+', 1, level) is not null;
--
--select trim(regexp_substr(replace (replace(G_ACCOUNTID,' ',','),chr(10),','),'[^,]+', 1, level)) from dual
--connect by trim(regexp_substr(replace (replace(G_ACCOUNTID,' ',','),chr(10),','),'[^,]+', 1, level)) is not null;

select trim(regexp_substr(G_ACCOUNTID,'[^,]+', 1, level)) from dual
connect by regexp_substr(G_ACCOUNTID, '[^,]+', 1, level) is not null;


lv_return number :=0;
begin

--  if (G_ACCOUNTID like '%,%' ) then
--make the change before itself instead of making complicated select string-- replace newline and space with ,
      G_ACCOUNTID := replace (G_ACCOUNTID,chr(10),',');
      G_ACCOUNTID := replace (G_ACCOUNTID,chr(13),',');
      G_ACCOUNTID := replace (G_ACCOUNTID,' ',',');
  
      open c1 ;
      loop fetch c1 into singleaccount;
      exit when c1%notfound;
      begin
          singleaccount := replace (singleaccount,' ','');
          singleaccount := trim(singleaccount);
          
          select accountid into G_singleaccount from accountsmaster where accountid = singleaccount; --check account and start validation and insertion process
          lv_return := checkSeriesStyleModel(1,ExceptionId);
          if (lv_return != 0) then -- now try to find closest match based on exceptiondesc id and if model ,series or style is supplied and append to it.
            begin 
              case 
                when ( G_MODEL!='-' and  G_STYLE='-'  and G_SERIES='-') then --get similiar exception already defined for that 
                  select id into match_exceptionid from new_exceptions where accountid =singleaccount and exceptiondesc = G_EXCEPTIONDESC and discounttype = G_DISCOUNTTYPE and discountvalue = G_DISCOUNTVALUE and model!='-';-- and series =G_SERIES and style = G_STYLE;
                  update new_exceptions set model = model ||',' ||G_MODEL || '' ,user_id = G_USER_ID ,datestamp = sysdate where id = match_exceptionid;
                
                 when (G_SERIES!='-' and G_STYLE!='-' and G_MODEL = '-') then 
                  select id into match_exceptionid from new_exceptions where accountid =singleaccount and exceptiondesc = G_EXCEPTIONDESC and discounttype = G_DISCOUNTTYPE and discountvalue = G_DISCOUNTVALUE and series !='-' and model ='-' and style = G_STYLE ;
                  update new_exceptions set model = model ||',' ||G_SERIES || ''  ,user_id = G_USER_ID ,datestamp = sysdate where id = match_exceptionid;
                 
                 when (G_SERIES!='-' and G_STYLE='-' and G_MODEL = '-') then 
                  select id into match_exceptionid from new_exceptions where accountid =singleaccount and exceptiondesc = G_EXCEPTIONDESC and discounttype = G_DISCOUNTTYPE and discountvalue = G_DISCOUNTVALUE and series !='-' and model ='-' and style ='-' ;
                  update new_exceptions set model = model ||',' ||G_SERIES || '' ,user_id = G_USER_ID ,datestamp = sysdate where id = match_exceptionid;
                  
                 when (G_SERIES='-' and G_STYLE!='-' and G_MODEL = '-') then 
                  select id into match_exceptionid from new_exceptions where accountid =singleaccount and exceptiondesc = G_EXCEPTIONDESC and discounttype = G_DISCOUNTTYPE and discountvalue = G_DISCOUNTVALUE and style !='-' and series ='-' and model = '-' ;
                  update new_exceptions set model = model ||',' ||G_STYLE || ''  ,user_id = G_USER_ID ,datestamp = sysdate where id = match_exceptionid;
                else 
                  match_exceptionid :=0;
                -- insert into new_exceptions (accountid,series,model,exceptiondesc,discounttype,discountvalue,style,customerid,ex_applyon) values (IN_accountid,IN_series,IN_model,IN_exceptiondesc,IN_discounttype,IN_discountvalue,IN_style,IN_customerid,IN_ex_applyon);
              end case;
            exception when no_data_found then
              match_exceptionid :=0;
            end ;
            
            if (match_exceptionid = 0) then --now try to insert
                insert into new_exceptions (accountid,series,model,exceptiondesc,discounttype,discountvalue,style,customerid,ex_applyon,user_id) values (G_singleaccount,G_series,G_model,G_exceptiondesc,G_discounttype,G_discountvalue,G_style,G_customerid,G_ex_applyon,G_USER_ID);
            end  if; 
            
            else
               select descr into exceptiondescr from new_exceptiondesc where id in (select exceptiondesc from new_exceptions where id = exceptionId);
                 G_ERRORMESSAGE := G_ERRORMESSAGE||' already has exception '|| exceptiondescr ||' . '; 
            end if; 
                
           
          exception when others then 
          begin
            -- DBMS_OUTPUT.PUT_LINE ('Single account IS larger than expected ' );
             G_ERRORMESSAGE := G_ERRORMESSAGE||' Invalid Account : '|| singleAccount || ' . ';
             
             --Replace invalid accounts so only good accounts can be inserted.
             G_ACCOUNTID := replace (G_ACCOUNTID,','||SingleAccount,'');
             --DBMS_OUTPUT.PUT_LINE (' Account id now is  ' || G_ACCOUNTID );              
            end; 
       end;
       end loop;
      close c1;
 
-- DBMS_OUTPUT.PUT_LINE ('ACCOUNTID IS ' || G_ACCOUNTID);

commit;
--return 1;
end checkAccountId_Insert;



PROCEDURE PROC_INSERTEXCEPTIONS 
(
 IN_ACCOUNTID IN VARCHAR2 

, IN_MODEL IN VARCHAR2  DEFAULT '-'
, IN_SERIES IN VARCHAR2 DEFAULT '-'
, IN_STYLE IN VARCHAR2 DEFAULT '-'
, IN_CUSTOMERID IN VARCHAR2 DEFAULT '-'
, IN_EXCEPTIONDESC IN NUMBER 

, IN_DISCOUNTTYPE IN VARCHAR2 
, IN_DISCOUNTVALUE IN NUMBER 
, IN_EX_APPLYON IN VARCHAR2 
, IN_USER_ID IN VARCHAR2

, ERRORMESSAGE OUT VARCHAR2 
, RETVALUE OUT NUMBER 
) AS 

singleaccount varchar2(20);
singlemodel varchar2(20);
singleseries varchar2(20);
singlestyle varchar2(20);
ExceptionId number;

lv_return number :=0;

--cursor c1 is 
--
--select regexp_substr(IN_ACCOUNTID,'[^,]+', 1, level) from dual
--connect by regexp_substr(IN_ACCOUNTID, '[^,]+', 1, level) is not null;


-----RULES / VALIDATION etc
-- 1) Check if series,style,model in the exception assignment are correct if not return error
-- 2) if assignment are correct check if accounts passed is valid
-- 3) now check if account/series/style/model already exist for same exception if so 
--    dont add this accountentry at all even if there series is being passed this time around 
--    although report error on this account but continue processing on other accounts.
-- 4) if account/series/style/model combo doesnt exist then add or append to existing rule with same discount type and value
-----

BEGIN

--Assign global variables;

G_ACCOUNTID     := IN_ACCOUNTID;
G_SERIES        := IN_SERIES;
G_MODEL         := IN_MODEL;
G_STYLE         := IN_STYLE;
G_CUSTOMERID    := IN_CUSTOMERID;
--
G_EXCEPTIONDESC := IN_EXCEPTIONDESC;
G_DISCOUNTTYPE  := IN_DISCOUNTTYPE;
G_DISCOUNTVALUE := IN_DISCOUNTVALUE;
G_EX_APPLYON    := IN_EX_APPLYON;

G_USER_ID        := IN_USER_ID;

---DO VALIDATIONDS

 ERRORMESSAGE:='';

  --Check model,series,style and customer if valid go on to checking accounts.
  
  lv_return := checkSeriesStyleModel(0,ExceptionId);
  
  if (lv_return =1 and checkCustomerID()= 1) then 
      CHECKACCOUNTID_INSERT(); --check accounts and if account model,series,style combo exists and if not try to match to closest combo and append or just insert new record
  end if;
  
 RETVALUE :=lv_return;
  
  --ERRORMESSAGE :=G_ERRORMESSAGE || 'Supplied Params :- ' || G_ACCOUNTID || ',.'||G_EXCEPTIONDESC||'.,'||G_EX_APPLYON||'.' ;
  ERRORMESSAGE :=G_ERRORMESSAGE;
  DBMS_OUTPUT.PUT_LINE ('RETURNS :- G_ERRORMESSAGE >> ' || G_ERRORMESSAGE);
  DBMS_OUTPUT.PUT_LINE ('RETURNS :- RETVALUE >> ' || RETVALUE);
  
END PROC_INSERTEXCEPTIONS;



PROCEDURE PROC_COPYEXCEPTIONS
(
  IN_COPYFROM IN VARCHAR2
, IN_COPYTO IN VARCHAR2
, IN_EXCEPTIONID IN NUMBER
, IN_USER_ID IN VARCHAR2
, ERRORMESSAGE OUT VARCHAR2 


) AS
BEGIN

--validation is done on apex side.

select series,model,style,'-',exceptiondesc,discounttype,discountvalue,ex_applyon into  G_SERIES,G_MODEL,G_STYLE,G_CUSTOMERID,G_EXCEPTIONDESC,G_DISCOUNTTYPE,G_DISCOUNTVALUE,G_EX_APPLYON
from new_exceptions where accountid = TRIM(IN_COPYFROM) and id = IN_exceptionid;

G_ACCOUNTID := IN_COPYTO;
G_USER_ID := IN_USER_ID;

CHECKACCOUNTID_INSERT();  

ERRORMESSAGE :=G_ERRORMESSAGE;

END PROC_COPYEXCEPTIONS;


END INSERT_COPY_EXCEPTIONS;