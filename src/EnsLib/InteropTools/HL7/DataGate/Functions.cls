/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Functions for DataGate
Class EnsLib.InteropTools.HL7.DataGate.Functions Extends EnsLib.InteropTools.HL7.eGate.Functions
{

Parameter MONKSTANDARDDATE = "MonkStandardDate";

Parameter MONKUNIQUEID = "MonkUniqueId";

Parameter MONKMAKEVECTOR = "MonkMakeVector";

Parameter MONKCHECKDIGIT = "MonkRegexMatch";

Parameter MONKTOHL7TIME = "MonkToHL7Time";

Parameter MONKTOHL7DATE = "MonkToHL7Date";

Parameter MONKCEILING = "MonkCeiling";

ClassMethod MonkCeiling(pValue)
{
	Quit $System.SQL.CEILING(pValue)
}

/// Create a string based on a number of repetitions of a string
ClassMethod MonkStandardDate(pDate) As %Boolean
{
    /// return internal date or "" for error
    Quit +$zdh(pDate,8,,,,,,,"")
}

/// Since precision is only available in $ZTIMESTAMP which is UTC we need to figure out the offset and calculate from there
ClassMethod MonkUniqueId(pPrecision = 2) As %String
{
    Set tOffSet = $Extract($zdt($H,8,5),*-5,*)
    Set tOffSetHR = $Piece(tOffSet,":")
    Set tOffSetMIN = $p(tOffSet,":",2)
    Set tOff = ($zabs(tOffSetHR) * 3600) + (tOffSetMIN*60)
    If tOffSetHR<0 Set tOff=tOff*-1
    Set tNow = $ZTimestamp
    Set tNowSec = tNow*86400 + $p(tNow,",",2) + tOff
    Set tNowUpd = tNowSec\86400 _","_ (tNowSec#86400) //_"."_$p(tNow,".",2)
    Quit $TR($ZDT(tNowUpd,8,,pPrecision),".: ")
    /// It's likely close enough to just use the milliseconds from $ztimestamp
    ///  Quit $TR($ZDT($H_$P($ZTIMESTAMP,".",2),8,,2),".: ")
}

ClassMethod MonkMakeVector(pNum, pFill) As %String
{
    Set tVariable=""
    For tIdx = 1:1:pNum {
        If $D(pFill) {
            Set tVariable=tVariable_$LB(pFill)
        } Else {
            Set tVariable = tVariable _$LB()
        }
    }
    Quit tVariable
}

/// 
/// ;
/// ; SYNOPSIS: Computes the Mod10 or Mod11 (et. al.?) with 3 different
/// ;           variations (A, B, C), as shown below:
/// ;
/// ;           Compute the M10 check digit of 201535768 with all 3 variations:
/// ;
/// ;      A     2  0  1  5  3  5  7  6  8
/// ;         * 10  9  8  7  6  5  4  3  2             (multiply by increaing factors starting
/// ;         ----------------------------             with 2 for the LOW order digit)
/// ;           20  0  8 35 18 25 28 18 16  (168 sum)  (sum the products)
/// ;
/// ;         now, 10 - (168 mod 10) = (10 - 8) = 2 check digit 
/// ;
/// ;      B     2  0  1  5  3  5  7  6  8
/// ;          * 1  2  1  2  1  2  1  2  1             (multiply by alternating 1 and 2
/// ;          ---------------------------             starting with the HIGH order digit)
/// ;            2  0  1 10  3 10  7 12  8   (53 sum)
/// ;
/// ;          now, 10 - (53 mod 10) = (10 - 3) = 7 check digit 
/// ;
/// ;      C     2  0  1  5  3  5  7  6  8
/// ;          * 1  2  1  2  1  2  1  2  1             (same as B)
/// ;          ---------------------------     
/// ;            2  0  1 10  3 10  7 12  8
/// ;            2  0  1  1  3  1  7  3  8   (26 sum)  (further reduce products to single digits
/// ;                                                  by adding the digits (note 10 and 12)
/// ;
/// ;          now, 10 - (26 mod 10) = (10 - 6) = 4 check digit 
/// ;
/// ;
/// ;           (Note:  For ALL variations, if the result of the modulo is 0, the check
/// ;                   digit would be 10.  This case is normalized to 0.)
/// ;
/// ;           The 3 variations yielded 3 different check digits:
/// ;                  M10A = 2 
/// ;                  M10B = 7
/// ;                  M10C = 4
/// ;
/// ;           M11 check digits are computed similarly, but substitute  11 - (x mod 11)
/// ;           in the last step.
/// ;
/// ;           Variation C is really a sub-type of B, but for ease of use, I deemed
/// ;           it another type.  (M10A, M11B1, M10B2 ??!!)
/// ;
/// ;           I may add functionality for Mx check digits.  I need to research the topic
/// ;           to determine if other modulos are used, or are even valid.
ClassMethod MonkCheckDigit(pValue, pPattern) As %String
{
	If $E(pPattern)'="M" $$$ThrowOnError($$$ERROR($$$GeneralError,"Pattern must start with M"))
	Set tMod = $E(pPattern,2,3)
	If tMod'=10 && (tMod'=11) {
		$$$ThrowOnError($$$ERROR($$$GeneralError,"Modulo must be 10 or 11 not "_tMod))
	}
	Set tType=$E(pPattern,4) 
	If "ABC"'[tType {
		$$$ThrowOnError($$$ERROR($$$GeneralError,"Unknown mode "_tType))
	}
	If $E(pPattern,5,*)]"" {
		$$$ThrowOnError($$$ERROR($$$GeneralError,"Unknown trailing characters "_$E(pPattern,5,*)))
	}
	Set tSum = 0
	Set tLen = $l(pValue)
	If tType = "A" {
		/*
		///;      A     2  0  1  5  3  5  7  6  8
		///;         * 10  9  8  7  6  5  4  3  2             (multiply by increaing factors starting
		///;         ----------------------------             with 2 for the LOW order digit)
		///;           20  0  8 35 18 25 28 18 16  (168 sum)  (sum the products)
		///;
		///;         now, 10 - (168 mod 10) = (10 - 8) = 2 check digit 
		*/
		For tIdx=1:1:tLen { 
			Set tSum=tSum+($E(pValue,tIdx)*(tLen+2-tIdx))
		}
		Set tCD = tMod - (tSum#tMod)
	} ElseIf tType="B" {
		/*
		///;      B     2  0  1  5  3  5  7  6  8
		///;          * 1  2  1  2  1  2  1  2  1             (multiply by alternating 1 and 2
		///;          ---------------------------             starting with the HIGH order digit)
		///;            2  0  1 10  3 10  7 12  8   (53 sum)
		///;
		///;          now, 10 - (53 mod 10) = (10 - 3) = 7 check digit 
		*/
		For tIdx=1:1:tLen { 
			Set tSum=tSum+($E(pValue,tIdx)*$S((tLen-tIdx)#2:2,1:1))
		}
		Set tCD = tMod - (tSum#tMod)
	} ElseIf tType="C" {
		/*
		///;      C     2  0  1  5  3  5  7  6  8
		///;          * 1  2  1  2  1  2  1  2  1             (same as B)
		///;          ---------------------------
		///;            2  0  1 10  3 10  7 12  8
		///;            2  0  1  1  3  1  7  3  8   (26 sum)  (further reduce products to single digits
		///;                                                  by adding the digits (note 10 and 12)
		*/
		For tIdx=1:1:tLen { 
			Set tProduct = $E(pValue,tIdx)*$S((tLen-tIdx)#2:2,1:1)
			IF $l(tProduct)>1 {
				Set tProduct = $E(tProduct) + $E(tProduct,2)
			}
			Set tSum=tSum+tProduct
		}
		Set tCD = tMod - (tSum#tMod)
	}
	Quit $S(tCD=tMod:0,1:tCD)
}

ClassMethod MonkToHL7Time(pValue)
{
	Set tValue = pValue
	Set tAMPM=""
	If $E(tValue,*) = "M" {
		Set tAMPM = $E(tValue,*-1,*)
		Set tValue = $E(tValue,1,*-2)
	}
	Set tTime = ""
	For tIdx =0:1:2 {
		Set tPos = tIdx*2+1
		Set tItem = $E(100+$E(tValue,tPos,tPos+1),2,3)
		Set tTime = tTime_tItem
	}
	If tAMPM="PM" && ($E(tTime,1,2)<12) {
		Set $E(tTime,1,2) = $E(tTime,1,2)+12
	}
	Quit tTime
}

/*
MM/DD/YY MM/DD/YYYY DD-MMM-YY MMM DD, YYYY

*/
ClassMethod MonkToHL7Date(pValue)
{
	Set tValue = pValue
	If tValue["/" {
		Set tDate = $ZDATEH(pValue,1,,3,1990)
	} ElseIf tValue["-" {
		Set tDate = $ZDATEH($tr(pValue,"-"," "),2)
	} Else {
		Set tDate = $ZDATEH(pValue,5)
	}
	Quit $ZD(tDate,8)
}

}
