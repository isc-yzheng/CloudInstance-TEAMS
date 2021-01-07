/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsUI)

/// Production Wizard pane.
/// This is the first step in creating a Production.
/// This page lets the user decide what type of production
/// as well as its name.
Class EnsLib.ITK.UI.ProductionWizardPane Extends %CSP.Util.Pane [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// Use our own domain for localization
Parameter DOMAIN = "Ensemble";

/// Override submit behavior for this page
ClassMethod Submit(pRequest As %CSP.Request, pSubmit As %String) As %Status [ ServerOnly = 1 ]
{
	// get ID values from request
	If ($IsObject($G(pRequest))) {
		Set n = 1
		While ($D(pRequest.Data("$ID"_n,1))) {
			Set tID(n) = pRequest.Data("$ID"_n,1)
			Set n = n + 1
		}
	}
	Quit ..OnSubmit(.tID,pSubmit)
}

/// This callback is called when this form is submitted.
ClassMethod OnSubmit(ByRef pID As %String, pSubmit As %String) As %Status
{
	Set tOptionId = $G(%request.Data("$OptionId",1))
	Set tSC = $$$OK

	If (pSubmit = "$AUTOFORM_SAVE") {
		Do {
			Set tPackage = $G(%request.Data("Package",1))
			Set tName = $G(%request.Data("Name",1))
			Set tType = $G(%request.Data("Type",1)) // HL7 | Generic
			Set tDescription = $G(%request.Data("Description",1))
			Set tProdClass = tPackage _ "." _ tName

			If ('$ZNAME(tProdClass,4)) {
				// bad class name
				Set tmsg = $$$FormatText($$$Text("Invalid class or package name: %1 "), tProdClass)
				Set tSC = $$$ERROR($$$GeneralError,tmsg)
				Quit
			}

			// create empty production class
			Set tClsDef = ##class(%Dictionary.ClassDefinition).%New()
			Set tClsDef.Name = tProdClass
			Set tClsDef.Super = "Ens.Production"
			Set tClsDef.ProcedureBlock = 1

			Set tXData = ##class(%Dictionary.XDataDefinition).%New()
			Set tXData.Name = "ProductionDefinition"
			Do tXData.Data.WriteLine("<Production Name="""_tProdClass_"""/>")
			Do tClsDef.XDatas.Insert(tXData)

			Set tSC = tClsDef.%Save()
			Set tClsDef = ""
			Set tXData = ""
			
			If $$$ISERR(tSC) Quit
			
			// now compile the class
			Set tSC = $System.OBJ.Compile(tProdClass,"-d")
			If $$$ISERR(tSC) Quit
	
			// fill in production:
			Set tProduction = ##class(Ens.Config.Production).%OpenId(tProdClass)
			If '$IsObject(tProduction) {
				Set tmsg = $$$FormatText($$$Text("Unable to open new production: %1 "), tProdClass)
				Set tSC = $$$ERROR($$$GeneralError,tmsg)
				Quit
			}
			Set tProduction.Name = tProdClass
			Set tProduction.Description = tDescription
			Set tProduction.ActorPoolSize = 2

			Set tSC = ..ConfigureITKProduction(tName,tProduction,tPackage)
			If $$$ISERR(tSC) Quit
			
			//do ##class(EnsLib.ITK.UI.Reconcile).ReconcileProduction(tProdClass)
		

			// save production
			Set tSC = tProduction.%Save()  Quit:$$$ISERR(tSC)
	
			// update production class
			Set tSC = tProduction.SaveToClass()  Quit:$$$ISERR(tSC)
		
			// tell this window to close
			Set %response.Context("$CLOSEWINDOW") = 1
			Set %response.Context("$ID1") = tProdClass
		} While(0)

		If $$$ISERR(tSC) {
			Set tErr = $$$StatusDisplayString(tSC)
			Set %request.Data("$ERROR",1) = tErr
			Set %request.Data("Package",1) = tPackage
			Set %request.Data("Name",1) = tName

		}
	}
	Quit tSC
}

ClassMethod ConfigureITKProduction(pName As %String, pProduction As Ens.Config.Production, pPackage As %String) As %Status
{
	Set tSC = $$$OK
	Do {
		// ITKMessageRouter
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "ITKMessageRouter"
		Set tItem.ClassName = "EnsLib.ITK.Framework.Process.ITKMessageRouter"
		Set tItem.PoolSize = 1

		Set tSetting = ##class(Ens.Config.Setting).%New()
		Set tSetting.Target = "Host"
		Set tSetting.Name = "SendReponsesTo"
		Set tSetting.Value = "ITKResponseDispatcher"
		Do tItem.Settings.Insert(tSetting)
		
		Set tSetting = ##class(Ens.Config.Setting).%New()
		Set tSetting.Target = "Host"
		Set tSetting.Name = "BadMessageHandler"
		Set tSetting.Value = "ITKBadMessageHandler"
		Do tItem.Settings.Insert(tSetting)

		Do pProduction.Items.Insert(tItem)

		// ITKResponseDispatcher
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "ITKResponseDispatcher"
		Set tItem.ClassName = "EnsLib.ITK.Framework.Process.DispatchResponse"

		Do pProduction.Items.Insert(tItem)

		// ITKBadMessageHandler
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "ITKBadMessageHandler"
		Set tItem.ClassName = "EnsLib.MsgRouter.RoutingEngine"
		
		Do pProduction.Items.Insert(tItem)
		
		// DeferResponse
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "DeferResponse"
		Set tItem.ClassName = "EnsLib.ITK.Framework.Operation.DeferResponse"
		
		Do pProduction.Items.Insert(tItem)

		// SuspendedPurgeRoutine
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "SuspendedPurgeRoutine"
		Set tItem.ClassName = "EnsLib.ITK.Framework.Process.SuspendedPurgeRoutine"
		
		Do pProduction.Items.Insert(tItem)

		// PurgeSuspendedService
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "PurgeSuspendedService"
		Set tItem.ClassName = "EnsLib.ITK.Framework.Service.PurgeSuspendedService"
		
		Set tSetting = ##class(Ens.Config.Setting).%New()
		Set tSetting.Target = "Host"
		Set tSetting.Name = "CallInterval"
		Set tSetting.Value = 28800
		Do tItem.Settings.Insert(tSetting)
		
		Do pProduction.Items.Insert(tItem)
		
		// CallBackPurgeRoutine
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "CallBackPurgeRoutine"
		Set tItem.ClassName = "EnsLib.ITK.Framework.Process.CallBackPurgeRoutine"
		
		Do pProduction.Items.Insert(tItem)

		// PurgeCallBackService
		Set tItem = ##class(Ens.Config.Item).%New()
		Set tItem.Name = "PurgeCallBackService"
		Set tItem.ClassName = "EnsLib.ITK.Framework.Service.PurgeCallBackService"
		
		Set tSetting = ##class(Ens.Config.Setting).%New()
		Set tSetting.Target = "Host"
		Set tSetting.Name = "CallInterval"
		Set tSetting.Value = 28800
		Do tItem.Settings.Insert(tSetting)
		
		Do pProduction.Items.Insert(tItem)

		
	} While(0)

	Quit $$$OK
}

Method DrawHEAD(pInstance As %CSP.Util.PageInstance) As %Status
{
	// override table style
	&html<
<style>

table.LayoutMain td.LayoutContentCol {
	background: #CCCCEE;
	width: 100%;
	margin: 0px;
	margin-right: 0px;
}

.label {
	font-weight: bold;
	text-align: right;
	white-space: nowrap;
}

.Text {
}

.Error {
	border: 1px solid black;
	background: white;
	color: red;
	white-space: nowrap;
	padding: 3px;
}

.TypeLabel {
	font-weight: bold;
}

.TextM {
	font-size: 1.0em;
	line-height: 120%;
	margin-bottom: 5px;
	padding: 2px;
}

</style>>
	Set msg1 = $$$TextJS("Please provide a package name for the new Production.")
	Set msg2 = $$$TextJS("Please provide a name for the new Production.")
	&html<
	
<script language="javascript">


function btnOK()
{
	var form = self.document.getElementById('form');

	if (form.Package.value == '') {
		alert('#(msg1)#');
		return false;
	}

	if (form.Name.value == '') {
		alert('#(msg2)#');
		return false;
	}

	form.submit();
	return true;
}

function btnCancel()
{
	// go back
	self.document.location = 'UtilEnsProductions.csp';
	return true;
}

</script>
	>
	
	Quit $$$OK
}

///   Draw the BODY of the wizard pane
Method DrawBODY(pInstance As %CSP.Util.PageInstance) As %Status
{
	// test if we should jump to the next window
	If $G(%request.Data("$CLOSEWINDOW",1)) {
	&html<<script language="javascript">
	self.document.location = 'ITKSetupHome.csp';
	</script></body></html>>
		Quit $$$OK
	}

	// get page ID values
	Merge tID = pInstance.IDValues
	Set tTitle1 = $$$TextHTML("The ITK Production Wizard lets you create a new ITK production: a set of components that implement the ITK messaging rules specified in the ITK registries.")
	Set tTitle2 = $$$TextHTML("Choose a package and name for the new production:")
	&html<<div style="width: 600px; margin-left: 40px;"><br>>
	&html<<div class="TextM">#(tTitle1)#<br>#(tTitle2)#</div>>

	// see if there were errors
	Set tError = $G(%request.Data("$ERROR",1)) 
	If (tError '= "") {
		// see if we know what error this is!!!
		If (tError[" #5805:") {
			Set tError = $$$TextHTML("ERROR: There is already a production with this name and package.")
		}
		ElseIf (tError[" #5802:") {
			Set tError = $$$TextHTML("ERROR: The production name and/or package name you have entered is not valid.")
		}
		Else {
			If (tError[" #5001:") Set tError = $E(tError,$F(tError," #5001:"),$L(tError))
			Set tError = $$$TextHTML("ERROR:")_" "_$ZCVT(tError,"O","HTML")
		}
		&html<<div class="Error">
		#(" "_$$$TextHTML("There were errors encountered when creating this new production:")_" ")#
		<br><b> #(" "_tError_" ")# </b>
		</div>>
		
	}

	// make sure submit comes back to this class as a Save
	&html<<form id="form">
	<input type="hidden" name="$CLASS" value="#($classname())#">
	<input type="hidden" name="$AUTOFORM_SAVE" value="1">
	<table>
	<tr><td class="label">#($$$TextHTML("Package Name"))#:</td><td><input type="text" name="Package" value="#($G(%request.Data("Package",1),"MyPackage"))#" size="50"></td></tr>

	<tr><td class="label">#($$$TextHTML("Production Name"))#:</td><td><input type="text" name="Name" value="#($G(%request.Data("Name",1),"NewProduction"))#" size="50"></td></tr>

	<tr><td class="label">#($$$TextHTML("Description"))#:</td><td><textarea name="Description" cols="50" rows="5">#($G(%request.Data("Description",1),"NewProduction"))#</textarea></td></tr>

	</table>

	<hr>
	<div style="margin-left: 25%;">
	<input type="button" value='#($$$Text(" OK "))#' onclick="btnOK();">&nbsp;
	<input type="button" value='#($$$Text("Cancel"))#' onclick="btnCancel();">
	</div>

	</form>
	</div>
	>

	Quit $$$OK
}

ClassMethod EscapeHTML(text) [ CodeMode = expression ]
{
$ZCVT(text,"O","HTML")
}

}
