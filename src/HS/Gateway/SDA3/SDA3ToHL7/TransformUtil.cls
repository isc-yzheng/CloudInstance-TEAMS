/// Common MU2 Tranform Utilities
Class HS.Gateway.SDA3.SDA3ToHL7.TransformUtil Extends Ens.Util.FunctionSet
{

/// Return Date time in YYYYMMDDhhmmss format
ClassMethod DateTime(pHorolog As %String = {$H}, pNoSecs As %Boolean = 0) As %String
{
	Set tDateTime=$Translate($ZdateTime(pHorolog,8)," :")
	If pNoSecs {
		Set retVal=$Extract(tDateTime,1,12)
	} Else {
		Set retVal=$Extract(tDateTime,1,14)_"+0000"
	}
	Quit retVal
}

/// Get date in format YYYYMMDD from XML Date Stamp (yyyy-mm-ddThh:mm:ssZ)
ClassMethod XMLTimeStampToDate(pDate As %String = "") As %String
{
	If pDate'="" {
		Set retVal=$Extract($Translate($Piece(pDate,"T"),"-\ "),1,8)
	} Else {
		Set retVal=""
	}
	Quit retVal
}

/// Get date in format YYYYMMDDHHMMSS from XML Date Stamp (yyyy-mm-ddThh:mm:ssZ)
ClassMethod XMLTimeStampToDateTime(pDateTime As %String = "") As %String
{
	Set sDate=..XMLTimeStampToDate(pDateTime)
	Set sTime=$E($Translate($Piece(pDateTime,"T",2),":Z",""),1,6)
	Set sTimezone="-"_$Piece($Piece(pDateTime,"T",2),"-",2)
	Set:sTimezone="-" sTimezone="+"_$Piece($Piece(pDateTime,"T",2),"+",2)
	Set:sTimezone'="+" sTimezone=$Translate(sTimezone,":","")
	Set:sTimezone'="+" sTime= sTime_sTimezone
	Quit (sDate_sTime)
}

