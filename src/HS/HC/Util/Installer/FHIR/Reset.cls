Include HS.HC

Class HS.HC.Util.Installer.FHIR.Reset Extends %RegisteredObject
{

/// Reset calls the Reset() method on all classes that extend this class. If multiple Reset()
/// calls are made, the failure of one call does not abort the execution of this method. All
/// failure statuses are gathered into one %Status object that is then returned by this method.
ClassMethod Reset(pDiscardCapabilities As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Reset FHIR data in "_$Namespace_" started at "_$ZDateTime($Horolog,3))
		
		Set tResultSet = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
		Set tSC = tResultSet.%Execute(..%ClassName(1))
		If $$$ISERR(tSC) Quit
		
		Set tInitialState = ""
		Set tStoppedProd = 0
		
		While tResultSet.%Next() {
			// If the current production has not been checked for stopped, check to
			// see if the current production is running. If it is, then make a note
			// of that, and stop the production.
			If 'tStoppedProd {
				// Make sure the Production is stopped, allow it 30 secs
				Set tSC = ##class(HS.HC.Util.Installer).StopProduction($Namespace, 30, .tInitialState, .tState)
				If $$$ISERR(tSC) Quit
				If tInitialState = $$$eProductionStateStopped {
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production not running")
				} ElseIf tState = $$$eProductionStateStopped {
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production Stopped")
				} ElseIf tState = $$$eProductionStateSuspended {
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production is suspended")
				} Else {
					Set tSC = $$$ERROR($$$GeneralError, "Production not stopped, state = "_$case(tState,$$$eProductionStateRunning:"Running",$$$eProductionStateTroubled:"Troubled",$$$eProductionStateNetworkStopped:"NetworkStopped",:"Unknown"))
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production failed to stop")
				}
				Set tStoppedProd = 1
			}
			Try {
				Set tSC1 = $ClassMethod(tResultSet.Name, "Reset", pDiscardCapabilities)
			} Catch eException {
				Set tSC1 = eException.AsStatus()
			}
			// Accumulate errors.
			Set tSC = $$$ADDSC(tSC, tSC1)
		}
		
		Set tSC1 = ##class(HS.Registry.Document.FHIR).%DeleteExtent()
		// Accumulate errors.
		If $$$ISERR(tSC1) Set tSC = $$$ADDSC(tSC, tSC1)
		
		// If the current production was running before we started calling Reset()
		// methods, then start it back up again.
		If tInitialState=$$$eProductionStateRunning {
			Set tSC = ##class(HS.HC.Util.Installer).StartProduction($namespace,,.tState)
			If $$$ISERR(tSC) Quit
			If tState=$$$eProductionStateRunning {
				Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production restarted")
			} Else {
				Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production failed to restart")
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		Set tErrorText = ""
		Set tErrorCodes = $system.Status.GetErrorCodes(tSC)
		For i = 1:1:$Length(tErrorCodes,",") {
			If tErrorText'="" Set tErrorText = tErrorText_", "
			Set tErrorText = tErrorText_$system.Status.GetOneErrorText(tSC,i)
		}
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Reset FHIR data in "_$namespace_" failed at "_$ZDateTime($Horolog,3)_" - "_tErrorText)
	} Else {
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Reset FHIR data in "_$Namespace_" done at "_$ZDateTime($Horolog,3))
	}
	
	Quit tSC
}

/// ResetBasedOnAbstractClass resets (deletes) the FHIR data in the current namespace
/// based on the specified Health Connect FHIR resource repository storage abstract
/// class. The abstract class is expected to provide an indication of location of the
/// search table data and the resource repository data.
ClassMethod ResetBasedOnAbstractClass(pRepoAbstractClass As %String, pVerbose As %Boolean = 1) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = $ClassMethod(pRepoAbstractClass, "KillAllData", pVerbose)
		If $$$ISERR(tSC) {
			Set tText = "KillAllData for "_pRepoAbstractClass_" repository data delete failed: "_$System.Status.GetErrorText(tSC)
			Set tSC = $$$ERROR($$$GeneralError, tText)
			Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// SaveResources searches for resources of the specified resource type, saves metadata about
/// those resources in the pMetadata array, and saves the resource streams into QuickStreams.
/// <br>Format of pMetadata:
/// <br>pMetadata(n,"ResourceType") = resource type
/// <br>pMetadata(n,"ResourceId") = resource id
/// <br>pMetadata(n,"Format") = format (e.g., xml, json) of the stored resource
/// <br>pMetadata(n,"ResourceSchema") = resource schema for the resource
/// <br>pMetadata(n,"QuickStreamId") = id of the QuickStream temporarily holding the resource
ClassMethod SaveResources(pResourceType As %String, pStorageClass As %String, ByRef pMetadata As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = $ClassMethod(pStorageClass, "Search", pResourceType, , , , , .tResultSet)
		If $$$ISERR(tSC) {
			If $system.Status.GetErrorText(tSC)["Search table definition for resource type" Set tSC = $$$OK
			Quit
		}
		
		While (tResultSet.%Next()) {
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%New()
			Set tQuickStreamId = tQuickStream.%Id()
			Set tSC = $ClassMethod(pStorageClass, "GetStorageDataByStorageId", tResultSet.%Get("ID"), , .tResourceId, , , .tStoredFormat, .tDeleted, , .tQuickStream, .tResourceSchema)
			If $$$ISERR(tSC) Quit
			If $Get(tDeleted) Continue
			Set pMetadata = $Get(pMetadata)+1
			Set pMetadata(pMetadata,"ResourceType") = pResourceType
			Set pMetadata(pMetadata,"ResourceId") = tResourceId
			Set pMetadata(pMetadata,"Format") = tStoredFormat
			Set pMetadata(pMetadata,"ResourceSchema") = tResourceSchema
			Set pMetadata(pMetadata,"QuickStreamId") = tQuickStreamId
		}
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod RestoreResources(pStorageClass As %String, ByRef pMetadata As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		For i = 1:1:+$Get(pMetadata) {
			Set tResourceId = pMetadata(i,"ResourceId")
			Set tStoredFormat = $ZConvert(pMetadata(i,"Format"),"L")
			Set tResourceSchema = pMetadata(i,"ResourceSchema")
			Set tQuickStreamId = pMetadata(i,"QuickStreamId")
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tQuickStreamId)
			Set tSC = $ClassMethod(pStorageClass, "Update", tStoredFormat, tResourceSchema, , , 1, , , , tQuickStream)
			If $$$ISERR(tSC) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ClearQuickStreams(ByRef pMetadata As %String)
{
	If +$Get(pMetadata) {
		For i = 1:1:pMetadata {
			Set tQuickStreamId = pMetadata(i,"QuickStreamId")
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tQuickStreamId)
			Do tQuickStream.Clear()
		}
	}
	Quit
}

}
