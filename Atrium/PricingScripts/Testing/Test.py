# -*- coding: utf-8 -*-
import re
"""
Created on Wed Jun 14 11:07:16 2017

@author: jrathod
"""
"""
import cx_Oracle

con_wwdev = cx_Oracle.connect('mssql/mssql@wel-db-2-srv:1521/wwdev')
cur_wwdev = con_wwdev.cursor()

con_oldwwdev = cx_Oracle.connect('mssql/mssql@db1:1521/wwdev')
cur_oldwwdev = con_oldwwdev.cursor()

currentwwdev_tables=[]
oldwwdev_tables=[]

currentwwdev=[]
oldwwdev=[]


def diffObjects(do):
    print()
    print("---------------",do,"---------------")
    currentwwdev.clear()
    oldwwdev.clear()
    query = "select OBJECT_NAME from user_objects where object_type ='"+do+"' order by 1"
    cur_wwdev.execute (query)
    cur_oldwwdev.execute (query)
    
    for row in cur_wwdev:
        currentwwdev.append(row) 
    
    for row1 in cur_oldwwdev:
        oldwwdev.append(row1)
    
    for dbobject in oldwwdev:
        if not dbobject in currentwwdev:
            dbobject = str(dbobject).replace('(','').replace(')','').replace(',','').replace('\'','').strip()
            if not dbobject in except_objects:
                print(dbobject)
            
    #print(query)
    
    

cur_wwdev.execute ('select OBJECT_NAME from user_objects where object_type = \'TABLE\' order by 1')


db_objects= ['FUNCTION',
'PACKAGE',
'PACKAGE BODY',
'PROCEDURE',
'TABLE',
]

for object in db_objects:
    diffObjects(object)

for row in cur_wwdev:
    currentwwdev_tables.append(row)

print()
print()


cur_oldwwdev.execute ('select OBJECT_NAME from user_objects where object_type = \'TABLE\' and object_name = \'NEW_PRICINGSIZE\' order by 1')
for row1 in cur_oldwwdev:
    oldwwdev_tables.append(row1)
    
#    if not (row1 in cur_wwdev):
#        print(row1)

except_objects=['ACCOUNTSMASTER_WWPRD','EBA_DEMO_FILES',
'EBA_DEMO_FILE_PROJECTS',
'EBA_DEMO_LOAD_DEPT',
'EBA_DEMO_LOAD_EMP',
'EBA_SME_ACCESS_LEVELS',
'EBA_SME_CONTACTS',
'EBA_SME_ERRORS',
'EBA_SME_ERROR_LOOKUP',
'EBA_SME_FILES',
'EBA_SME_HISTORY',
'EBA_SME_LINKS',
'EBA_SME_MAP',
'EBA_SME_NOTES',
'EBA_SME_NOTIFICATIONS',
'EBA_SME_PREFERENCES',
'EBA_SME_SUBJECTS',
'EBA_SME_USERS',
'NEW_PRICINGSIZE_BU_10_19_2016',
'OPTION_GRIcon_wwdevU',
'OPTION_GRID_B4_ADDITIONALSHAPE',
'OPTION_GRID_BU',
'OPTION_GRID_BU_8_29_2016',
'OPTION_WOOD_MULL_2_29_2016',
'OPTION_WOOD_MULL_BU',
'STYLE_BU',
'PARTS_105',
'PARTS_BCK',
'EBA_BT',
'EBA_DEMO_FILE_DATA',
'EBA_SME',
'EBA_SME_ACL',
'EBA_SME_FW',
'EBA_SME_EXP_LIST',
'FUNCTION1',
'EBA_DEMO_LOAD_DATA',
'PROC_2017MSA',
'PROC_COPYITEM_EJ',
'PROC_COPYORDER_BACKORDER',
'PROC_COPYORDER_EJ',
'PROC_EXTRALINE_EJ',
'proc_GetNFRC']
#print(except_table)



#print(currentwwdev_tables)

for table in oldwwdev_tables:
    if not table in currentwwdev_tables:
        #table = str(table).replace('(','').replace(')','').replace('\'','').replace(',','')
        #print(table,',')
        table = str(table).replace('(','').replace(')','').replace(',','').replace('\'','').strip()
        #print(table, except_table[0])
        if not table in except_objects:
             #print(table)
             #query = 'select DBMS_METADATA.GET_DDL(\'TABLE\',''\''+table+'\' ) from dual'
             query = 'select count(*) from '+ table+''
             #print(query)
             cur_oldwwdev.execute (query)
             for row in cur_oldwwdev:
                 #print(row[0].read())
                 print(table,row[0])
             query = 'select DBMS_METADATA.GET_DDL(\'TABLE\',''\''+table+'\' ) from dual'
             cur_oldwwdev.execute (query)
             for row in cur_oldwwdev:
                 print(row[0].read())


for object in db_objects:
    diffObjects(object)
    
cur_wwdev.close()
cur_oldwwdev.close()
con_wwdev.close()
con_oldwwdev.close()       
"""

str1= "insert into NEW_EXCEPTIONDESC (ID,DESCR,IGNORE,APPLYON,VARIABLE1,OPERATOR1,VALUE1,VARIABLE2,OPERATOR2,VALUE2,VARIABLE3,OPERATOR3,VALUE3,VARIABLE4,OPERATOR4,VALUE4,VARIABLE5,OPERATOR5,VALUE5,USER_ID,DATESTAMP) values  (2, 'SH CUSTOM PRICE WHITE CLEAR $2.08 WHITE GRID $2.17', NULL, 'BASE', 'STD SIZE', '=', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'JRATHOD', datetime.datetime(2016, 2, 12, 6, 9, 59))"
print(len(list(re.finditer('datetime.datetime', str1))))
#for m in re.finditer('datetime.datetime', str1):
#    print('datetime', m.start(), m.end())
"""
searchObj = re.search( r'datetime.datetime\(.*\).*', str1, re.M|re.I)

if searchObj:
   print( "searchObj.group() : ", searchObj.group())
   print( "searchObj.group(1) : ", searchObj.group(1))
   print( "searchObj.group(2) : ", searchObj.group(2))
else:
   print( "Nothing found!!")
"""
#matchList = re.findall(pattern, input_str, flags=0)

