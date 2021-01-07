/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Utility Methods to create HL7 Schema file from Class Definitions.
Class EnsLib.ITK.Util.ImportSchema [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Utility Methods to create HL7 Schema file from Class Definitions.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

ClassMethod CreateHL7v2Schema(pPackage As %String, pSchemaName As %String, pIOStream As %IO.I.CharacterStream, pNamespace As %String, pBase) As %Status
{
	set tSC=$$$OK
	
	set tRS=##class(%ResultSet).%New()
	set tRS.ClassName="%Dictionary.ClassDefinition"
	set tRS.QueryName="Summary"
	
	set tSC=tRS.Execute()
	Quit:$$$ISERR(tSC)
	
	while tRS.Next() {
		
	continue:($extract(tRS.Get("Name"),1,$length(pPackage))'=pPackage)
	
	set class=tRS.Get("Name")
	
	set def=##class(%Dictionary.ClassDefinition).%OpenId(class)
	continue:(def="")
	
	set classdesc=def.Description
			
	set type="MS"
	if $find(classdesc,"datatypes-2010-05.xsd") set type="DS"
	if $find(classdesc,"segments-2010-05.xsd") set type="SS"

	continue:$find(classdesc,"fields")
	continue:$find(classdesc,"distributionenvelope-v1-0.xsd")
	continue:$find(classdesc,"queuecollectionmessagetypes-2010-05.xsd")
	continue:classdesc=""

	if ((type="DS")||(type="SS")) {
		set tSC=..DataSegmentStructure(def,type)
	}
	elseif (type="MS") {
		set msgtype=..GetName(class) //$zcvt($piece($piece(classdesc,"/",$length(classdesc,"/")),".xsd"),"U")

		//Use the Type defined in the XSD and not the one from base schema.
		set doctype=..GetName(class)
		
		// Also need to fetch returntype from base category
		do ##class(EnsLib.HL7.Schema).ResolveReplyNameAndDocType(pBase_":"_msgtype,.returntype)
		
		//Mainly for ACK - For which ResolveReplyNameAndDocType returns ACK_
		If ($P(returntype, "_", 2)="") Set returntype=$P(returntype, "_", 1)
		
		set desc="xsi:schemaLocation="_""""_$piece(pNamespace,"'",2)_" "_msgtype_".xsd"_""""
		set ^||tempArray("MT",msgtype)=doctype_"^"_returntype_"^"_desc
		
		continue:(msgtype'=doctype)
		
		set msgstruct=..MakeGroupStructure(class)

		if ($P($P(class, pPackage_".", 2), ".", 2) = "CONTENT") {
			set ^||tempArray(type,doctype)=msgstruct
		}
	}
	}

	set pLine="<?xml version=""1.0"" encoding=""UTF-8""?>"
	Do pIOStream.WriteLine(pLine,,.tSC)  Quit:$$$ISERR(tSC)

	set pLine="<Export generator=""IRIS"" version=""24"" zv="""_$zv_""" ts="""_$zdatetime($horolog,3)_""">"
	Do pIOStream.WriteLine(pLine,,.tSC)  Quit:$$$ISERR(tSC)

	set pLine="<Document name="""_pSchemaName_""_".HL7"">"
	Do pIOStream.WriteLine(pLine,,.tSC)  Quit:$$$ISERR(tSC)

	set pLine="<Category name="""_pSchemaName_""" description="""_pNamespace_""">"
	Do pIOStream.WriteLine(pLine,,.tSC)  Quit:$$$ISERR(tSC)
	
	do ..OutputMiddleTags(.pIOStream,pSchemaName,pBase)
	
	set pLine="</Category></Document></Export>"
	Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)

	quit tSC
}

// RB

ClassMethod MakeGroupStructure(pClass As %String) As %String
{
	Set msgstruct = ""
	// def.Properties in alphabetical order so must use storage definition.
	set storage=##class(%Dictionary.StorageDefinition).%OpenId(pClass_"||"_"Default")
	if ('$IsObject(storage)) w "Bad storage for "_pClass,!
	set values=storage.Data.GetAt(1).Values
	if ('$IsObject(values)) w "Bad values for "_pClass,!
	set valnum=values.Count()
	// first one should be %%CLASSNAME
	for i=2:1:valnum {
		set value=values.GetAt(i).Value
		
		Do ..IsRequired(pClass,value,.tIsRequired, .tIsRepeating)
		
		//only going one level at the moment
		// using the name length > 3 is an assumption for a group name
		if ($length(value)>3) {
			set tValue = ..MakeGroupStructure(..GetClassName(pClass, value)) //..GroupNameCodeTableSet(pClass,value,doctype,.msgstruct)
		}
		else {
			//Add {}, [] based on repeating and optionality
			Set tValue = value
		}
		if (tValue '= "") {
			If (tIsRepeating) Set tValue = "{~"_tValue_"~}"
			If ('tIsRequired) Set tValue = "[~"_tValue_"~]"
			
			if (msgstruct="") {
				set msgstruct=tValue
			}
			else {
				set msgstruct=msgstruct_"~"_tValue
			}
		}
	}
	
	Quit msgstruct
}

ClassMethod GroupNameCodeTableSet(pClass As %String, pValue As %String, pDocType As %String, pMsgStruct As %String) As %Status
{
	set type="CT"
	set name=$piece(pValue,$piece(pClass,".",2),2)
	set pMsgStruct=pMsgStruct_"~{"
	set groupname=""
	// to do, a better way of getting the v2 group name though this is only for information
	if name="PATIENT" set groupname="PIDgrp"
	set defname=$piece(pClass,".",1,2)_"."_name_"."_"CONTENT"
	set def=##class(%Dictionary.ClassDefinition).%OpenId(defname)

	// def.Properties in alphabetical order so must use storage definition.
	set storage=##class(%Dictionary.StorageDefinition).%OpenId(defname_"||"_"Default")
	set values=storage.Data.GetAt(1).Values
	set valnum=values.Count()
	// first one should be %%CLASSNAME
	for i=2:1:valnum {
		set value=values.GetAt(i).Value
		set ^||tempArray(type,pDocType,value)=name_"^"_groupname
		set pMsgStruct=pMsgStruct_"~"_value
	}
	set pMsgStruct=pMsgStruct_"~}"
	quit $$$OK
}

ClassMethod DataSegmentStructure(pDef As %Dictionary.ClassDefinition, pType As %String) As %Status
{
		set tSC=$$$OK
		
		quit:$extract(pDef.Super,1,13)="%SerialObject" tSC
		
		set name=..GetName(pDef.Name) //$piece(pDef.Name,".",3)
		quit:$extract(name,1,3)="any" tSC
		quit:name="escapeType" tSC
		set classdesc=pDef.Description
		set propnum=pDef.Properties.Count()
		quit:propnum=0 tSC
		// class shouldn't be persistent but it is:
		quit:(pDef.Properties.GetAt(1).Name="LongName") tSC
		quit:(pDef.Properties.GetAt(1).Name="content") tSC

		set ^||tempArray(pType,name)=classdesc
		for i=1:1:propnum {
		set prop=pDef.Properties.GetAt(i)
		//RAH
		//set propname=prop.Name
		set propname=..GetPropName(pDef.Name,prop.Name)
		set:propname="" propname=prop.Name
		// RAH end
		
		continue:$extract(propname,1,3)="any"
		
		set datatype=prop.Type
		set desc=prop.Description
		set propdef=##class(%Dictionary.ClassDefinition).%OpenId(datatype)
		quit:propdef=""
		// description for fields is in field class
		if (desc="") set desc=$piece(propdef.Description,$c(13))
		set desc=$zcvt(desc,"O","XML")
		set extends=propdef.Super
		set datastruct=""
		
		set datastruct=..GetName(propdef.Super)

		if ($piece(propname,name,2)'="") {
			//RAH
			//set ^||tempArray(pType,name,$piece(propname,name,2))=desc_"^"_datastruct
			set ^||tempArray(pType,name,$zstrip($piece(propname,name,2),"<","."))=desc_"^"_datastruct
			//RAH end
			}
		else {
			set ^||tempArray(pType,name,propname)=desc_"^"_datastruct
			w "Warning non-conformant property in "_name_": "_propname,!
			}
		continue:pType="DS"

		// also need required,ifrepeating and this will determine symbol
		// + -> Required & Repeating
		// ! -> Required
		// * -> Repeating
		// &amp -> Required="C" (Conditional) - Not taken care of yet
		set required="O"
		if +(prop.Required) set required="R"
		set ifrepeating=0
		if prop.Collection'="" set ifrepeating=1
		set symbol=""
		if (ifrepeating) {
			set symbol="*"
			if (required="R") set symbol="+" 
		} Elseif (required="R") {
			set symbol="!"
		}
		
		// RAH
		//set ^||tempArray(pType,name,$piece(propname,name,2))=desc_"^"_datastruct_"^"_symbol_"^"_required_"^"_ifrepeating	kill propdef
		set ^||tempArray(pType,name,$zstrip($piece(propname,name,2),"<","."))=desc_"^"_datastruct_"^"_symbol_"^"_required_"^"_ifrepeating
		// RAH end
		
	}
	quit tSC
}

ClassMethod OutputMiddleTags(pIOStream As %IO.I.CharacterStream, pSchemaName As %String, pBase As %String) As %Status
{
	set tSC=$$$OK
	
	for tA1="MT","MS","SS","DS","CT" {
		if (tA1="MT") {
			set tA2=""
			for  {
				set tA2=$order(^||tempArray(tA1,tA2))
				quit:tA2=""
				
				set tag="MessageType"

				set pLine="<"_tag_" name='"_tA2_"' structure='"_$piece(^||tempArray(tA1,tA2),"^")_"' returntype='"_$piece(^||tempArray(tA1,tA2),"^",2)_"' description='"_$piece(^||tempArray(tA1,tA2),"^",3)_"' />"
				Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
				}
		}
		if (tA1="MS") {
				set tA2=""
				for  {
					set tA2=$order(^||tempArray(tA1,tA2))
					quit:tA2=""
					
					set tag="Message"

					set pLine="<"_tag_"Structure name='"_tA2_"' definition='"_^||tempArray(tA1,tA2)_"'/>"
					Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
					}
		
		}
 		if ((tA1="DS")||(tA1="SS")) {
 			set tag=$case(tA1,"DS":"Data","SS":"Segment")
 	
			set tA2=""
			for  {
				set tA2=$order(^||tempArray(tA1,tA2))
				quit:tA2=""
		
				set pLine="<"_tag_"Structure name='"_tA2_"' description='"_^||tempArray(tA1,tA2)_"'>"
				Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
		
				set tA3=""
				for  {
					set tA3=$order(^||tempArray(tA1,tA2,tA3))
					quit:tA3=""
					set desc=$piece(^||tempArray(tA1,tA2,tA3),"^")
					set datastruct=$piece(^||tempArray(tA1,tA2,tA3),"^",2)
					set pLine="<"_tag_"SubStructure piece='"_tA3_"' description='"_desc_"' "
					set pElementSpec="DS:"_pBase_":"_datastruct
					
					// Do not assign unknown datatypes (either primitive or new
					// datatypes unless base schema is custom one that includes them).
					if ((datastruct'="")&&(##class(EnsLib.HL7.Schema).ElementExists(pElementSpec))) {
						set pLine=pLine_"datastruct='"_datastruct_"' "
					}
					// RAH
					elseif (datastruct'="") && ($d(^||tempArray(tA1,datastruct)))
					{
						w:datastruct'="" "Warning defining new data structure:"_datastruct,!
						set:datastruct'="" pLine=pLine_"datastruct='"_datastruct_"' "
					}
					else
					{
						w:datastruct'="" "Warning bad datastructure:"_datastruct,!
					}
					// RAH end
					if (tA1="SS") {
						set symbol=$piece(^||tempArray(tA1,tA2,tA3),"^",3)
						if (symbol'="") set pLine=pLine_"symbol='"_symbol_"' "
						set required=$piece(^||tempArray(tA1,tA2,tA3),"^",4)
						set pLine=pLine_"required='"_required_"' "
						set ifrepeating=$piece(^||tempArray(tA1,tA2,tA3),"^",5)
						set pLine=pLine_"ifrepeating='"_ifrepeating_"'"
					}
			
					set pLine=pLine_" />"
					Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
					
				}
				set pLine="</"_tag_"Structure>"
				Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
			}
		}
		elseif (tA1="CT") {
			
			set tA2=""
			for  {
				set tA2=$order(^||tempArray(tA1,tA2))
				quit:tA2=""
		
				set pLine="<CodeTable name='"_tA2_"' tabletype='1' description='Group label names for "_tA2_"'>"
				Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
		
				set tA3=""
				for  {
					set tA3=$order(^||tempArray(tA1,tA2,tA3))
					quit:tA3=""
					
					set position=$piece(^||tempArray(tA1,tA2,tA3),"^")
					set desc=$piece(^||tempArray(tA1,tA2,tA3),"^",2)
					set pLine="<Enumerate position='"_position_"' value='"_tA3_"' description='"_desc_"'"
					set pLine=pLine_" />"
					Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
				}
				set pLine="</CodeTable>"
				Do pIOStream.WriteLine(pLine,,.pStatus)  Quit:$$$ISERR(pStatus)
			}
			
		}
	}
	kill ^||tempArray

	quit tSC
}

/// Use the XMLNAME Parameter to get the Name
ClassMethod GetName(pClass As %String) As %String
{
	S tName = ""
	if ($$$comMemberDefined(pClass, $$$cCLASSparameter, "XMLNAME")) {
			S tName = $$$comMemberKeyGet(pClass,$$$cCLASSparameter,"XMLNAME",$$$cPARAMdefault)
			S tName = $P(tName, ".", 1)
	}	
	Quit tName
}

// RAH

/// Use the XMLNAME Annotation to get the Name
ClassMethod GetPropName(pClass As %String, pProp As %String) As %String
{
	S tName = ""
	if ($$$comSubMemberDefined(pClass, $$$cCLASSproperty,pProp,$$$cPROPparameter, "XMLNAME")) {
			S tName = $$$comMemberArrayGet(pClass,$$$cCLASSproperty,pProp,$$$cPROPparameter,"XMLNAME")
	}	
	Quit tName
}

// RAH end

/// Use the XMLTYPE Parameter to get the Type - Doc Type
ClassMethod GetType(pClass As %String) As %String
{
	S tName = ""
	if ($$$comMemberDefined(pClass, $$$cCLASSparameter, "XMLTYPE")) {
			S tName = $$$comMemberKeyGet(pClass,$$$cCLASSparameter,"XMLTYPE",$$$cPARAMdefault)
			S tName = $P(tName, ".", 1)
	}	
	Quit tName
}

ClassMethod IsRequired(pClass As %String, pProp As %String, ByRef pIsRequired As %Boolean, ByRef pIsRepeating As %Boolean)
{
	Set pIsRequired = 0
	Set pIsRepeating = 0
	
	Set p = ##class(%Dictionary.PropertyDefinition).%OpenId(pClass_"||"_pProp)
	
	Set pIsRequired = p.Required
	Set pIsRepeating = $S(p.Collection="list":1, 1:0)
}

ClassMethod GetClassName(pClass As %String, pProp As %String) As %String
{
	Set p = ##class(%Dictionary.PropertyDefinition).%OpenId(pClass_"||"_pProp)
	
	Quit p.Type
}

ClassMethod CompareSchemas(a, b)
{
	
	/* DS */
	s i1=""
	while 1
	{
		s i1=$O(^EnsHL7.Schema(a,"DS",i1))
		q:i1=""
		
		s al=^EnsHL7.Schema(a,"DS",i1)
		
		if $d(^EnsHL7.Schema(b,"DS",i1))=0
		{
			w "Data structure """_i1_""" not defined in "_b,!
			continue
		}
		
		s bl=^EnsHL7.Schema(b,"DS",i1)
		set dif=0
		set:dif=0 dif =($ll(al)'=$ll(bl))
		f i= 1:1:$ll(al)
		{
			q:dif'=0
			s:$p($lg(al,i),a,2)'=$p($lg(bl,i),b,2) dif=1
		}

		w:dif'=0 "Data structure """_i1_""" is different",!
	}
	s i1=""
	while 1
	{
		s i1=$O(^EnsHL7.Schema(b,"DS",i1))
		q:i1=""
		
		if $d(^EnsHL7.Schema(a,"DS",i1))=0
		{
			w "Data structure """_i1_""" not defined in "_a,!
			continue
		}
		
	}
	/* MS */
	s i1=""
	while 1
	{
		s i1=$O(^EnsHL7.Schema(a,"MS",i1))
		q:i1=""
		
		s ms = "Message structure """_i1_""""
		if $d(^EnsHL7.Schema(b,"MS",i1))=0
		{
			w ms_" not defined in "_b ,!
			continue
		}
		
		if ^EnsHL7.Schema(a,"MS",i1,"array")'=^EnsHL7.Schema(b,"MS",i1,"array")
		{
			w ms_" lengths differ",! 
		}
		else 
		{
			for i=1:1:^EnsHL7.Schema(a,"MS",i1,"array")
			{
				if ($p(^EnsHL7.Schema(a,"MS",i1,"array",i,"type"),a,2)'=$p(^EnsHL7.Schema(b,"MS",i1,"array",i,"type"),b,2))
				{
					w ms_" segment structure differs at index "_i,!
					quit
				}
				if ($g(^EnsHL7.Schema(a,"MS",i1,"array",i,"opt"))'=$g(^EnsHL7.Schema(a,"MS",i1,"array",i,"opt")))
				{
					w ms_" segment requirement differs at index "_i,!	
					quit
				}
			}
		}
	}
	while 1
	{
		s i1=$O(^EnsHL7.Schema(b,"MS",i1))
		q:i1=""
		
		s ms = "Message structure """_i1_""""
		if $d(^EnsHL7.Schema(a,"MS",i1))=0
		{
			w ms_" not defined in "_a ,!
			continue
		}
	}
	
	/* MT */
	s i1=""
	while 1
	{
		s i1=$O(^EnsHL7.Schema(a,"MT",i1))
		q:i1=""
		
		s mt = "Message type """_i1_""""
		if $d(^EnsHL7.Schema(b,"MT",i1))=0
		{
			w mt_" not defined in "_b ,!
			continue
		}
	
		if ($p(^EnsHL7.Schema(a,"MT",i1),a,2)'=$p(^EnsHL7.Schema(b,"MT",i1),b,2))
		{
			w mt_" types differ",! 
			continue
		}
		if ($p(^EnsHL7.Schema(a,"MT",i1,"rettype"),a,2)'=$p(^EnsHL7.Schema(b,"MT",i1,"rettype"),b,2))
		{
			w mt_" rettypes differ",! 
			continue
		}
		
	}
	s i1=""
	while 1
	{
		s i1=$O(^EnsHL7.Schema(b,"MT",i1))
		q:i1=""
		
		if $d(^EnsHL7.Schema(a,"MT",i1))=0
		{
			w "Message Type """_i1_""" not defined in "_a,!
			continue
		}
	}
	
	/* SS */
	s i1=""
	while 1
	{
		s i1=$O(^EnsHL7.Schema(a,"SS",i1))
		q:i1=""
		
		s ss = "Segment structure type """_i1_""""
		if $d(^EnsHL7.Schema(b,"SS",i1))=0
		{
			w ss_" not defined in "_b ,!
			continue
		}
		
		if ($ll(^EnsHL7.Schema(a,"SS",i1))'=$ll(^EnsHL7.Schema(b,"SS",i1)))
		{
			w ss_" lengths differ",! 
			continue
		}
		s dif=0
		f i=1:1:$ll(^EnsHL7.Schema(a,"SS",i1))
		{
			
			set dif =$p($li($li(^EnsHL7.Schema(a,"SS",i1),i),1),a,2)'=$p($li($li(^EnsHL7.Schema(b,"SS",i1),i),1),b,2)
			if dif
			{
				w ss_" data types differ at field _"_i,! 
				quit
			}
			f j=2:1:$ll($li(^EnsHL7.Schema(a,"SS",i1),1))
			{
				set dif =$li($li(^EnsHL7.Schema(a,"SS",i1),i),j)'=$li($li(^EnsHL7.Schema(b,"SS",i1),i),j)
				if dif
				{
					w ss_" data structures differ at field "_i,! 
					quit
				}
			
			}
			quit:dif
		}
		continue:dif
		
		s i2=""
		while 1
		{
			s i2=$O(^EnsHL7.Schema(a,"SS",i1,"map",i2))
			q:i2=""
		
			if $g(^EnsHL7.Schema(a,"SS",i1,"map",i2)) '=$g(^EnsHL7.Schema(b,"SS",i1,"map",i2))
			{
				w ss_" field map "_i2_" differ",!
				quit
			}
		}
		
		continue:dif
		
		s i2=""
		while 1
		{
			s i2=$O(^EnsHL7.Schema(a,"SS",i1,"name",i2))
			q:i2=""
		
			if $g(^EnsHL7.Schema(a,"SS",i1,"name",i2)) '=$g(^EnsHL7.Schema(b,"SS",i1,"map",i2))
			{
				w ss_" field name "_i2_" differ",!
				quit
			}
		}
	}
	s i1=""
	while 1
	{
		s i1=$O(^EnsHL7.Schema(b,"SS",i1))
		q:i1=""
		
		if $d(^EnsHL7.Schema(a,"SS",i1))=0
		{
			w "Segment Structure """_i1_""" not defined in "_a,!
			continue
		}
	}
}

}
