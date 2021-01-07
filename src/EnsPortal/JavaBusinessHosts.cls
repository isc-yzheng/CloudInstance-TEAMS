/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsJBH)

/// Page for generating a Java Business Host (either type Business Service or Business Operation)
Class EnsPortal.JavaBusinessHosts Extends EnsPortal.Template.standardPage [ System = 4 ]
{

Parameter PAGENAME = "Java Business Hosts";

/// User needs WRITE permissions on either the %Ens_Code resource or the %Ens_JBH resource to view this page.
Parameter RESOURCE = "%Ens_Code:WRITE,%Ens_JBH:WRITE";

/// Is the user permitted to access the fileSelect popup.
Property canViewFileSystem As %Boolean [ Final, InitialExpression = {$system.Security.Check("%Ens_ViewFileSystem","USE")} ];

Property HostType As %String(VALUELIST = "Service,Operation") [ InitialExpression = "Operation" ];

/// Track whether we are in the middle of stopping one production and starting another one
Property InSwitchProds As %Boolean [ InitialExpression = 0 ];

/// Message to inform the user they may not perform a given action.
Property msgNotPermitted As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("You are not permitted to perform this action")} ];

/// Flag to indicate whether the user has WRITE permissions on the Databases used by this production
Property canEditDB As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Flag to indicate if the default db is mounted R/O
Property dbIsRO As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Message to inform user they don't have WRITE permissions on the DB required to perform an action
Property msgNoDBPermissions As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("This action writes to a database that you do not have WRITE permissions on.")} ];

XData Style
{
<style type="text/css">
.errorNote {
	background: #F2F1EC;
	border: 1px solid #da4848;
	border-radius: 5px;
	color: #da4848;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
	padding: 10px;
	text-align: left;
	display:inline-block;
}
.successNote {
	background: #F2F1EC;
	border: 1px solid #52b012;
	border-radius: 5px;
	color: #52b012;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
	padding: 10px;
	text-align: left;
	display:inline-block;
}
#prodPane {
	border-right: 1px solid #EDECE4;
	width: 250px;
	background: white;
	font-size: 11pt;
	color: #404040;
	padding: 8px;
	overflow: auto;
}
</style>
}

/// This XML block defines the contents of this pane.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<vgroup width="100%">
<hgroup id="mainGroup" cellVAlign="top">
<pane id="prodPane" paneName="prodPane"/>
<group valign="top">
<pane id="formPane" paneName="formPane" />
</group>
</hgroup>
</vgroup>
</pane>
}

XData prodPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<vgroup labelPosition="top" containerStyle="padding-top:4px;">
<label align="left" value="A running production with a Java Gateway Service is required in order to create Java Business Hosts."/>
<spacer height="15"/>
<label align="left" id="currProdStatus"/>
<spacer height="20"/>
<dataCombo id="activeProduction" label="Active Production:"
title="The current active production.  Select a different production to stop the current production and start the selected one."
onchange="zenPage.onChangeProductions()"
dropdownWidth="325" size="35" 
queryClass="Ens.Config.Production" queryName="EnumerateConfigItemNames" choiceColumn="1" displayColumns="1"><parameter value=""/><parameter value="EnsLib.JavaGateway.Service"/></dataCombo>
<spacer height="40"/>
<vgroup align="left" cellStyle="padding-left:5px">
<button caption="Start Active Production" id="btnStartProd" controlStyle="width:250px" controlClass="commandButton" title="Start the current production" onclick="zenPage.startProduction();"/>
<spacer height="20"/>
<button caption="Start New Production" id="btnGenProd" controlStyle="width:250px" controlClass="commandButton" title="Create a new production which includes a Java Gateway Initiator Service" onclick="zenPage.genJGProduction();"/>
<spacer height="20"/>
<button caption="New Java Gateway Service" id="btnGenInit" controlStyle="width:250px" controlClass="commandButton" title="Create a new Java Gateway Initiator Service within the current production" onclick="zenPage.genInitService();"/>
<spacer height="20"/>
<button caption="Enable Java Gateway Service" id="btnStartJG" controlStyle="width:250px" controlClass="commandButton" title="Enable the current production's Java Gateway Service" onclick="zenPage.enableJGService();"/>
 </vgroup>
 </vgroup>

</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="formGroup" containerStyle="padding:20px">
<hgroup cellVAlign="top">
<spacer width="5"/>
<vgroup>
<spacer height="10" />
<titleBox id="id_Title" title="Java Business Host Generator" 
		subtitle="Supply the values needed to generate a Java Business Host" />
