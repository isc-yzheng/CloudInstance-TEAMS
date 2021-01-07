/// A rational number with implicit precision<br>
/// Do not use a IEEE type floating point type, instead use something that works like a true decimal, with inbuilt precision (e.g. Java BigInteger)<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Datatype.Decimal Extends HS.FHIR.vSTU3.Model.Base.Element [ CompileAfter = HS.FHIR.vSTU3.Model.Datatype.DecimalPrimitive, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "decimal";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

Property value As HS.FHIR.vSTU3.Model.Datatype.DecimalPrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// Get new object, populated with specified data.
Method %OnNew(pValue As %String, pExtension As %RegisteredObject, pId As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pExtension)=0)&&($Data(pId)=0) Quit
		If $Get(pValue)'="" {
			If $IsValidNum(pValue)=0 Set tSC = $$$ERROR($$$GeneralError,"Invalid decimal value "_pValue) Quit
			If (pValue?.E1"E"1N.N)||(pValue?.E1"e"1N.N) Set pValue = $Decimal(pValue)
			Set ..value = pValue
		}
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

}
