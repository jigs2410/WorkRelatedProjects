# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 14:28:08 2017

@author: jrathod
"""

import re

line = "Cats are smarter than dogs"
line1 = r'$par 10 INFOS $noconfpc $func $careareaopt'

matchObj = re.match( r'(.*) are (.*?) .*', line, re.M|re.I)

if matchObj:
   print ("matchObj.group() : ", matchObj.group())
   print ("matchObj.group(1) : ", matchObj.group(1))
   print ("matchObj.group(2) : ", matchObj.group(2))
else:
   print ("No match!!")

matchObj = re.match( r'\$(\w*) (\d*) (\w*) .*', line1, re.M|re.I)
if matchObj:
   print ("matchObj.group() : ", matchObj.group())
   print ("matchObj.group(1) : ", matchObj.group(1))
   print ("matchObj.group(2) : ", matchObj.group(2))
else:
   print ("No matchhh!!")

line2="DATETIME Create   DMM_DT   date/heure utilisateur génération données"
matchObj = re.match( r'(\w*) (\w*) .*', line2.strip('\t\n\r'), re.M|re.I)
if matchObj:
       print ("matchObj.group() : ", matchObj.group())
       print ("matchObj.group(1) : ", matchObj.group(1))
       print ("matchObj.group(2) : ", matchObj.group(2))
else:
   print ("No matching!!")


line3=r'   $structname InfosZone'
matchObj = re.match( r'\$(\w*) (\w*).*', line3.strip(' \t\n\r'), re.M|re.I)
if matchObj:
       print ("matchObj.group() : ", matchObj.group())
       print ("matchObj.group(1) : ", matchObj.group(1))
       print ("matchObj.group(2) : ", matchObj.group(2))
       #print ("matchObj.group(3) : ", matchObj.group(3))
       #print ("matchObj.group(4) : ", matchObj.group(4))
else:
   print ("No matching!!!",line3)

line4 = r'Correct si :'

if(r'si :' in line4):
    print("present")

line5=r'BOOL[DILUTION_UNIT]  Dilution TRUE 0 1'
matchObj = re.match( r'(\w*\[\w*\])  (\w*).*', line5.strip(' \t\n\r'), re.M|re.I)
if matchObj:
     print ("matchObj.group() : ", matchObj.group())
     print ("matchObj.group(1) : ", matchObj.group(1))
     print ("matchObj.group(2) : ", matchObj.group(2))
else:
     print ("No matching!!!",line5)

line6=r'BYTE[8] Data4         **   bits 64-127 de l'
matchObj = re.match( r'(\w*\[\w*\]) (\w*).*', line6.strip(' \t\n\r'), re.M|re.I)
if matchObj:
     print ("matchObj.group() : ", matchObj.group())
     print ("matchObj.group(1) : ", matchObj.group(1))
     print ("matchObj.group(2) : ", matchObj.group(2))
else:
     print ("No matching!!!",line6)

line7=r'$bit 3 @MEM_PRESSLIM           TRUE  * mémorisation limite pression'
matchObj = re.match( r'\$bit (\d*) (@\w*).*', line7.strip(' \t\n\r'), re.M|re.I)
if matchObj:
     print ("matchObj.group() : ", matchObj.group())
     print ("matchObj.group(1) : ", matchObj.group(1))
     print ("matchObj.group(2) : ", matchObj.group(2))
     #print ("matchObj.group(3) : ", matchObj.group(3))
     
else:
     print ("No matching!!!",line7)