<spacer height="10" />
<vgroup id="idshowform" groupStyle="background:#F7ECD7;">
<form id="theForm" width="100%" layout="vertical" cellStyle="padding: 2px; padding-left: 10px; padding-right: 10px;" >
<vgroup labelPosition="top">
<spacer height="25"/>
<vgroup id="inputGroup" disabled="true">
<hgroup cellVAlign="bottom">
<text id="jarFile" name="jarFile" align="left" required="true" label="Path to Jar file" size="125" 
title="Path to the Jar file containing the Java class" onchange="zenPage.onFileSelect(zenThis.getValue());"/>
<button id="btnBrowse" caption="Browse..." controlClass="commandButton" containerStyle="padding-left:2px;" onclick="zenPage.browseSelect();"/>
</hgroup>
<spacer height="15" />
<select id="javaClass" name="javaClass" required="true" align="left" label="Name of Java Class" showEmpty="false" controlStyle="width:440px;"
 disabled="true" onfocus="this.oldvalue = zenThis.getValue();"
 onchange="zenPage.setDefaultName(this.oldvalue); this.oldvalue = zenThis.getValue(); zenPage.determineHostType();" queryClass="EnsPortal.JavaBusinessHosts" queryName="JavaClasses"><parameter id="jarFileParam" value=""/></select>
<spacer height="15" />
<text id="genClass" name="genClass" align="left" required="true" label="ObjectScript Class" size="70" title="Name of ObjectScript class to be generated" />
<spacer height="15"/>
<hgroup labelPosition="left">
<selector name="Credentials" id="selCredentials" label="Default credentials:" title="Default credentials for Java to use when authenticating with IRIS.  This can be modified for individual config items on the Production Configuration page."
context="Ens.ContextSearch/Credentials" size="30"/>
<spacer width="2"/>
<image valign="bottom" src="deepsee/zoom_24.png" id="btnCredentials" title="Show details for the selected Credentials." onclick="zenPage.showCredentialsDetails();"/>
</hgroup>
<spacer height="5"/>
<group id="ServiceSpecs" labelPosition="left" hidden="true" width="100%">
<spacer height="20"/>
<label value="Business Service Details" labelStyle="font-family:Arial;" enclosingStyle="font-size:10pt;color:#434343"/>
<spacer height="5"/>
<vgroup enclosingStyle="border:1px solid #434343;border-radius:5px;padding:5px;" >
<spacer height="15"/>
<hgroup labelPosition="left">
<select id="inputFormat" name="inputFormat" label="Format of Incoming Data:" title="What is the format of the data being sent into this Business Service from the Java class?"
displayList="ASTM,EDIFACT,HL7,Plain Text,XML,X12" valueList="ASTM,EDIFACT,HL7,Stream,XML,X12"
showEmpty="false" value="Stream"/>
</hgroup>
<spacer height="15"/>
</vgroup>
</group>
</vgroup>
<spacer height="90"/>
<button caption="Generate" id="btnGenerate"  align="center" valign="middle" onclick="zenPage.OnGenerate()" controlClass="commandButton" title="Generate Java Business Host" />
<spacer height="20"/>
</vgroup>
</form>
</vgroup>
</vgroup>
</hgroup>
</pane>
}

/// User clicked the Browse button.
ClientMethod browseSelect() [ Language = javascript ]
{
	if (!this.canViewFileSystem) {
		alert(this.msgNotPermitted);
		return false;
	}
	var Dir = zen('jarFile').getValue();
	if (Dir=="") Dir = zenPage.GetDefaultDir();
	parms = {
		Dir:Dir,
		wildcard:'*.jar'
	}
	var url = zenLink('%ZEN.Dialog.fileSelect.cls',this.studioMode);
	zenPage.launchPopupWindow(url,this.addPopupSuffix('fileSelect'),'resizable,width=660,height=700',parms);
}

/// Launch the profile info dialog.
ClientMethod showCredentialsDetails() [ Language = javascript ]
{
	var name = zen('selCredentials').getValue();
	if (''==name) {
		alert($$$Text('Click here after selecting a pair of credentials, to see the credentials\' details'));
		return;
	}
	var link = zenLink('EnsPortal.Credentials.zen');
	link += (link.indexOf('?') > -1) ? '&' : '?';
	link += 'ID=' + encodeURIComponent(name);
	window.open(link);
}

ClientMethod genInitService() [ Language = javascript ]
{
	var url = zenLink('EnsPortal.Dialog.GenerateJGInitiator.cls',this.studioMode);
	zenPage.launchPopupWindow(url,this.addPopupSuffix('genInitService'),'resizable,width=500,height=450','');
}

