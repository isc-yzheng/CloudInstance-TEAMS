/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsHL7)

/// Context search methods.
Class EnsLib.HL7.ContextSearch Extends %ZEN.Portal.ContextSearch [ System = 4 ]
{

/// For HL7 only. The hierarchy in the other EDI standards does not include this level.
ClassMethod MessageTypes(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tSC=$$$OK  
	Kill pResults
	Try {
		Set n = 0
		Set tSchema = $get(pParms("cat")) Quit:""=tSchema
		Set tList = ##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(tSchema)
		Set tRS = ##class(%ResultSet).%New("EnsLib.HL7.Message:EnumerateMessageTypes")
		Do tRS.Execute()
		While (tRS.Next()) {
			Set tDoc = tRS.Data("Type")
			Set tPrefix = $P(tDoc, ":", 1)
			Set tName = $P(tDoc, ":", 2)
			Set foundNew = 0
			For i=1:1:$L(tList, ",") {
				If (foundNew)  Quit
				If (tPrefix = $P(tList, ",", i)) { // see if the prefix indicates a schema we are interested in
					Set foundNew = 1
					Set indexNew = i
					If ($D(tArray(tName))) { // there is an existing entry for this message type
						Set foundOld = 0
						For j=1:1:$L(tList, ",") { // see if we want to replace an existing entry with this new one
							If (foundOld) Quit
							If ($G(tArray(tName)) = $P(tList, ",", j)) {
								Set foundOld = 1
								Set indexOld = j
							}
						}
						If (indexOld > indexNew) { // use the more "custom" custom schema in the hierarchy
							Set tArray(tName) = tPrefix
						}
					}
					Else { // there was no existing entry so use this one
						Set tArray(tName) = tPrefix
					}
				}
			}
		}
		Set tNext = ""
		For { 
			Set tNext = $O(tArray(tNext), 1, tValue)  Quit:tNext=""
			Set n = n + 1
			Set pResults(n) = tNext _ " (" _ tValue _ ")"
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// For the HL7 Package only.
ClassMethod MessageStructures(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tSC=$$$OK  
	Kill pResults
	Try {
		Set n = 0
		Set tSchema = $get(pParms("cat")) Quit:""=tSchema
		Set tList = ##class(EnsPortal.HL7.Utils).GetSchemaInheritanceList(tSchema)
		Set tRS = ##class(%ResultSet).%New("EnsLib.HL7.Message:EnumerateDocTypes")
		Do tRS.Execute()
		While (tRS.Next()) {
			Set tDoc = tRS.Data("Type")
			Set tPrefix = $P(tDoc,":",1)
			Set tName = $P(tDoc, ":", 2)
			For i=1:1:$L(tList, ",") {
				If (tPrefix = $P(tList, ",", i)) { // see if the prefix indicates a schema we are interested in
					If ('$D(tArray(tName))) { // there was no existing entry so use this one
						Set tArray(tName) = ""
					}
					Quit
				}
			}
		}
		Set tNext = ""
		For { 
			Set tNext = $O(tArray(tNext))  Quit:tNext=""
			Set n = n + 1
			Set pResults(n) = tNext
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
