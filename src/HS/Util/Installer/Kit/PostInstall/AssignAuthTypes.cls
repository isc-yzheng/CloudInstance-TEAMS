/// Setup Patient Reports
Class HS.Util.Installer.Kit.PostInstall.AssignAuthTypes Extends HS.Util.Installer.Kit.Base
{

/// As soon as you activate the hub namespace, it uses this method to populate the table in the hub namespace.  
/// Use the SMP SQL management portal, and you will see the contents of the table.  
/// Note - this will add samples, but not overwrite any existing ones
ClassMethod RunHub(pNamespaces As HS.Util.Installer.Kit.Namespaces, pArgs...) As %Status
{
	Set tSC=..AddType("XX","Corporate ID",1,1,1)
	Set:$$$ISOK(tSC) tSC=..AddType("SN","Insurance ID")
	Set:$$$ISOK(tSC) tSC=..AddType("DL","Driver's License")
	Set:$$$ISOK(tSC) tSC=..AddType("MR","Medical Record Number",,0,1)
	Set:$$$ISOK(tSC) tSC=..AddType("PPN","Passport Number",,0)
	Set:$$$ISOK(tSC) tSC=..AddType("SS","Social Security Number",0,0)
	Set:$$$ISOK(tSC) tSC=..AddType("DN","Doctor Number",,0,1)
	Set:$$$ISOK(tSC) tSC=..AddType("PT","PIX identifier",,0,1)
	Set:$$$ISOK(tSC) tSC=..AddType("LN","Doctor License Number",,0,1)
	
	Quit tSC
}

ClassMethod AddType(pType As %String, pName As %String, pActive As %Boolean = 1, pInSearchList As %Boolean = 1, pExactMatch As %Boolean = 0) As %Status
{
	Set tSC=$$$OK
	&sql(select Count(*) into :tCount from HS_AssignAuth.IdentifierType Where Type = :pType)
	If 'tCount {
		Set tObj=##Class(HS.AssignAuth.IdentifierType).%New()
		Set tObj.Type=pType
		Set tObj.Name=pName
		Set tObj.Active=pActive
		Set tObj.ExactMatch=pExactMatch
		Set tObj.InSearchList=pInSearchList
		Set tSC=tObj.%Save()
	}
	
	Quit tSC
}

}