ClientMethod enableJGService(preSelected, selectedItem) [ Language = javascript ]
{
	if (preSelected) {
		var svc = selectedItem;
		if (svc == "") return;
	} else {
		var svc = zenPage.SingleJGService();
	}
	if ("" != svc) {
		var enabled = parseInt(svc.substring(0,1),10);
		var fullName = svc.substring(1)
		var name = fullName.split("|")[2];
		if (enabled) {
			alert($$$FormatText($$$Text("Java Gateway Service '%1' already enabled"),name));
		} else {
			if (preSelected || confirm($$$FormatText($$$Text("Do you want to enable Java Gateway Service '%1'?"),name))) {
				var err = zenPage.DoEnableJGService(fullName);
				if ("" != err) {
					alert(err);
				} else {
					if (zenPage.GetProductionState() == 1) {
						var active = zenPage.GetActiveProductionName();
						zenPage.updateProduction('update',active);
					} else {
						// in case production is stopped, make sure to provide feedback, but Update dialog won't be helpful
						alert($$$FormatText($$$Text("Successfully enabled Java Gateway Service '%1'."),name));
					}
				}
			}
		}
	} else {
		var parms = "";
		zenPage.launchPopupWindow(zenLink('EnsPortal.Dialog.StartJGService.zen'),this.addPopupSuffix('EnableItem'),'resizable=yes,width=380,height=190',parms);
	}
	zenPage.updateProdPanel();
}

ClassMethod DoEnableJGService(pConfigName) As %String [ ZenMethod ]
{
	Set tSC = ##class(Ens.Director).EnableConfigItem(pConfigName,1,0)
	If $$$ISERR(tSC) {
		Quit $System.Status.GetErrorText(tSC)
	} Else {
		Quit ""
	}
}

/// Set a default ObjectScript class name based on the Java class name
ClientMethod setDefaultName(oldValue) [ Language = javascript ]
{
	var oldJavaName = oldValue.split("|")[1];
	var OldDefault = zenPage.GetExternalNameFor(oldJavaName);
	var CacheName = zen('genClass').getValue();
	if (CacheName != OldDefault) return; // don't overwrite value set by user
	var newValue = zen('javaClass').getValue();
	var javaName = newValue.split("|")[1];
	var COSName = zenPage.GetExternalNameFor(javaName);
	zen('genClass').setValue(COSName);
}

ClassMethod GetExternalNameFor(pJavaName As %String) As %String [ Internal, ZenMethod ]
{
	#dim tClassName As %String = ""
	#dim tNamePiece As %String = ""
	Quit:""=pJavaName tClassName ; nothing to work with
	Set tClassName = $$$COSNamePrefix
	For i=1:1:$L(pJavaName,".") {
		Set tNamePiece = $P(pJavaName,".",i)
		Set tClassName = tClassName_"."_$zcvt($E(tNamePiece),"U")_$E(tNamePiece,2,*)
	}
	Quit tClassName
}

ClientMethod determineHostType() [ Language = javascript ]
{
	var val = zen('javaClass').getValue();
	var parent = val.split("|")[0];
	var isSvc = zenPage.IsJavaBS(parent);
	zenPage.onDetermineHostType(isSvc);
}

ClassMethod IsJavaBS(pSuperClass) As %Boolean [ ZenMethod ]
{
	Quit pSuperClass=$$$JavaBS
}

ClientMethod onDetermineHostType(isService) [ Language = javascript ]
{
	zenPage.HostType = isService ? "Service" : "Operation";
	zen('ServiceSpecs').setHidden(!isService);
}

/// Validate the contents of the form.
ClientMethod validate() [ Language = javascript ]
{
	var form = zen('theForm');
	if (form) {
		var valid = form.validate();
		if (!valid) return false;
	}
	return true;
}

ClassMethod CheckFileExists(pFilename As %String) As %Boolean [ ZenMethod ]
{
	Quit ##class(%File).Exists(pFilename)&&'##class(%File).DirectoryExists(pFilename)
}

Query JavaClasses(pJarFile As %String) As %Query(ROWSPEC = "ClassAndType:%String,Class:%String") [ SqlProc ]
{
}

ClassMethod JavaClassesExecute(ByRef qHandle As %Binary, pJarFile As %String) As %Status
{
	Set qHandle = ""
	Do ##class(Ens.Java.Utils).ScanJar(pJarFile,.qHandle)
	Quit $$$OK
}

ClassMethod JavaClassesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JavaClassesExecute ]
{
	Set qHandle = $O(qHandle(qHandle))
	If ""'=qHandle {
		Set Row = $lb(qHandle(qHandle)_"|"_qHandle,qHandle_" ("_$Case(qHandle(qHandle),$$$JavaBS:$$$Text("Business Service"),:$$$Text("Business Operation"))_")")
	} Else {
		Set Row=""
		Set AtEnd = 1
	}
	Quit $$$OK
}

ClassMethod JavaClassesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JavaClassesFetch ]
{
	Kill qHandle
	Quit $$$OK
}

