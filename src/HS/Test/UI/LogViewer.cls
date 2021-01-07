Class HS.Test.UI.LogViewer Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Log Viewer";

Property LOGID As %String(ZENURL = "ID");

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textReadOnly {
	border: 1px inset threedface;
	color:#777777;
	background: #EEEEEE;
}

</style>
}

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page title="HealthShare Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="40"/>
<tabGroup id="tabGroup" showTabBar="true" remember="false">
<tab caption="Request">
<spacer height="15"/>
<textarea label="Request:" id="txtRequest" cols="90" rows="20"/>
<spacer height="25"/>
<button id="btnShowXMLRQ" caption=" Show XML " onclick="zenPage.ShowXML('txtRequest');" />
</tab>
<tab caption="Response">
<spacer height="15"/>
<textarea label="Response:" id="txtResponse" cols="90" rows="20"/>
<spacer height="25"/>
<button id="btnShowXMLRS" caption=" Show XML " onclick="zenPage.ShowXML('txtResponse');" />
<spacer height="10"/>
</tab>
</tabGroup>
</pane>
</page>
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	New $namespace
	#; lookup the repository endpoint based on the oid
	Set tLogID=%page.LOGID
	Set $Namespace="%SYS"
	Set tObj=##class(TCPTrace.Log).%OpenId(tLogID) Quit:'$IsObject(tObj) $$$OK
	set %page.%GetComponentById("txtRequest").value=tObj.InputStream.Read(3000000)
	Set tString=tObj.OutputStream.Read(3000000)
	Set tP1=$p(tString,$c(13,10,13,10),1)
	Set tObjResponse=%page.%GetComponentById("txtResponse")
	set tObjResponse.value=tP1_$c(13,10,13,10)
	Set tString=$p(tString,$c(13,10,13,10),2,999)
	If tP1["CONTENT-ENCODING: gzip" {
		Set tStream=##class(%Stream.FileBinary).%New()
		Do tStream.Write(tString)
		If 'tObj.OutputStream.AtEnd {
			Do tStream.CopyFrom(tObj.OutputStream)
		}
		Set tSC=tStream.%Save()
		Set tDecoded=##class(%Stream.FileBinaryGzip).%New()
		Do tDecoded.LinkToFile(tStream.Filename)
		Set tString=tDecoded.Read(30000000)
		Set ^%zjb("fn")=tStream.Filename
		Do ##class(%File).Delete(tStream.Filename)
		Set (tDecoded,tStream)=""
	}
		
	set tObjResponse.value=tObjResponse.value_tString
	Quit $$$OK
}

}
