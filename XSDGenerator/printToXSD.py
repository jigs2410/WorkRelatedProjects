# -*- coding: utf-8 -*-
"""
Created on Fri Mar 24 13:21:32 2017

@author: jrathod
"""
import collections
from collections import OrderedDict


def printdevicesOrder(Zones, DeviceName):
    
    #Zones = collections.OrderedDict(sorted(Zones.items()))
    print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>")
    print("<xs:schema elementFormDefault=\"qualified\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\">")

    #print("<xs:element name=\"Zones\">")
    openelement('Zones')
    if (len(Zones)>0):
        com_seq()
        #print ("Zones ->",Zones.items())
        for zonekey, zonevalue in Zones.items():
            
            #print ("Zone ->",zonekey)
            #print ("Zonevalue ->",zonevalue)
            #if (len(Zone))
            openelement("Zone%s" % (zonevalue['ID']))
            if len(zonevalue) > 0:
                com_seq()
                Pars = zonevalue['Pars']
                for parskey, parsvalue in Pars.items():
                    #print (parsvalue['ID'])
                    #print (parsvalue['Name'])
                    openelement("Par%s" % (parsvalue['ID']))
                    com_seq()
                   #parsvalue['SubPars']
                    if 'SubPars' in parsvalue:
                        #print(parsvalue['SubPars'])
                        SubPars =  parsvalue['SubPars']
                        for subparkey, subparvalue in SubPars.items():
                            openelement("SubPar%s" % (subparvalue['ID']))
                            com_seq()
                            if 'Params' in subparvalue:
                                Params =  subparvalue['Params']
                                for paramkey, paramvalue in Params.items():
                                    openelement(paramvalue['Name'])
                                    if not 'Flags' in paramvalue:
                                        com_simple_ext(paramvalue['Type'],paramvalue['RD_ID'])
                                    else:
                                        com_seq()
                                        Flags = paramvalue['Flags']
                                        #print("Flag")
                                        for flagkey , flagvalue in Flags.items():
                                            #print(flagkey,"->",flagvalue )
                                            #print("BitID->",flagvalue['BitID'] )
                                            #print("BitName->",flagvalue['BitName'] )
                                            openelement("BIT%s" % (flagvalue['BitID']))
                                            com_simple_ext_bit(flagvalue['BitName'],flagvalue['BitID'],paramvalue['RD_ID'])
                                        close_seq_attr_com_param(paramvalue['Type'],paramvalue['RD_ID'])
                                    
                            close_seq_attr_com(subparvalue['Name'],subparvalue['ID'])
                    
                    else:
                        if 'Params' in parsvalue:
                            Params =  parsvalue['Params']
                            for paramkey, paramvalue in Params.items():
                                openelement(paramvalue['Name'])
                                if not 'Flags' in paramvalue:
                                    com_simple_ext(paramvalue['Type'],paramvalue['RD_ID'])
                                else:
                                    com_seq()
                                    Flags = paramvalue['Flags']
                                    #print("Flag")
                                    for flagkey , flagvalue in Flags.items():
                                        #print(flagkey,"->",flagvalue )
                                        #print("BitID->",flagvalue['BitID'] )
                                        #print("BitName->",flagvalue['BitName'] )
                                        openelement("BIT%s" % (flagvalue['BitID']))
                                        com_simple_ext_bit(flagvalue['BitName'],flagvalue['BitID'],paramvalue['RD_ID'])
                                    close_seq_attr_com_param(paramvalue['Type'],paramvalue['RD_ID'])
                                
                    #    print(parsvalue['params '])
                    #if 'Params' in parsvalue:
                        #print(parsvalue['Params'])
                    close_seq_attr_com(parsvalue['Name'],parsvalue['ID'])
                #close_com_seq()
                #print (zonevalue['ID'])
                #print (zonevalue['Name'])
                
            #for zonevaluekey, zonevaluevalue in zonevalue.items():
                #print("zonevaluekey ->",zonevaluekey)
                #print (zonevalue['ID'])
                #print (zonevalue['Name'])
        #print (zonevalue['Pars'])
        
                close_seq_attr_com(zonevalue['Name'],zonevalue['ID'])
        close_seq_attr_com_zones() #closingzonechilds
        #closeelement() #closing zone
    addTypes()    
    print("</xs:schema>")
    
    '''
    for zonekey, zonevalue in Zones.items():
        print ("Zone ->",zonekey)
        
        #for zonevaluekey, zonevaluevalue in zonevalue.items():
            #print(zonevaluevalue)
        print (zonevalue['ID'])
        print (zonevalue['Name'])
        print (zonevalue['Pars'])
        Pars = zonevalue['Pars']
        for parskey, parsvalue in Pars.items():
            print (parsvalue['ID'])
            print (parsvalue['Name'])
            if ('Params' in parsvalue):
                Params = parsvalue['Params']
                
            else:
                if ('SubPars' in parsvalue):
                    SubPars = parsvalue['Params']
            
        #print (Pars['Name'])
    '''


def openelement(element):
    print("<xs:element name=\"%s\">" % (element))

def closeelement():
    print("</xs:element>")
    
def com_seq():
    print("<xs:complexType>")
    print("<xs:sequence>")

def com_simple_ext(base,rd_id):
    print("<xs:complexType>")
    print("<xs:simpleContent>")
    type = ""
    
    if "STRING(" in base:
        #print("1 Type is %s and base is %s  " %(type,base))
        type = base.replace('(',"_").replace(')',"")
    #elif "BOOL[]" in base:
        #print("2 Type is %s and base is %s  " %(type,base))
        #type = base.replace('[]',"_ARR")
    elif "BOOL[" in base:
        #print("2 Type is %s and base is %s  " %(type,base))
        type = base.replace('[',"_ARR_").replace(']',"")        
    elif "BYTE[" in base:
        #print("2 Type is %s and base is %s  " %(type,base))
        type = base.replace('[',"_ARR_").replace(']',"")        
    else:
        type=base        
    #print("3 Type is %s and base is %s  " %(type,base))
    print("<xs:extension base = \"%s\">" % type.upper())
    print("<xs:attribute name=\"RD_ID\" fixed=\"%s\" type=\"xs:string\" use=\"required\" />" % rd_id)
    print("<xs:attribute name=\"Type\" fixed=\"%s\" type=\"xs:string\" use=\"required\" />" % base.upper())
    print("</xs:extension>")
    print("</xs:simpleContent>")
    print("</xs:complexType>")
    print("</xs:element>")

def com_simple_ext_bit(name,id,rd_id):
    print("<xs:complexType>")
    print("<xs:simpleContent>")
    print("<xs:extension base = \"BIT\">" )
    print("<xs:attribute name=\"NAME\" fixed=\"%s\" type=\"xs:string\" use=\"required\" />"% name) 
    print("<xs:attribute name=\"ID\" fixed=\"%s\" type=\"xs:int\" use=\"required\" />"%id)
    #print("<xs:attribute name=\"RD_ID\" fixed=\"%s\" type=\"xs:string\" use=\"required\" />" % rd_id)
    print("<xs:attribute name=\"Type\" fixed=\"BIT\" type=\"xs:string\" use=\"required\" />")
    print("</xs:extension>")
    print("</xs:simpleContent>")
    print("</xs:complexType>")
    print("</xs:element>")

    