/// Generate the requested business host
ClientMethod OnGenerate() [ Language = javascript ]
{
	if (!this.checkEdit()) return false;
	if (!this.validate()) return false;
	
	if (1111 != zenPage.DetectIsJGRunning()) {
		zenPage.updateProdPanel();
		return false;
	}

	var jar = zen('jarFile').getValue();
	var java = zen('javaClass').getValue().split("|")[1];
	var COS = zen('genClass').getValue();
	var format = zen('inputFormat').getValue();
	var credentials = zen('selCredentials').getValue();
	
	parms = {
		JARFILE:jar,
		JAVACLASS:java,
		COSNAME:COS,
		FORMAT:format,
		CREDENTIALS:credentials
	}
	var url = this.GetLink();
	zenPage.launchPopupWindow(url,this.addPopupSuffix('generate'),'status,scrollbars,resizable=yes,width=800,height=600',parms);
}

Method GetLink() As %String [ ZenMethod ]
{
	Quit ..Link("EnsPortal.Dialog.ImportJBH.cls")
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Java Business Hosts", "Ensemble")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Quit $$$OK
}

/// Populate the controls as needed.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set tSC = ..hasDBPermissions(.DBPermissions, .DB)
	If $$$ISOK(tSC) {
		Set ..canEditDB = DBPermissions
		Set:DB'="" ..msgNoDBPermissions=$$$FormatText($$$Text("This action requires write privilege for the %1 database resource."),DB)
		If ..canEditDB {
			Set IsReadOnly = ..defaultMountedReadOnly(.tSC)
			If $$$ISOK(tSC) && IsReadOnly {
				Set ..msgNoDBPermissions=$$$TextJS("The default database is mounted Read Only.")
				Set ..canEditDB = 0
				Set ..dbIsRO = 1
			}
		}
	}
	
	If '..canEdit {
		Set tGenerate = ..%GetComponentById("btnGenerate")
		Set tGenerate.disabled = 1
	}
	
	Set tClasses = ..%GetComponentById("javaClass")
	Set tClasses.title = $$$FormatText($$$Text("Name of the Java class which implements %1 or %2"),$$$JavaBS,$$$JavaBO)

	//Amend according to packages installed: displayList="ASTM,EDIFACT,HL7,Plain Text,XML,X12" valueList="ASTM,EDIFACT,HL7,Stream,XML,X12"
	#dim inputFormatRadio = ..%GetComponentById("inputFormat")
	#dim tPackages
	Set tPackages("ASTM")=""
	Set tPackages("EDIFACT")=""
	Set tPackages("XML")=""
	Set tPackages("HL7")=""
	Set tPackages("X12")=""
	#dim tOption = ""
	#dim tClass = ""
	For {
		Set tOption = $Order(tPackages(tOption))
		If tOption = "" Quit
		If '##class(%Library.InteroperabilityMgr).IsPackageInstalled(tOption) {
			Set inputFormatRadio.valueList = $Replace($Replace(inputFormatRadio.valueList,tOption,""),",,",",")
			Set inputFormatRadio.displayList = $Replace($Replace(inputFormatRadio.displayList,tOption,""),",,",",")
			#; Check for leading , and remove
			If $Extract(inputFormatRadio.valueList)="," Set inputFormatRadio.valueList = $Extract(inputFormatRadio.valueList,2,*)
			If $Extract(inputFormatRadio.displayList)="," Set inputFormatRadio.displayList = $Extract(inputFormatRadio.displayList,2,*)
		}
	}
	Quit $$$OK
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $Case(pMethod, "DoEnableJGService":"%Ens_ConfigItemRun:USE", :"")
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',[]);
	
	var active = zen('activeProduction');
	if (zenIsGecko || zenIsIE) {
		active.setProperty('size',35);
	} else {
		active.setProperty('size',28);
	}
	active.refreshContents();

	zenPage.updateProdPanel();
}

