Include (%ZHSLIB, HS.Upgrade, HS.HC.UI.Home, HS.HC)

/// Common methods for HS UI.
Class HS.HC.UI.Util Extends HS.UI.Base [ Abstract ]
{

/// Override to choose which fields to exclude (e.g. "txtSpecialty,txtSubSpecialty")
Parameter EXCLUDEFIELDS;

/// Comma-delimited list of tables which can be loaded with LoadComboBox.  This should be set in each subclass which calls LoadComboBox.
Parameter ALLOWEDTABLES;

/// Comma-delimited list of fields that can be retrieved with LoadComboBox.  If any fields other than Name and ID are needed, this should be set in each subclass which calls LoadComboBox.
Parameter ALLOWEDFIELDS = "Name,ID";

Property excludeFields As %ZEN.Datatype.string [ InitialExpression = {..#EXCLUDEFIELDS} ];

/// Utility Method used by UIs that can run on a gateway, to check if the gateway version is recent
/// enough to be compatible with an upgraded registry.
/// Use the same key (without the "\UI\") as HSUILink
ClassMethod CheckUIVersion(pKey) As %Status
{
	Set pKey="\UIVersion\"_pKey
	Set tVersion=##class(HS.Registry.Config).GetKeyValue(pKey,"")
	If $$$HSCoreVersion<tVersion Quit $$$ERROR($$$GeneralError,$$$Text("Gateway version is too old"))
	Quit $$$OK
}

/// Utility Method used by $$$ConfigValue
/// Gets a value from the session if there, otherwise from the Configuration Registry
ClassMethod ConfigValue(pKey As %String, pDefault As %String = "") As %String
{
	//Allow this to be used if there is no CSP session
	If '$D(%session) Set %session=##class(HS.Util.SessionCache).%New()
	If '$D(%session.Data("ConfigValue",pKey),tValue) {
		Set tValue=##class(HS.Registry.Config).GetKeyValue(pKey,pDefault)
		Set %session.Data("ConfigValue",pKey)=tValue
	}
	Quit tValue
}

ClassMethod GetLoginLink(pFrom As %String = "") As %String
{
	IF pFrom="" {
		If $D(%session.Data("HomePage")) {Set pFrom=%session.Data("HomePage")}
	}
	Set tQuery("FROM")=pFrom
	Quit $$$HSUILinkQuery("Logout","HS.UI.Logout.cls",tQuery)
}

/// *******************************************************************///
///                  Generic Methods
/// *******************************************************************///
/// Moving a list item from one box to the next, then remove it from the original box
ClientMethod arrowClick(from, to, sort) [ Language = javascript ]
{
	var fromCtl = zenPage.getComponentById(from);
	var currIndex = fromCtl.selectedIndex;
	if ( (currIndex < 0) || (currIndex >= fromCtl.getOptionCount()) ) return;	
	var optionValue = fromCtl.getOptionValue(currIndex);
	var optionText = fromCtl.getOptionText(currIndex);
	var toCtl = zenPage.getComponentById(to);
	toCtl.appendOption(optionValue,optionText);
	
	fromCtl.removeOption(currIndex);
	if (sort) zenPage.sortList(to);
	return optionValue;
}

/// enable or disable the Save button - note that the Save buttn's id is "btnSave".
ClientMethod disableSave(flag) [ Language = javascript ]
{
	zenPage.getComponentById('btnSave').setProperty("disabled",flag);
}

ClientMethod setListBoxItems(listBoxId, items, render) [ Language = javascript ]
{
	var listBoxCtl = zenPage.getComponentById(listBoxId);
	
	if ((!listBoxCtl) || (!items) || (!items.length)) {
		return;
	}
	for (var i = 0; i < items.length; i++) {
		var item = items[i];
		if (item) {
			var option = zenPage.createComponent('option');
			option.value = item.value;
			option.text = (typeof item.text != 'undefined') ? item.text : item.value;
			listBoxCtl.options.push(option);
		}
	}
	if (render) {
		listBoxCtl.renderListBox();
	}
}

/// Given a group name, return implied group names if appliable
ClassMethod GetImplied(selection) As %String [ ZenMethod ]
{
	Set $zt="Error"
	Set text="" 
	For idx = 1:1:$L(selection,".")-1 Set text = text_","_..%EscapeComma($p(selection,".",1,idx))
	Set text = $E(text,2,*)
	If text'="",text'= selection Set text = $$$FormatText($$$Text("%1 implies %2."),selection,text)
	Quit text
Error Set $ZT=""
	Do BACK^%ETN
	Quit $ZE
}

/// Check for an error from a web service call to load an object
ClassMethod %CheckError(pSC As %Status, pObj As HS.Util.WebServices.ServiceStatus, pShowInternalDetails As %Boolean = 1, Output pWarning As %String) As %String
{
	Set pWarning = ""
	If '$$$ISOK(pSC) {
		If pShowInternalDetails {
			Set ok=$System.Status.GetErrorText(pSC)
		} Else {
			Set ok=##class(HS.Util.Status.Interpreter).GetErrorText(pSC)
		}
	} ElseIf '$IsObject(pObj) {
		Set ok="Cannot open object!"
	} ElseIf '$$$ISOK(pObj.Status) {
		If pShowInternalDetails {
			Set ok=$System.Status.GetErrorText(pObj.Status)
		} Else {
			Set ok=##class(HS.Util.Status.Interpreter).GetErrorText(pObj.Status)
		}
	}  Else {
		If $Length(pSC) > 1 {
			// In this case we have an OK/Warning status
			Set pWarning=##class(HS.Util.Status.Interpreter).GetErrorText(pSC)
		} ElseIf $Length(pObj.Status) > 1 {
			// In this case we have an OK/Warning status
			Set pWarning=##class(HS.Util.Status.Interpreter).GetErrorText(pObj.Status)
		}	
		Quit 1
	}

	Quit ..%FormatError(ok)
}

