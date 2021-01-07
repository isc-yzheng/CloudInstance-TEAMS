/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.CodeBuilder

Class EnsLib.InteropTools.HL7.eGate.Parser Extends (EnsLib.InteropTools.HL7.GateSSC.Parser, EnsLib.InteropTools.HL7.Common)
{

/// Overriding FUNCTIONSETCLASS offers ability to direct to user defined function class
Parameter FUNCTIONSETCLASS = "EnsLib.InteropTools.HL7.eGate.Functions";

/// Call based on FUNCTIONSETCLASS
Parameter FUNCTIONSET = "##class({..#FUNCTIONSETCLASS}).";

/// for Code entries such as Display or $event-parse include a comment line
Parameter INCLUDECODENOTATIONS = 1;

Method CodeWalkNode(pNode As %XML.Node, pLevel = 0, pSet = 1, pCommandLine = "", pDebug = 1, pFileName)
{
	Set tSaveNodeId = pNode.NodeId
	Set tCode = ..Code("Code")
	If pNode.NodeType=$$$xmlELEMENTNODE {
		try {
			Set tSC = $method($this,"CodeWalk"_pNode.LocalName,pNode,tCode.Items)
			If $$$ISERR(tSC) Do ..ReportItem("Error processing "_pNode.NodeData,0)
		} catch ex { break}
	} elseIf pNode.NodeData="&lt;EOF" {
	} elseIf pNode.NodeData=">" {
	} else {
		Break:..Debug
	}
	Set pNode.NodeId=tSaveNodeId
	Quit 1
}

Method CodeWalkform(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSaveNodeId = pNode.NodeId
		Quit:'pNode.MoveToFirstChild(1)
		For  {
			Set tNodeId = pNode.NodeId
			If pNode.NodeType = $$$xmlTEXTNODE && (pNode.NodeData = ")") Quit
			If pNode.NodeType = $$$xmlELEMENTNODE {
				If pNode.NodeData = "form" {
					break:'pNode.MoveToFirstChild(1)
				
				}
				If pNode.LocalName = "list" {
					break:'pNode.MoveToFirstChild(1)
					break:'pNode.MoveToNextSibling(1)
					break:pNode.NodeData'="forms"
					try {
						Set tSC = $method($this,"CodeWalk"_pNode.NodeData,pNode,pCode,.pElement)
						Quit:$$$ISERR(tSC)
						Break:pElement]""
					} catch ex {
						Set tSC = ex.AsStatus() break
					}
				} ElseIf pNode.LocalName = "literal" {
					Set tLiteral = $zstrip(..NodeAsText(pNode),"<>WC")
					If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent for "_tLiteral,1) Quit
					try {
						Set tSC = $method($this,"CodeWalk"_tLiteral,pNode,pCode,.pElement)
						Break:'tSC&&..Debug  if 'tSC Do ..ReportItem("error in code walk form executing "_tLiteral_" "_$system.Status.GetErrorText(tSC),0)
						Quit:$$$ISERR(tSC)
						//break:pElement=""
					} catch ex {
						Set tCode = ##class(CodeCOS).%New()
						Do pCode.Insert(tCode)
						Do ..DisableObject(pNode,tCode,"Unexpected "_tLiteral,tSaveNodeId)
						Do tCode.Lines.Insert("	/*"_tCode.Annotation_"*/")
						For  Quit:'pNode.MoveToNextSibling(1)
						Quit 
					}
				} else {
					break:..Debug  Do ..ReportItem("expected a list in code walk form",0) /// not a list
				}
			}
			Set pNode.NodeId = tNodeId
			Quit:'pNode.MoveToNextSibling(1)  /// ifinstr
		}
	} catch ex {
		set tSC = ex.AsStatus() break:..Debug  Do ..ReportItem("Error in code walk form "_$system.Status.GetErrorText(tSC),0)
	}
	Quit $$$OK
}

Method "CodeWalkdefined?"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no variables for defined?",0) Quit
	Set tWhatID = pNode.NodeId
	Set tSC = ..GetElement(pNode,pCode,.tWhat,.tType,,1)
	Quit:$$$ISERR(tSC)

	Set pElement = "$Data("_tWhat_")"
	Set pElement("SubDone")=1
	Quit $$$OK
}

