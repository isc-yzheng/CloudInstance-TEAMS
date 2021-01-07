Include HS.FHIRServer

/// This class has a subset of methods refactored from HS.FHIR.Util
Class HS.FHIRServer.Utils [ Abstract ]
{

/// API
/// Convert $h value to seconds since start of the Unix epoch,<br>
/// time is $h value.<br>
/// interval is interval to be added in seconds.
ClassMethod TimeInSeconds(time As %String, interval As %Integer = 0) As %Integer [ Internal ]
{
	Quit (($piece(time,",")-47117)*86400+$piece(time,",",2)+interval)\1
}

/// API
/// ConvertToUTC takes a date time value and converts it to UTC time.
/// Expected input format is YYYY-MM-DDTHH:MM:SS[.ssss][(+/-)HH:MM]/[Z].
/// A date-only input value is returned unchanged.
/// A date time input value with the "Z" time zone appended is returned unchanged.
ClassMethod ConvertToUTC(pDateTime As %String) As %String
{
	// 24*60*60 = 86400
	#dim tSecondsPerDay = 86400
	
	set tDate = $P(pDateTime,"T")
	set tTimeWithOffset = $P(pDateTime,"T",2)
	// If no time part, no need to convert, just quit the original value
	if (tTimeWithOffset="") { quit pDateTime }
	// If already in UTC time, no need to convert, just quit the original value
	if ($E(tTimeWithOffset,*) = "Z") { quit pDateTime }
	
	
	if (tTimeWithOffset [ "-") { set tOffsetSign = "-" }
	elseif (tTimeWithOffset [ "+") { set tOffsetSign = "+" }
	else { set tOffsetSign = "" }
	
	
	if (tOffsetSign'="") {
		// compute offset in seconds
		set tOffset = $P(tTimeWithOffset,tOffsetSign,2)
		set tOffsetHrs = $P(tOffset,":")
		set tOffsetMins = $P(tOffset,":",2)
		set tOffsetInSeconds = (3600*tOffsetHrs) + (60*tOffsetMins)
		// get date/time in $H format
		set tTime = $P(tTimeWithOffset,tOffsetSign)
		set tDateTimeH = $ZDTH(tDate_"T"_tTime,3,1)
		set tDateH = $P(tDateTimeH,",")
		set tTimeH = $P(tDateTimeH,",",2)
		// UTC time = timestamp value (+/-) offset
		// might have to increment or decrement the date
		set tUTCDateH = tDateH
		if (tOffsetSign = "-") {
			set tUTCTimeH = tTimeH + tOffsetInSeconds
			if (tUTCTimeH >= tSecondsPerDay) {
				set tUTCDateH = tUTCDateH+1
				set tUTCTimeH = tUTCTimeH-tSecondsPerDay
			}
		}
		else { 
			set tUTCTimeH = tTimeH - tOffsetInSeconds
			if (tUTCTimeH < 0) {
				set tUTCDateH = tUTCDateH-1
				set tUTCTimeH = tUTCTimeH+tSecondsPerDay
			}
		}

		quit $TR($ZDT(tUTCDateH_","_tUTCTimeH,3,1)," ","T")_"Z"	
	}
	// no offset - assume local time
	else {
		// convert to $H format
		set tDateTimeH = $ZDTH(pDateTime,3,1)
		// convert to UTC time, $H format
		set tUTCDateTimeH = $ZDT(tDateTimeH,-3)
		quit $TR($ZDT(tUTCDateTimeH,3,1)," ","T")_"Z"
	}
	
	
	
	quit ""
}

ClassMethod URLParameterArrayToString(pParametersArray As %Library.ArrayOfDataTypes) As %String
{
	Set tString = ""
	
	Set tParamName = ""
	For {
		Set tParamVals = pParametersArray.GetNext(.tParamName)
		If tParamName="" Quit
		For i = 1:1:$ListLength(tParamVals) {
			If tString'="" Set tString = tString_"&"
			Set tString = tString_tParamName_"="_$ListGet(tParamVals, i)
		}
	}
	
	Quit tString
}

/// API
/// URLParamStringToArray takes a URL parameters string and converts it to an array of $List.<br>
/// <br>
/// Input:<br>
/// <li>pParametersString : Parameters string exactly as one would see in a request URL.
/// <br><br>
/// Output:<br>
/// <li>pParametersArray  : %Library.ArrayOfDataTypes that is an array of $List, indexed by parameter
///                         name. Use the GetParameterCount() and GetParameterValue() methods of this
///                         class to extract information from this array.
ClassMethod URLParamStringToArray(pParametersString As %String, Output pParametersArray As HS.FHIRServer.API.Data.QueryParameters)
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pParametersArray)) Set pParametersArray = ##class(%Library.ArrayOfDataTypes).%New()
		
		For i = 1:1:$Length(pParametersString,"&") {
			Set tP = $Piece(pParametersString,"&",i)
			If tP'="" {
				// Split Name from Value
				Set tParamName = $Piece(tP,"=",1)
				Set tParamValue = $Piece(tP,"=",2,99)
				// Split any Modifier from the name
				Set tModifier = $Piece(tParamName,":",2)
				Set tParamName = $Piece(tParamName,":",1)
				Do ..SetParameter(tParamName, tParamValue, tModifier, .pParametersArray)
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// SetParameter adds the specified parameter, modifier, and value to the pParametersArray collection.
ClassMethod SetParameter(pParamName As %String = "", pParamValue As %String = "", pModifier As %String = "", pParametersArray As %Library.ArrayOfDataTypes) [ Private ]
{
	If (pParamName'="")&&(pParamValue'="") {
		If $Extract(pModifier)=":" Set pModifier = $Extract(pModifier,2,*)
		If pModifier'="" Set pParamName = pParamName_":"_pModifier
		Set tParamList = pParametersArray.GetAt(pParamName)
		Set $LIST(tParamList, *+1) = pParamValue
		$$$ThrowOnError( pParametersArray.SetAt(tParamList, pParamName) )
	} ElseIf pParamName="" {
		$$$ThrowFHIR($$$GeneralError, "Error setting parameter - parameter name not specified")
	} ElseIf pParamValue="" {
		$$$ThrowFHIR($$$GeneralError, "Error setting parameter "_pParamName_" - parameter value not specified")
	}
}

}
