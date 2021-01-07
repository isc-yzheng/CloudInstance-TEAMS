/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.CodeBuilder

Include EnsLib.InteropTools.HL7.Common

Class EnsLib.InteropTools.HL7.DataGate.Parser Extends (EnsLib.InteropTools.HL7.GateSSC.Parser, EnsLib.InteropTools.HL7.Common)
{

/// Overriding FUNCTIONSETCLASS offers ability to direct to user defined function class
Parameter FUNCTIONSETCLASS = "EnsLib.InteropTools.HL7.DataGate.Functions";

/// Call based on FUNCTIONSETCLASS
Parameter FUNCTIONSET = "##class({..#FUNCTIONSETCLASS}).";

/// When set to 0 CopyStrip becomes Copy
Parameter COPYSTRIP = 1;

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
		} catch ex { break:..Debug}
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
					If 'pNode.MoveToFirstChild(1) {
						Do ..ReportItem("Failed to move to first child in form ",1) 
						break:..Debug
						Quit
					}
				
				}
				If pNode.LocalName = "list" {
					If 'pNode.MoveToFirstChild(1) {
						Do ..ReportItem("Failed to move to first child in form ",1) 
						break:..Debug
						Quit
					}
					If 'pNode.MoveToNextSibling(1) {
						Do ..ReportItem("Failed to move to first next sibling in form ",1) 
						break:..Debug
						Quit
					}
					If pNode.NodeData'="forms" {
						Do ..ReportItem("expected forms node in list ",1) 
						break:..Debug
						Quit
					}
					try {
						Set tSC = $method($this,"CodeWalk"_pNode.NodeData,pNode,pCode,.pElement)
						Quit:$$$ISERR(tSC)
						//Break:pElement]""
					} catch ex {
						Set tSC = ex.AsStatus() break:..Debug
					}
				} ElseIf pNode.LocalName = "literal" {
					Set tLiteral = $zstrip(..NodeAsText(pNode),"<>WC")
					If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent for "_tLiteral,1) Quit
					try {
						Set tSC = $method($this,"CodeWalk"_tLiteral,pNode,pCode,.pElement)
						Break:'tSC&&..Debug  if 'tSC Do ..ReportItem("error in code walk form executing "_tLiteral_" "_$system.Status.GetErrorText(tSC),0)
						Quit:$$$ISERR(tSC)
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
			Set tCode = ##class(CodeCOS).%New()
			Set tCode.Annotation = ..NodeAsText(pNode)
			Do tCode.Lines.Insert($c(9)_"/*"_$C(13,10,9)_..NodeAsText(pNode)_"*/") 
			Do pCode.Insert(tCode)
			Do ..ReportItem("Error with define"_$system.Status.GetErrorText(tSC),0) Quit
		}
		If pNode.MoveToNextSibling(1) {
			break:..Debug  ///shouldn't be more siblings
			Do ..ReportItem("Unexpected additional siblings",0)
		}
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
		set tSC = ex.AsStatus()
		Do ..ReportItem("Error in Define "_$system.Status.GetErrorText(tSC))
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
		Do ..DisableObject(pNode,pCode,"Failed to get Element in stinrg->ssn",tTopNodeId)
		Quit tSC
	}
	Quit tSC
}

Method "CodeWalkstring-begins-with?"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString,.pType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed string-begins-with? "_$system.Status.GetErrorText(tSC))
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tSubString,.pType,,1) 
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed substring string-begins-with? "_$system.Status.GetErrorText(tSC))
			Quit
		}
		Set pElement = "..StartsWith("_tString_","_tSubString_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalksubstring-index"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tPattern,.pType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed substring-index "_$system.Status.GetErrorText(tSC))
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString,.pType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed substring-index "_$system.Status.GetErrorText(tSC))
			Quit
		}
		Set pElement = "$FIND("_tString_","_tPattern_")"
		Set pElement("SubDone")=1
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method CodeWalkcapitalize(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString,.pType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed capitalize "_$system.Status.GetErrorText(tSC))
			Quit
		}
		Set pElement = "..ToUpper("_tString_")"
		Set pElement("SubDone")=1
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalkstring-downcase"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString,.pType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed string-downcase "_$system.Status.GetErrorText(tSC))
			Quit
		}
		Set pElement = "..ToLower("_tString_")"
		Set pElement("SubDone")=1
	} Catch ex {
		Set tSC = ex.AsStatus()
		break:..Debug
	}
	Quit tSC
}

Method "CodeWalkstring-ends-with?"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.pType,,1)
	If $$$ISERR(tSC) {
		Do ..ReportItem("Failed string-ends-with? "_$system.Status.GetErrorText(tSC))
		Quit
	}
	Set tSC = ..GetElement(pNode,pCode,.tPattern,.pType,,1)
	If $$$ISERR(tSC) {
		Do ..ReportItem("Failed string-ends-with? "_$system.Status.GetErrorText(tSC))
		Quit
	}
	Set tPattern="%"_tPattern
	Set pElement = "..Like("_tString_","_tPattern_")"
	Quit tSC
}