/// Get Part of a phone number
ClassMethod PhonePart(pType As %String = "Local", pNumber As %String = "") As %String
{
	Set (retVal,tNumber)=$Piece(pNumber,",")
	// Remove ": " part
	If tNumber[": " {
		Set tNumber=$Piece(tNumber,": ",2)
	}
	// Remove Country code
	If $Extract(tNumber)="+" {
		If pType="Country" {
			Set retVal=$Translate($Piece(tNumber," "),"+","")
		} Else {
			Set tNumber=$Piece(tNumber," ",2,99)
		}
	} ElseIf pType="Country" {
		Set retVal=""
	}
	Set tNumber=$ZStrip($Translate(tNumber,")~(^","--"),"*W")
	If tNumber["-" {
		If pType="Area" {
			Set retVal=$Piece($Piece(tNumber,"-"),"x",1)
		} ElseIf pType="Local" {
			Set retVal=$Piece($Piece(tNumber,"-",2),"x",1)
		} ElseIf pType="Extension" {
			Set retVal=$Piece(tNumber,"x",2)
			If retVal=";" {
				Set retVal =""
			}
		}
	}
	Quit retVal
}

/// Given a string value that originated as an HL7 structured numeric (SN)<br>
/// type, return the original SN value. The format of the SN structure is:<br>
/// <pre>
/// SEQ  LEN  DT  OPT  TBL#  COMPONENT NAME  COMMENTS  SEC.REF.
/// 1    2    ST  O          Comparator                2.A.74
/// 2    15   NM  O          Num1                      2.A.47
/// 3    1    ST  O          Separator/Suffix          2.A.74
/// 4    15   NM  O          Num2                      2.A.47
/// </pre>
/// <br>
/// As per the HL7 spec, the comparator, if populated, must be one of >, <, >=,<br>
/// <=, =, or <>. The separator/suffix, if populated, must be one of -, +, /,<br>
/// or :. The HL7 spec lists "." as a possible separator, however this method<br>
/// cannot parse that correctly since Num1 and Num2 are both numeric fields and<br>
/// therefore can contain decimals. Note that a positive or negative sign (+ or<br>
/// -) at the beginning of either Num1 or Num2 will be handled correctly.
ClassMethod StructuredNumeric(pOrigVal As %String, pSeparator As %String = "^") As %String
{
	set (tComparator,tNum1,tSeparatorSuffix,tNum2)=""
	// original value may be XML-encoded
	set pOrigVal = $ZCVT(pOrigVal, "I", "XML")
	
	// special considerations:
	// one or both numbers may contain a decimal
	// one or both numbers may be negative
	// one or both numbers may have a positive sign
	
	// find comparator
	// check if first two chars are the comparator
	if (",>=,<=,<>," [ (","_$E(pOrigVal,1,2)_",")) {
		set tComparator = $E(pOrigVal,1,2)
		set tNum1Start = 3
	}
	// check if first char is the comparator
	elseif ("><=" [ $E(pOrigVal,1)) {
		set tComparator = $E(pOrigVal,1)
		set tNum1Start = 2
	}
	// else there is no comparator
	else { set tNum1Start = 1 }
	
	set tSepIdx=""
	// find separator/suffix
	for tI=tNum1Start:1:$L(pOrigVal) {
		set tChar = $E(pOrigVal,tI)
		if ("-+/:" [ tChar) {
			// num1 can begin with + or -
			if ((tI=tNum1Start) && ("-+"[tChar)) { continue }
			// otherwise separator has been found
			else { set tSepIdx=tI quit }
		}
	}
	if (tSepIdx'="") {
		set tNum1 = $E(pOrigVal,tNum1Start,tSepIdx-1)
		set tSeparatorSuffix = $E(pOrigVal,tSepIdx)
		set tNum2 = $E(pOrigVal,tSepIdx+1,$L(pOrigVal))
	}
	else { set tNum1 = $E(pOrigVal,tNum1Start,$L(pOrigVal)) }
	// strip trailing separators from final value
	quit $ZSTRIP(tComparator_pSeparator_tNum1_pSeparator_tSeparatorSuffix_pSeparator_tNum2, ">", pSeparator)
}

/// DEPRECATED - Use <method>StructuredNumeric</method> instead.
ClassMethod StructuredResultValue(pResultValue As %String) As %String
{
	Set (Comp,Num1,Sep,Num2,tVal,tNum)=""
	
	// Possible Comparator values: <>, <=, >=, <, >, =
	// Default to = if no value
	
	If $Find(pResultValue,"<>") {
		Set Comp = "<>"
		Set tNum = $p(pResultValue,"<>",2)
	}
	ElseIf $Find(pResultValue,"<=") {
		Set Comp = "<="
		Set tNum = $p(pResultValue,"<=",2)
	}
	ElseIf $Find(pResultValue,">=") {
		Set Comp = ">="
		Set tNum = $p(pResultValue,">=",2)
	}
	ElseIf $Find(pResultValue,"<") {
		Set Comp = "<"
		Set tNum = $p(pResultValue,"<",2)
	}
	ElseIf $Find(pResultValue,">") {
		Set Comp = ">"
		Set tNum = $p(pResultValue,">",2)
	}
	ElseIf $e(pResultValue,1) = "=" {
		Set Comp = "="
		Set tNum = $p(pResultValue,"=",2)
	}
	
	If Comp="" { Set tNum = pResultValue }
	
	If $Length(tNum,":")=2 Set Sep = ":"
	If $Length(tNum,"/")=2 Set Sep = "/"
	
	// Make sure the only "-" isn't the sign for the number, and is an actual separator
	If ($Length(tNum,"-")=2)&&($e(tNum,1)'="-") Set Sep = "-"
		
	// Set Num2, Will overwrite if needed

	If Sep="" {
		Set Num1 = tNum
	}
	Else {
		Set Num1 = $p(tNum,Sep,1)
		Set Num2 = $p(tNum,Sep,2)
	}
	
	// Special Case #1: "-" as both separator and sign for the number
	// Extract the numbers, and manually add sign
	If $Length(tNum,"-")=3 {
		Set Sep = "-"
		Set Num1 = "-"_$p(tNum,"-",2)
		Set Num2 = $p(tNum,"-",3)
	}
	
	// Special Case #2: "." used as both a decimal and a separator
	// Manually build the numbers
	If $Length(tNum,".")=3 {
		Set Sep = "."
		// Handle case of "." as a separator and a decimal
		Set Num1 = $p(tNum,".",1)_"."_$p(tNum,".",2)
		Set Num2 = $p(tNum,".",3)
	}
	
	// If Comp is empty, set it to "=" as the default
	Set:Comp="" Comp = "="
	Set Value = Comp_"^"_Num1
	// If there is a separator, add it and the second number to Value and return
	If Sep'="" Set Value=Value_"^"_Sep_"^"_Num2
	q Value
}

}