ClientMethod updateProdPanel() [ Language = javascript ]
{
	var isJGRunning = zenPage.DetectIsJGRunning();
	var msg = zen('currProdStatus');
	var activeProd = zen('activeProduction');
		
	if (isJGRunning == 1111) {
		msg.setProperty('enclosingClass','successNote');
		msg.setValue($$$Text("The active production is running and does contain a Java Gateway Service"));
				
		zen('btnBrowse').setProperty('controlClass','commandButton');
		zen('btnGenerate').setProperty('controlClass','commandButton');
		zen('inputGroup').setProperty('disabled',false);
		
		// it's possible for a jar file value to have been selected already but for the java class selector to be unpopulated
		// if the java gateway service was troubled at the time when the jar file was selected
		var javaClasses = zen('javaClass');
		var filename = zen('jarFile').getValue();
		if ("" != filename) {
			zen('jarFileParam').value = filename;
			
			// synchronous mode so refresh complete before check options length
			var old = zenSynchronousMode;
			zenSynchronousMode = true;
			javaClasses.refreshContents();
			zenSynchronousMode = old;
		}
		if (javaClasses.findElement('control').options.length < 1) {
			// make sure selector stays disabled if no values to choose from
			javaClasses.setProperty('disabled',true);
			// if a filename is selected, then it must be invalid in order for there to be no options
			zen('jarFile').setProperty('invalid',("" != filename));
		} else {
			zen('jarFile').setProperty('invalid',false);
		}
	} else {
		msg.setProperty('enclosingClass','errorNote');

		zen('inputGroup').setProperty('disabled',true);
		zen('btnGenerate').setProperty('controlClass','commandButtonDisabled');
		zen('btnBrowse').setProperty('controlClass','commandButtonDisabled');
	}
	
	// isJGRunning not an integer means it's an error message
	if (isNaN(isJGRunning)) {
		msg.setProperty('enclosingClass','errorNote');
		msg.setValue(isJGRunning);
		
		activeProd.setProperty('showEmpty',true);
		activeProd.setValue('');
	} else {
		var prodRunning = parseInt(isJGRunning.charAt(0),10);
		var hasJG = parseInt(isJGRunning.charAt(1),10);
		var isServiceRunning = parseInt(isJGRunning.charAt(2),10);
		if (isJGRunning === "0") {
			msg.setValue($$$Text('There is no current active production.  Select a production from the list or generate a new one.'));
			
			activeProd.setProperty('showEmpty',true);
			activeProd.setValue('');

			var btns = ['btnStartProd','btnGenInit','btnStartJG'];
			for (i=0; i<btns.length; i++) {
				zenPage.changeBtnState(btns[i],0);
			}
		} else {
			var currentProd = zenPage.GetActiveProductionName();
			if (hasJG) {
				activeProd.setProperty('showEmpty',false);
			} else {
				// if active production doesn't have a Java Gateway Service, it isn't already listed
				activeProd.setProperty('emptyText',currentProd);
				activeProd.setProperty('showEmpty',true);
			}
			activeProd.setValue(currentProd);
			
			if (prodRunning) {
				zenPage.changeBtnState('btnStartProd',0);
			} else {
				zenPage.changeBtnState('btnStartProd',1);
				if (isServiceRunning) {
					msg.setValue($$$Text('No production is currently running, but the active production does include a Java Gateway Service.'));
				}
			}
			
			if (isServiceRunning) {
					zenPage.changeBtnState('btnStartJG',0);
					zenPage.changeBtnState('btnGenInit',0);
					
				if (prodRunning) {
					var isServiceOK = parseInt(isJGRunning.charAt(3),10);
					if (isServiceOK == 0) {
						msg.setValue($$$Text('The current status of the running Java Gateway Service is not okay.  Please check the Event Log for details.'));
					}
				}
			} else {
				if (hasJG) {
					zenPage.changeBtnState('btnStartJG',1);
					if (prodRunning) {
						msg.setValue($$$Text('The active running production includes a Java Gateway Service, but it is not enabled.')); 
					} else {
						msg.setValue($$$Text('No production is currently running.')+'  '+$$$Text("The active production does include a Java Gateway Service, but it is not enabled."));
					}

				} else{
					zenPage.changeBtnState('btnStartJG',0);
					if (prodRunning) {
						msg.setValue($$$Text('The active running production does not include a Java Gateway Service.'));
					} else {
						msg.setValue($$$Text('No production is currently running.')+'  '+$$$Text("No Java Gateway Services are present in the active production."));
					}

				}
				zenPage.changeBtnState('btnGenInit',1);
			}
		}
	}
}

ClientMethod changeBtnState(btnName, enabled) [ Language = javascript ]
{
	var btn = zen(btnName);
	if (btn) {
		var cls = enabled ? 'commandButton' : 'commandButtonDisabled';
		btn.setProperty('controlClass',cls);
		btn.setProperty('disabled',!enabled);
	}
}

ClientMethod onFileSelect(filename) [ Language = javascript ]
{
	zenPage.SetDefaultDir(filename);
	zen("jarFile").setValue(filename);
	zen('jarFileParam').value = filename;
	var javaClasses = zen('javaClass');
	var oldJavaClass = javaClasses.getValue();
	
	// synchronous mode so refresh doesn't take place after set to empty and overwrite value
	var old = zenSynchronousMode;
	zenSynchronousMode = true;
	javaClasses.refreshContents();
	javaClasses.setValue('');
	zenSynchronousMode = old;
	
	zenPage.determineHostType();
	zenPage.setDefaultName(oldJavaClass);
	
	if (!zenPage.CheckFileExists(filename)) {
		alert($$$FormatText($$$Text("File '%1' does not exist.  Try selecting a different jar file."),filename));
		javaClasses.setProperty('disabled',true);
		zen('jarFile').setProperty('invalid',true);
	}
	else if (javaClasses.findElement('control').options.length < 1) {
		// test for errored java gateway service before blaming the jar file
		if ("" == zenPage.CheckJGStatus()) {
			alert($$$Text('The selected file does not contain any classes which can be imported as a java business host.  Try selecting a different jar file.'));
			javaClasses.setProperty('disabled',true);
			zen('jarFile').setProperty('invalid',true);
		} else {
			zenPage.updateProdPanel();
		}
	} else {
		javaClasses.setProperty('disabled',false);
		zen('jarFile').setProperty('invalid',false);
	}
}