Method ProcessXLATE(pNode As %XML.Node, pCode) As %Status
{
	break:..Debug
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
			Set tNodeId = pNode.NodeId
			If pNode.NodeType = $$$xmlTEXTNODE && (pNode.NodeData = ")") Quit
			If pNode.NodeType = $$$xmlELEMENTNODE {
				If pNode.NodeData = "form" {
					Do $method($this,"CodeWalk"_pNode.NodeData,pNode,pCode)
				} else {
					Set tCode = ##class(CodeCOS).%New()
					Do pCode.Insert(tCode)
					Do ..DisableObject(pNode,tCode,"Unexpected "_pNode.NodeData,tSaveNodeId)
					Do tCode.Lines.Insert("	/*"_tCode.Annotation_"*/")
					For  Quit:'pNode.MoveToNextSibling(1)
					Quit 
				}
			} Else {
				break:..Debug  ///not an element node
			}
			Quit:'pNode.MoveToNextSibling(1)  /// ifinstr
		}
	} catch ex {
		set tSC = ex.AsStatus() break:..Debug
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
		set tSC = ex.AsStatus() break:..Debug
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
		Set tId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1) 
		Set pNode.NodeId = tId
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("unable to find let value",1) Quit
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1) 
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Variable = tVar 
		Set tValue = $zstrip(tValue,"<>",$c(34))
		Set:tType="string" tValue = $C(34)_tValue_$C(34)
		Set tCode.Value = tValue
		If tValue = "" {
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
	Set tTopNodeId = pNode.NodeId
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no begin items",0) Quit  /// message string
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no begin items",0) Quit  /// message parse
	Set tSC =  ..ProcessContent(pNode,pCode)
	Set pNode.NodeId = tTopNodeId
	If $$$ISERR(tSC) {
		Do ..ReportItem("Failed to process lambda content",0)
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
		If 'pNode.MoveToFirstChild(1) {
			Do ..ReportItem("Expected if condition",1)
		}
		Set tAnnotation = ..ParsedNode(pNode)
		Set tCode = ##class(CodeIf).%New()
		Set tCode.Annotation = tAnnotation
		Set tCode.Condition = "uuuUNKNOWNuuu"
		//Set tNodeId=pNode.NodeId

		If pNode.NodeData'="list" {
			/// example :if RunningTestWindow?
			Set tSC = ..GetElement(pNode,tCode,.tCondition,.tType,,1)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Expected literal item "_$system.Status.GetErrorText(tSC),1) 
				Quit
			}
			Set tCode.Condition = tCondition
			Set pNode.NodeId = tNodeId
		} Else {
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			//Set tNodeId=pNode.NodeId
			Set tSC = ..GetCondition(pNode,tCode)
			//Set pNode.NodeId = tNodeId
			//If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
			//If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
		}
		Set pNode.NodeId=tNodeId
		Do pCode.Insert(tCode)
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
		Set tSC = ex.AsStatus()
		Do ..ReportItem("Failure in if "_$system.Status.GetErrorText(tSC),0)
		break:..Debug
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
		break:..Debug
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
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,tCode,.tSource,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to GetElement (Source) for change-pattern "_$system.Status.GetErrorText(tSC),0)
			Quit
		}
		//Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,tCode,.tDest,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to GetElement (Destination) for change-pattern "_$system.Status.GetErrorText(tSC),0)
			Quit
		}
		Set tCode.Variable = tDest
		//Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")

		Set tTopChoices = pNode.NodeId
		
		$$$MoveToFirstChild(pNode,"")
		If pNode.NodeData="reader_macro" {
			$$$MoveToFirstChild(pNode,"quote")
			$$$MoveToFirstChild(pNode,"'")
			$$$MoveToNextSibling(pNode,"form")
			$$$MoveToFirstChild(pNode,"list")
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")
		} ElseIf pNode.NodeData="list" {
			/// code using ' instead of quote()
			/// <list>(<forms><form><literal><symbol><simple_sym>quote</simple_sym></symbol></literal></form><form><list>(<forms><form><list>(<forms><form>
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")
			Set tQuoteTop = pNode.NodeId
			$$$MoveToFirstChild(pNode,"literal")
			$$$MoveToFirstChild(pNode,"symbol")
			$$$MoveToFirstChild(pNode,"simple_sym")
			$$$MoveToFirstChild(pNode,"quote")
			Set pNode.NodeId = tQuoteTop
			$$$MoveToNextSibling(pNode,"form")

			//$$$MoveToFirstChild(pNode,"literal")
			$$$MoveToFirstChild(pNode,"list")
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")
		} Else {
			break:..Debug // not reader_macro or list
		}
		Set tQuote = pNode.NodeId 
		Set tCase = ""
		For  {
			Set tTopList = pNode.NodeId
			$$$MoveToFirstChild(pNode,"list")
			$$$MoveToFirstChild(pNode,"(")
			$$$MoveToNextSibling(pNode,"forms")
			$$$MoveToFirstChild(pNode,"form")

			Set tTop = pNode.NodeId
			Set tSC = ..GetElement(pNode,tCode,.tFrom,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (From) for change-pattern "_$system.Status.GetErrorText(tSC),0)
				Quit
			}
			Set pNode.NodeId=tTop
			$$$MoveToNextSibling(pNode,"form")
			Set tTop = pNode.NodeId
			Set tSC = ..GetElement(pNode,tCode,.tTo,.tType)
			If $$$ISERR(tSC) {
				Do ..ReportItem("Failed to GetElement (To) for change-pattern "_$system.Status.GetErrorText(tSC),0)
				Quit
			}
			Set tCase=tCase_","_tFrom_","_tTo
			Set pNode.NodeId=tTopList

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
	} ElseIf pCompare = ">=" {
		Quit tCond1_">="_tCond2
	} ElseIf pCompare = "<" {
		Quit tCond1_"<"_tCond2
	} ElseIf pCompare = "<=" {
		Quit tCond1_"<="_tCond2
	} ElseIf pCompare = "regex" {
		Set tCond1 = $replace($replace($replace(tCond1,"\|","|"),"\^","^"),"\$","$")
		/// monk will do a contains on a regex if there are no special instructions
		If $TR(match,"?$.^{}()+\?<>|\")=match {
			Quit "..Contains("_tCond2_","_tCond1_")"
		}
		Quit ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKREGEX")_"("_tCond2_","_tCond1_")"
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
		Quit "Failure - Unknown Compare "_pCompare
		//break  /// what is pCompare
	}
}

