Include HS.HC

/// This class handles callbacks from the XSLT processor. You should create a subclass this class and override the 
/// 'evaluate' method to perform the processing that you require. An example of an stylesheet using this function is
/// shown in the example XSL contained in the %XML.XSLT.Transformer class
Class HS.Util.XSLTHelper Extends %XML.XSLT.CallbackHandler
{

ClassMethod LogAccess(atype As %String) [ Private ]
{
    Set hascount = $data(^xmlperf(atype))
    if (hascount) {
        Set oldCount = ^xmlperf(atype)
    } else {
        Set oldCount = 0
    }
    Set ^xmlperf(atype) = oldCount + 1
}

ClassMethod ReportAccess()
{
	Set total = 0
    SET key=$ORDER(^xmlperf(""))
    WHILE (key'="") {
     WRITE key _ " " _ ^xmlperf(key), !
     Set total = total + ^xmlperf(key)
     // Get next subscript
     SET key = $ORDER(^xmlperf(key))
    }
     WRITE "Total " _ total, !
}

ClassMethod ResetAccess()
{
    Kill ^xmlperf
}

Method evaluate(Args...) As %String
{
	#if 0
	/// debugging code not used in production code
	Do ..LogAccess(Args(1))
	#endif	
	If Args(1)="xmltimestamp" {
		Quit ..xmltimestamp(Args(2))
	} ElseIf Args(1)="createGUID" {
		Quit $System.Util.CreateGUID()
	} ElseIf Args(1)="currentDate" {
		Quit $ZDT($P($H,","),3)
	} ElseIf Args(1)="lookup" {
		Quit ..lookup(Args(2),Args(3))
	} ElseIF Args(1)="dateNoDash" {
		Quit ..dateNoDash(Args(2))
	} ElseIf Args(1)="stripapos" {
		Quit $zstrip(Args(2),"<>","'")
	} ElseIf Args(1)="piece" {
		Quit $P(Args(2),Args(3),Args(4))
	} ElseIf Args(1)="pieceStrip" {
		Quit $ZSTRIP($P(Args(2),Args(3),Args(4)),"<>W")
	} ElseIf Args(1)="strip" {
		Quit $ZSTRIP(Args(2),"<>"_Args(3))
	} ElseIf Args(1)="encode" {
		Quit $system.Encryption.Base64Encode(Args(2))
	} ElseIf Args(1)="decode" {
		Quit $system.Encryption.Base64Decode(Args(2))
	} ElseIf Args(1)="timestamp" {
		Quit ..timestamp($g(Args(2),$h))
	} ElseIf Args(1)="xmltimestampisbefore" {
		Quit ..xmltimestampisbefore(Args(2),Args(3))
	} ElseIf Args(1)="dateDiff" {
		Quit ..dateDiff(Args(2), Args(3), $Get(Args(4), $ZDateTime($Horolog, 3)))
	} ElseIf Args(1)="GWtoOID" {
		#; Consider deleting this function in favor of ..getOIDForCode()
		Quit ##class(HS.Data.OIDMap).OIDForType(Args(2),"Repository","")
	} ElseIf Args(1)="CodetoOID" {
		Quit:Args(2)="" ""
		Quit ##class(HS.Data.OIDMap).GetOIDForCode(Args(2),$g(Args(3),"Unknown code:"_Args(2)))
	} ElseIf Args(1)="OIDtoCode" {
		Quit:Args(2)="" ""
		Quit ##class(HS.Data.OIDMap).GetCodeForOID(Args(2),$G(Args(3),"Unknown OID:"_Args(2)))
	} ElseIf Args(1)="OIDtoGW" {
		#; Consider deleting this function in favor of ..getCodeForOID()
		Quit ##class(HS.Data.OIDMap).GetCodeForOID(Args(2))
	} ElseIf Args(1)="OIDtoFacilityName" {
		Set tReturn=Args(2)
		Set tFACCode=##class(HS.Data.OIDMap).GetCodeForOID(Args(2))
		If ##class(HS.Facility.Config).%ExistsId(tFACCode) {Set tReturn=##class(HS.Facility.Config).NameGetStored(tFACCode)}
		Quit tReturn
	} ElseIf Args(1)="OIDtoFacilityContact" {
		Set tReturn=Args(2)
		Set tFACCode=##class(HS.Data.OIDMap).GetCodeForOID(Args(2))
		Set tFAC=##class(HS.Facility.Config).%OpenId(tFACCode)
		If $ISObject(tFAC) {
			Set tReturn=tFAC.Contact.FirstName_" "_tFAC.Contact.LastName
		}
		Quit tReturn
	} ElseIf Args(1)="getHomeCommunityCode" {
		Quit $$$HomeCommunity
	} ElseIf Args(1)="getSystemOID" {
		#; Consider deleting this function in favor of ..getOIDForCode()
		Quit ##class(HS.Data.OIDMap).OIDForType($g(Args(2)),"AssigningAuthority",$g(Args(2)))
	} ElseIf Args(1)="GetIdentifierType" { Quit ##class(HS.AssignAuth.Config).GetIdentifierType($g(Args(2)))
	} ElseIf Args(1)="lookupIHETransaction" {
		Quit ..lookupIHETransaction(Args(2))
	} ElseIf Args(1)="resultFlag" {
		Quit ##class(HS.SDA3.LabResultItem).RangeResult(Args(2),Args(3))
	} ElseIf Args(1)="getNumberType" {
		Quit ##class(HS.AssignAuth.Config).GetNumberType(Args(2))
	} ElseIf Args(1)="debug" {
		Set @("^" _ Args(2)) = Args(3)
		Quit ""
	} ElseIf Args(1)="getOIDForCode" {
		Quit ..getOIDForCode(Args(2), $Get(Args(3)), $Get(Args(4)))
	} ElseIf Args(1)="getCodeForOID" {
		Quit ..getCodeForOID(Args(2), $Get(Args(3)), $Get(Args(4)))
	} ElseIf Args(1)="getDescriptionForOID" {
		Quit ..getDescriptionForOID(Args(2), $Get(Args(3)), $Get(Args(4), Args(2)))
	} ElseIf Args(1)="getURLForCode" {
		Quit ..getURLForCode(Args(2), $Get(Args(3)), $Get(Args(4)))
	} ElseIf Args(1)="getCodeForURL" {
		Quit ..getCodeForURL(Args(2), $Get(Args(3)), $Get(Args(4)))
	} ElseIf Args(1)="getDescriptionForURL" {
		Quit ..getDescriptionForURL(Args(2), $Get(Args(3)), $Get(Args(4), Args(2)))
	} ElseIf Args(1)="hex2dec" { Quit ..hex2dec(Args(2))
	} ElseIf Args(1)="uuid2oid" { Quit ..uuid2oid(Args(2))
	} ElseIf Args(1)="createUUID" { Quit ..createUUID()
	} ElseIf Args(1)="createOID" { Quit ..createOID()
	} ElseIf Args(1)="createHL7Timestamp" { Quit ..createHL7Timestamp()
	} ElseIf Args(1)="createID" { Quit ..createID($G(Args(2))) 
	} ElseIf Args(1)="varReset" { Quit ..varReset()	 
	} ElseIf Args(1)="varSet" { Quit ..varSet(Args...) 
	} ElseIf Args(1)="varGet"	{ Quit ..varGet(Args...) 
	} ElseIf Args(1)="varInc" { Quit ..varInc(Args...) 
	} ElseIf Args(1)="varKill" { Quit ..varKill(Args...) 
	} ElseIf Args(1)="varData" { Quit ..varData(Args...) 
	} ElseIf Args(1)="varConcat" { Quit ..varConcat(Args...) 
	} ElseIf Args(1)="varDebug" { Quit ..varDebug(Args...) 
	} ElseIf Args(1)="getPreviousUUID" { Quit ..getPreviousUUID(Args(2))
	} ElseIf Args(1)="encodeURL" { Quit $ZCVT(Args(2),"O","URL") 
	} ElseIf Args(1)="decodeURL" { Quit $ZCVT(Args(2),"I","URL")
	} ElseIf Args(1)="makeURL" { Quit ..makeURL(Args...)
	} ElseIf Args(1)="encodeJS" { Quit $ZCVT(Args(2),"O","JS") 
	} ElseIf Args(1)="decodeJS" { Quit $ZCVT(Args(2),"I","JS")
	} ElseIf Args(1)="getConfigValue" { Quit ..getConfigValue(Args(2))
	} ElseIf Args(1)="getHierarchicalConfigValue" { Quit ..getHierarchicalConfigValue(Args(2),Args...)
	} ElseIf Args(1)="getCodedEntryConfig" { Quit ..getCodedEntryConfig(Args(2),Args...)
	} ElseIf Args(1)="getCID" { 
		Set tCID=Args(2)
		Set:tCID["cid:" tCID=$e(tCID,5,*)
		Quit $ZCVT(tCID,"I","URL")
	} ElseIf Args(1)="getUniqueTime" { Quit ..getUniqueTime(Args(2),Args(3))
	} ElseIf Args(1)="toUpper" { Quit $ZConvert($Get(Args(2)), "U")
	} ElseIf Args(1)="toLower" { Quit $ZConvert($Get(Args(2)), "L")
	} ElseIf Args(1)="getServiceNameFromOID" { Quit ..getServiceNameFromOID($G(Args(2)),$G(Args(3)),$G(Args(4)),$G(Args(5)))
	} ElseIf Args(1)="getServiceHostFromOID" { Quit ..getServiceHostFromOID($G(Args(2)),$G(Args(3)),$G(Args(4)),$G(Args(5)))
	} ElseIf Args(1)="getServiceURLFromOID" { Quit ..getServiceURLFromOID($G(Args(2)),$G(Args(3)),$G(Args(4)),$G(Args(5)))
	} ElseIf Args(1)="getServiceNameFromURL" { Quit ..getServiceNameFromURL($G(Args(2)))
	} ElseIf Args(1)="getServiceOIDFromURL" { Quit ..getServiceOIDFromURL($G(Args(2)))
	} ElseIf Args(1)="addFilterEntity" { Quit ##Class(HS.Reports.Patient.ReportRun).AddFilterEntity(Args(2),$G(Args(3)),$G(Args(4)),$G(Args(5)),$G(Args(6)),$G(Args(7)),$G(Args(8)))
	} ElseIf Args(1)="includeEntity" { Quit ##Class(HS.Reports.Patient.ReportRun).IncludeEntity(Args(2))
	} ElseIf Args(1)="generateVisitNumber" { Quit $TR($ZTIMESTAMP,",.","")_$R(10000)
	} ElseIf Args(1)="addStreamletType" { Set %streamletType(Args(2))=$G(Args(3)) Quit ""
	} ElseIf Args(1)="recordSDAData" { Set %SDAData=Args(2) Quit ""
	} ElseIf Args(1)="xmltimestampToUTC" {
		Quit ..xmltimestampToUTC(Args(2))
	} ElseIf Args(1)="getQuickStream" { Quit ..getQuickStream(Args(2))
	} ElseIf Args(1)="getMeasuresTemplates" { Quit ..getMeasuresTemplates(Args(2))
	} ElseIf Args(1)="getMeasuresHeaderInfo" { Quit ..getMeasuresHeaderInfo(Args(2))
	} ElseIf Args(1)="getMeasuresSetIds" { Quit ..getMeasuresSetIds(Args(2))
	} ElseIf Args(1)="getValueSetOIDs" { Quit ..getValueSetOIDs(Args(2),Args(3),Args(4))
	} ElseIf Args(1)="setHSValueSetEntry" { Quit ..setHSValueSetEntry(Args(2),Args(3),Args(4),Args(5),Args(6),Args(7),Args(8),Args(9))
	} ElseIf Args(1)="addUTCtoDateTime" { Quit ..returnAsUTC(Args(2))  
	} ElseIf Args(1)="xmltimestampToLocal" { Quit ..returnAsLocal(..xmltimestamp(Args(2))) }
	
	
	ZTRAP "BAD:"_$g(Args(1))
}

ClassMethod dateNoDash(pDate) As %String
{
	Quit $TR(pDate,"-")
}

/// Compute a timestamp
ClassMethod timestamp(pEpoch As %String = {$Horolog}) As %String
{
	
	Set tTimeZoneOffset = $TR($e($ZDT(pEpoch,3,5),*-5,*),":","")
	
	If pEpoch["," {
		Quit $TR("YyXxMmDdHhNnSs","YyXx-Mm-Dd Hh:Nn:Ss",$ZDT(pEpoch,3))_tTimeZoneOffset
	} Else {
		Quit $TR("YyXxMmDd","YyXx-Mm-Dd",$ZDT(pEpoch,3))
	}
}

ClassMethod timestamptoxml(pTS As %String) As %String [ CodeMode = expression ]
{
$TR("YyXx-Mm-DdTHh:Nn:SsZ","YyXx-Mm-Dd Hh:Nn:Ss",pTS)
}

/// Used to take a UTC date/time (YYYY-MM-DDTHH:MM:SSZ) and return as a local date/time (YYYY-MM-DDTHH:MM:SS+/-HH:MM)
ClassMethod returnAsLocal(datetime As %String) As %String
{
	Try{
		Set tReturn = $ZDT($ZDTH(datetime,3,8),3,5)
	} Catch {
		Set tReturn=""
	}
	Quit tReturn
}

/// Used to take a standard date/time (YYYY-MM-DD HH:MM:SS) and return as UTC (YYYYMMDDHHMMSSZ)
ClassMethod returnAsUTC(datetime As %String) As %String
{
	Try { 
		Set tReturn=$tr($ZDT($ZDTH(datetime,3,4),3,7),"T:-")
	} Catch {
		Set tReturn=""
	}
	quit tReturn
}

/// Compare two XML timestamps, returns true if pTS1 is the same as or before pTS2
ClassMethod xmltimestampisbefore(pTS1 As %String, pTS2 As %String = "{$ZDateTime($Horolog, 3)}") As %Boolean
{
	Set tH1 = $S(pTS1'="":$ZDTH($tr("YyXx-Mm-Dd Hh:Nn:Ss","YyXx-Mm-DdTHh:Nn:SsZ",pTS1),3),1:0)
	Set tH2 = $S(pTS2'="":$ZDTH($tr("YyXx-Mm-Dd Hh:Nn:Ss","YyXx-Mm-DdTHh:Nn:SsZ",pTS2),3),1:9999999999)
	Set tResult = $S(+tH1<+tH2:1,+tH1>+tH2:0,1:$P(tH1,",",2)<=$P(tH2,",",2))
	
	Quit tResult
}

/// Convert an HL7 date of the form YYYYMMDDHHMM into a standard XML date
ClassMethod xmltimestamp(pDate) As %String
{
	// TODO: Handle YYYY and YYYYMM. Right now we reject them.
	Quit:$Length(pDate)<8 ""
	
	If $Extract(pDate,7,8)="00"!($Extract(pDate,5,6)="00") Quit ""
	
	// Account for an HL7 date that has a time zone offset AND leaves the seconds off the time.
	If pDate?1N.N1"-"4N!(pDate?1N.N1"+"4N) {
		Set tDelim = $Extract(pDate,$Length(pDate)-4)
		Set tDate1=$Piece(pDate,tDelim,1),tDate2=$Piece(pDate,tDelim,2)
		If $Length(tDate1)=12 Set tDate1=tDate1_"00" Set pDate=tDate1_tDelim_tDate2
	}
	
	Quit $tr("YyXx-Mm-DdTHh:Nn:SsZ","YyXxMmDdHhNnSs",$ZSTRIP($P(pDate,"+"),"<>W")_"00000000000000")
}

ClassMethod dateDiff(pDatePart As %String = "", pStartDateODBCFormat As %String = "", pEndDateODBCFormat As %String = {$ZDateTime($Horolog, 3)}) As %Integer
{
	#dim eException As %Exception.AbstractException
	
	Try {
		Set tDateDiff = $System.SQL.DATEDIFF(pDatePart, pStartDateODBCFormat, pEndDateODBCFormat)
	}
	Catch eException {
		Set tDateDiff = ""
	}
	
	Quit tDateDiff
}

ClassMethod getOIDForCode(pCode As %String = "", pType As %String = "", pDefault As %String = "") As %String
{
	If pCode="" Quit pDefault
	Set tNamespace=$$$OIDMapCacheNS
	Set tOID = $Get(^CacheTemp.OIDMap(tNamespace,"CodeTypeIndex",$ZCVT(pCode,"U")))
	If tOID'="" Quit tOID
	// Do not pass pDefault into GetOIDForCode, to avoid caching pDefault.
	Set tOID = ##class(HS.Data.OIDMap).GetOIDForCode(pCode,pCode)
	// tOID=pCode means OID not found. In that case, use pDefault if provided, and do not cache.
	If tOID=pCode Set:pDefault'="" tOID=pDefault Quit tOID
	Set ^CacheTemp.OIDMap(tNamespace,"CodeTypeIndex",$ZCVT(pCode,"U")) = tOID
	Quit tOID
}

ClassMethod getURLForCode(pCode As %String = "", pType As %String = "", pDefault As %String = "") As %String
{
	If pCode="" Quit pDefault
	Set tNamespace=$$$OIDMapCacheNS
	Set tURL = $Get(^CacheTemp.OIDMap(tNamespace,"CodeTypeURLIndex",$ZCVT(pCode,"U")))
	If tURL'="" Quit tURL
	// Do not pass pDefault into GetURLForCode, to avoid caching pDefault.
	Set tURL = ##class(HS.Data.OIDMap).GetURLForCode(pCode,pCode)
	// tURL=pCode means URL not found. In that case, use pDefault if provided, and do not cache.
	If tURL=pCode Set:pDefault'="" tURL=pDefault Quit tURL
	Set ^CacheTemp.OIDMap(tNamespace,"CodeTypeURLIndex",$ZCVT(pCode,"U")) = tURL
	Quit tURL
}

ClassMethod getCodeForOID(pOID As %String = "", pType As %String = "", pDefault As %String = "") As %String
{
	If pOID="" Quit pOID
	Set tNamespace=$$$OIDMapCacheNS
	Set tCode = $Get(^CacheTemp.OIDMap(tNamespace,"OIDIndex",pOID))
	If tCode'="" Quit tCode
	// Do not pass pDefault into GetCodeForOID, to avoid caching pDefault.
	Set tCode = ##class(HS.Data.OIDMap).GetCodeForOID(pOID,pOID)
	// tCode=pOID means Code not found. In that case, use pDefault if provided, and do not cache.
	If tCode=pOID Set:pDefault'="" tCode=pDefault Quit tCode
	Set ^CacheTemp.OIDMap(tNamespace,"OIDIndex",pOID) = tCode
	Quit tCode
}

ClassMethod getCodeForURL(pURL As %String = "", pType As %String = "", pDefault As %String = "") As %String
{
	If pURL="" Quit pURL
	Set tNamespace=$$$OIDMapCacheNS
	Set tCode = $Get(^CacheTemp.OIDMap(tNamespace,"URLIndex",pURL))
	If tCode'="" Quit tCode
	// Do not pass pDefault into GetCodeForURL, to avoid caching pDefault.
	Set tCode = ##class(HS.Data.OIDMap).GetCodeForURL(pURL,pURL)
	// tCode=pURL means Code not found. In that case, use pDefault if provided, and do not cache.
	If tCode=pURL Set:pDefault'="" tCode=pDefault Quit tCode
	Set ^CacheTemp.OIDMap(tNamespace,"URLIndex",pURL) = tCode
	Quit tCode
}

ClassMethod getDescriptionForOID(pOID As %String = "", pType As %String = "", pDefault As %String = "") As %String
{
	Set tDescription = ##class(HS.Data.OIDMap).OIDDescription(pOID, pType)
	Quit $Case(tDescription = "", 1:pDefault, :tDescription)
}

ClassMethod getDescriptionForURL(pURL As %String = "", pType As %String = "", pDefault As %String = "") As %String
{
	Set tDescription = ##class(HS.Data.OIDMap).URLDescription(pURL, pType)
	Quit $Case(tDescription = "", 1:pDefault, :tDescription)
}

ClassMethod getSystemOID(pSystem As %String = "") As %String
{
	If (pSystem = "InterSystems")		{ Quit ..getOIDForCode("ISC", "Organization") }
	ElseIf (pSystem = "Cache")			{ Quit ..getOIDForCode("ISC-Cache", "SoftwareProduct") }
	ElseIf (pSystem = "Ensemble")		{ Quit ..getOIDForCode("ISC-Ensemble", "SoftwareProduct") }
	ElseIf (pSystem = "HealthShare")	{ Quit ..getOIDForCode("ISC-HealthShare", "SoftwareProduct") }
	ElseIf (pSystem = "TrakCare")		{ Quit ..getOIDForCode("ISC-TrakCare", "SoftwareProduct") }
	ElseIf (pSystem = "DeepSee")		{ Quit ..getOIDForCode("ISC-DeepSee", "SoftwareProduct") }
	Else { Quit "" }
}

/// Convert a lookup
ClassMethod lookup(table, value) As %String
{
	Set value=$ZSTRIP(value,"<>W")
	
	If table="resultstatus" {
		Quit $S(value="F":"FIN",value="C":"COR",1:"ENT")
	} ElseIf table="idtype" {
		Quit $S("/MR/MRN/PI/"[("/"_value_"/"):"MRN","/SSN/DL/"[("/"_value_"/"):value,1:"OTH")
	} ElseIf table="patientclass" {
		Quit $S("/I/E/O/N/"[("/"_value_"/"):value,1:"O")
	} ElseIf table="orderstatus" {
		Quit $S("/DC/CA/RP/"[("/"_value_"/"):"D",value="HD":"H","/IP/SC/"[("/"_value_"/"):"IP",value="CM":"EXE",1:"INT")
	} Else {
		Quit value
	}
}

/// Lookup an IHE transaction code and return the display name
ClassMethod lookupIHETransaction(pIHETransactionType As %String = "") As %String
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	Try {
		If (pIHETransactionType = "") Set tDisplayString = "Unknown Transaction Type" Quit

		#; IHE-specified transactions
		Set tValues("ITI-1") = "Maintain Time"
		Set tValues("ITI-2") = "Get User Authentication"
		Set tValues("ITI-3") = "Get Service Ticket"
		Set tValues("ITI-4") = "Kerberized Communication"
		Set tValues("ITI-5") = "Join Context"
		Set tValues("ITI-6") = "Change Context"
		Set tValues("ITI-7") = "Leave Context"
		Set tValues("ITI-8") = "Patient Identity Feed"
		Set tValues("ITI-9") = "PIX Query"
		Set tValues("ITI-10") = "PIX Update Notification"
		Set tValues("ITI-11") = "Retrieve Specific Information for Display"
		Set tValues("ITI-12") = "Retrieve Document for Display"
		Set tValues("ITI-13") = "Follow Context"
		Set tValues("ITI-14") = "Register Document Set"
		Set tValues("ITI-15") = "Provide and Register Document Set"
		Set tValues("ITI-16") = "Query Registry"
		Set tValues("ITI-17") = "Retrieve Document"
		Set tValues("ITI-18") = "Registry Stored Query"
		Set tValues("ITI-19") = "Authenticate Node"
		Set tValues("ITI-20") = "Record Audit Event"
		Set tValues("ITI-21") = "Patient Demographics Query"
		Set tValues("ITI-22") = "Patient Demographics and Visit Query"
		Set tValues("ITI-23") = "Find Personnel White Pages"
		Set tValues("ITI-24") = "Query Personnel White Pages"
		Set tValues("ITI-25") = "Send Notification"
		Set tValues("ITI-26") = "Receive Notifications"
		Set tValues("ITI-27") = "Send Acknowledgement"
		Set tValues("ITI-28") = "Receive Acknowledgement"
		Set tValues("ITI-29") = "Cross Enterprise User Authentication"
		Set tValues("ITI-30") = "Patient Identity Management"
		Set tValues("ITI-31") = "Patient Encounter Management"
		Set tValues("ITI-32") = "Distribute Document Set on Media"
		Set tValues("ITI-33") = "Send Document Set"
		Set tValues("ITI-34") = "Retrieve Form"
		Set tValues("ITI-35") = "Submit Form"
		Set tValues("ITI-36") = "Archive Form"
		Set tValues("ITI-37") = "Retrieve Clarifications"
		Set tValues("ITI-38") = "Cross Gateway Query"
		Set tValues("ITI-39") = "Cross Gateway Retrieve"
		Set tValues("ITI-40") = "Provide X-User Assertion"
		Set tValues("ITI-41") = "Provide and Register Document Set-b"
		Set tValues("ITI-42") = "Register Document Set-b"
		Set tValues("ITI-43") = "Retrieve Document Set"
		Set tValues("ITI-44") = "Patient Identity Feed HL7 V3"
		Set tValues("ITI-45") = "PIXV3 Query"
		Set tValues("ITI-46") = "PIXV3 Update Notification"
		Set tValues("ITI-47") = "Patient Demographics Query HL7 V3"
		Set tValues("ITI-48") = "Retrieve Value Set"
		Set tValues("ITI-49") = "Convey Printed Referral Request"
		Set tValues("ITI-50") = "Request Referral"
		Set tValues("ITI-56") = "XCPD Patient Discovery"
		Set tValues("ITI-61") = "Register On-Demand Document"
		
		#; ISC-invented transactions, based on IHE requirements
		Set tValues("IHE-AStart") = "Actor Start"
		Set tValues("IHE-AStop") = "Actor Stop"
		Set tValues("IHE-SA") = "Security Alert"
		Set tDisplayString = $Get(tValues(pIHETransactionType), "Unknown Transaction Type")
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}
	
	Quit $Case($$$ISOK(tStatus), 1:tDisplayString, :$System.Status.GetOneErrorText(tStatus))
}

/// Convert a hexidecimal number to decimal
/// While $ZHEX has a max hex input length of 16, this method
/// has no limit -- only cpu/ram will affect max input length
ClassMethod hex2dec(pHex As %String = "") As %String
{
	For i=1:1:$l(pHex) {
		#;shift
		Set j="" For { Set j=$o(tDigits(j)) Quit:j=""  
			Set tDigits(j)=tDigits(j)*16 
		}
		
		#;increment
		Set tDigits(1)=$g(tDigits(1))+$ZHEX($e(pHex,i))
		
		#;carry
		Set j="" For { Set j=$o(tDigits(j)) Quit:j=""  
			If tDigits(j)>9 {
				Set tDigits(j+1)=$g(tDigits(j+1))+(tDigits(j)\10)
				Set tDigits(j)=tDigits(j)#10
			}
		}
	}
	
	#;convert to string
	If '$d(tDigits) Quit ""
	Set (tDec,i)="" For { Set i=$o(tDigits(i),1,v) Quit:i=""  
		Set tDec=tDigits(i)_tDec 
	}
	q tDec
}

/// Create a generic XML element ID unique for the current transform, with optional prefix
ClassMethod createID(pPrefix As %String = "") As %String
{
	If pPrefix="" Set pPrefix="id"
	Quit pPrefix_..varInc("","_id",pPrefix)
}

ClassMethod uuid2oid(pUUID As %String = "") As %String
{
	#;See IHE ITI 2x: B.6
	Quit "2.25."_..hex2dec($tr(pUUID,"-",""))
}

ClassMethod createUUID() As %String
{
	#;UUID must be lowercase, see IHE ITI 3: 4.1.12.3
	Quit $ZCVT($SYSTEM.Util.CreateGUID(),"L")
}

ClassMethod createOID() As %String
{
	Quit ..uuid2oid(..createUUID())
}

ClassMethod createHL7Timestamp() As %String
{
	#;All XDSb timestamps must be UTC (IHE ITI 3: 4.1.7)
	Quit $TR($P($ZDT($ZTS,3,,3),".",1),"-:TZ ","")
}

/// DEPRECATED -- This method is no longer supported by InterSystems and will be removed
/// 
/// Return the UUID of the previous submission for the given document key, if any
ClassMethod getPreviousUUID(pDocKey As %String = "") As %String
{
	If ##class(HS.IHE.XDSb.Source.Submission).HasPreviousSubmission(pDocKey,.tID,.tUUID) {
		Quit $G(tUUID)
	}
	Quit ""
}

/// Return a registry config value for the given key
ClassMethod getConfigValue(pKey As %String = "") As %String
{
	If pKey]"" {
		Quit ##class(HS.Registry.Config).GetKeyValue(pKey)
	}
	Quit ""
}

/// Return the most specific registry config value for the given root and children
/// For example here are some outputs given the following keys:
/// 		\a     = apple
///   \a\b   = banana
/// 		\a\b\c = carrot
///   \a\\c  = cucumber
/// getHierarchialConfigValue("\a",,,"b","c") -> carrot
/// getHierarchialConfigValue("\a",,,"b")     -> banana
/// getHierarchialConfigValue("\a",,,"x","y") -> apple
/// getHierarchialConfigValue("\a",,,"","c")  -> cucumber
/// 
/// This is used by the XDSb Document metadata generator transform to allow overriding coded entries (aka Classifications) based on context
ClassMethod getHierarchicalConfigValue(pKey As %String = "", Args...) As %String
{
	Set tReturn = ##class(HS.Registry.Config).GetKeyValue(pKey)
	For i=3:1:$G(Args) {
		Set pKey = pKey _ "\" _ $G(Args(i))		
		Kill tValue,tID
		Do ##class(HS.Registry.Config).FindByName(pKey, .tValue, .tID)
		If tID]"" Set tReturn = tValue
	}
	Quit tReturn
}

/// Return the most specific coded entry XSL nodes for the given coded entry type as code^desc^scheme
ClassMethod getCodedEntryConfig(pCodeType As %String = "", Args...) As %String
{
	Set tConfigValue = ..getHierarchicalConfigValue("\IHE\XDSb\"_pCodeType, Args...)
	If tConfigValue ] "" {
		Set tCode = $P(tConfigValue,"^",1)	
		Set tDesc = $P(tConfigValue,"^",2)	
		Set tScheme = $P(tConfigValue,"^",3)	
		
		If (tCode="")||(tScheme="") {
			$$$LOGWARNING("Configuration registry value for "_pCodeType_" must specify code and scheme")
		}
		ElseIf '##class(HS.IHE.CodedEntry).UniqueIndexExists(pCodeType,tScheme,tCode,.tConfigID) {
			$$$LOGWARNING("Configured "_pCodeType_" does not exist: "_tCode_"/"_tScheme)
		}
		Else {
			If tDesc = "",tConfigID]"" {
				Set tDesc = ##class(HS.IHE.CodedEntry).DescriptionGetStored(tConfigID)
				Set tConfigValue = tCode_"^"_tDesc_"^"_tScheme
			} 
		}
	}
	Quit tConfigValue
}

/// Return a registry service name given an oid
ClassMethod getServiceNameFromOID(pOID As %String = "", pOIDType As %String = "", pFunction As %String = "", pServiceType As %String = "") As %String
{
	#dim tEP As HS.Registry.Service.Abstract
	Set tName = ""
	Try {
		Set:pServiceType="" pServiceType="SOAP"
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForOID(pOID,pOIDType,pFunction,pServiceType,.tSC) $$$ThrowOnError(tSC)
		If $IsObject(tEP) Set tName = tEP.Name
	} Catch ex { $$$LOGSTATUS(ex.AsStatus()) }
	Quit tName
}

/// Return a registry service host given an oid
ClassMethod getServiceHostFromOID(pOID As %String = "", pOIDType As %String = "", pFunction As %String = "", pServiceType As %String = "") As %String
{
	#dim tEP As HS.Registry.Service.Abstract
	Set tHost = ""
	Try {
		Set:pServiceType="" pServiceType="SOAP"
		Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForOID(pOID,pOIDType,pFunction,pServiceType,.tSC) $$$ThrowOnError(tSC)
		If $IsObject(tEP) Set tHost = tEP.Host
	} Catch ex { $$$LOGSTATUS(ex.AsStatus()) }
	Quit tHost
}

/// Return a domain and URL (e.g., http://host:port/url) given an OID
ClassMethod getServiceURLFromOID(pOID As %String = "", pOIDType As %String = "", pFunction As %String = "", pServiceType As %String = "") As %String
{
	#dim tEP As HS.Registry.Service.Abstract
	Set tURL = ""
	Try {
		Set:pServiceType="" pServiceType="SOAP"
		Set tEP = ##class(HS.Registry.Service.Abstract).EndPointForOID(pOID,pOIDType,pFunction,pServiceType,.tSC) $$$ThrowOnError(tSC)
		If $IsObject(tEP) {
			Set tHTTP = $Select(tEP.SSLConfig'="":"https://",1:"http://")
			Set tPort = $Select(tEP.Port'="":":"_tEP.Port,1:"")
			Set tURL = tHTTP_tEP.Host_tPort_tEP.URL
		}
	} Catch ex { $$$LOGSTATUS(ex.AsStatus()) }
	Quit tURL
}

/// Return a registry service name given an URL
ClassMethod getServiceNameFromURL(pURL As %String = "") As %String
{
	Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForURL(pURL)
	If $IsObject(tEndPoint)	Quit tEndPoint.Name
	Quit ""
}

/// Return a registry service OID given an URL
ClassMethod getServiceOIDFromURL(pURL As %String = "") As %String
{
	#dim tEndPoint As HS.Registry.Service.SOAP
	Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForURL(pURL)
	If $IsObject(tEndPoint)	{
		Set tOID = ""
		For i="Device","Repository","HomeCommunity" {
			If tEndPoint.OIDMapCode.IsDefined(i) {
				Set tCode= tEndPoint.OIDMapCode.GetAt(i)
				Set tOID = ##class(HS.Data.OIDMap).OIDForType(tCode,i,"")
				If tOID]"" Quit
			}
		}
		Quit tOID
	}
	Quit ""
}

/// Turn an arg list into a variable name and optionally a value
ClassMethod varArgsToNameValue(pHasValue As %Boolean = 0, ByRef pName As %String, Args...) As %String
{
	#; Start with the variable cache name
	If $Get(pName)="" Set pName="%HSUtilXSLTHelper"
	
	#; Add subscripts, ignorning value if appropriate 
	#; Append " " to ensure non-null subscript
	For i=2:1:($G(Args)-pHasValue) {
		Set pName=pName_$s(pName["(":",",1:"(")
		Set pName=pName_""" "_$G(Args(i))_""""
	}
	If pName["(" Set pName=pName_")"
	
	#; Return the last arg if there is a value, "" otherwise
	Quit $S(pHasValue:$G(Args($G(Args))),1:"")
}

/// Clear the variable cache. Call before each transform either from code or the XSL itself
ClassMethod varReset() As %String
{
	Quit ..varKill()
}

/// Kill a variable in the cache.
ClassMethod varKill(Args...) As %String
{
	Do ..varArgsToNameValue(0,.tVar)
	Kill @tVar
	Quit ""
}

/// Set a variable in the cache
ClassMethod varSet(Args...) As %String
{
	Set tValue=..varArgsToNameValue(1,.tVar,Args...)
	Set @tVar=tValue
	Quit tValue
}

/// Get a variable
ClassMethod varGet(Args...) As %String
{
	Do ..varArgsToNameValue(0,.tVar,Args...)
	Quit $G(@tVar)
}

/// Increment a variable
ClassMethod varInc(Args...) As %String
{
	Do ..varArgsToNameValue(0,.tVar,Args...)
	Quit $I(@tVar)
}

/// Check for data in a var
ClassMethod varData(Args...) As %String
{
	Do ..varArgsToNameValue(0,.tVar,Args...)
	Quit $D(@tVar)
}

/// Concatenate a value onto a variable in the cache
ClassMethod varConcat(Args...) As %String
{
	Set tValue=..varArgsToNameValue(1,.tVar,Args...)
	Set @tVar=$G(@tVar)_tValue
	Quit @tVar
}

/// Merge the variable cache into a debug global
ClassMethod varDebug(Args...) As %String
{
	Set tGlobal=$G(Args(2))
	If tGlobal]"" {
		Do ..varArgsToNameValue(0,.tVar)
		Set %=$i(@tGlobal)
		Merge @tGlobal@(%)=@tVar
	}
	Quit ""
}

/// Create a valid URL
ClassMethod makeURL(Args...) As %String
{
	Set tURL=Args(2)
	Set tDelim="?"
	For i=3:2:Args {
		Set tURL=tURL_tDelim_Args(i)_"="_$ZCVT($G(Args(i+1)),"O","URL")
		Set tDelim="&"
	}
	Quit tURL
}

/// Work around for bug in viewer that looses documents with same date/time over different encounters
/// It will return a unique timestamp for the current transform as close to the input timestamp as possible
ClassMethod getUniqueTime(pKey As %String = "", pValue As %String) As %String
{
	Set tValue=pValue,i=0
	
	#; keep adding 1ms to the time value until it hasn't been seen
	#; bail if we would move to the next second
	while ..varData(pKey,tValue) {
		Set i=i+1 If i>999 Quit  
		Set tValue=$p(pValue,"Z",1)_"."_$tr($j(i,3)," ",0)_"Z"
	}
	
	#; mark this value as seen
	Do ..varSet(pKey,tValue,1)
	
	Quit tValue
}

/// Convert xmltimestamp with offset to timestamp with UTC
ClassMethod xmltimestampToUTC(pDateTime) As %String
{
	#; if not a full date return what we are given
	Quit:$l(pDateTime)<8 pDateTime
	Set dt=$zdh($e(pDateTime,1,8),8),tm=$e(pDateTime,9,*)
	#; return the same precision as given
	Set offsetpos=$f(pDateTime,"-") set:'offsetpos offsetpos=$f(pDateTime,"+")
	#; if no offset return what we are given
	If 'offsetpos Quit pDateTime
	Set len=$s('offsetpos:$l(pDateTime),1:offsetpos-2)

	Set offset=$e(pDateTime,offsetpos-1,*),tm=$e(pDateTime,9,offsetpos-2),offset=$e(offset)_($e(offset,2,3)*3600+($e(offset,4,5)*60))
	Set tm=$zth($e(tm,1,2)_":"_$e(tm_"00",3,4)_":"_$e(tm_"00",5,6)),tm=tm-offset s:tm<0 tm=86400-tm,dt=dt-1 s:tm>86399 tm=tm-86400,dt=dt+1
	Quit $E($zd(dt,8)_$tr($zt(tm),":"),1,len)
}

/// Method to return the contents of a quickstream.  For security purposes, the stream ID
/// must be one explictly labeled as one to be passed into here, starting with TXSLTHelper
/// (perhaps followed by $J)
ClassMethod getQuickStream(pStreamId) As %String
{
	Quit:pStreamId'?1"TXSLTHelper".E ""
	Set tStream=##class(HS.SDA3.QuickStream).%OpenId(pStreamId)
	Quit:'$IsObject(tStream) ""
	Do tStream.Rewind()
	Quit ##class(%XML.XSLT.StreamAdapter).%New(tStream)
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
/// getMeasuresTemplates returns a vertical bar-delimited string
/// of the templateId OIDs for the Quality Measures specified
/// in a vertical bar-delimited input string.
ClassMethod getMeasuresTemplates(pMeasureCodes As %String = "") As %String
{
	If $Translate(pMeasureCodes,"|")="" Quit ""
	Set tTemplates = ""
	For i = 1:1:$Length(pMeasureCodes,"|") Set tTemplates = tTemplates_..getMeasureTemplates($Piece(pMeasureCodes,"|",i))
	// De-duplicate the Ids before returning.
	For i = 1:1:$Length(tTemplates,"|") Set tP = $Piece(tTemplates,"|",i) If tP'="" Set tArr(tP)=""
	Set tTemplates = ""
	Set tP = "" For  Set tP = $Order(tArr(tP)) Quit:tP=""  Set tTemplates = tTemplates_"|"_tP
	If tTemplates'="" Set tTemplates = tTemplates_"|"
	Quit tTemplates
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
/// getMeasureTemplates returns a vertical bar-delimited string
/// of the templateId OIDs for a the specified Quality Measure.
ClassMethod getMeasureTemplates(pMeasureCode As %String = "") As %String
{
	If $Translate(pMeasureCode,"|")="" Quit ""
	Set tObj = ##class(HS.Registry.QualityMeasure).ObjectForCode(pMeasureCode)
	If '$IsObject(tObj) Quit ""
	Set tTemplates = ""
	For j = 1:1:tObj.TemplateIds.Count() Set tTemplates = tTemplates_"|"_tObj.TemplateIds.GetAt(j)
	If tTemplates'="" Set tTemplates = tTemplates_"|"
	Quit tTemplates
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
/// getMeasuresHeaderInfo takes a vertical bar-delimited string of Measure Codes
/// and returns an XML representation of all of the specified Measures.
ClassMethod getMeasuresHeaderInfo(pMeasureCodes As %String = "") As %String
{
	If $Translate(pMeasureCodes,"|")="" Quit ""
	Set tMeasuresInfo = ""
	For i = 1:1:$Length(pMeasureCodes,"|") Set tMeasuresInfo = tMeasuresInfo_..getMeasureHeaderInfo($Piece(pMeasureCodes,"|",i))
	Quit tMeasuresInfo
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
ClassMethod getMeasureHeaderInfo(pMeasureCode As %String = "") As %String
{
	If $Translate(pMeasureCode,"|")="" Quit ""
	
	Set tMeasureInfo = ""
	
	Set tObj=##class(HS.Registry.QualityMeasure).CodeIndexOpen(pMeasureCode)
	If '$IsObject(tObj) Quit ""
	
	Set tMeasureInfo = "Code!"_tObj.Code
	Set tMeasureInfo = tMeasureInfo_"^VersionSpecificId!"_$Translate(tObj.VersionSpecificId,$Char(0))
	Set tMeasureInfo = tMeasureInfo_"^NQFNumber!"_$Translate(tObj.NQFNumber,$Char(0))
	Set tMeasureInfo = tMeasureInfo_"^Title!"_$Translate(tObj.Title,$Char(0))
	Set tMeasureInfo = tMeasureInfo_"^AuthoringToolIdExtension!"_$Translate(tObj.AuthoringToolIdExtension,$Char(0))
	Set tMeasureInfo = tMeasureInfo_"^VersionNeutralId!"_$Translate(tObj.VersionNeutralId,$Char(0))
	Set tMeasureInfo = tMeasureInfo_"^VersionNumber!"_$Translate(tObj.VersionNumber,$Char(0))
	Set tMeasureInfo = tMeasureInfo_"^|"
	
	Quit tMeasureInfo
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
/// getMeasuresSetIds returns the setIds (aka Version Neutral Id) for
/// the specified Measures in a vertical bar-delimited string.
ClassMethod getMeasuresSetIds(pMeasureCodes As %String = "") As %String
{
	If $Translate(pMeasureCodes,"|")="" Quit ""
	Set tSetIds = ""
	For i = 1:1:$Length(pMeasureCodes,"|") Set tSetIds = tSetIds_..getMeasureSetId($Piece(pMeasureCodes,"|",i))_"|"
	Quit tSetIds
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
ClassMethod getMeasureSetId(pMeasureCode As %String = "") As %String
{
	If $Translate(pMeasureCode,"|")="" Quit ""
	
	Set tObj=##class(HS.Registry.QualityMeasure).CodeIndexOpen(pMeasureCode)
	If '$IsObject(tObj) Quit ""
	
	Set tSetId = $Translate(tObj.VersionNeutralId,$Char(0))
	
	Quit tSetId
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
/// getValueSetOIDs returns a vertical bar-delimited string of OIDs
/// for the values sets in which pCode+pCodeSystem are found for the
/// specified quality measures.  pMeasures is a vertical bar-delimited
/// string of measure Version Neutral Ids (aka setIds).
ClassMethod getValueSetOIDs(pCode As %String = "", pCodeSystem As %String = "", pMeasureIds As %String = "") As %String
{
	Set tValueSetOIDs = ""
	
	Set tStatement = ##class(%SQL.Statement).%New()
	Set tStatement.%SelectMode=2
	Set tQuery = "SELECT ValueSetOID,MeasureId FROM HS_Data.ValueSet WHERE ConceptCode=? AND ConceptCodeSystem=?"
	Set tStatus = tStatement.%Prepare(tQuery)
	Set tResultSet = tStatement.%Execute(pCode, pCodeSystem)
	While tResultSet.%Next() {
		Set tO = tResultSet.ValueSetOID
		If $Data(tOIDs(tO))=0 {
			If $Translate(pMeasureIds,"|")="" Set tValueSetOIDs = tValueSetOIDs_tO_"|" Set tOIDs(tO)=""
			If pMeasureIds[("|"_tResultSet.MeasureId_"|") Set tValueSetOIDs = tValueSetOIDs_tO_"|" Set tOIDs(tO)=""
		}
	}
	Kill tResultSet
	Kill tStatement
	
	/*
	Set tP = ""
	For {
		Set tP = $Order(^HS.ValueSet(pCode,pCodeSystem,tP))
		If tP="" Quit
		Set tO = ""
		For {
			Set tO = $Order(^HS.ValueSet(pCode,pCodeSystem,tP,tO))
			If tO="" Quit
			If $Data(tOIDs(tO))=0 {
				If $Translate(pMeasureIds,"|")="" Set tValueSetOIDs = tValueSetOIDs_tO_"|"
				If pMeasureIds[("|"_tResultSet.MeasureId_"|") Set tValueSetOIDs = tValueSetOIDs_tO_"|"
			}
			Set tOIDs(tO)=""
		}
	}
	*/
	
	Kill tStatement
	
	Quit tValueSetOIDs
}

/// *** THIS METHOD, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.<br>
/// <br>
ClassMethod setHSValueSetEntry(pValueSetOID, pValueSetName, pValueSetVersion, pConceptCode, pConceptCodeSystem, pConceptCodeSystemVersion, pConceptDescription, pMeasureId) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tObj = ##class(HS.Data.ValueSet).%New()
		Set tObj.ConceptCode = pConceptCode
		Set tObj.ConceptCodeSystem = pConceptCodeSystem
		Set tObj.ConceptCodeSystemVersion = pConceptCodeSystemVersion
		Set tObj.ConceptDescription = pConceptDescription
		Set tObj.ValueSetName = pValueSetName
		Set tObj.ValueSetOID = pValueSetOID
		Set tObj.ValueSetVersion = pValueSetVersion
		Set tObj.MeasureId = pMeasureId
		Set tSC = tObj.%Save()
		
		//Set ^HS.ValueSet(pConceptCode,pConceptCodeSystem,pMeasureId,pValueSetOID)=""
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
