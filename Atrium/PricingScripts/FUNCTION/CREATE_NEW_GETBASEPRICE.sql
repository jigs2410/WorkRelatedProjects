
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETBASEPRICE" 
(
  IN_MODEL IN VARCHAR2 
, IN_SERIES IN VARCHAR2 
, IN_STYLE IN VARCHAR2 

, IN_WIDTHES IN NUMBER
, IN_HEIGHTES IN NUMBER

--, IN_GRIDTYPE IN VARCHAR2
--, IN_GRIDSTYLE IN VARCHAR2
--, IN_GRIDPATTERN IN VARCHAR2
--, IN_ACCOUNTID IN VARCHAR2 
--, IN_CUSTOMERID IN VARCHAR2 
, IN_CONSTRUCTION IN VARCHAR2 
, IN_HASGRID NUMBER
, IN_EFFECTIVEUNIT IN NUMBER
, IN_SECTIONS IN NUMBER
, IN_PART IN NUMBER
, IN_CATEGORY IN VARCHAR2
, IN_SCREENTYPE IN VARCHAR2
, IN_SHAPE IN NUMBER
, IN_TRIPLEEYEBROW NUMBER
, IN_STDSIZE IN OUT NUMBER
, IN_SIZEID IN OUT NUMBER
, IN_SCREENDEDUCT IN OUT NUMBER
, IN_SIZETYPE IN OUT VARCHAR2
) RETURN NUMBER AS 

lv_widthes NUMBER := IN_WIDTHES;
lv_heightes NUMBER := IN_HEIGHTES;
lv_baseprice number :=0;
lv_stdsize number :=0;

--NEW_PRICINGSIZE_EXACT

lv_unitedinches number:= IN_WIDTHES + IN_HEIGHTES;

lv_clear                    new_pricingsize.clear%type;
lv_clear_pricetype          new_pricingsize.clear_Pricetype%type;
lv_withgrid                 new_pricingsize.withgrid%type;
lv_withgrid_pricetype       new_pricingsize.withgrid_pricetype%type;
lv_screen_deduct            new_pricingsize.screen_deduct%type;  
lv_screen_deduct_pricetype  new_pricingsize.screen_deduct_pricetype%type;
lv_clear_minui              new_pricingsize.clear_minui%type;
lv_withgrid_minui           new_pricingsize.withgrid_minui%type;

