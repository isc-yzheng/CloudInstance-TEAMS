/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// <p> This class is for internal InterSystems use only. The class is subject to change and should not be
/// used by user applications.</p>
/// Used by HL7 Schema editor pages to be source control aware.
Class EnsPortal.HL7.SourceControl.Base [ Abstract, System = 4 ]
{

Property msgSCReadOnly As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Your source control framework has marked this document as read only, so you will not be able to modify this document.")} ];

Property msgDocReadOnly As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("This custom schema is read only.")} ];

/// Flag to indicate whether source control hooks are enabled for the current namespace.
Property sourceControlEnabled As %ZEN.Datatype.boolean [ InitialExpression = {##class(%CSP.Portal.SourceControl.Util).IsEnabled($namespace)} ];

Property sourceControlNewlineFormat As %ZEN.Datatype.string [ InitialExpression = "HTML" ];

/// Standardized Category property name for source control use for the different dialog pages
Property scCategory As %String(MAXLEN = "") [ Calculated, Internal ];

/// If true, user cannot modify the current document.
Property readOnly As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Override to return correct Category
Method scCategoryGet() As %String [ ServerOnly = 1 ]
{
	Quit ""
}

/// Return the internal name of the current document.
Method GetInternalName() As %String
{
	Quit ..scCategory_".HL7"
}

Method IsSchemaSCReadOnly() As %Boolean [ ZenMethod ]
{
	If ..scCategory = "" Quit 0
	Quit ##class(%CSP.Portal.SourceControl.Base).IsSourceControlReadOnly(..GetInternalName())
}

ClientMethod scDisabled() [ Language = javascript ]
{
	alert(this.msgSCReadOnly);
}

ClientMethod setReadOnly(readOnly) [ Language = javascript ]
{
	this.readOnly = !!readOnly;
}

/// Test if the user has write privilege.
ClientMethod canUserModify(saveAs) [ Language = javascript ]
{
	if (!this.checkEdit()) return false;

	if (this.readOnly) {
		alert(this.msgDocReadOnly);
		return false;
	}
	return true;
}

/// Implement OnSchemaSave to be able to call Source Control OnBeforeSave and OnAfterSave around the global sets of the Schema
Method OnSchemaSave(pWhen As %String = "before", Output pOutput As %DynamicObject) As %String [ Internal ]
{
	#dim tStatus = $$$OK
	#dim ex AS %Exception.AbstractException

	Set pOutput = {}

	#dim tIO
	#dim tSourceControl
	#dim tCreated = 0

	Try {
		#dim tReturn = ""
		Set tStatus = $$$OK
		Set pOutput.serverOutput = ""

		Set tStatus = ##class(%CSP.Portal.SourceControl.IO).Redirect(.tIO,,,,..sourceControlNewlineFormat)
		If $$$ISERR(tStatus) Quit
		Set tStatus = ##class(%CSP.Portal.SourceControl.Base).CreateSourceControl(.tSourceControl, .tCreated)
		If $$$ISERR(tStatus) Quit

		If 'tCreated Quit

		#dim tProjectName = ##class(%CSP.Portal.SourceControl.Base).GetCurrentProject()

		If tProjectName '= "" {
			Set tStatus = ##class(%CSP.Portal.SourceControl.Base).LoadProject(tSourceControl, tProjectName, 0)
			If $$$ISERR(tStatus) Quit
		}

		Set pOutput.created = 1
		If pWhen = "before" {
			Set tStatus = tSourceControl.OnBeforeSave(..GetInternalName())
		}
		Else {
			Set tStatus = tSourceControl.OnAfterSave(..GetInternalName())
		}

	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If $IsObject($get(tIO)) {
		Try {
			Do ..handleRedirect(tIO, .tStatus, pOutput)
		} Catch ex {Set tStatus = $$$ADDSC(tStatus,ex.AsStatus())}
	}

	If $$$ISERR(tStatus) Set tReturn = $system.Status.GetErrorText(tStatus)

	Quit tReturn
}

/// Helper method to capture redirected output.
ClassMethod handleRedirect(pRedirect As %CSP.Portal.SourceControl.IO, ByRef pStatus As %Status = {$$$OK}, pOutputProxy As %DynamicObject) [ Internal, Private ]
{
	#dim ex AS %Exception.AbstractException
	Try {
		#dim tStatus = $$$OK
		Set tStatus = pRedirect.StopRedirect()
		If $$$ISERR(tStatus) Quit
		#dim tStream
		Set tStatus = pRedirect.GetData(.tStream)
		If $$$ISERR(tStatus) Quit
		
		If $IsObject($get(%session)) {
			#dim tHasData = 0
			While 'tStream.AtEnd {
				#dim tData = tStream.Read()
				If tData '= "" {
					Set tHasData = 1
					Do ##class(%CSP.Portal.SourceControl.Base).AppendSourceControlOutput(tData)
				}
			}
			If tHasData && $IsObject($Get(pOutputProxy)){
				Set pOutputProxy.serverOutput = "1"
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit $$$ADDSC(tStatus, pStatus)
}

}