/// (and test1 test2 ...)
/// The and expression stops processing and returns the result of the first test that returns false. If all expressions return true, not #f, the expression returns the result of the last expression evaluated. If no tests are listed, the #t is the result.
Method CodeWalkand(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNodeId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tCondition = ""
		For  {
			Set tNodeE = pNode.NodeId
			Set tSC = ..GetElement(pNode,pCode,.tCond,.tType,,1)
			Quit:$$$ISERR(tSC)
			Set pNode.NodeId = tNodeE
			Set tCondition = tCondition _ " && (" _ tCond _ ")" 
			Quit:'pNode.MoveToNextSibling(1)
		}
		Set pElement("SubDone")=1
		Quit:$$$ISERR(tSC)
		Set pCode.Condition = $E(tCondition,5,*)
		Set pElement = pElement_pCode.Condition
	} catch ex {
		Set tSC = ex.AsStatus() break:..Debug
		Do ..ReportItem("Fatal error "_$system.Status.GetErrorText(tSC),1)
	}
	Set pNode.NodeId=tNodeId
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
			Set tNodeE = pNode.NodeId
			Set tSC = ..GetElement(pNode,pCode,.tCond,.tType,,1)
			Quit:$$$ISERR(tSC)
			Set pNode.NodeId = tNodeE
			Set tCondition = tCondition _ " && (" _ tCond _ ")" 
			Quit:'pNode.MoveToNextSibling(1)
		}
		Quit:$$$ISERR(tSC)
		Set pCode.Condition = $E(tCondition,5,*)
		Set pElement = pElement_pCode.Condition
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus() break:..Debug
		Do ..ReportItem("Failure for or "_$system.Status.GetErrorText(tSC),0)
	}
	Quit $$$OK
}

Method "CodeWalkcount-children"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do ..ReportItem("not implemented count-children")
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
		If pCode.Condition="" break:..Debug  Do ..ReportItem("Code walk not Condition is null",0)
		Set pCode.Condition = "'("_pCode.Condition_")"
		Set pElement = pElement_pCode.Condition
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
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
		Set pElement = tItem1_"'="""""
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit $$$OK
}

Method "CodeWalkempty-string?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in empty-string?",tTopId)
			Quit
		}
		Set pElement = tItem1_"="""""
		Set pElement("SubDone")=1
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
		Set tTopId = pNode.NodeId

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
		Set pElement = tItem1_"]"_tValue
		Set pElement("SubDone")=1
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
		Set pElement = tItem1_"']"_tValue
		Set pElement("SubDone")=1
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
		Set pElement = tItem1_"="_tValue
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method CodeWalkequal(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit .."CodeWalk="(pNode,.pCode,.pElement,.pType,.pNodeId)
}

Method "CodeWalkequal?"(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit .."CodeWalk="(pNode,.pCode,.pElement,.pType,.pNodeId)
}

Method "CodeWalk="(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in =",tTopId)
			Quit
		}
		Set pNode.NodeId = tNodeId 
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item2 in =",tTopId)
			Quit
		}
		Set pElement = pElement_tItem1_"="_tItem2
		Set pElement("SubDone")=1
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
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in >",tTopId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item2 in >",tTopId)
			Quit
		}
		Set pElement = tItem1_">"_tItem2
		Set pElement("SubDone")=1
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
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tItem1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in <",tTopId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tItem2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Item in <",tTopId)
			Quit
		}
		Set pElement = tItem1_"<"_tItem2
		Set pElement("SubDone")=1
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
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
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
			Do $classMethod(..#FUNCTIONSETCLASS,"MonkGetStartEnd",tExtract,.tStart,.tEnd)
			Set:tEnd'?1N.N tEnd=$c(34)_tEnd_$c(34)
			Set tVariable="..SubString("_tVariable_","_tStart_","_tEnd_")"
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
			 If tVariable'="%" {
				 Set:tVariable'?1AN.E tVariable="t"_tVariable 
			 }
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
		Set tSC = ..GetElement(pNode,pCode,.tCond,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Condition in integer?",tTopId)
			Quit
		}
		Set pElement = "("_tCond_"?1N.N)"
		Set pElement("SudDone")=1
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
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tString1,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get contains variable",tNodeId)
			Quit
		}
		Set tString1 = ..GetVariable(tString1,tType)
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString2,.tType)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get substring ",tNodeId)
		}
		Set tString2 = ..GetVariable(tString2,tType)
		Set pElement = tString2_"]]"_tString1
		Set pElement("SudDone")=1
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalk<="(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tString1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get contains variable",tNodeId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get substring ",tNodeId)
		}
		Set pElement = tString1_"<="_tString2
		Set pElement("SudDone")=1
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method "CodeWalk>="(pNode As %XML.Node, ByRef pCode As CodeIf, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tString1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get contains variable",tNodeId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get substring ",tNodeId)
		}
		Set pElement = tString1_">="_tString2
		Set pElement("SudDone")=1
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
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get contains variable",tNodeId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tSubstring,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Unable to get substring ",tNodeId)
		}
		Set pElement = "..Contains("_tVariable_","_tSubstring_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Quit $$$OK
}

