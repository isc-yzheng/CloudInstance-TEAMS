/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Datatype.Decimal when working with FHIR DSTU2.
Class HS.FHIR.Model.Datatype.Decimal Extends HS.FHIR.Model.Base.Element [ CompileAfter = HS.FHIR.Model.Datatype.DecimalPrimitive, Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "decimal";

///  
Parameter XMLSEQUENCE = 1;

///  
Property value As HS.FHIR.Model.Datatype.DecimalPrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

///  
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

}