regex = r"[a-zA-Z]+ \d+"
matches = re.findall(regex, "hello lhe June 24, August 9, Dec 12")
for match in matches:
    # This will print:
    #   June 24
    #   August 9
    #   Dec 12
    print("Full match: %s" % (match))
    
regex = r"datetime.datetime\(\d+, \d+, \d+, \d+, \d+, \d+\)"
matches = re.findall(regex, str1)
for match in matches:
    # This will print:
    #   June 24
    #   August 9
    #   Dec 12
    replacestr = match
    replacestr = replacestr.replace('datetime.datetime','to_timestamp').replace('(','(\'').replace(',','-').replace(' ','').replace(')','\' ,\'RRRR-MM-DD-HH-MI-SS\')')
    str1=str1.replace(match,replacestr)
    print("Full match: %s %s" % (match, replacestr))   
         
#insert into NEW_EXCEPTIONDESC (ID,DESCR,IGNORE,APPLYON,VARIABLE1,OPERATOR1,VALUE1,VARIABLE2,OPERATOR2,VALUE2,VARIABLE3,OPERATOR3,VALUE3,VARIABLE4,OPERATOR4,VALUE4,VARIABLE5,OPERATOR5,VALUE5,USER_ID,DATESTAMP) values  (21, 'TWIN 4 9/16 PAINTABLE WOODJAMB $70.00 LIST', NULL, 'WOOD/MULL', 'WOOD/MULL', 'IN', '''Wood 4''', 'MULLED UNITS', '=', '2', 'SHAPES', '=', '0', NULL, NULL, NULL, NULL, NULL, NULL, 'JRATHOD', datetime.datetime(2016, 2, 12, 6, 48, 3))
#insert into NEW_EXCEPTIONDESC (ID,DESCR,IGNORE,APPLYON,VARIABLE1,OPERATOR1,VALUE1,VARIABLE2,OPERATOR2,VALUE2,VARIABLE3,OPERATOR3,VALUE3,VARIABLE4,OPERATOR4,VALUE4,VARIABLE5,OPERATOR5,VALUE5,USER_ID,DATESTAMP) values  (62, 'SH 2/8 5/4 SAME PRICE AS 2/8 5/6', NULL, 'BASE', 'WIDTH ES', '=', '31.5', 'HEIGHT ES', '=', '63.5', 'STD SIZE', '=', '0', NULL, NULL, NULL, NULL, NULL, NULL, 'JRATHOD', datetime.datetime(2016, 2, 12, 6, 9, 59))

print(str1)
pricingList = ['NEW_DOOR_PRICINGSIZE', 'NEW_EXCEPTIONDESC', 'NEW_EXCEPTIONS', 'NEW_EXCEPTIONS_BASE', 'NEW_PRICELOG', 'NEW_PRICELOGHISTORY', 'NEW_PRICEMULTIPLIER', 'NEW_PRICENEXCEPTLOG', 'NEW_PRICINGLOG', 'NEW_PRICINGSIZE', 'NEW_PRICINGSIZEMAP', 'NEW_PRICINGSIZE_LOWES', 'NEW_PRICINGTYPE', 'NEW_PRICING_CONFIG', 'NEW_VARIABLEMAP', 'OPTION_COLOR', 'OPTION_COLOR_LOWES', 'OPTION_COTTAGEORIEL', 'OPTION_COTTAGEORIEL_LOWES', 'OPTION_DRYWALL', 'OPTION_DRYWALL_LOWES', 'OPTION_FOAMWRAP', 'OPTION_FOAMWRAP_LOWES', 'OPTION_GLASS', 'OPTION_GLASS_ALUM', 'OPTION_GLASS_ALUMINUM', 'OPTION_GLASS_ALUMINUM_LOWES', 'OPTION_GLASS_LOWES', 'OPTION_GRID', 'OPTION_GRIDBU', 'OPTION_GRID_LOWES', 'OPTION_HARDWARE', 'OPTION_HARDWARE_LOWES', 'OPTION_OTHERS', 'OPTION_OTHERS_LOWES', 'OPTION_SASHACCESSORY', 'OPTION_SASHACCESSORY_LOWES', 'OPTION_SCREEN', 'OPTION_SCREENMESH', 'OPTION_SCREENMESHBU', 'OPTION_SCREENMESH_LOWES', 'OPTION_SCREEN_LOWES', 'OPTION_SEAT', 'OPTION_SEAT_LOWES', 'OPTION_WARRANTY', 'OPTION_WARRANTY_LOWES', 'OPTION_WOOD_MULL', 'OPTION_WOOD_MULL_LOWES', 'PRICINGCUSTOM', 'PRICINGOPTIONEXCEPT_PARENT', 'PRICING_DESC', 'PRICING_DESC_MAP', 'PRICING_EXCEPTIONLIST', 'PRICING_GROUP', 'PRICING_OPERATORS', 'PRICING_PRECONDITION','PRICING', 'PRICINGFIELDTYPE', 'PRICINGOPTION', 'PRICINGSIZE', 'PRICINGSIZETITLE', 'PRICINGTITLE', 'PRICING_GROUP', 'PRICING_OPERATORS', 'PRICING_PRECONDITION']          
#for table in pricingList:
#    print(table)
