Include HS.HC

Class HS.Push.MessageCenter.Folder Extends (%Persistent, HS.Util.DataModel.Adaptor, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Domain used for localization.
Parameter DOMAIN = "HS";

Property FolderType As %String(VALUELIST = ",Inbox,Deleted,Drafts,Sent,Custom") [ Required ];

Property FolderName As %String [ Required ];

Property SystemFolder As %Boolean;

Property OrderGroup As %Integer;

Relationship OwnerUser As HS.Registry.Person.User [ Cardinality = one, Inverse = Folders ];

Index OwnerUserIndex On OwnerUser;

ClassMethod CreateCustomFolder(pClinicianId As %String, pName As %String = "", Output pId) As %Status
{
	Set tSC=..SysFolders(pClinicianId) Quit:$$$ISERR(tSC) tSC
	Quit ..AddFolder("Custom",pClinicianId,pName,0,100)
}

ClassMethod RenameCustomFolder(pFolderId, pNewName) As %Status
{
	#dim tFold As HS.Push.MessageCenter.Folder
	Set tFold=..%OpenId(pFolderId)
	IF '$IsObject(tFold) Set tSC=$$$HSError($$$HSErrFolderNotFound,pFolderId) Quit tSC
	IF tFold.SystemFolder Set tSC=$$$HSError($$$HSErrFolderIsSystem,tFold.FolderName) Quit tSC
	Set tFold.FolderName=pNewName
	Quit tFold.%Save()
}

ClassMethod DeleteCustomFolder(pClinicianId, pFolderId) As %Status
{
	Set tSC=..GetSysFolder(pClinicianId,"Deleted",.tDelFoldId) Quit:$$$ISERR(tSC) tSC
	Set tFold=..%OpenId(pFolderId)
	IF '$IsObject(tFold) Set tSC=$$$HSError($$$HSErrFolderNotFound,pFolderId) Quit tSC
	IF tFold.SystemFolder Set tSC=$$$HSError($$$HSErrFolderIsSystem,tFold.FolderName) Quit tSC
	// Move all existing documents to the clinician's deleted folder
	Do $classMethod("HS.Push.MessageCenter.Document","UpdateFolder",pFolderId,tDelFoldId)
	//&SQL(Update Document Set FolderId=:tDelFoldId WHERE FolderId=:pFolderId)
	Quit ..%DeleteId(pFolderId)
}

/// get the ID for a system folder of type pType for a clinician
ClassMethod GetSysFolder(pClinicianId, pType, Output pFolderId) As %Status
{
	Set tSC=..SysFolders(pClinicianId) Quit:$$$ISERR(tSC) tSC
	&SQL(Select %ID INTO :tFoldId FROM Folder WHERE FolderType=:pType AND OwnerUser=:pClinicianId)
	IF SQLCODE=0 Set pFolderId=tFoldId Quit $$$OK
	Set tSC=$$$HSError($$$HSErrFolderNotFound,pType) Quit tSC
}

/// This will check if the system folders exist for a clinician, and if not, create them
ClassMethod SysFolders(pClinicianId) As %Status
{
	&SQL(Select FolderType into :tType FROM Folder WHERE FolderType='Inbox' AND OwnerUser=:pClinicianId)
	Quit:SQLCODE=0 $$$OK
	///slightly tedious literal repetition in order to make $$$Text work at compile time
	Set tSC=..AddFolder("Inbox",pClinicianId,$$$Text("Inbox"),1,1) Quit:$$$ISERR(tSC) tSC
	Set tSC=..AddFolder("Sent",pClinicianId,$$$Text("Sent"),1,2) Quit:$$$ISERR(tSC) tSC
	Set tSC=..AddFolder("Drafts",pClinicianId,$$$Text("Drafts"),1,4) Quit:$$$ISERR(tSC) tSC
	Set tSC=..AddFolder("Deleted",pClinicianId,$$$Text("Deleted"),1,3) Quit:$$$ISERR(tSC) tSC
	Quit $$$OK
}

ClassMethod AddFolder(pType, pClinicianId, pName, pSystem, pOrderGroup) As %Status
{
	Set tFold=##Class(HS.Push.MessageCenter.Folder).%New()
	Set tFold.FolderName=pName
	Set tFold.FolderType=pType
	Do tFold.OwnerUserSetObjectId(pClinicianId)
	Set tFold.SystemFolder=pSystem
	Set tFold.OrderGroup=pOrderGroup
	Quit tFold.%Save()
}

/// Prior to calling this, something should have first called SysFolders to create the system folders for this clinician
/// the GetClinicianFromRequest method on the clinician registry already does this
Query ListFolders(pClinician As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,FolderName,FolderType,SystemFolder, OrderGroup FROM Folder
Where OwnerUser = :pClinician
 ORDER BY OrderGroup, FolderName
}

Query ListSysFolders(pClinician As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,FolderName,FolderType,SystemFolder, OrderGroup FROM Folder
Where OwnerUser = :pClinician AND SystemFolder=1
 ORDER BY OrderGroup, FolderName
}

Query ListFoldersWeb(pClinicianId As %String = "") As %Query(ROWSPEC = "ID:%String,FolderName:%String,FolderType:%String,SystemFolder:%Boolean,OrderGroup:%Integer")
{
}

ClassMethod ListFoldersWebExecute(ByRef qHandle As %Binary, pClinicianId As %String = "") As %Status [ ServerOnly = 1 ]
{
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Push.WebServices","HS.Push.WebServicesClient","ListFolders",.tObj,pClinicianId)
	If '$$$ISOK(tSC) Quit tSC
	If '$$$ISOK(tObj.Status) Quit tObj.Status
	Set qHandle=tObj
	Set qHandle("POS")=0
	Quit $$$OK
}

ClassMethod ListFoldersWebClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListFoldersWebExecute, ServerOnly = 1 ]
{
	Kill qHandle
	Quit $$$OK
}

