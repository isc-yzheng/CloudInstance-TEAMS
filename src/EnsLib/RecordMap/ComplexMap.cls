/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsRecordMap

Class EnsLib.RecordMap.ComplexMap [ Abstract, System = 4 ]
{

Parameter BATCHCLASS;

ClassMethod GetBatch(pIOStream As %IO.DeviceStream, pTimeout As %Numeric = -1, Output pBatch As EnsLib.RecordMap.ComplexBatch, ByRef pLookAhead As %String = "") As %Status
{
	Set pBatch = ""
	Quit $$$ERROR($$$NotImplemented)
}

/// Write out the batch header, all the records in the batch, and then the batch trailer
Method OutputWholeBatch(pIOStream As %IO.DeviceStream, pRecordMap As %String, pUnSwizzleRecords As %Boolean = 1) As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

/// Delete an existing Complex RecordMap, and optionally delete the target class definition and the target class's extent.
/// The option to remove the extent is only evaluated if the target class is also being deleted, otherwise the option is ignored.
ClassMethod DeleteComplexMap(pComplexMap As %String = "", pRemoveTargetClass As %Boolean = 0, pRemoveTargetExtent As %Boolean = 0) As %Status
{
	If '##class(EnsLib.RecordMap.Model.ComplexBatch).Exists(pComplexMap) Quit $$$ERROR($$$ClassDoesNotExist,pComplexMap)
	Set tStatus = $$$OK
	Try {
		Set tComplexMap = $$$NormalizeClassname(pComplexMap)
		Set tTargetClass = $$$comMemberKeyGet(tComplexMap,$$$cCLASSparameter,"BATCHCLASS",$$$cPARAMdefault)
		Set tStatus = ##class(%Dictionary.ClassDefinition).%DeleteId(tComplexMap)
		If $$$ISERR(tStatus) Quit
		
		If pRemoveTargetClass && (tTargetClass '= "") {
			Set tTargetClass = $$$NormalizeClassname(tTargetClass)
			If pRemoveTargetExtent && ##class(%Dictionary.CompiledClass).%ExistsId(tTargetClass) && $classmethod(tTargetClass, "%Extends", "%Persistent") {
				Set tStatus = $classmethod(tTargetClass, "%DeleteExtent")
				If $system.Status.Equals(tStatus, $$$ERRORCODE($$$ClassDoesNotExist), $$$ERRORCODE($$$DeleteObjectNotFound)) Set tStatus = $$$OK
				If $$$ISERR(tStatus) Quit
			}
			// Returns an error if target class doesn't exist
			Set tStatus = ##class(%Dictionary.ClassDefinition).%DeleteId(tTargetClass)
			If $$$ISERR(tStatus) Quit
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

}
