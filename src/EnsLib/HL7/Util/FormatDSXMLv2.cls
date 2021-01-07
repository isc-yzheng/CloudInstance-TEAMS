/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

/// XML import/export format of HL7 v2 messages<br>
/// Consists of Data Structure tags around data.
/// <EXAMPLE>
/// <hl7:DFT_P03 xmlns:hl7="urn:hl7-org:v2xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
/// <hl7:MSH><hl7:MSH.1></hl7:MSH.1><hl7:MSH.2></hl7:MSH.2><hl7:MSH.3><hl7:HD.1><hl7:IS.1>Unity</hl7:IS.1></hl7:HD.1></hl7:MSH.3><hl7:MSH.4><hl7:HD.1><hl7:IS.1>OptiGlomerate Group Ltd.</hl7:IS.1></hl7:HD.1></hl7:MSH.4><hl7:MSH.5><hl7:HD.1><hl7:IS.1>Affinity</hl7:IS.1></hl7:HD.1></hl7:MSH.5><hl7:MSH.6><hl7:HD.1><hl7:IS.1>OctoGlomerate Holdings Inc.</hl7:IS.1></hl7:HD.1></hl7:MSH.6><hl7:MSH.7><hl7:TS.1><hl7:DTM.1>201505281135</hl7:DTM.1></hl7:TS.1></hl7:MSH.7>
/// </EXAMPLE>
/// Namespace is set to hl7<br>
/// The Data Structure for OBX:5 is obtained from OBX:2
Class EnsLib.HL7.Util.FormatDSXMLv2 Extends (%XML.SAX.ContentHandler, EnsLib.EDI.IOFormatInterface) [ System = 4 ]
{

Parameter ChildLinks = 10;

Parameter DefaultNSPDeclarations = "xmlns:hl7='urn:hl7-org:v2xml' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'";

Parameter DefaultNSP = "hl7";

/// Return 1 if we took care of the whole document or got an error. Returning 0 means the caller will continue doing component segments as usual.
ClassMethod OutputDocument(pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSequenceNumber As %String) As %Boolean
{
	Set pStatus=$$$OK
	
	Set tName=$piece(pDocObj.Name,"_",1,2)

	set tCat=pDocObj.DocTypeCategory
	set tSchemaDescription=$tr($G(^EnsHL7.Description(tCat),..#DefaultNSPDeclarations),"'","""")

	// The Root Tag is derived from the DocType of the message
	Set tRootTag = $P(pDocObj.DocType, ":", 2)

	set tNS=$piece($piece(tSchemaDescription,"="),"xmlns:",2)_":"
	Set tDescription=##class(EnsLib.HL7.Schema).GetDescription("MT:"_tCat_":"_tName)
	set tDescription=$tr(tDescription,"'","""")
	set tTopLevelTag=tNS_tRootTag_" "_tSchemaDescription

	Do pIOStream.WriteLine("<"_tTopLevelTag_">")  Quit:$$$ISERR(pStatus) 1
	Quit 0 ; let the caller iterate the segments
}

ClassMethod OutputDocumentEnd(pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSequenceNumber As %String)
{

	Set tName=$piece(pDocObj.Name,"_",1,2)
	set tCat=pDocObj.DocTypeCategory
	set tSchemaDescription=$tr($G(^EnsHL7.Description(tCat),..#DefaultNSPDeclarations),"'","""")

	set tNS=$piece($piece(tSchemaDescription,"="),"xmlns:",2)_":"

	Set tRootTag = $P(pDocObj.DocType, ":", 2)
	Do pIOStream.WriteLine("</"_tNS_tRootTag_">",,.pStatus)
	
	Quit
}

/// Return 1 if we took care of the segment or got an error. Returning 0 means the caller will output the segment as usual.
ClassMethod OutputSegment(pSegObj As EnsLib.EDI.Segment, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, ByRef pSequenceNumber As %String) As %Boolean
{
	set tNS=..#DefaultNSP_":"
	Set tName=pSegObj.Name
	If ""=tName Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't do HL7v2 XML output of a segment with no name: '"_$E(pSegObj.GetValueAt(),1,1000)_"'") Quit 1
	Set tDocType=pParentDoc.DocType
	if '$get(pSeparators) s pSeparators=pSegObj.Separators

	Set tReplaceSpec(" ")="&nbsp;"
	Set tReplaceSpec($C(9))="\t"
	Set tReplaceSpec($C(13))="\r"
	Set tReplaceSpec($C(10))="\n"

	Set iCat=$P(tDocType,":"), iSeg=tName

	if '##class(EnsLib.HL7.Schema).ElementExists("SS:"_iCat_":"_iSeg) set pStatus=1 quit 1
	Set tDescription=##class(EnsLib.HL7.Schema).GetDescription("SS:"_iCat_":"_iSeg)
	
	
	Do pIOStream.Write("<"_tNS_tName_">",,.pStatus)  Quit:$$$ISERR(pStatus)
	
	Set iCnt=pSegObj.GetValueAt("*",pSeparators)

	For i=1:1:iCnt {
		set tTag1=tName_"."_i
		continue:""=pSegObj.GetValueAt(i)
		Do pIOStream.Write("<"_tNS_tTag1_">",,.pStatus)  Quit:$$$ISERR(pStatus)
		Set rCnt=+(pSegObj.GetValueAt(i_"(*)"))
		if tTag1="MSH.1" s rCnt=1
		if tTag1="MSH.2" s rCnt=1
		// this deals with single or repeating values without subtypes
		for r=1:1:rCnt {
			Set rAlias=i_"("_r_")"
			Set tTag2=$S(tTag1="OBX.5":pSegObj.GetValueAt(2),1:$piece($lg($lg($$$vaSchemaGbl(iCat,"SS",tName),i)),":",2))
			continue:tTag2'=""
			Continue:""=pSegObj.GetValueAt(rAlias)
			Do pIOStream.Write($zcvt(pSegObj.Unescape(pSegObj.GetValueAt(rAlias)),"O","XML"),,.pStatus)  Quit:$$$ISERR(pStatus)
		}
		// this loop deals with datatypes
		For r=1:1:rCnt {
			Set rAlias=i_"("_r_")"
			Set tTag2=$S(tTag1="OBX.5":pSegObj.GetValueAt(2),1:$piece($lg($lg($$$vaSchemaGbl(iCat,"SS",tName),i)),":",2))
			continue:tTag2=""
			Continue:""=pSegObj.GetValueAt(rAlias)
			set tRepeating=$lg($lg($$$vaSchemaGbl(iCat,"SS",tName),i),2)

			Set cCnt=pSegObj.GetValueAt(i_"("_r_").*")

			For c=1:1:cCnt {
				Set cAlias=rAlias_"."_c
				set tTag3=$Select($D($$$vaSchemaGbl(iCat,"DT",$piece(tTag2,"."))):$piece($lg($lg($$$vaSchemaGbl(iCat,"DT",$piece(tTag2,".")),c)),":",2),1:$piece($lg($$$vaSchemaGbl(iCat,"DS",$piece(tTag2,".")),c),":",2))
				Continue:""=pSegObj.GetValueAt(cAlias,pSeparators)
				If (tTag3'="") {
						Set sCnt=pSegObj.GetValueAt(cAlias_".*",pSeparators)
						Do pIOStream.Write("<"_tNS_tTag2_"."_c_">",,.pStatus)  Quit:$$$ISERR(pStatus)

						// last loop is many items or subcomponents
						set tTag4=$Select($D($$$vaSchemaGbl(iCat,"DT",$piece(tTag3,"."))):$piece($lg($lg($$$vaSchemaGbl(iCat,"DT",$piece(tTag3,".")))),":",2),1:$piece($lg($$$vaSchemaGbl(iCat,"DS",$piece(tTag3,".")),1),":",2))
						if (tTag4'="") {
							Set tTag3=$piece(tTag3,".")_"."_1
							Do pIOStream.Write("<"_tNS_tTag3_">",,.pStatus)  Quit:$$$ISERR(pStatus)

							for sub=1:1:sCnt {
								set tTag4=$piece(tTag4,".")_"."_sub
								Set sAlias=cAlias_"."_sub
								Do pIOStream.Write("<"_tNS_tTag4_">",,.pStatus)  Quit:$$$ISERR(pStatus)							
								Do pIOStream.Write($zcvt(pSegObj.Unescape(pSegObj.GetValueAt(sAlias)),"O","XML"),,.pStatus)  Quit:$$$ISERR(pStatus)
								Do pIOStream.Write("</"_tNS_tTag4_">",,.pStatus)  Quit:$$$ISERR(pStatus)
							}
							Do pIOStream.Write("</"_tNS_tTag3_">",,.pStatus)  Quit:$$$ISERR(pStatus)
							Do pIOStream.Write("</"_tNS_tTag2_"."_c_">",,.pStatus)  Quit:$$$ISERR(pStatus)
						}
						else {

						For s=1:1:sCnt {
							Set sAlias=cAlias_"."_s
							Set tVal=pSegObj.GetValueAt(sAlias,pSeparators)
							Continue:""=tVal

							set tTag3=$piece(tTag3,".")_"."_s
							Do pIOStream.Write("<"_tNS_tTag3_">",,.pStatus)  Quit:$$$ISERR(pStatus)
							Do pIOStream.Write($zcvt(pSegObj.Unescape(pSegObj.GetValueAt(sAlias)),"O","XML"),,.pStatus)  Quit:$$$ISERR(pStatus)
							Do pIOStream.Write("</"_tNS_tTag3_">",,.pStatus)  Quit:$$$ISERR(pStatus)
						} Quit:$$$ISERR(pStatus)
							Do pIOStream.Write("</"_tNS_tTag2_"."_c_">",,.pStatus)  Quit:$$$ISERR(pStatus)
						}
				}
				else {
						Set tTag3=$piece(tTag2,".")_"."_c
						Do pIOStream.Write("<"_tNS_tTag3_">",,.pStatus)  Quit:$$$ISERR(pStatus)
						Do pIOStream.Write($zcvt(pSegObj.Unescape(pSegObj.GetValueAt(cAlias)),"O","XML"),,.pStatus)  Quit:$$$ISERR(pStatus)
						Do pIOStream.Write("</"_tNS_tTag3_">",,.pStatus)  Quit:$$$ISERR(pStatus)
				}

			} Quit:$$$ISERR(pStatus)
			if ((tRepeating="")||("+*"'[tRepeating)) {
					set tTag2=""
			}
			If ((r<rCnt)) {
				Do pIOStream.Write("</"_tNS_tTag1_">",,.pStatus)  Quit:$$$ISERR(pStatus)
				Do pIOStream.Write("<"_tNS_tTag1_">",,.pStatus)  Quit:$$$ISERR(pStatus)
			}
		} Quit:$$$ISERR(pStatus)
		
		Do pIOStream.Write("</"_tNS_tTag1_">",,.pStatus)  Quit:$$$ISERR(pStatus)
	} Quit:$$$ISERR(pStatus) 1
	Do pIOStream.WriteLine("</"_tNS_tName_">",,.pStatus)
	Quit 1
}

/// Return 1 if we imported the whole document or got an error. Returning 0 means the caller will do its standard parse.
/// Must pass Schema value in the pConfigItem array.  For example:  set pConfigItem="2.4"
ClassMethod ImportDocument(Output pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, ByRef pConfigItem As %String) As %Boolean
{
	set pConfigItem("Schema") = $piece(pConfigItem,":",1)

	if '$data(pConfigItem("Schema")) quit $$$ERROR($$$GeneralError,"No schema to associate with document")
	Set pDocObj=$$$NULLOREF, tHandler=..%New()
	Merge tHandler.%Context=pConfigItem
	Set pStatus=##class(%XML.SAX.Parser).ParseStream(##class(%IO.LibraryStream).%New(pIOStream),tHandler)  Quit:$$$ISERR(pStatus) 1
	Quit:$$$ISERR(pStatus) 1
	Quit:'$IsObject(tHandler.%DocObj)||'tHandler.%DocObj.%Extends("EnsLib.HL7.Message") $$$ERROR($$$EnsErrGeneral,"No SimpleHL7v2 object found in stream "_pIOStream.Name)
	Set pDocObj=tHandler.%DocObj

	// default DocType to MSH:12 _":"_ MSH:9.3.  Must add more code if these values are not found. 
	do pDocObj.PokeDocType(pDocObj.GetValueAt("1:12")_":"_pDocObj.GetValueAt("1:9.3"))

	// Try to set it to schema as sent in pConfigItem
	set tType=pDocObj.GetValueAt("1:9.1")_"_"_pDocObj.GetValueAt("1:9.2")
	set tSchema=pConfigItem("Schema")

	if (tType'="") {
		set tMessageStructure=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType(tSchema,tType)
	}
	if (tMessageStructure'="") {
		do pDocObj.PokeDocType(tMessageStructure)
	}
	Quit 1
}

/// Return 1 if we imported a segment or got an error. Returning 0 means the caller will do its standard parse.
ClassMethod ImportSegment(Output pSegObj As EnsLib.EDI.Segment, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, ByRef pSeparators As %String) As %Boolean
{
	Set pSegObj=$$$NULLOREF, tHandler=..%New()
	Merge tHandler.%Context=pSeparators
	Set pStatus=##class(%XML.SAX.Parser).ParseStream(##class(%IO.LibraryStream).%New(pIOStream),tHandler)  Quit:$$$ISERR(pStatus) 1
	Set pStatus=tHandler.Error
	Quit:$$$ISERR(pStatus) 1
	Quit:'$IsObject(tHandler.%DocObj)||'tHandler.%DocObj.%Extends("EnsLib.HL7.Segment") $$$ERROR($$$EnsErrGeneral,"No SimpleHL7v2 segment object found in stream "_pIOStream.Name)
	Set pSegObj=tHandler.%DocObj
	Quit 1
}

/* SAX parser properties and methods used by Import... */
Property %Context As %String [ MultiDimensional ];

Property %DocObj As EnsLib.EDI.Document;

Property %SegObj As EnsLib.EDI.Segment;

Property %SegFields As %Integer;

Property %FieldPath As %String;

Property %LastLevel As %Integer;

Property %Content As %String;

Property %InCData As %Integer [ InitialExpression = 0 ];

Method startElement(uri As %Library.String, localname As %Library.String, qname As %Library.String, attrs As %Library.List)
{
	if localname[":" set localname=$piece(localname,":",2)

	set tSchema=$get(..%Context("Schema"))
	If $data($$$vaSchemaGbl(tSchema,"MT",localname)) {
		Do:$IsObject(..%DocObj) ..fault("More than one message found in stream")
		Set ..%DocObj=##class(EnsLib.HL7.Message).%New()
	} ElseIf $data($$$vaSchemaGbl(tSchema,"SS",localname)) {
		if (localname="MSH") {
			set ..%SegObj=..%DocObj.getSegmentByIndex(1)
		}
		else {
			Set ..%SegObj=##class(EnsLib.HL7.Segment).%New()
			If $IsObject(..%DocObj) {
			Set ..%SegObj.Separators = ..%DocObj.Separators
			Set tSC=..%DocObj.setSegmentByIndex(..%SegObj,(..%DocObj.SegCount)+1,0)
			Do ..%SegObj.SetValueAt(localname,0)
			}
		}

		Set ..%SegFields=0
		Set ..%Content=""
		set ..%FieldPath=""
	} ElseIf ($data($$$vaSchemaGbl(tSchema,"SS",$piece(localname,".")))&&(+$piece(localname,".",2)>0)) {
		set ..%SegFields=$piece(localname,".",2)
		// schema defines more than one item per field
		if ("+*"[$lg($lg($$$vaSchemaGbl(tSchema,"SS",..%SegObj.Name),..%SegFields),2)) {
			if (..%SegFields > ..%LastLevel)
				{
					set ..%FieldPath=""
				}
			if ..%FieldPath["("  {
				Set ..%FieldPath=..%SegFields_"("_($piece($piece(..%FieldPath,"(",2),")")+1)_")"
			}
			else  {
				set ..%FieldPath=..%SegFields_"(1)"
			}
		}
		else {
			Set ..%FieldPath=..%SegFields
		}
		Set ..%Content=""
	} Elseif ($data($$$vaSchemaGbl(tSchema,"DT",$piece(localname,"."))) || $data($$$vaSchemaGbl(tSchema,"DS",$piece(localname,".")))) {
			Set ..%FieldPath=..%FieldPath_"."_$piece(localname,".",2)
			set ..%Content=""
	}

	Quit
}

Method endElement(uri As %Library.String, localname As %Library.String, qname As %Library.String)
{
	if localname[":" set localname=$piece(localname,":",2)

	set tSchema=$get(..%Context("Schema"))

	If $data($$$vaSchemaGbl(tSchema,"MT",$piece(localname,"."))) {
		Quit
	} ElseIf $data($$$vaSchemaGbl(tSchema,"SS",localname)) {
		Set tSC=..%SegObj.SaveData()
		Do:$$$ISERR(tSC) ..faultStatus(tSC)
		Set ..%SegFields=""
		Set ..%SegObj=$$$NULLOREF
		Set ..%LastLevel=0
		Quit
	}
	
	/* Identify a sub component */
	If $length(..%FieldPath,".")=4 {
		Set tFieldPath = $P(..%FieldPath,".",1,2)_"."_$P(..%FieldPath,".",4)
	} Else {
		Set tFieldPath = ..%FieldPath	
	}
	
	If (..%SegObj.GetValueAt(tFieldPath)="") {
		Set tSC=..%SegObj.SetValueAt(..%SegObj.Escape($zstrip(..%Content,"*C")),tFieldPath), ..%Content=""
		Do:$$$ISERR(tSC) ..faultStatus(tSC)
	}

	If ($data($$$vaSchemaGbl(tSchema,"SS",localname))) {
		set ..%FieldPath=""
	}
	If ($data($$$vaSchemaGbl(tSchema,"SS",$piece(localname,".")))&&(+$piece(localname,".",2)>0)) {
		set ..%LastLevel=+$piece(localname,".",2)
	}
	if ($data($$$vaSchemaGbl(tSchema,"DT",$piece(localname,"."))) || $data($$$vaSchemaGbl(tSchema,"DS",$piece(localname,".")))) {
			set tLength=1
			if $length(..%FieldPath,".")>1 set tLength=$length(..%FieldPath,".")-1
			Set ..%FieldPath=$piece(..%FieldPath,".",1,tLength)

	}
}

Method characters(chars As %Library.String, length As %Library.Integer)
{
	If ..%InCData=1 {
		Set ..%Content=..%Content_$E(chars,1,length)
	} Else {
		Set ..%Content=..%Content_$ZCVT($E(chars,1,length),"I","XML")
	}
}

Method startCDATA()
{
	Set ..%InCData=1
	Set ..%Content=""
}

Method endCDATA()
{
	Set ..%InCData=0
}

Method startEntity(name As %String)
{
	Quit
}

Method endEntity(name As %String)
{
	Quit
}

Method fault(text As %String)
{
	Set %objlasterror=$$$ERROR($$$EnsErrGeneral,text)
	ZTRAP "HL7v2"
}

Method faultStatus(status As %Status)
{
	Set %objlasterror=status
	ZTRAP "HL7v2"
}

}
