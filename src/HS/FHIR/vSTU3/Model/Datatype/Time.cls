/// A time during the day, with no date specified<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Datatype.Time Extends HS.FHIR.vSTU3.Model.Base.Element [ CompileAfter = HS.FHIR.vSTU3.Model.Datatype.TimePrimitive, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "time";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

Property value As HS.FHIR.vSTU3.Model.Datatype.TimePrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

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

/// valueIsValid is called by %ValidateObject() to validate the value property.
/// This method is overridden here to apply extra validation.  Time value must
/// be HH:MM:SS.  No time zone.
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
