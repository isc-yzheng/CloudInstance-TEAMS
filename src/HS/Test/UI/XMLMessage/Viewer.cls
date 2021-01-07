/// Created using the page template: Default
/// Utility class to show the first Attachement content (item 1 from stream collection) of the inbound HS.Mesage.XMLMesage
Class HS.Test.UI.XMLMessage.Viewer Extends HS.UI.Base
{

Parameter RESOURCE = "%HS_TestSuite";

/// Class name of application this page belongs to.
Parameter APPLICATION = "HS.UI.Application";

/// Displayed name of this page.
Parameter PAGENAME = "XDR Viewer";

/// Domain used for localization.
Parameter DOMAIN;

Property MessageId As %ZEN.Datatype.string(ZENURL = "MSG");

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
</page>
}

Parameter CONTENTTYPE = "text/xml";

Method %DrawHTMLPage()
{
	Set tSC = $$$OK
	Try {
		For tClass = "HS.Message.XMLMessage","HS.Message.IHE.XDSb.RetrieveResponse" {
			Set msg=$classMethod(tClass,"%OpenId",..MessageId)
			Quit:$IsObject(msg)
		}
		If '$IsObject(msg) Write "<root>Message Not Found</root>" Quit
		Set doc = msg.StreamCollection.GetAt(1)
		If $isObject(doc) {
			Do doc.Body.OutputToDevice()
		} Else { Write "<root>Message exists but the document does not</root>"}
	} Catch ex { Set tSC = ex.AsStatus() }
	If $$$ISERR(tSC) Write $ZCVT($SYSTEM.Status.GetErrorText(tSC),"O","XML"),!
}

}