Method DisableObject(pNode As %XML.Node, pCode, pString, pNodeId)
{
	Set pCode.Disabled=1
	Set tNodeId = pNode.NodeId
	Set pNode.NodeId = $G(pNodeId,tNodeId)
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
		Set tNodeId = pNode.NodeId
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
		Set pElement = $g(pElement)_pCode.Condition
		Set pElement("SubDone")=1
		
	} catch ex {
		Set tSC = ex.AsStatus() break:..Debug
		Do ..ReportItem("Fatal error "_$system.Status.GetErrorText(ex.AsStatus()),1)
	}
	Quit tSC
}

Method CodeWalkdo(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tVeryTopNodeId = pNode.NodeId
 	try {
		Set tAnnotation = ..ParsedNode(pNode) 
		Set tForEach=##class(CodeForEach).%New()
		Set tForEach.Disabled=1
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
		Set tCountId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tCount,.tType)
		If $$$ISERR(tSC) {
			Do ..ReportItem("Error getting for each count "_$system.Status.GetErrorText(tSC)) Quit
		} 
		Set tForEach.Variable = tEvalWhat break:tEvalWhat=""
		Set tForEach.Property = tCount 
		Set pNode.NodeId = tTopNodeId
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected lines what value for do",0) Quit
		Set tTopNodeId = pNode.NodeId
		
		Set tSC = ..ProcessContent(pNode,tForEach.Lines)
		If tCount'?.E1"{".E1"}".E {
			Do ..DisableObject(pNode,tForEach,"Expecting property to iterate found ",tCountId)
		} Else {
			Set tForEach.Disabled=0
		}
	} catch ex {
		set tSC = ex.AsStatus() break
		Do ..ReportItem("Fatal error "_$system.Status.GetErrorText(ex.AsStatus()),1)
	}
	Set pNode.NodeId = tVeryTopNodeId 
	Do pNode.MoveToParent(1)
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
		If $E(tValue)'=$c(34) && ..#COPYSTRIP {
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