def close_seq_attr_com_zones():
    print("</xs:sequence>")  
    print("<xs:attribute name=\"CommandId\" fixed=\"25\" type=\"xs:string\" use=\"required\" />")
    print("</xs:complexType>")
    print("</xs:element>")
    
def close_seq_attr_com(Name="",Id=""):
    print("</xs:sequence>")  
    print("<xs:attribute name=\"Name\" fixed=\"%s\" type=\"xs:string\" use=\"required\" />" % (Name))
    print("<xs:attribute name=\"ID\" fixed=\"%s\" type=\"xs:int\" use=\"required\" />" % (Id))
    print("</xs:complexType>")
    print("</xs:element>")
    
def close_seq_attr_com_param(base,rd_id):
    print("</xs:sequence>")  
    print("<xs:attribute name=\"RD_ID\" fixed=\"%s\" type=\"xs:string\" use=\"required\" />" % rd_id)
    print("<xs:attribute name=\"Type\" fixed=\"%s\" type=\"xs:string\" use=\"required\" />" % base.upper())
    print("</xs:complexType>")
    print("</xs:element>")
    
    
def close_com_seq():
    print("</xs:sequence>") 
    print("</xs:complexType>")
       

def addTypes():
    print("<xs:simpleType name=\"UNIT\"> \
		<xs:restriction base=\"xs:string\"> \
			<xs:enumeration value=\"ml\" /> \
			<xs:enumeration value=\"ml/h\" /> \
			<xs:enumeration value=\"ml/min\" /> \
			<xs:enumeration value=\"ml/min\" /> \
			<xs:enumeration value=\"ml/m2\" /> \
			<xs:enumeration value=\"ml/kg\" /> \
			<xs:enumeration value=\"xg\" /> \
			<xs:enumeration value=\"kg\" /> \
			<xs:enumeration value=\"xg/m2\" /> \
			<xs:enumeration value=\"xg/kg\" /> \
			<xs:enumeration value=\"mg\" /> \
			<xs:enumeration value=\"mg/m2\" /> \
			<xs:enumeration value=\"mg/kg\" /> \
		</xs:restriction> \
	</xs:simpleType> \
	<xs:simpleType name=\"restrictedFloat\"> \
		<xs:restriction base=\"xs:float\"> \
			<xs:minInclusive value=\"0.0\" /> \
		</xs:restriction> \
	</xs:simpleType> \
	<xs:simpleType name=\"FLOAT_ARR\"> \
		<xs:list itemType=\"restrictedFloat\" /> \
	</xs:simpleType> \
	<xs:simpleType name=\"FLOAT_ARR_2\"> \
		<xs:restriction base=\"FLOAT_ARR\"> \
			<xs:length value=\"2\" /> \
		</xs:restriction> \
	</xs:simpleType> \
	<xs:simpleType name=\"FLOAT_ARR_6\"> \
		<xs:restriction base=\"FLOAT_ARR\"> \
			<xs:length value=\"6\" /> \
		</xs:restriction> \
	</xs:simpleType> \
	<xs:simpleType name=\"BIT\"> \
		<xs:restriction base=\"xs:string\"> \
			<xs:pattern value=\"0|1\" /> \
		</xs:restriction> \
	</xs:simpleType> \
	<xs:simpleType name=\"BOOL\"> \
		<xs:restriction base=\"xs:string\"> \
			<xs:pattern value=\"0|1\" /> \
		</xs:restriction> \
	</xs:simpleType> \
   <xs:simpleType name=\"BOOLOnlyOne\"> \
		<xs:restriction base=\"xs:string\"> \
			<xs:pattern value=\"1\" /> \
		</xs:restriction> \
	</xs:simpleType> \
    <xs:simpleType name=\"BOOL_ARR\"> \
		<xs:list itemType=\"BOOLOnlyOne\" /> \
	</xs:simpleType> \
    <xs:simpleType name=\"BOOL_ARR_10\"> \
		<xs:restriction base=\"BOOL_ARR\"> \
			<xs:length value=\"10\" /> \
		</xs:restriction>  \
	</xs:simpleType> \
	<xs:simpleType name=\"BOOL_ARR_36\"> \
		<xs:restriction base=\"BOOL_ARR\"> \
			<xs:length value=\"36\" /> \
		</xs:restriction>  \
	</xs:simpleType> \
    <xs:simpleType name=\"BYTE\"> \
		<xs:restriction base=\"xs:short\"> \
			<xs:minInclusive value=\"0\" /> \
			<xs:maxInclusive value=\"255\" /> \
		</xs:restriction> \
	</xs:simpleType> \
	<xs:simpleType name=\"BYTE_ARR\"> \
		<xs:list itemType=\"BYTE\" /> \
	</xs:simpleType> \
   <xs:simpleType name=\"BYTE_ARR_8\"> \
		<xs:restriction base=\"BYTE_ARR\"> \
			<xs:length value=\"8\" /> \
		</xs:restriction>  \
	</xs:simpleType>  \
   <xs:simpleType name=\"WORD\">  \
		<xs:restriction base=\"xs:unsignedShort\">  \
			<xs:minInclusive value=\"0\" />  \
			<xs:maxInclusive value=\"65535\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
	<xs:simpleType name=\"DWORD\">  \
		<xs:restriction base=\"xs:unsignedInt\">  \
			<xs:minInclusive value=\"0\" />  \
			<xs:maxInclusive value=\"4294967295\" />  \
		</xs:restriction> \
	</xs:simpleType>  \
	<xs:simpleType name=\"DATETIME\">  \
		<xs:restriction base=\"xs:unsignedInt\">  \
			<xs:minInclusive value=\"0\" />  \
			<xs:maxInclusive value=\"4294967295\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
	<!--xs:simpleType name=\"BYTE\" >  \
<xs:restriction base=\"xs:string\">  \
<xs:pattern value=\"[0-1][0-1][0-1][0-1][0-1][0-1][0-1][0-1]\"/>  \
</xs:restriction>  \
</xs:simpleType-->  \
	<xs:simpleType name=\"STRING_150\">  \
		<xs:restriction base=\"xs:string\">  \
			<xs:maxLength value=\"150\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
   <xs:simpleType name=\"STRING_25\">  \
		<xs:restriction base=\"xs:string\">  \
			<xs:maxLength value=\"25\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
    <xs:simpleType name=\"VSTRING_25\">  \
		<xs:restriction base=\"xs:string\">  \
			<xs:maxLength value=\"25\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
	<xs:simpleType name=\"STRING_20\">  \
		<xs:restriction base=\"xs:string\">  \
			<xs:maxLength value=\"20\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
   <xs:simpleType name=\"STRING_12\">  \
		<xs:restriction base=\"xs:string\">  \
			<xs:maxLength value=\"12\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
	<xs:simpleType name=\"STRING_8\">  \
		<xs:restriction base=\"xs:string\">  \
			<xs:maxLength value=\"8\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
   <xs:simpleType name=\"STRING_4\">  \
		<xs:restriction base=\"xs:string\">  \
			<xs:maxLength value=\"4\" />  \
		</xs:restriction>  \
	</xs:simpleType>  \
    <xs:simpleType name=\"STRUCT\">  \
		<xs:restriction base=\"xs:string\" />  \
	</xs:simpleType>  \
	<xs:simpleType name=\"USESTRUCT\">  \
		<xs:restriction base=\"xs:string\" />  \
	</xs:simpleType>  \
	<xs:simpleType name=\"STRUCTNAME\">  \
		<xs:restriction base=\"xs:string\" />  \
	</xs:simpleType>")

