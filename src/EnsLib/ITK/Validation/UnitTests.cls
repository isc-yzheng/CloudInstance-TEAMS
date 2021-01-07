/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Validation.UnitTests Extends %UnitTest.TestCase [ System = 4 ]
{

Parameter ACTIONRESPSUFFIX = "Response";

Parameter ADDRESSINGFAULT = "http://www.w3.org/2005/08/addressing/fault";

Parameter ADDRESSINGSOAPFAULT = "http://www.w3.org/2005/08/addressing/soap/fault";

Property Name As %String;

Property SubDir As %String;

Property RequestSync As %Boolean;

Property ResponseSync As %Boolean;

Property Fault As %Boolean;

Method OnBeforeAllTests() As %Status
{
 // Get the root dir for the documents
 //Set ..WorkingDir = $System.Process.CurrentDirectory()
 //do $System.Process.CurrentDirectory($G(^ITKTest("RootDir"),"C:\Users\sshaw\Projects\ITK\170611_Retest_ReqResp\Tests"))
 
 // Setup test parameters
 // Come in list form via UserParam property (Request Sync?, Response Sync?)
 // The name of this test is the last directory
 Set ..Name = ##class(%File).GetDirectoryPiece(..Manager.CurrentDir, ##class(%File).GetDirectoryLength(..Manager.CurrentDir))
 Set ..SubDir = ..fixPath(..fixPath(..Manager.UserParam.GetAt("RootDir"))_..Name)
 Set ..RequestSync = $List(..Manager.UserParam.GetAt(..Name),1)
 Set ..ResponseSync = $List(..Manager.UserParam.GetAt(..Name),2)
 Set ..Fault = $ListData(..Manager.UserParam.GetAt(..Name),3) && $List(..Manager.UserParam.GetAt(..Name),3)
 
 // Now read in the tkw request / response logs
 Set %tkw1 = ##class(EnsLib.ITK.Validation.TKWLog).%New()
 Set tSC = %tkw1.ReadFile(..GetLogFile(1,1))
 Quit:$$$ISERR(tSC) tSC
 Set %tkw2req = ##class(EnsLib.ITK.Validation.TKWLog).%New()
 Set tSC = %tkw2req.ReadFile(..GetLogFile(2,1))
 Quit:$$$ISERR(tSC) tSC
 if '..RequestSync {
	 Set %tkw3 = ##class(EnsLib.ITK.Validation.TKWLog).%New()
 	 Set tSC = %tkw3.ReadFile(..GetLogFile(3,0))
 	 Quit:$$$ISERR(tSC) tSC
 }
 if '..ResponseSync {
	 Set %tkw2resp = ##class(EnsLib.ITK.Validation.TKWLog).%New()
 	 Set tSC = %tkw2resp.ReadFile(..GetLogFile(2,0))
 	 Quit:$$$ISERR(tSC) tSC
 }
  
 Quit $$$OK
}

Method TestConfig()
{
	
	do $$$LogMessage("TestName: "_..Name_", SubDir: "_..SubDir_", ReqSync? "_..RequestSync_", RespSync?"_..ResponseSync)
	//TKW1 Request
	Do $$$AssertTrue($IsObject(%tkw1), "TKW1 loaded")
	//TKW2 Request
	Do $$$AssertTrue($IsObject(%tkw2req), "TKW2Req loaded")
	// TKW3 Response
	Do:'..RequestSync $$$AssertTrue($IsObject(%tkw3), "TKW3 loaded")
	// TKW2 Response
	Do:'..ResponseSync $$$AssertTrue($IsObject(%tkw2resp), "TKW2Resp loaded")
}

