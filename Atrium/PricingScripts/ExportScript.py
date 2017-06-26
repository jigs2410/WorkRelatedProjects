# -*- coding: utf-8 -*-
"""
Created on Wed Jun 21 22:43:59 2017

@author: jrathod
"""
import os
import re

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

def exportlist(do,objectlist):
    path = ""+do+"\\"+do+".txt"
    output= open(path,'w')
    for item in objectlist:
        output.write(item)
        output.write("\n")
    output.close()
    
    
def export(do,dbobject,cur):
    if not os.path.exists(do):
        os.makedirs(do)
    
    create = "CREATE_"+dbobject+".sql"
    
    
        
    query = "select DBMS_METADATA.GET_DDL('"+do+"','"+dbobject+"') from dual "
    path = ""+do+"\\"+create
    output = open(path,'w')
    
    cur.execute(query)
    for script in cur:
       output.write(script[0].read())
    output.close()
    
    if do == "TABLE":
        insert = "INSERT_"+dbobject+".sql"
        trigger = "TRIGGER_"+dbobject+".sql"
        sequence = "SEQUENCE_"+dbobject+".sql"
        ###insert####
        query = "select * from "+dbobject+" order by 1"
        path = ""+do+"\\"+insert
        output = open(path,'w')
        cur.execute(query)
        
        tempquery="insert into "+dbobject+" ("
        for col in cur.description:
            tempquery+=str(col[0])+"," 
        
        tempquery = tempquery[:-1]
        tempquery+=") values " 

        insertquery=""
        for row_data in cur: # add table rows
            if len(row_data) > 0:
                insertquery = ("%s %s" %(tempquery,row_data))
                insertquery=insertquery.replace('[','').replace(']','').replace('None','NULL').replace('\\t','') 
                # semiquote has to replaced by '''
                if "\"'" in insertquery:
                    insertquery = convdblquote(insertquery)
                if "\"" in insertquery:
                    insertquery = convdblquote(insertquery)
                if "datetime.datetime" in insertquery:
                    insertquery = convdatetime(insertquery)
                output.write(insertquery)
                output.write("\n")
        output.close()
       
        ####trigger n sequence ######
        
        query = "select tabs.table_name,trigs.trigger_name,seqs.sequence_name,seqs.last_number \
                    from user_tables tabs \
                    join user_triggers trigs on trigs.table_name = tabs.table_name \
                    join user_dependencies deps on deps.name = trigs.trigger_name \
                    join user_sequences seqs on seqs.sequence_name = deps.referenced_name \
                    where tabs.table_name = '"+dbobject+"' order by 1  "
                    
                    
            
        cur.execute(query)
        for row in cur:
            if (len(row)>0):
                ### trigger without alter trigger statement #####
                query1 ="select DBMS_METADATA.GET_DDL('TRIGGER','"+row[1]+"') from dual" 
                alttrig = "ALTER TRIGGER \"MSSQL\".\""+row[1]+"\" ENABLE"
                path = ""+do+"\\"+trigger
                cur.execute(query1)
                output = open(path,'w') # 'wb'        
                for script in cur:
                    trig_text = script[0].read()
                    trig_text=trig_text.replace(alttrig,'')
                    output.write(trig_text)
                    
                output.write("\n")   
                output.close()
                
                ##### sequence ########
                query1 ="select DBMS_METADATA.GET_DDL('SEQUENCE','"+row[2]+"') from dual " 
                path = ""+do+"\\"+sequence
                cur.execute(query1)
                output = open(path,'w') # 'wb'        
                for script in cur:
                    seq_text =  script[0].read()
                    output.write(seq_text)
                    
                output.write("\n")   
                output.close()
        
        
       
    
    