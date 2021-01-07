Class HS.Types.IHE.DSUB.Subscription Extends %RegisteredObject
{

/// full notification or minimal (returns a retrieve document request with repo, doc and home community)
Property Topic As %String(DISPLAYLIST = ",ihe:FullDocumentEntry,ihe:MinimalDocumentEntry,ihe:SubmissionSetMetadata", VALUELIST = ",F,M,S", XMLLISTPARAMETER = "DISPLAYLIST") [ InitialExpression = "M", Required ];

/// ID^^^&oid&ISO
Property PatientID As %String(MAXLEN = "") [ Required ];

/// A collection of items to filter by in the subscription
Property FilterItems As list Of HS.Types.IHE.DSUB.SubscriptionItems(XMLNAME = "FilterItems", XMLPROJECTION = "ELEMENT");

/// Termination Time (when the subscription will be complete), local time of subscription expiration.  Could be a duration in the subscription request (but then converted)
Property TerminationTime As %String;

/// Document / Folder / Submission 
Property Type As %String(DISPLAYLIST = ",urn:uuid:aa2332d0-f8fe-11e0-be50-0800200c9a66,urn:uuid:9376254e-da05-41f5-9af3-ac56d63d8ebd,urn:uuid:fbede94e-dbdc-4f6b-bc1f-d730e677cece", VALUELIST = ",Document,Folder,Submission", XMLLISTPARAMETER = "DISPLAYLIST") [ Required ];

/// This is the URL where notifications will be sent
Property RecipientAddress As %String(MAXLEN = "") [ Required ];

/// pTerminationTime (either UTC or UTC+offset, or converted local, or P (coded pattern)
/// pDefaultDuration (maximum time based on coded pattern, ie P1Y - duration is 1 year from now)
/// pAdjustedTerminationTime (new time in UTC) YYYY-MM-DDTHH:MM:SS[.sss]
ClassMethod GetTerminationTime(pTerminationTime = "", pDefaultDuration = "", ByRef pAdjustedTerminationTime) As %Status
{
	try {
		Set tSC = $$$OK
		Set pAdjustedTerminationTime=""
		If pTerminationTime="" && (pDefaultDuration="") Quit 
		If $e(pTerminationTime)="P" {
			Set tSC=..GetTerminationTimeDuration(pTerminationTime,.pAdjustedTerminationTime)
		} Else {
			Set tSC=..GetTerminationTimeTime(.pTerminationTime,.pAdjustedTerminationTime)
		}
		If pDefaultDuration]"" {
			Set tSC = ..GetTerminationTimeDuration(pDefaultDuration,.tMax)
			Quit:$$$ISERR(tSC)
			If $tr(pAdjustedTerminationTime,",",".")>$tr(tMax,",",".") || (pAdjustedTerminationTime="") Set pAdjustedTerminationTime=tMax
		}
		Set:pAdjustedTerminationTime]"" pAdjustedTerminationTime=$TR($zdt(pAdjustedTerminationTime,3)," ","T")_"Z"
	} Catch ex {
		Set tSC = ex.AsStatus() 
	}
	Quit tSC
}

/// pTermination time is a coded pattern P* which may contain Year/Month/Day/Hour/Min/Second offset, Add this offset to the current UTC date/time
ClassMethod GetTerminationTimeDuration(pTerminationTime = "", ByRef pAdjustedTerminationTime = "") As %Status
{
	try {
		Set tSC =$$$OK
		Set tValid=1
		If pTerminationTime["-" {
			/// minus must be first, but negative subscriptions mean nothing
			Set tValid=0,tMessage="Negative values are not valid subscriptions"
		}
		Set tPreP = $p(pTerminationTime,"P"),tPostP=$p(pTerminationTime,"P",2)
		If tPreP'="" {
			/// only thing valid before P is -, but negative subscriptions are not really valid
			Set tValid=0,tMessage="Negative values are not valid subscriptions"
		}
		If tPostP="" {
			/// must have a value
			Set tValid = 0
		} Else {
			If $F(tPostP,"T") {
				/// If T is present, there must be a time
				Set tTime = $zstrip($p(tPostP,"T",2),"<>W")
				If tTime="" Set tValid=0
			} ElseIf (tPostP["H") || (tPostP["S") {
				// If T is not present we must not see H or S
				Set tValid=0
			}
		}
		If 'tValid Set tSC=$$$ERROR($$$GeneralError,$S(tMessage="":"Invalid duration pattern ",1:tMessage)_pTerminationTime) $$$ThrowStatus(tSC)
		Set tDate=$e($P(pTerminationTime,"T",1),2,*)
		Set tYearPos = $F(tDate,"Y")-2
		Set tMonthPos = $F(tDate,"M")-2
		Set tDayPos = $F(tDate,"D")-2
		Set tTime=$P(pTerminationTime,"T",2)
		Set tHourPos = $F(tTime,"H")-2
		Set tMinutePos = $F(tTime,"M")-2
		Set tSecondPos = $F(tTime,"S")-2
		Set tStartPos=1,(tYears,tMonths,tDays,tHours,tMinutes,tSeconds)=""
		If tYearPos Set tYears = $E(tDate,tStartPos,tYearPos),tStartPos=tYearPos+2
		If tMonthPos Set tMonths = $E(tDate,tStartPos,tMonthPos),tStartPos=tMonthPos+2
		If tDayPos Set tDays = $E(tDate,tStartPos,tDayPos)
		Set tStartPos=1
		If tHourPos Set tHours = $E(tTime,tStartPos,tHourPos),tStartPos=tHourPos+2
		If tMinutePos Set tMinutes = $E(tTime,tStartPos,tMinutePos),tStartPos=tMinutePos+2
		If tSecondPos Set tSeconds = $E(tTime,tStartPos,tSecondPos)

		For tCompare = tYears,tMonths,tDays,tHours,tMinutes,tSeconds {
			If (tCompare?1N.N || (tCompare="")) Continue
			If tCompare=tSeconds && (tCompare?1N.n1"."1N.N) Continue
			Set tSC=$$$ERROR($$$GeneralError,"Invalid duration pattern "_pTerminationTime) $$$ThrowStatus(tSC)
		}

		Set tNowH = $ztimestamp
		Set tDate = $zdt(tNowH,8)
		Set tYear = tYears + $E(tDate,1,4)
		Set tMonth = tMonths + $E(tDate,5,6)
		
		If tMonth>12 Set tOffset = tMonth\12 Set tMonth = tMonth - (tOffset*12),tYear=tYear+tOffset
		Set tNewDate = $zdh(tYear_$e(tMonth+100,2,3)_$e(tDate,7,8),8)
		Set tTime = $p(tNowH,",",2) + (tHours*3600) + (tMinutes*60) + tSeconds
		Set tDayOffset = tTime \ 86400
		Set tTimeOffset = tTime - (86400*tDayOffset)
		 
		Set tNewDate = tNewDate+tDays+tDayOffset _"," _ tTimeOffset
		Set pAdjustedTerminationTime = tNewDate
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Convert given time to UTC
ClassMethod GetTerminationTimeTime(ByRef pTerminationTime = "", ByRef pAdjustedTerminationTime = "") As %Status
{
	try {
		Set tSC =$$$OK
		Set tDTTM = ##class(HS.HC.Util.DateTime).ConvertToUTC(pTerminationTime,.pAdjustedTerminationTime,1)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
