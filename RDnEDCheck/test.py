# -*- coding: utf-8 -*-
"""
Created on Fri Apr 14 11:28:12 2017

@author: jrathod
"""

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

#line2=r'if ED_530 = "High": \
#   Fine = 1 \
#   elif ED_530 = "Low": \
#   Fine = 0'

line2 = "ED_530 is high ED_540 is high"
matchObj = re.search( r'((ED_(\d*))+).*', line2, re.I)
if matchObj:
   print ("matchObj.group() : ", matchObj.group())
   print ("matchObj.group(1) : ", matchObj.group(1))
   print ("matchObj.group(2) : ", matchObj.group(2))

else:
   print ("No matchhh!!",line2)
   
regex = r"[a-zA-Z]+ \d+"
matches = re.findall(regex, "June 24, August 9, Dec 12")
for match in matches:
    # This will print:
    #   June 24
    #   August 9
    #   Dec 12
    print ("Full match: %s" % (match))
    
regex = r"ED_\d+"
matches = re.findall(regex, line2)
for match in matches:
    # This will print:
    #   June 24
    #   August 9
    #   Dec 12
    print ("Full match: %s" % (match))    