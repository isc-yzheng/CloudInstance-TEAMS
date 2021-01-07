Include HS.HC

/// Dropdown and text box for selection of patient.
/// Dropdown is initially populated from %session.Data("IHE.Test","PatientID").
/// 
Class HS.Test.UI.Component.patientSelect Extends (%ZEN.Component.composite, HS.Test.UI.Component.hsComponent) [ Inheritance = right ]
{

Property onselect As %ZEN.Datatype.eventHandler;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

// #(%page.PatientMRN)#^^^&amp;#(%page.PatientAA)#&amp;ISO

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite xmlns="http://www.intersystems.com/zen" >
<combobox id="cmbPatientID2" label=" Select Patient:" size="90" valueList="" displayList="" value="" onchange="zenThis.composite.selectPatient();" />
<text label="Full Patient ID:" name="patientID" id="txtPatientID2" size="80" value="" onchange="zenThis.composite.updatePatientID();"/>
</composite>
}

ClientMethod selectPatient() [ Language = javascript ]
{
	patientID = zenThis.composite.getChildById("cmbPatientID2").getValue();
	
	zenThis.composite.getChildById("txtPatientID2").setValue(patientID);
	if (zenThis.onselect) zenInvokeCallbackMethod(this.onselect, this, 'onselect');
}

ClientMethod updatePatientID() [ Language = javascript, Private ]
{
	var value = zenThis.value;
	var newvalue = zenThis.composite.NormalizePatientID(value);
	zenThis.setProperty("value",newvalue);
}

/// This should be private, except zenmethods can't be private.
ClassMethod NormalizePatientID(pPatientID) As %String [ ZenMethod ]
{
	Set pPatientID=$zstrip(pPatientID,"<>W")
	If '$f(pPatientID,"^") Set pPatientID=pPatientID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	Quit pPatientID
}

Method PatientID() As %String
{
	return ..%GetChildById("txtPatientID2").value
}

/// This callback is called after the children of this composite
/// component have been created.
Method %OnAfterCreateComposite() As %Status
{
	Do ..PopulateCombobox()
	Quit $$$OK
}

Method PopulateCombobox() [ Private ]
{
	Merge tSVRecentPatients = %session.Data("IHE.Test","RecentPatients")
	Set tValueList = "", tDisplayList = ""
	For tIdx=1:1:+$g(tSVRecentPatients) {
		Set tItem = tSVRecentPatients(tIdx)
		Set tPatientId=$li(tItem)
		If $D(tSeen(tPatientId)) Continue
		Set tRecentPatients($i(tRecentPatients))=tItem
		Set tSeen(tPatientId)="",tValueList=tValueList_","_tPatientId
		Set tDisplayList=tDisplayList_","_##class(HS.UI.Util).%EscapeComma($li(tItem,2))
	}
	Set component = ..%GetChildById("cmbPatientID2")
	 Write "tDisplayList"_tDisplayList
	 set component.displayList=$e(tDisplayList,2,*)
	 set component.valueList=$e(tValueList,2,*)
}

}
