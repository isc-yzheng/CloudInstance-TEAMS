/// Data entry for Assigning Authorities
Class HS.UI.Hub.AssigningAuthorities Extends HS.HC.UI.AssigningAuthorities
{

/// Load an assigning authority into the UI
ClassMethod UpdateDetails(pId) [ ZenMethod ]
{
	Do ##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","LoadAssigningAuthority",.tObj,pId)
	If '$IsObject(tObj) || '$$$ISOK(tObj.Status) {
		&js<alert("Cannot open object!");>
	} Else {
		&js<zen("txtName").setValue('#($ZCVT(tObj.Name,"O","JS"))#');>
		&js<zen("txtCode").setValue('#($ZCVT(tObj.Code,"O","JS"))#');>
		&js<zen("assignAuthCode").setValue('#($ZCVT(tObj.Code,"O","JS"))#');>
		&js<zen("txtOtherId").setValue('#($ZCVT(tObj.OtherId,"O","JS"))#');>
		&js<zen("chkMultiple").setValue('#(tObj.AllowMultiple)#');>
		&js<zen('assignAuthId').setValue('#(tObj.ID)#');>
		&js<zen('cmbNumberType').setValue('#(tObj.NumberType)#');>
	}
}

/// Save Assigning Authority
ClassMethod SaveData(pIDTypeId, pId, pName, pCode, pOtherId, pMultiple, pNumberType) As %String [ ZenMethod ]
{
	Set $zt="Error"
	
	Set tAssignAuth = ##class(HS.Hub.HSWS.WebServices.Containers.AssigningAuthority).%New()
	Set tAssignAuth.ID = pId
	Set tAssignAuth.Name = pName
	Set tAssignAuth.Code = pCode
	Set tAssignAuth.OtherId = pOtherId
	Set tAssignAuth.IdentifierTypeId = pIDTypeId
	Set tAssignAuth.AllowMultiple = pMultiple
	Set tAssignAuth.NumberType = pNumberType

	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","AddEditAssigningAuthority",.tObj,tAssignAuth)
	Quit ..%CheckError(tSC,tObj)
Error Set $ZT=""
	Do BACK^%ETN
	Quit $ZE
}

}