Method CodeWalkdefine(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no variables for define",0) Quit
		Set tWhatID = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tWhat,.tType,,1)
		Quit:$$$ISERR(tSC)
		$$$MoveToNextSibling(pNode,"")
		If tWhat = "srcdcollapseddnodes" || (tWhat="destdcollapseddnodes") || (tWhat="collapseddrules") {
			Quit
		}
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1) 
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error with define"_$system.Status.GetErrorText(tSC),1) Quit
		}
		If pNode.MoveToNextSibling(1) break  ///shouldn't be more siblings
		If tWhat = "xlatedname" {
			Set ..Code("Translation")=..GetVariable($zstrip(tValue,"<>",$c(34)))
		} ElseIf tWhat = "usercomment" {
			Set tCode = ##class(CodeCOS).%New()
			Set tCode.Annotation = tWhat_"="_tValue
			Do pCode.Insert(tCode)
		} ElseIf tWhat = "version" {
		} ElseIf tWhat="inputdmessagedformatdfiledname" {
			Set ..Code("InputStructure")=tValue
			Set tFile = $zstrip(tValue,"<>",$C(34))
			Set:tFile]"" ..Code("InputStructureFile")=##class(%File).GetDirectory(..Filename)_tFile
		} ElseIf tWhat="outputdmessagedformatdfiledname" {
			Set ..Code("OutputStructure")=tValue
			Set tFile = $zstrip(tValue,"<>",$C(34))
			Set:tFile]"" ..Code("OutputStructureFile")=##class(%File).GetDirectory(..Filename)_tFile
		} ElseIf tWhat = "srcdcollapseddnodes" || (tWhat="destdcollapseddnodes") || (tWhat="collapseddrules") {
		} ElseIf tWhat = ..Code("Translation")	{
		} Else {
			break:..Debug  /// tWhat / tValue
		}
	} catch ex {
		set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkstring->ssn"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tString,.pType,,1)
	Set pElement="$CASE("_tString_",""?9N"":$Extract("_tString_",1,3)_""-""_$Extract("_tString_",4,5)_""-""_$Extract("_tString_",6,9),:"""")"
	Set pElement("SubDone")=1
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Element in string->number",tTopNodeId)
		Quit
	}
	Quit tSC
}

Method ProcessXLATE(pNode As %XML.Node, pCode) As %Status
{
	break
}

Method CodeWalkload(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do pNode.MoveToParent(1)
	Set tCode = ##class(CodeCOS).%New()
	Do:..#INCLUDECODENOTATIONS pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/*"_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	Quit $$$OK
	///discard load
}

Method CodeWalkforms(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSaveNodeId = pNode.NodeId
		Quit:'pNode.MoveToFirstChild(1)
		For  {
			If pNode.NodeType = $$$xmlTEXTNODE && (pNode.NodeData = ")") Quit
			If pNode.NodeType = $$$xmlELEMENTNODE {
				If pNode.NodeData = "form" {
					Do $method($this,"CodeWalk"_pNode.NodeData,pNode,pCode)
				} else {
					break
					Set tCode = ##class(CodeCOS).%New()
					Do pCode.Insert(tCode)
					Do ..DisableObject(pNode,tCode,"Unexpected "_pNode.NodeData,tSaveNodeId)
					Do tCode.Lines.Insert("	/*"_tCode.Annotation_"*/")
					For  Quit:'pNode.MoveToNextSibling(1)
					Quit 
				}
			} Else {
				break  ///not an element node
			}
			Quit:'pNode.MoveToNextSibling(1)  /// ifinstr
		}
	} catch ex {
		set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

/// (let ( (BLUE test ) (RED foo)) body-of-let )
Method CodeWalklet(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no variables for let",0) Quit
		Do ..getLetVariableAndValue(pNode,pCode)
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no body for let",0) Quit
		Set tSC = ..ProcessContent(pNode,pCode)
		Do pNode.MoveToNextSibling(1)
		 /// at end of let
	} catch ex {
		set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

/// in cases of let 
/// list/forms
Method getLetVariableAndValue(pNode As %XML.Node, pCode) As %Status
{
	
	Set tTopNode = pNode.NodeId
	$$$MoveToFirstChild(pNode,"list")
	$$$MoveToFirstChild(pNode,"(")
	$$$MoveToNextSibling(pNode,"forms")
	$$$MoveToFirstChild(pNode,"form")
	For {
		Kill tVar,tValue
		Set tVariableTop = pNode.NodeId
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")
		break:..Debug  
		Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1) 
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("unable to find let value",1) Quit
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1) break:tValue=""
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Variable = tVar 
		Set tValue = $zstrip(tValue,"<>",$c(34))
		Set:tValue="" tValue = $C(34,34)
		Set tCode.Value = tValue
		If tValue = "" {
			break // what is tType
			Set tCode.Annotation = ..ParsedNode(pNode)
			Set tCode.Disabled=1
		}
		If '$lf($lb("result","input","output"),tVar) {
				Do pCode.Insert(tCode)
		}
		Set pNode.NodeId=tVariableTop
		Quit:'pNode.MoveToNextSibling(1)
	}
	Set pNode.NodeId=tTopNode
}

/// in cases of let 
/// list/forms
Method getLetBody(pNode As %XML.Node, ByRef pCode) As %Status
{
	
	$$$MoveToNextSibling(pNode,"")
	Quit ..ProcessContent(pNode,pCode)
}

/// (duplicate-strip source-path destination_path format)
Method "CodeWalkduplicate-strip"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no source for duplicate-strip",0) Quit
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) Do ..ReportItem("Failed to get source in duplicate-strip",0) Quit tSC
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no target for duplicate-strip",0) Quit
	Set tSC = ..GetElement(pNode,pCode,.tTarget,.tType,,1)
	If $$$ISERR(tSC) Do ..ReportItem("Failed to get target in duplicate-strip",0) Quit tSC
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no format for duplicate-strip",0) Quit
	Set tSC = ..GetElement(pNode,pCode,.tFormat,.tType,,1)
	If $$$ISERR(tSC) Do ..ReportItem("Failed to get format for duplicate-strip",0) Quit tSC
	Set tCodeSet = ##class(CodeSet).%New()
	Set tCodeSet.Variable="tSC"
	Set tCodeSet.Value=..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKDUPLICATESTRIP")_"("_tSource_","_tTarget_","_tFormat_")"
	Do pCode.Insert(tCodeSet)
	Quit tSC
}

Method "CodeWalk$event-parse"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do pNode.MoveToParent(1)
	Set tCode = ##class(CodeCOS).%New()
	Do:..#INCLUDECODENOTATIONS pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/*"_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	Quit $$$OK
}

Method "CodeWalk$event-clear"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do pNode.MoveToParent(1)
	Set tCode = ##class(CodeCOS).%New()
	Do:..#INCLUDECODENOTATIONS pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/*"_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	Quit $$$OK
}

Method CodeWalktry(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no items for try",0) Quit
	Set tSC = ..ProcessContent(pNode,pCode)
	If $$$ISERR(tSC) {
		Do ..ReportItem("Failed to process try content",0)
		Quit
	}
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	$$$MoveToNextSibling(pNode,")")
	Do pNode.MoveToNextSibling(1) //end of try
	Quit $$$OK
}

Method CodeWalkbegin(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	If 'pNode.MoveToNextSibling(1) {
		Quit $$$OK
	}
	Quit ..ProcessContent(pNode,pCode)
}

Method CodeWalklambda(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no begin items",0) Quit
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no begin items",0) Quit
	Set tSC =  ..ProcessContent(pNode,pCode)
	If $$$ISERR(tSC) {
		Do ..ReportItem("Failed to process lambda content",0)
		Quit
	}
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	$$$MoveToNextSibling(pNode,")")
	Do pNode.MoveToNextSibling(1) //end of lambda
	Quit $$$OK
}

Method CodeWalkif(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no if condition",1) Quit
		Set tNodeId = pNode.NodeId
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		Set tAnnotation = ..ParsedNode(pNode)
		Set tCode = ##class(CodeIf).%New()
		Set tCode.Annotation = tAnnotation
		Set tCode.Condition = "uuuUNKNOWNuuu"
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetCondition(pNode,tCode)
		Set pNode.NodeId = tNodeId
		Do pCode.Insert(tCode)
		If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
		If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
		$$$MoveToNextSibling(pNode,"")
		
		//*/
		//true
		Set tNodeId = pNode.NodeId
		$$$MoveToFirstChild(pNode,"")	
		Set tSC = ..ProcessContent(pNode,tCode.True)
		If $$$ISERR(tSC) Do ..ReportItem("unable to process true condition for if",1)
		// false
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		$$$MoveToFirstChild(pNode,"")
		Set tSC = ..ProcessContent(pNode,tCode.False)
		If $$$ISERR(tSC) Do ..ReportItem("unable to process false condition for if",1)
	} catch ex {
	}
	Quit tSC
}

/// (list-lookup source-path destination_path lookup-list format trim-chars)
Method "CodeWalklist-lookup"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("list lookup issue",1) Quit

		Set tCode = ##class(CodeSet).%New()
		Set tAnnotation = ..ParsedNode(pNode)
		Set tCode.Annotation = tAnnotation
		Do pCode.Insert(tCode)
		Set tSC = ..GetElement(pNode,tCode,.tSource,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to GetElement (Source) for list-lookup",0)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,tCode,.tDest,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to GetElement (Destination) for list-lookup",0)
			Quit
		}
		Set tCode.Variable = tDest
		$$$MoveToNextSibling(pNode,"")

		Set tTopChoices = pNode.NodeId
		$$$MoveToFirstChild(pNode,"reader_macro")
		$$$MoveToFirstChild(pNode,"quote")
		$$$MoveToFirstChild(pNode,"'")
		$$$MoveToNextSibling(pNode,"form")
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")
		Set tCase = ""
		For  {
			Set tTop = pNode.NodeId
			$$$MoveToFirstChild(pNode,"list")
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")
			Set tSC = ..GetElement(pNode,tCode,.tFrom,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (From) for list-lookup",0)
				Quit
			}
			$$$MoveToNextSibling(pNode,"form")
			Set tSC = ..GetElement(pNode,tCode,.tTo,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (To) for list-lookup",0)
				Quit
			}
			If tFrom="else" Set tFrom=""
			Set tCase=tCase_","_tFrom_":"_tTo
			Set pNode.NodeId=tTop
			Quit:'pNode.MoveToNextSibling(1)
		}
		Set tCase=tCase_")" 
		Set pNode.NodeId = tTopChoices
		$$$MoveToNextSibling(pNode,"")
		
		Set tSC = ..GetElement(pNode,tCode,.tFormat,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to GetElement (Format) for list-lookup",0)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
			
		Set tCase="$CASE("_tSource_tCase
		if tFormat'=$c(34,34) {
			Set tCase=..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKFORMAT")_"("_tCase_","_tFormat_")"
		}
		Set tCode.Value = tCase
	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..ReportItem("Failure in list-lookup "_$system.Status.GetErrorText(tSC),0)
	}
	Quit $$$OK
}

/// (change-pattern source-path destination change-list format)
Method "CodeWalkchange-pattern"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("change pattern issue",1) Quit

		Set tCode = ##class(CodeSet).%New()
		Set tAnnotation = ..ParsedNode(pNode)
		Set tCode.Annotation = tAnnotation
		Do pCode.Insert(tCode)
		Set tSC = ..GetElement(pNode,tCode,.tSource,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to GetElement (Source) for change-pattern "_$system.Status.GetErrorText(tSC),0)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,tCode,.tDest,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to GetElement (Destination) for change-pattern "_$system.Status.GetErrorText(tSC),0)
			Quit
		}
		Set tCode.Variable = tDest
		$$$MoveToNextSibling(pNode,"")

		Set tTopChoices = pNode.NodeId
		$$$MoveToFirstChild(pNode,"reader_macro")
		$$$MoveToFirstChild(pNode,"quote")
		$$$MoveToFirstChild(pNode,"'")
		$$$MoveToNextSibling(pNode,"form")
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")
		Set tCase = ""
		For  {
			Set tTop = pNode.NodeId
			$$$MoveToFirstChild(pNode,"list")
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")
			Set tSC = ..GetElement(pNode,tCode,.tFrom,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (From) for change-pattern "_$system.Status.GetErrorText(tSC),0)
				Quit
			}
			$$$MoveToNextSibling(pNode,"form")
			Set tSC = ..GetElement(pNode,tCode,.tTo,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (To) for change-pattern "_$system.Status.GetErrorText(tSC),0)
				Quit
			}
			Set tCase=tCase_","_tFrom_","_tTo
			Set pNode.NodeId=tTop
			Quit:'pNode.MoveToNextSibling(1)
		}
		Set pNode.NodeId = tTopChoices
		Set tFormat=""
		If pNode.MoveToNextSibling(1) {
			Set tSC = ..GetElement(pNode,tCode,.tFormat,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (Format) for change-pattern "_$system.Status.GetErrorText(tSC),0)
				Quit
			}
		}
		Set tCase = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKCHANGEPATTERN")_"("_tSource_tCase_")"
		if tFormat'=$c(34,34) && (tFormat]"") {
			Set tCase=..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKFORMAT")_"("_tCase_","_tFormat_")"
		}
		Set tCode.Value = tCase
	} catch ex {
		Set tSC = ex.AsStatus()
			Do ..ReportItem("Failure in change-pattern "_$system.Status.GetErrorText(tSC),0)
	}
	Quit $$$OK
}

Method GetCompare(pCompare, tCond1, tCond2)
{
	If pCompare = "string=?" || (pCompare="=") {
		Quit tCond1_"="_tCond2
	} ElseIf pCompare = "empty-string?" {
		Quit "("_tCond1_"="""")"
	} ElseIf pCompare = "string-contains?" {
		Quit "..Contains("_tCond1_","_tCond2_")"
	} ElseIf pCompare = ">" {
		Quit tCond1_">"_tCond2
	} ElseIf pCompare = "<" {
		Quit tCond1_"<"_tCond2
	} ElseIf pCompare = "regex" {
		Quit ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKREGEX")_"("_tCond2_","_$replace($replace($replace(tCond1,"\|","|"),"\^","^"),"\$","$")_")"
	} ElseIf pCompare = "not-empty-string?" {
		Quit "'("_tCond1_"="""")"
	} ElseIf pCompare = "not" {
		Quit "'("_tCond1_")"
	} ElseIf pCompare = "valid-decimal?" {
		Quit "(..Matches("_tCond1_","".N1""."".N""))"
	} ElseIf pCompare = "number?" {
		Quit "(..Matches("_tCond1_","".N""))"
	} ElseIf pCompare = "valid-integer?" {
		Quit "(..Matches("_tCond1_",""1N.N""))"
	} Else {
		Do ..ReportItem("Unknown pCompare "_pCompare,0)
		//break  /// what is pCompare
	}
}

Method CodeWalkand(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNodeId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tCondition = ""
		For  {
			Kill tCond1,tCond2
			$$$MoveToFirstChild(pNode,"list")
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")
			Set tSC = ..GetElement(pNode,pCode,.tCompare,.tType)
			Quit:$$$ISERR(tSC)
			$$$MoveToNextSibling(pNode,"")
			Set tSC = ..GetElement(pNode,pCode,.tCond1,.tType,,1)
			Quit:$$$ISERR(tSC)
			Set tCond2=""  // not all have two conditions
			If pNode.MoveToNextSibling(1) {
				Set tSiblingId = pNode.NodeId
				Set tSC = ..GetElement(pNode,pCode,.tCond2,.tType,,1)
				If $$$ISERR(tSC) {
					Do ..ReportItem("Failed to get element for and condition")
					Quit
				}
			}
			Set tCompare = ..GetCompare(tCompare,tCond1,tCond2)
			
			Set tCondition = tCondition_" && ("_tCompare_")" 
			Quit:'pNode.MoveToParent(1)
			If 'pNode.MoveToNextSibling(1) || (pNode.NodeData '= ")") {
				Do ..DisableObject(pNode,pCode,"Expected closing paren on the and",tNodeId)
				Quit
			}
			If pNode.MoveToNextSibling(1) {
				Do ..DisableObject(pNode,pCode,"Unexpected sibling on the and",tNodeId)
				Quit
			}
			
			If 'pNode.MoveToParent(1) || 'pNode.MoveToParent(1) {
				Do ..DisableObject(pNode,pCode,"Unable to move to parent",tNodeId)
				Quit
			}
			Quit:'pNode.MoveToNextSibling(1)
			Quit:pNode.NodeData=")"
			
		}
		Quit:$$$ISERR(tSC)
		Set pCode.Condition = $E(tCondition,5,*)
		Set pElement = pCode.Condition
	} catch ex {
		Set tSC = ex.AsStatus() break:..Debug
	}
	Quit $$$OK
}

Method CodeWalkor(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNodeId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tCondition = ""
		For  {
			Kill tCond1,tCond2
			$$$MoveToFirstChild(pNode,"list")
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")
			Set tSC = ..GetElement(pNode,pCode,.tCompare,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (Compare) for or "_$system.Status.GetErrorText(tSC),0)
				Quit
			}
			$$$MoveToNextSibling(pNode,"")
			Set tSC = ..GetElement(pNode,pCode,.tCond1,.tType,,1)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (Cond1) for or "_$system.Status.GetErrorText(tSC),0)
				Quit
			}
			Set tCond2=""  // not all have two conditions
			If pNode.MoveToNextSibling(1) {
				Set tSC = ..GetElement(pNode,pCode,.tCond2,.tType,,1)
				If $$$ISERR(tSC) {
					Do ..ReportItem("Failed to GetElement (Cond2) for or "_$system.Status.GetErrorText(tSC),0)
					Quit
				}
			}
			Set tCompare = ..GetCompare(tCompare,tCond1,tCond2)
			Set tCondition = tCondition_" || ("_tCompare_")" 
			Quit:'pNode.MoveToParent(1)
			If 'pNode.MoveToNextSibling(1) || (pNode.NodeData '= ")") {
				Do ..DisableObject(pNode,pCode,"Expected closing paren on the and",tNodeId)
				Quit
			}
			If pNode.MoveToNextSibling(1) {
				Do ..DisableObject(pNode,pCode,"Unexpected sibling on the and",tNodeId)
				Quit
			}
			
			If 'pNode.MoveToParent(1) || 'pNode.MoveToParent(1) {
				Do ..DisableObject(pNode,pCode,"Unable to move to parent",tNodeId)
				Quit
			}
			Quit:'pNode.MoveToNextSibling(1)
			Quit:pNode.NodeData=")"
			
		}
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failure for or "_$system.Status.GetErrorText(tSC),0)
			Quit
		}
		Set pCode.Condition = $E(tCondition,5,*)
		Set pElement = pCode.Condition
	} catch ex {
		Set tSC = ex.AsStatus() break:..Debug
		Do ..ReportItem("Failure for or "_$system.Status.GetErrorText(tSC),0)
	}
	Quit $$$OK
}

Method CodeWalknot(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopId = pNode.NodeId
	try {
		Set tSC = $$$OK
		$$$MoveToNextSibling(pNode,"")
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		
		Set tSC = ..GetCondition(pNode,pCode)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get contains variable",tTopId)
			Quit
		}
		If pCode.Condition="" break  Do ..ReportItem("Code walk not Condition is null",0)
		break:pCode.Condition=""&&..Debug

		Set pCode.Condition = "'("_pCode.Condition_")"
		Set pElement = pCode.Condition
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalknot-empty-string?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in not-empty-string?",tTopId)
			Quit
		}
		Set pElement =  tItem1_"'="""""
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkempty-string?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in empty-string?",tTopId)
			Quit
		}
		Set pCode.Condition = tItem1_"="""""
		Set pElement = pCode.Condition
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkstring-empty?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit .."CodeWalkempty-string?"(pNode,.pCode)
}

Method "CodeWalkstring>?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in string>?",tTopId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Value in string>?",tTopId)
			Quit
		}
		Set pCode.Condition = tItem1_"]"_tValue
		Set pElement = pCode.Condition
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkstring<?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in string<?",tTopId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in string<?",tTopId)
			Quit
		}
		Set pCode.Condition = tItem1_"']"_tValue
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkstring=?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in string=?",tTopId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in string=?",tTopId)
			Quit
		}
		Set pCode.Condition = tItem1_"="_tValue
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalk="(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in =",tTopId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item2 in =",tTopId)
			Quit
		}
		Set pCode.Condition = tItem1_"="_tItem2
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalk>"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in >",tTopId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item2 in >",tTopId)
			Quit
		}
		Set pCode.Condition = tItem1_">"_tItem2
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalk<"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in <",tTopId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in <",tTopId)
			Quit
		}
		Set pCode.Condition = tItem1_"<"_tItem2
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkvalid-integer?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in valid-integer?",tTopId)
			Quit
		}
		Set pElement =  "(..Matches("_tItem1_",""1N.N""))"
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method GetVariable(pVariable, pType) As %String
{
	#define Extract(%pVariable,%var,%what) Set %var=%pVariable,%what=$p(%var,":",2) If %what]"" {Set (%pVariable,%var)=$p(%var,":")}
	If $E(pVariable,1,2)=".." {
	}ElseIf $E(pVariable,1,7)="~input%" {
		$$$Extract(pVariable,tVariable,tExtract)
		Set tVariable = "source.{[|||"_$E(tVariable,8,*)_"|||]}"
		Set ..VariableReplacement(tVariable)=""
		Set tExtract = $CASE(tExtract,"0-":"","0-END":"","0,END":"","0,":"",:tExtract)
		If tExtract]"" {
			Set tVariable=..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKEXTRACT")_"("_tVariable_","""_tExtract_""")"
		}
		Set pVariable = tVariable
	} ElseIf $E(pVariable,1,8)="~output%" {
		$$$Extract(pVariable,tVariable,tExtract)
		Set tVariable = "target.{[|||"_$E(tVariable,9,*)_"|||]}"
		Set ..VariableReplacement(tVariable)=""
		/// for output if extract is 0- or 0-END replace output don't append we only append if we see ..Code("Targets",variable)
		If (tExtract = "0-") || (tExtract="0-END") {
			Set tTarget = $p($p(tVariable,"target.{",2),"}")
			Kill ..Code("Targets",tTarget_" ")
			Set tExtract=""
		}
		//Set tExtract = $CASE(tExtract,"0-":"","0-END":"","0,END":"","0,":"",:tExtract)
		If tExtract]"" {
			Set tVariable=..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKEXTRACT")_"("_tVariable_","""_tExtract_""")"
		}
		Set pVariable = tVariable
	} ElseIf $E(pVariable)=$C(34) {
	} Else {
		If pVariable ] "" {
			 Set tVariable = $TR(pVariable,..#VARIABLETRANSLATEFROM,..#VARIALBETRANSLATETO)
			 Set:tVariable'?1AN.E tVariable="t"_tVariable 
			 Set:pVariable'=tVariable ..Code("ConvertedVariables",pVariable)=tVariable
			 Set pVariable = tVariable
		}
	}
	Quit pVariable
}

Method "CodeWalkinteger?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tCond,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Condition in integer?",tTopId)
			Quit
		}
		Set pCode.Condition = "("_..GetVariable(tCond,tType)_"?1N.N)"
		If pNode.MoveToNextSibling(1) {
			Set pCode.Disabled=1
			Set pCode.Annotation = pCode.Annotation _$C(13,10)_ "Unexpected "_..ParsedNode(pNode)
		}
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkstring<=?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString1,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get contains variable",tNodeId)
			Quit
		}
		Set tString1 = ..GetVariable(tString1,tType)
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString2,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get substring ",tNodeId)
		}
		Set tString2 = ..GetVariable(tString2,tType)
		Set pCode.Condition = tString2_"]]"_tString1

	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalkstring-contains?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get contains variable",tNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tSubstring,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get substring ",tNodeId)
		}
		Set pCode.Condition = "..Contains("_tVariable_","_tSubstring_")"
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method DisableObject(pNode As %XML.Node, pCode, pString, pNodeId)
{
	Set pCode.Disabled=1
	Set tNodeId = pNode.NodeId
	Set pNode.NodeId = pNodeId
	Set pCode.Annotation = pCode.Annotation_$C(13,10)_pString_$c(13,10)_..ParsedNode(pNode)
	Do ..ReportItem(pString_" "_..ParsedNode(pNode),0)
	Set pNode.NodeId=tNodeId
}

Method GetCondition(pNode As %XML.Node, ByRef pCode As CodeIf) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNode = pNode.NodeId
		$$$MoveToFirstChild(pNode,"form")
		Set tSC = ..GetElement(pNode,pCode,.tCond,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get condition",tTopNode)
			Quit
		}
		Set tSC = $method($this,"CodeWalk"_tCond,pNode,pCode,.tElement,.tType,.tNodeId)  /// Conditionand Conditionnot Conditioninteger?
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get condition",tTopNode)
			Quit
		}
		If pCode.Condition="" || (tElement]"") {
			Set pCode.Condition = tElement
		}
		If pCode.Condition="" Do ..DisableObject(pNode,pCode,"Unable to get condition",tTopNode)
		
	} catch ex {
		Set tSC = ex.AsStatus() break:..Debug
	}
	Quit tSC
}

Method CodeWalkdo(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	try {
		Set tAnnotation = ..ParsedNode(pNode) 
		Set tForEach=##class(CodeForEach).%New()
		Set tForEach.Annotation = tAnnotation
		Do pCode.Insert(tForEach)
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no iterator for do",0) break  Quit
		Set tTopNodeId = pNode.NodeId 
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")
		Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,.tForEach,"Error getting for each variable "_$system.Status.GetErrorText(tSC),tTopNodeId) Quit
		} 
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected Init value for do",0) break  Quit
		Set tSC = ..GetElement(pNode,pCode,.tInit,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for init variable "_$system.Status.GetErrorText(tSC)) Quit
		} 
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected Increment value for do",0) break  Quit
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")
		Set tSC = ..GetElement(pNode,pCode,.tIncrement,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for each increment "_$system.Status.GetErrorText(tSC)) Quit
		} 
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected IncrementWhat value for do",0) break  Quit
		Set tSC = ..GetElement(pNode,pCode,.tIncrementWhat,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for each increment what "_$system.Status.GetErrorText(tSC)) Quit
		} 
		If tIncrementWhat=1 && (tVariable="l") { Set tIncrementWhat = tVariable}
		If tIncrementWhat'=tVariable Do ..DisableObject(pNode,tForEach,"IncrmentWhat:"_tIncrementWhat_" is not "_tVariable,tTopNodeId) break:..Debug

		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected IncrementByWhat value for do",0) Quit
		Set tSC = ..GetElement(pNode,pCode,.tIncrementByWhat,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for each increment by what "_$system.Status.GetErrorText(tSC)) Quit
		} 

		Set pNode.NodeId = tTopNodeId 
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no Eval",0) Quit
		Set tTopNodeId = pNode.NodeId
		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")

		$$$MoveToFirstChild(pNode,"list")
		$$$MoveToFirstChild(pNode,"(")
		$$$MoveToNextSibling(pNode,"forms")
		$$$MoveToFirstChild(pNode,"form")

		Set tSC = ..GetElement(pNode,pCode,.tEval,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for each eval "_$system.Status.GetErrorText(tSC)) Quit
		} 
		Set tNodeId = pNode.NodeId
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected eval what value for do",0) Quit
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tEvalWhat,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for each eval what "_$system.Status.GetErrorText(tSC)) Quit
		} 
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected expression what value for do",0) Quit
		Set tSC = ..GetElement(pNode,pCode,.tCount,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for each count "_$system.Status.GetErrorText(tSC)) Quit
		} 
		Set tForEach.Variable = tEvalWhat break:tEvalWhat=""
		Set tForEach.Property = tCount
		If tCount?1N.N {
			Do ..DisableObject(pNode,tForEach,"Expecting property to iterate found "_tCount,tTopNodeId)
		}
		Set pNode.NodeId = tTopNodeId
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected lines what value for do",0) Quit
		Set tTopNodeId = pNode.NodeId
		
		Set tSC = ..ProcessContent(pNode,tForEach.Lines)
	} catch ex {
		set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method CodeWalkcopy(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit .."CodeWalkcopy-strip"(pNode,.pCode,.pElement,.pType,.pNodeId)
}

Method "CodeWalkcopy-strip"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Annotation = ..ParsedNode(pNode)
		Set tCode.Variable = "uuuuERRORuuuu"
		Do pCode.Insert(tCode)
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no copy-strip",1) Quit
		Set tID=pNode.NodeId
		Set tSC = ..GetElement(pNode,tCode,.tValue,.tValueType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get tValue in copy-strip",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,tCode,.tVariable,.tType,,1) 
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get Variable in copy-strip",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,tCode,.tFormat,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get Format in copy-strip",tTopNodeId)
			Quit
		}
		Set tFormat = $zstrip(tFormat,"<>",$c(34)) 
	
		Set tCode.Variable=tVariable
		If $E(tValue)'=$c(34) {
			Set tValue = "..Strip("_tValue_","">W"")"
		}

		/// if output has an extract 
		If tCode.Variable[$parameter(..#FUNCTIONSETCLASS,"MONKEXTRACT") {
			//<assign value='"080000"' property='##class(EnsLib.InteropTools.HL7.eGate.Functions).MonkExtract(target.{PV2:ExpectedAdmitDateTime},"8,6")' action='set' disabled='1' >
			Set tVar = tCode.Variable
			//Set tValue = tCode.Value
			Set tTarget = $p($p(tVar,"target.{",2),"}")
			Set tVariable = "target.{"_tTarget_"}"
			Set ..Code("Targets",tTarget_" ")=""
			Set tPosition = $p($p(tVar,"},",2),")")
			Do $classMethod(..#FUNCTIONSETCLASS,$parameter(..#FUNCTIONSETCLASS,"MONKSTARTEND"),tPosition,.tStart,.tEnd)
			Set tCode.Variable = "ISCuTEMP"
			Set tCode.Value = tVariable

			Set tCode = ##class(CodeSet).%New()
			Set tCode.Variable = "$Extract(ISCuTEMP,"_tStart_","_tEnd_")"
			Set tCode.Value = tValue
			Do pCode.Insert(tCode)

			Set tCode = ##class(CodeSet).%New()
			Set tCode.Variable = tVariable
			Set tCode.Value = "ISCuTEMP"
			Do pCode.Insert(tCode)

			Set tCode.Disabled=1
			Set tCode.Annotation = "*** attempting to extract on property"_tCode.Annotation
		} Else {
			Set tTarget = $p($p(tCode.Variable,"target.{",2),"}")
			If $D(..Code("Targets",tTarget_" ")) {
				Set tCode.Action = "append"
			}
			Set tCode.Value = tValue
			Set ..Code("Targets",tTarget_" ")=""
		}
		If tFormat'=$C(34,34) && (tFormat'="") {
			Set tCode.Value = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKFORMAT")_"("_tCode.Value_","""_tFormat_""")"
		}

	} catch ex {
		Do ..ReportItem("Fatal error "_$system.Status.GetErrorText(ex.AsStatus()),1)
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) && $D(tTopNodeId) {
		Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
		Do ..DisableObject(pNode,tCode,"Error",pNode.NodeId)
		Set tSC = $$$OK
	}
	Quit tSC
}

Method GetElement(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId, pConvertVariableName = 0) As %Status
{
	Set pElement="",pType=""
	Set tNodeId = pNode.NodeId
	try {
		Set tSC = $$$OK
		If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
		Set tField = pNode.NodeData
		If pNode.NodeType = $$$xmlTEXTNODE {
			For {
				Quit:'pNode.MoveToNextSibling(1) 
				Set tField = tField_$zstrip(pNode.NodeData,"<>WC")
				Set pNodeId = pNode.NodeId
			}
			Set tField = $c(34)_tField_$c(34)
		}
		Set tSC = $method($this,"CodeWalk"_tField,pNode,pCode,.pElement,.pType,.tNodeId)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error with CodeWalk"_tField_"  "_$system.Status.GetErrorText(tSC))
			Quit
		}
		If pConvertVariableName && '$G(pElement("SubDone")){
			Set pElement = ..GetVariable(pElement,pType)
			Set pElement("SubDone")=1
		} Else {
			Set:pElement]"" pElement = $g(..Code("ConvertedVariables",pElement),pElement)
		}
	} catch ex {
		Set tSC = ex.AsStatus() break:..Debug  Do ..ReportItem("error in get element "_$system.Status.GetErrorText(tSC),0)
	}
	Set pNode.NodeId = tNodeId
	Quit tSC
}

Method CodeWalksubseq(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Var in subseq",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tFrom,.tType)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get From in subseq",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tTo,.tType)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get To in subseq",tTopNodeId)
		Quit
	}
	Set pElement="..SubString("_tVar_","_tFrom_","_tTo_")"
	Set pElement("SubDone")=1
	Quit $$$OK
}

Method "CodeWalktrim-string-left"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Var in trim-string-left",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tStrip,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Strip in trim-string-left",tTopNodeId)
		Quit
	}
	Set pElement="..Strip("_tVar_",""<"","_tStrip_")"
	Set pElement("SubDone")=1
	Quit $$$OK
}

Method "CodeWalkstring-trim"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Var in string-trim",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tStrip,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Strip in string-trim",tTopNodeId)
		Quit
	}
	Set pElement="..Strip("_tVar_",""<"","_tStrip_")"
	Set pElement("SubDone")=1
	Quit $$$OK
}

Method "CodeWalkstring-substitute"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tOld,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Old value in string-substitute",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tNew,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get New value in string-substitute",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get Variable value in string-substitute",tTopNodeId)
		Quit
	}
	Set pElement = "..ReplaceStr("_tVariable_","_tOld_","_tNew_")"
	Set pElement("SubDone")=1
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Quit $$$OK
}

/// (strip-punct source)
Method "CodeWalkstrip-punct"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get Source value in strip-punct",tTopNodeId)
		Quit
	}
	Set pElement = "..Strip("_tSource_",""*P"")"
	Set pElement("SubDone")=1
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)  // move back up out of list
	Quit $$$OK
}

// (string-append string...stringN)

Method "CodeWalkstring-append"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	For  {
		Quit:'pNode.MoveToNextSibling(1)
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get value in string-append",tTopNodeId)
			Quit
		}
		Set pElement = pElement _"_"_ tValue
		Kill tValue  // need to remove tValue("SubDone") 
	}
	Set pElement = $E(pElement,2,*)
	Set pElement("SubDone")=1 
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Quit $$$OK
}

Method "CodeWalk$event->string"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set pElement="unknown event-string"
	Quit $$$OK
}

Method "CodeWalkstrip-string"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tFunction,.tType)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get function in strip-string",tTopNodeId)
		Quit
	}
	Set tChars = $method($this,"GetCharacters"_tFunction)
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Source in strip-string",tTopNodeId)
		Quit
	}
	Set pElement = "..Strip("_tSource_",""_tChars_"")"
	Set pElement("SubDone")=1
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)  /// move back up out of list

	Quit $$$OK
}

Method "GetCharacterschar-alphabetic?"()
{
	Quit "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
}

Method "GetCharacterschar-whitespace?"()
{
	Quit " "
}

Method CodeWalksymbol(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tNodeId = pNode.NodeId
	If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
	Set tSC = $method($this,"CodeWalk"_pNode.NodeData,.pNode,.pCode,.pElement,.pType,.pNodeId)
	Set pNode.NodeId = tNodeId
	Quit tSC
}

Method "CodeWalksimple_sym"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tNodeId = pNode.NodeId
	If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
	Set tSC = $$$OK
	Set pElement=""
	For  {
		Set pElement = pElement_pNode.NodeData
		Quit:'pNode.MoveToNextSibling(1)
	}
	Set pElement = $zcvt(pElement,"I","XML")
	Set pType = "simple_sym"
	Set pNode.NodeId = tNodeId
	Quit tSC
}

Method CodeWalkliteral(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tNodeId = pNode.NodeId
	try {
		Set tSC = $$$OK
		If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
		If pNode.NodeData="string" || (pNode.NodeData="number") {
			If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
			Set pElement = pNode.NodeData
			Set pType = "string"
			For  {
				Quit:'pNode.MoveToNextSibling(1)
				Set pElement = pElement_pNode.NodeData
			}
			If $E(pElement)'=$c(34) {
				Set pElement = $replace(pElement,$C(34),$C(34,34))
			} Else {
				Set pElement = $C(34)_$replace($E(pElement,2,*-1),$C(34),$C(34,34))_$C(34)
			}
			Set pElement = $zcvt(pElement,"I","XML")
		} ElseIf pNode.NodeData="character" {
			If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
			Set pType="character"
			If pNode.NodeData'="any_char" {break}
			If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
			Set pElement = $zcvt(pNode.NodeData,"I","XML")
		} ElseIf pNode.NodeData="symbol" {
			Set tSC = $method($this,"CodeWalksymbol",pNode,.pCode,.pElement,.pType,.pNodeId)
		} Elseif pNode.NodeData="param_name" {
			If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
			Set pElement = pNode.NodeData
			Set pType = "param_name"
		} Else {
			Write pNode.NodeData  break:..Debug
			Do pNode.MoveToParent(1)
			Do ..ReportItem("Failed to parse "_..ParsedNode(pNode),1) 
		}
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Set pNode.NodeId = tNodeId
	Quit tSC
}

Method CodeWalklist(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNode = pNode.NodeId
	$$$MoveToFirstChild(pNode,"(")
	$$$MoveToNextSibling(pNode,"forms")
	$$$MoveToFirstChild(pNode,"form")
	For {
		Set tVariableTop = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tCall,.tType,.pNodeId) 
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Call in list",tTopNode)
			Quit
		}
		If tCall]"" {
			try {
				Set tSC = $method($this,"CodeWalk"_tCall,pNode,pCode,.tElement,.tType,.pNodeId)
			} catch ex {
				Set tElement = "Failure "_..ParsedNode(pNode)
				Write !,"Failed to find handler for "_tCall 
				$$$LogMissingFunction(tCall,"eGate",..Filename)
			}
		}
		Merge pElement = tElement,pType=tType
		If $D(pNodeId) {
			Set pNode.NodeId=pNodeId
		}
		If pNode.MoveToNextSibling(1) {
			Quit
		}  Else {
			Quit
		}
	}
	Set pNode.NodeId=tTopNode

	break:..Debug&&$$$ISERR(tSC)
	Quit tSC
}

Method CodeWalkcount(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit .."CodeWalkcount-rep"(pNode,.pCode,.pElement,.pType,.pNodeId)
}

Method "CodeWalkcount-rep"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set pNodeId = pNode.NodeId
	Set tSC = ..GetElement(pNode,pCode,.pElement,.pType,,1)
	Set pElement("SubDone")=1
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Element in count-rep",tTopNodeId)
		Quit
	}
	Quit tSC
}

Method "CodeWalkstring->number"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.pElement,.pType,,1)
	Set pElement("SubDone")=1
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Element in string->number",tTopNodeId)
		Quit
	}
	Quit tSC
}

Method "CodeWalkstring-length"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.pElement,.pType,,1)
	Set pElement = "..Length("_pElement_")"
	Set pElement("SubDone")=1
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Element in string->number",tTopNodeId)
		Quit
	}
	Quit tSC
}

Method "CodeWalkmake-string"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tReps,.pType)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get reps in make-string",tTopNodeId)
		Quit tSC
	}
	If $E(tReps,*)="#" {
		Set tReps=$E(tReps,1,*-1)  /// improper parsing - picking up part of fill string #\0
		Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
		Set tSib = pNode.MoveToNextSibling(1) 
		If 'tSib {
			Do ..DisableObject(pNode,pCode,"Failed to get character in make-string",tTopNodeId)
			Quit $$$ERROR($$$GeneralError,"Expected sibling in make-string")
		}
		Set tSC = ..GetElement(pNode,pCode,.tValue,.pType) 
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get backslash in make-string",tTopNodeId)
			Quit tSC
		}
		Set tStr = $zstrip(tValue,"<","\")
		
	} Else {
		Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
		Set tSib = pNode.MoveToNextSibling(1) 
		If 'tSib {
			Do ..DisableObject(pNode,pCode,"Failed to get character in make-string",tTopNodeId)
			Quit $$$ERROR($$$GeneralError,"Expected sibling in make-string")
		}
		Set tSC = ..GetElement(pNode,pCode,.tStr,.pType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get character in make-string",tTopNodeId)
			Quit tSC
		}
	
	}
	Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKMAKESTRING")_"("_tReps_","_tStr_")"
	
	Set pElement("SubDone")=1 
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Quit $$$OK
}

Method CodeWalkregex(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	$$$MoveToNextSibling(pNode,"")
	Set tSibling1=pNode.NodeId
	Set tSC = ..GetElement(pNode,pCode,.tMatchItem,.tType,,1)
	Quit:$$$ISERR(tSC) tSC
	$$$MoveToNextSibling(pNode,"")
	Set pNodeId = pNode.NodeId
	Set tSibling2=pNode.NodeId
	Set tSC = ..GetElement(pNode,pCode,.tMatchValue,.tType,,1) 
	Set tMatchItem = $Replace(tMatchItem,"\"_$c(34),$C(34))
	Set tMatchItem = $Replace(tMatchItem,"\|","|")
	$$$SubstituteHex(tMatchItem)  /// substitute \x1C to $c(28)
	Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKREGEX")_"("_tMatchValue_","_$replace($replace($replace(tMatchItem,"\|","|"),"\^","^"),"\$","$")_")"
	Set pElement("SubDone")=1
	Quit $$$OK
}

Method "CodeWalk*"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit ..CodeWalkMath(pNode,pCode,.pElement,.pType,.pNodeId,"*")
}

Method "CodeWalk+"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit ..CodeWalkMath(pNode,pCode,.pElement,.pType,.pNodeId,"+")
}

Method "CodeWalk-"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit ..CodeWalkMath(pNode,pCode,.pElement,.pType,.pNodeId,"-")
}

Method CodeWalkMath(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId, pMath) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVal1,.tType,,1) 
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Value in Math",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVal2,.tType,,1) 
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Value2 in Math",tTopNodeId)
		Quit
	}
	Set pElement = "("_tVal1_pMath_tVal2_")"
	Set pElement("SubDone")=1
	Quit $$$OK
}

Method "CodeWalkdiff-two-dates"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tDate1,.tType,,1) 
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date1 in diff-two-dates",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tDate2,.tType,,1) 
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date2 in diff-two-dates",tTopNodeId)
		Quit
	}
	Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKDATEDIFF")_"("_tDate1_","_tDate2_")"
	Set pElement("SubDone")=1
	Set pNodeId = pNode.NodeId
	Quit $$$OK
}

Method "CodeWalkreader_macro"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	Set pElement="",pType=""
	Set tNodeId = pNode.NodeId
	try {
		Set tSC = $$$OK
		If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
		If pNode.NodeData="string" {
			If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
			Set pElement = pNode.LocalName 
		} ElseIf pNode.NodeData="unquote" {
			Set tUnquoteId = pNode.NodeId
			If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
			Set pElement = pElement_pNode.NodeData
			break:pNode.NodeData'="~"
			If 'pNode.MoveToNextSibling(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"Expected sibling after ~"))
			Set tSC = ..GetElement(pNode,pCode,.tElement,.tType)
			$$$ThrowOnError(tSC)
			Set pElement = pElement_tElement
			Set pType = "unquote,"_tType
			Set pNode.NodeId=tNodeId
			If 'pNode.MoveToParent(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"Error with move to parent"))
			If 'pNode.MoveToNextSibling(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"Expected sibling after reader_macro"))
			Set tSC = ..GetElement(pNode,pCode,.tElement,.tType)
			If $$$ISERR(tSC) {
				Do ..DisableObject(pNode,pCode,"Failed to get element in reader_macro",tTopNodeId)
				Quit
			}
			If tElement'="%" break
			Set pElement = pElement_tElement
			Set pType = pType_","_tType
			If 'pNode.MoveToNextSibling(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"Expected sibling after reader_macro"))
			Set tSC = ..GetElement(pNode,pCode,.tElement,.tType)
			If $$$ISERR(tSC) {
				Do ..DisableObject(pNode,pCode,"Failed to get element in reader_macro",tTopNodeId)
				Quit
			}
			Set pElement = pElement_tElement
			Set pType = pType_","_tType
			Set pNodeId=pNode.NodeId
		} ElseIf pNode.NodeData="gensym" {
			Set tUnquoteId = pNode.NodeId   
			If 'pNode.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child"))
			Set pElement = pElement_pNode.NodeData
			//If 'pNode.MoveToNextSibling(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No sibling"))
			Set pNodeId=pNode.NodeId
		} Else {
			break:..Debug
			Do pNode.MoveToParent(1)
			Do ..ReportItem("Failed to parse "_..ParsedNode(pNode),1) 
		}
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Set pNode.NodeId = tNodeId
	Quit tSC
}

Method CodeWalkcase(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tNodeId = pNode.NodeId
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	Set tCode = ##class(CodeCOS).%New()
	Do pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/*"_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	Quit $$$OK
}

Method CodeWalkdisplay(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tCode = ##class(CodeCOS).%New()
	Do:..#INCLUDECODENOTATIONS pCode.Insert(tCode)
	Set tAnnotation = ""
	For  {
		Set tSC = ..GetElement(pNode,tCode,.tText,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get element in display",tTopNodeId)
			Quit
		}
		Set tAnnotation = tAnnotation_$C(13,10)_tText
		Quit:'pNode.MoveToNextSibling(1)
	}
	Quit tSC
}

Method CodeWalkuniqueid(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	Set tCode = ##class(CodeCOS).%New()
	Do pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/* unexpected uniqueid "_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	Do ..ReportItem("unexpected uniqueid "_..ParsedNode(pNode),0)
	Quit $$$OK
}

Method CodeWalkcomment(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	$$$MoveToNextSibling(pNode,"")
	Set tCode = ##class(CodeCOS).%New()
	Set tAnnotation = ""
	For  {
		Set tND = ..ParsedNode(pNode)
		If tND'="""" {
			Set tAnnotation = tAnnotation_$c(13,10)_tND
		}
		Quit:'pNode.MoveToNextSibling(1)
	}
	Set tCode.Annotation = tAnnotation
	Do pCode.Insert(tCode)
	Quit $$$OK
}

