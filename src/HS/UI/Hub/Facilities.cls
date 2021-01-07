/// Healthshare Facility maintenance page.
Class HS.UI.Hub.Facilities Extends HS.UI.HubCRUDTemplate
{

/// Displayed name of this page.
Parameter PAGENAME = "HealthShare Facility";

/// Security requirement
Parameter RESOURCE = "%HSAdmin_HubManagement";

/// Current Facility ID selected. It is null if it is adding a new one. 
Property PID As %String;

/// Current EndPoint ID selected. It is null if it is adding a new one. 
Property EPID As %String;

Property msgaddIP As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Please enter an IP address before clicking Add.")} ];

Property msgcancelItem As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to discard changes and reset form?")} ];

Property msgnothingDelete As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Nothing selected to delete.")} ];

Property msgdeleteFac As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Do you wish to delete this facility?")} ];

Property msgenterFac As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Please enter a Facility Code.")} ];

Property msgInvalidFac As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Invalid Facility Code.  Please remove any spaces or apostrophes.")} ];

Property msgenterType As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Please select a Service Type.")} ];

Property msgconfirmFac As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("This Facility Code already exists. Do you want to override the existing code?")} ];

Property msgconfirmFacIgnoreCase As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("A similar Facility Code exists.  Are you sure you want to create a facility with this name?")} ];

XData Style
{
<style type="text/css">
#table {
	width: 100%;
	overflow: auto;
	border: solid gray 1px;	
}
/* @doc="Item within listBox. Set the font size for this form." */
.listBox {
	border: 1px #77A8D0 solid;
}
.listBoxItem {
	font-size:10px;
}
.listBoxItemSelected {
	font-size:10px;
}
/* @doc="Selected item within listBox." */
.listBoxItemFocus {
	font-size:10px;
}

.multiStyle {
	color: black;
	text-decoration: none;
	font-size: .8em;
	width: 8em;
}

</style>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML("Facility Registry")	
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

XData detailPane
{
<pane xmlns="http://www.intersystems.com/zen">
<tableNavigatorBar tablePaneId="pickList" showPageSize="true" />
<tablePane id="pickList" sql="Select ID,Name,FacilityCode,Description,Contact_FirstName||CHAR(32)||Contact_LastName As Contact,FacilityId,Gateway->Name As GatewayName FROM HS_Facility.Config"
maxRows="10000"
showFilters="true"
showQuery="false"
showZebra="true"
useKeys="true" 
useSnapshot="true" 
valueColumn="ID"
pageSize="15"
onselectrow="zenPage.rowSelected(zenThis,which);">
<column colName="ID" hidden="true"/>
</tablePane>
</pane>
}

XData formPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<spacer height="1"/>
<tabGroup id="tabs" showTabBar="false" width="100%" height="495px">
<tab id="tab1" caption="General" labelPosition="left" cellStyle="padding:4px;">
<!--spacer height="1"/-->
<text id="FacilityCode" label="Facility Code *" size="60" />
<hgroup label="Name" labelPosition="left" cellAlign="even">
<text id="Name" size="27" />
<text id="FacilityId" label="FacilityId " size="16" />
</hgroup>
<text id="Description" label="Description" size="60" />
<hgroup  label="Contact First Name" labelPosition="left" cellAlign="even">
<text id="FirstName" size="27" />
<text id="LastName" label="Last " size="20" />
</hgroup>
<hgroup label="Tier" labelPosition="left" cellAlign="left">
<text id="Tier" size="10"/>
<spacer width="50"/>
<checkbox id="Home" label="Home Facility"/>
</hgroup>
<text id="Organization" label="Contact Organization" size="60" />
<hgroup label="Contact EMail" labelPosition="left">
<text id="EMail" size="27" />
<text id="Telephone" label="Telephone" size="16" />
</hgroup>
<text id="ConsentGroup" label="Consent Group" size="60" />
<hgroup label="External HIE" labelPosition="left">
<checkbox id="ExternalHIE"/>
<text id="OID" label="OID" size="47" />
</hgroup>
<select id="Gateway" label="Edge Gateway"/>
<checkbox id="AssignAuth" label="Create Assigning Authority"/>
<!--<dataCombo id="Gateway" maxRows="10000" label="Edge Gateway" sql="SELECT ID, Name FROM HS_Gateway.Config WHERE Type = 'Edge'" 
multiColumn="false" valueColumn="1" choiceColumn="1"  
 dropdownWidth="400"
