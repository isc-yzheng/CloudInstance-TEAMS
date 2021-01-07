/// A FHIR request message.  Typically represents the inbound REST request
Class HS.Message.FHIR.Request Extends (HS.Message.FHIR.Base, HS.Util.EnsRequest) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// The FHIR interaction
Property Interaction As %String [ Required ];

/// Query Parameters
Property Parameters As array Of %List;

/// Compartment
Property Compartment As %String(MAXLEN = 255);

/// Add formatting indents and lines feeds to returned FHIR payload
Property FormatFHIROutput As %Boolean [ InitialExpression = 0 ];

Property SessionApplication As %String(MAXLEN = 255);

Property SessionId As %String(MAXLEN = 255);

/// For client-side request messages, Accept is not used.<br>
/// For server-side request messages, Accept is populated with a value
/// derived from the first found of the either the request URL _format
/// parameter or the HTTP Accept header value.
Property Accept As %String(MAXLEN = 255);

Parameter RESPONSECLASSNAME As %String = "HS.Message.FHIR.Response";

/// GetParameterCount returns the number of instances of a given parameter.
/// This method assumes that all instances of a given parameter include
/// a modifier OR all instances do NOT include a modifier.
/// Parameter modifier in FHIR is expressed as a colon-delimited suffix
/// on the parameter name (not value), for example family:exact=jones.
Method GetParameterCount(pParamName As %String) As %Integer
{
	Set tCount = 0
	
	Set tKey = ""
	For {
		Set tParamItem = ..Parameters.GetNext(.tKey)
		If tKey="" Quit
		If $Piece(tKey,":",1)=pParamName Set tCount = $ListLength(tParamItem) Quit
	}
	
	Quit tCount
}

/// GetParameter returns the value of a specified parameter instance,
/// plus any parameter modifier.  This method assumes that all
/// instances of a given parameter include a modifier OR all instances
/// do NOT include a modifier.  Parameter modifier in FHIR is expressed
/// as a colon-delimited suffix on the parameter name (not value), for
/// example family:exact=jones.
Method GetParameterValue(pParamName As %String, pPosition As %Integer = 1, ByRef pModifier As %String) As %String
{
	Set tParamValue = ""
	Set pModifier = ""
	
	Set tKey = ""
	For {
		Set tParamItem = ..Parameters.GetNext(.tKey)
		If tKey="" Quit
		If $Piece(tKey,":",1)=pParamName {
			If $ListGet(..Parameters.GetAt(tKey),pPosition)'="" {
				Set tParamValue = $ListGet(..Parameters.GetAt(tKey),pPosition)
				Set pModifier = $Piece(tKey,":",2)
			}
			Quit
		}
	}
	
	Quit tParamValue
}

/// SetParameter adds the specified parameter, modifier, and
/// value to the request message Parameters collection.
Method SetParameter(pParamName As %String = "", pParamValue As %String = "", pModifier As %String = "") As %Status
{
	Set tSC = $$$OK
	
	If (pParamName'="")&&(pParamValue'="") {
		If $Extract(pModifier)=":" Set pModifier = $Extract(pModifier,2,*)
		If pModifier'="" Set pParamName = pParamName_":"_pModifier
		Set tParamList = ..Parameters.GetAt(pParamName)
		Set tParamList = tParamList_$ListBuild(pParamValue)
		Set tSC = ..Parameters.SetAt(tParamList, pParamName)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "Error setting parameter "_pParamName_" - "_$system.Status.GetErrorText(tSC))
	} ElseIf pParamName="" {
		Set tSC = $$$ERROR($$$GeneralError, "Error setting parameter - parameter name not specified")
	} ElseIf pParamValue="" {
		Set tSC = $$$ERROR($$$GeneralError, "Error setting parameter "_pParamName_" - parameter value not specified")
	}
	
	Quit tSC
}

Storage Default
{
<Data name="Parameters">
<Attribute>Parameters</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.FHIR.Request.Parameters"</Subscript>
</Data>
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Interaction</Value>
</Value>
<Value name="2">
<Value>Compartment</Value>
</Value>
<Value name="3">
<Value>HSMinVersion</Value>
</Value>
<Value name="4">
<Value>HSCoreVersion</Value>
</Value>
<Value name="5">
<Value>FormatFHIROutput</Value>
</Value>
<Value name="6">
<Value>SessionApplication</Value>
</Value>
<Value name="7">
<Value>SessionId</Value>
</Value>
<Value name="8">
<Value>%ClearFields</Value>
</Value>
<Value name="9">
<Value>Accept</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
