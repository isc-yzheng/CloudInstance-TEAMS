/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Datatype.Time when working with FHIR DSTU2.
Class HS.FHIR.Model.Datatype.Time Extends HS.FHIR.Model.Base.Element [ CompileAfter = HS.FHIR.Model.Datatype.TimePrimitive, Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "time";

///  
Parameter XMLSEQUENCE = 1;

///  
Property value As HS.FHIR.Model.Datatype.TimePrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

///  
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

///  
ClassMethod valueIsValid(pValue As %String) As %Status
{
	If pValue="" Quit $$$OK
	#; If %repairfhirdates=1 and the value is found to be invalid,
	#; then just log the existing value and a proposed corrected value,
	#; and do not return an error.
	If $Get(%repairfhirdates)=1 {
		Set %repairfhirdates = 0
		Set tSC = ..valueIsValid(pValue)
		Set %repairfhirdates = 1
		If $$$ISERR(tSC) {
			Set tOldValue = pValue
			Do ##class(HS.FHIR.Utils.DateConversion).RepairTime(.pValue)
			If pValue'=tOldValue Set ^CacheTemp.RepairFHIRDates($i(^CacheTemp.RepairFHIRDates))=tOldValue_"\"_pValue
		}
		Quit $$$OK
	}
	Set tSC = (((pValue?2N1":"2N)||(pValue?2N1":"2N1":"2N)||(pValue?2N1":"2N1":"2N1"."1N.N))&&($ZTimeH(pValue,1,"error")'="error"))
	If tSC=0 Set tSC = $$$ERROR($$$GeneralError,"Invalid format for Time value")
	Quit tSC
}

}