Method CodeWalkinsert(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Annotation = ..ParsedNode(pNode)
		Set tCode.Variable = "uuuuERRORuuuu"
		Do pCode.Insert(tCode)
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no insert",1) Quit
		Set tNodeId=pNode.NodeId
		Set tSC = ..GetElement(pNode,tCode,.tValue,.tValueType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get tValue in insert",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,tCode,.tVariable,.tType,,1) 
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get Variable in insert",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,tCode,.tFormat,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get Format in insert",tTopNodeId)
			Quit
		}
		Set tFormat = $zstrip(tFormat,"<>",$c(34)) 
	
		Set tCode.Variable=tVariable
		If $E(tValue)'=$c(34) && ..#COPYSTRIP {
			Set tValue = "..Strip("_tValue_","">W"")"
		}

		/// if output has an extract 
		If tCode.Variable[$parameter(..#FUNCTIONSETCLASS,"MONKEXTRACT") || (tCode.Variable["SubString") {
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
		If $E(pElement)=$C(34) && ($E(pElement,*)=$C(34)) {
			Set pElement = $E(pElement,2,*-1)
			Set pElement = $Replace(pElement,"\\\\","\")
			Set pElement = $Replace(pElement,"\""","""")
			Set pElement = $C(34)_pElement_$C(34)
		}
		If pConvertVariableName && '$G(pElement("SubDone")) {
			Set pElement = ..GetVariable(pElement,pType)
			Set pElement("SubDone")=1
		} Else {
			try {
				Set:pElement]"" pElement = $g(..Code("ConvertedVariables",pElement),pElement)
			} Catch ex {
			}
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
		Quit tSC
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
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tStrip,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Strip in trim-string-left",tTopNodeId)
		Quit tSC
	}
	Set pElement="..Strip("_tVar_",""<"","_tStrip_")"
	Set pElement("SubDone")=1
	Set pNode.NodeId = tTopNodeId

	Quit $$$OK
}

Method "CodeWalktrim-space-right"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNodeId=pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Var in trim-string-left",tTopNodeId)
			Quit
		}
		Set pElement="..Strip("_tVar_","">W"")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}	
	Quit tSC
}

Method "CodeWalktrim-space-left"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Var in trim-string-left",tTopNodeId)
			Quit 
		}
		Set pElement="..Strip("_tVar_",""<W"")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}	
	Quit tSC
}

Method "CodeWalktrim-string-right"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	If 'pNode.MoveToNextSibling(pNode)  break  //$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Var in trim-string-right",tTopNodeId)
		Quit tSC
	}
	If 'pNode.MoveToNextSibling(pNode)  break  //$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tStrip,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Strip in trim-string-right",tTopNodeId)
		Quit tSC
	}
	Set pElement="..Strip("_tVar_","">"","_tStrip_")"
	Set pElement("SubDone")=1
	Set pNode.NodeId = tTopNodeId
	Quit $$$OK
}

/// Strips leading / trailing space
Method "CodeWalktrim-space"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Var in string-trim",tTopNodeId)
		Quit tSC
	}
	Set pElement="..Strip("_tVar_",""<>"","_$c(32)_")"
	Set pElement("SubDone")=1
	Set pNode.NodeId = tTopNodeId
	Quit $$$OK
}

Method "CodeWalkstring-trim"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVar,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Var in string-trim",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tStrip,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Strip in string-trim",tTopNodeId)
		Quit tSC
	}
	Set pElement="..Strip("_tVar_",""<"","_tStrip_")"
	Set pElement("SubDone")=1
	Set pNode.NodeId = tTopNodeId

	Quit $$$OK
}

Method "CodeWalkstring-substitute"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tOld,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Old value in string-substitute",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tNew,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get New value in string-substitute",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get Variable value in string-substitute",tTopNodeId)
		Quit tSC
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
		Quit tSC
	}
	Set pElement = "..Strip("_tSource_",""*P"")"
	Set pElement("SubDone")=1
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)  // move back up out of list
	Quit $$$OK
}

/// (string-append string...stringN)
Method "CodeWalkstring-append"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	For  {
		Quit:'pNode.MoveToNextSibling(1)
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get value in string-append",tTopNodeId)
			Quit tSC
		}
		Set pElement = pElement _"_"_ tValue
		Kill tValue  // need to remove tValue("SubDone") 
	}
	Set pElement = $E(pElement,2,*)
	Set pElement("SubDone")=1 
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Quit $$$OK
}

Method "CodeWalkmake-message-structure"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Set pElement="unknown make-message-structure"
	Quit $$$OK
}

Method "CodeWalkmessage-parse"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Set pElement="unknown message-parse"
	Quit $$$OK
}

Method "CodeWalkmessage-clear"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Set pElement="unknown message-clear"
	Quit $$$OK
}

Method "CodeWalkmessage->string"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Do pNode.MoveToParent(1),pNode.MoveToParent(1),pNode.MoveToParent(1)
	Set pElement="unknown message-clear"
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
		Quit tSC
	}
	Set tChars = $method($this,"GetCharacters"_tFunction)
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Source in strip-string",tTopNodeId)
		Quit tSC
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

Method "GetCharacterschar-numeric?"()
{
	Quit "0123456789"
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
			break:..Debug  Do ..ReportItem("Failed to parse "_..ParsedNode(pNode),1) 
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
				Set tSC = ex.AsStatus()
				Set tElement = "Failure "_..ParsedNode(pNode)_ "   "_ $system.Status.GetErrorText(tSC)
				Write !,"Failed to find handler for "_tCall_" "_ $system.Status.GetErrorText(tSC)
				$$$LogMissingFunction(tCall,"Monk",..Filename)
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
	Set tSC = .."CodeWalkcount-rep"(pNode,.pCode,.pElement,.pType,.pNodeId)
	Quit tSC
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
		Quit tSC
	}
	Set pNode.NodeId = tTopNodeId
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
		Quit tSC
	}
	Quit tSC
}

Method "CodeWalknumber->string"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId=pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.pElement,.pType,,1)
	Set pElement("SubDone")=1
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Element in string->number",tTopNodeId)
		Quit tSC
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
		Quit tSC
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
	Set tMatchItem = $Replace(tMatchItem,"\^","^")
	Set tMatchItem = $Replace(tMatchItem,"\$","$")
	$$$SubstituteHex(tMatchItem)  /// substitute \x1C to $c(28)
	/// monk will do a contains on a regex if there are no special instructions
	If $TR(tMatchItem,"?$.^{}()+\?<>|\")=tMatchItem {
		Set pElement = "..Contains("_tMatchValue_","_tMatchItem_")"
	} Else {
		Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKREGEX")_"("_tMatchValue_","_tMatchItem_")"
	}
	Set pElement("SubDone")=1
	Quit $$$OK
}

Method "CodeWalk/"(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit ..CodeWalkMath(pNode,pCode,.pElement,.pType,.pNodeId,"/")
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
	Set tSC = ..CodeWalkMath(pNode,pCode,.pElement,.pType,.pNodeId,"-")
	Quit tSC
}

Method CodeWalkMath(pNode As %XML.Node, pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId, pMath) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tId = pNode.NodeId
	Set tSC = ..GetElement(pNode,pCode,.tVal1,.tType,,1) 
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Value in Math",tTopNodeId)
		Quit tSC
	}
	Set pNode.NodeId = tId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tVal2,.tType,,1) 
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Value2 in Math",tTopNodeId)
		Quit tSC
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
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tDate2,.tType,,1) 
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date2 in diff-two-dates",tTopNodeId)
		Quit tSC
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
		break:pNode.NodeData="reader_macro" 
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
		} ElseIf pNode.NodeData="dispatch" {
			Set tId = pNode.NodeId
			If 'pNode.MoveToFirstChild(1) || (pNode.NodeData'="#") {
				$$$ThrowOnError($$$ERROR($$$GeneralError,"Expected # in dispatch"))
			}
			If 'pNode.MoveToNextSibling(1) || (pNode.NodeData'="symbol") {
				$$$ThrowOnError($$$ERROR($$$GeneralError,"Expected symbol in dispatch"))
			}
			If 'pNode.MoveToFirstChild(1) || (pNode.NodeData'="simple_sym") {
				$$$ThrowOnError($$$ERROR($$$GeneralError,"expected simple_sym in dispatch"))
			}
			If 'pNode.MoveToFirstChild(1)  {
				$$$ThrowOnError($$$ERROR($$$GeneralError,"expected child in dispatch"))
			}

			Set pElement = pElement_$S(pNode.NodeData="f":0,pNode.NodeData="t":1)
			Set pNodeId=pNode.NodeId
		} Else {
			break:..Debug
			Do pNode.MoveToParent(1)
			break:..Debug  Do ..ReportItem("Failed to parse "_..ParsedNode(pNode),1) 
		}
	} catch ex {
		Set tSC = ex.AsStatus()
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
	Set tAnnotation = ..NodeAsText(pNode)
	Set pNode.NodeId = tTopNodeId
	Quit tSC
}

Method CodeWalkuniqueid(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Annotation = ..ParsedNode(pNode)
		Set tCode.Variable = "uuuuERRORuuuu"
		Do pCode.Insert(tCode)
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no uniqueid",1) Quit
		Set tID=pNode.NodeId
		Set tSC = ..GetElement(pNode,tCode,.tVariable,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get Variable in uniqueid",tTopNodeId)
			Quit
		}
		Set tCode.Variable=tVariable
		Set tCode.Value = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKUNIQUEID")_"()"
	} catch ex {
		Do ..ReportItem("Fatal error "_$system.Status.GetErrorText(ex.AsStatus()),1)
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) && $D(tTopNodeId) {
		Do ..DisableObject(pNode,tCode,"Error",pNode.NodeId)
		Set tSC = $$$OK
	}
	Quit tSC
}

Method CodeWalkcomment(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	$$$MoveToNextSibling(pNode,"")
	Set tCode = ##class(CodeCOS).%New()
	Set tAnnotation = ..ParsedNode(pNode)
	Set tString=""
	For  {
		Set tTop = pNode.NodeId
		$$$MoveToFirstChild(pNode,"literal") 
		$$$MoveToFirstChild(pNode,"string")
		$$$MoveToFirstChild(pNode,"") 
		Set tString = tString_$C(13,10)_ pNode.NodeData
		Set pNode.NodeId = tTop
		Quit:'pNode.MoveToNextSibling(1)
	}
	If tString]"" {
		Set tAnnotation = tString
	}
	Do tCode.Lines.Insert($C(9)_"/*"_$c(9)_tAnnotation_$c(13,10,9)_"*/")
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
		Set tSC = ex.AsStatus() break:..Debug
	}

	Quit tSC
}

Method "CodeWalkiq-put"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Try {
		Set tSC = $$$OK
		Set tCode = ##class(CodeCOS).%New()
		Set tCode.Annotation = "Unknown function: "_..ParsedNode(pNode)
		Do tCode.Lines.Insert($C(9)_"//"_tCode.Annotation)
		Do pCode.Insert(tCode)
		If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
		Do pNode.MoveToParent(1),pNode.MoveToParent(1)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method CodeWalkceiling(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get value in ceiling",tTopNodeId)
			Quit
		}
		Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKCEILING")_"("_tValue_")"
		Set pElement("SubDone")=1
	} catch {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
	//$system.SQL.Functions.CEILING(3.5)
}

Method "CodeWalkset!"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Disabled=1
		Set tCode.Variable = "uuuUNKNOWNuuu"
		Set tCode.Value = "''"
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
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
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
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tDateTimeFormat,.tType)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,tCode,"Failed to get DateTimeFormat in timestamp",tTopNodeId)
		Quit tSC
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
		Quit tSC
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
			Set tSC = ex.AsStatus() break:..Debug
		}
		Quit:$$$ISERR(tSC)
		Set pNode.NodeId=tNode
		Quit:'pNode.MoveToNextSibling(1)
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

Method "CodeWalkto-upper"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Source in string-upcase",tTopNodeId)
			Quit 
		}
		Set pElement = "..ToUpper("_tSource_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalkstring-upcase"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Source in string-upcase",tTopNodeId)
		Quit tSC
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
		Quit tSC
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
		Quit tSC
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
		Quit tSC
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
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSubstring,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date1 in diff-two-dates",tTopNodeId)
		Quit tSC
	}
	Set pElement = "..Piece("_tSource_","_tSubstring_")"
	Set pElement("SubDone")=1
	Quit tSC
}

/// (find-get-after source substring)
Method "CodeWalkfind-get-after"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Source in find-get-after",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSubstring,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Substring in find-get-after",tTopNodeId)
		Quit tSC
	}
	Set pElement = "..Piece("_tSource_","_tSubstring_",2,""*"")"
	Set pElement("SubDone")=1
	Quit tSC
}

Method "CodeWalkstrip-trailing-whitespace"(pNode As %XML.Node, pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Source in strip-trailing-whitespace",tTopNodeId)
		Quit tSC
	}
	Set pElement = "..Strip("_tSource_","">W"")"
	Set pElement("SubDone")=1
	Quit tSC
}

Method "CodeWalkstring>=?"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tString1,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get String1 in string>=?",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tString2,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get String2 in string>=?",tTopNodeId)
		Quit tSC
	}
	Set pElement = "(("_tString1_"]"_tString2_") || ("_tString1_"="_tString2_"))"
	Set pElement("SubDone")=1
	Quit tSC
}

/// / (if (substring=? "-" ~input%Athena_ADT.PID.PID-4-alternate_patient_ID[0] 2)  
Method "CodeWalksubstring=?"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tPattern,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Pattern in substring=?",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tString,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get String in substring=?",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tIndex,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Index in substring=?",tTopNodeId)
		Quit tSC
	}
	Set pElement = "(..Substring("_tString_","_(tIndex+1)_")="_tPattern_")"
	Set pElement("SubDone")=1
	Quit tSC
}

Method CodeWalksubstring(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tString,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get String in substring",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tStart,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get start in substring",tTopNodeId)
		Quit tSC
	}
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tEnd,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get start in substring",tTopNodeId)
		Quit tSC
	}
	Set pElement="..SubString("_tString_","_tStart_","_tEnd_")"
	Set pElement("SubDone")=1
	Quit tSC
}

Method "CodeWalkstandard-date"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Set tTopNodeId = pNode.NodeId
	$$$MoveToNextSibling(pNode,"")
	Set tSC = ..GetElement(pNode,pCode,.tDate,.tType,,1)
	If $$$ISERR(tSC) {
		Do ..DisableObject(pNode,pCode,"Failed to get Date in standard-date",tTopNodeId)
		Quit tSC
	}
	Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKSTANDARDDATE")_"("_tDate_")"
	Set pElement("SubDone")=1
	Quit tSC
}

/// The time expression returns the current system time, defined as the number of seconds since midnight, 1 January 1970, Coordinated Universal Time.
Method CodeWalktime(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNodeId = pNode.NodeId
		Set pElement = "$H"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = $$$OK
	}
	Quit tSC
}

// ( strftime "format-spec" time )

Method CodeWalkstrftime(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tFormat,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Format in strftime",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tTime,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Time in strftime",tTopNodeId)
			Quit
		}
		Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKTIMEFORMAT")_"("_tFormat_","_tTime_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = $$$OK
	}
	Quit tSC
}

Method "CodeWalkmake-vector"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tCount,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Count in make-vector",tTopNodeId)
			Quit
		}
		If pNode.MoveToNextSibling() {
			Set tSC = ..GetElement(pNode,pCode,.tFill,.tType,,1)
			If $$$ISERR(tSC) {
				Do ..DisableObject(pNode,pCode,"Failed to get Fill in make-vector",tTopNodeId)
				Quit
			}

		}
		Set pElement = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKMAKEVECTOR")_"("_tCount_$S(tFill]"":","_tFill,1:"")_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = $$$OK
	}
	Quit tSC
}

Method "CodeWalkvector-ref"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Variable in vector-ref",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tIndex,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Index in vector-ref",tTopNodeId)
			Quit
		}

		Set pElement = "$ListGet("_tVariable_","_tIndex_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = $$$OK
	}
	Quit tSC
}

Method "CodeWalkvector-set!"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC = $$$OK
		Set tTopNodeId = pNode.NodeId
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Annotation = ..ParsedNode(pNode)
		Set tCode.Variable = "uuuuERRORuuuu"
		Do pCode.Insert(tCode)
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Variable in vector-set",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tIndex,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Index in vector-set",tTopNodeId)
			Quit
		}

		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tValue,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Value in vector-set!",tTopNodeId)
			Quit
		}
		Set tCode.Variable = "$LI("_tVariable_","_tIndex_")"
		Set tCode.Disabled=1
		Set tCode.Value=tValue
	} catch ex {
		Set tSC = $$$OK
	}
	Quit tSC
}

Method "CodeWalkchar=?"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		Set tSC=$$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tChar1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Char1 in char=?",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tChar2,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Char2 in char=?",tTopNodeId)
			Quit
		}
		Set pElement = tChar1_"="_tChar2
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalknumber?"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		Set tSC=$$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tCond1,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Cond in number?",tTopNodeId)
			Quit
		}
		Set pElement = "(..Matches("_tCond1_","".N""))"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalkstring-ref"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		Set tSC=$$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tString,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get String in string-ref",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tPosition,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Position in string-ref",tTopNodeId)
			Quit
		}
		Set pElement = "..SubString("_tString_","_(tPosition+1)_","_(tPosition+1)_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalktime->hl7time"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC=$$$OK
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Annotation = ..ParsedNode(pNode)
		Set tCode.Variable = "uuuuERRORuuuu"
		Do pCode.Insert(tCode)
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Source in time->hl7time",tTopNodeId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tTarget,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Target in time->hl7time",tTopNodeId)
			Quit
		}
		Set tCode.Variable = tTarget
		Set tCode.Value = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKTOHL7TIME")_"("_tSource_")"
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalkdate->hl7date"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC=$$$OK
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Annotation = ..ParsedNode(pNode)
		Set tCode.Variable = "uuuuERRORuuuu"
		Do pCode.Insert(tCode)
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tSource,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Source in time->hl7time",tTopNodeId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tTarget,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Target in time->hl7time",tTopNodeId)
			Quit
		}
		Set tCode.Variable = tTarget
		Set tCode.Value = ..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKTOHL7DATE")_"("_tSource_")"
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method "CodeWalkcheck-digit"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC=$$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tVariable,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Variable in check-digit",tTopNodeId)
			Quit
		}
		Set pNode.NodeId=tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tPattern,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get Variable in check-digit",tTopNodeId)
			Quit
		}
		Set pElement=..#FUNCTIONSET_$parameter(..#FUNCTIONSETCLASS,"MONKCHECKDIGIT")_"("_tVariable_","_tPattern_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// (string-search-from-left function source)
Method "CodeWalkstring-search-from-left"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC=$$$OK
		Set tTopNodeId = pNode.NodeId
		Set pCode.Disabled=1
		Set pElement = "unexpectedString-Search-From-Left"
		Quit		
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tString,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get String in char-substitute",tTopNodeId)
			Quit
		}
		Set pNode.NodeId = tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tOrigChar,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get OriginalChar in char-substitute",tTopNodeId)
			Quit
		}

		Set pNode.NodeId = tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tNewChar,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get NewChar in char-substitute",tTopNodeId)
			Quit
		}
		Set pElement = "..ReplaceStr("_tString_","_tOrigChar_","_tNewChar_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// (char-substitute source origchar newchar)
Method "CodeWalkchar-substitute"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tSC=$$$OK
		Set tTopNodeId = pNode.NodeId
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tString,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get String in char-substitute",tTopNodeId)
			Quit
		}
		Set pNode.NodeId = tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tNodeId = pNode.NodeId
		Set tSC = ..GetElement(pNode,pCode,.tOrigChar,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get OriginalChar in char-substitute",tTopNodeId)
			Quit
		}

		Set pNode.NodeId = tNodeId
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tNewChar,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get NewChar in char-substitute",tTopNodeId)
			Quit
		}
		Set pElement = "..ReplaceStr("_tString_","_tOrigChar_","_tNewChar_")"
		Set pElement("SubDone")=1
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert will append to anything that has already been written to the outbound where as the insert-hard overwrites anything that has been written to the outbound.
Method "CodeWalkinsert-hard"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	try {
		Set tTopNodeId = pNode.NodeId
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Annotation = ..ParsedNode(pNode)
		Set tCode.Variable = "uuuuERRORuuuu"
		Do pCode.Insert(tCode)
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("no insert",1) Quit
		Set tID=pNode.NodeId
		Set tSC = ..GetElement(pNode,tCode,.tValue,.tValueType,,1)
		If $$$ISERR(tSC) {
			break:..Debug  Do ..DisableObject(pNode,tCode,"Failed to get tValue in insert",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,tCode,.tVariable,.tType,,1) 
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,tCode,"Failed to get Variable in insert",tTopNodeId)
			Quit
		}
	
		Set tCode.Variable=tVariable
		If $E(tValue)'=$c(34) {
			Set tValue = "..Strip("_tValue_","">W"")"
		}

		/// if output has an extract 
		If tCode.Variable[$parameter(..#FUNCTIONSETCLASS,"MONKEXTRACT") || (tCode.Variable["SubString") {
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
			Set tCode.Value = tValue
			Set ..Code("Targets",tTarget_" ")=""
		}
		Set tCode.Disabled=1  /// what is insert

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

/// This function is a variation of the Datagate provided change-pattern function.  Unlike the Datagate provided function, this function passes the existing data as is when the pattern is not found.  The Datagate provided function passes nothing when the pattern is not found. In most cases where the Datagate provided change-pattern exists in translation code, it is likely in error.  This custom function was created in response to a modification by the vendor in which the change-pattern function was modified during the DataGate 3.6.2 upgrade to match their documentation.  I think it is safe to always apply the logic of custom-change-pattern to all occurrences of change-pattern as well
Method "CodeWalkcustom-change-pattern"(pNode As %XML.Node, ByRef pCode, ByRef pElement = "", ByRef pType = "", ByRef pNodeId) As %Status
{
	Quit .."CodeWalkchange-pattern"(pNode,.pCode,.pElement,.pType,.pNodeId)
}

/// this is in an if... so it doesn't work
Method "CodeWalkeqv?"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	If 'pNode.MoveToParent() Do ..ReportItem("Failed to move to parent",1) Quit
	Set pCode.Annotation="unexpected eqv? "_..NodeAsText(pNode)
	Do ..ReportItem("unexpected eqv? "_..ParsedNode(pNode),0)
	Set pCode.Disabled=1
	Set pElement="uuuERRORUUU"
	Quit $$$OK
}

///  check-file ~input%MSG.EVN.1 "/home/datagate/data/events"
Method "CodeWalkcustom-check-file"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Try {
		Set tSC = $$$OK
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tPath,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get path in custom-check-file",tTopNodeId)
			Quit
		}
		$$$MoveToNextSibling(pNode,"")
		Set tSC = ..GetElement(pNode,pCode,.tFilename,.tType,,1)
		If $$$ISERR(tSC) {
			Do ..DisableObject(pNode,pCode,"Failed to get filename in custom-check-file",tTopNodeId)
			Quit
		}
		Set tFilename = ##class(%File).GetFilename($zstrip(tFilename,"<>W",$C(34)))

		Set tTableName = $$$Param(TableGroupName)_$P(tFilename,".")
		///ClassMethod Lookup(table As %String = "", value As %String = "", default As %String = "", defaultOnEmptyInput As %Integer = 0) As %String [ CodeMode = expression, Final ]
		Set tDefault = """|||Empty|||"""
		Set pElement ="'(..Lookup("_$c(34)_tTableName_$C(34)_","_tPath_","_tDefault_",3)="_tDefault_")"
		Set pElement("SubDone")=1
	} Catch ex {
		Set tSC = ex.AsStatus() break:..Debug
	}
	Quit tSC
}

///  check-file ~input%MSG.EVN.1 "/home/datagate/data/events"
Method "CodeWalkcustom-check-file-eq"(pNode As %XML.Node, ByRef pCode, ByRef pElement, ByRef pType, ByRef pNodeId) As %Status
{
	Try {
		Set tSC = $$$OK
		Set pCode.Annotation = pCode.Annotation _ "  unexpected "_ ..NodeAsText(pNode)
		Set pCode.Disabled = 1
		Set pElement = "UnexpectedCheckFileEq"
	} Catch ex {
		Set tSC = ex.AsStatus() break:..Debug
	}
	Quit tSC
}

}
