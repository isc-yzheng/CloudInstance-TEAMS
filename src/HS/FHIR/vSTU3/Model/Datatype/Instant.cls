/// An instant in time - known at least to the second<br>
/// Note: This is intended for precisely observed times, typically system logs etc., and not human-reported times - for them, see date and dateTime below. Time zone is always required<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Datatype.Instant Extends HS.FHIR.vSTU3.Model.Base.Element [ CompileAfter = HS.FHIR.vSTU3.Model.Datatype.InstantPrimitive, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "instant";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

Property value As HS.FHIR.vSTU3.Model.Datatype.InstantPrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

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
/// This method is overridden here to apply extra validation.  Instant must be
/// YYYY-MM-DDTHH:MM:SS plus time zone.
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
			Do ##class(HS.FHIR.Utils.DateConversion).RepairInstant(.pValue)
			If pValue'=tOldValue Set ^CacheTemp.RepairFHIRDates($i(^CacheTemp.RepairFHIRDates))=tOldValue_"\"_pValue
		}
		Quit $$$OK
	}
	#; YYYY-MM-DDTHH:MM:SS must have a time zone.
	If (pValue?4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N.E)&&((pValue?.E1"+"2N1":"2N)||(pValue?.E1"-"2N1":"2N)||($Extract(pValue,*)="Z")) {
		Set tDH = $ZDateTimeH(pValue,3,5,,,,,,,"error")
		Set tSC = '(tDH="error")
		If (tSC)&&(($Extract(pValue,*)'="Z")) {
			#; $ZDateTimeH does not appear to validate the time zone.
			Set tTZ1 = $Extract(pValue,*-4,*-3)
			Set tTZ2 = $Extract(pValue,*-1,*)
			Set tSC = '((+tTZ1>14)||(tTZ2>59))
		}
	} Else {
		Set tSC = 0
	}
	If tSC=0 Set tSC = $$$ERROR($$$GeneralError,"Invalid format for Instant value")
	
	Quit tSC
}

}
