# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 11:07:27 2017

@author: jrathod
"""

import cx_Oracle
import os.path

con= cx_Oracle.connect('mssql/mssql@wel-db-2-srv:1521/wwdev')
cur = con.cursor()

db_objects= ['TABLE','FUNCTION',
'PACKAGE',
'PROCEDURE',
]

def readExecute(path,cur,con,readline=0):
    if (os.path.isfile(path)):
        with open(path) as content:
            if (readline == 1):
                 for line in content: 
                   line=line.strip()
                   print(line)
                   cur.execute(line)
                   con.commit()
   
            else:
                script = content.read()
                print(script)
                cur.execute(script)

for objects in db_objects:
    print(objects)
    
    # iterate through contents
    filepath  = objects+"\\"+objects+".txt"
    data=""
    with open(filepath) as file:
        for dbobject in file: 
            dbobject=dbobject.strip()
            
            objectpath = objects+"\\CREATE_"+dbobject+".sql"
            readExecute(objectpath,cur,con)
            
            if(objects=='TABLE'):
                insertpath = objects+"\\INSERT_"+dbobject+".sql"
                readExecute(insertpath,cur,con,1)    
                
                sequencepath = objects+"\\SEQUENCE_"+dbobject+".sql"
                readExecute(sequencepath,cur,con)    
                
                triggerpath = objects+"\\TRIGGER_"+dbobject+".sql"
                readExecute(triggerpath,cur,con)    
            
            """"
            #if(objects!='TABLE'):
            print(dbobject)
            objectpath = objects+"\\CREATE_"+dbobject+".sql"
            if (os.path.isfile(objectpath)):
                with open(objectpath) as content:
                    script = content.read()
                    print(script)
            
            if(objects=='TABLE'): 
                insertpath = objects+"\\INSERT_"+dbobject+".sql"
                if (os.path.isfile(insertpath)):    
                    with open(insertpath) as content:
                        for line in content: 
                           line=line.strip()
                           print(line)
                       #cur.execute(line)
                    #con.commit()
                
                sequencepath = objects+"\\SEQUENCE_"+dbobject+".sql"
                if (os.path.isfile(sequencepath)):    
                    with open(sequencepath) as content:
                         data = content.read()
                         print(data)
                     #cur.execute(data)
                
                triggerpath = objects+"\\TRIGGER_"+dbobject+".sql"
                if (os.path.isfile(triggerpath)):    
                    with open(triggerpath) as content:
                         data = content.read()
                         print(data)
                     #cur.execute(data)
            """
            
cur.close()
con.close()                