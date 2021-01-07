/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsHL7)

/// This class contains utility methods to support the HL7 user interface
Class EnsPortal.HL7.Utils Extends %RegisteredObject
{

Parameter DOMAIN = "Ensemble";

/// Accepts a schema name as input. Returns its base schema or "" if there is no base schema.
ClassMethod GetImmediateBaseSchema(pSchema As %String) As %String
{
	Quit:pSchema="" ""
	If ($D($$$vaSchemaGbl(pSchema)) && $D($$$vaSchemaGbl(pSchema, "base"))) {
		Set tBase = $G($$$vaSchemaGbl(pSchema, "base"))
	}
	Else {
		Set tBase = ""
	}
	Quit tBase
}

/// Accepts a schema name as input. Returns a comma-separated list of schema names ordered from the 
/// "most custom" custom schema to the "least custom" schema, which may be a standard schema.
ClassMethod GetSchemaInheritanceList(pSchema As %String) As %String
{
	Set tList = pSchema
	Set current = pSchema
	While ($D($$$vaSchemaGbl(current, "base"))) {
		Set current = $G($$$vaSchemaGbl(current, "base"))
		Set tList = tList _ "," _ current
	}
	Quit tList
}

/// Accepts a schema name as input. Returns 1 (true) if the schema is custom, 0 (false) if it is standard).
ClassMethod IsCustomSchema(pSchema As %String) As %Boolean
{
	If (( $D($$$vaSchemaDescGbl(pSchema,"std")) ) && ( +$G($$$vaSchemaDescGbl(pSchema,"std")) = 1 )) { Quit 0 }
	Else { Quit 1 }
}

/// Indicates whether the entity exists
/// in the schema. 1 = true, 0 = false.
/// If searching for a schema itself, use pType="" and pEntity="".
/// Otherwise use pType values suitable for schemas such as "MT" "MS" "DS" and so on.
ClassMethod SchemaEntityAlreadyExists(pSchema As %String, pEntity As %String, pType As %String) As %String
{
	Set tMsg = ""
	Set found = 0
	Try {
		Set tQuery = $S(pType="":"EnsLib.HL7.Message:EnumerateTypeCategories",
		                pType="MT":"EnsLib.HL7.Message:EnumerateMessageTypes", 
		                pType="MS":"EnsLib.HL7.Message:EnumerateDocTypes",
		                pType="SS":"EnsLib.HL7.Message:EnumerateSegTypes", 
		                pType="DS":"EnsLib.HL7.Schema:DataStructures",
		                pType="DT":"EnsLib.HL7.Schema:DataStructures", 
		                pType="CT":"EnsLib.HL7.Schema:CodeTables", 
		                1:"")
		Set tColumn = $S(pType="":"Category",
						 pType="MT":"Type", 
		                 pType="MS":"Type",
		                 pType="SS":"SegType", 
		                 pType="DS":"DataStruct",
		                 pType="DT":"DataStruct", 
		                 pType="CT":"CodeTable", 
		                 1:"")
		Set tFullName = $S(pType="":pSchema,
						   pType="MT":pSchema _ ":" _ pEntity, 
		                   pType="MS":pSchema _ ":" _ pEntity, 
		                   pType="SS":pSchema _ ":" _ pEntity,
		                   pType="DS":pSchema _ ":" _ pEntity,
		                   pType="DT":pSchema _ ":" _ pEntity,
		                   pType="CT":pSchema _ ":" _ pEntity,
		                   1:"")
		Set tRS = ##class(%ResultSet).%New(tQuery)

		If pType="SS" {
			#; EnsLib.HL7.Schema::SegTypesExecute() called by EnsLib.HL7.Message:EnumerateSegTypes supports searching by Category passed as Category:Segment type name
			Do tRS.Execute(tFullName)
		} Else {
			Do tRS.Execute(pSchema)
		}

		If (tRS) { ; There is data 
			While ('found & tRS.Next()) { 
				If (tFullName = tRS.Data(tColumn)) { ; we found it
					Set found = 1 
				}
			}
		}
		Set tMsg = $S(found:"1", 'found:"0")
	}
	Catch (ex) {
	}
	Quit tMsg
}

/// Accepts a custom schema name and schema entity (such as a message type or message structure) as input.
/// Looks through this schema's inheritance to find out where the "most custom"
/// entity of this type is defined and returns a string in the form "schema:name" with the name being the input entity name.
/// If no entity of this type is found in the inheritance hierarchy, even in a standard schema, then it returns a blank string.
ClassMethod GetMostCustomSchemaEntity(pSchema As %String, pEntity As %String, pType As %String) As %String
{
	Set tMsg = ""
	Try {
		Set tList = ..GetSchemaInheritanceList(pSchema)
		Set tQuery = $S(pType="MT":"EnsLib.HL7.Message:EnumerateMessageTypes", 
		                pType="MS":"EnsLib.HL7.Message:EnumerateDocTypes", 
		                pType="SS":"EnsLib.HL7.Message:EnumerateSegTypes", 
		                1:"")
		Set tColumn = $S(pType="MT":"Type", 
		                 pType="MS":"Type", 
		                 pType="SS":"SegType", 
		                 1:"")
		Set tRS = ##class(%ResultSet).%New(tQuery)
		Do tRS.Execute()
		While (tRS.Next()) {
			Set tDoc = tRS.Data(tColumn)
			Set tName = $P(tDoc, ":", 2)
			If (tName = pEntity) {
				Set tPrefix = $P(tDoc, ":", 1)
				Set foundNew = 0
				For i=1:1:$L(tList, ",") {
					If (foundNew)  Quit
					If (tPrefix = $P(tList, ",", i)) { // see if the prefix indicates a schema we are interested in
						Set foundNew = 1
						Set indexNew = i
						If (tMsg = "") { // there was no existing entry so use this one
							Set tMsg = tPrefix
						}
						Else { // there is an existing entry for pType
							Set foundOld = 0
							For j=1:1:$L(tList, ",") { // see if we want to replace an existing entry with this new one
								If (foundOld) Quit
								If (tMsg = $P(tList, ",", j)) {
									Set foundOld = 1
									Set indexOld = j
								}
							}
							If (indexOld > indexNew) { // use the more "custom" custom schema in the hierarchy
								Set tMsg = tPrefix
							}
						}
					}
				}
			}
		}
		If (tMsg '= "") {
			Set tMsg = tMsg _ ":" _ pEntity
		}
	}
	Catch (ex) {
	}
	Quit tMsg
}

}