Method CodeWalknewline(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	Set tCode = ##class(CodeCOS).%New()
	Do:..#INCLUDECODENOTATIONS pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/*"_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	Quit $$$OK
}

/// (data-map source-path destination_path filename format trim-chars)
/// Use the data-map operator to match a string in the input message with a string stored in an ASCII text file. The mapping data associated with the matching string is inserted into the output message.
Method "CodeWalkdata-map"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Try {
		Set tSC = $$$OK
		Set tTopNodeId = pNode.NodeId
		Set tCode = ##class(CodeSet).%New()
		Do pCode.Insert(tCode)
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get element in display",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get element in display",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tFilename,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get element in display",tTopNodeId)
			Quit
		}
		Set tFilename = ##class(%File).GetFilename($zstrip(tFilename,"<>",$C(34)))
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tFormat,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get element in display",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tTrimChars,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get element in display",tTopNodeId)
			Quit
		}
		Set tCode.Variable = tVariable
		Set tTableName = $$$Param(TableGroupName)_$E($zstrip(tFilename,"<>W"),1,*-4)
		
		Set tDefault = $G($$$TableDefaults(tTableName))
		//Set tValue = ..Lookup(tTableName,tValue,default,defaultOnEmptyInput)
		Set tValue ="..Lookup("_$c(34)_tTableName_$C(34)_","_tSource_","_tDefault_","_tDefault_")"
		Set tTrimChars = $zstrip(tTrimChars,"<>",$C(34))
		If tTrimChars]"" {
			Set tValue = "..Strip("_tValue_",""<>"","_tTrimChars_")"
		} 
		Set tFormat = $zstrip(tFormat,"<>",$C(34))
		If tFormat'="" {
			Set tValue = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKFORMAT")_"("_tValue_","_tFormat_")"
		}
		Set tCode.Value = tValue
		Set tCode.Disabled=0
	} Catch ex {
		Set tSC = ex.AsStatus() break
	}

	Quit tSC
}

