Include HS.FHIRServer

/// This class is intended to be inherited into other classes that work with SQL and
/// FHIR-based data. It provides conversion utilities as well as naming conventions that are shared
/// among Table Generation, Indexing, and Querying
Class HS.FHIRServer.Util.FHIRQueryUtils Extends (HS.FHIRMeta.MetaUtils, HS.FHIRServer.Util.RunSQLQuery)
{

/// Suffix to create Column Name from property name for start-of-period
Parameter PERIODSTARTSUFFIX = "Start";

/// Suffix to create Column Name from property name for end-of-period
Parameter PERIODENDSUFFIX = "End";

/// Normalize a phone number for indexing and search by stripping out punctuation and whitespace
ClassMethod NormalizePhone(pVal As %String) As %String
{
	quit $ZSTRIP(pVal, "*PW")
}

/// Given a date and optionally time in one of the formats:<br>
/// YYYY<br>
/// YYYY-MM<br>
/// YYYY-MM-DD<br>
/// YYYY-MM-DDThh:mmZ<br>
/// YYYY-MM-DDThh:mm:ssZ<br>
/// This method will return the first instant (second) that falls within that date/time.<br>
/// For example, an input value of "1974" would return "1974-01-01T00:00:00Z". A date/time<br>
/// that already has second precision will be returned unchanged.<br>
/// The argument must be in one of the above formats. This method will not validate it.
ClassMethod FirstInstant(pVal As %String) As %String
{
	set tYear   = $P(pVal,"-")
	set tMonth  = $P(pVal,"-",2)
	set tDate   = $P($P(pVal,"-",3),"T")
	set tHour   = $P($P(pVal,"T",2),":")
	set tMinute = $P(pVal,":",2)
	set tSecond = $E($P(pVal,":",3),1,2)
	
	set:tSecond="" tSecond="00"
	set:tMinute="" tMinute="00"
	set:tHour="" tHour="00"
	set:tMonth="" tMonth="01"
	set:tDate="" tDate="01"
	
	// hopefully there's a year!
	
	quit tYear_"-"_tMonth_"-"_tDate_"T"_tHour_":"_tMinute_":"_tSecond_"Z"
}

/// Given a date and optionally time in one of the formats:<br>
/// YYYY<br>
/// YYYY-MM<br>
/// YYYY-MM-DD<br>
/// YYYY-MM-DDThh:mmZ<br>
/// YYYY-MM-DDThh:mm:ssZ<br>
/// This method will return the last instant (second) that falls within that date/time.<br>
/// For example, an input value of "1974" would return "1974-12-31T23:59:59Z". A date/time<br>
/// that already has second precision will be returned unchanged.<br>
/// The argument must be in one of the above formats. This method will not validate it.
ClassMethod LastInstant(pVal As %String) As %String
{
	set tYear   = $P(pVal,"-")
	set tMonth  = $P(pVal,"-",2)
	set tDate   = $P($P(pVal,"-",3),"T")
	set tHour   = $P($P(pVal,"T",2),":")
	set tMinute = $P(pVal,":",2)
	set tSecond = $E($P(pVal,":",3),1,2)
	
	set:tSecond="" tSecond=59
	set:tMinute="" tMinute=59
	set:tHour="" tHour=23
	set:tMonth="" tMonth=12
	set:tDate="" tDate=$CASE(tMonth, "01":31, "02":$$FebruaryLength(tYear), "03":31, "04":30, "05":31, "06":30, "07":31, "08":31, "09":30, "10":31, "11":30, "12":31)
	
	// hopefully there's a year!
	
	quit tYear_"-"_tMonth_"-"_tDate_"T"_tHour_":"_tMinute_":"_tSecond_"Z"
	
FebruaryLength(pYear)
	if (pYear#4=0)&&((pYear#100'=0)||(pYear#400=0)) quit 29
	quit 28
}

/// Given a timestamp in YYYY-MM-DDThh:mm:ss format, return the value
/// of the timestamp that is one second prior
ClassMethod PreviousInstant(pVal As %String) As %String
{
	set tDateTimeH = $ZDTH(pVal, 3)
	set tDateH = $P(tDateTimeH, ",")
	set tTimeH = $P(tDateTimeH, ",", 2)
	if (tTimeH = 0) {
		set tTimeH = 86399
		set tDateH = tDateH-1
	}
	else { set tTimeH = tTimeH-1 }
	quit $REPLACE($ZDT(tDateH_","_tTimeH, 3), " ", "T")
}

}
