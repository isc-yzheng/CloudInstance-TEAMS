Class HS.FHIR.DTL.Util.Element.TypeCast
{

/// Base64 encode the source string.
ClassMethod Base64Encode(source As %String) As %String
{
	quit $replace($system.Encryption.Base64Encode(source), $char(13,10), "")
}

/// Base64 decode the source string
ClassMethod Base64Decode(source As %String) As %String
{
	quit $system.Encryption.Base64Decode(source)
}

/// Convert a standard text string to a format that
/// is a valid div element in FHIR.
ClassMethod ToDiv(source As %String) As %String
{
	set source = $replace(source, $char(13, 10), "<br/>")
	
	
	if $find(source, "<div") && $find(source, "/div>") {
		quit source
	}
	else {
		quit "<div xmlns=""http://www.w3.org/1999/xhtml"">" _ source _ "</div>"
	}
}

/// Convert a valid div element in FHIR to a text
/// string.
ClassMethod FromDiv(source As %String) As %String
{
	set index = $find(source, "<div>")
	if index {
		set source = $extract(source, index, *)
	}
	set index = $find(source, "<div xmlns=""http://www.w3.org/1999/xhtml"">")
	if index {
		set source = $extract(source, index, *)
	}
	set index = $find(source, "</div>")
	if index {
		set source = $extract(source, 1, index - $length("</div>") - 1)
	}
	quit source
}

ClassMethod dateTimeTOdate(value As %Integer) As %Integer
{
	if value [ "T" {
		set value = $piece(value, "T", 1)
	}
	quit value
}

ClassMethod positiveIntTOinteger(value As %Integer) As %Integer
{
	quit value
}

ClassMethod integerTOpositiveInt(value As %Integer) As %Integer
{
	if value > 0 {
		quit value
	}
	else {
		quit ""
	}
}

ClassMethod unsignedIntTOinteger(value As %Integer) As %Integer
{
	quit value
}

ClassMethod integerTOunsignedInt(value As %Integer) As %Integer
{
	if value >= 0 {
		quit value
	}
	else {
		quit ""
	}
}

ClassMethod uriTOstring(value As %String) As %String
{
	quit value
}

ClassMethod stringTOuri(value As %String) As %String
{
	//TODO: should we add validation here?
	quit value
}

ClassMethod positiveIntTOstring(value As %Integer) As %String
{
	quit value
}

ClassMethod stringTOpositiveInt(value As %String) As %String
{
	if $isvalidnum(value,,1) && (value '[ ".") {
		quit value
	}
	else {
		quit ""
	}
}

ClassMethod codeTOuri(value As %String) As %String
{
	//TODO: should we add validation here?
	quit value
}

ClassMethod uriTOcode(value As %String) As %String
{
	//TODO: should we add validation here?
	quit value
}

ClassMethod codeTOboolean(value As %String) As %Boolean
{
	if ($isvalidnum(value) && (value > 0)) || (value = "true") || (value = "T") {
		quit 1
	}
	elseif ($isvalidnum(value) && (value <= 0)) || (value = "false") || (value = "F") {
		quit 0
	}
	else {
		quit ""
	}
}

ClassMethod booleanTOcode(value As %String) As %String
{
	quit value
}

ClassMethod codeTOkeyword(value As %String) As %String
{
	quit value
}

ClassMethod keywordTOcode(value As %String) As %String
{
	quit value
}

ClassMethod idTOstring(value As %String) As %String
{
	quit value
}

ClassMethod stringTOid(value As %String) As %String
{
	//TODO: should we add validation here?
	quit value
}

ClassMethod markdownTOstring(value As %String) As %String
{
	//TODO: should we add validation here?
	quit value
}

ClassMethod stringTOmarkdown(value As %String) As %String
{
	quit value
}

/// Convert an SDA3 date format to a valid FHIR date. Can convert
/// to any of the FHIR date types - date, dateTime, time, instant.
/// fromVal - the SDA3 date
/// toType - the FHIR data type, used to determine which format to output
/// the date in.
ClassMethod DateToFHIR(fromVal As %String, toType As %String) As %String
{
	set tSC = $$$OK
	try {
		set toVal = ""
		if toType = "date" {
			set toVal = ##class(HS.FHIR.DTL.Utils).FHIRDate(fromVal)
		}
		elseif toType = "dateTime" {
			set toVal = ##class(HS.FHIR.DTL.Utils).FHIRDateTime(fromVal)
		}
		elseif (toType = "instant") || (toType = "time") {
			set toVal = ##class(HS.FHIR.DTL.Utils).FHIRInstant(fromVal)
			if toType = "time" {
				set toVal = $piece(toVal, "T", *)
				set toVal = $piece(toVal, "-", 1)
				set toVal = $piece(toVal, "+", 1)
			}
		}
	} catch ex {
		set toVal = ""
	}
	quit toVal
}

/// Convert a FHIR date back to an SDA3 date. Any of the FHIR
/// date data types can be used as inputs.
ClassMethod FHIRDateToSDA3(fromVal As %String) As %String
{
	set tSC = $$$OK
	try {
		set toVal = ##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(fromVal)
	} catch ex {
		set toVal = ""
	}
	quit toVal
}

}
