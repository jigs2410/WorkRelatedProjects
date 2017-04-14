from openpyxl import load_workbook

wb = load_workbook(filename = 'NewRDData.xlsx')

Sheet1 = wb['Sheet2']
i = 0
ZONE = ZONE_NAME = PAR = PAR_NAME = SUBPAR = SUBPAR_NAME = VALUE = TYPE = BIT = BIT_NAME = ""
Device_Types = ""

print("<ZONES>")
for row in Sheet1.rows:
    #print (row.value)
    #print(end="\n")
    i += 1
    #print(i," ",end=" ")
    #print (row[0].value)

    if i != 1:
        if len(str(row[0].value)) > 0 and str(row[0].value).find("None") < 0 and \
            len(str(row[1].value)) > 0 and str(row[1].value).find("None") < 0:
            if ZONE != "" and ZONE != str(row[0].value):
                print(' </ZONE{0}>'.format(ZONE))
            ZONE = str(row[0].value) 
            ZONE_NAME = str(row[1].value)
            #ZONE = ZONE.strip(' \t\n\r')
            #print(".", ZONE, ".", end="")
            print(' <ZONE{0} name="{1}">'.format(ZONE, ZONE_NAME))
            #print(" name=", ZONE_NAME.strip(), ">")
        if len(str(row[2].value)) > 0 and str(row[2].value).find("None") < 0 and \
            len(str(row[3].value)) > 0 and str(row[3].value).find("None") < 0:
            if PAR != "" and PAR != str(row[2].value):
                print('     </PAR{0}>'.format(PAR))
            PAR = row[2].value
            PAR_NAME = row[3].value
            print('     <PAR{0} name="{1}">'.format(PAR, PAR_NAME))
        if len(str(row[4].value)) > 0 and str(row[4].value).find("None") < 0 and \
        len(str(row[5].value)) > 0 and str(row[5].value).find("None") < 0:
            SUBPAR = row[4].value
        #if len(str(row[5].value)) > 0 and str(row[5].value).find("None") < 0:
            SUBPAR_NAME = row[5].value
            print('        <SUBPAR{0} name="{1}">'.format(SUBPAR, SUBPAR_NAME))

        if len(str(row[6].value)) > 0 and str(row[6].value).find("None") < 0 and \
         len(str(row[7].value)) > 0 and str(row[7].value).find("None") < 0:
            VALUE = row[6].value
            TYPE = row[7].value
            print('         <{0} type="{1}">'.format(VALUE, TYPE))


        #if len(str(row[8].value)) > 0 and str(row[8].value).find("None") < 0:
        if str(row[8].value).find("None") >= 0:
            BIT = ""
        else:
            BIT = row[8].value
        #if len(str(row[9].value)) > 0 and str(row[9].value).find("None") <0:
        if str(row[9].value).find("None") >= 0:
            BIT_NAME = ""
        else:
            BIT_NAME = row[9].value

        if len(str(row[10].value)) > 0 and str(row[10].value).find("None") < 0:
            Device_Types = row[10].value


        #print (ZONE,"\t",ZONE_NAME,"\t",PAR,"\t",PAR_NAME,"\t",SUBPAR,"\t",SUBPAR_NAME,"\t",VALUE,
        # "\t",TYPE,"\t",BIT,"\t",BIT_NAME,"\t",Device_Types)

        #print (i,",",ZONE,",",ZONE_NAME,",",PAR,",",PAR_NAME,",",SUBPAR,",",SUBPAR_NAME,",",VALUE,
        # ",",TYPE,",",BIT,",",BIT_NAME,",",Device_Types)

print("</ZONES>")
    #for cell in row:
        #print(cell.value,end=" ")

