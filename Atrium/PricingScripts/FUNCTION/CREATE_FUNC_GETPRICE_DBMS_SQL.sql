
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."FUNC_GETPRICE_DBMS_SQL" 
( p_UNITID IN NUMBER,
p_DEBUG IN NUMBER
) RETURN NUMBER DETERMINISTIC IS

lv_optionid pricing.OPTIONID%TYPE;
lv_pricinggroupid pricing.PRICINGGROUPID%TYPE;
lv_fieldtypeid pricingoption.FIELDTYPEID%TYPE;
lv_precondition pricingoption.PRECONDITION%TYPE;
lv_condition pricingoption.PRECONDITION%TYPE;
lv_prevalue pricingoption.PREVALUE%TYPE;

lv_invplant char(1);
lv_orderid l1_item.orderid%TYPE;
lv_linetypeid l1_item.linetypeid%TYPE;
lv_itemid l1_item.itemid%TYPE;
lv_linenumber l1_item.linenumber%TYPE;
lv_quantity l1_item.quantity%TYPE;
lv_priceoverride l1_item.priceoverride%TYPE;
lv_rendercode l1_item.rendercode%TYPE;
lv_lowercount configurations.lowercount%TYPE;
lv_uppercount configurations.uppercount%TYPE;
lv_construction l1_item.construction%TYPE;
lv_itemsizecode l1_item.sizecode%TYPE;
lv_itemwidthns l1_item.widthns%TYPE;
lv_itemheightns l1_item.heightns%TYPE;
lv_itemwidthos l1_item.widthos%TYPE;
lv_itemheightos l1_item.heightos%TYPE;
lv_itemwidthes l1_item.widthes%TYPE;
lv_itemheightes l1_item.heightes%TYPE;
lv_angle l1_item.angle%TYPE;
lv_walldepthes l1_item.walldepthes%TYPE;
lv_shelf l1_item.shelf%TYPE;
lv_seat l1_item.seat%TYPE;
lv_woodsurround l1_item.woodsurround%TYPE;
lv_glassplus l1_item.glassplus%TYPE;
lv_foamwrap l1_item.foamwrap%TYPE;
lv_fins l1_item.fins%TYPE;
lv_sampledisplay l1_item.sampledisplay%TYPE;
lv_sashdivision l1_item.sashdivision%TYPE;
lv_skunumber l1_item.skunumber%TYPE;
lv_gridposition l1_item.gridposition%TYPE;
lv_gridplacement l1_item.gridplacement%TYPE;
lv_configuration l1_item.configuration%TYPE;
lv_mutype l1_item.mutype%TYPE;
lv_specialmulled l1_item.specialmulled%TYPE;
lv_widthegr l1_item.widthegr%TYPE;
lv_heightegr l1_item.heightegr%TYPE;
lv_inconfig l2_unit.inconfig%TYPE;
lv_sizecode l2_unit.sizecode%TYPE;
lv_widthns l2_unit.widthns%TYPE;
lv_heightns l2_unit.heightns%TYPE;
lv_widthes l2_unit.widthes%TYPE;
lv_heightes l2_unit.heightes%TYPE;
lv_dim1es l2_unit.dim1es%TYPE;
lv_dim2es l2_unit.dim2es%TYPE;
lv_dim3es l2_unit.dim3es%TYPE;
lv_series l2_unit.series%TYPE;
lv_style l2_unit.style%TYPE;
lv_brand l2_unit.brand%TYPE;
lv_model l2_unit.model%TYPE;
lv_hinge l2_unit.hinge%TYPE;
lv_egress l2_unit.egress%TYPE;
lv_cottageoriel l2_unit.cottageoriel%TYPE;
lv_meetingrailes l2_unit.meetingrailes%TYPE;
lv_outsourcedto l2_unit.outsourcedto%TYPE;
lv_woodtrim l2_unit.woodtrim%TYPE;
lv_stdgrid l2_unit.stdgrid%TYPE;
lv_stdlock l2_unit.stdlock%TYPE;
lv_gbwavailable l2_unit.gbwavailable%TYPE;
lv_accessory l2_unit.accessory%TYPE;


lv_smr l2_unit.smr%TYPE;


lv_screentype l3_screen.screentype%TYPE;

lv_hardwaretype l3_hardware.hardwaretype%TYPE;
lv_hardwarecolor l3_hardware.hardwarecolor%TYPE;

lv_framecolorin l3_frame.framecolorin%TYPE;
lv_framecolorout l3_frame.framecolorout%TYPE;

lv_tintin l5_glass.tintin%TYPE;
lv_tintout l5_glass.tintout%TYPE;
lv_energy l5_glass.energy%TYPE;

lv_safetyin l5_glass.safetyin%TYPE;
lv_safetyout l5_glass.safetyout%TYPE;

lv_gridpattern l5_glass.gridpattern%TYPE;
lv_gridstyle l5_glass.gridstyle%TYPE;
lv_gridtypein l5_glass.gridtypein%TYPE;
lv_gridtypeout l5_glass.gridtypeout%TYPE;
lv_breathertube l5_glass.breathertube%TYPE;


lv_widededuct deductions.wide_deduct%TYPE;
lv_highdeduct deductions.high_deduct%TYPE;

lv_effectiveunit style.orcl_effect_unit%TYPE;
lv_horsashcount style.horsashcount%TYPE;
lv_versashcount style.versashcount%TYPE;
lv_category style.category%TYPE;
lv_part style.part%TYPE;

-- Added for PWP (next 6):
lv_accountid ordermaster.accountid%TYPE;
lv_pricingorderindex pricing.orderindex%TYPE;
lv_pricingoptionorderindex pricingoption.orderindex%TYPE;
lv_precedence pricingoption.precedence%TYPE;
lv_screenmeshtype l3_screen.screenmeshtype%TYPE;
lv_panetype l2_unit.pane_type%TYPE;
lv_mulltype l3_mull.mulltype%TYPE;
lv_spacertype l5_glass.spacertype%TYPE;
lv_silltype l3_frame.silltype%TYPE;
lv_reinforcement l3_frame.reinforcement%TYPE;
lv_gridcolorin l5_glass.gridcolorin%TYPE;
lv_gridcolorout l5_glass.gridcolorout%TYPE;
lv_hardwareaccessory l2_unit.hardwareaccessory%TYPE;
lv_sashaccessory l3_hardware.sashaccessorytype%TYPE;
lv_projection1 l1_item.projection1%TYPE;
lv_projection2 l1_item.projection2%TYPE;
lv_itemacc l1_item.item_acc%TYPE;
lv_itemhardacc l1_item.item_hard_acc%TYPE;
lv_material l3_frame.material%TYPE;
lv_glassautoset l5_glass.caelusglasslocation%TYPE;



lv_sections number;
--lv_dryervent L2_UNIT.DRYER_VENT%TYPE;

lv_price number;
lv_queryprice number;
lv_baseprice number;
lv_totalpricededuct number :=0;
lv_optionprice number;
lv_optionprice_group number;
lv_stockprice number;
lv_return number;
lv_count number;
lv_ReturnMsg varchar2(3000);
-- Added for PWP {next 6):
nbr_prevalue number;

