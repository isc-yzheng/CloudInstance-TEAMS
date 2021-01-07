Class HS.Test.UI.Config Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Test Tool Configuration";

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
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane id="workflow" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<spacer height="40"/>
<html>The configuration only needs to be updated if multiple users are using the same instance or computer.</html>
<html>Each user must have a separate configuration, otherwise unpredictable results will occur.</html>
<spacer height="5"/>
<form width="75%" layout="vertical" cellStyle="padding: 2px;" groupStyle="padding-left:10px;" labelPosition="left">
<spacer height="5"/>
<text label="Trace configuration name:" id="txtServiceName" size="30" tabIndex="5" />
<text label="Trace configuration port:" id="txtServicePort" size="30" tabIndex="10" />
<text label="SAML Username:" id="txtSAMLUsername" size="30" tabIndex="15" />
<checkbox label="Enable logging" id="chkLogging" />
<spacer height="15"/>
<hgroup width="40%" cellAlign="right">
<button id="btnSave" caption=" Save " onclick="zenPage.Save();" />
</hgroup>

</form>
</pane>
</page>
}

Method Save() As %Status [ ZenMethod ]
{
	Set pName = %page.%GetValueById("txtServiceName") set:pName="" pName=..#TESTSERVICENAME
	Set pPort = %page.%GetValueById("txtServicePort") set:pPort="" pPort=..#TESTSERVICEPORT
	Set %session.Data("IHE.Test","TestServiceName")=pName
	Set %session.Data("IHE.Test","TestServicePort")=pPort
	Set %session.Data("IHE.Test","SAMLUsername")= %page.%GetValueById("txtSAMLUsername")
	Set %session.Data("IHE.Test","LogTransactions")= %page.%GetValueById("chkLogging")

	New $namespace
	Set $namespace="%SYS"
	Set tRS = ##class(%SQL.Statement).%New()
	Set tResult= tRS.%ExecDirect("","select ID from TCPTrace.Config where inboundport=? and ID<>? and runningstatus=1",pPort,pName)
	If tResult.%Next() {
		&js< alert('Port already in use by #(tResult.ID)#');>
	} Else {
		Do ..SetDefaultTracePort(pName,pPort)
	}
	Quit $$$OK
}

ClientMethod onloadHandler() [ Language = javascript ]
{
       zenPage.CheckProduction();
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tTestServiceName=$g(%session.Data("IHE.Test","TestServiceName"),..#TESTSERVICENAME_"."_$zcvt($Username,"l"))
	Set tTestServicePort=..GetDefaultTracePort(tTestServiceName,$g(%session.Data("IHE.Test","TestServicePort"),..#TESTSERVICEPORT))
	Set tUsername = $g(%session.Data("IHE.Test","SAMLUsername"),$username)
	Set %session.Data("IHE.Test","TestServiceName")=tTestServiceName
	Set %session.Data("IHE.Test","TestServicePort")=tTestServicePort
	Set %session.Data("IHE.Test","LogTransactions")=+$g(%session.Data("IHE.Test","LogTransactions"),0)
	Set ..%GetComponentById("txtServiceName").value=tTestServiceName
	Set ..%GetComponentById("txtServicePort").value=tTestServicePort
	Set ..%GetComponentById("txtSAMLUsername").value=tUsername
	Set ..%GetComponentById("chkLogging").value=+$g(%session.Data("IHE.Test","LogTransactions"))
	Quit $$$OK
}

}
