/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsJBH)

Class EnsPortal.Dialog.GenerateJGProduction Extends EnsPortal.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Java Gateway Production Wizard";

/// Domain used for localization.
Parameter DOMAIN = "Ensemble";

/// User needs WRITE permissions on the %Ens_ProductionConfig resource to view this page and its subclasses.
Parameter RESOURCE = "%Ens_ProductionConfig:WRITE";

/// Holder for return value.
Property retValue As %ZEN.Datatype.string;

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css";

/// Contents of this dialog
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<spacer height="5" />
<spacer width="20" />

<form name="TheForm" id="TheForm">
<spacer height="20" />
<spacer width="5" />

<vgroup labelPosition="left" >

<spacer height="10" />
<selector name="pkgName" id="pkgName" label="Package" hidden="false" 
	enclosingStyle="padding-bottom:4px;" size="47" labelClass="labelRequired" required="true" 
	title="Choose or enter a package name for the production."
	  multiSelect="false" context="Ens.ContextSearch/ClassPackages" /> 
<spacer height="10" />
<text label="Production Name" name="txtProduction" id="txtProduction" labelClass="labelRequired" value="NewProduction" size="50"
	title="Enter a new production name in this field. Avoid using an existing name. Do not use the characters ;,:|!*-_ or $ in the name." />
<spacer height="10"/>
<text required="false" readOnly="false" hidden="false" 
 	name="ServiceName" id="ServiceName" label="Service Config Name" labelClass="labelNormal" 
	size="50" enclosingStyle="padding-bottom:4px;" 
	title="Enter a configuration item name for the Java Gateway Initiator Service. Do not use the characters ;,:|!*-$ or [ in the name. If you do not enter a name, 'EnsLib.JavaGateway.Initiator' is used."
	value="EnsLib.JavaGateway.Initiator"
	/>
<text required="true" readOnly="false" hidden="false"
name="ServiceAddress" id="ServiceAddress" label="Address" labelClass="labelNormal"
size="50" enclosingStyle="padding-bottom:4px;"
title="IP address or name of the machine where the JVM to be used by the Java Gateway Server is located."
value="127.0.0.1"
/>
<text required="true" readOnly="false" hidden="false"
name="ServicePort" id="ServicePort" label="Port" labelClass="labelRequired"
size="50" enclosingStyle="padding-bottom:4px;"
title="TCP port number for communication between the Java Gateway Server and the proxy classes in IRIS."
value="55555"
/>
<spacer height="10" />
<textarea label="Production Description" name="prodDescription" id="prodDescription" labelClass="labelNormal" value="" rows="3" cols="39"
	title="Enter a description of the production in this field. The maximum length is 500 characters."/>
<spacer height="3" />
<textarea required="false" readOnly="false" hidden="false"
    name="ServiceComment" id="ServiceComment" label="Service Comment" labelClass="labelNormal" 
	rows="3" cols="39" enclosingStyle="padding-bottom:4px;" 
	title="Provide a brief comment about the Java Gateway Initiator Service. This annotation appears in the configuration summary for the production."
	 />

</vgroup>

</form>

</pane>
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$TextHTML("Java Gateway Production Wizard")
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Create a new Production containing a Java Gateway Initiator Service")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return encodeURIComponent(this.retValue);
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',[]);
	zen('pkgName').setValue(zenPage.GetDefaultProductionName());
}

Method GetDefaultProductionName() As %String [ Internal, ZenMethod ]
{
	Quit $$$COSNamePrefix_".JavaGateway"
}

Method %OnGetJSResources(ByRef pResources As %String) As %Status [ Private ]
{
	Set pResources("msgHostErrorsStart") = $$$Text("Errors:")
	Set pResources("msgHostErrorsEnd") = $$$Text("NOTE: Because there were errors, your changes have not been saved.")
	Set pResources("msgHostFixSave") = $$$Text("To save your work, click OK in this alert box, correct the reported problems, and then click OK in the Wizard dialog.")
	Set pResources("msgProdExists") = $$$Text("A production of this name already exists in this package.")
	Set pResources("msgProdCreatePackage") = $$$Text("Please do not use the characters ;,:|!*-_ or $ in the package name.")
	Set pResources("msgProdCreatePackageEmpty") = $$$Text("Please enter or choose a package name.")
	Set pResources("msgProdCreateName") = $$$Text("Please do not use the characters ;,:|!*-_ or $ in the production name.")
	Set pResources("msgProdCreateNameEmpty") = $$$Text("Please enter a new production name.")
	Set pResources("msgProdCreateDescLong") = $$$Text("Please keep the description length under 500 characters.")
	Set pResources("msgHostBadChar") = $$$Text("Please do not use the characters ;,:|!*-$ or [ in the host name.")
	Set pResources("msgHostLong") = $$$Text("Please keep the Service Config Name length under 100 characters.")
	Set pResources("msgHostDescLong") = $$$Text("Please keep the Comment length under 500 characters.")

	Quit $$$OK
}

