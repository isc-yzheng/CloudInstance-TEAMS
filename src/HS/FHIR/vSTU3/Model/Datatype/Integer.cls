/// A whole number<br>
/// 32 bit number; for values larger than this, use decimal<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Datatype.Integer Extends HS.FHIR.vSTU3.Model.Base.Element [ CompileAfter = HS.FHIR.vSTU3.Model.Datatype.IntegerPrimitive, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "integer";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

Property value As HS.FHIR.vSTU3.Model.Datatype.IntegerPrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

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
			} ElseIf pExtension.Count()>0 {
				For i = 1:1:pExtension.Count() {
					Set tSC = ..extension.Insert(pExtension.GetAt(i)) Quit:$$$ISERR(tSC)
				}
			}
			Quit:$$$ISERR(tSC)
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod valueIsValid(val) As %Status
{
	Set tSC = $select(val=$c(0)&&$zu(115,13):1,$isvalidnum(val,0,-2147483648,2147483647):1,'$isvalidnum(val):$$Error^%apiOBJ(7207,val),val<-2147483648:$$Error^%apiOBJ(7204,val,-2147483648),1:$$Error^%apiOBJ(7203,val,2147483647))
	If $$$ISERR(tSC) Quit tSC
	// Adding on Regex check, using the XMLPATTERN from IntegerPrimitive.
	Set tSC = $Match(val,"-?([0]|([1-9][0-9]*))")
	If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "value '"_val_"' is not an integer")
	Quit tSC
}

}
