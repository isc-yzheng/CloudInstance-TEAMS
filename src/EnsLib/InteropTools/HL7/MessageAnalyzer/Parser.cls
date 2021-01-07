/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Node

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Parser Extends %RegisteredObject
{

ClassMethod ParseSchema(pLexer As Lexer) As Base
{
	#Dim tNode As Base
	
	Set tNode=..ParseBody(pLexer)
	If 'pLexer.Ended() {
		Do ..FatalError("Not all the source was parsed",pLexer)
	}
	
	Quit tNode
}

ClassMethod ParseBody(pLexer As Lexer) As Base
{
	#Dim tNodeList As EnsLib.InteropTools.HL7.MessageAnalyzer.Node.List // can't abbreviate 'List' here
	#Dim tNode As Base
	
	Set tNodeList = ##class(List).%New()
	Set tStartOffset=pLexer.CurrentPosition()
	
	Do
	{
		Set tNode=..ParseItem(pLexer)
		If '$IsObject(tNode) {
			Quit
		}
		Do tNodeList.Add(tNode)
	} While pLexer.CrossIfPresent(pLexer.#TILDE)
	
	Do tNodeList.SetSourceOffset($ListBuild(tStartOffset,pLexer.CurrentPosition()))
	
	Quit tNodeList
}

ClassMethod ParseItem(pLexer As Lexer) As Base
{
	If pLexer.IsPresent(pLexer.#NAME) {
		Quit ..ParseTerm(pLexer)
	}
	Else {
		Quit ..ParseStructure(pLexer)
	}
}

ClassMethod ParseTerm(pLexer As Lexer) As Base
{
	#Dim tName1,tName2
	
	Set tStartOffset=pLexer.CurrentPosition()
	
	Set tName1=pLexer.CrossMustBe(pLexer.#NAME)
	If pLexer.CrossIfPresent(pLexer.#COLON) {
		Set tName2=pLexer.CrossMustBe(pLexer.#NAME)
		Set tNodeName=##class(Name).%New(tName1,tName2)
	}
	Else {
		Set tNodeName=##class(Name).%New(,tName1)
	}
	
	Do tNodeName.SetSourceOffset($ListBuild(tStartOffset,pLexer.CurrentPosition()))
	Quit tNodeName
}

ClassMethod ParseStructure(pLexer As Lexer) As Base
{
	If pLexer.IsPresent(pLexer.#BRACETILDE) {
		Quit ..ParseRepeat(pLexer)
	}

	ElseIf pLexer.IsPresent(pLexer.#BRACKETTILDE) {
		Quit ..ParseOption(pLexer)
	}
	
	ElseIf pLexer.IsPresent(pLexer.#ANGLETILDE) {
		Quit ..ParseChoice(pLexer)
	}
	
	Else {
		Quit $$$NULLOBJECTREF
	}
}

ClassMethod ParseRepeat(pLexer As Lexer) As Base
{
	Set tStartOffset=pLexer.CurrentPosition()
	Set tNodeRepeat=##class(Repeat).%New(..ParseStructureImpl(pLexer,pLexer.#BRACETILDE,pLexer.#TILDEBRACE))
	Do tNodeRepeat.SetSourceOffset($ListBuild(tStartOffset,pLexer.CurrentPosition()))
	Quit tNodeRepeat
}

ClassMethod ParseOption(pLexer As Lexer) As Base
{
	Set tStartOffset=pLexer.CurrentPosition()
	Set tNodeOption=##class(Option).%New(..ParseStructureImpl(pLexer,pLexer.#BRACKETTILDE,pLexer.#TILDEBRACKET))
	Do tNodeOption.SetSourceOffset($ListBuild(tStartOffset,pLexer.CurrentPosition()))
	Quit tNodeOption
}

ClassMethod ParseChoice(pLexer As Lexer) As Base
{
	#Dim tNode As Base
	
	Set tStartOffset=pLexer.CurrentPosition()
	
	Do pLexer.CrossMustBe(pLexer.#ANGLETILDE)
	
	Set tNode=..ParseChoiceBody(pLexer)
	
	Do pLexer.CrossMustBe(pLexer.#TILDEANGLE)
	
	Set tNodeChoice=##class(Choice).%New(tNode)
	Do tNodeChoice.SetSourceOffset($ListBuild(tStartOffset,pLexer.CurrentPosition()))
	Quit tNodeChoice
}

ClassMethod ParseChoiceBody(pLexer As Lexer) As Base
{
	#Dim tNodeList As EnsLib.InteropTools.HL7.MessageAnalyzer.Node.List // can't abbreviate 'List' here
	
	Set tStartOffset=pLexer.CurrentPosition()

	Set tNodeList=##class(List).%New()
	
	Set tStartLexerPos=pLexer.CurrentPosition()
	Do {
		Do tNodeList.Add(..ParseBody(pLexer))
	} While pLexer.CrossIfPresent(pLexer.#TILDEBARTILDE)
	
	// if the lexer was unmoved by that loop ..
	If tStartLexerPos=pLexer.CurrentPosition() {
		Do ..FatalError("An empty choice construct is not allowed",pLexer)
	}
	
	Do tNodeList.SetSourceOffset($ListBuild(tStartOffset,pLexer.CurrentPosition()))
	Quit tNodeList
}

ClassMethod ParseStructureImpl(pLexer As %String, pOpener As %Integer, pCloser As %Integer) As Base
{
	#Dim tBodyNode As Base
	
	Do pLexer.CrossMustBe(pOpener)
	
	Set tBodyNode=..ParseBody(pLexer)
	
	Do pLexer.CrossMustBe(pCloser)
	
	Quit tBodyNode
}

ClassMethod FatalError(pMessage As %String, pLexer As Lexer)
{
	Throw ##class(%Exception.General).%New("(parser) "_pMessage_" -- "_pLexer.Repr())
}

}
