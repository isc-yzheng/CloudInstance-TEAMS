/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lexer Extends %RegisteredObject
{

Parameter TILDE = 1;

Parameter NAME = 2;

Parameter COLON = 3;

Parameter BRACETILDE = 4;

Parameter TILDEBRACE = 5;

Parameter BRACKETTILDE = 6;

Parameter TILDEBRACKET = 7;

Parameter ANGLETILDE = 8;

Parameter TILDEANGLE = 9;

Parameter TILDEBARTILDE = 10;

Property Source As %String [ Private ];

Property SourcePos As %Integer [ InitialExpression = 1, Private ];

Property TokenInfo As %List [ Private ];

Method %OnNew(pSource As %String) As %Status
{
	Set ..Source=pSource
	Set ..TokenInfo=..GetTokenInfo()
	Quit $$$OK
}

/// So that callers can tell if the lexer position has changed after a call to some other code
Method CurrentPosition() As %Integer [ CodeMode = expression ]
{
..SourcePos
}

Method Repr() As %String
{
	Quit $Extract(..Source,1,..SourcePos-1)_"!"_$Extract(..Source,..SourcePos,*)
}

Method Ended() As %Boolean
{
	Quit ..TokenInfo=""
}

Method CrossIfPresent(pTokenType As %Integer) As %Boolean
{
	If '..Ended(),..CurrentType()=pTokenType {
		Do ..Next()
		Quit 1
	}
	Else {
		Quit 0
	}
}

Method CrossMustBe(pTokenType As %Integer) As %String
{
	#Dim tText
	
	If ..CurrentType()=pTokenType {
		Set tText=..CurrentText()
		Do ..Next()
		Quit tText
	}
	Else {
		Do ..FatalError("Expected token #"_pTokenType)
	}
}

Method IsPresent(pTokenType As %Integer) As %Boolean
{
	Quit ..CurrentType()=pTokenType
}

Method CurrentType() As %Integer [ Private ]
{
	Do ..CheckNotEnded()
	Quit $List(..TokenInfo,2)
}

Method CurrentText() As %String [ Private ]
{
	Do ..CheckNotEnded()
	Quit $Extract(..Source,..SourcePos,..SourcePos+$List(..TokenInfo)-1)
}

Method Next() [ Private ]
{
	Do ..CheckNotEnded()
	Set ..SourcePos=..SourcePos+$List(..TokenInfo)
	Set ..TokenInfo=..GetTokenInfo()
}

Method CheckNotEnded() [ Private ]
{
	If ..Ended() {
		Do ..FatalError("End of source")
	}
}

/// Return "" at eof or $LB(len,type)
Method GetTokenInfo() As %List [ Private ]
{
	#Dim tFirst1,tFirst2,tFirst3,tName
	
	If ..SourcePos>$Length(..Source) {
		Quit ""
	}
	
	Set tFirst1=$Extract(..Source,..SourcePos)
	Set tFirst2=$Extract(..Source,..SourcePos,..SourcePos+1)
	Set tFirst3=$Extract(..Source,..SourcePos,..SourcePos+2)
	
	If tFirst3="~|~" {
		Quit $LB(3,..#TILDEBARTILDE)
	}
	ElseIf tFirst2="~}" {
		Quit $LB(2,..#TILDEBRACE)
	}
	ElseIf tFirst2="{~" {
		Quit $LB(2,..#BRACETILDE)
	}
	ElseIf tFirst2="~]" {
		Quit $LB(2,..#TILDEBRACKET)
	}
	ElseIf tFirst2="[~" {
		Quit $LB(2,..#BRACKETTILDE)
	}
	ElseIf tFirst2="~>" {
		Quit $LB(2,..#TILDEANGLE)
	}
	ElseIf tFirst2="<~" {
		Quit $LB(2,..#ANGLETILDE)
	}
	ElseIf tFirst1="~" {
		Quit $LB(1,..#TILDE)
	}
	ElseIf tFirst1=":" {
		Quit $LB(1,..#COLON)
	}
	ElseIf tFirst1?1(1AN,1".",1"_") {
		Set tName=..FetchName()
		Quit $LB($Length(tName),..#NAME)
	}
	Else {
		Do ..FatalError("Unrecognized token: "_$Extract(..Source,..SourcePos,*))
	}
}

Method FetchName() As %String [ Private ]
{
	#Dim tPos
	
	Set tPos=..SourcePos
	While tPos<=$Length(..Source),$Extract(..Source,tPos)?1(1AN,1".",1"_") {
		Set tPos=tPos+1
	}
	
	If tPos=..SourcePos {
		Do ..FatalError("No name found")
	}
	
	Quit $Extract(..Source,..SourcePos,tPos-1)
}

Method FatalError(pMessage As %String)
{
	Throw ##class(%Exception.General).%New("(lexer) "_pMessage_" -- "_..Repr())
}

}
