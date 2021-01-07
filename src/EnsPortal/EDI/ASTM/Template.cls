/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsPortal.EDI.ASTM.Template Extends EnsPortal.EDI.Template [ Abstract, System = 4 ]
{

Method %GetLocatorLinks(Output pLink) As %Status
{
	Do ..%GetRootLink(.pLink)
	Set pLink(2) = $LB($$$Text("ASTM Schemas","Ensemble"),"EnsPortal.EDI.ASTM.SchemaMain.zen") 
	Set pLink(3) = $LB(..%OnGetPageName(),"#")
	Quit $$$OK
}

}
