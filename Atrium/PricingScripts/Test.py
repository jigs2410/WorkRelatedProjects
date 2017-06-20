# -*- coding: utf-8 -*-
"""
Created on Wed Jun 14 11:07:16 2017

@author: jrathod
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
"""
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
"""
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
"""
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
"""

for object in db_objects:
    diffObjects(object)
    
cur_wwdev.close()
cur_oldwwdev.close()
con_wwdev.close()
con_oldwwdev.close()                 