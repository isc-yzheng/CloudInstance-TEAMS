Class HS.FHIR.DTL.Utils Extends Ens.Util.FunctionSet
{

/// GetCodeForURI looks up the table HS_Data.OIDMap to get
/// the IdentityCode for the specified URI.
ClassMethod GetCodeForURI(URI As %String) As %String
{
	q ##class(HS.Data.OIDMap).GetCodeForURI(URI)
}

/// GetURLForCode looks up the table HS_Data.OIDMap to get
/// the URL for the specified IdentityCode.
ClassMethod GetURLForCode(pIdentityCode As %String) As %String
{
	q ##class(HS.Data.OIDMap).GetURLForCode(pIdentityCode)
}

/// GetURIForCode looks up the table HS_Data.OIDMap to get the
/// URI (first found of URL or OID) for the specified IdentityCode.
ClassMethod GetURIForCode(pIdentityCode As %String) As %String
{
	q ##class(HS.Data.OIDMap).GetURIForCode(pIdentityCode)
}

/// GetResourceId returns the FHIR resource id
/// that was assigned to the specified SDA object.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetResourceId(pSDAObj As HS.SDA3.Patient) As %String
{
	s tReturn = ""
	f i = 1:1:pSDAObj.CustomPairs.Count() {
		i pSDAObj.CustomPairs.GetAt(i).Name="DTLInput_ResourceId" {
			s tReturn = pSDAObj.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetPatientResourceId returns the FHIR Patient resource id
/// that was assigned to the specified SDA object.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetPatientResourceId(pSDAObj As HS.SDA3.Patient) As %String
{
	s tReturn = ""
	f i = 1:1:pSDAObj.CustomPairs.Count() {
		i pSDAObj.CustomPairs.GetAt(i).Name="DTLInput_PatientResourceId" {
			s tReturn = pSDAObj.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetEncounterResourceId returns the FHIR Encounter resource id
/// that was assigned to the specified SDA object.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetEncounterResourceId(pSDAObj) As %String
{
	s tReturn = ""
	f i = 1:1:pSDAObj.CustomPairs.Count() {
		i pSDAObj.CustomPairs.GetAt(i).Name="DTLInput_EncounterResourceId" {
			s tReturn = pSDAObj.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetMedicationOrderResourceId returns the FHIR MedicationOrder
/// resource id that was assigned to the specified SDA object.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetMedicationOrderResourceId(pSDAObj) As %String
{
	s tReturn = ""
	f i = 1:1:pSDAObj.CustomPairs.Count() {
		i pSDAObj.CustomPairs.GetAt(i).Name="DTLInput_MedicationOrderResourceId" {
			s tReturn = pSDAObj.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetMedicationAdministrationPosition returns the relative position
/// of the specified SDA MedicationAdministration object in the list
/// Administrations from a given SDA Medication.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetMedicationAdministrationPosition(pSDAObj As HS.SDA3.Administration) As %String
{
	s tReturn = ""
	f i = 1:1:pSDAObj.CustomPairs.Count() {
		i pSDAObj.CustomPairs.GetAt(i).Name="DTLInput_MedicationAdministrationPosition" {
			s tReturn = pSDAObj.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetResultItemId returns the FHIR Observation resource id that
/// should be used for the specified SDA ResultItem.  This method
/// expects the entire HS.SDA3.Result object to be passed in
/// because DTL does not allow something like
/// ..GetResultItemId(source.Result.ResultItems.(k2)).
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetResultItemId(pSDAObj As HS.SDA3.Result, pIndex As %Integer) As %String
{
	s tReturn = ""
	s tResultItem = pSDAObj.ResultItems.GetAt(pIndex)
	f i = 1:1:tResultItem.CustomPairs.Count() {
		i tResultItem.CustomPairs.GetAt(i).Name="DTLInput_ResultItemId" {
			s tReturn = tResultItem.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetResultId returns the FHIR Observation resource id that
/// should be used for the specified SDA Result.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetResultId(pSDAObj As HS.SDA3.Result) As %String
{
	s tReturn = ""
	f i = 1:1:pSDAObj.CustomPairs.Count() {
		i pSDAObj.CustomPairs.GetAt(i).Name="DTLInput_ResultId" {
			s tReturn = pSDAObj.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetDiagnosticOrderId returns the FHIR DiagnosticOrder
/// resource id that should be used for the specified SDA
/// LabOrder, RadOrder, or OtherOrder.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetDiagnosticOrderId(pSDAObj) As %String
{
	s tReturn = ""
	f i = 1:1:pSDAObj.CustomPairs.Count() {
		i pSDAObj.CustomPairs.GetAt(i).Name="DTLInput_DiagnosticOrderId" {
			s tReturn = pSDAObj.CustomPairs.GetAt(i).Value q
		}
	}
	q tReturn
}

/// GetDiagnosticOrderId returns the FHIR DiagnosticOrder
/// resource id that should be used for the specified SDA
/// LabOrder, RadOrder, or OtherOrder.
/// DEPRECATED: This method is deprecated as of HealthShare Core 15.03. FHIR DTLs should use the aux array instead.
ClassMethod GetSDAEncounterNumber(pFHIRObj, pResourceId) As %String
{
	s tReturn = ""
	f i = 1:1:pFHIRObj.extension.Count() {
		i pFHIRObj.extension.GetAt(i).url="http://www.intersystems.com/fhir/tempencounternumber" {
			s tStr = pFHIRObj.extension.GetAt(i).valueString.value
			i $p(tStr,"\",1)=pResourceId s tReturn = $p(tStr,"\",2) q
		}
	}
	q tReturn
}

/// CTIsDefined uses the IsDefined() method and other means
/// to check for the presence of data for the specified SDA
/// CodeTableTranslated property.  IsDefined() allows an
/// initial check for data without swizzling (instantiating)
/// a property object that hasn't yet been swizzled.
ClassMethod CTIsDefined(pObject, pPropertyName As %String) As %Boolean
{
	i '$isobject($g(pObject)) q 0
	i 'pObject.IsDefined(pPropertyName) q 0
	i $property(pObject, pPropertyName).Code'="" q 1
	i $property(pObject, pPropertyName).Description'="" q 1
	i $property(pObject, pPropertyName).OriginalText'="" q 1
	q 0
}

/// CPIsDefined uses the IsDefined() method and other means
/// to check for the presence of data for the specified SDA
/// CareProvider property.  IsDefined() allows an initial
/// check for data without swizzling (instantiating) a
/// property object that hasn't yet been swizzled.
ClassMethod CPIsDefined(pObject, pPropertyName As %String) As %Boolean
{
	i '$isobject($g(pObject)) q 0
	i 'pObject.IsDefined(pPropertyName) q 0
	i $property(pObject, pPropertyName).Code'="" q 1
	i $property(pObject, pPropertyName).Description'="" q 1
	i $property(pObject, pPropertyName).IsDefined("Name") q 1
	i $property(pObject, pPropertyName).IsDefined("Address") q 1
	i $property(pObject, pPropertyName).IsDefined("ContactInfo") q 1
	i $property(pObject, pPropertyName).IsDefined("AtOrganization") q 1
	q 0
}

/// HCFIsDefined uses the IsDefined() method and other means
/// to check for the presence of data for the specified SDA
/// HealthCareFacility property.  IsDefined() allows an initial
/// check for data without swizzling (instantiating) a
/// property object that hasn't yet been swizzled.
ClassMethod HCFIsDefined(pObject, pPropertyName As %String) As %Boolean
{
	i '$isobject($g(pObject)) q 0
	i 'pObject.IsDefined(pPropertyName) q 0
	i $property(pObject, pPropertyName).Code'="" q 1
	i $property(pObject, pPropertyName).Description'="" q 1
	i ..OrgIsDefined($property(pObject, "Organization")) q 1
	q 0
}

/// OrgIsDefined uses the IsDefined() method and other means
/// to check for the presence of data for the specified SDA
/// Organization property.  IsDefined() allows an initial
/// check for data without swizzling (instantiating) a
/// property object that hasn't yet been swizzled.
ClassMethod OrgIsDefined(pObject, pPropertyName As %String) As %Boolean
{
	i '$isobject($g(pObject)) q 0
	i 'pObject.IsDefined(pPropertyName) q 0
	i $property(pObject, pPropertyName).Code'="" q 1
	i $property(pObject, pPropertyName).Description'="" q 1
	q 0
}

/// RDIsDefined uses the IsDefined() method and other means
/// to check for the presence of data for the specified SDA
/// ReferralDoctor property.  IsDefined() allows an initial
/// check for data without swizzling (instantiating) a
/// property object that hasn't yet been swizzled.
ClassMethod RDIsDefined(pObject, pPropertyName As %String) As %Boolean
{
	i '$isobject($g(pObject)) q 0
	i 'pObject.IsDefined(pPropertyName) q 0
	i $property(pObject, pPropertyName).Code'="" q 1
	i $property(pObject, pPropertyName).Description'="" q 1
	i $property(pObject, pPropertyName).IsDefined("Name") q 1
	i $property(pObject, pPropertyName).IsDefined("Address") q 1
	i $property(pObject, pPropertyName).IsDefined("ContactInfo") q 1
	q 0
}

/// GetFHIRCodeOrDesc is used to help with transforming a
/// FHIR CodeableConcept type property into an SDA String
/// type property.<br>
/// For a given FHIR CodeableConcept object, return the
/// first found of:<br>
/// - First coding code<br>
/// - First coding display<br>
/// - text<br>
/// - The specified default pDefault.
ClassMethod GetFHIRCodeOrDesc(pCodeableConcept As HS.FHIR.vDSTU2.Model.Base.CodeableConcept, pDefault As %String = "") As %String
{
	i '$isobject($g(pCodeableConcept)) q pDefault
	i pCodeableConcept.%IsA("HS.FHIR.vDSTU2.Model.Base.CodeableConcept")=0 q pDefault
	i pCodeableConcept.coding.Count()>0 {
		i pCodeableConcept.coding.GetAt(1).code.value'="" q pCodeableConcept.coding.GetAt(1).code.value
		i pCodeableConcept.coding.GetAt(1).display.value'="" q pCodeableConcept.coding.GetAt(1).display.value
	}
	i pCodeableConcept.text.value'="" q pCodeableConcept.text.value
	q pDefault
}

/// GetFHIRDescOrCode is used to help with transforming a
/// FHIR CodeableConcept type property into an SDA String
/// type property.<br>
/// For a given FHIR CodeableConcept object, return the
/// first found of:<br>
/// - First coding display<br>
/// - text<br>
/// - First coding code<br>
/// - The specified default pDefault.
ClassMethod GetFHIRDescOrCode(pCodeableConcept As HS.FHIR.vDSTU2.Model.Base.CodeableConcept, pDefault As %String = "") As %String
{
	i '$isobject($g(pCodeableConcept)) q pDefault
	i pCodeableConcept.%IsA("HS.FHIR.vDSTU2.Model.Base.CodeableConcept")=0 q pDefault
	i pCodeableConcept.coding.Count()>0 {
		i pCodeableConcept.coding.GetAt(1).display.value'="" q pCodeableConcept.coding.GetAt(1).display.value
	}
	i pCodeableConcept.text.value'="" q pCodeableConcept.text.value
	i pCodeableConcept.coding.Count()>0 {
		i pCodeableConcept.coding.GetAt(1).code.value'="" q pCodeableConcept.coding.GetAt(1).code.value
	}
	q pDefault
}

/// GetSDACodeOrDesc is used to help with transforming an
/// SDA CodeTableTranslated property into a FHIR string
/// or code type property.<br>
/// For a given SDA CodeTableTranslated object, return the
/// first found of:<br>
/// - SDA Code<br>
/// - SDA Description<br>
/// - SDA OriginalText<br>
/// - The specified default pDefault.
ClassMethod GetSDACodeOrDesc(pCodeTableTranslated As HS.SDA3.CodeTableTranslated, pDefault As %String = "") As %String
{
	i '$isobject($g(pCodeTableTranslated)) q pDefault
	i 'pCodeTableTranslated.%IsA("HS.SDA3.CodeTableDetail") q pDefault
	i pCodeTableTranslated.Code'="" q pCodeTableTranslated.Code
	i pCodeTableTranslated.Description'="" q pCodeTableTranslated.Description
	i 'pCodeTableTranslated.%IsA("HS.SDA3.CodeTableTranslated") q pDefault
	i pCodeTableTranslated.OriginalText'="" q pCodeTableTranslated.OriginalText
	q pDefault
}

/// GetSDADescOrCode is used to help with transforming an
/// SDA CodeTableTranslated property into a FHIR string
/// or code type property.<br>
/// For a given SDA CodeTableTranslated object, return the
/// first found of:<br>
/// - SDA Description<br>
/// - SDA OriginalText<br>
/// - SDA Code<br>
/// - The specified default pDefault.
ClassMethod GetSDADescOrCode(pCodeTableTranslated As HS.SDA3.CodeTableTranslated, pDefault As %String = "") As %String
{
	i '$isobject($g(pCodeTableTranslated)) q pDefault
	i 'pCodeTableTranslated.%IsA("HS.SDA3.CodeTableDetail") q pDefault
	i pCodeTableTranslated.Description'="" q pCodeTableTranslated.Description
	i pCodeTableTranslated.%IsA("HS.SDA3.CodeTableTranslated") {
		i pCodeTableTranslated.OriginalText'="" q pCodeTableTranslated.OriginalText
	}
	i pCodeTableTranslated.Code'="" q pCodeTableTranslated.Code
	q pDefault
}

/// NormalizeTimeStamp takes a FHIR date, dateTime or instant
/// as input and returns an SDA TimeStamp in the local time.
/// If the input data is invalid then blank string is returned.
ClassMethod NormalizeTimeStamp(pFHIRTime As %String, pPrecision As %String = "TIME") As %String
{
	i pFHIRTime="" q pFHIRTime
	
	i (pPrecision="PARTIALDATE")&&((pFHIRTime?4n)||(pFHIRTime?4n1"-"2n)) q pFHIRTime
	
	i (pPrecision="DATE")&&(pFHIRTime?4n1"-"2n1"-"2n)&&($zdateh(pFHIRTime,3,,,,,,,"error")'="error") q pFHIRTime
	
	i (pFHIRTime?4n)||(pFHIRTime?4n1"-"2n) q ""
	
	// At this point pFHIRTime should be YYYY-MM-DDTHH:MM:SS
	// plus time zone.  Validate and get $H representation.
	s tFHIRTimeDH = $zdatetimeh(pFHIRTime,3,5,,,,,,,"error")
	
	i tFHIRTimeDH="error" q ""
	
	i (pFHIRTime?4n1"-"2n1"-"2n) q pFHIRTime_" 00:00:00"
	
	// Local time zone offset at the time specified by pFHIRTime.
	s tLocalTZ = $e($zdatetime(tFHIRTimeDH,3,5),*-5,*)
	i $e(tLocalTZ,2,6)="00:00" s tLocalTZ = "Z"
	
	// Time zone offset specified in pFHIRTime.
	i $e(pFHIRTime,*)="Z" s pFHIRTime = $e(pFHIRTime,1,*-1)_"-00:00"
	s tFHIRTimeTZ = $e(pFHIRTime,*-5,*)
	i $Extract(tFHIRTimeTZ,2,6)="00:00" s tFHIRTimeTZ = "Z"
	
	// If they match then return pFHIRTime without the time zone.
	i tLocalTZ=tFHIRTimeTZ {
		s pFHIRTime = $e(pFHIRTime,1,*-6)
		s pFHIRTime = $p(pFHIRTime,"T",1)_" "_$p(pFHIRTime,"T",2)
		q pFHIRTime
	}
	
	// Get the difference in seconds between the local time zone and that indicated by pFHIRTime.
	s tLocalTZSecs = $s(tLocalTZ="Z":0,1:$e(tLocalTZ)_(($e(tLocalTZ,2,3)*3600)+($e(tLocalTZ,5,6)*60)))
	s tFHIRTimeTZSecs = $s(tFHIRTimeTZ="Z":0,1:$e(tFHIRTimeTZ)_(($e(tFHIRTimeTZ,2,3)*3600)+($e(tFHIRTimeTZ,5,6)*60)))
	s tDiffSecs = tLocalTZSecs - tFHIRTimeTZSecs
	
	s tFHIRTimeDHSecs = $Piece(tFHIRTimeDH, ",", 2)
	
	// Adjust the $Horolog version of pFHIRTime.
	i tDiffSecs<0 {
		s tDiffSecs = $e(tDiffSecs,2,*)
		i tDiffSecs>tFHIRTimeDHSecs {
			s tFHIRTimeDHSecs = (86400 - (tDiffSecs-tFHIRTimeDHSecs))
			s tFHIRTimeDH = ($p(tFHIRTimeDH,",",1)-1)_","_tFHIRTimeDHSecs
		} else {
			s tFHIRTimeDHSecs = (tFHIRTimeDHSecs - tDiffSecs)
			s $p(tFHIRTimeDH, ",", 2) = tFHIRTimeDHSecs
		}
	} else {
		i tDiffSecs>=(86400-tFHIRTimeDHSecs) {
			s tFHIRTimeDHSecs = tDiffSecs - (86400 - tFHIRTimeDHSecs)
			s tFHIRTimeDH = ($p(tFHIRTimeDH,",",1)+1)_","_tFHIRTimeDHSecs
		} else {
			s tFHIRTimeDHSecs = (tFHIRTimeDHSecs + tDiffSecs)
			s $p(tFHIRTimeDH, ",", 2) = tFHIRTimeDHSecs
		}
	}
	
	// Return the adjusted $Horolog converted to YYYY-MM-DDTHH:MM:SS plus time zone.
	q $zdatetime(tFHIRTimeDH,3)
}

/// FHIRDate takes an SDA time stamp value and returns the
/// FHIR date format for that value.  If the SDA time stamp
/// is invalid then blank value is returned.  The time
/// portion of the SDA time stamp is not used.
ClassMethod FHIRDate(pSDATime As %String) As %String
{
	i pSDATime="" q pSDATime
	
	// Return YYYY and YYYY-MM as is.
	i (pSDATime?4n)||(pSDATime?4n1"-"2n) q pSDATime
	
	i (pSDATime?4n1"-"2n1"-"2n.e)&&($zdateh(pSDATime,3,,,,,,,"error")'="error") q $Extract(pSDATime,1,10)
	
	q ""
}

/// FHIRDateTime takes an SDA time stamp value and returns the
/// FHIR dateTime format of that value.  If the SDA time stamp
/// is invalid then blank value is returned.  SDA time stamp
/// will not have a time zone on it and the value is assumed
/// to be in the local time zone.  If the value comes in
/// suffixed with "Z" then that character is stripped.
ClassMethod FHIRDateTime(pSDATime As %String) As %String
{
	i pSDATime="" q pSDATime
	
	// Strip Z, as it has incorrect meaning in SDA, and we are asssuming local time.
	i $e(pSDATime,*)="Z" s pSDATime = $e(pSDATime,1,*-1)
	
	// Return YYYY and YYYY-MM as is.
	i (pSDATime?4n)||(pSDATime?4n1"-"2n) q pSDATime
	
	// Validate YYYY-MM-DD before returning a value.
	i (pSDATime?4n1"-"2n1"-"2n) {
		i $zdateh(pSDATime,3,,,,,,,"error")="error" {
			q ""
		} else {
			q pSDATime
		}
	}
	
	// Remaining valid formats are YYY-MM-DD HH:MM:SS and YYYY-MM-DDTHH:MM:SS.
	// Validate before adding local time zone and returning.
	i ((pSDATime?4n1"-"2n1"-"2n1" "2n1":"2n1":"2n.1".".n)||(pSDATime?4n1"-"2n1"-"2n1"T"2n1":"2n1":"2n.1".".n)) {
		s tPrecision = 0
		i pSDATime?.e1"."1n.n s tPrecision = $l($p(pSDATime,".",2))
		s tDH = $zdatetimeh(pSDATime,3,5,,,,,,,"error")
		i tDH="error" q ""
		q $zdatetime(tDH,3,5,tPrecision)
	}
	
	q ""
}

/// FHIRInstant takes an SDA time stamp value and returns the
/// FHIR instant format of that value.  If the SDA time stamp
/// is invalid then blank value is returned.  SDA time stamp
/// will not have a time zone on it and the value is assumed
/// to be in the local time zone.  If the value comes in
/// suffixed with "Z" then that character is stripped.
ClassMethod FHIRInstant(pSDATime As %String) As %String
{
	i pSDATime="" q pSDATime
	
	// Strip Z, as it has incorrect meaning in SDA, and we are asssuming local time.
	i $e(pSDATime,*)="Z" s pSDATime = $e(pSDATime,1,*-1)
	
	// SDA time stamp must be YYY-MM-DD HH:MM:SS or YYYY-MM-DDTHH:MM:SS.
	// Validate before adding local time zone and returning.
	i ((pSDATime?4n1"-"2n1"-"2n1" "2n1":"2n1":"2n.1".".n)||(pSDATime?4n1"-"2n1"-"2n1"T"2n1":"2n1":"2n.1".".n)) {
		s tPrecision = 0
		i pSDATime?.e1"."1n.n s tPrecision = $l($p(pSDATime,".",2))
		s tDH = $zdatetimeh(pSDATime,3,5,,,,,,,"error")
		i tDH="error" q ""
		q $zdatetime(tDH,3,5,tPrecision)
	}
	
	q ""
}

/// LookupFHIR checks to see if there is a customized version
/// of the specified data lookup table.  A customized version
/// is indicated by the presence a table with a name of the
/// specified name prefixed by "Local.".  If a customized
/// version is found then it is used to do the lookup.
/// Otherwise the specified table is used to do the lookup.
ClassMethod LookupFHIR(table As %String = "", value As %String = "", default As %String = "", defaultOnEmptyInput As %Integer = 0) As %String
{
	i $d(^Ens.LookupTable("Local."_table)) s table = "Local."_table
	q ..Lookup(table, value, default, defaultOnEmptyInput)
}

/// FromSDAReferenceRange interprets the SDA ResultNormalRange string into
/// discrete "low" and "high" values and populates and returns a FHIR
/// ReferenceRange object.  This method takes into account negative numbers
/// on both sides of the range, and takes into account the possibility of
/// dash, colon, or slash for delimiter.
ClassMethod FromSDAReferenceRange(pNormalRange As %String, pUnit As %String) As HS.FHIR.vDSTU2.Model.Resource.Observation.ReferenceRange
{
	s tRefRange = ##class(HS.FHIR.vDSTU2.Model.Resource.Observation.ReferenceRange).%New()
	
	s tColons = $l(pNormalRange,":")-1
	s tSlashes = $l(pNormalRange,"/")-1
	s tDashes = $l(pNormalRange,"-")-1
	
	s tSubString = $e(pNormalRange,2,*)
	
	#; tLtGtNumeric:
	#; 0 = both sides of delimiter are numeric
	#; 1 = starts with >=
	#; 2 = starts with =>
	#; 3 = starts with <=
	#; 4 = starts with =<
	#; 5 = values are not numeric
	
	i (tColons>1)||(tSlashes>1) {
		s tLtGtNumeric = 5
	} elseif tColons=1 {
		s tLeft = $p(pNormalRange,":",1)
		s tRight = $p(pNormalRange,":",2)
		i (..IsNumeric(tLeft))&&(..IsNumeric(tRight)) {
			s tLtGtNumeric = 0
		} else {
			s tLtGtNumeric = 5
		}
	} elseif tSlashes=1 {
		s tLeft = $p(pNormalRange,"/",1)
		s tRight = $p(pNormalRange,"/",2)
		i (..IsNumeric(tLeft))&&(..IsNumeric(tRight)) {
			s tLtGtNumeric = 0
		} else {
			s tLtGtNumeric = 5
		}
	} elseif (pNormalRange?1">="1e.e)&&(..IsNumeric($e(pNormalRange,3,*))) {
		s tLtGtNumeric = 1
	} elseif (pNormalRange?1"=>"1e.e)&&(..IsNumeric($e(pNormalRange,3,*))) {
		s tLtGtNumeric = 2
	} elseif (pNormalRange?1"<="1e.e)&&(..IsNumeric($e(pNormalRange,3,*))) {
		s tLtGtNumeric = 3
	} elseif (pNormalRange?1"=<"1e.e)&&(..IsNumeric($e(pNormalRange,3,*))) {
		s tLtGtNumeric = 4
	} elseif tDashes=1 {
		s tLeft = $p(pNormalRange,"-",1)
		s tRight = $p(pNormalRange,"-",2)
		i (..IsNumeric(tLeft))&&(..IsNumeric(tRight)) {
			s tLtGtNumeric = 0
		} else {
			s tLtGtNumeric = 5
		}
	} elseif (tDashes>1)&&($e(pNormalRange)'="-") {
		s tLtGtNumeric = 5
	} elseif tDashes=2 {
		s tRight = $p(pNormalRange,"-",3)
		i ..IsNumeric(tRight) {
			set tLtGtNumeric = 0
		} else {
			set tLtGtNumeric = 5
		}
	} elseif tDashes=3 {
		s tLeft = $p(pNormalRange,"-",2)
		s tRight = $p(pNormalRange,"-",4)
		i (..IsNumeric(tLeft))&&(..IsNumeric(tRight)) {
			s tLtGtNumeric = 0
		} else {
			s tLtGtNumeric = 5
		}
	} elseif ..IsNumeric(pNormalRange) {
		s tLtGtNumeric = 5
	} else {
		s tLtGtNumeric = 0
	}
	
	s tLow = ""
	i (tLtGtNumeric=1)||(tLtGtNumeric=2) {
		s tLow = $e(pNormalRange,3,*)
	} elseif $e(pNormalRange)="-" {
		i (tSubString["-")&&(tSubString'[":")&&(tSubString'["/") {
			s tLow = "-"_$p(pNormalRange,"-",2)
		} elseif tSubString[":" {
			s tLow = $p(pNormalRange,":",1)
		} elseif tSubString["/" {
			s tLow = $p(pNormalRange,"/",1)
		}
	} elseif pNormalRange["-" {
		s tLow = $p(pNormalRange,"-",1)
	} elseif pNormalRange[":" {
		s tLow = $p(pNormalRange,":",1)
	} elseif pNormalRange["/" {
		s tLow = $p(pNormalRange,"/",1)
	} else {
		s tLow = pNormalRange
	}
	
	s tHigh = ""
	i (tLtGtNumeric=3)||(tLtGtNumeric=4) {
		s tHigh = $e(pNormalRange,3,*)
	} elseif $e(pNormalRange)="-" {
		i (tSubString["-")&&(tSubString'[":")&&(tSubString'["/") {
			i tDashes=2 {
				s tHigh = $p(pNormalRange,"-",3)
			} elseif tDashes=3 {
				s tHigh = "-"_$p(pNormalRange,"-",4)
			}
		} elseif tSubString[":" {
			s tHigh = $p(pNormalRange,":",2)
		} elseif tSubString["/" {
			s tHigh = $p(pNormalRange,"/",2)
		}
	} elseif pNormalRange["-" {
		s tHigh = $p(pNormalRange,"-",2)
	} elseif pNormalRange[":" {
		s tHigh = $p(pNormalRange,":",2)
	} elseif pNormalRange["/" {
		s tHigh = $p(pNormalRange,"/",2)
	} else {
		s tHigh = pNormalRange
	}
	
	d tRefRange.SetText(pNormalRange)
	i ..IsNumeric(tLow) {
		s tLowObj = ##class(HS.FHIR.vDSTU2.Model.Base.SimpleQuantity).%New()
		d tLowObj.SetValue(tLow)
		d tLowObj.SetUnit(pUnit)
		s tRefRange.low = tLowObj
	}
	i ..IsNumeric(tHigh) {
		s tHighObj = ##class(HS.FHIR.vDSTU2.Model.Base.SimpleQuantity).%New()
		d tHighObj.SetValue(tHigh)
		d tHighObj.SetUnit(pUnit)
		s tRefRange.high = tHighObj
	}
	
	d tRefRange.SetText(pNormalRange)
	
	Quit tRefRange
}

/// IsNumeric checks pText to determine whether it is numeric
/// or not.  "numeric" means it is an integer or decimal
/// number.  If the pStripLtGtEq parameter is passed in with
/// a value of 1, then any leading less than, greater than
/// and/or equals sign is stripped from pText that is being
/// evaluated as numeric.
ClassMethod IsNumeric(pText, pStripLtGtEq) As %Boolean
{
	i pText="" q 0
	i +$g(pStripLtGtEq) s pText = ..StripLtGtEq(pText)
	i pText="" q 0
	i pText?.1"-".n1n1"."1n.n q 1
	i pText?.1"-"1"."1n.n q 1
	i pText?.1"-"1n.n.1"." q 1
	q 0
}

/// StripLtGtEq strips leading less than, greater than
/// and/or equals sign from pText.
ClassMethod StripLtGtEq(pText) As %String
{
	i pText="" q ""
	i '((pText[">")||(pText["<")||(pText["=")) q pText
	s tX = $e(pText,1,2)
	i (tX=">=")||(tX="=>")||(tX="<=")||(tX="=<") q $e(pText,3,*)
	s tX = $e(pText)
	i (tX=">")||(tX="<") q $e(pText,2,*)
	q pText
}

ClassMethod CreateUUID() As %String
{
	q $zcvt($system.Util.CreateGUID(),"l")
}

/// GetFrequency returns a delimited string containing the
/// following possible FHIR frequency-related values:
/// Piece 1 : code code value
/// Piece 2 : code display value
/// Piece 3 : code system (if standard code, then the coding system or value set URL)
/// Piece 4 : frequency value
/// Piece 5 : period value
/// Piece 6 : periodUnits value
/// Piece 7 : when value (a "when code", e.g., "AC" for "before food or meals")
ClassMethod GetFrequency(pCode, pDesc) As %String
{
	s tReturn = ""
	
	i $g(pCode)="" s pCode = $g(pDesc)
	i pCode="" q tReturn
	s tCodeLower = $zcvt(pCode,"L")
	s tCodeP1 = $p(tCodeLower," ",1)
	s tCodeP2 = $p(tCodeLower," ",2)
	s tCodeP3 = $p(tCodeLower," ",3)
	s tCodeNoSpaces = $tr(tCodeLower," ")
	
	#; tCodeCodes is the union of the timing codes and the event ("when") codes.
	d ..GetTimingCodes(.tCodeCodes)
	d ..GetWhenCodes(.tCodeCodes)
	#; tWhenCodes is just the event codes.
	d ..GetWhenCodes(.tWhenCodes)
	
	#; If the code exactly matches a common timing code or event code then use
	#; the information that was determined by the GetTimingCodes method.
	i $d(tCodeCodes(tCodeLower)) {
		s $p(tReturn,"|",1) = $zcvt(tCodeLower,"U")
		s $p(tReturn,"|",2) = tCodeCodes(tCodeLower,"display")
		s $p(tReturn,"|",3) = ..GetTimingCodeSystem()
		s $p(tReturn,"|",4) = $g(tCodeCodes(tCodeLower,"frequency"))
		s $p(tReturn,"|",5) = $g(tCodeCodes(tCodeLower,"period"))
		s $p(tReturn,"|",6) = $g(tCodeCodes(tCodeLower,"periodUnit"))
		s $p(tReturn,"|",7) = $zcvt($g(tCodeCodes(tCodeLower,"when")),"U")
		q tReturn
	}
	
	d ..GetUnitCodesAndDescs(.tUnitCodes, .tUnitDescs)
	
	#; every n seconds, minutes, hours, days, or weeks ('q' plus number plus unit)
	i tCodeNoSpaces?1"q"1n.n1l.l {
		s tFrequencyPeriod = ""
		f i = 2:1 {
			i $e(tCodeNoSpaces,i)'?1n q
			s tFrequencyPeriod = tFrequencyPeriod_$e(tCodeNoSpaces,i)
		}
		s tFrequency = 1
		s tFrequencyPeriodUnit = $e(tCodeNoSpaces,i,*)
		#; periodUnit and durationUnit have Required value set, so leave code blank if not found in tUnitCodes.
		s tFrequencyPeriodUnitCode = $g(tUnitCodes(tFrequencyPeriodUnit))
		s tFrequencyPeriodUnitDesc = $g(tUnitDescs(tFrequencyPeriodUnit))
		i (+tFrequencyPeriod'=1)&&(tFrequencyPeriodUnitDesc'="") s tFrequencyPeriodUnitDesc = tFrequencyPeriodUnitDesc_"s"
		s $p(tReturn,"|",1) = "Q"_tFrequencyPeriod_$zcvt(tFrequencyPeriodUnitCode,"U")
		s $p(tReturn,"|",2) = "every "_tFrequencyPeriod_" "_$s(tFrequencyPeriodUnitDesc'="":tFrequencyPeriodUnitDesc,1:tFrequencyPeriodUnit)
		s $p(tReturn,"|",3) = ..GetTimingCodeSystem()
		s $p(tReturn,"|",4) = tFrequency
		s $p(tReturn,"|",5) = tFrequencyPeriod
		s $p(tReturn,"|",6) = tFrequencyPeriodUnitCode
		q tReturn
	}
	#; example: 4xD (four times a day)
	i tCodeNoSpaces?1n.n1"x"1l.l {
		s tFrequency = +tCodeNoSpaces
		s tFrequencyPeriod = 1
		s tFrequencyPeriodUnit = $p(tCodeNoSpaces,"x",2)
		#; periodUnit and durationUnit have Required value set, so leave code blank if not found in tUnitCodes.
		s tUnitCode = $g(tUnitCodes(tFrequencyPeriodUnit))
		s $p(tReturn,"|",4) = tFrequency
		s $p(tReturn,"|",5) = tFrequencyPeriod
		s $p(tReturn,"|",6) = tUnitCode
		q tReturn
	}
	#; examples: 2 x W (two times a week), 4 a day, 1 per hour
	i (tCodeP1?1n.n)&&("|a|an|per|x|"[("|"_tCodeP2_"|"))&&(tCodeP3'="") {
		s tFrequency = +tCodeP1
		s tFrequencyPeriod = 1
		s tFrequencyPeriodUnit = tCodeP3
		#; periodUnit and durationUnit have Required value set, so leave code blank if not found in tUnitCodes.
		s tFrequencyPeriodUnitCode = $g(tUnitCodes(tFrequencyPeriodUnit))
		s tFrequencyPeriodUnitDesc = $g(tUnitDescs(tFrequencyPeriodUnit))
		i (+tFrequencyPeriod'=1)&&(tFrequencyPeriodUnitDesc'="") s tFrequencyPeriodUnitDesc = tFrequencyPeriodUnitDesc_"s"
		s $p(tReturn,"|",4) = tFrequency
		s $p(tReturn,"|",5) = tFrequencyPeriod
		s $p(tReturn,"|",6) = tFrequencyPeriodUnitCode
		q tReturn
	}
	#; Just a number plus letter(s) means that this is an interval.
	i tCodeLower?1n.n1l.l {
		s tFrequencyPeriod = ""
		f i = 1:1 {
			i $e(tCodeNoSpaces,i)'?1n q
			s tFrequencyPeriod = tFrequencyPeriod_$e(tCodeNoSpaces,i)
		}
		s tFrequency = 1
		s tFrequencyPeriodUnit = $e(tCodeNoSpaces,i,*)
		#; periodUnit and durationUnit have Required value set, so leave code blank if not found in tUnitCodes.
		s tFrequencyPeriodUnitCode = $g(tUnitCodes(tFrequencyPeriodUnit))
		s tFrequencyPeriodUnitDesc = $g(tUnitDescs(tFrequencyPeriodUnit))
		i (+tFrequencyPeriod'=1)&&(tFrequencyPeriodUnitDesc'="") s tFrequencyPeriodUnitDesc = tFrequencyPeriodUnitDesc_"s"
		s $p(tReturn,"|",4) = tFrequency
		s $p(tReturn,"|",5) = tFrequencyPeriod
		s $p(tReturn,"|",6) = tFrequencyPeriodUnitCode
		q tReturn
	}
	
	#; Code and Description not recognized by this method get stored in Timing code, display and text.
	i pCode'="" s $p(tReturn,"|",1) = pCode
	i pDesc'="" {
		s $p(tReturn,"|",2) = pDesc
	} else {
		s $p(tReturn,"|",2) = pCode
	}
	
	q tReturn
}

/// Return an array of timing codes and the frequency data derived from them.
ClassMethod GetTimingCodes(ByRef pCodes As %String)
{
	s pCodes("bid","display") = "twice a day"
	s pCodes("bid","frequency") = 2
	s pCodes("bid","period") = 1
	s pCodes("bid","periodUnit") = "d"
	s pCodes("bid","when") = ""
	
	s pCodes("prn","display") = "as needed"
	s pCodes("prn","frequency") = ""
	s pCodes("prn","period") = ""
	s pCodes("prn","periodUnit") = ""
	s pCodes("prn","when") = ""

	s pCodes("qam","display") = "every morning"
	s pCodes("qam","frequency") = 1
	s pCodes("qam","period") = 1
	s pCodes("qam","periodUnit") = "d"
	s pCodes("qam","when") = ""
	
	s pCodes("qd","display") = "every day"
	s pCodes("qd","frequency") = 1
	s pCodes("qd","period") = 1
	s pCodes("qd","periodUnit") = "d"
	s pCodes("qd","when") = ""
	
	s pCodes("qdam","display") = "every day in the morning"
	s pCodes("qdam","frequency") = 1
	s pCodes("qdam","period") = 1
	s pCodes("qdam","periodUnit") = "d"
	s pCodes("qdam","when") = ""
	
	s pCodes("qdpm","display") = "every day in the evening"
	s pCodes("qdpm","frequency") = 1
	s pCodes("qdpm","period") = 1
	s pCodes("qdpm","periodUnit") = "d"
	s pCodes("qdpm","when") = ""
	
	s pCodes("qh","display") = "every hour"
	s pCodes("qh","frequency") = 1
	s pCodes("qh","period") = 1
	s pCodes("qh","periodUnit") = "h"
	s pCodes("qh","when") = ""
	
	s pCodes("qhs","display") = "every night at bedtime"
	s pCodes("qhs","frequency") = 1
	s pCodes("qhs","period") = 1
	s pCodes("qhs","periodUnit") = "d"
	s pCodes("qhs","when") = "hs"
	
	s pCodes("qid","display") = "four times a day"
	s pCodes("qid","frequency") = 4
	s pCodes("qid","period") = 1
	s pCodes("qid","periodUnit") = "d"
	s pCodes("qid","when") = ""
	
	s pCodes("qod","display") = "every other day"
	s pCodes("qod","frequency") = 1
	s pCodes("qod","period") = 2
	s pCodes("qod","periodUnit") = "d"
	s pCodes("qod","when") = ""
	
	s pCodes("tid","display") = "three times a day"
	s pCodes("tid","frequency") = 3
	s pCodes("tid","period") = 1
	s pCodes("tid","periodUnit") = "d"
	s pCodes("tid","when") = ""
	
	q
}

ClassMethod GetTimingCodeSystem() As %String
{
	q "http://hl7.org/fhir/timing-abbreviation"
}

ClassMethod GetWhenCodes(ByRef pCodes As %String)
{
	#; Based on Required value set http://hl7.org/fhir/v3/TimingEvent defined at http://hl7.org/fhir/ValueSet/event-timing.
	s pCodes("ac","display") = "before food or meals"
	s pCodes("acd","display") = "before lunch"
	s pCodes("acm","display") = "before breakfast"
	s pCodes("acv","display") = "before dinner"
	s pCodes("c","display") = "meal"
	s pCodes("cd","display") = "lunch"
	s pCodes("cm","display") = "breakfast"
	s pCodes("cv","display") = "dinner"
	s pCodes("hs","display") = "at bedtime"
	s pCodes("pc","display") = "after food or meals"
	s pCodes("pcd","display") = "after lunch"
	s pCodes("pcm","display") = "after breakfast"
	s pCodes("pcv","display") = "after dinner"
	s pCodes("wake","display") = "upon waking"
	q
}

/// Return an array of possible unit codes that might be received in
/// the SDA data, each item pointing at the corresponding standard
/// unit code.  Also return a long description of each of the standard
/// unit codes (e.g. s = second).
ClassMethod GetUnitCodesAndDescs(ByRef pCodes As %String, ByRef pDescs As %String)
{
	s pCodes("s") = "s"
	s pCodes("sec") = "s"
	s pCodes("secs") = "s"
	s pCodes("min") = "min"
	s pCodes("mins") = "min"
	s pCodes("minute") = "min"
	s pCodes("minutes") = "min"
	s pCodes("h") = "h"
	s pCodes("hr") = "h"
	s pCodes("hrs") = "h"
	s pCodes("hour") = "h"
	s pCodes("hours") = "h"
	s pCodes("d") = "d"
	s pCodes("day") = "d"
	s pCodes("days") = "d"
	s pCodes("w") = "wk"
	s pCodes("wk") = "wk"
	s pCodes("wks") = "wk"
	s pCodes("week") = "wk"
	s pCodes("weeks") = "wk"
	s pCodes("mo") = "mo"
	s pCodes("mos") = "mo"
	s pCodes("mon") = "mo"
	s pCodes("mons") = "mo"
	s pCodes("month") = "mo"
	s pCodes("months") = "mo"
	s pCodes("a") = "a"
	s pCodes("y") = "a"
	s pCodes("yr") = "a"
	s pCodes("yrs") = "a"
	s pCodes("year") = "a"
	s pCodes("years") = "a"
	s x = ""
	f  {
		s x = $o(pCodes(x))
		i x="" q
		s pDescs(x) = $Case(pCodes(x), "s":"second", "min":"minute", "h":"hour", "d":"day", "wk":"week", "mo":"month", "a":"year", :"")
	}
	q
}

}