Method "CodeWalkiq-put"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tCode = ##class(CodeCOS).%New()
	Set tCode.Annotation = "Unknown function: "_..ParsedNode(pNode)
	Do tCode.Lines.Insert($C(9)_"//"_tCode.Annotation)
	Do pCode.Insert(tCode)
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	Do pNode.MoveToParent(1),pNode.MoveToParent(1)
	Quit $$$OK
}

Method "CodeWalkset!"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tCode = ##class(CodeSet).%New()
	Set tCode.Disabled=1
	Set tCode.Annotation = ..ParsedNode(pNode)
	Do pCode.Insert(tCode)
	Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get variable in set!",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get value in set!",tTopNodeId)
		Quit
	}
	Set tCode.Variable = tVariable
	Set tCode.Value = tValue
	Set tCode.Disabled=0
	Quit $$$OK
}

Method CodeWalktimestamp(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tCode = ##class(CodeSet).%New()
	Set tCode.Disabled=1
	Set tCode.Annotation = ..ParsedNode(pNode)
	Do pCode.Insert(tCode)
	Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get variable in timestamp",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tDateTimeFormat,.tType)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get DateTimeFormat in timestamp",tTopNodeId)
		Quit
	}
	Set tCode.Variable = tVariable
	Set tCode.Value = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKTIMEFORMAT")_"("_tDateTimeFormat_")"
	Set tCode.Disabled=0
	Quit $$$OK
}

