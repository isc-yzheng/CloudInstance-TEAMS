/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class Ens.Util.JSON [ Abstract, System = 4 ]
{

ClassMethod JSONStreamToObject(pStream, Output pObject As %RegisteredObject, pClass As %String, pIgnoreUnknownProps As %Boolean) As %Status
{
	Set tSC=##class(%ZEN.Auxiliary.jsonProvider).%ParseJSON(pStream,.pClass,.pObject,,,,.pIgnoreUnknownProps)
	Quit:$$$IsdefObject(pObject) tSC
	Set:$$$ISOK(tSC) tSC=$$$ERROR($$$EnsErrGeneral,"No object found in JSON stream "_pStream.Read(200+pStream.Rewind()))
	Quit tSC
}

ClassMethod JSONStreamToObjectArray(pStream, Output pArray, pClass As %String, pIgnoreUnknownProps As %Boolean) As %Status
{
	Kill pArray
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ParseJSON(.pStream,.pClass,.tObjectList,,,,.pIgnoreUnknownProps)
	If $$$ISERR(tSC) Quit tSC
	Set pArray = tObjectList.Count()
	For i=1:1:pArray {
		Set pArray(i) = tObjectList.GetAt(i)
	}
	Quit tSC
}

ClassMethod ObjectToJSONStream(pObject As %RegisteredObject, ByRef pStream, pFormat As %String = "iw") As %Status [ CodeMode = expression ]
{
##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.pStream,.pObject,,,,pFormat)
}

/* Query used by Source Code editing REST API /action/query */
/// Returns XData model as JSON<br>
/// Requires XData Object to extend %JSON.Adaptor
/// Protected by resource determined by XDataName<br>
/// RuleDefinition : To read: one of "%Ens_Rules:READ,%Ens_RoutingRules:READ,%Ens_BusinessRules:READ,%Ens_Code:READ"
Query GetXDataAsJSON(pClassname As %String = "", pXDataName As %String = "") As %Query(ROWSPEC = "XDataAsJSON") [ SqlProc ]
{
}

ClassMethod GetXDataAsJSONExecute(ByRef qHandle As %Binary, pClassname As %String = "", pXDataName As %String = "") As %Status
{
	Set qHandle("Classname") = pClassname
	Set qHandle("XDataName") = pXDataName
	Quit $$$OK
}

ClassMethod GetXDataAsJSONFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
	#dim tSC=$$$OK
	#dim ex As %Exception.AbstractException
	Try {
		Set Row="",AtEnd=1
		Set tSC = ..isSupportedXDataAndPrivilegeChecked(qHandle("XDataName"), 1, "READ")
		If $$$ISOK(tSC) && (qHandle("Classname") '= "") && (qHandle("XDataName") '= "") {
			#dim xdataAsJSON = ""
			Set tXData = ##class(%Dictionary.XDataDefinition).%OpenId(qHandle("Classname")_"||"_qHandle("XDataName"),,.tSC)
			Set:$$$ISOK(tSC) tSC = tXData.Object.%JSONExportToString(.xdataAsJSON)
			Set:$$$ISOK(tSC) Row = $ListBuild(xdataAsJSON)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	#; Only run once
	Set qHandle("Classname") = ""
	Set qHandle("XDataName") = ""
	Quit tSC
}

ClassMethod GetXDataAsJSONClose(ByRef qHandle As %Binary) As %Status
{
	Kill qHandle
	Quit $$$OK
}

/// Internal method to return status if XData to JSON and check access
ClassMethod isSupportedXDataAndPrivilegeChecked(pXDataName As %String = "", pCheckResources As %Boolean = 0, ByRef pOneOfTheseResourcesRequired As %String) As %Status [ Internal, Private ]
{
	#dim tisSupportedXData = $$$ERROR($$$GeneralError,"Requested XData not supported.")

	If (pXDataName = "RuleDefinition") {
		If pOneOfTheseResourcesRequired = "READ" {
			Set pOneOfTheseResourcesRequired = "%Ens_Rules:READ,%Ens_RoutingRules:READ,%Ens_BusinessRules:READ,%Ens_Code:READ"
			Set tisSupportedXData = $$$OK
		} ElseIf pOneOfTheseResourcesRequired = "WRITE" {
			Set pOneOfTheseResourcesRequired = "%Ens_Rules:WRITE,%Ens_RoutingRules:WRITE,%Ens_BusinessRules:WRITE,%Ens_Code:WRITE"
			Set tisSupportedXData = $$$OK
		}
	}
	If $$$ISOK(tisSupportedXData) {
		Set tisSupportedXData =..privilegeCheck(pOneOfTheseResourcesRequired)
	} Else {
		#; Caller ought to check return if supported first. In case not set resource to non existent resource
		Set pOneOfTheseResourcesRequired = "%OughtNotToExistOnlyAll_"_$TR($ZH,".")_":USE"
	}
	Return tisSupportedXData
}

/// Internal privilege check
ClassMethod privilegeCheck(pResources As %String = "") As %Status [ Internal, Private ]
{
	#dim tSC = $$$OK
	#dim ex As %Exception.AbstractException
	#dim tCanUse, i, tPair, tResource, tPermission
	Try {
		#; The resource checks can be skipped if the user has the %All role
		If (pResources '= "") && '$$$IOwnAllRole {
			Set tCanUse = 0
			For i=1:1:$length(pResources,",") {
				Set tPair = $piece(pResources,",",i)
				Set tResource = $piece(tPair,":",1)
				If tResource = "" Continue
				Set tPermission = $piece(tPair,":",2)
				If tPermission = "" Set tPermission = "USE"
				If $system.Security.Check(tResource, tPermission) {
					Set tCanUse = 1
					Quit
				}
			}
			If 'tCanUse {
				Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation)
				Quit
			}
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