/> -->
<vgroup label="IP Address" >
<hgroup labelPosition="left" cellVAlign="top" cellStyle="padding-right:2px;">
<text id="IPAddress" size="16" />
<button caption="Add" onclick="zenPage.addIP();"/>
<listBox id="lstIP" listWidth="150px" listHeight="100px" ondblclick="zenPage.editIP();" />
<button id="btnDeleteIP" caption="Delete" onclick="zenPage.deleteIP();"/>
</hgroup>
</vgroup>
<hgroup cellAlign="right" width="100%" showLabel="false" cellStyle="padding-right:4px;" enclosingStyle="background:#CCCCCC;border-top:1px gray solid;">
<button caption="New" title="Create a new item" onclick="zenPage.newItem();"/>
<button caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/>
<button caption="Cancel" title="Cancel the current edit operation" onclick="zenPage.cancelItem();"/>
<button id="btnDeleteItem" caption="Delete" title="Delete the current item" onclick="zenPage.deleteItem();" disabled="true"/>
</hgroup>
</tab>
<tab id="tabRoles" caption="Roles" labelPosition="left" cellStyle="padding:4px;" >
<!-- we're hiding this whole tab (and the tab bar) until facility based roles become supported-->
<multiSelectSet hidden="true" id="RoleList" name="RoleList" label="Allow Additional Roles and Groups" captionClass="multiStyle" title="Select the additional roles and groups that are allowed to be assigned for users at this facility" enclosingStyle="border:2px inset gray; height:180px; overflow:auto;" />
<!--hgroup>
<button caption="Select All" onclick="zenPage.getComponentById('RoleList').selectAll();" />
<button caption="Select None" onclick="zenPage.getComponentById('RoleList').selectNone();"/>
</hgroup>
<button caption="Save" title="Save the current item" onclick="zenPage.saveItem();"/-->
</tab>
</tabGroup>
<hgroup labelPosition="left" cellStyle="padding-right:10px;">
<label label="* indicates required field" labelStyle="font-size:10px;" align="left"/>
<label id="LastUpdate" label="Last update:" labelStyle="font-size:10px;" controlClass="zenLabel" value=""/>
</hgroup>
<spacer height="2"/>
</pane>
}

/// User clicked Add to add a new IP address
ClientMethod addIP() [ Language = javascript ]
{
	zenPage.getComponentById('btnDeleteItem').setDisabled(true);
	var IPAddress = zenPage.getComponentById("IPAddress");
	var ip = IPAddress.getValue();
	if (ip == "") {
		alert(this.msgaddIP);
		IPAddress.focus();
		return;	
	}
	zenPage.getComponentById("lstIP").appendOption(ip,ip);
	IPAddress.setValue("");
	IPAddress.focus();
}

/// Cancel current Facility edit.
ClientMethod cancelItem() [ Language = javascript ]
{
	if (confirm(this.msgcancelItem) == true) {
		this.newItem();
	}
}

/// Delete an IP Address
ClientMethod deleteIP() [ Language = javascript ]
{
	var lst = zenPage.getComponentById("lstIP");
	if (lst.getOptionCount() > 0) {
		var idx = lst.selectedIndex;
		lst.removeOption(idx);
		zenPage.getComponentById("IPAddress").setValue("");
	}
}