Method CodeWalkresult(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	Set tCode = ##class(CodeCOS).%New()
	Do:..#INCLUDECODENOTATIONS pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/*"_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	Quit $$$OK
}

Method CodeWalkcatch(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	Set tCode = ##class(CodeCOS).%New()
	Do:..#INCLUDECODENOTATIONS pCode.Insert(tCode)
	Do tCode.Lines.Insert("	/*"_..NodeAsText(pNode)_"*/")
	Set tCode.Disabled=1
	
	Quit $$$OK
}

Method "CodeWalk$make-event-map"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.pElement,.pType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Element in make-event-map",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set pNodeId = pNode.NodeId
	Quit tSC
}

Method ProcessContent(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNode=pNode.NodeId

	For {
		Set tNode = pNode.NodeId
		Quit:pNode.NodeData=")"

		try {
			Set tMethod = pNode.NodeData
			Set tSC =  $method($this,"CodeWalk"_tMethod,pNode,pCode)
		} catch ex {
			Set tSC = ex.AsStatus() break
		}
		Quit:$$$ISERR(tSC)
		Set pNode.NodeId=tNode
		Quit:'pNode.MoveToNextSibling(1)
		break:pNode.NodeData=")"
	}
	Set pNode.NodeId=tTopNode
	Quit $$$OK
}