Zones=OrderedDict()

#Zones = OrderedDict([(8, OrderedDict([('ID', 8), ('Name', 'GLOBAL'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict([('Version', OrderedDict([('Name', 'Version'), ('Type', 'STRING(8)'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Create', OrderedDict([('Name', 'Create'), ('Type', 'DATETIME'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ManChg', OrderedDict([('Name', 'ManChg'), ('Type', 'DATETIME'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (2, OrderedDict([('ID', 2), ('Name', 'ACCURACY'), ('Params', OrderedDict([('Fine', OrderedDict([('Name', 'Fine'), ('Type', 'BOOL'), ('Required', 'No'), ('RD_ID', 'RD_0013')]))]))]))]))])), (22, OrderedDict([('ID', 22), ('Name', 'USER'), ('Pars', OrderedDict([(9, OrderedDict([('ID', 9), ('Name', 'MEM_PROGRAM_MODE'), ('Params', OrderedDict([('ProgramMode', OrderedDict([('Name', 'ProgramMode'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (10, OrderedDict([('ID', 10), ('Name', 'MEM_SEL'), ('Params', OrderedDict([('Mem', OrderedDict([('Name', 'Mem'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0546'), ('Flags', OrderedDict([(2, OrderedDict([('BitID', 2), ('BitName', '@MEM_PRESSLIM')])), (3, OrderedDict([('BitID', 3), ('BitName', '@MEM_VOLINFUS')])), (5, OrderedDict([('BitID', 5), ('BitName', '@MEM_SAMEINFUSION')])), (6, OrderedDict([('BitID', 6), ('BitName', '@MEM_DPSAUTO')])), (7, OrderedDict([('BitID', 7), ('BitName', '@MEM_AUTORESTARTOCCLUS')]))]))])), ('DurSameInfusion', OrderedDict([('Name', 'DurSameInfusion'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0547')])), ('PressLim', OrderedDict([('Name', 'PressLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0548')])), ('DpsAuto', OrderedDict([('Name', 'DpsAuto'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0549')])), ('AutoRestartOcclus', OrderedDict([('Name', 'AutoRestartOcclus'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (12, OrderedDict([('ID', 12), ('Name', 'MAX_FLOWRATE'), ('Params', OrderedDict([('MaxFlowPrim', OrderedDict([('Name', 'MaxFlowPrim'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0001')]))]))])), (13, OrderedDict([('ID', 13), ('Name', 'MODE_FAST_START'), ('Params', OrderedDict([('Valid', OrderedDict([('Name', 'Valid'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@FS_FASTSTART')])), (1, OrderedDict([('BitID', 1), ('BitName', '@FS_PURGMANDATORY')])), (2, OrderedDict([('BitID', 2), ('BitName', '@FS_PURGADVICE')]))]))]))]))])), (14, OrderedDict([('ID', 14), ('Name', 'DPS'), ('Params', OrderedDict([('ParamDps', OrderedDict([('Name', 'ParamDps'), ('Type', 'struct'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ThresholdIncr', OrderedDict([('Name', 'ThresholdIncr'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0550')])), ('ThresholdDrop', OrderedDict([('Name', 'ThresholdDrop'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0551')]))]))])), (16, OrderedDict([('ID', 16), ('Name', 'END_INFUS'), ('Params', OrderedDict([('KvoFlowRate', OrderedDict([('Name', 'KvoFlowRate'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0559')])), ('DurPreAl', OrderedDict([('Name', 'DurPreAl'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0555')])), ('VolPreAl', OrderedDict([('Name', 'VolPreAl'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0560')])), ('PercentPreAl', OrderedDict([('Name', 'PercentPreAl'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0561')])), ('InhPreAlDrop', OrderedDict([('Name', 'InhPreAlDrop'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0562')])), ('DurSilAlKvo', OrderedDict([('Name', 'DurSilAlKvo'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0556')]))]))])), (18, OrderedDict([('ID', 18), ('Name', 'OPT_SCREEN1'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@OPTS_INFUSMODE')])), (3, OrderedDict([('BitID', 3), ('BitName', '@OPTF_SAMETHERAPY')])), (8, OrderedDict([('BitID', 8), ('BitName', '@OPTF_PRESSURE')])), (9, OrderedDict([('BitID', 9), ('BitName', '@OPTF_BATTERY')])), (10, OrderedDict([('BitID', 10), ('BitName', '@OPTF_VIGILANT')]))]))])), ('MnuScreen', OrderedDict([('Name', 'MnuScreen'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(2, OrderedDict([('BitID', 2), ('BitName', '@OPTS_SOUNDLEVEL')])), (3, OrderedDict([('BitID', 3), ('BitName', '@OPTS_HISTORIC')])), (4, OrderedDict([('BitID', 4), ('BitName', '@OPTS_LIBDRUG')])), (6, OrderedDict([('BitID', 6), ('BitName', '@OPTS_BOLUSPROG')])), (7, OrderedDict([('BitID', 7), ('BitName', '@OPTS_PATIENT')])), (9, OrderedDict([('BitID', 9), ('BitName', '@OPTS_SECONDARY')])), (10, OrderedDict([('BitID', 10), ('BitName', '@OPTS_GRAPH_FLOW')])), (11, OrderedDict([('BitID', 11), ('BitName', '@OPTS_GRAPH_PRESS')])), (12, OrderedDict([('BitID', 12), ('BitName', '@OPTS_TIMEWARNING')])), (13, OrderedDict([('BitID', 13), ('BitName', '@OPTS_CHANGEDRUG')])), (14, OrderedDict([('BitID', 14), ('BitName', '@OPTS_INFOCASET')])), (15, OrderedDict([('BitID', 15), ('BitName', '@OPTS_INFOCAREAREA')])), (17, OrderedDict([('BitID', 17), ('BitName', '@OPTS_PAUSE')])), (18, OrderedDict([('BitID', 18), ('BitName', '@OPTS_CLINICALINFO')]))]))]))]))])), (19, OrderedDict([('ID', 19), ('Name', 'PRESS_LIM'), ('Params', OrderedDict([('MaxLimVar', OrderedDict([('Name', 'MaxLimVar'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('LowLim', OrderedDict([('Name', 'LowLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('MediumLim', OrderedDict([('Name', 'MediumLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('HighLim', OrderedDict([('Name', 'HighLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Mode', OrderedDict([('Name', 'Mode'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Unit', OrderedDict([('Name', 'Unit'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (20, OrderedDict([('ID', 20), ('Name', 'PARAM_VOL_AIR'), ('Params', OrderedDict([('VolAlarm', OrderedDict([('Name', 'VolAlarm'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('VolMin', OrderedDict([('Name', 'VolMin'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (21, OrderedDict([('ID', 21), ('Name', 'BOLUS_FLOWRATE'), ('Params', OrderedDict([('BolsFlowRate', OrderedDict([('Name', 'BolsFlowRate'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (24, OrderedDict([('ID', 24), ('Name', 'INFUS_ENABLE'), ('Params', OrderedDict([('InfusEnable', OrderedDict([('Name', 'InfusEnable'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@PRGM_M_VIGILANT')])), (2, OrderedDict([('BitID', 2), ('BitName', '@INFUS_B_TR')])), (3, OrderedDict([('BitID', 3), ('BitName', '@INFUS_B_VTR')])), (4, OrderedDict([('BitID', 4), ('BitName', '@INFUS_B_R')])), (5, OrderedDict([('BitID', 5), ('BitName', '@INFUS_B_DROP')])), (6, OrderedDict([('BitID', 6), ('BitName', '@INFUS_B_BOLS')])), (8, OrderedDict([('BitID', 8), ('BitName', '@INFUS_B_LOAD')])), (9, OrderedDict([('BitID', 9), ('BitName', '@INFUS_B_BOLP')])), (10, OrderedDict([('BitID', 10), ('BitName', '@INFUS_B_RAMP')])), (11, OrderedDict([('BitID', 11), ('BitName', '@INFUS_B_SEQ')])), (12, OrderedDict([('BitID', 12), ('BitName', '@INFUS_B_PURG_AIR')])), (13, OrderedDict([('BitID', 13), ('BitName', '@INFUS_B_PURG_TUB')]))]))]))]))])), (25, OrderedDict([('ID', 25), ('Name', 'PROGRAM_MODE'), ('Params', OrderedDict([('ModeEnable', OrderedDict([('Name', 'ModeEnable'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(2, OrderedDict([('BitID', 2), ('BitName', '@PRGM_M_TCI')])), (3, OrderedDict([('BitID', 3), ('BitName', '@PRGM_M_NONAME_MLH')])), (4, OrderedDict([('BitID', 4), ('BitName', '@PRGM_M_NONAME_MF')])), (5, OrderedDict([('BitID', 5), ('BitName', '@PRGM_M_DRUGLIST_MLH')])), (6, OrderedDict([('BitID', 6), ('BitName', '@PRGM_M_DRUGLIST_MF')])), (0, OrderedDict([('BitID', 0), ('BitName', '@PRGM_D_XMLH')]))]))])), ('DrugEnable', OrderedDict([('Name', 'DrugEnable'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@PRGM_D_XMF')])), (2, OrderedDict([('BitID', 2), ('BitName', '@PRGM_D_TOP')])), (0, OrderedDict([('BitID', 0), ('BitName', '@NM_LOWBACKLIGHT')]))]))]))]))])), (27, OrderedDict([('ID', 27), ('Name', 'NIGHT_MODE'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@NM_LOWLEDS')])), (2, OrderedDict([('BitID', 2), ('BitName', '@NM_INHBEEPKEY')])), (3, OrderedDict([('BitID', 3), ('BitName', '@NM_MANUAL')])), (4, OrderedDict([('BitID', 4), ('BitName', '@NM_AUTO')]))]))])), ('FromTime', OrderedDict([('Name', 'FromTime'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ToTime', OrderedDict([('Name', 'ToTime'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (28, OrderedDict([('ID', 28), ('Name', 'PARAM_PATIENT'), ('Params', OrderedDict([('DefaultWeight', OrderedDict([('Name', 'DefaultWeight'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinWeight', OrderedDict([('Name', 'MinWeight'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxWeight', OrderedDict([('Name', 'MaxWeight'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('DefaultBSA', OrderedDict([('Name', 'DefaultBSA'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinBSA', OrderedDict([('Name', 'MinBSA'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxBSA', OrderedDict([('Name', 'MaxBSA'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (29, OrderedDict([('ID', 29), ('Name', 'INFUS_MODE'), ('Params', OrderedDict([('Mem', OrderedDict([('Name', 'Mem'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@MEM_INFUSMODE')]))]))])), ('InfusMode', OrderedDict([('Name', 'InfusMode'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (30, OrderedDict([('ID', 30), ('Name', 'PARAM_PATIENT_TCI'), ('Params', OrderedDict([('DefaultAge', OrderedDict([('Name', 'DefaultAge'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('DefaultHeight', OrderedDict([('Name', 'DefaultHeight'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinHeight', OrderedDict([('Name', 'MinHeight'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxHeight', OrderedDict([('Name', 'MaxHeight'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (31, OrderedDict([('ID', 31), ('Name', 'SECONDARY'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@SEC_STOPENDSEC')])), (1, OrderedDict([('BitID', 1), ('BitName', '@SEC_NOACKENDSEC')]))]))]))]))])), (32, OrderedDict([('ID', 32), ('Name', 'ENABLE_UNIT'), ('Params', OrderedDict([('Dilution', OrderedDict([('Name', 'Dilution'), ('Type', 'BOOL[]'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MassFlow', OrderedDict([('Name', 'MassFlow'), ('Type', 'BOOL[]'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('EnablePer', OrderedDict([('Name', 'EnablePer'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@MEM_DRUGONLY')])), (1, OrderedDict([('BitID', 1), ('BitName', '@PER_DIL_XML')])), (7, OrderedDict([('BitID', 7), ('BitName', '@PER_U_ML')]))]))]))]))])), (37, OrderedDict([('ID', 37), ('Name', 'ENABLE_MEM_DRUG'), ('Params', OrderedDict([('Mem', OrderedDict([('Name', 'Mem'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@MEM_DRUGPARAM')])), (0, OrderedDict([('BitID', 0), ('BitName', '@BUZ2_INHKEY')]))]))]))]))])), (40, OrderedDict([('ID', 40), ('Name', 'BUZZER2'), ('Params', OrderedDict([('Mode', OrderedDict([('Name', 'Mode'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Level', OrderedDict([('Name', 'Level'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (42, OrderedDict([('ID', 42), ('Name', 'DROP_CONFIG'), ('Params', OrderedDict())])), (44, OrderedDict([('ID', 44), ('Name', 'MISCELLANEOUS2'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@MISC2_INHSELFLOWINFUS')])), (2, OrderedDict([('BitID', 2), ('BitName', '@MISC2_AUTOINFUSR')])), (3, OrderedDict([('BitID', 3), ('BitName', '@MISC2_HIDEDURATION')]))]))]))]))])), (46, OrderedDict([('ID', 46), ('Name', 'MAX_FLOWRATE_SEC'), ('Params', OrderedDict([('MaxFlowSec', OrderedDict([('Name', 'MaxFlowSec'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (47, OrderedDict([('ID', 47), ('Name', 'MAX_FLOWRATE_LOADBOLP'), ('Params', OrderedDict([('MaxFlowLoadBolp', OrderedDict([('Name', 'MaxFlowLoadBolp'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (50, OrderedDict([('ID', 50), ('Name', 'DROP_CONFIG_SEC'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@DROPS_ON_PRIM_INFUSSEC')])), (2, OrderedDict([('BitID', 2), ('BitName', '@DROPS_ONSEC_INFUSSEC')]))]))]))]))])), (53, OrderedDict([('ID', 53), ('Name', 'AUTO_RESTART_OCCLUS'), ('Params', OrderedDict([('Valid', OrderedDict([('Name', 'Valid'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('MaxWaitDur', OrderedDict([('Name', 'MaxWaitDur'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('DecPressRestart', OrderedDict([('Name', 'DecPressRestart'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('InhibitPressLim', OrderedDict([('Name', 'InhibitPressLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('InhibitFlow', OrderedDict([('Name', 'InhibitFlow'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('MaxNbRestart', OrderedDict([('Name', 'MaxNbRestart'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('CountRestartDur', OrderedDict([('Name', 'CountRestartDur'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (54, OrderedDict([('ID', 54), ('Name', 'SYR_DRUG'), ('Params', OrderedDict([('SyrDrugItem', OrderedDict([('Name', 'SyrDrugItem'), ('Type', 'struct'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('NumRefSyr', OrderedDict([('Name', 'NumRefSyr'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('NumDrug', OrderedDict([('Name', 'NumDrug'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))]))]))])), (27, OrderedDict([('ID', 27), ('Name', 'CARE_AREA'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict([('InfosZone', OrderedDict([('Name', 'InfosZone'), ('Type', 'usestruct'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (2, OrderedDict([('ID', 2), ('Name', 'NAME'), ('Params', OrderedDict([('CareAreaName', OrderedDict([('Name', 'CareAreaName'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Name', OrderedDict([('Name', 'Name'), ('Type', 'STRING(20)'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (3, OrderedDict([('ID', 3), ('Name', 'AUTHOR'), ('Params', OrderedDict([('CareAreaAuthor', OrderedDict([('Name', 'CareAreaAuthor'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('AuthorName', OrderedDict([('Name', 'AuthorName'), ('Type', 'STRING(20)'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (4, OrderedDict([('ID', 4), ('Name', 'VERSION'), ('Params', OrderedDict([('CareAreaVersion', OrderedDict([('Name', 'CareAreaVersion'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Version', OrderedDict([('Name', 'Version'), ('Type', 'STRING(4)'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (5, OrderedDict([('ID', 5), ('Name', 'DATE'), ('Params', OrderedDict([('CareAreaDate', OrderedDict([('Name', 'CareAreaDate'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Create', OrderedDict([('Name', 'Create'), ('Type', 'DATETIME'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Modif', OrderedDict([('Name', 'Modif'), ('Type', 'DATETIME'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (6, OrderedDict([('ID', 6), ('Name', 'COMMENT'), ('Params', OrderedDict([('CareAreaComment', OrderedDict([('Name', 'CareAreaComment'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Comment', OrderedDict([('Name', 'Comment'), ('Type', 'STRING(150)'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (7, OrderedDict([('ID', 7), ('Name', 'GUID'), ('Params', OrderedDict([('Data1', OrderedDict([('Name', 'Data1'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Data2', OrderedDict([('Name', 'Data2'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Data3', OrderedDict([('Name', 'Data3'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Data4', OrderedDict([('Name', 'Data4'), ('Type', 'BYTE[8]'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (8, OrderedDict([('ID', 8), ('Name', 'DATE_WRITE'), ('Params', OrderedDict([('CareAreaDataWrite', OrderedDict([('Name', 'CareAreaDataWrite'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Write', OrderedDict([('Name', 'Write'), ('Type', 'DATETIME'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (9, OrderedDict([('ID', 9), ('Name', 'LOGO'), ('Params', OrderedDict([('LogoType', OrderedDict([('Name', 'LogoType'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))]))]))])), (30, OrderedDict([('ID', 30), ('Name', 'CARE_30'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict())])), (2, OrderedDict([('ID', 2), ('Name', 'INFOS LIB'), ('Params', OrderedDict())])), (3, OrderedDict([('ID', 3), ('Name', 'PARAM_DRUG'), ('Params', OrderedDict())]))]))])), (31, OrderedDict([('ID', 31), ('Name', 'CARE_31'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict())])), (2, OrderedDict([('ID', 2), ('Name', 'INFOS_LIB'), ('Params', OrderedDict([('InfosZone', OrderedDict([('Name', 'InfosZone'), ('Type', 'usestruct'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (3, OrderedDict([('ID', 3), ('Name', 'PARAM_DRUG'), ('Params', OrderedDict())]))]))]))])
Zones = OrderedDict([(8, OrderedDict([('ID', 8), ('Name', 'GLOBAL'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict([('Version', OrderedDict([('Name', 'Version'), ('Type', 'STRING(8)'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Create', OrderedDict([('Name', 'Create'), ('Type', 'DATETIME'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ManChg', OrderedDict([('Name', 'ManChg'), ('Type', 'DATETIME'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (2, OrderedDict([('ID', 2), ('Name', 'ACCURACY'), ('Params', OrderedDict([('Fine', OrderedDict([('Name', 'Fine'), ('Type', 'BOOL'), ('Required', 'No'), ('RD_ID', 'RD_0013')]))]))]))]))])), (22, OrderedDict([('ID', 22), ('Name', 'USER'), ('Pars', OrderedDict([(9, OrderedDict([('ID', 9), ('Name', 'MEM_PROGRAM_MODE'), ('Params', OrderedDict([('ProgramMode', OrderedDict([('Name', 'ProgramMode'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (10, OrderedDict([('ID', 10), ('Name', 'MEM_SEL'), ('Params', OrderedDict([('Mem', OrderedDict([('Name', 'Mem'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0546'), ('Flags', OrderedDict([(2, OrderedDict([('BitID', 2), ('BitName', '@MEM_PRESSLIM')])), (3, OrderedDict([('BitID', 3), ('BitName', '@MEM_VOLINFUS')])), (5, OrderedDict([('BitID', 5), ('BitName', '@MEM_SAMEINFUSION')])), (6, OrderedDict([('BitID', 6), ('BitName', '@MEM_DPSAUTO')])), (7, OrderedDict([('BitID', 7), ('BitName', '@MEM_AUTORESTARTOCCLUS')]))]))])), ('DurSameInfusion', OrderedDict([('Name', 'DurSameInfusion'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0547')])), ('PressLim', OrderedDict([('Name', 'PressLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0548')])), ('DpsAuto', OrderedDict([('Name', 'DpsAuto'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0549')])), ('AutoRestartOcclus', OrderedDict([('Name', 'AutoRestartOcclus'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (12, OrderedDict([('ID', 12), ('Name', 'MAX_FLOWRATE'), ('Params', OrderedDict([('MaxFlowPrim', OrderedDict([('Name', 'MaxFlowPrim'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0001')]))]))])), (13, OrderedDict([('ID', 13), ('Name', 'MODE_FAST_START'), ('Params', OrderedDict([('Valid', OrderedDict([('Name', 'Valid'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@FS_FASTSTART')])), (1, OrderedDict([('BitID', 1), ('BitName', '@FS_PURGMANDATORY')])), (2, OrderedDict([('BitID', 2), ('BitName', '@FS_PURGADVICE')]))]))]))]))])), (14, OrderedDict([('ID', 14), ('Name', 'DPS'), ('Params', OrderedDict([('ParamDps', OrderedDict([('Name', 'ParamDps'), ('Type', 'struct'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ThresholdIncr', OrderedDict([('Name', 'ThresholdIncr'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0550')])), ('ThresholdDrop', OrderedDict([('Name', 'ThresholdDrop'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0551')]))]))])), (16, OrderedDict([('ID', 16), ('Name', 'END_INFUS'), ('Params', OrderedDict([('KvoFlowRate', OrderedDict([('Name', 'KvoFlowRate'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0559')])), ('DurPreAl', OrderedDict([('Name', 'DurPreAl'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0555')])), ('VolPreAl', OrderedDict([('Name', 'VolPreAl'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0560')])), ('PercentPreAl', OrderedDict([('Name', 'PercentPreAl'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0561')])), ('InhPreAlDrop', OrderedDict([('Name', 'InhPreAlDrop'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0562')])), ('DurSilAlKvo', OrderedDict([('Name', 'DurSilAlKvo'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0556')]))]))])), (18, OrderedDict([('ID', 18), ('Name', 'OPT_SCREEN1'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@OPTS_INFUSMODE')])), (3, OrderedDict([('BitID', 3), ('BitName', '@OPTF_SAMETHERAPY')])), (8, OrderedDict([('BitID', 8), ('BitName', '@OPTF_PRESSURE')])), (9, OrderedDict([('BitID', 9), ('BitName', '@OPTF_BATTERY')])), (10, OrderedDict([('BitID', 10), ('BitName', '@OPTF_VIGILANT')]))]))])), ('MnuScreen', OrderedDict([('Name', 'MnuScreen'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(2, OrderedDict([('BitID', 2), ('BitName', '@OPTS_SOUNDLEVEL')])), (3, OrderedDict([('BitID', 3), ('BitName', '@OPTS_HISTORIC')])), (4, OrderedDict([('BitID', 4), ('BitName', '@OPTS_LIBDRUG')])), (6, OrderedDict([('BitID', 6), ('BitName', '@OPTS_BOLUSPROG')])), (7, OrderedDict([('BitID', 7), ('BitName', '@OPTS_PATIENT')])), (9, OrderedDict([('BitID', 9), ('BitName', '@OPTS_SECONDARY')])), (10, OrderedDict([('BitID', 10), ('BitName', '@OPTS_GRAPH_FLOW')])), (11, OrderedDict([('BitID', 11), ('BitName', '@OPTS_GRAPH_PRESS')])), (12, OrderedDict([('BitID', 12), ('BitName', '@OPTS_TIMEWARNING')])), (13, OrderedDict([('BitID', 13), ('BitName', '@OPTS_CHANGEDRUG')])), (14, OrderedDict([('BitID', 14), ('BitName', '@OPTS_INFOCASET')])), (15, OrderedDict([('BitID', 15), ('BitName', '@OPTS_INFOCAREAREA')])), (17, OrderedDict([('BitID', 17), ('BitName', '@OPTS_PAUSE')])), (18, OrderedDict([('BitID', 18), ('BitName', '@OPTS_CLINICALINFO')]))]))]))]))])), (19, OrderedDict([('ID', 19), ('Name', 'PRESS_LIM'), ('Params', OrderedDict([('MaxLimVar', OrderedDict([('Name', 'MaxLimVar'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('LowLim', OrderedDict([('Name', 'LowLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('MediumLim', OrderedDict([('Name', 'MediumLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('HighLim', OrderedDict([('Name', 'HighLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Mode', OrderedDict([('Name', 'Mode'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Unit', OrderedDict([('Name', 'Unit'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (20, OrderedDict([('ID', 20), ('Name', 'PARAM_VOL_AIR'), ('Params', OrderedDict([('VolAlarm', OrderedDict([('Name', 'VolAlarm'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('VolMin', OrderedDict([('Name', 'VolMin'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (21, OrderedDict([('ID', 21), ('Name', 'BOLUS_FLOWRATE'), ('Params', OrderedDict([('BolsFlowRate', OrderedDict([('Name', 'BolsFlowRate'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (24, OrderedDict([('ID', 24), ('Name', 'INFUS_ENABLE'), ('Params', OrderedDict([('InfusEnable', OrderedDict([('Name', 'InfusEnable'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@PRGM_M_VIGILANT')])), (2, OrderedDict([('BitID', 2), ('BitName', '@INFUS_B_TR')])), (3, OrderedDict([('BitID', 3), ('BitName', '@INFUS_B_VTR')])), (4, OrderedDict([('BitID', 4), ('BitName', '@INFUS_B_R')])), (5, OrderedDict([('BitID', 5), ('BitName', '@INFUS_B_DROP')])), (6, OrderedDict([('BitID', 6), ('BitName', '@INFUS_B_BOLS')])), (8, OrderedDict([('BitID', 8), ('BitName', '@INFUS_B_LOAD')])), (9, OrderedDict([('BitID', 9), ('BitName', '@INFUS_B_BOLP')])), (10, OrderedDict([('BitID', 10), ('BitName', '@INFUS_B_RAMP')])), (11, OrderedDict([('BitID', 11), ('BitName', '@INFUS_B_SEQ')])), (12, OrderedDict([('BitID', 12), ('BitName', '@INFUS_B_PURG_AIR')])), (13, OrderedDict([('BitID', 13), ('BitName', '@INFUS_B_PURG_TUB')]))]))]))]))])), (25, OrderedDict([('ID', 25), ('Name', 'PROGRAM_MODE'), ('Params', OrderedDict([('ModeEnable', OrderedDict([('Name', 'ModeEnable'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(2, OrderedDict([('BitID', 2), ('BitName', '@PRGM_M_TCI')])), (3, OrderedDict([('BitID', 3), ('BitName', '@PRGM_M_NONAME_MLH')])), (4, OrderedDict([('BitID', 4), ('BitName', '@PRGM_M_NONAME_MF')])), (5, OrderedDict([('BitID', 5), ('BitName', '@PRGM_M_DRUGLIST_MLH')])), (6, OrderedDict([('BitID', 6), ('BitName', '@PRGM_M_DRUGLIST_MF')])), (0, OrderedDict([('BitID', 0), ('BitName', '@PRGM_D_XMLH')]))]))])), ('DrugEnable', OrderedDict([('Name', 'DrugEnable'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@PRGM_D_XMF')])), (2, OrderedDict([('BitID', 2), ('BitName', '@PRGM_D_TOP')])), (0, OrderedDict([('BitID', 0), ('BitName', '@NM_LOWBACKLIGHT')]))]))]))]))])), (27, OrderedDict([('ID', 27), ('Name', 'NIGHT_MODE'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@NM_LOWLEDS')])), (2, OrderedDict([('BitID', 2), ('BitName', '@NM_INHBEEPKEY')])), (3, OrderedDict([('BitID', 3), ('BitName', '@NM_MANUAL')])), (4, OrderedDict([('BitID', 4), ('BitName', '@NM_AUTO')]))]))])), ('FromTime', OrderedDict([('Name', 'FromTime'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ToTime', OrderedDict([('Name', 'ToTime'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (28, OrderedDict([('ID', 28), ('Name', 'PARAM_PATIENT'), ('Params', OrderedDict([('DefaultWeight', OrderedDict([('Name', 'DefaultWeight'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinWeight', OrderedDict([('Name', 'MinWeight'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxWeight', OrderedDict([('Name', 'MaxWeight'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('DefaultBSA', OrderedDict([('Name', 'DefaultBSA'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinBSA', OrderedDict([('Name', 'MinBSA'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxBSA', OrderedDict([('Name', 'MaxBSA'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (29, OrderedDict([('ID', 29), ('Name', 'INFUS_MODE'), ('Params', OrderedDict([('Mem', OrderedDict([('Name', 'Mem'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@MEM_INFUSMODE')]))]))])), ('InfusMode', OrderedDict([('Name', 'InfusMode'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (30, OrderedDict([('ID', 30), ('Name', 'PARAM_PATIENT_TCI'), ('Params', OrderedDict([('DefaultAge', OrderedDict([('Name', 'DefaultAge'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('DefaultHeight', OrderedDict([('Name', 'DefaultHeight'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinHeight', OrderedDict([('Name', 'MinHeight'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxHeight', OrderedDict([('Name', 'MaxHeight'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (31, OrderedDict([('ID', 31), ('Name', 'SECONDARY'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@SEC_STOPENDSEC')])), (1, OrderedDict([('BitID', 1), ('BitName', '@SEC_NOACKENDSEC')]))]))]))]))])), (32, OrderedDict([('ID', 32), ('Name', 'ENABLE_UNIT'), ('Params', OrderedDict([('Dilution', OrderedDict([('Name', 'Dilution'), ('Type', 'BOOL[10]'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MassFlow', OrderedDict([('Name', 'MassFlow'), ('Type', 'BOOL[36]'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('EnablePer', OrderedDict([('Name', 'EnablePer'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@MEM_DRUGONLY')])), (1, OrderedDict([('BitID', 1), ('BitName', '@PER_DIL_XML')])), (7, OrderedDict([('BitID', 7), ('BitName', '@PER_U_ML')]))]))]))]))])), (37, OrderedDict([('ID', 37), ('Name', 'ENABLE_MEM_DRUG'), ('Params', OrderedDict([('Mem', OrderedDict([('Name', 'Mem'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@MEM_DRUGPARAM')])), (0, OrderedDict([('BitID', 0), ('BitName', '@BUZ2_INHKEY')]))]))]))]))])), (40, OrderedDict([('ID', 40), ('Name', 'BUZZER2'), ('Params', OrderedDict([('Mode', OrderedDict([('Name', 'Mode'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Level', OrderedDict([('Name', 'Level'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (42, OrderedDict([('ID', 42), ('Name', 'DROP_CONFIG'), ('Params', OrderedDict())])), (44, OrderedDict([('ID', 44), ('Name', 'MISCELLANEOUS2'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(0, OrderedDict([('BitID', 0), ('BitName', '@MISC2_INHSELFLOWINFUS')])), (2, OrderedDict([('BitID', 2), ('BitName', '@MISC2_AUTOINFUSR')])), (3, OrderedDict([('BitID', 3), ('BitName', '@MISC2_HIDEDURATION')]))]))]))]))])), (46, OrderedDict([('ID', 46), ('Name', 'MAX_FLOWRATE_SEC'), ('Params', OrderedDict([('MaxFlowSec', OrderedDict([('Name', 'MaxFlowSec'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (47, OrderedDict([('ID', 47), ('Name', 'MAX_FLOWRATE_LOADBOLP'), ('Params', OrderedDict([('MaxFlowLoadBolp', OrderedDict([('Name', 'MaxFlowLoadBolp'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (50, OrderedDict([('ID', 50), ('Name', 'DROP_CONFIG_SEC'), ('Params', OrderedDict([('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@DROPS_ON_PRIM_INFUSSEC')])), (2, OrderedDict([('BitID', 2), ('BitName', '@DROPS_ONSEC_INFUSSEC')]))]))]))]))])), (53, OrderedDict([('ID', 53), ('Name', 'AUTO_RESTART_OCCLUS'), ('Params', OrderedDict([('Valid', OrderedDict([('Name', 'Valid'), ('Type', 'BOOL'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('MaxWaitDur', OrderedDict([('Name', 'MaxWaitDur'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('DecPressRestart', OrderedDict([('Name', 'DecPressRestart'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('InhibitPressLim', OrderedDict([('Name', 'InhibitPressLim'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('InhibitFlow', OrderedDict([('Name', 'InhibitFlow'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('MaxNbRestart', OrderedDict([('Name', 'MaxNbRestart'), ('Type', 'BYTE'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('CountRestartDur', OrderedDict([('Name', 'CountRestartDur'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (54, OrderedDict([('ID', 54), ('Name', 'SYR_DRUG'), ('Params', OrderedDict([('SyrDrugItem', OrderedDict([('Name', 'SyrDrugItem'), ('Type', 'struct'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('NumRefSyr', OrderedDict([('Name', 'NumRefSyr'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('NumDrug', OrderedDict([('Name', 'NumDrug'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))]))]))])), (27, OrderedDict([('ID', 27), ('Name', 'CARE_AREA'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict([('InfosZone', OrderedDict([('Name', 'InfosZone'), ('Type', 'usestruct'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (2, OrderedDict([('ID', 2), ('Name', 'NAME'), ('Params', OrderedDict([('CareAreaName', OrderedDict([('Name', 'CareAreaName'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Name', OrderedDict([('Name', 'Name'), ('Type', 'STRING(20)'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (3, OrderedDict([('ID', 3), ('Name', 'AUTHOR'), ('Params', OrderedDict([('CareAreaAuthor', OrderedDict([('Name', 'CareAreaAuthor'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('AuthorName', OrderedDict([('Name', 'AuthorName'), ('Type', 'STRING(20)'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (4, OrderedDict([('ID', 4), ('Name', 'VERSION'), ('Params', OrderedDict([('CareAreaVersion', OrderedDict([('Name', 'CareAreaVersion'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Version', OrderedDict([('Name', 'Version'), ('Type', 'STRING(4)'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (5, OrderedDict([('ID', 5), ('Name', 'DATE'), ('Params', OrderedDict([('CareAreaDate', OrderedDict([('Name', 'CareAreaDate'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Create', OrderedDict([('Name', 'Create'), ('Type', 'DATETIME'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Modif', OrderedDict([('Name', 'Modif'), ('Type', 'DATETIME'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (6, OrderedDict([('ID', 6), ('Name', 'COMMENT'), ('Params', OrderedDict([('CareAreaComment', OrderedDict([('Name', 'CareAreaComment'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Comment', OrderedDict([('Name', 'Comment'), ('Type', 'STRING(150)'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (7, OrderedDict([('ID', 7), ('Name', 'GUID'), ('Params', OrderedDict([('Data1', OrderedDict([('Name', 'Data1'), ('Type', 'DWORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Data2', OrderedDict([('Name', 'Data2'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Data3', OrderedDict([('Name', 'Data3'), ('Type', 'WORD'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')])), ('Data4', OrderedDict([('Name', 'Data4'), ('Type', 'BYTE[8]'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (8, OrderedDict([('ID', 8), ('Name', 'DATE_WRITE'), ('Params', OrderedDict([('CareAreaDataWrite', OrderedDict([('Name', 'CareAreaDataWrite'), ('Type', 'structname'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Write', OrderedDict([('Name', 'Write'), ('Type', 'DATETIME'), ('Required', 'Yes'), ('RD_ID', 'RD_0000')]))]))])), (9, OrderedDict([('ID', 9), ('Name', 'LOGO'), ('Params', OrderedDict([('LogoType', OrderedDict([('Name', 'LogoType'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))]))]))])), (30, OrderedDict([('ID', 30), ('Name', 'CARE_30'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict())])), (2, OrderedDict([('ID', 2), ('Name', 'INFOS LIB'), ('Params', OrderedDict())])), (3, OrderedDict([('ID', 3), ('Name', 'PARAM_DRUG'), ('Params', OrderedDict())]))]))])), (31, OrderedDict([('ID', 31), ('Name', 'CARE_31'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict())])), (2, OrderedDict([('ID', 2), ('Name', 'INFOS_LIB'), ('Params', OrderedDict([('InfosZone', OrderedDict([('Name', 'InfosZone'), ('Type', 'usestruct'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (3, OrderedDict([('ID', 3), ('Name', 'PARAM_DRUG'), ('SubPars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'NAME'), ('Params', OrderedDict([('Name', OrderedDict([('Name', 'Name'), ('Type', 'VSTRING(25)'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (2, OrderedDict([('ID', 2), ('Name', 'DILUTION'), ('Params', OrderedDict([('Default', OrderedDict([('Name', 'Default'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Unit', OrderedDict([('Name', 'Unit'), ('Type', 'UNIT'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Volume', OrderedDict([('Name', 'Volume'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MassInfusUnit', OrderedDict([('Name', 'MassInfusUnit'), ('Type', 'UNIT'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (3, OrderedDict([('ID', 3), ('Name', 'SEL_DILUTION'), ('Params', OrderedDict([('MinDilution', OrderedDict([('Name', 'MinDilution'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxDilution', OrderedDict([('Name', 'MaxDilution'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinVolume', OrderedDict([('Name', 'MinVolume'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxVolume', OrderedDict([('Name', 'MaxVolume'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Flags', OrderedDict([('Name', 'Flags'), ('Type', 'BYTE'), ('Required', 'No'), ('RD_ID', 'RD_0000'), ('Flags', OrderedDict([(1, OrderedDict([('BitID', 1), ('BitName', '@SDIL_VALUES')])), (4, OrderedDict([('BitID', 4), ('BitName', '@SDIL_VOLVALUES')]))]))])), ('ValDilution4', OrderedDict([('Name', 'ValDilution4'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ValDilution5', OrderedDict([('Name', 'ValDilution5'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Volume2', OrderedDict([('Name', 'Volume2'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Volume3', OrderedDict([('Name', 'Volume3'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Volume4', OrderedDict([('Name', 'Volume4'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Volume5', OrderedDict([('Name', 'Volume5'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (4, OrderedDict([('ID', 4), ('Name', 'FLOWRATE'), ('Params', OrderedDict([('Default', OrderedDict([('Name', 'Default'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Min', OrderedDict([('Name', 'Min'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Max', OrderedDict([('Name', 'Max'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Unit', OrderedDict([('Name', 'Unit'), ('Type', 'UNIT'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (5, OrderedDict([('ID', 5), ('Name', 'FLOW_LOW_HIGH'), ('Params', OrderedDict([('Low', OrderedDict([('Name', 'Low'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('High', OrderedDict([('Name', 'High'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (6, OrderedDict([('ID', 6), ('Name', 'VOL_TIME'), ('Params', OrderedDict([('DefaultDose', OrderedDict([('Name', 'DefaultDose'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('DefaultDuration', OrderedDict([('Name', 'DefaultDuration'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinDose', OrderedDict([('Name', 'MinDose'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxDose', OrderedDict([('Name', 'MaxDose'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MinDuration', OrderedDict([('Name', 'MinDuration'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('MaxDuration', OrderedDict([('Name', 'MaxDuration'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('KvoFlowRate', OrderedDict([('Name', 'KvoFlowRate'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Unit', OrderedDict([('Name', 'Unit'), ('Type', 'UNIT'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (7, OrderedDict([('ID', 7), ('Name', 'BOLUS'), ('Params', OrderedDict([('FlowRate', OrderedDict([('Name', 'FlowRate'), ('Type', 'DWORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])), (8, OrderedDict([('ID', 8), ('Name', 'INFUS_MODE'), ('Params', OrderedDict([('MaxVolume', OrderedDict([('Name', 'MaxVolume'), ('Type', 'WORD'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))]))]))]))]))]))])
#Zones = OrderedDict([(8, OrderedDict([('ID', 8),('Name', 'GLOBAL'), ('Pars', OrderedDict([(1, OrderedDict([('ID', 1), ('Name', 'INFOS'), ('Params', OrderedDict([('Version', OrderedDict([('Name', 'Version'), ('Type', 'STRING(8)'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('Create', OrderedDict([('Name', 'Create'), ('Type', 'DATETIME'), ('Required', 'No'), ('RD_ID', 'RD_0000')])), ('ManChg', OrderedDict([('Name', 'ManChg'), ('Type', 'DATETIME'), ('Required', 'No'), ('RD_ID', 'RD_0000')]))]))])),(2, OrderedDict([('ID', 2), ('Name', 'ACCURACY'), ('Params', OrderedDict([('Fine', OrderedDict([('Name', 'Fine'), ('Type', 'BOOL'), ('Required', 'No'), ('RD_ID', 'RD_0013')]))]))]))]))]))])
printdevicesOrder(Zones, 'AllZones')