ClassMethod CheckJGStatus() As %String [ ZenMethod ]
{
	Set tSC = ##class(Ens.Java.Utils).FindJavaGateway()
	Quit $Select($$$ISERR(tSC):$System.Status.GetErrorText(tSC),1:"")
}

/// Returning from file select and setting the value into the appropriate field.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return false;
	popupName = this.removePopupSuffix(popupName);
	switch(popupName) {
		case 'fileSelect' :
			zenPage.onFileSelect(value);
			break;
		case 'EnableItem' :
			setTimeout(function() {
				zenPage.enableJGService(1,value);
			}, 300);
			break;
		case 'genInitService' :
			if (value == 1) {
				if (zenPage.GetProductionState() == 1) {
					var active = zenPage.GetActiveProductionName();
					setTimeout(function() {
						zenPage.updateProduction('update',active);
					}, 300);
				} else {
					// in case production is stopped, make sure to provide feedback, but Update dialog won't be helpful
					alert($$$Text('Successfully added the Java Gateway Initiator Service to the active production'));
				}
			}
			zenPage.updateProdPanel();
			break;
		case 'genJGProd' :
			if (value != "") {
				setTimeout(function() {
					zenPage.updateProduction('start',value);
				}, 300);
			}
			zenPage.updateProdPanel();
			break;
		case 'UpdateProduction' :
			if (zenPage.InSwitchProds) {
				zenPage.InSwitchProds = 0;
				var selected = zen('activeProduction').getValue();
				var active = zenPage.GetActiveProductionName();
				if (selected != active) {
					// selected a different production from the combobox
					if (zenPage.GetProductionState() == 2) {
						if (!this.checkHelper('RunProd')||!this.checkEditDB()) {
							return false;
						}
						setTimeout(function() {
							zenPage.updateProduction('start',selected);
						}, 300);
					} else {
						alert($$$FormatText($$$Text("Production '%1' did not stop.  Unable to start Production '%2'."),active,selected));
						zenPage.updateProdPanel();
					}
				} else {
					// creating a new production
					if (zenPage.GetProductionState() == 2) {
						if (!this.checkHelper('RunProd')||!this.checkEditDB()) {
							return false;
						}
						setTimeout(function() {
							zenPage.genJGProduction();
						}, 300);
					} else {
						alert($$$FormatText($$$Text("Production '%1' did not stop.  Unable to start a new production."),active));
						zenPage.updateProdPanel();
					}
				}
			} else {
				zenPage.updateProdPanel();
			}
			break;
		case 'switchNamespace':
			zenPage.changeURLNamespace(value);
			break;
	}
}

ClassMethod GetDefaultDir() As %String [ ZenMethod ]
{
	Quit $G(^EnsPortal.Settings($USERNAME, "ImportExportDir"))
}

ClassMethod SetDefaultDir(pPathname As %String) [ ZenMethod ]
{
	Set ^EnsPortal.Settings($USERNAME, "ImportExportDir") = ##class(%File).GetDirectory(pPathname, 1)
}

ClassMethod GetProductionState() As %Integer [ ZenMethod ]
{
	Set tSC = ##class(Ens.Director).GetProductionStatus(.tProductionName,.tState)
	Quit tState
}

/// Start the Production.
ClientMethod startProduction() [ Language = javascript ]
{
	var prodName = zenPage.GetActiveProductionName();
	if (zenPage.GetProductionState() == 1) {
		alert($$$FormatText($$$Text("Production '%1' is already running"),prodName));
		zenPage.updateProdPanel();
	} else {
		if (!this.checkHelper('RunProd')||!this.checkEditDB()) {
			return false;
		}
		if (confirm($$$FormatText($$$Text("Do you wish to start Production '%1'?"),prodName))) {
			zenPage.updateProduction('start',prodName);
		}
	}
}

