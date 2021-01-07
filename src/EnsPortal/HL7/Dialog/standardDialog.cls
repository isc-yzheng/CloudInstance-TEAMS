/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsPortal.HL7.Dialog.standardDialog Extends (EnsPortal.Dialog.standardDialog, EnsPortal.HL7.SourceControl.Base) [ System = 4 ]
{

Property category As %ZEN.Datatype.string(MAXLEN = "");

/// Override to return correct Category
Method scCategoryGet() As %String [ ServerOnly = 1 ]
{
	Quit ..category
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
