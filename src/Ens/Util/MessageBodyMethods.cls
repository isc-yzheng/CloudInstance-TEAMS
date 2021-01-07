/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (%occInclude, Ensemble)

Class Ens.Util.MessageBodyMethods [ Abstract, ClassType = "", System = 4 ]
{

/// This method is called by the Management Portal to determine
/// the content type that will be returned by the <method>%ShowContents</method>
/// method.
/// The return value is a string containing an HTTP content type.
Method %GetContentType() As %String
{
	If (..%Extends("%XML.Adaptor")) {
		Quit "text/xml"
	}
	Quit "text/html"
}

/// This method is called by the Management Portal to 
/// display a message-specific content viewer.<br>
/// This method displays its content by writing out to the current device.
/// The content should match the type returned by the 
/// <method>%GetContentType</method> method.<br>
Method %ShowContents(pZenOutput As %Boolean = 0)
{
	If (..%Extends("%XML.Adaptor")) {
		// show contents as XML
		&html<<?xml version="1.0" ?>
		<?xml-stylesheet href="ensemble/Ensemble_XMLDisplay.xsl" type="text/xsl" ?>
		<!-- type: #($classname())#  id: #(..%Id())# -->
>
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.NoXMLDeclaration = 1
		Set tWriter.Indent = 1
		Do tWriter.AddInstanceNamespace()
		Do tWriter.AddSchemaNamespace()
		Do tWriter.RootObject($this)
	}
	Else {
		&html<<div>There is no content viewer defined for this message type.</div>>
	}
}

/// This method is called by the Management Portal to 
/// display a message-specific content viewer.<br>
ClassMethod %DrawHTMLTable(pObj As %RegisteredObject, ByRef pID As %String) As %Status
{
	Quit ##class(%CSP.Util.AutoFormDynamic).DrawHTMLTable(pObj, .pID)
}

/// This method is called by the Management Portal to 
/// display a message-specific content editor.<br>
ClassMethod %DrawHTMLForm(pObj As %RegisteredObject, ByRef pID As %String, pActionURL As %String = "", ByRef pButtons As %CSP.Util.FormButton, pTarget As %String = "") As %Status
{
	Quit ##class(%CSP.Util.AutoFormDynamic).DrawHTMLForm(pObj, .pID, pActionURL, .pButtons, pTarget)
}

/// This method is called by the Management Portal to 
/// display a message-specific content editor.<br>
ClassMethod %ProcessSubmit(pRequest As %CSP.Request, ByRef pID As %String = "", Output pErrorMsg As %String) As %RegisteredObject
{
	#; construct body clone and get an id for it
	Merge tID=pID Set tObjId=$G(tID(1))
	If ""'=tObjId {
		Set tOldBody=..%OpenId(tObjId,,.tSC)  If $$$ISERR(tSC) Set pErrorMsg=$$$StatusDisplayString(tSC)  Quit $$$NULLOREF
		Set tOldBody=tOldBody.%ConstructClone()
		If tOldBody.%IsA("%Library.Persistent")||tOldBody.%IsA("%Stream.Object") Set tSC=tOldBody.%Save()  If $$$ISERR(tSC) Set pErrorMsg=$$$StatusDisplayString(tSC)  Quit $$$NULLOREF
		Set tSC=tOldBody.%GetSwizzleObject(0,.tOID)  If $$$ISERR(tSC) Set pErrorMsg=$$$StatusDisplayString(tSC)  Quit $$$NULLOREF
		Set tID(1)=$$$oidPrimary(tOID)
	}
	Quit ##class(%CSP.Util.AutoFormDynamic).ProcessSubmit(pRequest, .tID, .pErrorMsg, 0)
}

ClassMethod %CompareContents(pMsg1 As Ens.MessageBody, pMsg2 As Ens.MessageBody)
{
	&html<<frameset id="frameset" cols="50%,50%" frameborder=yes frameborder=1 border=2" >>
	&html<<frame src="#(##class(%CSP.Page).Link("EnsPortal.MessageContents.cls?HeaderClass="_##class(%CSP.Page).escapeURL($classname())_"&HeaderId="_$S($IsObject(pMsg1):##class(%CSP.Page).escapeURL(pMsg1.%Id()),1:"")))#" name="Left" MARGINWIDTH="0" MARGINHEIGHT="0" FRAMESPACING="0" FRAMEBORDER="1" SCROLLING="yes" >>
	&html<<frame src="#(##class(%CSP.Page).Link("EnsPortal.MessageContents.cls?HeaderClass="_##class(%CSP.Page).escapeURL($classname())_"&HeaderId="_$S($IsObject(pMsg2):##class(%CSP.Page).escapeURL(pMsg2.%Id()),1:"")))#" name="Right" MARGINWIDTH="0" MARGINHEIGHT="0" FRAMESPACING="0" FRAMEBORDER="1" SCROLLING="yes" >>
	&html<</frameset>>
}

/// This method is called by the Management Portal to 
/// display a portion of the HEAD section of a
/// message-specific content viewer.<br>
Method %ShowContentsHead(pZenOutput As %Boolean = 0)
{
}

/// This method is called when this message has timed out
/// The time out moment happens when the timer response arrives, 
/// and the request is being removed from pending request list.
/// The timeout moment is not when the response arrives and is being marked as "discarded"
Method %OnTimeout() As %Status
{
	Quit $$$OK
}

/// This method is used to provide the Statistics Site Dimension if not already set
/// Override and implement as needed.
Method GetStatsDimension() As %String
{
	Quit $$$StatsDefaultDimension
}

}
