/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Context base class for requesting evaluation of a rule that uses The ExtensionsAssist class
Class Ens.Rule.ExtensionInputs Extends %Persistent [ Abstract ]
{

/// JSON string of Rule inputs
Property %JSON As %String(MAXLEN = "") [ Internal ];

/// Object representation of JSON string
Property %Inputs As %DynamicObject [ Internal, Transient ];

/// Counter for JSON changes while in memory
Property %JSONUpd As %Integer [ InitialExpression = 1, Internal, Transient ];

/// Flag for Inputs matching JSON update while in memory
Property %InputsUpd As %Integer [ Internal, Transient ];

/// Override this JSON in a subclass to enable editing the associated Rule with Rule Extensions supported by the Ens.Rule.ExtensionsAssist class;
/// The format of the parameter value is a JSON object containing a data type name for each described input name
XData InputTypesJSON [ MimeType = application/json ]
{
{}
}

Method %OnNew(initvalue As %String) As %Status
{
	If $IsObject($Get(initvalue)) { Set ..%Inputs = initvalue }
	Else { Set i%%JSON = $Get(initvalue) }

	Set classname = $classname()
	Set tSC = ##class(Ens.Rule.ExtensionsAssist).ContextList(classname,.propsList)
	Quit:$$$ISERR(tSC) tSC

	// iterate over: properties, inputTypes, inputs
	Set iProp = propsList.%GetIterator() While iProp.%GetNext(.idx, .propAttrs) {
		//{"name":(propName),"irisType":(propType),"pluginType":(pluginType.type),"pluginSchema":(pluginType.pluginSchema)})
		// construct each property from input based on input datatype and inputType
		Kill propData,propVal
		Set propName = propAttrs.name
		Set propData = $S($IsObject(..%Inputs):..%Inputs.%Get(propName), 1:"")
		If $L(propAttrs.pluginClass) {
			try {
				Set propVal = $classmethod(propAttrs.pluginClass,"Create",propData,.tSC)
			} catch ex {
				Set:ex.Name'="<METHOD DOES NOT EXIST>" tSC = ex.AsStatus()
			}
		}
		If $$$ISOK(tSC) && '$D(propVal) && $IsObject(propData) && $L(propData.class) && $L(propData.id) && $classmethod(propData.class,"%Extends",propAttrs.irisType) {
			try {
				Set propVal = $classmethod(propData.class,"%OpenId",propData.id,,.tSC)
				Set:'$IsObject(propVal) tSC=$G(%objlasterror,$$$ERROR($$$GeneralError,"Failed to open "_propAttrs.irisType_" object with "_propData.%ToJSON()_" : "_$$$StatusDisplayString(tSC)))
			} catch ex {
				Set tSC = ex.AsStatus()
			}
		}
		If $$$ISOK(tSC) && '$D(propVal) {
			try {
				Kill %objlasterror
				Set propVal = $classmethod(propAttrs.irisType,"%New",propData)
				Set:'$IsObject(propVal) tSC=$G(%objlasterror,$$$ERROR($$$GeneralError,"Failed to instantiate "_propAttrs.irisType_" with data "_propData))
				Set:propVal.%Extends("Ens.VDoc.Interface") propVal.DocType = propAttrs.pluginSchema
			} catch ex {
				Set:ex.Name'="<METHOD DOES NOT EXIST>" tSC = ex.AsStatus()
			}
		}
		If $$$ISOK(tSC) && '$D(propVal) {
			Set propVal = propData
		}
		Quit:$$$ISERR(tSC)
		Set $property($this,propName) = propVal
	}

	// warn on leftover inputs

	Quit tSC
}

Method %JSONSet(tJSON As %String) As %Status
{
	Set i%%JSON = tJSON
	Set ..%JSONUpd = ..%JSONUpd+1
	Quit $$$OK
}

Method %InputsGet() As %DynamicObject
{
	Quit:..%InputsUpd=..%JSONUpd r%%Inputs
	If $E(..%JSON) '= "{" {
		Set r%%Inputs = $$$NULLOREF
	} Else {
		Do ##class(%ZEN.Auxiliary.jsonProvider).%ParseJSON(..%JSON,,.obj) ; support parsing unquoted property names
		Do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,obj,,,,"aeilow4")
		Set r%%Inputs = ##class(%DynamicObject).%FromJSON(tStream)
	}
	Set ..%InputsUpd = ..%JSONUpd
	Quit r%%Inputs
}

Method %InputsSet(tInputsObj As %DynamicObject) As %Status
{
	If $classname(tInputsObj) = "%Library.DynamicObject" {
		Set r%%Inputs = tInputsObj
		Set i%%JSON = tInputsObj.%ToJSON()
	} Else {
		Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,tInputsObj,,,,"aeilow4")
		Quit:$$$ISERR(tSC) tSC
		Set i%%JSON = tStream.Read()
		Set r%%Inputs = ##class(%DynamicObject).%FromJSON(i%%JSON)
	}
	Set (..%JSONUpd,..%InputsUpd) = 1
	Quit $$$OK
}

Storage Default
{
<Data name="ExtensionInputsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%JSON</Value>
</Value>
</Data>
<DataLocation>^Ens.Rule.ExtensionInputsD</DataLocation>
<DefaultData>ExtensionInputsDefaultData</DefaultData>
<IdLocation>^Ens.Rule.ExtensionInputsD</IdLocation>
<IndexLocation>^Ens.Rule.ExtensionInputsI</IndexLocation>
<StreamLocation>^Ens.Rule.ExtensionInputsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
