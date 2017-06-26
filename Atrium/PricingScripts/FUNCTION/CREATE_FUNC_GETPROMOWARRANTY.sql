
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_GETPROMOWARRANTY" 
(
  in_BRAND IN VARCHAR2 
, in_ACCOUNTID IN VARCHAR2 
, in_CUSTOMERID IN VARCHAR2 
, in_SERIES IN VARCHAR2 
, in_STYLE IN VARCHAR2 
, in_MODEL IN VARCHAR2 
, in_PRICE IN NUMBER 
, in_DEBUG IN VARCHAR2 DEFAULT 'DEBUG'
) RETURN NUMBER AS 
l_price number :=in_PRICE;
l_promoprice number :=in_PRICE;
l_rangeid number;
l_rangedesc VARCHAR2(50);
l_deduction number;
BEGIN
  BEGIN -- first check for accountid with model 1
  
  --select pt.type,pt.value , 15 - decode(pt.type,'FREE',15 , 'DISCOUNT',pt.value, 'PERCENT', 15 * pt.value/100),pt.CREATE_DATE,pr.ID,pt.id from new_promomap pm,new_promorange pr , new_promotype pt
  --where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' order by 3 ,create_date desc;
  
  --For warranty we return the first cheapest available value and the latest date created.
  
  --Rule 1) For particular brand and all series
         select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100),pr.id,pr.NAME,  decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100) 
         into l_promoprice , l_rangeid , l_rangedesc,l_deduction
         from new_promomap pm,new_promorange pr , new_promotype pt
         where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
         and upper(pm.BRAND) = upper(in_BRAND) and (Series = 'ALL' or upper(Series) = upper(in_SERIES))
         and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
         and rownum =1 
         order by pr.datecreated desc;
         
      EXCEPTION WHEN NO_DATA_FOUND THEN
      --Rule 2) For specific series but all brand 
        BEGIN
           select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100)  into l_promoprice
           from new_promomap pm,new_promorange pr , new_promotype pt
           where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
           and (upper(pm.BRAND) = 'ALL' or upper(pm.BRAND) = upper(in_BRAND))  and upper(Series) = upper(in_SERIES)
           and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
           and rownum =1 
           order by pr.datecreated desc;
         EXCEPTION WHEN NO_DATA_FOUND THEN
         BEGIN --now start the user defined rules Rule 3
           select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100)  into l_promoprice
           from new_promomap pm,new_promorange pr , new_promotype pt
           where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
           and  ( UPPER(accountid)= upper(in_ACCOUNTID) and upper(model)= upper(in_MODEL) )
           and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
           and rownum =1 
           order by pr.datecreated desc;
            EXCEPTION WHEN NO_DATA_FOUND THEN
            BEGIN --Rule 4
             select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100)  into l_promoprice
             from new_promomap pm,new_promorange pr , new_promotype pt
             where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
             and (  UPPER(accountid)= upper(in_ACCOUNTID) and upper(series) = upper(in_SERIES) and upper(style)= upper(in_STYLE) )
             and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
             and rownum =1 
             order by pr.datecreated desc;
             EXCEPTION WHEN NO_DATA_FOUND THEN
              BEGIN --Rule 5
               select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100)  into l_promoprice
               from new_promomap pm,new_promorange pr , new_promotype pt
               where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
               and (  UPPER(accountid)= upper(in_ACCOUNTID) and upper(series) = upper(in_SERIES))
               and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
               and rownum =1 
               order by pr.datecreated desc;
               EXCEPTION WHEN NO_DATA_FOUND THEN
               BEGIN --Rule 6
                 select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100)  into l_promoprice
                 from new_promomap pm,new_promorange pr , new_promotype pt
                 where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
                 and  ( UPPER(customerid)= upper(in_CUSTOMERID) and upper(model)= upper(in_MODEL) )
                 and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
                 and rownum =1 
                 order by pr.datecreated desc;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                  BEGIN --Rule 7
                   select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100)  into l_promoprice
                   from new_promomap pm,new_promorange pr , new_promotype pt
                   where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
                   and (  UPPER(customerid)= upper(in_CUSTOMERID) and upper(series) = upper(in_SERIES) and upper(style)= upper(in_STYLE) )
                   and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
                   and rownum =1 
                   order by pr.datecreated desc;
                   EXCEPTION WHEN NO_DATA_FOUND THEN
                    BEGIN --Rule 8
                     select l_price - decode(pt.type,'FREE',l_price , 'DISCOUNT',pt.value, 'PERCENT', l_price * pt.value/100)  into l_promoprice
                     from new_promomap pm,new_promorange pr , new_promotype pt
                     where pm.rangeid= pr.id and pr.type_id = pt.id and pr.active =1 and pr.CATEGORY='WARRANTY' 
                     and (  UPPER(customerid)= upper(in_CUSTOMERID) and upper(series) = upper(in_SERIES))
                     and pr.DATESTART <= sysdate and pr.Dateend >=sysdate 
                     and rownum =1 
                     order by pr.datecreated desc;
                     EXCEPTION WHEN NO_DATA_FOUND THEN
                      BEGIN --No Data Found at all return same price
                        l_promoprice:=in_PRICE;
                      END;
                       
                     END; --Rule 8  
                  END;--Rule 7
                END; --Rule 6
              END; --Rule 5
            END;--Rule 4
         END; --Rule 3
        END; --Rule 2
    END; --Rule 1
   -- BEGIN
   insert into ww_change_log (change_id,old_val,new_val,notes) values (4,l_price, l_promoprice , l_rangedesc);
  -- END;
  RETURN l_promoprice;
  EXCEPTION WHEN OTHERS THEN
  BEGIN
   RETURN -1; 
  END;
END FUNC_GETPROMOWARRANTY;