/// Delete selected Facility from database
ClientMethod deleteItem() [ Language = javascript ]
{
	var id = this.PID;
	if ('' == id) {
		alert(this.msgnothingDelete);
	}
	else if (confirm(this.msgdeleteFac)) {
		var ok = this.DeleteData(id);
		if (ok == 1) {
			this.newItem();
			var table = zenPage.getComponentById('pickList');
			table.executeQuery();
		} else {
			alert(ok);	
		}
	}
}

/// User double clicked on an IP address in the list. Show it in the add box for edit.
/// If user is correcting, he can edit it and save then delete the old one.
/// It is also convenient if they are adding multiple ones that have most parts similar.
ClientMethod editIP() [ Language = javascript ]
{
	var editip = zenPage.getComponentById("lstIP").getValue();
	var IPAddress = zenPage.getComponentById("IPAddress");
	var ip = IPAddress.setValue(editip);
	IPAddress.focus();
}

/// Create a new facility. Clear field and unselect table row.
ClientMethod newItem() [ Language = javascript ]
{
	this.PID = "";
	zenPage.getComponentById('FacilityCode').setValue("");
	zenPage.getComponentById('Name').setValue("");
	zenPage.getComponentById('Description').setValue("");
	zenPage.getComponentById('FirstName').setValue("");
	zenPage.getComponentById('LastName').setValue("");
	zenPage.getComponentById('Organization').setValue("");
	zenPage.getComponentById('Tier').setValue("");
	zenPage.getComponentById('Home').setValue("");
	zenPage.getComponentById('EMail').setValue("");
	zenPage.getComponentById('Telephone').setValue("");
	zenPage.getComponentById('ConsentGroup').setValue("");
	zenPage.getComponentById('ExternalHIE').setValue("");
	zenPage.getComponentById('OID').setValue("");
	zenPage.getComponentById('FacilityId').setValue("");
	zenPage.getComponentById('Gateway').setValue("");
	zenPage.getComponentById('IPAddress').setValue("");
	zenPage.getComponentById('lstIP').resetOptions();
 	zenPage.getComponentById('pickList').setProperty("selectedIndex",-1);
	zenPage.getComponentById('btnDeleteItem').setDisabled(true);
	zen("AssignAuth").setValue(1);
	zen("AssignAuth").setHidden(false);
}

/// User clicked on a facility row.
ClientMethod rowSelected(table, which) [ Language = javascript ]
{
	if ('keypress' == which) {
		// defer this action in case the user is arrowing through a number of items
		var id = table.getValue();
		var action = new Function("zenPage.showObject('"+id+"');"); 
		zenSetDeferredAction(action,200);
	}
	else {
		// select immediately
		var id = table.getValue();
		zenPage.showObject(id);
	}
}

/// Load the facility object with the given id into the form.
ClientMethod showObject(id) [ Language = javascript ]
{
	// update the property for later use
	this.PID = id;
	zenPage.getComponentById('btnDeleteItem').setDisabled(false);
	zenPage.getComponentById('lstIP').resetOptions();
	// return to tab 1 when user changed row
	zenPage.getComponentById("tabs").setProperty("currTab",1);
	this.UpdateDetails(id);
}

