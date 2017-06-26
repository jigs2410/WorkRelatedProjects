# -*- coding: utf-8 -*-
"""
Created on Tue Jun 20 13:50:12 2017

@author: jrathod
"""


import cx_Oracle
import csv
import re
con_wwdev = cx_Oracle.connect('mssql/mssql@wel-db-2-srv:1521/wwdev')
cur_wwdev = con_wwdev.cursor()

con_oldwwdev = cx_Oracle.connect('mssql/mssql@db1:1521/wwdev')
cur_oldwwdev = con_oldwwdev.cursor()
cur_oldwwdev1 = con_oldwwdev.cursor()
cur_oldwwdev2 = con_oldwwdev.cursor()

create_table = 'PRICING_EXCEPTIONLIST_TABLE'+".sql"
insert_file = 'PRICING_EXCEPTIONLIST' + ".sql"
trigger = 'PRICING_EXCEPTIONLIST_TRIGGER'+".sql"
sequence = 'PRICING_EXCEPTIONLIST_SEQUENCE'+".sql"

query1 = "select DBMS_METADATA.GET_DDL('TABLE','PRICING_EXCEPTIONLIST') from dual "


query2 = "select * from PRICING_EXCEPTIONLIST order by 1"  

query3 = "select tabs.table_name,trigs.trigger_name,seqs.sequence_name,seqs.last_number \
from user_tables tabs \
join user_triggers trigs on trigs.table_name = tabs.table_name \
join user_dependencies deps on deps.name = trigs.trigger_name \
join user_sequences seqs on seqs.sequence_name = deps.referenced_name \
where tabs.table_name = 'PRICING_EXCEPTIONLIST' order by 1  "

  
def convdblquote(statement):
    semiquotecheck = 0
    returnstatement =""
    #print(statement)
    for c in statement:
        if c == "\"":
            #c = "'''"
            if semiquotecheck == 1:
                semiquotecheck = 0
                returnstatement =returnstatement.replace("\"","'")
                c = "'"
                
            else: 
                semiquotecheck = 1
        
        if semiquotecheck == 1:
            if c == "'":
                c = "''"
        
        returnstatement+=c
        
    if semiquotecheck == 0:
        return returnstatement
    else:
        return statement
    
def convdatetime(statement):
    
    while 'datetime.datetime' in statement:
        regex = r"datetime.datetime\(\d+, \d+, \d+, \d+, \d+, \d+\)"
        matches = re.findall(regex, statement)
        if len(matches) > 0:
            for match in matches:
                replacestr = match
                replacestr = replacestr.replace('datetime.datetime','to_timestamp').replace('(','(\'').replace(',','-').replace(' ','').replace(')','\' ,\'RRRR-MM-DD-HH24-MI-SS\')')
                statement=statement.replace(match,replacestr)
                #print("Full match: %s %s" % (match, replacestr))
        else:
            regex = r"datetime.datetime\(\d+, \d+, \d+, \d+, \d+\)"
            matches = re.findall(regex, statement)
            if len(matches) > 0:
                for match in matches:
                    newmatch = match.replace(')',', 0)')
                    replacestr = newmatch
                    replacestr = replacestr.replace('datetime.datetime','to_timestamp').replace('(','(\'').replace(',','-').replace(' ','').replace(')','\' ,\'RRRR-MM-DD-HH24-MI-SS\')')
                    statement=statement.replace(match,replacestr)       
    
    return statement
    
cur_oldwwdev1.execute(query1)

output = open(create_table,'w')

for script in cur_oldwwdev1:
    #exec("%s_CREATE_TABLE" % ('PRICING_EXCEPTIONLIST'))
    
    exec("%s_CREATE_TABLE = script[0].read()" % ('PRICING_EXCEPTIONLIST')) 
    #print(script[0].read())
    exec("print(%s_CREATE_TABLE)" % ('PRICING_EXCEPTIONLIST'))
    exec("output.write(%s_CREATE_TABLE)" % ('PRICING_EXCEPTIONLIST'))
output.write("\n")   
output.close()

output = open(insert_file,'w') # 'wb'
#output = csv.writer(outputFile, delimiter='~', dialect='excel')        
cur_oldwwdev1.execute(query2)


tempquery = "insert into PRICING_EXCEPTIONLIST ("


cols=[]
for col in cur_oldwwdev1.description:
    #cols.append(col[0])
    tempquery+=str(col[0])+"," 
tempquery = tempquery[:-1]
tempquery+=") values " 

