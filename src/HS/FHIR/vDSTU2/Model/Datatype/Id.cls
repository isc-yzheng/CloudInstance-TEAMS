Class HS.FHIR.vDSTU2.Model.Datatype.Id Extends HS.FHIR.vDSTU2.Model.Base.Element [ CompileAfter = HS.FHIR.vDSTU2.Model.Datatype.IdPrimitive, ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "id";

Parameter XMLSEQUENCE = 1;

Property value As HS.FHIR.vDSTU2.Model.Datatype.IdPrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// Get new object, populated with specified data.
Method %OnNew(pValue As %String, pExtension As %RegisteredObject, pId As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pExtension)=0)&&($Data(pId)=0) Quit
		If $Get(pValue)'="" Set ..value = pValue
		If $Get(pId)'="" Set ..id = pId
		#; pExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pExtension)) {
			If (pExtension.%Extends("%Collection.ListOfObj")=0)&&(pExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..extension.Insert(pExtension) Quit:$$$ISERR(tSC)
			} Else {
				Set ..extension = pExtension
			}
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod valueIsValid(val) As %Status
{
	Set tMaxlen = 64
	// From Original valueIsValid.
	Set tSC = $s(($s(val'=$c(0):$l(val),1:0)'<1)&&($l(val)'>tMaxlen):1,$s(val'=$c(0):$l(val),1:0)<1:$$Error^%apiOBJ(7202,val,1),1:$$Error^%apiOBJ(7201,val,tMaxlen))
	If $$$ISERR(tSC) Quit tSC
	// Adding on Regex check, using the XMLPATTERN from IdPrimitive.
	Set tSC = $Match(val,"[A-Za-z0-9\-\.]{1,64}")
	If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "value '"_val_"' is not a valid FHIR resource id")
	Quit tSC
}

}