/// User clicked "Save" for facility. Check Facility code.
/// If user modified facility code while editing, confirm with user if they are sure doing that.
ClientMethod saveItem() [ Language = javascript ]
{
	var Fac = zenPage.getComponentById('FacilityCode');
	var FacilityCode = Fac.getValue();
	if (this.CheckAllBlanks(FacilityCode) == 1) {
		alert(this.msgenterFac);
		Fac.focus();
		return;
	}
	
	// YSD2198 check if facility exists if user changed it while editing, or entering a new one
	if (((this.PID != "") && (this.PID != FacilityCode)) || (this.PID == "")) {
		if (this.FacilityExists(FacilityCode) == 1) {
			var ok = confirm(this.msgconfirmFac);
			if (ok == false) return;
		}
		//ALG90 ensure that facilities that differ only in case are confirmed by the user.
		//Note the additional argument in the call to FacilityExists
		else if (this.FacilityExists(FacilityCode,1) == 1) {
			var ok = confirm(this.msgconfirmFacIgnoreCase);
			if (ok == false) return;
		}
	}
	
	// Validate formatting.  Calls CheckFormatting method in HS.UI.BaseUtil
	if (this.CheckFormatting(FacilityCode) == 1) {
		alert(this.msgInvalidFac);
		Fac.focus();
		return;
	}
	
	var Name = zenPage.getComponentById('Name').getValue();
	var Description = zenPage.getComponentById('Description').getValue();
	var FirstName = zenPage.getComponentById('FirstName').getValue();
	var LastName = zenPage.getComponentById('LastName').getValue();
	var Organization = zenPage.getComponentById('Organization').getValue();
	var EMail = zenPage.getComponentById('EMail').getValue();
	var Telephone = zenPage.getComponentById('Telephone').getValue();
	var ConsentGroup = zenPage.getComponentById('ConsentGroup').getValue();
	var ExternalHIE = zenPage.getComponentById('ExternalHIE').getValue();
	var OID = zenPage.getComponentById('OID').getValue();
	var FacilityId = zenPage.getComponentById('FacilityId').getValue();
	var Gateway = zenPage.getComponentById('Gateway').getValue();
	var Tier = zen('Tier').getValue();
	var Home = zen('Home').getValue()?1:0;
	var AssignAuth = zen('AssignAuth').getValue()?1:0;
	var lstIP = zenPage.getComponentById('lstIP');
	var total = lstIP.getOptionCount();
	var IPs = "";
	for (var r = 0; r < total; r++) {
		if (IPs != "") IPs = IPs + ",";
		IPs = IPs + lstIP.getOptionValue(r);
	}	
	var Roles=zenPage.getComponentById('RoleList').getValue()
	var ok = this.SaveData(Name,FacilityCode,Description,FirstName,LastName,Organization,EMail,Telephone,ConsentGroup,ExternalHIE,OID,FacilityId,Gateway,Tier,Home,AssignAuth,IPs,Roles);
	if (ok == 1) {
		// refresh the table
		this.PID = FacilityCode;
		//zenPage.getComponentById("tab2").setProperty("disabled",false);
		var table = zenPage.getComponentById('pickList');
		table.executeQuery();
	} else {
		alert(ok);
	}
}

Method %OnAfterCreatePage() As %Status
{
	#; Hide the template's button group
	Set ..%GetComponentById("btnGroup").hidden = 1
	Set sql = "SELECT ID, Name FROM HS_Gateway.Config WHERE Type = 'E'"
	Set tRS = ##class(%ResultSet).%New()
	Set tSC = tRS.Prepare(sql)
	Do tRS.Execute()
	Set (vList,dList) = ""
	While tRS.Next() {
		Set vList = vList_$S(vList="":"",1:",")_tRS.Data("ID")
		Set dList = dList_$S(dList="":"",1:",")_tRS.Data("Name")
	}
	Set Gateway = ..%GetComponentById("Gateway")
	Set Gateway.valueList = vList
	Set Gateway.displayList = dList
	//Load list of roles & Groups
	Set tRoles="" Set:(","_$roles_",")[",%All," tRoles="%All,"
	Set tRS = ##class(%ResultSet).%New("%ZHSLIB.UsersAndRoles:QueryAvailableRoles")
	Do tRS.Execute()
	While tRS.Next() { Set tRoles=tRoles_tRS.GetData(1)_"," }
	Do tRS.Close()
	Set tRS = ##class(%ResultSet).%New("%ZHSLIB.UsersAndRoles:QueryAvailableGroups")
	Do tRS.Execute()
	While tRS.Next() { Set tRoles=tRoles_tRS.GetData(1)_"," }
	Do tRS.Close()
	Set ..%GetComponentById("RoleList").valueList=$E(tRoles,1,*-1)
	Set ..%GetComponentById("AssignAuth").value=1

	Quit 1
}

/// Return 1 if the string is all blank.
ClassMethod CheckAllBlanks(string) As %Boolean [ ZenMethod ]
{
	Quit $ZStrip(string,"<>W")=""
}

/// Delete existing facility.
ClassMethod DeleteData(PID) As %String [ ZenMethod ]
{
	Set tSC = ##class(HS.Facility.Config).%DeleteId(PID)
	If $$$ISERR(tSC) {
		Set ok = ##class(HS.Util.Status.Interpreter).GetErrorText(tSC,0)
	} Else {
		Set ok = 1
	}
	Quit ok
}

/// Return 1 if facility code exists
ClassMethod FacilityExists(FacilityCode, IgnoreCase = 0) As %String [ ZenMethod ]
{
	If ('IgnoreCase) {
		Quit ##class(HS.Facility.Config).%ExistsId(FacilityCode)
	}
	Set tExists = 0
	Set tSQL = "SELECT c.%ID FROM HS_Facility.Config c WHERE LOWER(%ID) = ?"
	Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,$ZCONVERT(FacilityCode,"L"))
	If tRS.%Next(.tStatus) {
		If $$$ISERR(tStatus) {
			Quit "2" _ $System.Status.GetErrorText(tStatus)
		}
		Set tExists = 1
	}
	Quit tExists
}

