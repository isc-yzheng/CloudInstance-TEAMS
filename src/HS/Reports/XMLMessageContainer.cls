Include Ensemble

Class HS.Reports.XMLMessageContainer Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

ClassMethod ReturnReportData(pReportRequest As HS.Message.ReportRequest) As HS.Reports.XMLMessageContainer
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	Set tResponse=##Class(HS.Reports.XMLMessageContainer).%New()
	Do {
		Set tempnum=$I(^CacheTemp.HS.ReportCriteria)
		Set tG="^CacheTemp.HS.ReportCriteria("_tempnum_")"
		//de-serialize criteria
		#dim tCond As HS.Reports.SerialCondition
		For tI=1:1:pReportRequest.BooleanConditions.Count() {
			Set @tG@(0,pReportRequest.BooleanConditions.GetAt(tI))=1
		}
		For tI=1:1:pReportRequest.ComparisonConditions.Count() {
			Set tCond=pReportRequest.ComparisonConditions.GetAt(tI)
			Set @tG@(1,tCond.FieldName)=$LB(tCond.ValueInternal,tCond.ValueDisplay)
		}
		For tI=1:1:pReportRequest.InlistConditions.Count() {
			Set tCond=pReportRequest.InlistConditions.GetAt(tI)
			Set @tG@(2,tCond.FieldName,tCond.ValueInternal)=tCond.ValueDisplay
		}
		//Generate the XML data
		Set tRname=pReportRequest.ReportClass
		Set:$E(tRname,$L(tRname)-3,999)=".cls" tRname=$E(tRname,1,$L(tRname)-4)
		Set tReport=$zobjclassmethod(tRname,"%New")
		Set tReport.CriteriaNum=tempnum
		Merge tReport.Criteria=@tG
		Set tReport.Criteria=""
		Set tFileName=##Class(%File).TempFilename($CASE(pReportRequest.ContentType,"HTML":"HTML","PDF":"PDF",:"XML")), tIO=$IO
		IF $P(pReportRequest.ContentType,".")="Excel" {
			Set tSC=tReport.GenerateReport(tFileName,7,,,$P(pReportRequest.ContentType,".",2))
		} Else {
			Set tSC=tReport.GenerateReport(tFileName,$CASE(pReportRequest.ContentType,"HTML":1,"PDF":2,:0))
		}
		Quit:$$$ISERR(tSC)
		Set tFile=##class(%FileBinaryStream).%New()
		Set tFile.Filename=tFileName
		IF pReportRequest.ContentType="XML"||($P(pReportRequest.ContentType,".")="Excel") {
			Set tSC=tResponse.XMLData.CopyFrom(tFile)
		} ElseIf pReportRequest.ContentType="HTML" {
			Set tSC=tResponse.HTMLData.CopyFrom(tFile)
		} Else {
			Set tSC=tResponse.BinaryData.CopyFrom(tFile)
		}
	} While 0
Exit
	// Remove the temporary file if it was created (the error may have occurred before that point)
	if $Data(tFileName) && ($G(^CacheTemp.ZEN("DebugZen","NoDelete"))'=1) d ##class(%File).Delete(tFileName)
	Set tResponse.Status=tSC Quit tResponse
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Used to return PDF and other binary formats
Property BinaryData As %GlobalBinaryStream;

/// Used to Return various XML formats - SDA, CCD, CCR, etc.
Property XMLData As %GlobalCharacterStream;

/// Used to Return HTML
Property HTMLData As %GlobalCharacterStream;

/// to allow this to be used to pass arbitrary simple message lists
Property StringCollection As list Of %String(MAXLEN = 32000);

Property Status As %Status;

Storage Default
{
<Data name="XMLMessageContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContentStream</Value>
</Value>
<Value name="3">
<Value>StringCollection</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>BinaryData</Value>
</Value>
<Value name="6">
<Value>XMLData</Value>
</Value>
<Value name="7">
<Value>HTMLData</Value>
</Value>
</Data>
<DataLocation>^HS.Reports.XMLMessageC82DED</DataLocation>
<DefaultData>XMLMessageContainerDefaultData</DefaultData>
<IdLocation>^HS.Reports.XMLMessageC82DED</IdLocation>
<IndexLocation>^HS.Reports.XMLMessageC82DEI</IndexLocation>
<StreamLocation>^HS.Reports.XMLMessageC82DES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