/// Make error message presentable
ClassMethod %FormatError(pMsg As %String) As %String
{
	Quit $S($F(pMsg,":"):$P($P(pMsg,":",2,99),"[",1),1:pMsg)
}

/// Sort the entries in a listbox or combobox
ClientMethod sortList(ctlName) [ Language = javascript ]
{
	var lst = zen(ctlName); 
	if (lst.selectedIndex > 0) {
		var oldValue = lst.getOptionValue(lst.selectedIndex);
	} else {
		var oldValue=''
	}
	arr = new Array();
	
	var len = lst.getOptionCount();
	for(i=0; i<len; i++) { 
		arr[i] = {text:lst.getOptionText(i), value: lst.getOptionValue(i)}; 
	} 
	arr.sort(function(a,b){
		if (a.text < b.text) {return -1;}
		else if (a.text > b.text) {return 1;}
		else {if (a.value<b.value) { return -1; } else if (a.value>b.value) { return 1;} else { return 0;}}
		});
	
	lst.resetOptions();

	zenPage.setListBoxItems(ctlName,arr,true);
}

/// Display a checkmark (actually an X) for a Boolean field
Method displayCheck(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	Set tValue=%query(pName)
	If tValue {
		&html<X>
	} Else {
		&html<&nbsp;>
	}

	Quit $$$OK
}

/// Set a list into a UI control
ClassMethod %SetListIntoUI(pControl As %String, pList As HS.Util.WebServices.ListItems)
{
	&js<zenPage.getComponentById('#(pControl)#').resetOptions();>

	For tIdx=1:1:pList.Items.Count() {
		Set tItem=pList.Items.GetAt(tIdx)
		Set tID=$ZCVT(tItem.ID,"O","JS")
		Set tName=$ZCVT(tItem.Name,"O","JS")
		&js<zenPage.getComponentById('#(pControl)#').appendOption('#(tID)#','#(tName)#');>
	}
}

