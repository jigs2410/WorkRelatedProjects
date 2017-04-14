# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 13:31:35 2017

@author: jrathod
"""
import re
rowCount=0
lines=[]
with open("Param_VolumatV2_22b.txt") as fo:
   lines = fo.readlines()
fo.close()

zoneIdentified=0
parIdentified=0
getFields=0


for line in lines:
   #print(rowCount)
   matchObj=""
   if ("/* Zone" in line or  "/* Notes" in line):
       zoneIdentified=0
       parIdentified=0
       getFields=0
       #print(rowCount,line.strip(' \t\n\r'))
   
   if ("$zone" in line):
       #print(rowCount,"Zone",line.strip(' \t\n\r'))
       matchObj = re.match( r'\$zone (\d*) (\w*) .*', line.strip(' \t\n\r'), re.I)
       #print(rowCount,"Zone",matchObj.group(1),"->",matchObj.group(2))
       print("Zone",matchObj.group(1),"->",matchObj.group(2))
       getFields=0
       parIdentified=0
       zoneIdentified=1
   
   if (zoneIdentified == 1):
       if("$par" in line and "$carearea" in line):
           parIdentified=1
           matchObj = re.match( r'\$par (\d*) (\w*) .*', line, re.I)          #$par (.*) are (.*?) .*', line, re.M|re.I)
           if matchObj:
               #print ("par ID : ", matchObj.group(1))
               #print ("par Name : ", matchObj.group(2))
               getFields=1
               #print(rowCount,"\tPar",matchObj.group(1),"->",matchObj.group(2))
               print("\tPar",matchObj.group(1),"->",matchObj.group(2))
               print("\t\tParams:")
   
   if(parIdentified==1 and getFields==1):
       #print(rowCount,line)
       if ("Note :" in line):
           parIdentified = 0
           getFields=0
       else: ##extract fields
           if len(line.strip(' \t\n\r')) > 0 and not ("$par" in line):
               words = line.strip(' \t\n\r').split(" ")
               #for word in words:
                   #print(word)
               if (words[0].isupper() or words[0][:1]=="$") and (words[0]!="$value"):
                   if (words[0] == "$bit"):
                       #print(rowCount,"\t\t\t\tFlags",line.strip(' \t\n\r'))
                       matchObj = re.match(r'\$bit (\d*) (@\w*).*', line.strip(' \t\n\r'),re.I)
                       if matchObj:
                           #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2),line.strip(' \t\n\r'))
                           #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                           print("\t\t\t\tFlags Bit",matchObj.group(1),"->",matchObj.group(2))
                       #print("\t\t\t\tFlags",line.strip(' \t\n\r'))
                   else:
                       
                       matchObj = re.match(r'(\w*) (\w*) .*', line.strip(' \t\n\r'),re.I)
                       if matchObj:
                           #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2),line.strip(' \t\n\r'))
                           #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                           print("\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                       else:
                           #print("line is->%s"%line)
                           #$struct case
                           matchObj = re.match( r'\$(\w*) (\w*).*', line.strip(' \t\n\r'), re.M|re.I)
                           if matchObj:
                               #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2),line.strip(' \t\n\r'))
                               #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                               print("\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                           else:
                               #paramater with round brackets
                               matchObj = re.match( r'([A-Za-z0-9\(\)]*) (\w*).*', line.strip(' \t\n\r'), re.M|re.I)
                               if matchObj:
                                   #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2),line.strip(' \t\n\r'))
                                   #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                                   print("\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                               else:#paramater with square brackets with unit
                                    matchObj = re.match( r'(\w*\[\w*\])  (\w*).*', line.strip(' \t\n\r'), re.M|re.I)
                                    if matchObj:
                                   #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2),line.strip(' \t\n\r'))
                                       #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                                       print("\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                                    else:#paramater with square brackets with integer
                                         matchObj = re.match( r'(\w*\[\w*\]) (\w*).*', line.strip(' \t\n\r'), re.M|re.I)
                                         if matchObj:
                                   #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2),line.strip(' \t\n\r'))
                                           #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                                           print("\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                                         #else:
                                         #    print(rowCount,"\t\t\tEmpty ->>%s"%line.strip(' \t\n\r'))
              
   rowCount+=1