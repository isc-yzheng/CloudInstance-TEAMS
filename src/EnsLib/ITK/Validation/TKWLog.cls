/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include %occXSLT

Class EnsLib.ITK.Validation.TKWLog Extends %RegisteredObject [ System = 4 ]
{

Parameter XSDSPEC = "sec http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd,wsse http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd,sig http://www.w3.org/2000/09/xmldsig#,wsu http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd,wsa http://www.w3.org/2005/08/addressing,soap http://schemas.xmlsoap.org/soap/envelope,itk urn:nhs-itk:ns:201005";

Property FileName As %String;

Property InputFile As %File;

Property RequestHeaders As %ArrayOfDataTypes;

Property RawSOAPRequest As %GlobalCharacterStream;

Property ResponseHeaders As %ArrayOfDataTypes;

Property RawSOAPResponse As %GlobalCharacterStream;

Property XPathRequest As %XML.XPATH.Document;

Property XPathResponse As %XML.XPATH.Document;

Method ReadFile(TestFileName As %String) As %Status
{
	set $ZT="Trap"
	Set tSC = $$$OK
	Set ..FileName = $ZSTRIP(TestFileName,"<>W")
	Quit:$L(..FileName)=0 $$$ERROR($$$GeneralError,"Must supply a name")
	Quit:'##class(%File).Exists(..FileName) $$$ERROR($$$GeneralError, "File '"_..FileName_"' does not exist")
	Set ..InputFile = ##class(%FileCharacterStream).%New()
	Set ..InputFile.Filename = ..FileName
	
	Set ..RequestHeaders = ..ReadHTTP(1, ..InputFile, .RawSOAPRequest, .tSC)
	if ($$$ISERR(tSC)) ZTRAP
	Set ..RawSOAPRequest = $G(RawSOAPRequest)
	if ..RawSOAPRequest.Size > 0 {
		set tSC = ##class(%XML.XPATH.Document).CreateFromStream(
			..RawSOAPRequest, .XPathDoc, ##class(%XML.SAX.EntityResolver).%New(),,,,..#XSDSPEC)
		if ($$$ISERR(tSC)) ZTRAP
		Set ..XPathRequest = XPathDoc
	}
	Set ..ResponseHeaders = ..ReadHTTP(0, ..InputFile, .RawSOAPResponse, .tSC)
	if ($$$ISERR(tSC)) ZTRAP
	Set ..RawSOAPResponse = $G(RawSOAPResponse)
	if ..RawSOAPResponse.Size > 0 {
		set tSC = ##class(%XML.XPATH.Document).CreateFromStream(
			..RawSOAPResponse, .XPathDoc, ##class(%XML.SAX.EntityResolver).%New(),,,,..#XSDSPEC)
		if ($$$ISERR(tSC)) ZTRAP
		Set ..XPathResponse = XPathDoc
	}
	
Exit
	Quit $$$OK
	
Trap
	set $ZT=""
	w $ZERROR
	if $G(tSC)="" {
		Quit $$$ERROR($$$GeneralError,$ZERROR)
	} else {
		do $System.OBJ.DisplayError(tSC)
		Quit tSC
	}
		
	goto Exit
}

Method ReadHTTP(pIsRequest As %Boolean, pFile As %FileCharacterStream, ByRef pBody As %GlobalCharacterStream, ByRef pSC As %Status) As %ArrayOfDataTypes [ Private ]
{
			
	// Read File In
	/*Set tSC = ..InputFile.Open("RS")
	if $$$ISERR(tSC) {
		set tFault = "Failed to open file"
		goto Trap
	}*/
	Set pSC = $$$OK
	// Read in the file and extract HTTP Headers for request:
	Do {
		// Read raw lines of header, then suck in whole body into a stream
		Set tLine = pFile.ReadLine()
		//Set:$E(tLine,$L(tLine))=$C(13) $E(tLine,$L(tLine))=""
		Set tHeadersFound = 1
		set pHeaders = ##class(%ArrayOfDataTypes).%New()
		if (pIsRequest) {
			// Should have a Request line
			Set tURL=$P(tLine," ",2)
			Do pHeaders.SetAt(tURL, "URL")
			do pHeaders.SetAt($P(tLine," "),"HttpRequest")
			//$$$sysTRACE("Got SOAP Request '"_RequestHeaders("HttpRequest")_" "_tURL_"'")
			If 3=$L(tLine," ") //Set pSC=$$$ERROR($$$GeneralError,"invalid HTTP header:'"_tLine_"'") Quit
			{ // Only do if it exists
				Set tLine=$P(tLine," ",3,$L(tLine," "))
				If "HTTP"'=$P(tLine,"/") Set pSC=$$$ERROR($$$GeneralError,"invalid HTTP version'"_tLine_"'") Quit
				do pHeaders.SetAt($P(tLine,"/",2),"version")
			}
		} else {
			// Parse a Response message
			if $Find(tLine,"HTTP/")=6 {
				do pHeaders.SetAt($P(tLine," ",2), "StatusCode")
				do pHeaders.SetAt($P(tLine," ",3), "StatusMessage")
				Set tLine = $P(tLine," ")
				do pHeaders.SetAt($P(tLine,"/",2),"version")
			} elseif tLine = "****" {
				// This form of response has no headers, just a SOAP response ,so lets put in a 200 OK
				do pHeaders.SetAt("200", "StatusCode")
				do pHeaders.SetAt("OK", "StatusMessage")
				Set tHeadersFound = 0
			} else {
				Continue
			}
			
		}
		
		Quit:$$$ISERR(pSC)
		// Now store the headers
		While tHeadersFound {		
			Set tLine = pFile.ReadLine()
			//Set:$E(tLine,$L(tLine))=$C(13) $E(tLine,$L(tLine))=""
			Quit:""=tLine
			do pHeaders.SetAt($ZStrip($P(tLine,":",2,$L(tLine,":")),"*W",""""), $ZCVT($P(tLine,":"),"L"))
		}
		//If ""=$G(%iaHeader("soapaction")) { Set pSC = $$$ERROR($$$EnsErrGeneral,"No SOAPAction in SOAP Request HTTP header") Quit }
		#; now read the body
		Set tLen=pHeaders.GetAt("content-length")
		Set:tLen="" tLen=$Case(tHeadersFound,1:0,:32000)
		//$$$sysTRACE("For action='"_%iaHeader("soapaction")_"' got content-len="_tLen_", waiting to read (raw) with timeout="_..ReadTimeout)
		If tLen {
			// copy post-header part in, loop writing into stream until done
		 	Set pBody = ##class(%Library.GlobalCharacterStream).%New()
			//Use ..Device:(::"+":) ; turn off terminators
			Set pSC = pBody.Write(..InputFile.Read(.tLen)) //InputFromDevice(.tLen,..ReadTimeout)
			//Use ..Device:(::"+":..Terminators) ; turn on terminators
			Quit:$$$ISERR(pSC)
			//$$$sysTRACE("TCP Read body("_%iaStream.Size_")")
		} Else {
			Set pBody=$$$NULLOREF
		}
	} While pHeaders.Count() = 0, 'pFile.AtEnd
	
	Quit pHeaders
}

Method GetRequestElement(pElement As %String, ByRef pAttributes, ByRef pSC As %Status) As %String
{
	Quit ..GetElement(..XPathRequest, pElement, .pAttributes, .pSC)
}

Method GetResponseElement(pElement As %String, ByRef pAttributes, ByRef pSC As %Status) As %String
{
	Quit ..GetElement(..XPathResponse, pElement, .pAttributes, .pSC)
}

Method GetElement(pXPath As %XML.XPATH.Document, pElement As %String, ByRef pAttributes, ByRef pSC As %Status) As %String [ Private ]
{
	Set pSC=pXPath.EvaluateExpression("/","//"_pElement,.tRes)
	if $$$ISERR(pSC) Quit ""
	Quit ..GetDOMElement(pElement,.pAttributes, tRes)
}

ClassMethod GetDOMElement(pElement As %String, pAttributes As %String, pResults As %ListOfObjects(CLASSNAME="%XML.XPATH.Result")) As %String [ Private ]
{
	Set tResultValue = ""
	Quit:pResults.Count()<1 tResultValue
	Set tI = 0
	While $I(tI)<=pResults.Count(), tResultValue=""
	{
		Set tResult=pResults.GetAt(tI)
		
		if (tResult.Type=$$$XPATHDOM)
		{
			While tResult.Read(), tResultValue=""
			{	
				If tResult.NodeType="element", $P(tResult.Name,":",$L(tResult.Name,":")) = $P(pElement,":",$L(pElement,":"))
				{
					// Found the specified element
					If tResult.HasAttributes {
						
						For tJ=1:1:tResult.AttributeCount
						{
							Do tResult.MoveToAttributeIndex(tJ)
							if tResult.NodeType="attribute" {
								Set pAttributes(tResult.Name) = tResult.Value
							}
						}
					}
					
					// Loop through until the value is found
					While tResult.Read(), tResultValue="" {
				
						if tResult.NodeType="chars", tResult.Name="#text" {
							Set tResultValue = tResult.Value
						} elseif tResult.NodeType="element" {
							// Failed to find it, so bomb
							Quit	
						}
					}
				}
			}
		}
	}
	
	Quit tResultValue
}

/// Output the Request/Response
Method Display()
{
	w !,"******** REQUEST *********"
	w !,..RequestHeaders.GetAt("HttpRequest")_" "_..RequestHeaders.GetAt("URL")_" HTTP/"_..RequestHeaders.GetAt("version")
	Do {
		Set val = ..RequestHeaders.GetNext(.key)
		Quit:key=""
		Continue:(key="HttpRequest")||(key="URL")||(key="version")
		w !,key_": "_val
	} While 1
	
	w !
	Set tSC = ..RawSOAPRequest.Rewind()
	//w !,..RawSOAPRequest.Read(32000)
	
	set tSC = ##class(%XML.XPATH.Document).CreateFromStream(..RawSOAPRequest, .XPATHReq, ##class(%XML.SAX.EntityResolver).%New(),,,,
		"sec http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"_
		",wsu http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"_
		",wsa http://www.w3.org/2005/08/addressing"_
		",soap http://schemas.xmlsoap.org/soap/envelope"_
		",itk urn:nhs-itk:ns:201005"
		)
	if $$$ISERR(tSC) do $SYSTEM.OBJ.DisplayError(tSC)  Quit
	
	Set tSC=XPATHReq.EvaluateExpression("/","//soap:Header",.tRes)
    If $$$ISERR(tSC) do $SYSTEM.OBJ.DisplayError(tSC)  Quit
    
    w !,"Header: "
    Do ##class(%XML.XPATH.Document).ExampleDisplayResults(tRes)
	w !
	
	w !,"******** RESPONSE *********"
	w !,"HTTP/"_..ResponseHeaders.GetAt("version")_" "_..ResponseHeaders.GetAt("StatusCode")_" "_..ResponseHeaders.GetAt("StatusMessage")
	Do {
		Set val = ..ResponseHeaders.GetNext(.key)
		Quit:key=""
		Continue:(key="StatusCode")||(key="StatusMessage")||(key="version")
		w !,key_": "_val
	} While 1
	
	w !
	Set tSC = ..RawSOAPResponse.Rewind()
	w !,..RawSOAPResponse.Read(32000)
	w !
	
	Quit
}

ClassMethod Test(pFile As %String)
{
	set val = ##class(EnsLib.ITK.Validation.TKWLog).%New()
	do val.ReadFile(pFile)
	do val.Display()
}

}
