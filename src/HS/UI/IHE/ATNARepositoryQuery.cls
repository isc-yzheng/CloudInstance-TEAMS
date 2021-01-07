/// For use at connectathons, for others to be able to query our repository
Class HS.UI.IHE.ATNARepositoryQuery Extends HS.UI.Base [ DependsOn = HS.UI.Custom.textList ]
{

/// Security requirement
Parameter RESOURCE = "%HS_TestSuite";

/// Displayed name of this page.
Parameter PAGENAME = "ATNA Repository Query";

/// Domain used for localization.
Parameter DOMAIN = "HS";

XData Style
{
<style type="text/css">

/* default body style */
body {
	font-family: arial;
	background: #F0F0F0;
}

</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page id="idPage" 
xmlns="http://www.intersystems.com/zen" 
xmlns:hs="http://www.intersystems.com/zen/hs"
containerStyle="background:white;" 
cellStyle="background:white;" 
title="ATNA Repository Query"
>
<hgroup cellAlign="left" align="left" valign="top" id="formGroup" >
<vgroup labelPosition="left" cellStyle="padding:2px" valign="top" align="left" cellAlign="left" width="50%">
<dataCombo 
id="idInboundIP"
label="Inbound IP Address**: "
sql="select distinct value from HS_IHE_ATNA_Repository.CustomPair where name='AuditRecord:InboundIP' UNION SELECT '(Missing)' as value order by value"
dropdownWidth="400"
size="50"
maxRows="10000"
/>
<dataCombo 
id="idEventType"
label="Event Type**: "
sql="select distinct eventtype from HS_IHE_ATNA_REPOSITORY.Aggregation"
dropdownWidth="400"
size="50"
/><dateText id="idFrom" label="From Time*: " showTime="true" size="50"/>
<text id="idAuditSource" label="Audit Source ID:~ " size="50" />
</vgroup>
<spacer width="10"/>
<vgroup labelPosition="left" cellStyle="padding:2px" valign="top" align="left" cellAlign="left" width="50%">
<hs:textList
label="User: "
id="idUser"
entity="User"
sql="select distinct username from HS_IHE_ATNA_REPOSITORY.Aggregation"
allowMultiple="false"
listHeight="400"
width="45"
/>
<dateText id="idThru" label="Thru Time: " showTime="true" size="45" />
<text id="idSourceNet" label="Source NW Access Pt ID:~ " size="45" />
<select id="idMessageType" value="DICOM" valueList="DICOM,RFC3881" label="Message Type: " showEmpty="false" />
</vgroup>
</hgroup>
<hgroup cellStyle="padding:5px" cellAlign="left" >
<button id="btnSearch" caption="Search" align="left" onclick="zenPage.refreshEventList();"/>
<spacer width="100"/>
<label label="**: Either Inbound IP or Event Type is required.  *: From Time is Required. ~: Enter SQL Like"/>
</hgroup>
<tableNavigatorBar showFilter="false" showPageSize="true" tablePaneId="idEventList"/>
<tablePane id="idEventList" queryClass="HS.UI.IHE.ATNARepositoryQuery" queryName="ListEvents"
maxRows="1000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.rowSelected(zenThis);"
pageSize="10"
useSnapshot="true"
>
<parameter/>
<parameter/>
<parameter/>
<parameter/>
<parameter/>
<parameter/>
<parameter/>
<parameter/>
</tablePane>
<label label="Copy the source of the iframe below to get your audit message"/>
<iframe id="idATNAExport" width="100%" height="1000px" scrolling="yes">
</iframe>
</page>
}

Method ParmChanged(pParm, pValue) [ ZenMethod ]
{
	Set %session.Data(pParm)=pValue
}

ClientMethod refreshEventList() [ Language = javascript ]
{
	zen('idATNAExport').setProperty('src','');
	zen('idEventList').parameters[0].value = zen('idEventType').value ;
	zen('idEventList').parameters[1].value = zen('idUser').value ;
	zen('idEventList').parameters[2].value = zen('idFrom').value ;
	zen('idEventList').parameters[3].value = zen('idThru').value ;
	zen('idEventList').parameters[4].value = zen('idAuditSource').value ;
	zen('idEventList').parameters[5].value = zen('idSourceNet').value ;
	zen('idEventList').parameters[6].value = zen('idInboundIP').value ;
	zen('idEventList').parameters[7].value = zen('idMessageType').value ;
	zen('idEventList').executeQuery() ;
}

ClientMethod rowSelected(table) [ Language = javascript ]
{
	var index = table.getProperty('value');
	zenPage.EventSelected(index) ;
}

Method EventSelected(pID) [ ZenMethod ]
{
	///
	Quit:'pID
	Set tQuery("LogId")=pID, tQuery("CSPShare")=1, tQuery("ATNAMessageType")=..%GetComponentById("idMessageType").value
	If ##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance() {
		Set tLink=..Link("HS.UI.Reports.FetchDocumentAudit.cls",.tQuery)
		Set ..%GetComponentById("idATNAExport").src=tLink
	} Else {
		/// For IRIS For Health / HealthConnect retrieve audit message using method
		If tQuery("ATNAMessageType")="RFC3881" {
			Set tSC=##class(HS.IHE.ATNA.Repository.AggregationToAuditMessage).Convert(pID,.tString)
		} Else {
			Set tSC=##class(HS.IHE.ATNA.Repository.AggregationToDICOMAuditMessage).Convert(pID,.tString)
		}
		Set tURL=""
		Set tBody = "<body>"
		If $G(%request.CgiEnvs("QUERY_STRING"))=""{
			Set tURL = "http"_$S(%request.CgiEnvs("SERVER_PORT_SECURE"):"s",1:"")_"://"_
				$g(%request.CgiEnvs("SERVER_NAME"))_$S($G(%request.CgiEnvs("SERVER_PORT"))="":"",1:":"_%request.CgiEnvs("SERVER_PORT"))_
				%request.Application_..%ClassName(1)_ ".cls?ID="_pID
			Set tBody = tBody_"<a href="_tURL_">"_tURL_"</a><br>"
		}
		//Set tURL = "http://intersystems16.ihe-europe.net/csp/atna/"_..%ClassName(1)_".cls?ID="_pID
		Set tBody = tBody_$zcvt(tString,"O","HTML")_"</body>"
		Set ..%GetComponentById("idATNAExport").src="javascript:'"_tBody_"'"
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set ..%GetComponentById("idFrom").value = $ZD($H,3)_" 01:00:00"
	If $IsObject($g(%request)) && ($D(%request.Data("ID",1))) {
		Do ..EventSelected(%request.Data("ID",1))
	}
	Quit $$$OK
}

Query ListEvents(EventType As %String, UserName As %String, FromTime As %TimeStamp, ThruTime As %TimeStamp, AuditSource As %String, SourceNWAccess As %String, InboundIP As %String, MessageType As %String) As %Query(ROWSPEC = "ID:%String,Date & Time:%TimeStamp,User:%String,Event:%String,Audit Source:%String,Source NW Access:%String,Destination NW Access:%String")
{
}

ClassMethod ListEventsExecute(ByRef qHandle As %Binary, EventType As %String, UserName As %String, FromTime As %String, ToTime As %String, AuditSource As %String, SourceNWAccess As %String, InboundIP As %String, MessageType As %String) As %Status
{
	Set tSQL="SELECT A.%ID,LocalDateTime,UserName,EventCodes,AuditSourceID,SourceNetworkAccess,DestinationNetworkAccess FROM HS_IHE_ATNA_Repository.Aggregation A"
	Set tParms=0, tCond=""
	If InboundIP="(Missing)" {
		Set tCond=" WHERE Not Exists(Select * From HS_IHE_ATNA_Repository.CustomPair C Where C.AggregationID=A.ID AND C.Name='AuditRecord:InboundIP')"
	} ElseIf InboundIP'="" {
		Set tSQL=tSQL_", HS_IHE_ATNA_Repository.CustomPair C"
		Set tCond=" WHERE C.AggregationID=A.ID AND C.Name='AuditRecord:InboundIP' AND C.Value= ?"
		Set tParms($I(tParms))=InboundIP
	}
	Do ..addCondition(.tCond,EventType,"EventType","=",.tParms)
	Do ..addCondition(.tCond,UserName,"UserName","=",.tParms)
	Do ..addCondition(.tCond,FromTime,"LocalDateTime",">=",.tParms)
	Do ..addCondition(.tCond,ToTime,"LocalDateTime","<=",.tParms)
	Do ..addCondition(.tCond,AuditSource,"AuditSourceID"," LIKE ",.tParms)
	Do ..addCondition(.tCond,SourceNWAccess,"SourceNetworkAccess"," LIKE ",.tParms)
	Set tParms($I(tParms)) = MessageType, tCond=tCond_" AND (ATNAMessageType = ? OR ATNAMessageType IS NULL)"
	If (EventType=""&(InboundIP=""))||(FromTime="") Set tCond=" WHERE %ID=-1" //disable unless mandatory parms included
	Set tSQL=tSQL_" "_tCond_" Order By LocalDateTime"
	Set tStatement=##Class(%SQL.Statement).%New()
	Set tSC=tStatement.%Prepare(tSQL) Quit:$$$ISERR(tSC) tSC
	Set tRes=tStatement.%Execute(tParms...)
	Set qHandle=tRes
	Quit $$$OK
}

ClassMethod addCondition(tCond, tValue, pField, pOp, pParams)
{
	Quit:tValue=""
	If tCond="" {Set tCond=" WHERE "}
	Else {Set tCond=tCond_" AND "}
	Set tCond=tCond_"("_pField_" "_pOp_" ?)"
	Set pParams($I(pParams)) = tValue
	Quit
}

ClassMethod ListEventsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListEventsExecute ]
{
	Quit $$$OK
}

ClassMethod ListEventsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListEventsExecute ]
{
	Set Row=""
	If 'qHandle.%Next() Set AtEnd=1 Quit $$$OK
	For tIdx=1:1:7 Set Row=Row_$lb(qHandle.%GetData(tIdx))
	Quit $$$OK
}

}