ClientMethod genJGProduction() [ Language = javascript ]
{
	if (zenPage.GetProductionState() == 1) {
		var prodName = zenPage.GetActiveProductionName();
		if (!confirm($$$FormatText($$$Text("Production '%1' is already running.  Are you sure you wish to stop Production '%1' and create a a new Production?"),prodName))) {
			return false;
		}
		zenPage.InSwitchProds = 1;
		zenPage.updateProduction('stop',prodName);
	} else {	
		var url = zenLink('EnsPortal.Dialog.GenerateJGProduction.cls',this.studioMode);
		zenPage.launchPopupWindow(url,this.addPopupSuffix('genJGProd'),'resizable,width=660,height=700','');
	}
}

ClientMethod onChangeProductions() [ Language = javascript ]
{
	var active = zenPage.GetActiveProductionName();
	var selected = zen('activeProduction').getValue();
	if (zenPage.GetProductionState() == 1) {
		if (active == selected) {
			alert($$$FormatText($$$Text("Production '%1' is already running"),active));
		} else {
			if (confirm($$$FormatText($$$Text("Production '%1' is already running.  Are you sure you wish to stop Production '%1' and start Production '%2'?"),active,selected))) {
				zenPage.InSwitchProds = 1;
				zenPage.updateProduction('stop',active);
				return;
			}
		}
	} else {
		if (this.checkHelper('RunProd')&&this.checkEditDB()) {
			if (confirm($$$FormatText($$$Text("Do you wish to start Production '%1'?"),selected))) {
				zenPage.updateProduction('start',selected);
				return;
			}
		}
	}
	zenPage.updateProdPanel();
}

/// This client method handles start / stop / update / recover Production.
/// A popup is displayed containing progress messages.
ClientMethod updateProduction(action, production) [ Language = javascript ]
{
	var doUpdate = false;
	switch (action) {
		case 'start':
		case 'stop':
			doUpdate = this.checkHelper('RunProd', true);
			break;
		case 'update':
			doUpdate = (this.checkHelper('RunProd',true) || this.checkHelper('RunItem', true));
			break;
	}
	if (!doUpdate || !this.canEditDB) {
		alert(!doUpdate ? this.msgNotPermitted : this.msgNoDBPermissions);
		return true;
	}

	var parms = {
		PRODUCTION: production,
		ACTION: action,
	};
	zenLaunchPopupWindow(zenLink('EnsPortal.Dialog.UpdateProduction.zen'),this.addPopupSuffix('UpdateProduction'),'status,scrollbars,resizable=yes,width=700,height=600',parms);
}

ClientMethod checkEditDB() [ Language = javascript ]
{
	if (!this.canEditDB) {
		alert(this.msgNoDBPermissions);
	}
	return this.canEditDB;
}

ClassMethod hasDBPermissions(ByRef tOK, ByRef DB As %String = "") As %Status [ ZenMethod ]
{
	Set tOK = 1, tSC = $$$OK
	// Check whether user has WRITE permissions on ^Ens.ConfigItemD and ^Ens.Config.ProductionD
	Set tRS = ##class(%Library.ResultSet).%New("%SYS.GlobalQuery:NameSpaceList")
	Set tSC = tRS.Execute($namespace,"Ens.Config.ProductionD,Ens.Config.ItemD")
	Quit:$$$ISERR(tSC) tSC
	While tRS.%Next(.tSC) {
		Quit:$$$ISERR(tSC)
		Set resource = tRS.Data("ResourceName")
		If '$system.Security.Check(resource,"WRITE") Set tOK=0, DB=resource Quit
	}
	Quit tSC
}

ClassMethod defaultMountedReadOnly(ByRef pSC As %Status) As %Boolean [ Internal, ZenMethod ]
{
	#dim tIsRO As %Integer = 0
	#dim e As %Exception.SystemException
	#dim tInfo As %String
	Set pSC = $$$OK
	Try {
		Do ##class(%SYS.Namespace).GetNSInfo($namespace,.tInfo)
		Set tIsRO = $G(tInfo("ReadOnly"),0)
		Set pSC = $G(tInfo("Status"),1)
	} Catch e {Set pSC = e.AsStatus()}
	Quit tIsRO
}

ClientMethod checkHelper(toCheck, noAlert) [ Language = javascript ]
{
	if ((toCheck == null) || (!this.securityHelper) || (this.securityHelper[toCheck] == null)) {
		return true;
	}
	if (parseInt(this.securityHelper[toCheck],10) != 1) {
		if (!noAlert) {
			alert(this.msgNotPermitted);
		}
		return false;
	}
	return true;
}

ClientMethod updateSecurityHelper() [ Language = javascript ]
{
	var newHelper = zenPage.GetSecurityHelper();
	if (newHelper) {
		zenPage.securityHelper = newHelper;
	}
	return true;
}

