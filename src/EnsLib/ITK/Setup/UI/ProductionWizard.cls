/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class EnsLib.ITK.Setup.UI.ProductionWizard Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:WRITE";

/// Enable styles that are common to all pages and dialogs for the EnsPortal application.
Parameter APPLICATION = "EnsPortal.Application";

Parameter PAGENAME = "Add System";

Parameter APPLYBUTTON = 0;

Parameter CANCELBUTTON = 1;

/// Holder for return value.
Property retValue As %ZEN.Datatype.string;

XData Style
{
}

XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<hgroup id="detailGroup">
<form id="form" cellStyle="padding:3px;">
<text label="Package Name" name="PackageName" id="txtPackageName" size="50" hint="Fully qualified package structure" required="true"/>
<text label="Production Name" name="ProductionName" id="txtProductionName" size="50" hint="Name for the switchboard production" required="true"/>
<textarea label="Production Description" name="Description" id="txtDescription" cols="50" rows="5" hint="Description for the switchboard production" required="false"/>
</form>
</hgroup>
</pane>
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit "Create a new ITK switchboard production"
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit "New ITK Switchboard Production"
}

/// Get the value that will be applied when the user presses the OK button.
/// This is implemented by subclasses.
ClientMethod getDialogValue() [ Language = javascript ]
{
	return encodeURIComponent(this.retValue);
}

Method %OnAfterCreatePage() As %Status
{
	Quit $$$OK
}

/// save production 
ClientMethod saveProd() [ Language = javascript ]
{
	if (!this.checkEdit()) { return ""; }
  	// validate and save form
  	var form = zenPage.getComponentById('form');
  	var data = form.getValuesAsObject();
	var msg = this.SaveProduction(data);
	if (msg != '') {
		alert(msg);
		return msg;
	}
	this.retValue = data.PackageName + "." + data.ProductionName;
	return "";
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.
ClientMethod ondialogFinish(action) [ Language = javascript ]
{
	return (this.saveProd() == "")
}

ClassMethod SaveProduction(pItem As %ZEN.proxyObject) As %String [ ZenMethod ]
{
	Set tmsg = ""
	Set tSC = $$$OK
	
	try {
		Do {
			Set tProdClass = pItem.PackageName _ "." _ pItem.ProductionName

			If ('$ZNAME(tProdClass,4)) {
				// bad class name
				// Set tmsg = $$$FormatText($$$Text("Invalid class or package name: %1 "), tProdClass)
				Set tmsg = "Invalid class or package name: "_tProdClass
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
				// Set tmsg = $$$FormatText($$$Text("Unable to open new production: %1 "), tProdClass)
				Set tmsg = "Unable to open new production: "_tProdClass
				Quit
			}
			Set tProduction.Name = tProdClass
			Set tProduction.Description = pItem.Description
			Set tProduction.ActorPoolSize = 2

			Set tSC = ..ConfigureITKProduction(pItem.ProductionName,tProduction,pItem.PackageName)
			If $$$ISERR(tSC) Quit
	
			//do ##class(EnsLib.ITK.UI.Reconcile).ReconcileProduction(tProdClass)


			// save production
			Set tSC = tProduction.%Save()  Quit:$$$ISERR(tSC)

			// update production class
			Set tSC = tProduction.SaveToClass()  Quit:$$$ISERR(tSC)

		} While(0)
	} catch (ex) {
		Set tSC = ex.AsStatus()	
	}

	If $$$ISERR(tSC) {
		Set tmsg = $$$StatusDisplayString(tSC)
	}
	
	Quit tmsg
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
		Set tSetting.Target = "Adapter"
		Set tSetting.Name = "CallInterval"
		Set tSetting.Value = "5"
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
		Set tSetting.Target = "Adapter"
		Set tSetting.Name = "CallInterval"
		Set tSetting.Value = "5"
		Do tItem.Settings.Insert(tSetting)

		Do pProduction.Items.Insert(tItem)

	} While(0)

	Quit $$$OK
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $CASE(pMethod, 
		"SaveProduction":..#RESOURCE,
		:"")
}

}
