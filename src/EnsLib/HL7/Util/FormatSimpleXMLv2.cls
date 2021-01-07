/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

/// Schema-free XML import/export format for HL7 v2 messages
/// Consists only of elements <HL7><Segment><Field><Rep><Component><Subcomponent> along with attributes and content
Class EnsLib.HL7.Util.FormatSimpleXMLv2 Extends (%XML.SAX.ContentHandler, EnsLib.EDI.IOFormatInterface) [ System = 4 ]
{

Parameter ChildLinks = 10;

/// Return 1 if we took care of the whole document or got an error. Returning 0 means the caller will continue doing component segments as usual.
ClassMethod OutputDocument(pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSequenceNumber As %String) As %Boolean
{
	Set pStatus=$$$OK
	
	Set tId=pDocObj.%Id()
	Set tDocType=pDocObj.DocType
	Set tName=pDocObj.Name
	Set tIdent=pDocObj.Identifier
	Set tSegCount=pDocObj.SegCount
	Set tDescription=##class(EnsLib.HL7.Schema).GetDescription("MT:"_pDocObj.MessageTypeCategory_":"_pDocObj.Name)
	Set tSource=$TR(pDocObj.Source,$C(13,10)_"""","||'")

	Do pIOStream.WriteLine("<SimpleHL7v2"_$S(""=tId:"",1:" EnsId="""_tId_"""")_$S(""=tDocType:"",1:" DocType="""_tDocType_"""")_$S(""=tName:"",1:" TypeName="""_tName_"""")_$S(""=tIdent:"",1:" Identifier="""_tIdent_"""")_$S(""=tSegCount:"",1:" SegCount="""_tSegCount_"""")_$S(""=tDescription:"",1:" Description="""_tDescription_"""")_$S(""=tSource:"",1:" Source="""_tSource_"""")_">")  Quit:$$$ISERR(pStatus) 1
	Quit 0 ; let the caller iterate the segments
}

ClassMethod OutputDocumentEnd(pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String)
{
	Do pIOStream.WriteLine("</SimpleHL7v2>",,.pStatus)
	Quit ; no return value
}

/// Return 1 if we took care of the segment or got an error. Returning 0 means the caller will output the segment as usual.
ClassMethod OutputSegment(pSegObj As EnsLib.EDI.Segment, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, ByRef pSequenceNumber As %String) As %Boolean
{
	Do pSegObj.decompose()
	Set tName=pSegObj.Name
	If ""=tName Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't do SimpleHL7v2 XML output of a segment with no name: '"_$E(pSegObj.GetValueAt(),1,1000)_"'") Quit 1
	Set tDocType=pSegObj.DocType
	Set pSegPath=$G(pSegPath) Set:pSegPath=pSegNum pSegPath=""

	Set tReplaceSpec(" ")="&nbsp;"
	Set tReplaceSpec($C(9))="\t"
	Set tReplaceSpec($C(13))="\r"
	Set tReplaceSpec($C(10))="\n"

	Set iCat=$P(tDocType,":"), iSeg=$P(tDocType,":",2)
	Set tDescription=##class(EnsLib.HL7.Schema).GetDescription("SS:"_iCat_":"_iSeg)
	Set iCnt=pSegObj.GetValueAt("*",pSeparators)
	Do pIOStream.Write("<Segment Index="""_pSegNum_""" Name="""_tName_""" FieldCount="""_iCnt_""""_$S(""=tDocType:"",1:" DocType="""_tDocType_"""")_$S(""=pSegPath:"",1:" SegPath="""_pSegPath_"""")_$S(""=tDescription:"",1:" Description="""_tDescription_"""")_">",,.pStatus)  Quit:$$$ISERR(pStatus)

	Set tIndent=pIOStream.LineTerminator_$C(9), tElem=0
	For i=1:1:iCnt {
		If $Case(tName,"MSH":1,"FHS":1,"BHS":1,:0) && (i<=2) {
			Do pIOStream.Write(tIndent_"<Field Index="""_i_""">"_$ZCVT(pSegObj.GetValueAt(i,pSeparators),"O","XML")_"</Field>",,.pStatus)  Quit:$$$ISERR(pStatus)
			Continue
		}
		Continue:""=pSegObj.GetValueAt(i)
		Do pIOStream.Write(tIndent_"<Field Index="""_i_""">",,.pStatus)  Quit:$$$ISERR(pStatus)
		Set rCnt=pSegObj.GetValueAt(i_"(*)")
		Set:rCnt>1 tIndent=tIndent_$C(9)
		For r=1:1:rCnt {
			Set rAlias=i_"("_r_")"
			Continue:""=pSegObj.GetValueAt(rAlias)
			If rCnt>1 Do pIOStream.Write(tIndent_"<Rep Index="""_r_""">",,.pStatus)  Quit:$$$ISERR(pStatus)
			Set cCnt=pSegObj.GetValueAt(i_"("_r_").*")
			Set:cCnt>1 tIndent=tIndent_$C(9)
			For c=1:1:cCnt {
				Set cAlias=rAlias_"."_c
				Continue:""=pSegObj.GetValueAt(cAlias,pSeparators)
				If cCnt>1 Do pIOStream.Write(tIndent_"<Component Index="""_c_""">",,.pStatus)  Quit:$$$ISERR(pStatus)
				Set sCnt=pSegObj.GetValueAt(cAlias_".*",pSeparators)
				Set:sCnt>1 tIndent=tIndent_$C(9)
				For s=1:1:sCnt {
					Set sAlias=cAlias_"."_s
					Set tVal=pSegObj.GetValueAt(sAlias,pSeparators)
					Continue:""=tVal
					If sCnt>1 Do pIOStream.Write(tIndent_"<Subcomponent Index="""_s_""">",,.pStatus)  Quit:$$$ISERR(pStatus)
					Set tVal=pSegObj.Unescape(tVal)
					If $L(tVal)>25 || (tVal'=$TR(tVal,"<>")) {
						Do pIOStream.Write(tIndent_"<![CDATA["_tVal_"]]>")
					} Else {
						Do pIOStream.Write($ZCVT(tVal,"O","XML"))
						Set tElem=1
					}
					If sCnt>1 Do pIOStream.Write($S(tElem:"",1:tIndent)_"</Subcomponent>",,.pStatus)  Set tElem=0  Quit:$$$ISERR(pStatus)
				} Quit:$$$ISERR(pStatus)
				Set:sCnt>1 tIndent=$E(tIndent,1,*-1)
				If cCnt>1 Do pIOStream.Write($S(tElem:"",1:tIndent)_"</Component>",,.pStatus)  Set tElem=0  Quit:$$$ISERR(pStatus)
			} Quit:$$$ISERR(pStatus)
			Set:cCnt>1 tIndent=$E(tIndent,1,*-1)
			If rCnt>1 Do pIOStream.Write($S(tElem:"",1:tIndent)_"</Rep>",,.pStatus)  Set tElem=0  Quit:$$$ISERR(pStatus)
		} Quit:$$$ISERR(pStatus)
		Set:rCnt>1 tIndent=$E(tIndent,1,*-1)
		Do pIOStream.Write($S(tElem:"",1:tIndent)_"</Field>",,.pStatus)  Set tElem=0  Quit:$$$ISERR(pStatus)
		$$$ASSERTNOLOG(pIOStream.LineTerminator_$C(9)=tIndent)
	} Quit:$$$ISERR(pStatus) 1
	Do pIOStream.WriteLine(pIOStream.LineTerminator_"</Segment>",,.pStatus)
	Quit 1
}

/// Return 1 if we imported the whole document or got an error. Returning 0 means the caller will do its standard parse.
ClassMethod ImportDocument(Output pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, ByRef pConfigItem As %String) As %Boolean
{
	Set pDocObj=$$$NULLOREF, tHandler=..%New()
	Merge tHandler.%Context=pConfigItem
	Set pStatus=##class(%XML.SAX.Parser).ParseStream(##class(%IO.LibraryStream).%New(pIOStream),tHandler)  Quit:$$$ISERR(pStatus) 1
	Quit:$$$ISERR(pStatus) 1
	Quit:'$IsObject(tHandler.%DocObj)||'tHandler.%DocObj.%Extends("EnsLib.HL7.Message") $$$ERROR($$$EnsErrGeneral,"No SimpleHL7v2 object found in stream "_pIOStream.Name)
	Set pDocObj=tHandler.%DocObj
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
	For i=0:1:$LL(attrs)\5-1 Set attribs($LI(attrs,i*5+2))=$LI(attrs,i*5+5)
	If localname="SimpleHL7v2" {
		Do:$IsObject(..%DocObj) ..fault("More than one SimpleHL7v2 element found in stream")
		Set ..%DocObj=##class(EnsLib.HL7.Message).%New()
	} ElseIf localname="Segment" {
		Do:$IsObject(..%SegObj) ..fault("Nested SimpleHL7v2 Segment element found in stream")
		Set ..%SegObj=##class(EnsLib.HL7.Segment).%New()
		If $IsObject(..%DocObj) {
			Set ..%SegObj.Separators = ..%DocObj.Separators
			Set tSC=..%DocObj.setSegmentByIndex(..%SegObj,attribs("Index"),0)
		} Else {
			Set ..%SegObj.Separators = $G(attribs("Separators"))
			Set ..%DocObj=..%SegObj
		}
		Do ..%SegObj.SetValueAt(attribs("Name"),0)
		Set ..%SegFields=attribs("FieldCount")
		Set ..%Content=""
	} ElseIf localname="Field" {
		Set ..%FieldPath=attribs("Index")
		Set ..%Content=""
	} ElseIf localname="Rep" {
		Set ..%FieldPath=..%FieldPath_"("_attribs("Index")_")"
		Set ..%Content=""
	} ElseIf localname="Component" {
		Set ..%FieldPath=..%FieldPath_"."_attribs("Index")
		Set ..%Content=""
	} ElseIf localname="Subcomponent" {
		Set ..%FieldPath=..%FieldPath_"."_attribs("Index")
		Set ..%Content=""
	}
	Quit
}

Method endElement(uri As %Library.String, localname As %Library.String, qname As %Library.String)
{
	If localname="SimpleHL7v2" {
		Quit
	} ElseIf localname="Segment" {
		Do:..%SegFields>..%SegObj.GetValueAt("*") ..%SegObj.SetValueAt("",..%SegFields)
		Set tSC=..%SegObj.SaveData()
		Do:$$$ISERR(tSC) ..faultStatus(tSC)
		Set ..%SegFields=""
		Set ..%SegObj=$$$NULLOREF
		Set ..%LastLevel=""
		Quit
	}
	Set tLevel=$Case(localname,"Field":1,"Rep":2,"Component":3,"Subcomponent":4,:"")
	If tLevel>=..%LastLevel {
		If $Case(..%SegObj.Name,"MSH":0,"FHS":0,"BHS":0,:1) || (..%FieldPath>2) {
			Set tSC=..%SegObj.SetValueAt(..%SegObj.Escape(..%Content),..%FieldPath), ..%Content=""
			Do:$$$ISERR(tSC) ..faultStatus(tSC)
		} ElseIf $IsObject(..%DocObj) && (..%DocObj'=..%SegObj) {
			If ..%FieldPath=1 {
				Set ..%DocObj.Separators=$E(..%Content)_$E(..%DocObj.Separators,2,*)
			} Else {
				Set ..%DocObj.Separators=$E(..%DocObj.Separators,1)_$E(..%Content,1,4)_$E(..%DocObj.Separators,2+$L($E(..%Content,1,4)),*)
			}
		}
	}
	If tLevel=1 {
		Set ..%FieldPath=""
	} ElseIf tLevel=2 {
		Set ..%FieldPath=$P(..%FieldPath,"(")
	} ElseIf tLevel=3 {
		Set ..%FieldPath=$P(..%FieldPath,".")
	} ElseIf tLevel=4 {
		Set ..%FieldPath=$P(..%FieldPath,".",1,2)
	}
	Set ..%LastLevel=tLevel
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