Method TestResponseRelatesTo()
{
	// First, get the MessageID from tkw1_request.log
	Set tMsgID = %tkw1.GetRequestElement("wsa:MessageID")
	do $$$AssertTrue(tMsgID '= "","Got Message ID: "_tMsgID)
	if ..RequestSync {
		// RelatesTo should be in same file
		Set tRelatesTo = %tkw1.GetResponseElement("wsa:RelatesTo")
	} else {
		// Need to get this from tkw3_response
		Set tRelatesTo = %tkw3.GetRequestElement("wsa:RelatesTo")
	}
	do $$$AssertTrue(tRelatesTo '= "", "Got RelatesTo ID: "_tRelatesTo)
	
	do $$$AssertEquals(tMsgID, tRelatesTo, "RelatesTo matches original MessageID")
}

Method TestSOAPAction()
{
	// First, get the soap action from the tkw1 request (Sender -> Switchboard)
	Set tSOAPHdr1 = %tkw1.RequestHeaders.GetAt("soapaction")
	Do $$$AssertTrue($G(tSOAPHdr1)'="", "TKW1: Found SOAPAction Header: "_tSOAPHdr1)
	// Now get from WS-A
	Set tSOAP1 = %tkw1.GetRequestElement("wsa:Action")
	Do $$$AssertTrue($G(tSOAP1)'="", "TKW1: Found Action element: "_tSOAP1)
	// Now get the action from the tkw2 request (Switchboard -> Consumer)
	Set tSOAPHdr2 = %tkw2req.RequestHeaders.GetAt("soapaction")
	Do $$$AssertTrue($G(tSOAPHdr2)'="", "TKW1: Found SOAPAction Header: "_tSOAPHdr2)
	Set tSOAP2 = %tkw2req.GetRequestElement("wsa:Action")
	Do $$$AssertTrue($G(tSOAP2)'="", "TKW1: Found Action element: "_tSOAP2)
	
	// Make sure they're all equal
	Do $$$AssertEquals(tSOAPHdr1, tSOAP1, "TKW1: Header and WS-A Action match")
	Do $$$AssertEquals(tSOAPHdr2, tSOAP2, "TKW2: Header and WS-A Action match")
	Do $$$AssertEquals(tSOAPHdr1, tSOAPHdr2, "TKW1 action matches TKW2")
	
	// Now deal with Sync Request
	if (..RequestSync) {
		// Switchboard -> Sender
		// Shouldn't have a SOAPAction header in the response
		Set tSOAPHdr1resp = %tkw1.ResponseHeaders.GetAt("soapaction")
		Do $$$AssertTrue($G(tSOAPHdr1resp)="", "TKW1: No Response SOAPAction header")
		// But should have in SOAP addressing
		Set tSOAP1resp = %tkw1.GetResponseElement("wsa:Action")
		Set tkwText = "TKW1"
	} else {
		// Async Request
		Set tSOAPHdr1resp = %tkw3.RequestHeaders.GetAt("soapaction")
		Do $$$AssertTrue($G(tSOAPHdr1resp)'="", "TKW3: Found SOAPAction header: "_tSOAPHdr1resp)
		Set tSOAP1resp= %tkw3.GetRequestElement("wsa:Action")
		Set tkwText = "TKW3"
	}
	Do $$$AssertTrue($G(tSOAP1resp)'="", tkwText_": Found Action element: "_tSOAP1resp)
	Do:$G(tSOAPHdr1resp)'="" $$$AssertEquals(tSOAPHdr1resp, tSOAP1resp, tkwText_": Header and WS-A Action match")
	Do $$$AssertEquals(tSOAP1resp, tSOAP1_..#ACTIONRESPSUFFIX, tkwText_": Response action is correct")
	
	// Now deal with Sync/Async Response
	if (..ResponseSync) {
		// Consumer -> Switchboard
		// Shouldn't have a SOAPAction header in the response
		Set tSOAPHdr2resp = %tkw2req.ResponseHeaders.GetAt("soapaction")
		Do $$$AssertTrue($G(tSOAPHdr2resp)="", "TKW2Req: No Response SOAPAction header")
		// But should have in SOAP addressing
		Set tSOAP2resp = %tkw2req.GetResponseElement("wsa:Action")
		Set tkwText = "TKW2Req"
	} else {
		// Async Response
		Set tSOAPHdr2resp = %tkw2resp.RequestHeaders.GetAt("soapaction")
		Do $$$AssertTrue($G(tSOAPHdr2resp)'="", "TKW2resp: Found SOAPAction header: "_tSOAPHdr2resp)
		Set tSOAP2resp= %tkw2resp.GetRequestElement("wsa:Action")
		Set tkwText = "TKW2Resp"
	}
	Do $$$AssertTrue($G(tSOAP2resp)'="", tkwText_": Found Action element: "_tSOAP2resp)
	Do:$G(tSOAPHdr2resp)'="" $$$AssertEquals(tSOAPHdr2resp, tSOAP2resp, tkwText_": Header and WS-A Action match")
	Do $$$AssertEquals(tSOAP2resp, tSOAP1_..#ACTIONRESPSUFFIX, tkwText_": Response action is correct")
}

Method TestCertificate()
{
	//TKW1 Request
	Do ..CheckCertificate(%tkw1, "TKW1")
	//TKW2 Request
	Do ..CheckCertificate(%tkw2req, "TKW2Req")
	// TKW3 Response
	Do:'..RequestSync ..CheckCertificate(%tkw3, "TKW3")
	// TKW2 Response
	Do:'..ResponseSync ..CheckCertificate(%tkw2resp, "TKW2Resp")
}

Method TestTimestamp()
{
	// TKW1 Request
	Do ..CheckTimestamp(%tkw1.GetRequestElement("wsu:Timestamp/wsu:Created"), %tkw1.GetRequestElement("wsu:Timestamp/wsu:Expires"), "TKW1Req")
	// TKW2 Request
	Do ..CheckTimestamp(%tkw2req.GetRequestElement("wsu:Timestamp/wsu:Created"), %tkw2req.GetRequestElement("wsu:Timestamp/wsu:Expires"), "TKW2Req")
	// TKW3
	Do:'..RequestSync ..CheckTimestamp(%tkw3.GetRequestElement("wsu:Timestamp/wsu:Created"), %tkw3.GetRequestElement("wsu:Timestamp/wsu:Expires"), "TKW3")
	// TKW2 Response
	Do:'..ResponseSync ..CheckTimestamp(%tkw2resp.GetRequestElement("wsu:Timestamp/wsu:Created"), %tkw2resp.GetRequestElement("wsu:Timestamp/wsu:Expires"), "TKW2Resp")
}

Method OnAfterAllTests() As %Status
{
 // Set the working dir back
 //do $System.Process.CurrentDirectory(..WorkingDir)
 Quit $$$OK
}

Method CheckCertificate(pXPath As %XML.XPATH.Document, pMsgPrefix As %String) [ Private ]
{
	// Find the binary security token
	Set tBST = pXPath.GetRequestElement("sec:BinarySecurityToken",.attrs)
	Do $$$AssertTrue(tBST'=$$$NULLOREF, pMsgPrefix_": Found BinarySecurityToken")	
	// Check that it's EncodingType is Base64 and it is an X509 cert
	Do $$$AssertTrue($Find($G(attrs("EncodingType")),"Base64Binary") > 0, pMsgPrefix_": BinarySecurityToken encoding is base64")
	Do $$$AssertTrue($Find($G(attrs("ValueType")),"X509") > 0,  pMsgPrefix_": BinarySecurityToken is X509")
	
	// Now extract the Subject from the certificate
	Set tSubject = $System.Encryption.X509GetField($System.Encryption.Base64Decode(tBST),"Subject")
	Do $$$AssertTrue($G(tSubject)'="",  pMsgPrefix_": Got Subject from BST: "_tSubject)
	// Get the Username token from the security header
	Set tUsername = pXPath.GetRequestElement("sec:Username")
	Do $$$AssertTrue($G(tUsername)'="",  pMsgPrefix_": Got Username from BST: "_tUsername)
	Do $$$AssertEquals(tSubject, tUsername,  pMsgPrefix_": Username matches certificate subject")
}

Method CheckTimestamp(pCreated As %String, pExpires As %String, pMsgPrefix As %String) [ Private ]
{
	Do $$$AssertTrue($G(pCreated)'="",pMsgPrefix_": Got request created timestamp: "_pCreated)
	Do $$$AssertTrue($G(pExpires)'="",pMsgPrefix_": Got request expires timestamp: "_pExpires)
	// Convert the times into horolog
	Set tCreated = $ZDATETIMEH(pCreated,3,7)
	Set tExpires = $ZDATETIMEH(pExpires,3,7)
	Do $$$AssertTrue(tExpires ] tCreated, pMsgPrefix_": Expires is after Created by "_(((+tExpires - +tCreated)*3600)+($P(tExpires,",",2) - $P(tCreated,",",2)))_" secs")
}

Method GetLogFile(pInstance As %Integer, pIsRequest As %Boolean) As %String
{
	Set tDir = "tkw"_pInstance_"_"_$Select(pIsRequest:"request",1:"response")
	Quit ..fixPath(..SubDir_tDir)_tDir_".log"
}

ClassMethod fixPath(path As %String) As %String
{
	Quit ##class(EnsLib.ITK.Validation.TestManager).fixPath(path)
}

}