ClassMethod ListFoldersWebFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListFoldersWebExecute, ServerOnly = 1 ]
{
	Set Row=""
	Set pos=qHandle("POS")+1
	If pos>qHandle.Items.Count() {Set AtEnd=1}
	Else {
		Set tItem=qHandle.Items.GetAt(pos)
		Set Row=$Lb(tItem.ID,tItem.Name,tItem.FolderType,tItem.SystemFolder,tItem.OrderGroup)
	}
	Set qHandle("POS")=pos	
	Quit $$$OK
}

/// Checks permissions (parameter-based) on a particular operation + object. <br />
/// If <var>pHandled</var> is set to true, <method>CheckPermission</method> will be bypassed. <br />
/// <var>pOperation</var> is "C" (create), "R" (read), "U" (update), or "D" (delete) <br />
/// <var>pID</var> is the ID of the object being operated on (empty for new objects) <br />
/// <var>pObject</var> is the object being operated on (for create/read/update; empty for delete) <br />
/// Returns <code>$$$ERROR($$$AccessDenied)</code> if the user does not have the requisite permission.
ClassMethod OnCheckPermission(Output pHandled As %Boolean = 0, pOperation As %String, pID As %Integer, pObject As HS.Push.MessageCenter.Folder) As %Status
{
	Set tSC = $$$OK
	Set pHandled = 1
	Try {
		If $System.Security.Check($$$HSHubManagement,"USE") {
			Quit
		}
		
		Set tUserClinicianID = ##class(HS.Registry.Person.User).SessionUserClinician()
		If $IsObject(pObject) && $IsObject(pObject.OwnerUser) && (pObject.OwnerUser.%Id() '= tUserClinicianID) {
			$$$ThrowStatus($$$ERROR($$$AccessDenied))
		} ElseIf (pID '= "") && (tUserClinicianID '= ..OwnerUserGetStored(pID)) {
			$$$ThrowStatus($$$ERROR($$$AccessDenied))
		}
	} Catch e {
		Set tSC = e.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="FolderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FolderType</Value>
</Value>
<Value name="3">
<Value>FolderName</Value>
</Value>
<Value name="4">
<Value>SystemFolder</Value>
</Value>
<Value name="5">
<Value>OrderGroup</Value>
</Value>
<Value name="6">
<Value>OwnerClinician</Value>
</Value>
<Value name="7">
<Value>OwnerUser</Value>
</Value>
</Data>
<DataLocation>^HS.Push.MessageCenter.FolderD</DataLocation>
<DefaultData>FolderDefaultData</DefaultData>
<IdLocation>^HS.Push.MessageCenter.FolderD</IdLocation>
<IndexLocation>^HS.Push.MessageCenter.FolderI</IndexLocation>
<StreamLocation>^HS.Push.MessageCenter.FolderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
