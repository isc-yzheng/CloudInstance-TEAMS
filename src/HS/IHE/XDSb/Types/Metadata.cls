/// XDSb metadata abstraction
Class HS.IHE.XDSb.Types.Metadata Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Submissions As list Of HS.IHE.XDSb.Types.Submission(XMLNAME = "Submission", XMLPROJECTION = "ELEMENT");

Property Documents As list Of HS.IHE.XDSb.Types.Document(XMLNAME = "Document", XMLPROJECTION = "ELEMENT");

Property Folders As list Of HS.IHE.XDSb.Types.Folder(XMLNAME = "Folder", XMLPROJECTION = "ELEMENT");

Property ObjectRefs As list Of HS.IHE.XDSb.Types.ObjectRef(XMLNAME = "ObjectRef", XMLPROJECTION = "ELEMENT");

Property Associations As list Of HS.IHE.XDSb.Types.Association(XMLNAME = "Association", XMLPROJECTION = "ELEMENT");

Property Errors As HS.Types.IHE.Errors;

Method AddAssociation(pType As %String, pParent, pChild) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tParent = $S($IsObject(pParent):pParent.EntryUUID,1:pParent)
		Set tChild = $S($IsObject(pChild):pChild.EntryUUID,1:pChild)
		Set tAssoc = ##class(Association).%New(pType, tParent, tChild)
		If '$IsObject(..Associations) Set ..Associations = ##class(%ListOfObjects).%New()
		Set tSC = ..Associations.Insert(tAssoc)
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

Method AddObjectRef(pObject, pHome As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObject = ##class(ObjectRef).%New()
		If $IsObject(pObject) {
			Set tObject.EntryUUID = pObject.EntryUUID
			Set tObject.HomeCommunityId = pObject.HomeCommunityId
		} Else {
			Set tObject.EntryUUID = pObject
			Set tObject.HomeCommunityId = pHome
		}
		If '$IsObject(..ObjectRefs) Set ..ObjectRefs = ##class(%ListOfObjects).%New()
		Set tSC = ..ObjectRefs.Insert(tObject)
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

}
