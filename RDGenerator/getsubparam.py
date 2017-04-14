# -*- coding: utf-8 -*-
"""
Created on Tue Apr 11 10:17:08 2017

@author: jrathod
"""

# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 13:31:35 2017

@author: jrathod
"""
import re
rowCount=0
lines=[]
with open("ParamDrug_VolumatV2_22b.txt") as fo:
   lines = fo.readlines()
fo.close()

subParIdentified=0
parIdentified=0
getFields=0


for line in lines:
   #print(rowCount)
  #print(line)
  
  if("$par" in line):
      parIdentified=1
      matchObj = re.match( r'\$par (\d*) (\w*).*', line, re.I)          #$par (.*) are (.*?) .*', line, re.M|re.I)
      if matchObj:
           #print ("par ID : ", matchObj.group(1))
           #print ("par Name : ", matchObj.group(2))
           #getFields=1
           #print(rowCount,"\tPar",matchObj.group(1),"->",matchObj.group(2))
          print("\tPar",matchObj.group(1),"->",matchObj.group(2))
      #else:
       #print(rowCount," PARRRRRR",line.strip(' \t\n\r'))
  
  if(parIdentified==1 and line[:7] == "$subpar"):
      subParIdentified=1
      matchObj = re.match( r'\$subpar (\d*) (\w*) .*', line, re.I)          #$par (.*) are (.*?) .*', line, re.M|re.I)
      if matchObj:
           #print ("par ID : ", matchObj.group(1))
           #print ("par Name : ", matchObj.group(2))
           #getFields=1
           #print(rowCount,"\tPar",matchObj.group(1),"->",matchObj.group(2))
          print("\t\tSubPar",matchObj.group(1),"->",matchObj.group(2))
          print("\t\t\tParams:")
           #print(rowCount," \t",line.strip(' \t\n\r'))

  if subParIdentified == 1 and len(line.strip(' \t\n\r')) > 0 and line[:7] != "$subpar":
       words = line.strip(' \t\n\r').split(" ")
       #for word in words:
           #print(word)
       if (words[0].isupper() or words[0][:1]=="$") and (words[0]!="$option"):
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
                   matchObj = re.match( r'([A-Za-z0-9\(\)]*) (\w*).*', line.strip(' \t\n\r'), re.M|re.I)
                   if matchObj:
                       #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2),line.strip(' \t\n\r'))
                       #print(rowCount,"\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                       print("\t\t\t",matchObj.group(1),"->",matchObj.group(2))
                   else:
                       print(rowCount," \t\t\t EMPTY",line.strip(' \t\n\r'))
  
  if("Correct" in line and "si" in line):
      #parIdentified=0
      subParIdentified=0
  rowCount+=1