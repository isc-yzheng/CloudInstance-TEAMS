/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Functions for DataGate
Class EnsLib.InteropTools.HL7.eGate.Functions Extends Ens.Rule.FunctionSet
{

Parameter MONKDUPLICATESTRIP = "MonkDuplicateStrip";

Parameter MONKFORMAT = "MonkFormat";

Parameter MONKREGEX = "MonkRegexMatch";

Parameter MONKEXTRACT = "MonkExtract";

Parameter MONKSTARTEND = "MonkGetStartEnd";

Parameter MONKDATEDIFF = "MonkDateDiff";

Parameter MONKTIMEFORMAT = "MonkTimeFormat";

Parameter MONKCHANGEPATTERN = "MonkChangePattern";

Parameter MONKMAKESTRING = "MonkMakeString";

/// Create a string based on a number of repetitions of a string
ClassMethod MonkMakeString(pReps, pString) As %String
{
	Set tString = ""
	Set $Piece(tString,pString,pReps+1)=""
	Quit tString
}

/// Take the <var>value</var> and apply the MonkFormat
/// "%<flag><width>.<precision>[alt format]<C>"
ClassMethod MonkFormat(value = "", format = "") As %String
{
	If $e(format)'="%" Quit value
	//"%-7s"
	//"%012d"
	//"%05d"
	Set tFormat = $E(format,2,*)
	For {
		/*
		- Output is left aligned.
		+ A sign (+ or -) always precedes output.
		space If the first character to be output is not a sign (+ or -), a space character is prefixed. Only one space is allowed in a format specification.
		0 Numbers are right-aligned and padded with leading zeros. 
		# Output includes a decimal point.
		*/
		Quit:"-+ 0#"'[$E(tFormat)
		Set tFlags($E(tFormat))=""
		Set tFormat=$E(tFormat,2,*)
	}
	Set tWidth=""
	For {
		Quit:$E(tFormat)'?1N
		Set tWidth=tWidth_$E(tFormat)
		Set tFormat=$E(tFormat,2,*)
	}
	Set tPrecision=""
	If $E(tFormat)="." {
		Set tFormat=$E(tFormat,2,*)
		For {
			Quit:$E(tFormat)'?1N
			Set tPrecision=tPrecision_$E(tFormat)
			Set tFormat=$E(tFormat,2,*)
		}
	}
	Set tDataType = $zcvt($E(tFormat,*),"l"),tFormat=$E(tFormat,1,*-1)
	If tFormat]"" {
		Set tAltFormat = tFormat
	}
	Set tValue=value
	If "xbo*"[tDataType throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Unhandled datatype in MonkFormat "_tDataType)) 
	If tDataType = "d" {
		If $D(tFlags("0")) {
			Set tLength = $Select($length(value)>tWidth:$length(value),1:tWidth)
			Set $p(tPad,"0",tLength+1)=""
			Set tValue=$Extract(tPad_value,*-tLength+1,*)
		} ElseIf $D(tFlags("-")) {
			Set tLength = $Select($length(value)>tWidth:$length(value),1:tWidth)
			Set $p(tPad," ",tLength+1)=""
			Set tValue=$Extract(value_tPad,1,tLength)
		}
	} ElseIf tDataType="s" {
		If $D(tFlags("-")) {
			Set tLength = $Select($length(value)>tWidth:$length(value),1:tWidth)
			Set $p(tPad," ",tLength+1)=""
			Set tValue=$Extract(value_tPad,1,tLength)
		}
	}
	Quit tValue
}

/// Copies leaf data from the source-path to the corresponding leaf positions of the destination structured event, after removing trailing spaces for data at the leaf to be duplicated. Leaf data is contained in nodes without children. This function overwrites any existing data in the leaf locations.
ClassMethod MonkDuplicateStrip(pSource, pTarget, pFormat)
{
	x "not implemented"
}

ClassMethod MonkDateDiff(pDate1 As %String, pDate2 As %String) As %Integer [ CodeMode = expression ]
{
$SYSTEM.SQL.DATEDIFF("D",pDate1,pDate2)
}

/// Returns a Monk specific version of the regex $match(value,match), if there are no special characters execute a contains instead
ClassMethod MonkRegexMatch(value, match) As %Integer
{
	/// apparently Monk would do a contains if there were no special instructions, so use this list of instructions to determine whether there are any special instructions if not append .*{text}.*
	If $TR(match,"?$.^{}()+\?<>|\")=match {
		Quit value[match
	} Else {
		try {
			Return $match(value,match)
		} Catch ex {
			$$$ThrowOnError($$$ERROR($$$GeneralError,"REGULAR EXPRESSION: value:"_value_" match:"_match ))
		}
	}
}

ClassMethod MonkExtract(pValue = "", pPositions = "") As %String
{
	Do ..MonkGetStartEnd(pPositions,.tStart,.tEnd)
	If tEnd="*" {
		Quit $E(pValue,tStart,*)
	} Else {
		Quit $E(pValue,tStart,tEnd)
	}
}

/// Called from within this class and also from CodeWalkcopy-strip
ClassMethod MonkGetStartEnd(pPositions, ByRef pStart, ByRef pEnd)
{
	Set pPositions = $zstrip(pPositions,"<>",$c(34))
	For tDelim = ",","-" {
		Set pStart = $p(pPositions,tDelim)
		Quit:pStart'=pPositions
	}
	Set pStart = pStart+1
	Set tEnd = $p(pPositions,tDelim,2)
	If tEnd = "END" || (tEnd="") {
		Set pEnd = "*"
	} Else {
		/// For , start,length 4,2 want $Extract(value,4,6) (start,start+len-1), but 4-10, we want to go to the end
		Set pEnd = $S(tDelim=",":pStart-1,1:0) + tEnd
	}
}

ClassMethod MonkTimeFormat(pFormat = "", pDate = {$H}) As %String
{
	New %item,%value
	Set tNow8 = $tr($ZDT(pDate,8),": ")
	
	Set tItems = ""
	Set tTimeStamp = ""
	Set tFormat = $zstrip(pFormat,"<>",$C(34))
	If tFormat = "" Quit tNow8
	Set tLastPos=0
	For {
		Set tPos = $Find(tFormat,"%",tLastPos)
		Quit:'tPos
		Set tTimeStamp = tTimeStamp _ $E(tFormat,tLastPos,tPos-2)
		Set tLastPos = tPos+1
		Set tItem = $E(tFormat,tPos)
		
		kill value
		If tItem="Y" {
			Set value = $E(tNow8,1,4)
		} ElseIf tItem="y" {
			Set value = $E(tNow8,3,4)
		} ElseIf tItem="j" {
			Set value = $ZD(pDate,14)
		} ElseIf tItem="m" {
			Set value = $E(tNow8,5,6)
		} ElseIf tItem="d" {
			Set value = $E(tNow8,7,8)
		} ElseIf tItem="H" {
			Set value = $E(tNow8,9,10)
		} ElseIf tItem="M" {
			Set value = $E(tNow8,11,12)
		} ElseIf tItem="S" {
			Set value = $E(tNow8,13,14)
		} Else {
			break  /// unknown tItem throw an error
		}
		Set tTimeStamp = tTimeStamp_value
	}
	Quit tTimeStamp
}

/// pInput - input string to be evaluated
/// pParams - repeating values of match string, matchvalue, match string, match value
/// returns updated string
ClassMethod MonkChangePattern(pInput, pParams...) As %String
{
	Set tResponse = pInput
	For tIdx = 1:2:$g(pParams) {
		Set tPattern = pParams(tIdx)
		If '$D(pParams(tIdx+1)) $$$ThrowOnError($$$ERROR($$$GeneralError,"Unmatched output for Change-Pattern"))
		Set tOutputString = pParams(tIdx+1)
		set tMatcher=##class(%Regex.Matcher).%New(tPattern)
		Set tMatcher.Text = tResponse
		Set tResponse = tMatcher.ReplaceAll(tOutputString)
	}
	Quit tResponse
}

}