ClassMethod GetSecurityHelper() As %ZEN.proxyObject [ ZenMethod ]
{
	Set tSecurityHelper = ##class(%ZEN.proxyObject).%New()
	
	// List of checked values for the user: propertyName, resource, permission
	Set tChecks = $lb(	$lb("RunProd", "%Ens_ProductionRun", "USE"),
						$lb("RunItem", "%Ens_ConfigItemRun","USE"))
	
	For i=1:1:$ll(tChecks) {
		Set tCheck = $lg(tChecks, i)
		Set tArray($lg(tCheck, 1)) = $system.Security.Check($lg(tCheck, 2), $lg(tCheck, 3))
	}
	
	Do tSecurityHelper.%CopyFromArray(.tArray)
	Quit tSecurityHelper
}

ClassMethod GetActiveProductionName() As %String [ ZenMethod ]
{
	Quit ##class(Ens.Director).GetActiveProductionName()
}

ClassMethod SingleJGService() As %String [ ZenMethod ]
{
	Set tConfigName = ""
	Set tProdName = ##class(Ens.Director).GetActiveProductionName()
	Quit:(tProdName="") ""	
	
	set tStatement = ##class(%SQL.Statement).%New()
	Set tSC = tStatement.%PrepareClassQuery("Ens.Config.Production","EnumerateConfigItemNames")
	Set tRS = tStatement.%Execute(tProdName,"EnsLib.JavaGateway.Service")
	If tRS.%SQLCODE && (tRS.%SQLCODE '= 100) {
		Quit ""
	} Else {
		While tRS.%Next() {
			Set tCount = $i(tCount)
			Set tConfigName = tRS.%Get("ConfigName")
			set tClassName = tRS.%Get("ClassName")
			set tComment = tRS.%Get("Comment")
			Set tCommentOrClassname = $S(tComment'="":tComment,1:tClassName)
			Set tEnabled = tRS.%Get("Enabled")
			Quit:tCount>1
		}
	}
	Quit $Select(tCount=1:tEnabled_tProdName_"||"_tConfigName_"|"_tCommentOrClassname,1:"")
}

/// Returns status of the current active production wrt Java Gateway
/// Returns 0 if there is no active production
/// Returns error text if an error is encountered
/// Otherwise returns 3 digit integer which is the concatenation of 3 booleans: Is the production running?, Is there a Java Gateway Service?, If so is that running?
ClassMethod DetectIsJGRunning() As %String [ ZenMethod ]
{
	Set tProdName = ##class(Ens.Director).GetActiveProductionName()
	If tProdName="" {
		// No active production
		Quit 0
	}
	
	Set tSC = ##class(Ens.Director).GetProductionStatus(,.tProdStatus)
	Quit:$$$ISERR(tSC) $System.Status.GetErrorText(tSC)
	
	If $Case(tProdStatus,$$$eProductionStateStopped:1,$$$eProductionStateSuspended:1,:0) {
		Set tProdRunning = 0
	} Elseif (tProdStatus=$$$eProductionStateRunning) {
		Set tProdRunning = 1
	} Else {
		// error in current production - user needs to fix
		Quit $$$Text("The status of the current production is troubled or unknown.  Look at the Production Configuration page for more information.")
	}
	
	set tStatement = ##class(%SQL.Statement).%New()
	Set tSC = tStatement.%PrepareClassQuery("Ens.Config.Production","EnumerateConfigItemNames")
	Set tRS = tStatement.%Execute(tProdName,"EnsLib.JavaGateway.Service")
	If tRS.%SQLCODE && (tRS.%SQLCODE '= 100) {
		Quit $System.Status.GetErrorText($$$ERROR($$$SQLCode, tRS.%SQLCODE, tRS.%Message))
	} Else {
		Set tJGFound = $Case(tRS.%Next(), 0:0, :1)
	}
	
	If tJGFound {
		Set tJGRunning = 0
		Do {
			Set tConfigName = tRS.%Get("ConfigName")
			If ##class(Ens.Director).IsItemEnabled(tConfigName) {
				// Make certain that the running config item is the Java Gateway Service and not another Config Item of the same name
				Set tClass = ##class(Ens.Config.Production).OpenItemByConfigName(tConfigName).ClassName
				If $classmethod(tClass,"%Extends","EnsLib.JavaGateway.Service") {
					Set tJGRunning = 1
					Set tJGOK = $Select($$$GetHostMonitor(tConfigName,$$$eMonitorStatus)="OK":1,1:0)
					Quit
				}
			}
		} While tRS.%Next()
	} Else {
		Set tJGRunning = 0
	}

	Quit tProdRunning_tJGFound_tJGRunning_$G(tJGOK)
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	this.adjustSizes();
}

ClientMethod adjustSizes() [ Language = javascript ]
{
	try {		
		
		var prodDiv = zen('prodPane').getEnclosingDiv();

		var winHeight = zenGetWindowHeight();
		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 25;
		prodDiv.style.height = hgt + 'px';
		
	} catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

}
