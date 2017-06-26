# -*- coding: utf-8 -*-
"""
Created on Wed Jun 21 14:13:33 2017

@author: jrathod
"""

import cx_Oracle
import csv

con_wwdev = cx_Oracle.connect('mssql/mssql@wel-db-2-srv:1521/wwdev')
cur_wwdev = con_wwdev.cursor()

create_table = 'NEW_PRICINGTYPE_TABLE.sql'
insert_file = 'NEW_PRICINGTYPE.sql'
trigger = 'NEW_PRICINGTYPE_TRIGGER.sql'
sequence = 'NEW_PRICINGTYPE_SEQUENCE.sql'

data=""
with open(create_table) as file:  
    data = file.read() 
cur_wwdev.execute(data)

with open(insert_file) as file:  
   for line in file: 
       line=line.strip()
       print(line)
       cur_wwdev.execute(line)
   con_wwdev.commit()
    
with open(sequence) as file:  
    data = file.read() 
cur_wwdev.execute(data)

with open(trigger) as file:  
    data = file.read() 
cur_wwdev.execute(data) 
#enabletrigger = "ALTER TRIGGER \"MSSQL\".\"NEW_PRICINGTYPE_TRG\" ENABLE"
#cur_wwdev.execute(enabletrigger) 

   


cur_wwdev.close()
con_wwdev.close()