/// Set available and selected lists into the UI
ClassMethod %SetItemsIntoUI(pSelected As %ListOfDataTypes, pCodes As %ArrayOfDataTypes, pNames As %ArrayOfDataTypes, pAvail As %String = "lst", pSelect As %String = "lstSelect")
{
	&js<zenPage.getComponentById('#(pAvail)#').resetOptions();>
	&js<zenPage.getComponentById('#(pSelect)#').resetOptions();>

	Set tSelectedItems = ##class(%Library.DynamicArray).%New()
	For tIdx=1:1:pSelected.Items.Count() {
		Set tItem=pSelected.Items.GetAt(tIdx)
		Set tDynamicItem = ##class(%Library.DynamicObject).%New()
		Set tDynamicItem.text = pCodes.GetAt(tItem.ID)
		Set tDynamicItem.value = tItem.ID
		Do tSelectedItems.%Push(tDynamicItem)
		Set tArray(tItem.ID)=""
	}
	Write "var selectedItems = ",tSelectedItems.%ToJSON(),";",!

	Set tAvailableItems = ##class(%Library.DynamicArray).%New()
	Set tName="" 
	For { 
		Set tCode = pNames.GetNext(.tName) 
		Quit:tCode=""
		If '$data(tArray(tCode)) {
			Set tDynamicItem = ##class(%Library.DynamicObject).%New()
			Set tDynamicItem.text = tName
			Set tDynamicItem.value = tCode
			Do tAvailableItems.%Push(tDynamicItem)
		}
	}
	Write "var availableItems = ",tAvailableItems.%ToJSON(),";",!
	
	// push data into listBox and render
	&js<
	zenPage.setListBoxItems('#($zconvert(pSelect,"O","JS"))#',selectedItems,true);
	zenPage.setListBoxItems('#($zconvert(pAvail,"O","JS"))#',availableItems,true);
	>
	Kill tArray
}