BEGIN
 IN_SIZETYPE :='';
 IN_SCREENDEDUCT :=0;
 IN_STDSIZE :=0;
 
 ---FOR NEW CONSTRUCTION UNited inches  = CEIL(WIDTHES) + CEIL(HEIGHTES) and for replacement  floor(...
 
  --DETERMINE WHICH FIELDS to choose what orders etc ---
  
  --IF (IN_gridtype in ('No Grid','SDL') or (IN_gridstyle not in ('Colonial','Contour' , 'Contour Valance' ))) then
  
   IF IN_effectiveunit > 1 THEN
          --we need to "resize" the unit to a fundamental component size based on oracle effective units
           select func_es_to_es_unit(IN_model,lv_widthes,1,IN_effectiveunit) into lv_widthes from dual;
           lv_unitedinches := LV_WIDTHES + IN_HEIGHTES;
   END IF;
   
   
    if (IN_SHAPE !=1) then       
                
          if (IN_CONSTRUCTION = 'N') THEN
            begin --1
                  select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1 
                  into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                  from new_pricingsize where width = LV_WIDTHES and height=in_heightes 
                  and  regexp_like ( MODEL,''''||IN_MODEL||'''','i') and series ='0' and style ='0';
                  
                   IN_SIZETYPE :='NEW_STDSIZE';
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                  begin --2
                      select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1 
                      into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                      from new_pricingsize where width = LV_WIDTHES and height=in_heightes 
                      and  regexp_like ( SERIES,''''||IN_SERIES||'''','i') and model ='0' and style ='0';
                      
                       IN_SIZETYPE :='NEW_STDSIZE';
                      EXCEPTION WHEN NO_DATA_FOUND THEN
                      begin --3
                        select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,1 
                        into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                        from new_pricingsize where width = LV_WIDTHES and height=in_heightes 
                        and  regexp_like ( STYLE,''''||IN_STYLE||'''','i')and model ='0' and series ='0';
                      
                         IN_SIZETYPE :='NEW_STDSIZE';
                        EXCEPTION WHEN NO_DATA_FOUND THEN
                      begin --4  -- try united inchees now.
                          select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype ,clear_minui,withgrid_minui
                          into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                          from new_pricingsize where ui= 1
                          and  regexp_like ( MODEL,''''||IN_MODEL||'''','i') and series ='0' and style ='0';
                       
                          EXCEPTION WHEN NO_DATA_FOUND THEN
                          begin--5
                              select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,clear_minui,withgrid_minui
                              into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                              from new_pricingsize where  ui= 1 
                              and  regexp_like ( SERIES,''''||IN_SERIES||'''','i') and model ='0' and style ='0';
                       
                              EXCEPTION WHEN NO_DATA_FOUND THEN
                              begin --6
                                select sizeid,clear,clear_pricetype,withgrid,withgrid_pricetype,screen_deduct,screen_deduct_pricetype,clear_minui,withgrid_minui
                                into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_withgrid, lv_withgrid_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_clear_minui,lv_withgrid_minui
                                from new_pricingsize where  ui= 1
                                and  regexp_like ( STYLE,''''||IN_STYLE||'''','i')and model ='0' and series ='0';
                       
                                EXCEPTION WHEN NO_DATA_FOUND THEN
                                begin --7
                                  lv_clear:=0;
                                  lv_clear_pricetype:=0;
                                  lv_withgrid:=0;
                                  lv_withgrid_pricetype:=0;
                                  lv_stdsize := 0;
                                  lv_screen_deduct :=0;
                                  lv_screen_deduct_pricetype :=0;
                                  IN_SIZETYPE :='';
                                end;--7
                              end;--6  
                          end;--5
                        end;--4
                      end;--3  
                    end;--2
              end;
                  -- TRY to figure out pricetype and change it...A function would be better to do it.
        --          if (lv_clear_pricetype = 'UNITEDINCHES') then
        --              
        --              
        --              lv_clear := (LV_WIDTHES +IN_heightes) * lv_clear;
        --              IN_SIZETYPE :='NEW_CUSTOM';
        --          end if;
        --          
        --          
        --          
        --          if (lv_withgrid_pricetype = 'UNITEDINCHES') then
        --              lv_withgrid := (LV_WIDTHES +IN_heightes) * lv_withgrid;
        --              IN_SIZETYPE :='NEW_CUSTOM';
        --          end if;
        --          
        
        --- we check if we have price and then check if its united inches if not apply price type 
        --if its united inches but less than mininum ui then apply min price or else apply price type.
        
               IF IN_effectiveunit > 1 THEN
                 lv_clear := IN_Effectiveunit * lv_clear;
                 lv_withgrid := IN_Effectiveunit * lv_withgrid;
                 lv_screen_deduct := IN_Effectiveunit * lv_screen_deduct;
               end if ;
               
                  if (lv_clear > 0) then 
                    if (lv_clear_pricetype = 'UNITEDINCHES' and lv_clear_minui > 0) then
                        if (LV_WIDTHES+IN_HEIGHTES < lv_clear_minui) then
                               lv_clear := round (lv_clear_minui / lv_clear,2);
                        else
                              lv_clear := new_applypricetype (lv_clear,lv_clear_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                         end if;   
                    else
                        lv_clear := new_applypricetype (lv_clear,lv_clear_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                    end if;
                 end if ;
                  
                  
                  if (lv_withgrid > 0) then
                      if (lv_withgrid_pricetype = 'UNITEDINCHES' and lv_withgrid_minui > 0) then
                          if (LV_WIDTHES+IN_HEIGHTES < lv_withgrid_minui) then
                              lv_withgrid := round (lv_withgrid_minui/lv_withgrid,2);
                           else     
                              lv_withgrid := new_applypricetype (lv_withgrid,lv_withgrid_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));   
                           end if; 
                      else     
                        lv_withgrid := new_applypricetype (lv_withgrid,lv_withgrid_pricetype,CEIL(LV_WIDTHES),CEIL(IN_HEIGHTES));
                     end if;
                 end if; 
                 
                  if (lv_withgrid_pricetype = 'UNITEDINCHES' or lv_clear_pricetype = 'UNITEDINCHES') then
                    IN_SIZETYPE :='NEW_CUSTOM';
                  end if;
                  
                  IN_STDSIZE := lv_stdsize;
              
            
                  --NOw check if part or no screen and handle accordingly.
                  if (IN_PART = 1) then
                    IN_SCREENDEDUCT :=1;
                    RETURN lv_screen_deduct;
                  else
                  
                    if (IN_SCREENTYPE = 'No Screen' ) then
                      IN_SCREENDEDUCT :=1;
                      lv_clear := lv_clear - lv_screen_deduct;
                      lv_withgrid := lv_withgrid - lv_screen_deduct;
                    end if;
                    
                    if (IN_HASGRID = 0) then
                      RETURN lv_clear;
                    else 
                      RETURN lv_withgrid;
                    end if ;     
                  
                  end if; -- IN_PART =1 
                  
                  
        else  --replacemenet
               
                    if (IN_SECTIONS >=3) then --only baybow
                      begin--1
                        select sizeid,bb_price into IN_SIZEID,lv_baseprice  from new_pricingsize 
                          where regexp_like ( style,''''||IN_style||'''','i') and model ='0' and series ='0'
                          and sections = IN_SECTIONS
                          and width_lower <= floor(IN_WIDTHES) and width_upper >= floor(IN_WIDTHES)
                          and height_lower <= floor(IN_HEIGHTES) and height_upper >= floor(IN_HEIGHTES);
                          
                          IN_SIZETYPE :='REPL_BRACKET';
                          EXCEPTION WHEN NO_DATA_FOUND THEN           
                            begin --2
                              lv_baseprice:=0;
                              IN_SIZETYPE :='';
                            end; --2
                      
                      end;--1
                    
                    
                    else -- not baybow
                            begin --1
                               select sizeid,bracketprice into IN_SIZEID,lv_baseprice  from new_pricingsize 
                                where regexp_like ( MODEL,''''||IN_MODEL||'''','i') and style ='0' and series ='0'
                                and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                                IN_SIZETYPE :='REPL_BRACKET';
                                 EXCEPTION WHEN NO_DATA_FOUND THEN
                                  begin --2
                                  select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into IN_SIZEID,lv_baseprice from new_pricingsize 
                                  where regexp_like ( MODEL,''''||IN_MODEL||'''','i') and style ='0' and series ='0'
                                  and maxui!=0 and maxui < lv_unitedinches;
                                  IN_SIZETYPE :='REPL_OVERMAXUI';
                                  EXCEPTION WHEN NO_DATA_FOUND THEN
                                  begin --3
                              
                                    select sizeid,bracketprice into IN_SIZEID,lv_baseprice  from new_pricingsize 
                                    where regexp_like ( SERIES,''''||IN_SERIES||'''','i') and style ='0' and model ='0'
                                    and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                                    IN_SIZETYPE :='REPL_BRACKET';
                                     EXCEPTION WHEN NO_DATA_FOUND THEN
                                      begin --4
                                      select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into IN_SIZEID,lv_baseprice from new_pricingsize 
                                      where regexp_like ( SERIES,''''||IN_SERIES||'''','i') and style ='0' and model ='0'
                                      and maxui!=0 and maxui < lv_unitedinches;
                                      IN_SIZETYPE :='REPL_OVERMAXUI';
                                      EXCEPTION WHEN NO_DATA_FOUND THEN
                                      begin --5
                                        select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into IN_SIZEID,lv_baseprice  from new_pricingsize 
                                        where regexp_like ( STYLE,''''||IN_STYLE||'''','i') and series ='0' and model ='0'
                                        and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                                        IN_SIZETYPE :='REPL_BRACKET';
                                         EXCEPTION WHEN NO_DATA_FOUND THEN
                                          begin --6
                                          select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into IN_SIZEID,lv_baseprice from new_pricingsize 
                                          where regexp_like ( STYLE,''''||IN_STYLE||'''','i') and series ='0' and model ='0'
                                          and maxui!=0 and maxui < lv_unitedinches;
                                          IN_SIZETYPE :='REPL_OVERMAXUI';
                                          EXCEPTION WHEN NO_DATA_FOUND THEN           
                                          begin --7
                                            lv_baseprice:=0;
                                            IN_SIZETYPE :='';
                                          end; --7
                                        end; --6
                                      end; --5
                                    end;--4
                                   end;--3
                                  end;--2
                                 end;--1
                        end if; 
                 RETURN lv_baseprice;
              end if; --construction
  
  --end if;
  else
  
  
   begin --1
                  select sizeid,clear,clear_pricetype,screen_deduct,screen_deduct_pricetype,1 
                  into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                  from new_pricingsize where width = LV_WIDTHES and height=in_heightes  and regexp_like(tripleeyebrow, IN_tripleeyebrow)
                  and  regexp_like ( MODEL,''''||IN_MODEL||'''','i') and series ='0' and style ='0';
                  lv_stdsize := 1;
                   IN_SIZETYPE :='SHAPE_STDSIZE';
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                  begin --2
                      select sizeid,clear,clear_pricetype,screen_deduct,screen_deduct_pricetype,1 
                      into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                      from new_pricingsize where width = LV_WIDTHES and height=in_heightes  and regexp_like(tripleeyebrow, IN_tripleeyebrow)
                      and  regexp_like ( SERIES,''''||IN_SERIES||'''','i') and model ='0' and style ='0';
                      lv_stdsize := 1;
                       IN_SIZETYPE :='SHAPE_STDSIZE';
                      EXCEPTION WHEN NO_DATA_FOUND THEN
                      begin --3
                        select sizeid,clear,clear_pricetype,screen_deduct,screen_deduct_pricetype,1 
                        into IN_SIZEID,lv_clear,lv_clear_pricetype,lv_screen_deduct,lv_screen_deduct_pricetype,lv_stdsize
                        from new_pricingsize where width = LV_WIDTHES and height=in_heightes  and regexp_like(tripleeyebrow, IN_tripleeyebrow)
                        and  regexp_like ( STYLE,''''||IN_STYLE||'''','i')and model ='0' and series ='0';
                        lv_stdsize := 1;
                         IN_SIZETYPE :='SHAPE_STDSIZE';
                        EXCEPTION WHEN NO_DATA_FOUND THEN
                      begin --4  -- try united inchees now.
                      
                        select sizeid,clear,clear_pricetype
                          into IN_SIZEID,lv_clear,lv_clear_pricetype
                          from new_pricingsize where ui= 1
                          and  regexp_like ( MODEL,''''||IN_MODEL||'''','i') and series ='0' and style ='0' and regexp_like(tripleeyebrow, IN_tripleeyebrow)
                          and ((lowerui < lv_unitedinches and upperui >= lv_unitedinches) or (lowerui=0 and upperui = 0)) ;
--                          
--                          select sizeid,bracketprice into IN_SIZEID,lv_baseprice  from new_pricingsize 
--                          where regexp_like ( MODEL,''''||IN_MODEL||'''','i') and style ='0' and series ='0'
--                          and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                          IN_SIZETYPE :='SHAPE_BRACKET';
                       
                          EXCEPTION WHEN NO_DATA_FOUND THEN
                          begin--5
                          
                            select sizeid,clear,clear_pricetype
                              into IN_SIZEID,lv_clear,lv_clear_pricetype
                              from new_pricingsize where  ui= 1 
                              and  regexp_like ( SERIES,''''||IN_SERIES||'''','i') and model ='0' and style ='0' and regexp_like(tripleeyebrow, IN_tripleeyebrow)
                              and ((lowerui < lv_unitedinches and upperui >= lv_unitedinches) or (lowerui=0 and upperui = 0)) ;
                              
                              
--                              select sizeid,bracketprice into IN_SIZEID,lv_baseprice  from new_pricingsize 
--                              where regexp_like ( SERIES,''''||IN_SERIES||'''','i') and style ='0' and model ='0'
--                              and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
--                              
                              
                              IN_SIZETYPE :='SHAPE_BRACKET';
                       
                              EXCEPTION WHEN NO_DATA_FOUND THEN
                              begin --6
                              
                               select sizeid,clear,clear_pricetype
                                into IN_SIZEID,lv_clear,lv_clear_pricetype
                                from new_pricingsize where  ui= 1
                                and  regexp_like ( STYLE,''''||IN_STYLE||'''','i')and model ='0' and series ='0' and regexp_like(tripleeyebrow, IN_tripleeyebrow)
                                and ((lowerui < lv_unitedinches and upperui >= lv_unitedinches) or (lowerui=0 and upperui = 0)) ;
                                
--                                select sizeid,maxuiprice + (lv_unitedinches - maxui)*maxperui into IN_SIZEID,lv_baseprice  from new_pricingsize 
--                                where regexp_like ( STYLE,''''||IN_STYLE||'''','i') and series ='0' and model ='0' 
--                                and lowerui < lv_unitedinches and upperui >= lv_unitedinches;
                                
                                IN_SIZETYPE :='SHAPE_BRACKET';
                       
                                EXCEPTION WHEN NO_DATA_FOUND THEN
                                begin --7
                                  lv_clear:=0;
                                  lv_clear_pricetype:=0;
                                 -- lv_baseprice:=0;
                                  IN_SIZETYPE :='';
                                end;--7
                              end;--6  
                          end;--5
                        end;--4
                      end;--3  
                    end;--2
              end;
          
            IN_STDSIZE := lv_stdsize;
            
             if (lv_clear > 0)  then
                
                if (IN_PART = 1) then -- check if its a screen only or has no screen
                      IN_SCREENDEDUCT :=1;
                      RETURN lv_screen_deduct;
                else
                      if (IN_SCREENTYPE = 'No Screen' ) then
                        IN_SCREENDEDUCT :=1;
                        lv_clear := lv_clear - lv_screen_deduct;
                       end if;
                end if;
              
              if (IN_CONSTRUCTION = 'R') then 
                lv_clear := new_applypricetype (lv_clear,lv_clear_pricetype,FLOOR(IN_WIDTHES),FLOOR(IN_HEIGHTES));
              else
                lv_clear := new_applypricetype (lv_clear,lv_clear_pricetype,CEIL(IN_WIDTHES),CEIL(IN_HEIGHTES));
              end if;
            end if;
            
            
            
            
            return lv_clear;
  
  end if ; -- if shapes
  
 
END NEW_GETBASEPRICE;