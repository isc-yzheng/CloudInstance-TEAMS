/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Utility Methods for ITK
Class EnsLib.ITK.Util.UtilityMethods Extends %RegisteredObject [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Utility Methods for ITK
   
Update history:
2010-01-18 Added ResolveOpertaionByApplicationName
2011-01-10 Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Query GetDeferredRequestId(pSessionId As %Integer) As %SQLQuery
{
	SELECT ID FROM Ens.MessageHeader
	WHERE sessionid = :pSessionId
	AND status = 6
}

ClassMethod GetDeferredToken(pSessionId As %Integer) As %String
{
	Set tToken = ""

 Set $ZTRAP = "OnError"
	Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Util.UtilityMethods:GetDeferredRequestId")
	Do tResult.Execute(pSessionId)
	While (tResult.Next(.sc)) { 
		Set tToken = tResult.Data("ID")
	}
	
	Set:tToken'="" tToken = tToken _ "|" _ $$$EnsRuntime("Name")
	
	Set $ZTRAP = ""
	
Exit
	Quit tToken
	
OnError
	Set $ZTRAP = ""
	$$$LOGERROR($ZERROR)
	Goto Exit
}

ClassMethod XMLExportExtentToFile(pFilename As %String, pClassName As %String) As %Status
{
    set writer=##class(%XML.Writer).%New()
    set writer.Indent=1
    set status=writer.OutputToFile(pFilename)
   
    set status=writer.RootElement("Root")
    
    Set rset = ##class(%ResultSet).%New(pClassName_":Extent")
    Set status=rset.Execute()
    If $$$ISERR(status) {
        Do $System.Status.DisplayError(status) Quit $$$ERROR()
    }

    While (rset.Next()) {
        Set objid=rset.Data("ID")
        Set obj=$CLASSMETHOD(pClassName, "%OpenId", objid)
        Set status=writer.Object(obj)
        If $$$ISERR(status) {
            Do $System.Status.DisplayError(status) Quit
        }
    }
        
    Do writer.EndRootElement()
    Do writer.EndDocument()

    quit status
}

ClassMethod XMLExportIdListToFile(pFilename As %String, pIDList As %String, pClassName As %String) As %Status
{
    set writer=##class(%XML.Writer).%New()
    set writer.Indent=1
    set status=writer.OutputToFile(pFilename)
   
    set status=writer.RootElement("Root")
    set IDlist= $LISTFROMSTRING(pIDList)
    
    for i=1:1:$LISTLENGTH(IDlist) {
        set objid=$LIST(IDlist, i)
        set obj=$zobjclassmethod(pClassName,"%OpenId",objid)
        if (obj '= "") set status=writer.Object(obj)
    }
 
    set status=writer.EndRootElement()
 
    quit status
}

ClassMethod XMLImportExtentFromFile(pFilename As %String, pClassName As %String, pTag As %String)
{
    // Create an instance of %XML.Reader
    Set reader = ##class(%XML.Reader).%New()
    // Begin processing of the file
    Do reader.OpenFile(pFilename)
    // Associate a class name with the XML element name
    Do reader.Correlate(pTag, pClassName)
    
    // Read objects from xml file
    While (reader.Next(.object,.status)) {
        if (($$$ISOK(status)) && (object '= "")) Do $zobjmethod(object,"%Save")
    }
    
    // If error found during processing, show it
    If $system.Status.IsError(status) do $System.Status.DisplayError(status)
}

ClassMethod XMLImportFromFile(pFilename As %String, pClassName As %String, pTag As %String, ByRef pObject)
{
    // Create an instance of %XML.Reader
    Set reader = ##class(%XML.Reader).%New()
    // Begin processing of the file
    Do reader.OpenFile(pFilename)
    // Associate a class name with the XML element name
    If (pTag '= "") {
	    Do reader.Correlate(pTag, pClassName)
    } Else {
	    Do reader.CorrelateRoot(pClassName)
    }
    
    // Read objects from xml file
    Do reader.Next(.pObject,.status)
    
    // If error found during processing, show it
    If $system.Status.IsError(status) do $System.Status.DisplayError(status)
}

ClassMethod XMLExportToString(obj, pSuppressXmlns As %Boolean = 0) As %String
{
    set writer=##class(%XML.Writer).%New()

    Set writer.SuppressXmlns = pSuppressXmlns 

    set status=writer.OutputToString()
    if $$$ISERR(status) do $System.Status.DisplayError(status) quit $$$ERROR()

    set status=writer.RootObject(obj)
    if $$$ISERR(status) do $System.Status.DisplayError(status) quit $$$ERROR()

    set return=writer.GetXMLString()

    quit return
}

ClassMethod XMLImportFromString(string, class, tag, ByRef object, namespace)
{
   set reader=##class(%XML.Reader).%New()
   set status=reader.OpenString(string)
   if $$$ISERR(status) do $System.Status.DisplayError(status)

   do reader.Correlate(tag, class, namespace)

   do reader.Next(.object,.status, namespace)
   if $$$ISERR(status) do $System.Status.DisplayError(status)
}

/// ITK 2.0 stream may have an DE around it
/// Only used in Validate Content and Queue Collection, but for Queue collection there is no DE so all good.
ClassMethod XMLImportFromStream(stream As %GlobalCharacterStream, class As %String, ByRef object) As %Status
{
   set reader=##class(%XML.Reader).%New()
   set status=reader.OpenStream(stream)
   if $$$ISERR(status) Quit status

   do reader.CorrelateRoot(class)

   do reader.Next(.object,.status)
   if $$$ISERR(status) Quit status
   
   Quit $$$OK
}

ClassMethod ResolveOpertaionByDeviceName(pDeviceName As %String) As %String
{
	Set tOpName = ""

 Set $ZTRAP = "OnError"
	Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Util.UtilityMethods:GetListOfOperation")
	Do tResult.Execute($$$EnsRuntime("Name"))
	While ( (tResult.Next(.sc)) && (tOpName = "")) { 

		Set tAppName = ##class(Ens.Director).GetHostSettingValue($$$EnsRuntime("Name")_"||"_tResult.Get("Name"),"ApplicationName",.tSC)
		; Match on the application name : device name
		
		//Set tDeviceName = $P(tAppName, ":", 2)
		//If (tDeviceName = "") Set tDeviceName = $P(tAppName, ":", 1)
		
		If (pDeviceName = tAppName) {
			Set tOpName = tResult.Get("Name")
		} 
	}
	Set $ZTRAP = ""
	
Exit
	Quit tOpName
	
OnError
	Set $ZTRAP = ""
	$$$LOGERROR($ZERROR)
	Goto Exit
}

ClassMethod ResolveOpertaionByApplicationName(pDeviceName As %String, ByRef pOperations As %ArrayOfDataTypes)
{
 set pOperations= ##class(%ArrayOfDataTypes).%New()

 Set $ZTRAP = "OnError"
	Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Util.UtilityMethods:GetListOfOperation")
	Do tResult.Execute($$$EnsRuntime("Name"))
	While tResult.Next(.sc) { 

		Set tAppName = ##class(Ens.Director).GetHostSettingValue($$$EnsRuntime("Name")_"||"_tResult.Get("Name"),"ApplicationName",.tSC)
		; Match on the application name : *
		
		If (pDeviceName = $P(tAppName,":",1)) {
			do pOperations.SetAt(tAppName,tResult.Get("Name"))
		} 
	}
	Set $ZTRAP = ""
	
Exit
	Quit
	
OnError
	Set $ZTRAP = ""
	$$$LOGERROR($ZERROR)
	Goto Exit
}

ClassMethod BreakURL(pURL As %String, ByRef pProtocol As %String, ByRef pServer As %String, ByRef pPort As %String)
{
	Set pProtocol = $ZCVT($P(pURL, "://", 1), "L")
	
	Set pServerPort = $P( ($P(pURL, "://", 2)) , "/", 1)
	Set pServer = $P(pServerPort, ":", 1)
	Set pPort = $P(pServerPort, ":", 2)
	If (pPort = "") Set pPort = $S(pProtocol="http":80, pProtocol="https":80, 1:0)
}

ClassMethod ResolveOpertaionByURL(pURL As %String) As %String
{
	Set tOpName = ""
	
	Set (tProtocol, tServer, tPort) = ""	
	Do ..BreakURL(pURL, .tProtocol, .tServer, .tPort)
	
	Set (tOpProtocol, tOpServer, tOpPort) = ""

 Set $ZTRAP = "OnError"
 
	Set tResult = ##class(%ResultSet).%New("EnsLib.ITK.Util.UtilityMethods:GetListOfOperation")
	Do tResult.Execute($$$EnsRuntime("Name"))
	While ( (tResult.Next(.sc)) && (tOpName = "")) { 
		
		If ( ($CLASSMETHOD(tResult.Get("ClassName"), "%Extends", "Ens.BusinessOperation")) 
			&& ($$$comMemberDefined(tResult.Get("ClassName"),$$$cCLASSparameter,"ADAPTER")) 
			&& ($$$comMemberKeyGet(tResult.Get("ClassName"),$$$cCLASSparameter,"ADAPTER",$$$cPARAMdefault) '= "") ) {
				
			Set tOpURL = ##class(Ens.Director).GetHostSettingValue($$$EnsRuntime("Name")_"||"_tResult.Get("Name"),"EndpointBaseURL",.tSC)
			
			Do ..BreakURL(tOpURL, .tOpProtocol, .tOpServer, .tOpPort)
		
			If ((tProtocol = tOpProtocol) && (tServer = tOpServer) && (tPort = tOpPort)) {
				Set tOpName = tResult.Get("Name")
			}
		}
	}
	
	Set $ZTRAP = ""
	
Exit
	Quit tOpName
	
OnError
	Set $ZTRAP = ""
	$$$LOGERROR($ZERROR)
	Goto Exit
}

Query GetListOfOperation(pProduction As %String) As %SQLQuery
{
	SELECT * FROM Ens_Config.Item
        WHERE Production = :pProduction
}

ClassMethod GetTimeDiff(pTimeFrom As %String, pTimeTo As %String) As %Integer
{
	Set tDiff = 0
	Set tSecondsInADay = 86400
	
	Set tDateFrom = $P(pTimeFrom, ",", 1)
	Set tTimeFrom = $P(pTimeFrom, ",", 2)
	
	Set tDateTo = $P(pTimeTo, ",", 1)
	Set tTimeTo = $P(pTimeTo, ",", 2)	
	
	Set tDiff = ((tDateTo-tDateFrom)*tSecondsInADay) + (tTimeTo-tTimeFrom)
	
	Quit tDiff
}

ClassMethod ValidateWSMessageId(pMessageId As %String) As %Boolean
{
	Set tStatus = 1
	Set tMessageId = $ZCVT(pMessageId, "U")
	
	// RAH
	if ( '(tMessageId?8UN1"-"4UN1"-"4UN1"-"4UN1"-"12UN)) {
		if ( '(tMessageId?1"UUID:"8UN1"-"4UN1"-"4UN1"-"4UN1"-"12UN)) Quit 0
	}
	// RAH end
	
	Set tMessageId = $P(tMessageId, ":", 2)
	
	//Loop through the message id and ensure each char is > F
	set MessageIdLength = $Length(tMessageId)
	FOR index=1:1:MessageIdLength {
		Set tChar = $E(tMessageId, index)
		if ( (tChar '= "-")  && ('(tChar?1N)) ) {
			If ( ($ASCII(tChar) < $ASCII("A")) || ($ASCII(tChar) > $ASCII("F")) ) {
    			Set tStatus = 0
    			Quit
			}
		}
  	}
	
	Quit tStatus
}

ClassMethod DeleteGlobals(pMask As %String)
{
	Set tName = ""
	
 Set $ZTRAP = "OnError"
	
	Set tResult = ##class(%ResultSet).%New("%SYS.GlobalQuery:NameSpaceList")
	Do tResult.Execute($NAMESPACE, pMask)
	While (tResult.Next(.sc)) { 
		
		Set tName = "^" _ tResult.Data("Name")
		Kill @tName
	}
	
	Set $ZTRAP = ""
	
Exit
	Quit
	
OnError
	Set $ZTRAP = ""
	$$$LOGERROR($ZERROR)
	Goto Exit
}

ClassMethod GetX509SubjectAttribute(pSubjectDN As %String, pField As %String) As %String
{
	Set tVal = ""
	Set tList = $LISTFROMSTRING(pSubjectDN, ",")
	
	If ((tList = "") || ($LL(tList) = 0)) Quit tVal
	
	For i=1:1:$LL(tList) {
		
		If ($P($LIST(tList ,i), "=") = pField) {
			
			Set tVal = $P($LIST(tList ,i), "=", 2)
			
			Quit
		}
	}
	
	Quit tVal
}

ClassMethod GetX509SubjectDNFromAttribute(pSubjectDN As %String, pField As %String) As %String
{
	Set tVal = ""
	Set tList = $LISTFROMSTRING(pSubjectDN, ",")
	
	If ((tList = "") || ($LL(tList) = 0)) Quit tVal
	
	set foundField=0
	For i=1:1:$LL(tList) {
		
		// If we have started or 
		If (foundField=1)||($P($LIST(tList ,i), "=") = pField) {
			if tVal'="" set tVal=tVal_","
			Set tVal = tVal_$P($LIST(tList ,i), "=")_"="_$P($LIST(tList ,i), "=", 2)
			set foundField=1
		}
	}
	
	Quit tVal
}

ClassMethod CNfromDN(dn As %String) As %String
{
	s cn=..GetX509SubjectAttribute(dn,"CN")
	s:cn="" cn=dn
		
	q cn
}

ClassMethod DistinguishedNamesAreEqual(dn1 As %String, dn2 As %String) As %Boolean
{
	s e=1
	q:dn1=dn2 1
	q:$l(dn1,",")'=$l(dn2,",") 0
	f i=1:1:$l(dn1,",") s ta1($ZSTRIP($P($P(dn1,",",i),"="),"<>W"))=$ZSTRIP($P($P(dn1,",",i),"=",2),"<>W")
	f i=1:1:$l(dn2,",") s:$g(ta1($ZSTRIP($P($P(dn2,",",i),"="),"<>W")))'=$ZSTRIP($P($P(dn2,",",i),"=",2),"<>W") e=0 q:e=0
	q e
}

ClassMethod ImportWSDL(pFilePath As %String, pClientPackage As %String, pServicePackage As %String) As %Status
{
	Set tSC = $$$OK
	
	If (($G(pServicePackage) = "") || ($G(pClientPackage) = "")) {
		Set tSC = $$$ERROR($$$GeneralError, "Package names for Client and Service classes are required.")
		Quit tSC
	}
	
	If (##class(%File).Exists($G(pFilePath))) {
		
		Set tReader = ##class(EnsLib.ITK.Framework.SOAP.WSDL.Reader).%New()
		
		Set tReader.Debug = 1
		
		Set tReader.MakeClient = 1
		Set tReader.MakeService = 1
		Set tReader.MakePersistent = 1
		Set tReader.MakeRelationships = 0		
		Set tReader.CompileClasses = 1
		Set tReader.MakeNamespace = 1

		Set tReader.ClientPackage = "Test.Client"
		Set tReader.ServicePackage = "Test.Service"
		
		Set tSC = tReader.Process(pFilePath, "Test.Schema")
	} Else {
		Set tSC = $$$ERROR($$$FileNotFound, $G(pFilePath))
	}
	
	Quit tSC
}

ClassMethod CreateGUID(pPrefix As %String = "") As %String
{
	
	Quit pPrefix_$system.Util.CreateGUID()
}

ClassMethod SessionServiceConfigName(sid As %String) As %String
{
	set sbt = $$$eHostTypeService
	&sql(select top 1 SourceConfigName into :scn from Ens.MessageHeader where SourceBusinessType = :sbt and SessionId = :sid)
	Quit scn
}

ClassMethod CreateSkeletonITKRequestMessage(pServiceName As %String, pAction As %String, pInvocationPattern As %String, pSourceApplication As %String, ByRef pStatus As %Status) As EnsLib.ITK.Framework.RequestData
{
	Set pStatus=$$$OK
	
	Set pRequest = ##class(EnsLib.ITK.Framework.RequestData).%New()
	
	set pRequest.ServiceName = pServiceName
	set pRequest.Action = pAction 
	set pRequest.InvocationPattern = pInvocationPattern
	set pRequest.SourceApplication = pSourceApplication
	set pRequest.MessageId = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
	Set dt = $h
	Set pRequest.Created = $ZDT(dt,3)
	Set $P(dt,",",2) = $P(dt,",",2)+900
	Set pRequest.Expires = $ZDT(dt,3)
	Set pRequest.SequenceNumber = $I(^EnsITK.SEQNO)
	Set pRequest.Status=$$$OK
	Quit pRequest
}

ClassMethod GetRelatedMessageId(MessageId As %String, SubscribingDevice As %String)
{
	set cbl = ##class(EnsLib.ITK.Framework.CallBackLog).RequestToResponseIndex(MessageId,SubscribingDevice)
	Quit:'$IsObject(cbl) ""
	Quit cbl.RelatedMessageId
}

}
