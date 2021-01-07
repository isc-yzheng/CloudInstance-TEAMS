/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsPortal.HL7.Template Extends (EnsPortal.EDI.Template, EnsPortal.HL7.SourceControl.Base) [ Abstract, System = 4 ]
{

Method %GetLocatorLinks(Output pLink) As %Status
{
	Do ..%GetRootLink(.pLink)
	Set pLink(2) = $LB($$$Text("HL7 Schemas","Ensemble"),"EnsPortal.HL7.SchemaMain.zen") 
	Set pLink(3) = $LB(..%OnGetPageName(),"#")
	Quit $$$OK
}

Method %OnAfterCreatePage() As %Status
{
	#dim tSC = ##super()

	If $$$ISOK(tSC) {

		If ..sourceControlEnabled Set ..readOnly = ..IsSchemaSCReadOnly()

	}

	Quit tSC
}

}
