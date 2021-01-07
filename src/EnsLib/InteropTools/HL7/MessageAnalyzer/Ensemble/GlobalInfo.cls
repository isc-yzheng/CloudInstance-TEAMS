/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble.GlobalInfo Extends %RegisteredObject
{

Property Namespace As %String [ Private ];

/// <p> GlobalMap(GLOBALNAME)=LOCATION - database for global unless a subscript is specified in a 2-key entry
/// <p> GlobalMap(GLOBALNAME,SUBSCRIPTSTART)=$LB(SUBSCRIPTEND,LOCATION) - database for specified subscript range
/// <ul>
///  <li> GLOBALNAME has no "^" or environment part
///  <li> LOCATION is a directory path
///  <li> SUBSCRIPT is just a string
/// </ul>
Property GlobalMap [ MultiDimensional, Private ];

/// MultSub(GLOBALNAME) exists if more than one subscript is mapped
Property MultSub [ MultiDimensional, Private ];

Method %OnNew(pNamespace As %String = "", pTraceBuild As %Boolean = 0) As %Status
{
	Set ..Namespace=$Select(pNamespace="":$Namespace,1:pNamespace)
	Set tSC=..BuildGlobalMap(pTraceBuild) If $$$ISERR(tSC) {Quit tSC}	
	Quit $$$OK
}

/// Returns the final name (uppercased) in the location string - or "." if the global is unknown; returns "" if the global is mapped but not in a way we can handle
Method DatabaseFor(pRef As %String) As %String
{
	Set tGlobalName=$Extract($QSubscript(pRef,0),2,*) // remove leading "^"
	If $Data(..MultSub(tGlobalName)) {Quit ""} // a mapping we can't handle
	
	// if there's at least one subscript ..
	If $QLength(pRef)>0 {
	
		Set tFirstKey=$QSubscript(pRef,1)
		
		// see if there is a subscript-level mapping
		Set tLocation=..DatabaseForSubscriptedGlobal(tGlobalName,tFirstKey)
		If tLocation'="" {
			Quit $$$TOUP(..LastName(tLocation)) // found subscript-level mapping
		}
		
		// fall through		
	}
	
	// if there's an entry for the global itself ..
	If $Data(..GlobalMap(tGlobalName),tLocation)#10 {
		Quit $$$TOUP(..LastName(tLocation)) // found global-level mapping
	}
	
	// not mapped
	Quit "."
}

Method Dump()
{
	Set tGlobal="" While 1 {
		Set tGlobal=$Order(..GlobalMap(tGlobal)) If tGlobal="" {Quit}
		If $Data(..GlobalMap(tGlobal),tLocation)#10 {
			Write tGlobal,": ",tLocation,!
		}
		Set tSubscript="" While 1 {
			Set tSubscript=$Order(..GlobalMap(tGlobal,tSubscript),+1,tList) If tSubscript="" {Quit}
			Set $ListBuild(tSecondSubscript,tLocation)=tList
			If tSubscript=tSecondSubscript {
				Write " ",tSubscript,": ",tLocation,!
			}
			Else {
				Write " ",tSubscript,"-",tSecondSubscript,": ",tLocation,!
			}
		}
	}
	
	Set tGlobal="" While 1 {
		Set tGlobal=$Order(..MultSub(tGlobal)) If tGlobal="" {Quit}
		Write tGlobal,": multiple subscripts",!
		If $Data(..GlobalMap(tGlobal)) {
			Write " - ** also in ..GlobalMap! **",!
		}
	}
}

