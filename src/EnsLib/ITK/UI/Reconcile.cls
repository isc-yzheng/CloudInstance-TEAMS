/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsUI)

/// CSP Page for reconciling a production to the ITK Registry.
Class EnsLib.ITK.UI.Reconcile Extends EnsPortal.Dialog.standardDialog [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:WRITE";

/// Use our own domain for localization
Parameter DOMAIN = "Ensemble";

ClassMethod OnPage() As %Status
{
	Quit:'##class(EnsPortal.Utils).CheckResourceList(..#RESOURCE) $$$ERROR($$$InsufficientPrivilegeForOperation)

	Set tProdName = $G(%request.Data("$ID1",1))
	// if URL is defined, go there
	Set tURL = $G(%request.Data("URL",1))
	Set StartStopTitle = "ITK Reconcile Production"
	&html<<html>
	<head>
	<title>#(StartStopTitle)#</title>
	<link rel="stylesheet" type="text/css" href="/csp/sys/csputils.css" title="Standard Style" >

	<script language="javascript">

	function gotoNextLocation()
	{
		self.document.location = '#(..Link(tURL))#';
		return true;
	}

  	// close button for end of popup
	function popupClose()
	{
		if (opener) {
			opener.autopagePopupWindow = null;
			opener.document.location.reload();
			window.close();
		}
		else {
			parent.location.reload();
		}
		return true;
	}
	</script>

	<style>

pre {
	border: 1px black solid;
	background: white;
	margin: 20px;
	padding: 4px;
	font-size: 12pt;
}

div.buttons {
	margin-left: 20px;
	margin-top: 0px;
}

table.subtitle {
	margin-left: 20px;
	margin-top: 20px;
}

span.statusSpan {
	color: blue;
}

	</style>>

	&html<</head>
	<body onload="self.document.getElementById('theButton').focus();">>

	Set tFinishedMsg = $$$LocalizeText("Ensemble","Finished","Finished")

	Set tTitle = "Reconcile ITK Production"

	Set tSubTitle = "Reconciling Production: "

	Set tSubTitle = tSubTitle_" <b>" _ tProdName _ "</b>"

	// title
	&html<
	<table border="0" class="LayoutMain" width="100%" cellpadding="0" cellspacing="0">
	<TR><TD COLSPAN="2" CLASS="Title" WIDTH="100%">
	<DIV CLASS="TitleText">&nbsp;#(tTitle)#</DIV>
	</TD></TR>
	</table>
	<table class="subtitle" border="0" cellspacing="0" cellpadding="0">
	<tr><td>#(tSubTitle)#</td>
	<td width="10%">&nbsp;</td>
	<td>&nbsp;</span></td>
	</tr></table>
	</div><hr>
	>

	Do %response.Flush()
	Hang 0.1

	Set tSC = $$$OK

	&html<<pre>>
	Set tSC = ..ReconcileProduction(tProdName)
	
	If ($$$ISERR(tSC)) {
		Set Err = $$$LocalizeText("Ensemble","Err","Error")
		Set tFinishedMsg = "<span style=""color:red;"">"_Err_"</span>"
	}
	&html<</pre>>


	&html<<hr>
		<form>
		<div class="buttons">
	>
	If (tURL = "") {
		// popup mode
		&html<<input id="theButton" type="button" name="btnClose" value="Close" Domain="Ensemble" TextId="Close" onclick="popupClose();">>
	}
	Else {
		&html<<input id="theButton" type="button" name="btnOK" value=" OK " Domain="Ensemble" TextId="btnOK" onclick="gotoNextLocation();">>
	}

	&html<
		</div>
		</form>
		<script language="javascript">
		var stat = self.document.getElementById("status");
		if (stat) {
			stat.innerHTML = '#(tFinishedMsg)#';
		}
		</script>
	>

	&html<</body>
	</html>>
	Quit $$$OK
}

/// Start a production
ClassMethod ReconcileProduction(pName As %String) As %Status
{
	Set $ZT = "Trap"
	Set tSC = $$$OK

	set prod=##class(Ens.Config.Production).%OpenId(pName)
	goto:'$IsObject(prod) Done
	Do
	{
		do ..GetITKMissingItems(pName,.items)

		set key=""
		do
		{
			set class=items.GetNext(.key)
			Continue:key=""
			Write "Adding component: "_key_" Class: "_class ,!

			set item = ##class(Ens.Config.Item).%New()
			set item.Production=prod
			set item.Name=key
			set item.ClassName=class
			set item.Enabled=0

			if (class="EnsLib.ITK.Framework.Service.SOAPRequestHandler")
			{
				set tSetting = ##class(Ens.Config.Setting).%New()
				set tSetting.Target="Host"
				set tSetting.Name="TargetConfigName"
				set tSetting.Value = "ITKMessageRouter"
				do item.tSetting.Insert(targetConfigName)

				set tSetting = ##class(Ens.Config.Setting).%New()
				set tSetting.Target="Host"
				set tSetting.Name="FaultVocabulary"
				set tSetting.Value = "2.16.840.1.113883.2.1.3.2.4.17.268"
				do item.Settings.Insert(targetConfigName)
			}
			elseif class="EnsLib.ITK.Framework.Operation.SOAPOperation" {
				set tSetting = ##class(Ens.Config.Setting).%New()
				set tSetting.Target="Host"
				set tSetting.Name="ApplicationName"
				set tSetting.Value = key
				do item.Settings.Insert(targetConfigName)

				set tSetting = ##class(Ens.Config.Setting).%New()
				set tSetting.Target="Host"
				set tSetting.Name="FaultVocabulary"
				set tSetting.Value = "2.16.840.1.113883.2.1.3.2.4.17.268"
				do item.Settings.Insert(targetConfigName)

				set tSetting = ##class(Ens.Config.Setting).%New()
				set tSetting.Target="Host"
				set tSetting.Name="UserNameToken"
				set tSetting.Value = prod.Name
				do item.Settings.Insert(targetConfigName)
			}

			do prod.Items.Insert(item)

			Write "Done" ,!

		}
		while (key'="")

		set tSC = prod.%Save()

		If ($$$ISOK(tSC)) { Write !,"Production reconciled" }
		Else {
			Write !,"Error reconciling production"
			Write $ZCVT($system.Status.GetErrorText(tSC),"O","HTML"),!
		}
	} While(0)

Done
	Write !
	Quit tSC

Trap
	Set $ZT=""
	Write !,"Error reconciling production"
	Goto Done
}

ClassMethod %OnPreHTTP() As %Boolean
{
	Set tResult = ##super()

	If %response.Redirect = "" {
		// Set the timeout for 5 minutes for a start/stop
		Set %response.Timeout = 5*60
	}
	Quit tResult
}

ClassMethod GetITKMissingItems(production As %String, ByRef items As %ArrayOfDataTypes)
{
	set items = ##class(%ArrayOfDataTypes).%New()

	set tRs=##class(%ResultSet).%New()
	set tSC=tRs.Prepare("select distinct %EXACT BusinessServiceName from EnsLib_ITK_Setup.SenderRegistry")
	set tSC=tRs.Execute()
	For
	{
		Quit:tRs.Next()=0
		do items.SetAt("EnsLib.ITK.Framework.Service.SOAPRequestHandler",tRs.GetData(1))
	}
	set subscribers = ##class(EnsLib.ITK.Setup.SubscriptionRules).GetAllSubscribers()
	For i=1:1:$L(subscribers,",")
	{
		Set tOne=$ZStrip($P(subscribers,",",i),"<>W")
		continue:tOne=""
		set approuter=""
		set app = ##class(EnsLib.ITK.Setup.SystemDefinition).%OpenId(tOne)
		Set:$IsObject(app) approuter = app.ApplicationRouter

		do items.SetAt($S(approuter="":"EnsLib.ITK.Framework.Operation.SOAPOperation",1:"EnsLib.MsgRouter.RoutingEngine"),$S(approuter="":tOne,1:approuter))
	}

	// Distribution Rules
	Set rs= ##class(%ResultSet).%New("EnsLib.ITK.Setup.DistributionRules:DistributionTargets")
	do rs.Execute()
	while rs.Next()
	{
		do items.SetAt("EnsLib.ITK.Framework.Operation.SOAPOperation",rs.GetData(1))
	}
	set tRSItems=##class(%ResultSet).%New("Ens.Config.Production:EnumerateConfigItems")
	Set tSC=tRSItems.Execute(production)
	For 
	{
			Quit:tRSItems.Next()=0
			set tConfigItem = tRSItems.GetDataByName("ConfigName")
			do items.RemoveAt(tConfigItem)
	}
}

}