/// Save facility data to server.
/// During "Edit", if user changed Facility code, and if that code does not exists, then a new record for the new Facility code will be created.
ClassMethod SaveData(Name, FacilityCode, Description, FirstName, LastName, Organization, EMail, Telephone, ConsentGroup, ExternalHIE, OID, FacilityId, Gateway, Tier, Home, AssignAuth, IPs, Roles) As %String [ ZenMethod ]
{
	Set $ZT = "Trap"
	Set tResult = ""
	Do {
		#dim tObj As HS.Facility.Config	
		If FacilityCode '= "",..FacilityExists(FacilityCode) Set tObj = ##class(HS.Facility.Config).%OpenId(FacilityCode)
		Else  Set tObj = ##class(HS.Facility.Config).%New()
		Set tObj.Name = Name
		Set tObj.FacilityCode = FacilityCode
		Set tObj.Description = Description
		Set tObj.Contact.FirstName = FirstName
		Set tObj.Contact.LastName = LastName
		Set tObj.Contact.Organization = Organization
		Set tObj.Contact.EMail = EMail
		Set tObj.Contact.Telephone = Telephone
		Set tObj.ConsentGroup = ConsentGroup
		Set tObj.Tier= Tier
		Set tObj.HomeFacility = Home
		Set tObj.AssigningAuthority = AssignAuth
		Set tObj.ExternalHIE = $S(ExternalHIE="true":1,1:0)
		If (Description = "") {
			Kill Description // Leave this undefined when passing to HS.Data.OIDMap:CreateOrUpdateOID.
		}
		Set tSC=##class(HS.Data.OIDMap).CreateOrUpdateOID(FacilityCode,"Facility",OID,.Description,$S(AssignAuth:"AssigningAuthority",1:""))
		If $$$ISERR(tSC) {
			Set tResult = $System.Status.GetErrorText(tSC) Quit
		}
		//Set tObj.OID = OID
		Set tObj.FacilityId = FacilityId
		Set tSC=tObj.GatewaySetObjectId(Gateway)
		Do tObj.Roles.Clear()
		For tI=1:1:$L(Roles,",") {
			Set tRole=$P(Roles,",",tI)
			Do:tRole'="" tObj.Roles.Insert(tRole)
		}

		Do tObj.IPAddresses.Clear()
		/// Build into an array to get rid of duplicates
		For c = 1:1:$L(IPs,",") Set tIP = $P(IPs,",",c) If tIP '= "" Set tIPs(tIP)=""
		Set tIP = ""
		For  Set tIP = $O(tIPs(tIP)) Quit:tIP=""  Do tObj.IPAddresses.Insert(tIP)
		Set tSC = tObj.%Save()
		If $$$ISERR(tSC) {
			Set tResult = $System.Status.GetErrorText(tSC)
		} Else {
			Set tResult = 1
			Set LastUpdate = tObj.LastUpdate
			Set PID = tObj.%id
			&js<zenPage.getComponentById("LastUpdate").setValue('#(LastUpdate)#');>
		}
	} While 0
	Quit tResult
Trap	///
	Set $ZT=""
	Quit $ZE
}