lv_pv_optionid number;
lv_pv_pricingorderindex number;
lv_pv_pricingoptionorderindex number;
lv_pv_precedence number;
lv_lites number;
lv_shapes number;
lv_shapeprice number;
lv_shapesdlprice number;
lv_screenprice number;

lv_standardsize number;
--lv_customscreen number;
lv_multiplier number;

lv_laminate number;
lv_painted number;

lv_doorpanel number;

lv_gbwselected ORDERMASTER.GBWSELECTED%TYPE;
lv_customerid ordermaster.customerid%type;


  colDescs DBMS_SQL.DESC_TAB2;
  
  numCols INTEGER;

cur_hdl         INTEGER;
   stmt_str        VARCHAR2(32565);
   rows_processed  BINARY_INTEGER;
   
       vIgnore integer;
   
CURSOR cur_Pricing IS
SELECT pricing.optionid as optionid,
  pricing.pricinggroupid,
  fieldtypeid,
  precondition,
  prevalue,
  substr(l2_unit.infopartnumber,5,1) invplant,
  l1_item.orderid,
  l1_item.linetypeid,
  l1_item.linenumber,
          l1_item.quantity,
          l1_item.priceoverride,
          l1_item.rendercode,
          configurations.lowercount,
          configurations.uppercount,
          l1_item.construction,
          l1_item.sizecode,
          l1_item.widthns,
          l1_item.heightns,
          l1_item.widthos,
          l1_item.heightos,
          l1_item.widthes,
          l1_item.heightes,
          l1_item.angle,
          l1_item.walldepthes,
          l1_item.shelf,
          l1_item.seat,
          l1_item.woodsurround,
          l1_item.glassplus,
          l1_item.foamwrap,
          l1_item.fins,
          l1_item.sampledisplay,
          l1_item.sashdivision,
          l1_item.skunumber,
          l1_item.gridposition,
          l1_item.gridplacement,
          l1_item.configuration,
          l1_item.mutype,
          l1_item.specialmulled,
          l1_item.widthegr,
          l1_item.heightegr,
          l2_unit.inconfig,
          l2_unit.sizecode,
          l2_unit.widthns,
          l2_unit.heightns,
          NVL(l2_unit.widthes,0),
          NVL(l2_unit.heightes,0),
          l2_unit.dim1es,
          l2_unit.dim2es,
          l2_unit.dim3es,
          l2_unit.series,
          l2_unit.style,
          l2_unit.brand,
          l2_unit.model,
          l2_unit.hinge,
          l2_unit.egress,
          l2_unit.cottageoriel,
          l2_unit.meetingrailes,
          l2_unit.outsourcedto,
          l2_unit.woodtrim,
          l2_unit.stdgrid,
          l2_unit.stdlock,
          l2_unit.gbwavailable,
          l2_unit.accessory,
          l3_screen.screentype,
          l3_hardware.hardwaretype,
          l3_hardware.hardwarecolor,
          l3_frame.framecolorin,
          l3_frame.framecolorout,
          l5_glass.tintin,
          l5_glass.tintout,
          l5_glass.energy,
          l5_glass.safetyin,
          l5_glass.safetyout,
          --l5_glass.gridpattern,
         -- l1_item.grid_desc, --NVL(FUNC_AGGREGATE_GRIDPATTERNS(p_UNITID),' '),--l1_item.grid_desc,
         NVL(FUNC_AGGREGATE_GRIDPATTERNS(p_UNITID),' '),
          l5_glass.gridstyle,
          l5_glass.gridtypein,
          l5_glass.gridtypeout,
          --deductions.wide_deduct,
          --deductions.high_deduct,
          0,
          0,
          style.orcl_effect_unit,
          style.horsashcount,
          style.versashcount,
          ordermaster.accountid,
          pricing.orderindex,
          pricingoption.orderindex,
          pricingoption.precedence,
          l3_screen.screenmeshtype,
          l2_unit.pane_type,
          l3_mull.mulltype,
          l5_glass.spacertype,
          l3_frame.silltype,
          l3_frame.reinforcement,
          l5_glass.gridcolorin,
          l5_glass.gridcolorout,
          l2_unit.hardwareaccessory,
          l3_hardware.sashaccessorytype,
          l1_item.projection1,
          l1_item.projection2,
          l1_item.item_acc,
          l1_item.item_hard_acc,
          l3_frame.material,
          l5_glass.caelusglasslocation,
            (case when l2_unit.style in ('C2','A2H','A2V') then 2 when l2_unit.style in ('30B','45B','3LB','C3','A3H','A3V') then 3 when l2_unit.style in ('4LB','C4') then 4 when l2_unit.style in ('5LB','C5') then 5 else 1 end) sections
            --,L2_UNIT.DRYER_VENT
            ,NVL(func_getlites(NVL(FUNC_AGGREGATE_GRIDPATTERNS(p_UNITID),' ')),0)
            ,l2_unit.smr
            ,NVL(func_isshape(l2_unit.style),0)
            ,NVL(func_pricecustom('',upper(l2_unit.style),upper(l5_glass.gridpattern),1,0,'GRIDPATTERN'),0)
            ,NVL(func_pricecustom('',upper(l2_unit.style),upper(l5_glass.gridpattern),0,1,'GRIDPATTERN'),0)
           ,NVL(func_pricecustomsize(''''||l2_unit.model||'''',l2_unit.widthes,l2_unit.heightes,1,0, style.orcl_effect_unit),0)
            --,NVL(func_pricecustomsize(l2_unit.model,l2_unit.widthes,l2_unit.heightes,0,1),0)
            ,NVL(func_pricecustom('',upper(l2_unit.style),upper(l3_Screen.screentype),1,0,'SCREEN'),0)
            --,NVL(func_getbasemultiplier(ordermaster.accountid,ordermaster.customerid,l2_unit.series,l2_unit.style,l2_unit.model,100),0)
            ,0
            --,NVL(func_get_mult(ordermaster.accountid,ordermaster.customerid,l2_unit.series,l2_unit.style,l2_unit.model,100),0)
            ,l1_item.itemid
            ,style.category
            ,style.part
            --,NVL(func_pricecolor('INTERIORLAMINATE',upper(l3_frame.framecolorin)),0)
            --,NVL(func_pricecolor('EXTERIORPAINT',upper(l3_frame.framecolorout)),0)
              ,NVL(func_pricecustom('','',upper(l3_frame.framecolorin),0,0,'INTERIORLAMINATE'),0)
            ,NVL(func_pricecustom('','',upper(l3_frame.framecolorout),0,0,'EXTERIORPAINT'),0)
            ,NVL(func_pricecustom(l2_unit.model,'','',0,0,'DOORPANEL'),0)
            ,l5_glass.breathertube
            ,ORDERMASTER.GBWSELECTED
            ,ORDERMASTER.CUSTOMERID
FROM "L5_GLASS" "L5_GLASS",
     "L4_SASH" "L4_SASH",
     "L3_SCREEN" "L3_SCREEN",
     "L3_HARDWARE" "L3_HARDWARE",
     "L3_FRAME" "L3_FRAME",
     "L3_MULL" "L3_MULL",
     "L2_UNIT" "L2_UNIT",
     "L1_ITEM" "L1_ITEM",
     "PRICINGOPTION" "PRICINGOPTION",
     "PRICING" "PRICING" ,
    -- "PRICING_GROUP" "PRICING_GROUP" ,
     "CONFIGURATIONS" "CONFIGURATIONS",
   --  "DEDUCTIONS" "DEDUCTIONS",
     "STYLE" "STYLE",
	   "ORDERMASTER" "ORDERMASTER"
WHERE "L2_UNIT"."UNITID" =p_UNITID
      and "L2_UNIT"."UNITID"="L3_FRAME"."UNITID"
      and "L1_ITEM"."ITEMID"="L2_UNIT"."ITEMID"
      and "L2_UNIT"."UNITID"="L3_SCREEN"."UNITID"
      and "L2_UNIT"."UNITID"="L3_HARDWARE"."UNITID"
      and "L2_UNIT"."UNITID"="L3_MULL"."UNITID"(+)
      and "L3_FRAME"."FRAMEID"="L4_SASH"."FRAMEID"
      and "L4_SASH"."SASHLOCATION" =0
      and "L4_SASH"."SASHID"="L5_GLASS"."SASHID"
	    and "L1_ITEM"."ORDERID" = "ORDERMASTER"."ORDERID"

      and
      (
         bitand("PRICING"."PLANT",substr(l2_unit.infopartnumber,5,1))=1 and
          ("PRICING"."CONSTRUCTIONCODE"="L1_ITEM"."CONSTRUCTION" or "PRICING"."CONSTRUCTIONCODE" is null)
         or ( "PRICING"."PLANT" is null and ("PRICING"."CONSTRUCTIONCODE"="L1_ITEM"."CONSTRUCTION" or "PRICING"."CONSTRUCTIONCODE" is null)
           and (
                  ("PRICING"."BRAND"="L2_UNIT"."BRAND" or "PRICING"."BRAND" is null) and 
                  (
                      (regexp_like ( "PRICING"."SERIES",''''||"L2_UNIT"."SERIES"||'''','i') and regexp_like ( "PRICING"."STYLE",''''||"L2_UNIT"."STYLE"||'''','i') and "PRICING"."CONSTRUCTIONCODE"="L1_ITEM"."CONSTRUCTION" and "PRICING"."MODEL" is null)
                   or (regexp_like ( "PRICING"."SERIES",''''||"L2_UNIT"."SERIES"||'''','i') and "PRICING"."STYLE" is null and regexp_like ( "PRICING"."MODEL",''''||"L2_UNIT"."MODEL"||'''','i'))
                   or (regexp_like ( "PRICING"."SERIES",''''||"L2_UNIT"."SERIES"||'''','i') and "PRICING"."STYLE" is null and "PRICING"."MODEL" is null)
                   or (regexp_like ( "PRICING"."SERIES",''''||"L2_UNIT"."SERIES"||'''','i') and regexp_like ( "PRICING"."STYLE",''''||"L2_UNIT"."STYLE"||'''','i') and "PRICING"."CONSTRUCTIONCODE"="L1_ITEM"."CONSTRUCTION" and regexp_like ( "PRICING"."MODEL",''''||"L2_UNIT"."MODEL"||'''','i'))
                   or ("PRICING"."SERIES" is null and  regexp_like ( "PRICING"."STYLE",''''||"L2_UNIT"."STYLE"||'''','i') and "PRICING"."CONSTRUCTIONCODE"="L1_ITEM"."CONSTRUCTION" and "PRICING"."MODEL" is null)
                   or ("PRICING"."SERIES" is null and "PRICING"."STYLE" is null and regexp_like ( "PRICING"."MODEL",''''||"L2_UNIT"."MODEL"||'''','i'))
                   or ("PRICING"."SERIES" is null and "PRICING"."STYLE" is null and "PRICING"."MODEL" is null)
                   or ("PRICING"."SERIES" is null and regexp_like ( "PRICING"."STYLE",''''||"L2_UNIT"."STYLE"||'''','i') and "PRICING"."CONSTRUCTIONCODE"="L1_ITEM"."CONSTRUCTION" and regexp_like ( "PRICING"."MODEL",''''||"L2_UNIT"."MODEL"||'''','i'))
                 )
               )
            )
      )
      and ("PRICING"."ACCOUNTID" is null or "PRICING"."ACCOUNTID" = "ORDERMASTER"."ACCOUNTID")
      and ("PRICING"."CUSTOMERID" is null or "PRICING"."CUSTOMERID" = "ORDERMASTER"."CUSTOMERID")
      and ( "PRICING".groupname is null or (ordermaster.accountid  in (select accountid from pricing_group where upper(groupname) =  upper("PRICING".groupname) and accountid = ordermaster.accountid))) 
      --  and ( "PRICING"."CATEGORY" is null or ("L2_UNIT"."STYLE" in (select STYLECODE from STYLE where upper(CATEGORY) =  upper("PRICING".groupname) and accountid = ordermaster.accountid))) 
      --  and ("PRICING"."GROUPNAME" is null or ("PRICING"."GROUPNAME" = "PRICING_GROUP"."GROUPNAME" and "PRICING_GROUP"."ACCOUNTID" in ( "ORDERMASTER"."ACCOUNTID"  )))
      --  and ("PRICING"."CATEGORY" is null or (( regexp_count("PRICING"."CATEGORY",(select category from style where stylecode ="L2_UNIT"."STYLE" ),1,'i' )  ) > 0 ))
      and ("PRICING"."CATEGORY" is null or  regexp_like ("PRICING"."CATEGORY","STYLE"."CATEGORY",'i'))
      and "PRICING"."OPTIONID"="PRICINGOPTION"."OPTIONID"
      --and "PRICING"."OPTIONID"<>20 -- Breakage option
      and "PRICING"."PRICINGGROUPID"="PRICINGOPTION"."PRICINGGROUPID"
      and "L1_ITEM"."RENDERCODE"="CONFIGURATIONS"."RENDERCODE"
    --  and "DEDUCTIONS"."MODEL_NUMBER"=SUBSTR("L2_UNIT"."MODEL", 1, 3)
    --  and "DEDUCTIONS"."SIZING_SYSTEM"='O'
      and "STYLE"."STYLECODE"="L2_UNIT"."STYLE"
      and pricing.pricinggroupid >= 2321
     -- and pricing.dateeffective < sysdate
     -- and pricing.optionid = 0
ORDER BY "PRICING"."OPTIONID","PRICING"."ORDERINDEX", "PRICINGOPTION"."ORDERINDEX", "PRICINGOPTION"."PRECEDENCE";

BEGIN
  OPEN cur_Pricing;
  lv_price:=0;
  lv_queryprice:=0;
  lv_baseprice:=0;
  lv_optionprice:=0;
  lv_optionprice_group:=0;
  lv_stockprice:=0;
  nbr_prevalue:=0;
  lv_pv_optionid:=-1;
  lv_pv_pricingorderindex:=-1;
  lv_pv_pricingoptionorderindex:=-1;
  lv_pv_precedence:=-1;

--DBMS_OUTPUT.PUT_LINE('1');

  LOOP
      FETCH cur_Pricing
  INTO
  lv_optionid,
  lv_pricinggroupid,
  lv_fieldtypeid,
  lv_precondition,
  lv_prevalue,
  lv_invplant,
  lv_orderid,
  lv_linetypeid,
  lv_linenumber,
                  lv_quantity,
                  lv_priceoverride,
                  lv_rendercode,
                  lv_lowercount,
                  lv_uppercount,
                  lv_construction,
                  lv_itemsizecode,
                  lv_itemwidthns,
                  lv_itemheightns,
                  lv_itemwidthos,
                  lv_itemheightos,
                  lv_itemwidthes,
                  lv_itemheightes,
                  lv_angle,
                  lv_walldepthes,
                  lv_shelf,
                  lv_seat,
                  lv_woodsurround,
                  lv_glassplus,
                  lv_foamwrap,
                  lv_fins,
                  lv_sampledisplay,
                  lv_sashdivision,
                  lv_skunumber,
                  lv_gridposition,
                  lv_gridplacement,
                  lv_configuration,
                  lv_mutype,
                  lv_specialmulled,
                  lv_widthegr,
                  lv_heightegr,
                  lv_inconfig,
                  lv_sizecode,
                  lv_widthns,
                  lv_heightns,
                  lv_widthes,
                  lv_heightes,
                  lv_dim1es,
                  lv_dim2es,
                  lv_dim3es,
                  lv_series,
                  lv_style,
                  lv_brand,
                  lv_model,
                  lv_hinge,
                  lv_egress,
                  lv_cottageoriel,
                  lv_meetingrailes,
                  lv_outsourcedto,
                  lv_woodtrim,
                  lv_stdgrid,
                  lv_stdlock,
                  lv_gbwavailable,
                  lv_accessory,
                  lv_screentype,
                  lv_hardwaretype,
                  lv_hardwarecolor,
                  lv_framecolorin,
                  lv_framecolorout,
                  lv_tintin,
                  lv_tintout,
                  lv_energy,
                  lv_safetyin,
                  lv_safetyout,
                  lv_gridpattern,
                  lv_gridstyle,
                  lv_gridtypein,
                  lv_gridtypeout,
                  lv_widededuct,
                  lv_highdeduct,
                  lv_effectiveunit,
                  lv_horsashcount,
                  lv_versashcount,
                  lv_accountid,
                  lv_pricingorderindex,
                  lv_pricingoptionorderindex,
                  lv_precedence,
                  lv_screenmeshtype,
                  lv_panetype,
                  lv_mulltype,
                  lv_spacertype,
                  lv_silltype,
                  lv_reinforcement,
                  lv_gridcolorin,
                  lv_gridcolorout,
                  lv_hardwareaccessory,
                  lv_sashaccessory,
                  lv_projection1,
                  lv_projection2,
                  lv_itemacc,
                  lv_itemhardacc,
                  lv_material,
                  lv_glassautoset,
            lv_sections
            --,lv_dryervent
            ,lv_lites
            ,lv_smr
            ,lv_shapes
            ,lv_shapeprice
            ,lv_shapesdlprice
            ,lv_standardsize
            --,lv_customscreen
            ,lv_screenprice
            ,lv_multiplier
            ,lv_itemid
            ,lv_category
            ,lv_part
            ,lv_laminate
            ,lv_painted
            ,lv_doorpanel
            ,lv_breathertube
            ,lv_gbwselected
            ,lv_customerid
  ;
  --  DBMS_OUTPUT.PUT_LINE( '2');
  
--DBMS_OUTPUT.PUT_LINE(lv_pricinggroupid || ' '||lv_precondition || ' '|| lv_prevalue );
  EXIT WHEN cur_Pricing%NOTFOUND;

--EXECUTE IMMEDIATE lv_precondition;
lv_return:=0; -- we still want to apply the pricing if no precondition exists
IF (p_DEBUG=1) THEN 
proc_pricedebug('BEGIN','', '','', p_UNITID, '', '', '', '', '', '', '');
--DBMS_OUTPUT.PUT_LINE('3');
  END IF;
if lv_precondition IS NOT NULL
THEN
--stmt_str  :=;

cur_hdl := dbms_sql.open_cursor;

   -- parse cursor
   dbms_sql.parse(cur_hdl, '
DECLARE
orderid number(10):=:1;
linetypeid number(5):=:2;
linenumber number(5):=:3;
quantity l1_item.quantity%TYPE:=:4;
priceoverride l1_item.priceoverride%TYPE:=:5;
rendercode l1_item.rendercode%TYPE:=:6;
construction l1_item.construction%TYPE:=:7;
itemsizecode l1_item.sizecode%TYPE:=:8;
itemwidthns l1_item.widthns%TYPE:=:9;
itemheightns l1_item.heightns%TYPE:=:10;
itemwidthos l1_item.widthos%TYPE:=:11;
itemheightos l1_item.heightos%TYPE:=:12;
itemwidthes l1_item.widthes%TYPE:=:13;
itemheightes l1_item.heightes%TYPE:=:14;
angle l1_item.angle%TYPE:=:15;
walldepthes l1_item.walldepthes%TYPE:=:16;
shelf l1_item.shelf%TYPE:=:17;
seat l1_item.seat%TYPE:=:18;
woodsurround l1_item.woodsurround%TYPE:=:19;
glassplus l1_item.glassplus%TYPE:=:20;
foamwrap l1_item.foamwrap%TYPE:=:21;
fins l1_item.fins%TYPE:=:22;
sampledisplay l1_item.sampledisplay%TYPE:=:23;
sashdivision l1_item.sashdivision%TYPE:=:24;
skunumber l1_item.skunumber%TYPE:=:25;
gridposition l1_item.gridposition%TYPE:=:26;
gridplacement l1_item.gridplacement%TYPE:=:27;
configuration l1_item.configuration%TYPE:=:28;
mutype l1_item.mutype%TYPE:=:29;
specialmulled l1_item.specialmulled%TYPE:=:30;
widthegr l1_item.widthegr%TYPE:=:31;
heightegr l1_item.heightegr%TYPE:=:32;
              inconfig l2_unit.inconfig%TYPE := :33;
              sizecode l2_unit.sizecode%TYPE := :34;
              widthns l2_unit.widthns%TYPE := :35;
              heightns l2_unit.heightns%TYPE := :36;
              widthes l2_unit.widthes%TYPE := :37;
              heightes l2_unit.heightes%TYPE := :38;
              dim1es l2_unit.dim1es%TYPE := :39;
              dim2es l2_unit.dim2es%TYPE := :40;
              dim3es l2_unit.dim3es%TYPE := :41;
              series l2_unit.series%TYPE := :42;
              style l2_unit.style%TYPE := :43;
              brand l2_unit.brand%TYPE := :44;
              model l2_unit.model%TYPE := :45;
              hinge l2_unit.hinge%TYPE := :46;
              egress l2_unit.egress%TYPE := :47;
              cottageoriel l2_unit.cottageoriel%TYPE := :48;
              meetingrailes l2_unit.meetingrailes%TYPE := :49;
              outsourcedto l2_unit.outsourcedto%TYPE := :50;
              woodtrim l2_unit.woodtrim%TYPE := :51;
              stdgrid l2_unit.stdgrid%TYPE := :52;
              stdlock l2_unit.stdlock%TYPE := :53;
              gbwavailable l2_unit.gbwavailable%TYPE := :54;
              accessory l2_unit.accessory%TYPE := :55;
              screentype l3_screen.screentype%TYPE := :56;
              hardwaretype l3_hardware.hardwaretype%TYPE := :57;
              hardwarecolor l3_hardware.hardwarecolor%TYPE := :58;
              framecolorin l3_frame.framecolorin%TYPE := :59;
              framecolorout l3_frame.framecolorout%TYPE := :60;
              tintin l5_glass.tintin%TYPE := :61;
              tintout l5_glass.tintout%TYPE := :62;
              energy l5_glass.energy%TYPE := :63;
              safetyin l5_glass.safetyin%TYPE := :64;
              safetyout l5_glass.safetyout%TYPE := :65;
              gridpattern l5_glass.gridpattern%TYPE := :66;
              gridstyle l5_glass.gridstyle%TYPE := :67;
              gridtypein l5_glass.gridtypein%TYPE := :68;
              gridtypeout l5_glass.gridtypeout%TYPE := :69;
             
              invplant NUMBER := :70;
              widededuct  NUMBER(5,3):=:71;
              highdeduct  NUMBER(5,3):=:72;
              effectiveunit NUMBER := :73;
              hsashcount NUMBER := :74;
              vsashcount NUMBER := :75;
              screenmeshtype l3_screen.screenmeshtype%TYPE := :76;
              panetype l2_unit.pane_type%TYPE := :77;
              mulltype l3_mull.mulltype%TYPE := :78;
              spacertype l5_glass.spacertype%TYPE := :79;
              silltype l3_frame.silltype%TYPE := :80;
              reinforcement l3_frame.reinforcement%TYPE := :81;
              gridcolorin l5_glass.gridcolorin%TYPE := :82;
              gridcolorout l5_glass.gridcolorout%TYPE := :83;
              hardwareaccessory l2_unit.hardwareaccessory%TYPE := :84;
              sashaccessorytype l3_hardware.sashaccessorytype%TYPE := :85;
              projection1 l1_item.projection1%TYPE := :86;
              projection2 l1_item.projection2%TYPE := :87;
              itemacc l1_item.item_acc%TYPE := :88;
              itemhardacc l1_item.item_hard_acc%TYPE := :89;
              material l3_frame.material%TYPE := :90;
              glassautoset l5_glass.caelusglasslocation%TYPE := :91;
              lowercount configurations.lowercount%TYPE := :92;
              uppercount configurations.uppercount%TYPE := :93;
              sections NUMBER := :94;
             -- dryervent l2_unit.dryer_vent%TYPE := :95;
              lites NUMBER := :95;
              smr l2_unit.smr%TYPE := :96;
              shapes NUMBER := :97;
              shapeprice NUMBER := :98;
              shapesdlprice NUMBER := :99;
              stdsize NUMBER := :100;
              
              screenprice NUMBER := :101;
              multiplier NUMBER := :102;
              itemid NUMBER := :103;
              
             category varchar(20) := :104;
             ispart varchar(20) := :105;
              
             laminate NUMBER := :106;
             painted NUMBER := :107;
           
              doorpanel NUMBER := :108;
              
              breathertube l5_glass.breathertube%TYPE := :109;
              
              gbwselected ORDERMASTER.GBWSELECTED%TYPE :=:110;
              
              ui NUMBER := widthes+heightes+widededuct+highdeduct;

              -- To conform to EMI rounding, need to always round up to the next full inch with fractions.
              widthes_ceil NUMBER := CEIL(widthes);
              heightes_ceil NUMBER := CEIL(heightes);
              ui_es NUMBER := widthes_ceil + heightes_ceil;

              -- Following is the way rounding originally done based on eXtremeX pricing sheet
      	      -- Round down based on pricing spec which says:
              -- If this total united inch number results in a fraction, please round down
              -- ui_es NUMBER := FLOOR(widthes+heightes);
              
              widthes_floor NUMBER :=FLOOR(widthes);
              heightes_floor NUMBER := FLOOR(heightes);

              sf NUMBER := trunc((widthes * heightes) / 144, 2);

              mulledunits NUMBER := lowercount + uppercount;
             -- parts NUMBER := hsashcount +  vsashcount;
                windows NUMBER := :73;      
                 
                ignoreret number;
                 
              
                      BEGIN
                        IF ( '|| lv_precondition ||')
                     THEN
                         :lv_return := 1;
                        
                      --    SELECT ' || lv_prevalue || ',1 into ignoreret,ignoreret FROM sys.DUAL;
                     
                     
                       ELSE
                          :lv_return := 0;
                       --  SELECT ' || lv_prevalue || ',0 into ignoreret, ignoreret  FROM sys.DUAL;
                     
                      END IF;
                       
                     END;
                   ',
      dbms_sql.native);

   -- supply binds
   --dbms_sql.bind_variable(cur_hdl, ':1', string1);
  -- dbms_sql.bind_variable
    --  (cur_hdl, ':dname', deptname);
   --dbms_sql.bind_variable
   --   (cur_hdl, ':loc', location);
   
--   DBMS_SQL.DESCRIBE_COLUMNS2(cur_hdl, numCols, colDescs);
--   
--      DBMS_SQL.DEFINE_COLUMN(cur_hdl, 1, nbr_prevalue); 
--      DBMS_SQL.DEFINE_COLUMN(cur_hdl, 2, lv_return); 


                    dbms_sql.bind_variable(cur_hdl,':1',lv_orderid);
                    dbms_sql.bind_variable(cur_hdl,':2',lv_linetypeid);
                    dbms_sql.bind_variable(cur_hdl,':3',lv_linenumber);
                    dbms_sql.bind_variable(cur_hdl,':4',lv_quantity);
                    dbms_sql.bind_variable(cur_hdl,':5',lv_priceoverride);
                    dbms_sql.bind_variable(cur_hdl,':6',lv_rendercode);
                    dbms_sql.bind_variable(cur_hdl,':7',lv_construction);
                    dbms_sql.bind_variable(cur_hdl,':8',lv_itemsizecode);
                    dbms_sql.bind_variable(cur_hdl,':9',lv_itemwidthns);
                    dbms_sql.bind_variable(cur_hdl,':10',lv_itemheightns);
                    dbms_sql.bind_variable(cur_hdl,':11',lv_itemwidthos);
                    dbms_sql.bind_variable(cur_hdl,':12',lv_itemheightos);
                    dbms_sql.bind_variable(cur_hdl,':13',lv_itemwidthes);
                    dbms_sql.bind_variable(cur_hdl,':14',lv_itemheightes);
                    dbms_sql.bind_variable(cur_hdl,':15',lv_angle);
                    dbms_sql.bind_variable(cur_hdl,':16',lv_walldepthes);
                    dbms_sql.bind_variable(cur_hdl,':17',lv_shelf);
                    dbms_sql.bind_variable(cur_hdl,':18',lv_seat);
                    dbms_sql.bind_variable(cur_hdl,':19',lv_woodsurround);
                    dbms_sql.bind_variable(cur_hdl,':20',lv_glassplus);
                    dbms_sql.bind_variable(cur_hdl,':21',lv_foamwrap);
                    dbms_sql.bind_variable(cur_hdl,':22',lv_fins);
                    dbms_sql.bind_variable(cur_hdl,':23',lv_sampledisplay);
                    dbms_sql.bind_variable(cur_hdl,':24',lv_sashdivision);
                    dbms_sql.bind_variable(cur_hdl,':25',lv_skunumber);
                    dbms_sql.bind_variable(cur_hdl,':26',lv_gridposition);
                    dbms_sql.bind_variable(cur_hdl,':27',lv_gridplacement);
                    dbms_sql.bind_variable(cur_hdl,':28',lv_configuration);
                    dbms_sql.bind_variable(cur_hdl,':29',lv_mutype);
                    dbms_sql.bind_variable(cur_hdl,':30',lv_specialmulled);
                    dbms_sql.bind_variable(cur_hdl,':31',lv_widthegr);
                    dbms_sql.bind_variable(cur_hdl,':32',lv_heightegr);
                    dbms_sql.bind_variable(cur_hdl,':33',lv_inconfig);
                    dbms_sql.bind_variable(cur_hdl,':34',lv_sizecode);
                    dbms_sql.bind_variable(cur_hdl,':35',lv_widthns);
                    dbms_sql.bind_variable(cur_hdl,':36',lv_heightns);
                    dbms_sql.bind_variable(cur_hdl,':37',lv_widthes);
                    dbms_sql.bind_variable(cur_hdl,':38',lv_heightes);
                    dbms_sql.bind_variable(cur_hdl,':39',lv_dim1es);
                    dbms_sql.bind_variable(cur_hdl,':40',lv_dim2es);
                    dbms_sql.bind_variable(cur_hdl,':41',lv_dim3es);
                    dbms_sql.bind_variable(cur_hdl,':42',lv_series);
                    dbms_sql.bind_variable(cur_hdl,':43',lv_style);
                    dbms_sql.bind_variable(cur_hdl,':44',lv_brand);
                    dbms_sql.bind_variable(cur_hdl,':45',lv_model);
                    dbms_sql.bind_variable(cur_hdl,':46',lv_hinge);
                    dbms_sql.bind_variable(cur_hdl,':47',lv_egress);
                    dbms_sql.bind_variable(cur_hdl,':48',lv_cottageoriel);
                    dbms_sql.bind_variable(cur_hdl,':49',lv_meetingrailes);
                    dbms_sql.bind_variable(cur_hdl,':50',lv_outsourcedto);
                    dbms_sql.bind_variable(cur_hdl,':51',lv_woodtrim);
                    dbms_sql.bind_variable(cur_hdl,':52',lv_stdgrid);
                    dbms_sql.bind_variable(cur_hdl,':53',lv_stdlock);
                    dbms_sql.bind_variable(cur_hdl,':54',lv_gbwavailable);
                    dbms_sql.bind_variable(cur_hdl,':55',lv_accessory);
                    dbms_sql.bind_variable(cur_hdl,':56',lv_screentype);
                    dbms_sql.bind_variable(cur_hdl,':57',lv_hardwaretype);
                    dbms_sql.bind_variable(cur_hdl,':58',lv_hardwarecolor);
                    dbms_sql.bind_variable(cur_hdl,':59',lv_framecolorin);
                    dbms_sql.bind_variable(cur_hdl,':60',lv_framecolorout);
                    dbms_sql.bind_variable(cur_hdl,':61',lv_tintin);
                    dbms_sql.bind_variable(cur_hdl,':62',lv_tintout);
                    dbms_sql.bind_variable(cur_hdl,':63',lv_energy);
                    dbms_sql.bind_variable(cur_hdl,':64',lv_safetyin);
                    dbms_sql.bind_variable(cur_hdl,':65',lv_safetyout);
                    dbms_sql.bind_variable(cur_hdl,':66',lv_gridpattern);
                    dbms_sql.bind_variable(cur_hdl,':67',lv_gridstyle);
                    dbms_sql.bind_variable(cur_hdl,':68',lv_gridtypein);
                    dbms_sql.bind_variable(cur_hdl,':69',lv_gridtypeout);
                    dbms_sql.bind_variable(cur_hdl,':70',lv_invplant);
                    dbms_sql.bind_variable(cur_hdl,':71',lv_widededuct);
                    dbms_sql.bind_variable(cur_hdl,':72',lv_highdeduct);
                    dbms_sql.bind_variable(cur_hdl,':73',lv_effectiveunit);
                    dbms_sql.bind_variable(cur_hdl,':74',lv_horsashcount);
                    dbms_sql.bind_variable(cur_hdl,':75',lv_versashcount);
                    dbms_sql.bind_variable(cur_hdl,':76',lv_screenmeshtype);
                    dbms_sql.bind_variable(cur_hdl,':77',lv_panetype);
                    dbms_sql.bind_variable(cur_hdl,':78',lv_mulltype);
                    dbms_sql.bind_variable(cur_hdl,':79',lv_spacertype);
                    dbms_sql.bind_variable(cur_hdl,':80',lv_silltype);
                    dbms_sql.bind_variable(cur_hdl,':81',lv_reinforcement);
                    dbms_sql.bind_variable(cur_hdl,':82',lv_gridcolorin);
                    dbms_sql.bind_variable(cur_hdl,':83',lv_gridcolorout);
                    dbms_sql.bind_variable(cur_hdl,':84',lv_hardwareaccessory);
                    dbms_sql.bind_variable(cur_hdl,':85',lv_sashaccessory);
                    dbms_sql.bind_variable(cur_hdl,':86',lv_projection1);
                    dbms_sql.bind_variable(cur_hdl,':87',lv_projection2);
                    dbms_sql.bind_variable(cur_hdl,':88',lv_itemacc);
                    dbms_sql.bind_variable(cur_hdl,':89',lv_itemhardacc);
                    dbms_sql.bind_variable(cur_hdl,':90',lv_material);
                    dbms_sql.bind_variable(cur_hdl,':91',lv_glassautoset);
                    dbms_sql.bind_variable(cur_hdl,':92',lv_lowercount);
                    dbms_sql.bind_variable(cur_hdl,':93',lv_uppercount);
                    dbms_sql.bind_variable(cur_hdl,':94',lv_sections);
                    dbms_sql.bind_variable(cur_hdl,':95',lv_lites);
                    dbms_sql.bind_variable(cur_hdl,':96',lv_smr);
                    dbms_sql.bind_variable(cur_hdl,':97',lv_shapes);
                    dbms_sql.bind_variable(cur_hdl,':98',lv_shapeprice);
                    dbms_sql.bind_variable(cur_hdl,':99',lv_shapesdlprice);
                    dbms_sql.bind_variable(cur_hdl,':100',lv_standardsize);
                    dbms_sql.bind_variable(cur_hdl,':101',lv_screenprice);
                    dbms_sql.bind_variable(cur_hdl,':102',lv_multiplier);
                    dbms_sql.bind_variable(cur_hdl,':103',lv_itemid);
                    dbms_sql.bind_variable(cur_hdl,':104',lv_category);
                    dbms_sql.bind_variable(cur_hdl,':105',lv_part);
                    dbms_sql.bind_variable(cur_hdl,':106',lv_laminate);
                    dbms_sql.bind_variable(cur_hdl,':107',lv_painted);
                    dbms_sql.bind_variable(cur_hdl,':108',lv_doorpanel);
                    dbms_sql.bind_variable(cur_hdl,':109',lv_breathertube);
                    dbms_sql.bind_variable(cur_hdl,':110',lv_gbwselected);

                   dbms_sql.bind_variable(cur_hdl,':lv_return',lv_return);
 --                  dbms_sql.bind_variable(cur_hdl,':nbr_prevalue',nbr_prevalue);
--                  dbms_sql.bind_variable(cur_hdl,':lv_precondition',lv_precondition);
--                   dbms_sql.bind_variable(cur_hdl,':lv_prevalue',lv_prevalue);
                   
                  --  dbms_sql.variable_value (cur_hdl, ':lv_return',lv_return);  
                  --  dbms_sql.variable_value (cur_hdl, ':nbr_prevalue',nbr_prevalue);
                    
                   -- OUT lv_return
                   -- ,OUT nbr_prevalue
                  
                  --DBMS_SQL.DESCRIBE_COLUMNS2(cur_hdl, numCols, colDescs);
                     
                  -- DBMS_SQL.DEFINE_COLUMN(cur_hdl, 1,nbr_prevalue);
                  -- DBMS_SQL.DEFINE_COLUMN(cur_hdl, 2,lv_return);
                   
                  
                     
    -- execute cursor
    rows_processed := dbms_sql.execute(cur_hdl);
--      rows_processed := DBMS_SQL.FETCH_ROWS(cur_hdl); 
    
--DBMS_SQL.FETCH_ROWS(cur_hdl);

   -- DBMS_SQL.COLUMN_VALUE(cur_hdl, 1, nbr_prevalue);
 --   DBMS_SQL.COLUMN_VALUE(cur_hdl, 2, lv_return);

-- DBMS_SQL.COLUMN_VALUE(cur_hdl, 1, nbr_prevalue);
-- DBMS_SQL.COLUMN_VALUE(cur_hdl, 1, lv_return);
 
 
 --dbms_output.put_line('before close ' ||lv_return ); 
    -- close cursor
    dbms_sql.close_cursor(cur_hdl);


 --  dbms_output.put_line(nbr_prevalue ); 
--                          dbms_output.put_line('after close ' ||lv_return ); 
                          


END IF; -- lv_precondition not null


--if condition is true or there was no condition but a database hit, we need to apply pricing
IF lv_return=1 and
   (lv_optionid <> lv_pv_optionid or
    lv_pricingorderindex <> lv_pv_pricingorderindex or
	  lv_pricingoptionorderindex <> lv_pv_pricingoptionorderindex or
    lv_pv_precedence is null) THEN
    
 --     DBMS_OUTPUT.PUT_LINE('PREVALUE is '|| lv_prevalue);
      
 --     DBMS_OUTPUT.PUT_LINE('NBR VALUE is '|| nbr_prevalue);
      --nbr_prevalue := lv_prevalue;
      
        IF lv_effectiveunit > 1 THEN
          --we need to "resize" the unit to a fundamental component size based on oracle effective units
          
          
           --select func_ns_to_ns_unit(lv_widthns,lv_effectiveunit),func_os_to_es_unit(lv_model,lv_itemwidthos,1,lv_effectiveunit) into lv_widthns, lv_widthes from dual;
           --select func_ns_to_os(lv_widthns) into lv_itemwidthos from dual;
           -- changed to always calculate nominal size
           select func_es_to_es_unit(lv_model,lv_widthes,1,lv_effectiveunit) into lv_widthes from dual;
           
        END IF;
        IF (lv_fieldtypeid='2' or lv_fieldtypeid='62') THEN
          BEGIN
             -- IF lv_effectiveunit > 1 THEN
               --   select price * lv_effectiveunit into lv_stockprice from pricingsize
                 --   where pricingsizegroupid=lv_prevalue and sizingsystem='N' and width=lv_widthns and height=lv_heightns;
             -- ELSE
             -- select price * lv_effectiveunit into lv_stockprice from pricingsize
              --   where pricingsizegroupid=lv_prevalue and sizingsystem='N' and width=lv_widthns and height=lv_heightns;
                    if (lv_effectiveunit !=0) then
                       select price * lv_effectiveunit into lv_stockprice from pricingsize
                       where pricingsizegroupid=to_number(lv_prevalue) and sizingsystem='E' and width=to_char(lv_widthes) and height=to_char(lv_heightes);
                     else
                        select price into lv_stockprice from pricingsize
                        where pricingsizegroupid=to_number(lv_prevalue) and sizingsystem='E' and width=to_char(lv_widthes) and height=to_char(lv_heightes);
                     end if ;
               -- END IF;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                lv_stockprice:=lv_baseprice;
              WHEN OTHERS THEN
                -- reset
                DBMS_APPLICATION_INFO.SET_MODULE(module_name => '',
                                                 action_name => '');
                lv_ReturnMsg := 'Problem selecting from pricingsize - ' || SQLCODE;
            END;
        END IF;
        IF lv_fieldtypeid='22' THEN
          BEGIN
            --select price into lv_stockprice from pricingsize
             -- where pricingsizegroupid=lv_prevalue and sizingsystem='N' and width=lv_widthns and height=lv_heightns;
               select price * lv_effectiveunit into lv_stockprice from pricingsize
               where pricingsizegroupid=to_number(lv_prevalue) and sizingsystem='E' and width=to_char(lv_widthes) and height=to_char(lv_heightes);
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  lv_stockprice:=0;
                WHEN OTHERS THEN
                  -- reset
                  DBMS_APPLICATION_INFO.SET_MODULE(module_name => '',
                                                   action_name => '');
                  lv_ReturnMsg := 'Problem selecting from pricingsize - ' || SQLCODE;
          END;
        END IF;

          IF lv_fieldtypeid='1' then --fixed price
                  lv_queryprice:=nbr_prevalue;
                ELSIF lv_fieldtypeid='2' then --stock size table
                        IF lv_stockprice <0 then
                          lv_queryprice:= lv_baseprice;
                        ELSE
                          lv_queryprice:= lv_stockprice;
                        END IF;
                ELSIF lv_fieldtypeid='3' then --united inches integer
                     lv_queryprice:=round((lv_widthes + lv_heightes)*nbr_prevalue,2);
                  --lv_queryprice:=round(( lv_widthes + lv_heightes + lv_widededuct + lv_highdeduct )*nbr_prevalue,2);
                ELSIF lv_fieldtypeid='4' then --square footage
                  lv_queryprice:=round(trunc(( lv_widthes * lv_heightes )/144,2)*nbr_prevalue,2);
                ELSIF lv_fieldtypeid='11' then --Add To Base Price
                  lv_queryprice:=lv_baseprice+nbr_prevalue;
                  
                ELSIF lv_fieldtypeid='62' then --Add To Base Price
                  lv_queryprice:=lv_baseprice+lv_stockprice;
                  
                ELSIF lv_fieldtypeid='12' then --percentage of base price, add to base
                  lv_queryprice:=lv_baseprice+trunc((lv_baseprice*nbr_prevalue/100),2);
                ELSIF lv_fieldtypeid='13' then --percentage of base price
                  lv_queryprice:=round((lv_baseprice*nbr_prevalue/100),2);
                ELSIF lv_fieldtypeid='14' then --Add To Base Price, per lite
                  lv_queryprice:=lv_baseprice+(nbr_prevalue*8); --faking the value to 8 for right now, should be actual number of lites
                ELSIF lv_fieldtypeid='15' then --Add To Base Price, per units
                  lv_queryprice:=lv_baseprice+(nbr_prevalue*(lv_lowercount+lv_uppercount));
                ELSIF lv_fieldtypeid='21' then --fixed deduction
                  lv_queryprice:=nbr_prevalue;
                ELSIF lv_fieldtypeid='22' then --stock size table deduction
                  lv_queryprice:=lv_stockprice;
                ELSIF lv_fieldtypeid='30' then -- multiply by factor
                  lv_queryprice:=lv_baseprice*nbr_prevalue;
                ELSIF lv_fieldtypeid='46' then
                  lv_totalpricededuct:=nbr_prevalue;
            --  ELSIF (lv_fieldtypeid='47' and lv_multiplier !=0)then
--                  lv_queryprice:= ROUND((nbr_prevalue)/lv_multiplier * 100,2) ;
--            

                ELSIF (lv_fieldtypeid='47') then --get multiplier only if needed
                      select NVL(func_get_mult(lv_accountid,lv_customerid,lv_series,lv_style,lv_model,100),0) into lv_multiplier from dual;
                   if (lv_multiplier !=0) then 
                      lv_queryprice:= ROUND((nbr_prevalue)/lv_multiplier * 100,2) ;
                    end if;
            
                ELSIF lv_fieldtypeid='31' then --Add To Base Price, per lite
                  IF lv_gridstyle='Prairie' then
                    lv_queryprice:=(nbr_prevalue*lv_horsashcount*lv_versashcount*9); --prairie has 9 lite per sash
                  ELSIF lv_gridstyle='perimeter' then
                    lv_queryprice:=(nbr_prevalue*lv_horsashcount*lv_versashcount*6); --perimeter prairie has 6 lite per sash
                  ELSE
                    lv_queryprice:=(nbr_prevalue*8); --faking the value to 8, 4/4 for right now, should be actual number of lites
                    --we will get it from lv_lites which will be added to l2_unit along with gridpattern
                  END IF;
                ELSIF lv_fieldtypeid='41' then
                  lv_queryprice:=nbr_prevalue;
          END IF;


          IF (lv_optionid <> lv_pv_optionid) THEN
            lv_optionprice := lv_optionprice + lv_optionprice_group;
            lv_optionprice_group:=0;
          END IF;

          IF (lv_optionid > 0) THEN
            IF (lv_fieldtypeid = '1') THEN 
                lv_optionprice_group := lv_queryprice;
            ELSIF (lv_fieldtypeid = '41') THEN 
                  lv_optionprice_group := lv_optionprice_group + lv_queryprice;
               ELSIF (lv_fieldtypeid = '21' or lv_fieldtypeid = '22') THEN 
                      lv_optionprice := lv_optionprice - lv_queryprice; -- this is an option price adjustement, deduct
                   ELSIF lv_fieldtypeid='30' then -- multiply by factor, option
                          lv_optionprice:=lv_optionprice*nbr_prevalue;
                       ELSIF  lv_fieldtypeid='44' then -- multiply to current group
                              lv_optionprice_group:=(lv_optionprice_group*nbr_prevalue/100); 
                                  ELSIF lv_fieldtypeid='46' then
                                        lv_totalpricededuct:=nbr_prevalue; --dont do anything just store the value
                           ELSIF  lv_fieldtypeid='45' then -- multiply to current group and add it 
                                  lv_optionprice_group:=lv_optionprice_group+(lv_optionprice_group*nbr_prevalue/100); 
                              ELSE lv_optionprice := lv_optionprice + lv_queryprice; -- this is an option price adjustement
            END IF;
      ELSIF (lv_fieldtypeid = '21' or lv_fieldtypeid = '22') THEN 
            lv_baseprice := lv_baseprice - lv_queryprice; -- this is a base price adjustment, deduct
         ELSE lv_baseprice := lv_queryprice; -- this is a base price override, default
         END IF;

  --time to save the results into a table for debugging
        IF (p_DEBUG=1 and lv_stockprice <0) THEN 
          proc_pricedebug('NODATA',lv_orderid, lv_linenumber,lv_itemid, p_UNITID, lv_optionid, lv_pricinggroupid, lv_fieldtypeid, lv_precondition, lv_prevalue, lv_baseprice, lv_optionprice + lv_optionprice_group,lv_pricingorderindex,lv_pricingoptionorderindex);
        ELSIF (p_DEBUG=1) THEN 
          proc_pricedebug('TRUE',lv_orderid, lv_linenumber,lv_itemid, p_UNITID, lv_optionid, lv_pricinggroupid, lv_fieldtypeid, lv_precondition, lv_prevalue, lv_baseprice, lv_optionprice + lv_optionprice_group,lv_pricingorderindex,lv_pricingoptionorderindex);
        END IF;
ELSE
        IF (lv_optionid <> lv_pv_optionid) THEN
          lv_optionprice := lv_optionprice + lv_optionprice_group;
          lv_optionprice_group:=0;
        END IF;
      
        IF (p_DEBUG=1) THEN 
          proc_pricedebug('FALSE',lv_orderid, lv_linenumber,lv_itemid, p_UNITID, lv_optionid, lv_pricinggroupid, lv_fieldtypeid, lv_precondition, lv_prevalue, lv_baseprice, lv_optionprice + lv_optionprice_group,lv_pricingorderindex,lv_pricingoptionorderindex);
        END IF;
END IF;

  lv_pv_optionid := lv_optionid;
  lv_pv_pricingorderindex := lv_pricingorderindex;
  lv_pv_pricingoptionorderindex := lv_pricingoptionorderindex;
  lv_pv_precedence := lv_precedence;

  END LOOP;

  lv_optionprice := lv_optionprice + lv_optionprice_group;

  CLOSE cur_Pricing;
  IF (p_DEBUG=1) THEN proc_pricedebug('END',lv_orderid, lv_linenumber,lv_itemid, p_UNITID, '', '', '', '', '', lv_baseprice, lv_optionprice + lv_optionprice_group);
  END IF;
  --last step
  --changed where we would give discount based on if we had come across any precentage deduction
   lv_price:=lv_baseprice+lv_optionprice;
  --make sure this works
  if (lv_totalpricededuct !=0) then
    lv_price:= lv_price - ROUND(lv_price * ((100-lv_totalpricededuct)/100),2);
    proc_pricedebug('TRUE',lv_orderid, lv_linenumber,lv_itemid, p_UNITID, 0, null, '46', null, lv_totalpricededuct, lv_price, 0);
  end if;
  
  
  IF (p_DEBUG=2) THEN
    RETURN lv_baseprice;
  ELSIF (p_DEBUG=3) THEN
    RETURN lv_optionprice;
  ELSE
    RETURN lv_price;
  END IF;
END FUNC_GETPRICE_DBMS_SQL;