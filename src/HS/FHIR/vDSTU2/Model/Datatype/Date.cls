Class HS.FHIR.vDSTU2.Model.Datatype.Date Extends HS.FHIR.vDSTU2.Model.Base.Element [ CompileAfter = HS.FHIR.vDSTU2.Model.Datatype.DatePrimitive, ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "date";

Parameter XMLSEQUENCE = 1;

Property value As HS.FHIR.vDSTU2.Model.Datatype.DatePrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

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

/// valueIsValid is called by %ValidateObject() to validate the value property.
/// This method is overridden here to apply extra validation.  Date must be
/// YYYY, YYYY-MM or YYYY-MM-DD.  No time zone.
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
			Do ##class(HS.FHIR.Utils.DateConversion).RepairDate(.pValue)
			If pValue'=tOldValue Set ^CacheTemp.RepairFHIRDates($i(^CacheTemp.RepairFHIRDates))=tOldValue_"\"_pValue
		}
		Quit $$$OK
	}
	If (pValue?4N1"-"2N1"-"2N)&&($ZDateH(pValue,3,,,,,,,"error")'="error") {
		Set tSC = $$$OK
	} ElseIf pValue?4N1"-"2N {
		Set tSC = '(($Extract(pValue)="0")||(+$Extract(pValue,6,7)<1)||(+$Extract(pValue,6,7)>12))
	} ElseIf pValue?4N {
		Set tSC = '($Extract(pValue)="0")
	} Else {
		Set tSC = 0
	}
	If tSC=0 Set tSC = $$$ERROR($$$GeneralError,"Invalid format for Date value")
	
	Quit tSC
}

}