/// Load data into General tab for facility.
ClassMethod UpdateDetails(PID) [ ZenMethod ]
{
	#dim tObj As HS.Facility.Config	
	// try to open the object
	If PID '= "",##class(HS.Facility.Config).%ExistsId(PID) {
		Set tObj = ##class(HS.Facility.Config).%OpenId(PID)
		Set IPCount = tObj.IPAddresses.Count()
		For c = 1:1:IPCount {
			Set tIP = tObj.IPAddresses.GetAt(c)
			&js<zenPage.getComponentById('lstIP').appendOption("#($ZCVT(tIP,"O","JS"))#","#($ZCVT(tIP,"O","JS"))#");>	
		}	
	} Else {
		Set tObj = ##class(HS.Facility.Config).%New()
	}
	&js<zenPage.getComponentById('Name').setValue('#($ZCVT(tObj.Name,"O","JS"))#');>
	&js<zenPage.getComponentById('FacilityCode').setValue('#($ZCVT(tObj.FacilityCode,"O","JS"))#');>
	&js<zenPage.getComponentById('Description').setValue('#($ZCVT(tObj.Description,"O","JS"))#');>
	&js<zenPage.getComponentById('FirstName').setValue('#($ZCVT(tObj.Contact.FirstName,"O","JS"))#');>
	&js<zenPage.getComponentById('LastName').setValue('#($ZCVT(tObj.Contact.LastName,"O","JS"))#');>
	&js<zenPage.getComponentById('Organization').setValue('#($ZCVT(tObj.Contact.Organization,"O","JS"))#');>
	&js<zenPage.getComponentById('EMail').setValue('#($ZCVT(tObj.Contact.EMail,"O","JS"))#');>
	&js<zenPage.getComponentById('Telephone').setValue('#($ZCVT(tObj.Contact.Telephone,"O","JS"))#');>
	&js<zenPage.getComponentById('ConsentGroup').setValue('#($ZCVT(tObj.ConsentGroup,"O","JS"))#');>
	&js<zenPage.getComponentById('ExternalHIE').setValue('#($ZCVT(tObj.ExternalHIE,"O","JS"))#');>
	&js<zenPage.getComponentById('OID').setValue('#($ZCVT(##class(HS.Data.OIDMap).OIDForType(tObj.FacilityCode,"Facility",""),"O","JS"))#');>
	&js<zenPage.getComponentById('FacilityId').setValue('#($ZCVT(tObj.FacilityId,"O","JS"))#');>
	&js<zenPage.getComponentById('Gateway').setValue('#($ZCVT(tObj.GatewayGetObjectId(),"O","JS"))#');>
	&js<zenPage.getComponentById("LastUpdate").setValue('#($ZCVT(tObj.LastUpdate,"O","JS"))#');>
	&js<zenPage.getComponentById("Tier").setValue('#(tObj.Tier)#');>
	&js<zenPage.getComponentById("Home").setValue('#(tObj.HomeFacility)#');>
	&js<zenPage.getComponentById("IPAddress").setValue("");>
	If tObj.%Id()]"" {
		&js<zen("AssignAuth").setValue('#(tObj.AssigningAuthority)#');>
		&js<zen("AssignAuth").setHidden(true);>
	}

	Set tRoles=""
	For tI=1:1:tObj.Roles.Count() { set tRoles=tRoles_tObj.Roles.GetAt(tI)_"," }
	Set tRoles=$E(tRoles,1,*-1)
	&js<zenPage.getComponentById('RoleList').setValue('#($ZCVT(tRoles,"O","JS"))#');>

	Quit
}

}
