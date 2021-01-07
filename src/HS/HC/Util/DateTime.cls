Class HS.HC.Util.DateTime Extends %RegisteredObject
{

/// ConvertToUTC takes a date time value and converts it to UTC time.
/// Expected input format is YYYY-MM-DDTHH:MM:SS[.ssss][(+/-)HH:MM]/[Z].
/// A date-only input value is returned unchanged.
/// A date time input value with the "Z" time zone appended is returned unchanged.
ClassMethod ConvertToUTC(pDateTime As %String, pDateTimeH, pForceTime = 0) As %String
{
	// 24*60*60 = 86400
	#dim tSecondsPerDay = 86400
	
	set tDate = $P(pDateTime,"T")
	set tTimeWithOffset = $P(pDateTime,"T",2)
	// If no time part, no need to convert, just quit the original value
	if (tTimeWithOffset="") {
		If 'pForceTime {
			Set pDateTimeH = $ZDH(pDateTime,3)
			quit pDateTime
		}
		Quit ..ConvertToUTC(pDateTime_"T00:00:00",.pDateTimeH) /// If pForceTime is true, return UTC value for 'local' midnight	
	}
	// If already in UTC time, no need to convert, just quit the original value
	if ($E(tTimeWithOffset,*) = "Z") { 
		Set pDateTimeH = $ZDATETIMEH(pDateTime,3,6)
		quit pDateTime 
	}
	
	
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

		Set pDateTimeH = tUTCDateH_","_tUTCTimeH
		quit $TR($ZDT(pDateTimeH,3,1)," ","T")_"Z"	
	}
	// no offset - assume local time
	else {
		// convert to $H format
		set tDateTimeH = $ZDTH(pDateTime,3,1)
		// convert to UTC time, $H format
		set pDateTimeH = $ZDT(tDateTimeH,-3)
		quit $TR($ZDT(pDateTimeH,3,1)," ","T")_"Z"
	}
	
	
	
	quit ""
}

}
