
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."NEW_GETPRICE" 
(
  IN_UNITID IN NUMBER 
, IN_ITEMID IN NUMBER 
, IN_ORDERID IN NUMBER 
 --, IN_PARAM1 IN OUT NUMBER
) RETURN NUMBER AS 


--L2_Unit
-- model ,series, style---
lv_model  l2_unit.model%TYPE;
lv_series l2_unit.series%TYPE;
lv_style  l2_unit.style%TYPE; 

--accountid,customerid--
lv_accountid Ordermaster.accountid%Type;
lv_customerid Ordermaster.customerid%Type;

--- size params ---
lv_widthes l2_unit.widthes%TYPE;
lv_heightes l2_unit.heightes%TYPE;

lv_cottageoriel       l2_unit.cottageoriel%TYpe;
lv_clmr               l2_unit.clmr%Type;
lv_panetype           l2_unit.pane_type%TYPE;
lv_hardwareaccessory  l2_unit.hardwareaccessory%TYPE;
lv_egress             l2_unit.egress%type;
lv_linetypeid         l2_unit.LINETYPEID%TYPE;
lv_smr                l2_unit.smr%TYPE;
lv_tripleeyebrow      number := 0;
lv_nfrc               l2_unit.northern_energy_star%type;

--L1_Item
lv_construction L1_ITEM.CONSTRUCTION%TYPE;
lv_rendercode   L1_ITEM.RENDERCODE%TYPE;
lv_woodsurround L1_ITEM.WOODSURROUND%TYPE;
lv_linenumber   L1_ITEM.LINENUMBER%TYPE;
lv_seat         L1_ITEM.SEAT%TYPE;
lv_foamwrap     L1_ITEM.FOAMWRAP%TYPE;
lv_gridplacement L1_ITEM.GRIDPLACEMENT%TYPE;
   


--STYLE
lv_category STYLE.CATEGORY%TYPE;
lv_part     STYLE.PART%TYPE;
lv_effectiveunit  STYLE.ORCL_EFFECT_UNIT%TYPE;


--CONFIGURATIONS
lv_lowercount CONFIGURATIONS.LOWERCOUNT%TYPE;
lv_uppercount CONFIGURATIONS.UPPERCOUNT%TYPE;

--L5_glass
lv_tintin l5_glass.tintin%type;
lv_energy l5_glass.energy%type;
lv_safety l5_glass.safetyin%type;
lv_gridtype l5_glass.gridtypein%type;
lv_gridstyle L5_GLASS.GRIDSTYLE%type;
lv_gridpattern L5_GLASS.GRIDPATTERN%type;
lv_spacertype  L5_GLASS.SPACERTYPE%type;
lv_gridcolorin  L5_GLASS.GRIDCOLORIN%type;
lv_gridcolorout L5_GLASS.GRIDCOLOROUT%TYPE;
lv_breathertube L5_GLASS.BREATHERTUBE%TYPE;

lv_lites number :=0;

--NEW_PRICINGSIZE_EXACT


---PRICING PARAMETERS
lv_baseprice number:=0;
lv_gridprice number:=0;

lv_glassprice number:=0;
lv_tintprice number;
lv_energyprice number;
lv_safetyprice number;
lv_breathertubeprice number :=0;

lv_colorprice number :=0;
lv_wood_mullprice number :=0;

lv_screenprice number :=0;
lv_screenmeshprice number :=0;
lv_seatprice number:=0;
lv_cottageorielprice number := 0;
lv_foamwrapprice number :=0;
lv_superspacerprice number:=0;
lv_lockprice number:=0;

lv_hardwareprice number:=0;
lv_hardwarecolor_typeprice number:=0;
lv_hardwareaccessoryprice number:=0;
lv_hardwareegressprice number :=0;
lv_sashaccessoryprice number :=0;
lv_drywallprice number :=0;
lv_smrprice number :=0;

lv_atriumprice number :=0;
lv_finalprice number :=0;

lv_totalperc number :=0; ---this for total deduct only applicatble for FGO/TOP SASH ONLY etc

--L3_FRAME--
lv_frameid L3_FRAME.frameid%TYPE;
lv_framecolorin L3_FRAME.FRAMECOLORIN%TYPE;