Method ParsedNode(pNode) As %String
{
	Set tText = $zstrip(..NodeAsText(pNode),"*C")
	For {
		Set tPos = $F(tText,"  ")
		Quit:'tPos
		Set tText=$E(tText,1,tPos-2)_$E(tText,tPos,*)
	}
	Quit $zstrip(tText,"<>W")
}

Method "CodeWalkstring-upcase"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Source in string-upcase",tTopNodeId)
		Quit
	}
	Set pElement = "..ToUpper("_tSource_")"
	Set pElement("SubDone")=1
	Quit tSC
}

Method "CodeWalkget-last-name"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Source in get-last-name",tTopNodeId)
		Quit
	}
	Set pElement = "(..Piece("_tValue_","",""))"
	Set pElement("SubDone")=1
	Quit tSC
}

Method "CodeWalkget-middle-name"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Value in get-middle-name",tTopNodeId)
		Quit
	}
	/// Take Second piece by , and strip leading trailing spaces, and take second piece by space
	Set pElement = "(..Piece(..Strip(..Piece("_tValue_","","",2),""<>W""),"" "",2,*))"

	Set pElement("SubDone")=1
	Quit tSC
}

Method "CodeWalkget-first-name"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Value in get-first-name",tTopNodeId)
		Quit
	}
	/// Take Second piece by , and strip leading trailing spaces, and take first piece by space
	Set pElement = "(..Piece(..Strip(..Piece("_tValue_","","",2),""<>W""),"" "",1))"
	Set pElement("SubDone")=1
	Quit tSC
}

/// (find-get-before source substring)
Method "CodeWalkfind-get-before"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date1 in diff-two-dates",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSubstring,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date1 in diff-two-dates",tTopNodeId)
		Quit
	}
	Set pElement = "..Piece("_tSource_","_tSubstring_")"
	Set pElement("SubDone")=1
	Quit tSC
}

/// (find-get-before source substring)
Method "CodeWalkfind-get-after"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date1 in diff-two-dates",tTopNodeId)
		Quit
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSubstring,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date1 in diff-two-dates",tTopNodeId)
		Quit
	}
	Set pElement = "..Piece("_tSource_","_tSubstring_",2,""*"")"
	Set pElement("SubDone")=1
	Quit tSC
}

}