Method BuildGlobalMap(pTraceBuild As %Boolean = 0) As %Status [ Private ]
{
	Set tResultSet=##class(%Library.ResultSet).%New("%SYS.GlobalQuery:NameSpaceList")
	Set tSC=tResultSet.Execute(..Namespace,"*",0) If $$$ISERR(tSC) {Quit tSC}
	
	Set tSC=$$$OK
	While tResultSet.Next(.tSC), '$$$ISERR(tSC) {
	
		Set tNamePart=tResultSet.Get("Name")
		Set tLocation=tResultSet.Get("Location")
		
		If pTraceBuild {
			Write "> ",tNamePart," | ",tLocation,!
		}
		
		If tNamePart["(" {
			Set tName=$Piece(tNamePart,"("),tRest=$Piece(tNamePart,"(",2,*)
			If '$Data(..MultSub(tName)) {
				Set tSubscriptRange=..GetSubscriptRange(tRest)
				If tSubscriptRange="" {
					Set ..MultSub(tName)=""
					Kill ..GlobalMap(tName)
				}
				Else {
					Set $ListBuild(tSubStart,tSubEnd)=tSubscriptRange
					Set ..GlobalMap(tName,tSubStart)=$ListBuild(tSubEnd,tLocation)
				}
			}
		}
		Else {
			If '$Data(..MultSub(tNamePart)) {
				Set ..GlobalMap(tNamePart)=tLocation
			}
		}
	}
	
	Quit tSC
}

/// Returns the location string - or "" if the global is unknown
/// <p> Assumes caller has checked ..MultSub
Method DatabaseForSubscriptedGlobal(pGlobalName As %String, pFirstKey As %String) [ Private ]
{
	// if there is an entry starting with the first subscript ..
	If $Data(..GlobalMap(pGlobalName,pFirstKey),tList) {
		Quit $List(tList,2) // the subscript is mapped
	}
	
	// look at the entry preceding the first subscript
	Set tBeforeFirstKey=$Order(..GlobalMap(pGlobalName,pFirstKey),-1,tList)
	If tBeforeFirstKey'="",pFirstKey']]$List(tList) {
		Quit $List(tList,2) // the subscript is mapped
	}
	
	Quit "" // the subscript is not mapped
}

ClassMethod GetSubscriptRange(pRest As %String) [ Private ]
{
	Set tPos=1
	Set tFirstSubscript=..GetSubscript(pRest,.tPos)
	
	// there are two different formats for this
	If $Extract(pRest,tPos)=":" {
		Set tPos=tPos+1
	}
	ElseIf $Extract(pRest,tPos,tPos+2)="):(" {
		Set tPos=tPos+3
	}
	Else {
		Quit ""  // multiple or unknown subscript config format
	}

	Set tSecondSubscript=..GetSubscript(pRest,.tPos)

	Quit $ListBuild(tFirstSubscript,tSecondSubscript)
}

ClassMethod GetSubscript(pRest As %String, ByRef pPos) [ Private ]
{
	If $Extract(pRest,pPos)="""" {
		Quit ..ExtractLeadingStringBody(pRest,.pPos)
	}
	Else {
		Quit ..ExtractLeadingUnquoted(pRest,.pPos)
	}
}

ClassMethod ExtractLeadingStringBody(pString As %String, ByRef pPos) As %String [ Private ]
{
	// skip leading double-quote
	If $Extract(pString,pPos)'="""" {ZTrap}
	Set pPos=pPos+1
	
	Set tLString=$Length(pString)
	Set tOut=""
	While pPos<=tLString {
		If $Extract(pString,pPos)="""" {
			Set pPos=pPos+1
			If $Extract(pString,pPos)'="""" {
				Quit  // quit the While loop
			}
			Set pPos=pPos+1
			Set tOut=tOut_""""
		}
		Else {
			Set tOut=tOut_$Extract(pString,pPos)
			Set pPos=pPos+1
		}
	}
	
	Quit tOut
}

ClassMethod ExtractLeadingUnquoted(pString As %String, ByRef pPos) As %String [ Private ]
{
	Set tRest=$Extract(pString,pPos,*)
	Set tBeforeColon=$Piece(tRest,":")
	Set tBeforeCloseParen=$Piece(tRest,")")
	
	If $Length(tBeforeColon)<$Length(tBeforeCloseParen) {
		Set tOut=tBeforeColon
	} 
	Else {
		Set tOut=tBeforeCloseParen
	}
	
	Set pPos=pPos+$Length(tOut)
	
	Quit tOut
}

ClassMethod LastName(pLocation As %String) [ CodeMode = expression, Private ]
{
$Piece(pLocation,..Dlm(pLocation),*-1)
}

ClassMethod Dlm(pLocation As %String) [ CodeMode = expression, Private ]
{
$Select(pLocation["\":"\",pLocation["/":"/",1:":")
}

}