#output.writerow(cols)
insertquery=""
for row_data in cur_oldwwdev1: # add table rows
    if len(row_data) > 0:
        insertquery = ("%s %s" %(tempquery,row_data))
        insertquery=insertquery.replace('[','').replace(']','').replace('None','NULL').replace('\\t','') 
        if "\"'" in insertquery:
            insertquery = convdblquote(insertquery)
        if "\"" in insertquery:
            insertquery = convdblquote(insertquery)
            
        if "datetime.datetime" in insertquery:
            insertquery = convdatetime(insertquery)
        output.write(insertquery)
        output.write("\n")
output.close()
"""        
        semiquotecheck = 0
        finalquery =""
        if '"' in insertquery:
            for c in insertquery:
                if c == "\"":
                    #c = "'''"
                    if semiquotecheck == 1:
                        semiquotecheck = 0
                    else: 
                        semiquotecheck = 1
                if semiquotecheck == 1:
                    if c == "'":
                        c = "''"
                finalquery+=c
                finalquery =finalquery.replace("\"","'")
            #output.write(insertquery)
            #output.write("\n")
            output.write(finalquery)
        else:
             output.write(insertquery)
"""            

        
#for row in cur_oldwwdev1:
"""    
query4 = "insert into PRICING_EXCEPTIONLIST (";

for col in cols:
    query4 = query4 +col+"," 
query4+=") values ("    
insertquery = ""
with open('PRICING_EXCEPTIONLIST.csv', 'rt') as csvfile:
     spamreader = csv.reader(csvfile, delimiter='~')
     for row in spamreader:
         if len(row) > 0:
             
             insertquery = ("%s %s" %(query4,row))
         #print(', '.join(row))
             insertquery+=")"  
             insertquery=insertquery.replace('[','').replace(']','') +';'         
             print(insertquery)

"""     
""""
     for values in spamreader:
         insertquery = ("%s " %query4 )
         for value in values:
             insertquery +=value+","
             #insertquery = ("%s %s" %(query4,value))
         insertquery+=")"    
         #print(', '.join(row))
         #insertquery+=")"         
         print(insertquery)
        
print(query3)    
cur_oldwwdev1.execute(query3)
for row in cur_oldwwdev1:
    for value in row:   
        print(value)
         
"""

print(query3)
alttrig = "ALTER TRIGGER \"MSSQL\".\"PRICING_EXCEPTIONLIST_TRG\" ENABLE"    
cur_oldwwdev1.execute(query3)
for row in cur_oldwwdev1:
    if (len(row)>0):
        query ="select DBMS_METADATA.GET_DDL('TRIGGER','"+row[1]+"') from dual" 
        cur_oldwwdev2.execute(query)
        output = open(trigger,'w') # 'wb'        
        for script in cur_oldwwdev2:
            NEW_PRICINTTYPE_TRIGGER = script[0].read()
            PRICING_EXCEPTIONLIST_TRIGGER=str(NEW_PRICINTTYPE_TRIGGER)
            print(alttrig)
            PRICING_EXCEPTIONLIST_TRIGGER=PRICING_EXCEPTIONLIST_TRIGGER.replace(alttrig,'')
            #exec("%s_TRIGGER = script[0].read()+' ;'" % ('PRICING_EXCEPTIONLIST')) 
            #print(script[0].read())
            
            #exec("%s_TRIGGER = %s_TRIGGER.replace('ALTER TRIGGER',"// \n ALTER TRIGGER')" %('PRICING_EXCEPTIONLIST','PRICING_EXCEPTIONLIST'))
            #exec("print(%s_TRIGGER)" % ('PRICING_EXCEPTIONLIST'))
            
            PRICING_EXCEPTIONLIST_TRIGGER=PRICING_EXCEPTIONLIST_TRIGGER.replace('ALTER TRIGGER','/\n ALTER TRIGGER')
            exec("output.write(%s_TRIGGER)" % ('PRICING_EXCEPTIONLIST'))
        output.write("\n")   
        output.close()
        
        query ="select DBMS_METADATA.GET_DDL('SEQUENCE','"+row[2]+"') from dual " 
        cur_oldwwdev2.execute(query)
        output = open(sequence,'w') # 'wb'        
        for script in cur_oldwwdev2:
            exec("%s_SEQ = script[0].read()" % ('PRICING_EXCEPTIONLIST')) 
            #print(script[0].read())
            #exec("print(%s_SEQ)" % ('PRICING_EXCEPTIONLIST'))
            exec("output.write(%s_SEQ)" % ('PRICING_EXCEPTIONLIST'))
        output.write("\n")   
        output.close()
        
        
    for value in row:   
        print(value)
        
        
cur_wwdev.close()
cur_oldwwdev.close()
cur_oldwwdev1.close()
cur_oldwwdev2.close()
con_wwdev.close()
con_oldwwdev.close()        