--L3_MULL
lv_mulltype L3_MULL.MULLTYPE%TYPE;


--L3_SCREEN
lv_screentype L3_SCREEN.SCREENTYPE%TYPE;
lv_screenmeshtype L3_SCREEN.SCREENMESHTYPE%TYPE;


--L3_Hardware

lv_hardwaretype  l3_hardware.hardwaretype%type;
lv_hardwarecolor l3_hardware.hardwarecolor%type;
lv_sashaccessory l3_hardware.sashaccessorytype%type;

-- L4_SASH---
lv_sashid l4_Sash.sashid%type;

-- OTHER VARIABLES
lv_stdsize NUMBER :=0;
lv_hasgrid NUMBER :=0;
lv_mulledunits number :=0;
lv_totalunits number :=0; -- mulled units may have more than 2 effective unit items eg CTTW & TR will be 2 mulled units but total of 3 effective unit.
lv_sections number  :=0;
lv_isshape number :=0;
lv_screendeduct number :=0;

--Log variables
--lv_sizeid number :=0;
lv_sizetype varchar(250) :='';
--lv_gridid number :=0;
lv_tintid number :=0;
lv_energyid number :=0;
lv_safetyid number :=0;
--lv_colorid number :=0;
--lv_wood_mullid number :=0;
lv_screenid number :=0;

lv_hardwareid number:=0;
lv_hardwareaccessoryid number:=0;
lv_hardwareegressid number :=0;
lv_sashaccessoryid number :=0;

lv_gridpatternid number:=0;
lv_gridpatternprice number:=0;

lv_count number :=0;

lv_ruleid number :=0;


---Exceptions
lv_exdiscounttype  EXCEPTIONASSIGNMENT.DISCOUNTTYPE%TYPE;
lv_exvalue         EXCEPTIONDESC.VALUE%TYPE;
lv_exvariable      EXCEPTIONDESC.VARIABLE%TYPE;
lv_exassignid      EXCEPTIONASSIGNMENT.ID%TYPE;
lv_exdescid        EXCEPTIONDESC.ID%TYPE;
lv_exdiscountvalue EXCEPTIONASSIGNMENT.DiscountValue%TYPE;
lv_appliedonname   new_pricenexceptlog.appliedonname%TYPE;

lv_exprice number :=0;
lv_exOrigPrice number :=0;
lv_lognexcept number :=0;