/// Load dropdown choices via web service calls
Method LoadComboBox(pTable As %String, pControl As %String, pWhere As %String = "", pName As %String = "Name", pID As %String = "ID") [ ZenMethod ]
{
	Quit:((","_..#ALLOWEDTABLES_",")'[(","_pTable_","))
	Quit:((","_..#ALLOWEDFIELDS_",")'[(","_pName_","))
	Quit:((","_..#ALLOWEDFIELDS_",")'[(","_pID_","))
	Set tCmb=..%GetComponentById(pControl)
	Quit:'$IsObject(tCmb)
	Set vList="",dList=""
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","ListObjects",.tObj,pTable,pName,pWhere,pID)
	If $D(tObj),$IsObject(tObj),$$$ISOK(tObj.Status) {
		For tIdx=1:1:tObj.Items.Count() {
			Set tItem=tObj.Items.GetAt(tIdx)
			Set vList = vList_","_..%EscapeComma(tItem.ID)
			Set dList = dList_","_..%EscapeComma(tItem.Name)
		}
		Set tCmb.valueList = vList
		Set tCmb.displayList = dList
	}
}

/// Add an option to a combobox
Method AddOption(pCombobox As %ZEN.Component.combobox, pValue As %String, pText As %String, pOptionStyle As %String = "") [ ZenMethod ]
{
	Set tOption = ##class(%ZEN.Auxiliary.option).%New()
	Set tOption.text = pText
	Set tOption.value = pValue
	Set tOption.style= pOptionStyle
	Do pCombobox.options.Insert(tOption)
	Do ..%AddComponent(tOption)
}

/// Insert an option in the sort order of a combobox, avoiding duplicates
Method InsertOption(pCombobox As %ZEN.Component.combobox, pValue As %String, pText As %String, pOptionStyle As %String = "") [ ZenMethod ]
{
	// Don't add a duplicate
	Set tDup=0
	For tI=1:1:pCombobox.options.Count() {
		Set tOption=pCombobox.options.GetAt(tI)
		If tOption.value=pValue { Set tDup=1 Quit }
	}
	Quit:tDup
		
	// Insert in sort order, ignoring any leading punctuation character
	Set tCount=pCombobox.options.Count(),tPos=tCount+1
	For tI=1:1:tCount {
		Set tOption=pCombobox.options.GetAt(tI)
		If tOption.text]pText,tOption.text'?1P.E {
			Set tPos=tI Quit 
		}
	}
	Set tOption = ##class(%ZEN.Auxiliary.option).%New()
	Set tOption.text = pText
	Set tOption.value = pValue
	Set tOption.style= pOptionStyle
	Do pCombobox.options.InsertAt(tOption,tPos)
	Do ..%AddComponent(tOption)
}

/// User clicked Find a User.
ClientMethod popupUser(searchMode, filter, systems, mpiid, groups, inactive) [ Language = javascript ]
{
	if (filter==undefined)   { filter = '0'; }
	if (systems==undefined)  { systems = '0'; }
	if (mpiid==undefined)    { mpiid = ''; }
	if (groups==undefined)   { groups = '0'; }
	if (inactive==undefined) { inactive = '0'; }
	zenPage.launchPopupWindow(zenLink("HS.UI.Registry.User.Find.cls?CPSHARE=1&SEARCHMODE="+searchMode+"&FILTER="+filter+"&SYSTEMS="+systems+"&MPIID="+mpiid+"&GROUPS="+groups+"&INACTIVE="+inactive),'FindUser','status,scrollbars=yes,resizable=yes,modal=yes,width=1260,height=650');
}

/// Validate input time, returning time in military time
ClientMethod validateTime(time) [ Language = javascript ]
{
	// Normalize input
	var timeArr=time.split(":");
	if (timeArr[0].length == 1) {
		time = "0"+time
	}
	
	// Convert to military time
	var ampm=time.substring(time.length-2,time.length).toLowerCase();
	if (ampm == "am") {
		time=time.substring(0,time.length-2);
	}
	if (ampm == "pm") {
		var hour=parseInt(timeArr[0])+12
		time=hour.toString()+time.substring(2,time.length-2);
	}
	if (time.substring(time.length-1,time.length) == " ") {
		time=time.substring(0,time.length-1);
	}
	
	// Validate time
	if (time.length != 5) return 0;
	if (time.substring(2,3) != ":") return 0;
	var hour=time.substring(0,2);
	var minute=time.substring(3,5);
	if (/\D/g.test(hour)) return 0; //not a number
	if (/\D/g.test(minute)) return 0;
	if (hour < 0 || hour > 23) return 0;
	if (minute < 0 || minute > 59) return 0;
	
	return time;
}

/// Hide search criteria fields
Method %HideFields(pGroup As %ZEN.Component.abstractGroup, pHideAll As %Boolean = 0)
{
	For tI=1:1:pGroup.children.Count() {
		Set tControl=pGroup.children.GetAt(tI)
		If ($E($classname(tControl),*-4,*)="group")||($E($classname(tControl),*-7,*)="fieldSet") {
			Do ..%HideFields(tControl, pHideAll)
		} Else {
			If pHideAll {
				Set tControl.hidden=1	
			} Else {
				Set:(","_..excludeFields_",")[(","_tControl.id_",") tControl.hidden=1
			}
		}
	}
}

/// Convert double quotes to single quote in a control
ClientMethod convertQuotes(ctrlName) [ Language = javascript ]
{
var	ctrl=zen(ctrlName);
var replace=ctrl.getValue().replace(/"/g,"'")
ctrl.setValue(replace);
}

/// Toggle whether a field is displayed
ClientMethod toggle(ctrlName) [ Language = javascript ]
{
	if (this.excludeFields.indexOf(ctrlName) < 0) 
	{
		var ctrl=zen(ctrlName);
		ctrl.setHidden(!ctrl.getHidden());
	}
}

/// Fill in an exact match based on a partial entry in a combobox with editable="true" and onkeyup="zenPage.comboBoxMatch(zenThis);"
/// Note that you'll also need to reproduce any onchange actions after calling this method in onkeyup.
ClientMethod comboBoxMatch(comboBox) [ Language = javascript ]
{
	if ((comboBox.disabled)||(comboBox.readOnly)) return false;
	
	var inputControl = comboBox.findElement('input');
	var inputValue = inputControl.value;
	var inputLen = inputValue.length;
	var value=comboBox.getValue();
	if ((value != "")&&(inputLen > comboBox.findDisplayValue(value).length)) return false
	var matchCnt = 0, matchIdx = 0, matchValue = '', matchDisplay = '';

	if (inputLen > 0) {
		var cnt = comboBox.getOptionCount();
		for (i=0; i<cnt; i++) {
			var optValue=comboBox.getOptionValue(i)
			var displayValue = comboBox.findDisplayValue(optValue);
			if (displayValue.substring(0,inputLen).toUpperCase() == inputValue.toUpperCase()) {
				if ((zenEvent.keyCode != 8)||(displayValue == inputValue)) {
					matchIdx=i
					matchValue=optValue;
					matchDisplay=displayValue;
					if (++matchCnt > 1) break;
				}
			}
		}
	}
	
	if (matchCnt == 1) {
		var comboBoxId=comboBox.getProperty('id');
		// delay is to discourage typing while matching
		setTimeout("zen('"+comboBoxId+"').findElement('input').value='"+matchDisplay+"';",100);
		//inputControl.value=matchDisplay;
		comboBox.value=matchValue;
		comboBox.selectedIndex=matchIdx;
		ret = true;
	} else {
		comboBox.value='';
		comboBox.selectedIndex=-1;
		ret = false;
	}
	
	return ret;
}

/// Filter facilities to those in a users list
ClassMethod %InFacilityList(pFilter As %Boolean) As %String
{
	If pFilter {
		Do ##class(HS.Registry.Person.User).SessionUserClinician()
		Set tFacilities=%session.Data("Facilities")
		Set tFacCnt=$L(tFacilities,","),tFacList=""
		If tFacCnt = 0 {
			Set tFacList=tFacList_"''"
		} Else {
			For tJ=1:1:tFacCnt {
				Set tFacList=tFacList_$S(tJ>1:",",1:"")_"'"_$P(tFacilities,",",tJ)_"'"
			}
		}
		Set tInList="FacilityCode IN "_"("_tFacList_")"
	} Else {
		Set tInList=""
	}

	Quit tInList
}

/// Disable a control and grey out its label (not always the standard behavior)
Method %DisableControl(pControlName As %String, pDisabled As %Boolean = 1, pNormal As %String = "black")
{
	Set tControl=..%GetComponentById(pControlName)
	Set tControl.disabled=pDisabled
	Set tControl.labelStyle="color:"_$S(pDisabled:"gray",1:pNormal)
}

/// Disable a control and grey out its label (not always the standard behavior)
ClientMethod disableControl(controlName, disabled, normal) [ Language = javascript ]
{
	if (disabled == undefined) disabled=1;
	if (normal == undefined) normal="black";
	var control=zen(controlName);
	control.setDisabled(disabled);
	control.setProperty('labelStyle',disabled?"gray":normal);
}

/// Javascript to convert input string into quoted JavaScript literal
ClientMethod jsQuote(inStr) [ Language = javascript ]
{
	return "'"+inStr.split("'").join("\\'")+"'";
}

/// This takes a vanilla XML stream, and adds in a style sheet from the Ensemble library to make this
/// browser friendly (needed for Chrome, useful for others)
ClassMethod OutputXMLToBrowser(pStream)
{
	Do pStream.Rewind()
	Set tLen=99999
	Set tRead=pStream.Read(.tLen), tFind=0
	If $E(tRead,1,5)="<?xml" {Set tFind=$F(tRead,">")} //we had better find this!
	Write $E(tRead,1,tFind-1)
	Write "<?xml-stylesheet href=""ensemble/Ensemble_XMLDisplay.xsl"" type=""text/xsl"" ?>"
	Write $E(tRead,tFind,*)
	For {
		Quit:pStream.AtEnd
		Write pStream.Read(32000)
	}
}

/// Don't show drowdown arrow for a combobox
Method %HideDropdownArrow(pComboName As %String)
{
	Set tCombo=..%GetComponentById(pComboName)
	Set tCombo.comboType="timer",tCombo.delay=1000000
}

/// Return from searching for a clinician or provider
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	var delay=navigator.userAgent.indexOf('Safari')>-1?300:0;
	if (action == "UserId"){ // value is an array
		if (value.length==0){
			setTimeout("alert('Nothing selected')",delay);
		}
		else{
			setTimeout("zenPage.userIdentified('"+value[0]+"',"+zenPage.jsQuote(value[1])+",'"+value[2]+"',"+zenPage.jsQuote(value[3])+",'"+value[4]+"')",delay);
		}
	} else if (action == "MultiUserId") { // value is a Cache $list string
		if (value==""){
			setTimeout("alert('Nothing selected')",delay);
		}
		else{
			setTimeout(zenPage.multiUserIdentified(value),delay);
		}
	}
}

/// A user was successfully identified
ClientMethod userIdentified(id, userName, userID, searchMode, type) [ Language = javascript ]
{
	alert("Implemented in descendent");
}

/// Multiple users were successfully identified
ClientMethod multiUserIdentified(usersInfo) [ Language = javascript ]
{
	alert("Implemented in descendent");
}

/// Escape commas in values to be included in comma-delimited lists
ClassMethod %EscapeComma(pValue As %String) As %String [ CodeMode = expression ]
{
$REPLACE(pValue,",","\,")
}

}