/// This callback is called when the user presses the OK button.
/// If this returns false, then the action is canceled.
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		var isValid = zenPage.validateAll();
		if (isValid) {
			var pkg = zenTrim(zen('pkgName').getValue());
			var prod = zenTrim(zen('txtProduction').getValue());
			var desc = zen('prodDescription').getValue();
			var msg = zenPage.OnWizardCompletion(pkg,prod,desc);
			if (msg != '') {
				isValid = false;
				alert(msg);
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
		isValid = false;
	}

	if (isValid) {
		this.retValue = pkg + "." + prod;
		return true;
	}
	else {
		this.retValue = "";
		return false;
	}
}

/// This method is invoked when the user completes the Wizard pressing "OK".
/// Returns a null string if it succeeds, or an error message otherwise.
Method OnWizardCompletion(pPackage, pName, pDescription) As %String [ ZenMethod ]
{
	Set tmsg = ""
	Try {
	Do {
		Set tProdClass = %page.%GetValueById("pkgName") _ "." _ pName

		If ('$ZNAME(tProdClass,4)) {
			Set tmsg = $$$Text("Invalid Production package or name.")
			Quit
		}

		// create empty production class
		Set tClsDef = ##class(%Dictionary.ClassDefinition).%New()
		Set tClsDef.Name = tProdClass
		Set tClsDef.Super = "Ens.Production"
		Set tClsDef.ClassVersion = 25

		Set tXData = ##class(%Dictionary.XDataDefinition).%New()
		Set tXData.Name = "ProductionDefinition"
		Do tXData.Data.WriteLine("<Production Name="""_tProdClass_"""/>")
		Do tClsDef.XDatas.Insert(tXData)

		Set tSC = tClsDef.%Save()
		Set tClsDef = ""
		Set tXData = ""
		If $$$ISERR(tSC) Set tmsg = $system.Status.GetErrorText(tSC) Quit

		// now compile the class
		Set tSC = $System.OBJ.Compile(tProdClass,"k-d")
		If $$$ISERR(tSC) Set tmsg = $system.Status.GetErrorText(tSC) Quit
		// fill in production:
		Set tProduction = ##class(Ens.Config.Production).%OpenId(tProdClass)
		If '$IsObject(tProduction) {
			Set tmsg = $$$FormatText($$$Text("Unable to open new production: '%1'"),tProdClass)
			Quit
		}
		Set tProduction.Name = tProdClass
		Set tProduction.Description = $Select(pDescription'="":pDescription,1:$$$Text("Created by the Java Gateway Production Wizard"))
		Set tProduction.ActorPoolSize = 2

		// create contents of production
		Set tSC = ..AddNewItem(tProduction)
		If $$$ISERR(tSC) {
			Set tmsg = $system.Status.GetErrorText(tSC)
			Do ##class(Ens.Director).DeleteProduction(tProdClass)
			Quit
		}
		
		// save production (and item), update production class and account for Source Control
		Set tSC = ##class(EnsPortal.Template.prodConfigSCPage).CallProductionUpdateAndSaveToClass(tProduction,"","SaveProduction")

		If $$$ISERR(tSC) Set tmsg = $system.Status.GetErrorText(tSC) Quit
		
	} While(0)
	} Catch (ex) {
		Set tmsg = ex.DisplayString()
	}

	Quit tmsg
}

/// Generic method for adding a new host
ClassMethod AddNewItem(production As Ens.Config.Production) As %Status
{
	Try {
		// add new item to production
		Set item = ##class(Ens.Config.Item).%New()
		Set item.ClassName = "EnsLib.JavaGateway.Initiator"
		Set item.Name = %page.%GetValueById("ServiceName")
		Set:item.Name="" item.Name = item.ClassName
		Set item.Category = %page.%GetValueById("ServiceCategory") 
		Set tComment = %page.%GetValueById("ServiceComment")
		Set:(tComment="") tComment = $$$Text("Created by the Java Gateway Production Wizard")
		Set item.Comment = tComment
		Set item.Enabled = 1
		
		Set setting = ##class(Ens.Config.Setting).%New()
		Set setting.Name = "Address"
		Set setting.Target = "Host"
		Set setting.Value = %page.%GetValueById("ServiceAddress")
		Do item.Settings.Insert(setting)
		
		Set setting = ##class(Ens.Config.Setting).%New()
		Set setting.Name = "Port"
		Set setting.Target = "Host"
		Set setting.Value = %page.%GetValueById("ServicePort")
		Do item.Settings.Insert(setting)

		Set tSC = production.Items.Insert(item)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClientMethod validateAll() [ Language = javascript ]
{
	var ok = true;
	var msg = zenText('msgHostErrorsStart') + '\n';

	// get package and production names
	var pkg = zenTrim(zen('pkgName').getValue());
	var prod = zenTrim(zen('txtProduction').getValue());

	// don't create duplicate productions
	var nam = pkg + '.' + prod;
	if (zenPage.ProductionAlreadyExists(nam) == 1) {
		msg += ('  ' + zenText('msgProdExists') + '\n');
		ok = false;
	}
	else {
		var len = nam.length;
		if (len > 128) {
			msg += '  ' + $$$Text("The proposed package and production name, joined together, are longer than the limit of 128 characters.") + '\n';
			ok = false;
		}
	}
	// check for and report other naming issues
	pkg = pkg.replace(/^\s+|\s+$/g, "");	
	pkg = pkg.replace(/^\t+|\t+$/g, "");
	if (pkg.match(/[;,:|!*$_-]/)) {
		msg += '  ' + zenText('msgProdCreatePackage') + '\n';
		ok = false;
	}
	else {
		var len = pkg.length;
		if (len == 0) {
			msg += '  ' + zenText('msgProdCreatePackageEmpty') + '\n';
			ok = false;
		}
	}
	if (prod.match(/[;,:|!*$_-]/)) {
		msg += '  ' + zenText('msgProdCreateName') + '\n';
		ok = false;
	}
	else {
		var len = prod.length;
		if (len == 0) {
			msg += '  ' + zenText('msgProdCreateNameEmpty') + '\n';
			ok = false;
		}
	}
	
	var name = zen('ServiceName').getValue();
	if (name !== name.replace(/^\s+|\s+$/g,'')) {
		msg += ('  ' + $$$FormatText($$$Text("Item name '%1' has leading or trailing spaces."),name) + '\n');
		ok = false;	
	}
	if (name.match(/[\[;,:|!*$-]/)) {
		msg += ('  ' + zenText('msgHostBadChar') + '\n');
		ok = false;
	}
	if (name.length > 128) { 
		msg += ('  ' + zenText('msgHostLong') + '\n');
		ok = false;
	}

	var cls = 'EnsLib.JavaGateway.Service';
	var commentOrClass = zen('ServiceComment').getValue();
	if (commentOrClass == '') commentOrClass = cls;
	if (commentOrClass.length > 500) { 
		msg += ('  ' + zenText('msgHostDescLong') + '\n');
		ok = false;
	}
	
	// Check that Port has a numerical value
	var port = zen('ServicePort').getValue()
	if ('' == port) {
		msg += ('  ' + $$$FormatText($$$Text("Please specify a TCP port number.")) + '\n');
		ok = false;
	} else if (parseInt(port).toString() != port) {
		msg += ('  ' + $$$FormatText($$$Text("Invalid TCP port number.  '%1' is not a numerical value."),port) +'\n');
		ok = false;
	}

	var descCtrl = zen('prodDescription');
	var desc = descCtrl.getValue();
	if (desc.length > 500) {
		msg += '  ' + zenText('msgProdCreateDescLong') + '\n';
		ok = false;
	}

	if (ok == false) {
		msg += ('\n' + zenText('msgHostErrorsEnd') + ' ' + zenText('msgHostFixSave') + '\n');
		alert(msg);
	}
	return ok;
}

/// This method returns a value that JavaScript can understand as 1 (true) or 0 (false). /* TODO */
ClassMethod ProductionAlreadyExists(prodCls As %String) As %Boolean [ ZenMethod ]
{
	Set found = 0 ; No production of this name was found in the package
	Set tRS = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
	Do tRS.Execute("Ens.Production") 
	If (tRS) { ; There is data 
		While ('found & tRS.Next()) { 
			If (prodCls = tRS.Data("Name")) { ; we found it
				Set found = 1 
			}
		}
	}
	Quit found ; Return the result as 1 (true) or 0 (false)
}

}