cursor c_exception is 
select EA.ID,EA.DISCOUNTTYPE,ED.ID,ED.VALUE,ED.VARIABLE,EA.DiscountVALUE from EXCEPTIONASSIGNMENT EA 
left join EXCEPTIONDESC ED on EA.EXCEPTIONDESC = ED.ID
where  regexp_like (accountid,''''||lv_accountid||'''','i') and  (regexp_like (series,''''||lv_SERIES||'''','i') or series = 'ALL') order by ED.VARIABLE;


BEGIN

  --ORdermaster
    select accountid,customerid into lv_accountid,lv_customerid 
    from ordermaster where orderid = IN_Orderid;
  --L1_item
    select construction,rendercode,nvl(woodsurround,0),linenumber,nvl(seat,'0') , nvl(foamwrap,'0'),nvl(gridplacement,'0')
    into lv_construction,lv_rendercode,lv_woodsurround,lv_linenumber,lv_seat ,lv_foamwrap,lv_gridplacement
    from l1_item where itemid = IN_itemid;
    
  --L2_unit
    select widthes,heightes,model,series,style,nvl(cottageoriel,0) , nvl(clmr,0), nvl(pane_type,0)  , nvl(hardwareaccessory,0),nvl(egress,0),linetypeid ,nvl(smr,0), 
    case when tripleeyebrow in ('Triple Eyebrow') then 1 else 0 end ,nvl(northern_energy_star,0)
    
    into lv_widthes,lv_heightes,lv_model,lv_series,lv_style,lv_cottageoriel,lv_clmr,lv_panetype, lv_hardwareaccessory, lv_egress ,lv_linetypeid,lv_smr
    ,lv_tripleeyebrow,lv_nfrc
    from l2_unit where unitid = IN_UNITID;
  --STYLE
    select category,part,orcl_effect_unit into lv_category,lv_part,lv_effectiveunit 
    from style where stylecode = lv_style;
   --Configurations
    select lowercount+uppercount into lv_mulledunits from CONFIGURATIONS where rendercode = lv_rendercode;
  
    if(lv_mulledunits >1) then
     -- select sum (orcl_effect_unit) into lv_totalunits from style where stylecode in (select style from l2_unit where itemid =IN_itemid);
     select sum (orcl_effect_unit)  into lv_totalunits from style s left join l2_unit u on s.stylecode = u.style  where u.itemid =19278660 ;
    end if;
    
  --MULL
    select nvl(mulltype , 0) into lv_mulltype from L3_MULL where unitid = IN_UNITID;
  
  --SCREEN
    select nvl(screentype,0) , nvl(screenmeshtype,0) into lv_screentype,lv_screenmeshtype from l3_screen where unitid = IN_UNITID;
    
  --HARDWARE
    select nvl(hardwaretype,0) , nvl(hardwarecolor,0),nvl(sashaccessorytype,0) into lv_hardwaretype,lv_hardwarecolor,lv_sashaccessory from l3_hardware where unitid = IN_UNITID;
  
  -- determine sections.
  
    select  case 
              when lv_style in ('C2','A2H','A2V') then 2 
              when lv_style in ('30B','45B','3LB','C3','A3H','A3V') then 3 
              when lv_style in ('4LB','C4') then 4 
              when lv_style in ('5LB','C5') then 5 else 1 end  into lv_sections from dual;
  
  --GET sash and frameid.
    
    select frameid,framecolorin into lv_frameid,lv_framecolorin from l3_frame where unitid = IN_UNITID;
    select sashid into lv_sashid from l4_sash where frameid = lv_frameid and rownum < 2 order by sashid;
    
    --Determin if shapes
    select case when exists(SELECT STYLE
                         from option_grid where regexp_like (style,''''||lv_style||'''','i') and shapes =1)
           then 1
           else 0
         end  into lv_isshape from dual;
    
    --L5_GLASS
    select tintin,energy,safetyin,nvl(gridtypein,0),nvl(gridstyle,0),nvl(gridpattern ,0),nvl(spacertype,0),nvl(gridcolorin,'0') , nvl(gridcolorout,'0'), nvl(breathertube,'0')
    into lv_tintin,lv_energy,lv_safety,lv_gridtype,lv_gridstyle,lv_gridpattern , lv_spacertype,lv_gridcolorin,lv_gridcolorout,lv_breathertube  from l5_glass where sashid =lv_sashid;
  
    --determine actual gridpatterns and lite only when gridtype is  SDL.
    -- we get grid pattern irrespective of gridtype but only if its non shape 
    if (lv_isshape = 0) then
      select nvl(listagg(gridpattern,'-')  within group (order by sashid desc),0) into lv_gridpattern from l5_glass where sashid in (select sashid from l4_sash where frameid = lv_frameid);
   
    --determine lites  
      if (lv_gridpattern!='0' and lv_gridtype  in ('SDL','7/8')) then
        select NVL(func_getlites(lv_gridpattern),0) into lv_lites from dual;
      end if ;
    
   end if;   
      
    
  --Get exceptnlog 
  select pricelognexception.nextval into lv_lognexcept from dual;
 

  
  

  --Get glass price.
    lv_glassprice := new_getglassprice (lv_tintin,lv_energy,lv_safety,lv_series,lv_style,lv_widthes,lv_heightes,lv_effectiveunit,lv_isshape,lv_nfrc,lv_tintprice,lv_energyprice,lv_safetyprice,lv_tintid ,lv_energyid,lv_safetyid);
    if (lv_glassprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'GLASS',0,lv_glassprice); end if;
    if (lv_tintprice!=0) then  proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'TINT',lv_tintid,lv_tintprice); end if;
    if (lv_energyprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'ENERGY',lv_energyid,lv_energyprice); end if;
    if (lv_safetyprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'SAFETY',lv_safetyid,lv_safetyprice); end if;
    
    DBMS_OUTPUT.put_line('Glass  '|| lv_glassprice);
    DBMS_OUTPUT.put_line('Tintprice '||lv_tintprice);
    DBMS_OUTPUT.put_line('energyprice '||lv_energyprice);
    DBMS_OUTPUT.put_line('safetyprice '||lv_safetyprice);

  --Get gridp price and also determination if grid exists.
  
  if (lv_isshape = 0) then -- for shapes we compute grid pricing after base pricing.
    if (LV_GRIDTYPE!= 'No Grid') then
      lv_gridprice :=  new_getgridprice(LV_CONSTRUCTION,LV_EFFECTIVEUNIT,LV_SECTIONS,LV_LITES,LV_GRIDTYPE,LV_GRIDSTYLE,lv_gridcolorin, lv_gridcolorout,lv_gridplacement,lv_gridpattern,lv_style, lv_isshape,lv_widthes,lv_heightes,lv_safety,0,LV_HASGRID,LV_ruleID,lv_gridpatternid,lv_gridpatternprice);
      if (lv_gridprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'GRID',lv_ruleid,lv_gridprice); end if;
      
      --if TSO or 0Hx0V then gridpattern price will be lv_gridprice. ( which is 50% of grid price)
      if (lv_gridpatternprice!=0) then 
        proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'GRID TSO ONLY',lv_gridpatternid,lv_gridpatternprice);
        lv_gridprice := lv_gridpatternprice;
      end if;
      
    end if;
    
      DBMS_OUTPUT.put_line('GRID  '|| lv_gridprice ||'  - ' ||lv_hasgrid);  
 end if;   
    
    
  --Base calculation
  -- DEtermination of  which sizing table to choose.
  --select new_getbaseprice (lv_model,lv_series,lv_style,lv_widthes,lv_heightes,IN_PARAM1) into lv_baseprice from dual;
  
  ---calculate base price but write to log later as we are calculating grid later.
  lv_baseprice := new_getbaseprice (lv_model,lv_series,lv_style,lv_widthes,lv_heightes,lv_construction,lv_hasgrid,lv_effectiveunit,lv_sections,lv_part,lv_category,lv_screentype,lv_isshape,lv_tripleeyebrow,lv_stdsize,lv_ruleid,lv_screendeduct,lv_sizetype);
  --proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'INFO',0,0,lv_stdsize,lv_isshape,lv_hasgrid,lv_screendeduct,lv_part,lv_sizetype,lv_widthes,lv_heightes,lv_mulledunits,lv_effectiveunit,lv_sections);
  DBMS_OUTPUT.put_line('BASE  '|| lv_baseprice ||  ' - '|| lv_stdsize);
  
  
    if (lv_isshape = 1) then -- for shapes we compute grid pricing after base pricing.
    if (LV_GRIDTYPE!= 'No Grid') then
      lv_gridprice :=  new_getgridprice(LV_CONSTRUCTION,LV_EFFECTIVEUNIT,LV_SECTIONS,LV_LITES,LV_GRIDTYPE,LV_GRIDSTYLE,lv_gridcolorin, lv_gridcolorout,lv_gridplacement,lv_gridpattern,lv_style, lv_isshape,lv_widthes,lv_heightes,lv_safety,lv_baseprice,LV_HASGRID,LV_ruleID,lv_gridpatternid,lv_gridpatternprice);
      if (lv_gridprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'GRID',lv_ruleid,lv_gridprice); end if;
      --- there is no tso or ohx0v for shapes.
    end if;
    
      DBMS_OUTPUT.put_line('GRID  '|| lv_gridprice ||'  - ' ||lv_hasgrid);  
   end if;   
 
  --Write to log after checking after grid calculation for shape.
  if (lv_baseprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'BASE',lv_ruleid,lv_baseprice,lv_stdsize,lv_isshape,lv_hasgrid,lv_screendeduct,lv_part,lv_sizetype,lv_widthes,lv_heightes,0,0); end if;
  
  
  --Get color  price
  lv_colorprice := NEW_GETCOLOR(lv_framecolorin,lv_mulledunits,lv_baseprice,lv_effectiveunit,lv_sections,lv_style,lv_ruleid);
  if (lv_colorprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'COLOR',lv_ruleid,lv_colorprice); end if;
  
  DBMS_OUTPUT.put_line('Color '|| lv_colorprice );
  
  

  --Get Mull / Wood Price
  --Only do this if mulltype and wood surr is not null or has some values
  if (lv_mulltype !='0' or lv_woodsurround !='0') then
      if (lv_mulltype !='0') then
        lv_wood_mullprice := NEW_GETWOODMULLPRICE(lv_mulltype,lv_style,lv_isshape,lv_totalunits,lv_mulledunits,lv_effectiveunit,lv_stdsize,lv_ruleid);
      else 
        lv_wood_mullprice := NEW_GETWOODMULLPRICE(lv_woodsurround,lv_style,lv_isshape,lv_totalunits,lv_mulledunits,lv_effectiveunit,lv_stdsize,lv_ruleid);
      end if ;
        
      if (lv_wood_mullprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'WOOD/MULL',lv_ruleid,lv_wood_mullprice,0,lv_isshape,0,0,lv_part,'',0,0,lv_mulledunits,lv_effectiveunit); end if;
  end if ;
  
  
  --- get seat price
  
  if (lv_seat != '0') then
    lv_seatprice := NEW_GETSEATPRICE (lv_seat,lv_effectiveunit,lv_sections,lv_construction,lv_framecolorin,lv_series,lv_style,lv_ruleid);
      if (lv_seatprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'SEAT',lv_ruleid,lv_seatprice); end if;
  end if;
  
  ---get screenmesh price
   if (lv_screenmeshtype!='0') then
    lv_screenmeshprice := NEW_GETSCREENMESHPRICE (lv_screenmeshtype,lv_effectiveunit,lv_sections,lv_construction,lv_series,lv_style,lv_screentype,lv_part,lv_ruleid);
    if (lv_screenmeshprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'SCREENMESH',lv_ruleid,lv_screenmeshprice); end if;
    
    end if;
    
    
    ---get cottageoriel
    
   if (lv_cottageoriel in ('ORIEL','Oriel','Cottage','COTTAGE')) then
   
    if (lv_clmr != '0' and lv_clmr != '000' ) then
        lv_clmr := '1';
      end if ;
    lv_cottageorielprice := NEW_GETCOTTAGEORIELPRICE (lv_cottageoriel,lv_construction,lv_clmr,lv_effectiveunit,lv_sections,lv_ruleid);
   
   DBMS_OUTPUT.put_line('Cottageorielprice  '|| lv_cottageorielprice || '  rule id is ' || lv_ruleid);
   
    if (lv_cottageorielprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'COTTAGE/ORIEL',lv_ruleid, lv_cottageorielprice); end if;
    
    end if;
  
  ----get foamwrap
    
     if (lv_foamwrap != '0') then
      lv_foamwrapprice := NEW_GETFOAMPRICE (lv_foamwrap,lv_effectiveunit,lv_sections,lv_series,lv_style,lv_ruleid);
      if (lv_foamwrapprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'FOAMWRAP',lv_ruleid,lv_foamwrapprice); end if;
  end if;
    
    
    
    ----get hardwarerelated prices
      if (lv_hardwaretype!='0' or lv_hardwarecolor !='0' or lv_hardwareaccessory!='0' or lv_egress!='0') then
        lv_hardwareprice := NEW_GETHARDWAREPRICE (lv_hardwaretype,lv_hardwarecolor,lv_hardwareaccessory,lv_egress,lv_series,lv_style,lv_effectiveunit,lv_sections,lv_category,lv_hardwarecolor_typeprice,lv_hardwareegressprice,lv_hardwareaccessoryprice,lv_hardwareid,lv_hardwareaccessoryid,lv_hardwareegressid);
        
        if (lv_hardwarecolor_typeprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'HARDWARE COLOR/TYPE',lv_hardwareid,lv_hardwarecolor_typeprice); end if;
        if (lv_hardwareegressprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'HARDWARE EGRESS',lv_hardwareegressid,lv_hardwareegressprice); end if;
        if (lv_hardwareaccessoryprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'HARDWARE ACCESSORY',lv_hardwareaccessoryid,lv_hardwareaccessoryprice); end if;
        if (lv_hardwareprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'HARDWARE',0,lv_hardwareprice); end if;
        

      end if;
    
    
    
    ---get drywall price only if style matches
    
    if (lv_style in   ('DW','DWHP','DWTW','DWTR','HPDW','DWHPTR','2DW','3DW')) then
      lv_drywallprice := new_getdrywallprice (lv_style,lv_framecolorin , lv_effectiveunit,lv_sections,lv_ruleid);
        if (lv_drywallprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'DRYWALL',lv_ruleid,lv_drywallprice); end if;
    end if;
    
    --get sash accessory price only if its not null and not 'No accessory'
    
    if (lv_sashaccessory not in ('0','No Accessory')) then 
    
      lv_sashaccessoryprice := new_getsashaccessoryprice (lv_sashaccessory,lv_construction,lv_style,lv_series,lv_part,lv_effectiveunit,lv_sections,lv_ruleid);
      if (lv_sashaccessoryprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'SASH ACCESSORY',lv_ruleid,lv_sashaccessoryprice); end if;
    
    end if;
    
    ---get superspacer price --- no table needed 
    
    if ((lv_spacertype in ('Super Spacer','SUPER SPACER')) and lv_panetype!='0' and lv_panetype not in ('TRIPLE PANE','Triple Pane')) then
      if (lv_Sections >=3) then 
        lv_superspacerprice := 16 * lv_sections;
      else
        lv_superspacerprice := 16;
      end if;
       if (lv_superspacerprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'SUPER SPACER',0,lv_superspacerprice); end if;
    end if ;
    
    --get locks --no table needed
    
    if (lv_hardwaretype in ( '2 LOCKS','2 Locks')) then 
        
        if ( lv_style in ('DH','SH') and lv_widthes < 27.25 ) or ( lv_style in ('2SL','3SL') and lv_heightes < 27.25 ) then
        lv_lockprice := 7;
        end if;
       if (lv_lockprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'LOCKS',0,lv_lockprice); end if;
      
    end if;
    
      ---get breather tube charge -- no table needed
    
    if (lv_breathertube = 1) then
       if (lv_series in ('4000','4002','R4000')) then
        lv_breathertubeprice := 5;
       else
        lv_breathertubeprice := 2.5;
       end if; 
       
       if (lv_breathertubeprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'BREATHER TUBE',0,lv_breathertubeprice); end if;
       
    end if;
    
    ---get smr price --no table needed.
    if (lv_smr = 'Simulated Meeting Rail') then
    
        if (lv_style in ('C2','C3','C4','C5') or lv_sections >= 3) then
          lv_smrprice := 38;
        else
          lv_smrprice := 19;
        end if;
        
        if (lv_smrprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'SIMULATED MEETING RAIL',0,lv_smrprice); end if;
        
        
    end if;
    
    -----Calculate screen last
  
  if (lv_screentype!='No Screen' and lv_screentype!='0' )  then
        
      lv_screenprice := NEW_GETSCREENPRICE (lv_screentype,lv_effectiveunit,lv_sections,lv_construction,lv_series,lv_style,lv_screenid,lv_totalperc);
      
      if (lv_totalperc=0) then
      if (lv_screenprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'SCREEN',lv_screenid,lv_screenprice,0,lv_isshape,0,0,lv_part,'',0,0,lv_mulledunits,lv_effectiveunit); end if;
      end if;
  end if;
   
   
  if (lv_totalperc!=0) then
    lv_atriumprice :=lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice +lv_cottageorielprice + lv_foamwrapprice + lv_superspacerprice+lv_lockprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice +lv_smrprice +lv_screenmeshprice;
    lv_screenprice :=  - (lv_atriumprice *(100-lv_totalperc)/100);
    if (lv_screenprice!=0) then proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'FIXED SCREEN',lv_screenid,lv_screenprice,0,lv_isshape,0,0,lv_part,'',0,0,lv_mulledunits,lv_effectiveunit);  end if;
  end if;
  
  
  ------Write final atrium price
  lv_atriumprice :=lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice + lv_screenprice+lv_seatprice +lv_cottageorielprice+ lv_foamwrapprice+ lv_superspacerprice+lv_lockprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice+lv_smrprice+lv_screenmeshprice;  
 
  
  proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'INFO',0,0,lv_stdsize,lv_isshape,lv_hasgrid,lv_screendeduct,lv_part,lv_sizetype,lv_widthes,lv_heightes,lv_mulledunits,lv_effectiveunit,lv_sections);
  
  proc_WriteToPricingLog (IN_ORDERID,IN_ITEMID,IN_UNITID,lv_linenumber,lv_linetypeid,lv_lognexcept,'ATRIUMPRICE',0,lv_atriumprice);
 


  
  ---Now apply exception and record into log table if any
   begin 
    open c_exception;
    loop fetch c_exception into lv_exassignid,lv_exdiscounttype,lv_exdescid,lv_exvalue,lv_exvariable,lv_exdiscountvalue;
    EXIT WHEN c_exception%NOTFOUND;
      lv_appliedonname :='';
      if lv_exvariable = 'lv_tint' and regexp_like (lv_exvalue,''''||lv_tintin||'''','i') and lv_tintprice > 0  then
        lv_exprice := new_applyexception (lv_tintprice,lv_exdiscounttype,lv_exdiscountvalue,lv_effectiveunit);
        lv_appliedonname :='TINT';
        lv_exOrigPrice := lv_tintprice;
        lv_tintprice := lv_exprice;
      end if;
      
      if lv_exvariable = 'lv_wood_mull' and ( regexp_like (lv_exvalue,''''||lv_woodsurround||'''','i') or regexp_like (lv_exvalue,''''||lv_mulltype||'''','i'))  and lv_wood_mullprice > 0  then
        lv_exprice := new_applyexception (lv_wood_mullprice,lv_exdiscounttype,lv_exdiscountvalue,lv_effectiveunit);
        lv_appliedonname :='WOOD/MULL';
        lv_exOrigPrice := lv_wood_mullprice;
        lv_wood_mullprice := lv_exprice;
      end if;

      if lv_exvariable = 'lv_color' and regexp_like (lv_exvalue,''''||lv_framecolorin||'''','i')  and lv_colorprice > 0  then
        lv_exprice := new_applyexception (lv_colorprice,lv_exdiscounttype,lv_exdiscountvalue,lv_effectiveunit);
        lv_appliedonname :='COLOR';
        lv_exOrigPrice := lv_colorprice;
        lv_colorprice := lv_exprice;
      end if;
      
      
          PROC_WRITEEXCEPTIONLOG ( LV_LOGNEXCEPT,IN_UNITID,LV_EXASSIGNID,LV_EXDESCID,LV_EXDISCOUNTTYPE,LV_EXDISCOUNTVALUE,lv_exvariable,lv_appliedonname,lv_exOrigprice,lv_exprice);
         
      
    end loop;
    close c_exception;
  end; 
  
  lv_glassprice := lv_tintprice+lv_energyprice+lv_safetyprice;
  
  
   if (lv_totalperc!=0) then
        lv_finalprice :=lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice +lv_cottageorielprice+ lv_foamwrapprice+ lv_superspacerprice+lv_lockprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice+lv_smrprice+lv_screenmeshprice;
        lv_screenprice :=  - (lv_finalprice *(100-lv_totalperc)/100);
        lv_exprice :=lv_finalprice+lv_screenprice;
      
      PROC_WRITEEXCEPTIONLOG ( LV_LOGNEXCEPT,IN_UNITID,0,0,0,0,0,'FIXED SCREEN',lv_finalprice,lv_exprice);
   
  end if;
  
    lv_finalprice :=lv_baseprice + lv_gridprice+lv_colorprice+lv_glassprice+lv_wood_mullprice+lv_seatprice+lv_screenprice +lv_cottageorielprice+ lv_foamwrapprice+ lv_superspacerprice+lv_lockprice+lv_drywallprice+lv_breathertubeprice+lv_sashaccessoryprice+lv_smrprice+lv_screenmeshprice;
   
     PROC_WRITEEXCEPTIONLOG ( LV_LOGNEXCEPT,IN_UNITID,0,0,0,0,0,'FINAL',lv_atriumprice,lv_finalprice);
         

  
  RETURN ROUND(lv_finalprice,3) ;
END NEW_GETPRICE;