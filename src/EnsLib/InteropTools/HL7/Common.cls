/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.CodeBuilder

Include EnsLib.InteropTools.HL7.Common

Class EnsLib.InteropTools.HL7.Common Extends %RegisteredObject
{

Parameter CODEBUILDER = "EnsLib.InteropTools.CodeBuilder.Code";

Parameter DEFAULTVERSION = "2.3.1";

Parameter PERMANENTBAIL = 2;

Parameter CLASSNAMEPREFIX;

Parameter VARIABLETRANSLATEFROM = "-_?";

Parameter VARIALBETRANSLATETO = "duq";

Parameter INCLUDECOMMENTS = 1;

Property FixNote;

Property Annotate As %Boolean [ InitialExpression = 0 ];

/// Problems related to variable substitution
Property NoteVariable As %String(MAXLEN = "") [ MultiDimensional ];

Property Code As %String [ MultiDimensional ];

Property Debug As %Boolean [ InitialExpression = 0 ];

Property Bail As %Boolean [ InitialExpression = 0 ];

Property Filename As %String(MAXLEN = "");

Property VariableReplacement As %String(MAXLEN = "") [ MultiDimensional ];

Property Report As %String(MAXLEN = "") [ MultiDimensional ];

/// export CLASSPATH= Define path to antlr4 jar - not required if defined for all users
Parameter JAVACLASSPATH;

/// either java or full path to java executable
Parameter JAVACMD = "java";

/// ; on unix, & on windows
Parameter CMDCONCATENATION = ";";

Parameter CMDQUOTE = """";

Parameter SCRIPTTOXMLCD;

Parameter SCRIPTTOXML = "MonkToXML";

Property SelectedTranslation As %String(MAXLEN = "") [ MultiDimensional ];

Property InputParameters As %String(MAXLEN = "") [ MultiDimensional ];

/// Assuming the Customer class is defined correctly use parameters to compile scripts
ClassMethod CompileJava() As %Status
{
	Set tScriptsDir = ..#SCRIPTTOXMLCD
	If tScriptsDir="" {
		Write !,"Scripts dir is empty, nothing to compile."
		Quit
	}
	Set tCommand = ..#JAVACLASSPATH
	If tCommand]"" {
		If $$$isWINDOWS {
			Set tCommand = "SET CLASSPATH=.;"_..#JAVACLASSPATH
			Set tJavaCMD = ..#JAVACMD
			If $E($zcvt(tJavaCMD,"l"),*-3,*)=".exe" {
				Set tJavaCMD=$E(tJavaCMD,1,*-4)
			}
		} Else {
			Set tCommand = "export CLASSPATH="_..#CMDQUOTE_".:"_tCommand_..#CMDQUOTE
			Set tJavaCMD = ..#JAVACMD
		}
		Set tCommand = tCommand_..#CMDCONCATENATION
	}
	Set tCommand = tCommand _"cd "_ ..#CMDQUOTE_tScriptsDir _..#CMDQUOTE_ ..#CMDCONCATENATION _ ..#CMDQUOTE_tJavaCMD_"c" _..#CMDQUOTE_ " *.java "
	Write !,tCommand
	Set tStat=$zf(-1,tCommand)
	If tStat {
		Write !,"Command:"_tCommand_" failed"
	}
	Quit $S(tStat:$$$ERROR($$$GeneralError,$$$Text("Java compile failed","Ensemble")),1:$$$OK)
}

Method ReportItem(pString, pBail = 0) As %Status
{
	Set tSC = $$$OK
	Set tFoundReport=0 
	For ReportIdx=1:1:$G(..Report(0)) {
		If ..Report(ReportIdx)=pString Set tFoundReport=1
	}
	If 'tFoundReport {
		Set ..Report($i(..Report(0)))=pString
		Write:..Debug pString,!
	}
	If pBail {
		Set ..Bail=pBail
		//break:..Debug
	}
	Quit tSC
}

ClassMethod Files(pPath, pSuffix = ".tsc,.ssc", pMethod = "", Output pFiles, pArgs...)
{
	Set tRS = ##class(%ResultSet).%New("%File:FileSet")
	Do tRS.%Execute(pPath,"*")
	While tRS.%Next() {
		If tRS.Type="D" {
			//
			Do ..Files(tRS.Name,pSuffix,pMethod,.pFiles,pArgs...)
			Continue
		}
		Set tsuffix = $E(tRS.Name,*-3,*)
		If pSuffix'[tsuffix Continue
		Set pFiles(tRS.Name)=""
		If pMethod]"" {
			Write tRS.Name,!
			Set tSC = $classmethod(..%ClassName(1),pMethod,tRS.Name,pArgs...)
		}
	}
}

/// if the ClassName is not defined in CodeWalk generate one from the file name
ClassMethod GetClassName(pFileName, pClassName) [ CodeMode = expression ]
{
..#CLASSNAMEPREFIX_$S(pClassName="":..DTLClassname(pFileName),1:pClassName)
}

ClassMethod DTLClassname(pFileName) [ CodeMode = expression ]
{
$tr(##class(%File).GetFilename(pFileName),"._-","pud")
}

ClassMethod ScriptToXML(pFrom, pTo, pDelete = 1, ByRef pExists, pScriptToXML = {..#SCRIPTTOXML}) As %Status
{
	Set pExists = 0
	Do:pDelete ##class(%File).Delete(pTo)
	Set pExists = ##class(%File).Exists(pTo)
	If 'pExists {
		Set tCommand = ..#JAVACLASSPATH
		If tCommand]"" {
			If $$$isWINDOWS {
				Set tCommand = "SET CLASSPATH="_..#CMDQUOTE_".;"_tCommand_..#CMDQUOTE
			} Else {
				Set tCommand = "export CLASSPATH="_..#CMDQUOTE_".:"_tCommand_..#CMDQUOTE
			}
			Set tCommand = tCommand_..#CMDCONCATENATION
		}
		Set tCommand = tCommand _"cd "_ ..#CMDQUOTE_..#SCRIPTTOXMLCD _..#CMDQUOTE_ ..#CMDCONCATENATION _ ..#CMDQUOTE_..#JAVACMD _..#CMDQUOTE_ " "_pScriptToXML_ " "_..#CMDQUOTE_pFrom_..#CMDQUOTE_" "_..#CMDQUOTE_pTo_..#CMDQUOTE
		//Write !,tCommand
		Set tStat=$zf(-1,tCommand)
		If tStat {
			Write !,"Command:"_tCommand_" failed"
		}
		Set pExists = ##class(%File).Exists(pTo)
	}
	Quit $$$OK
}

Method ParseInputParameters(pInputParameters) As %Status
{
	Set tSC = $$$OK
	Set ..InputParameters("BUILDDTL")=1
	For tIdx=2:1:$l(pInputParameters,"/") {
		Set tItem = $p(pInputParameters,"/",tIdx)
		Set tParam = $p(tItem,"=")
		Set tValue = $p(tItem,"=",2)
		If tParam = "" && (tValue="") Continue
		If tParam = "" {
			Set tSC  = $$$ADDSC(tSC,$$$ERROR($$$GeneralError,"Parameter is null for "_tValue))
			Continue
		}
		Set ..InputParameters($zstrip($zcvt(tParam,"U"),"<>W"))=$zstrip(tValue,"<>W")
	}
	Quit tSC
}

// ClassMethod CodeWalk(pFileName = "", ByRef pClassName = "", pSourceDocType = "", pTargetDocType = "", pReprocess = 0,pDebug = 0,pAllowSkip=1, pBuildDTL = 1,pRebuildXML=0) As %Status

/// pFileName complete path and filename
/// pClassName - generated className
/// pSourceDocType - version:type ie 2.7.1:MDM_T02
/// pTargetDocType - version:type ie 2.7.1:MDM_T02
/// pDebug - break for issues
ClassMethod CodeWalk(pFileName = "", pInputParameters = "", Output pOutput) As %Status
{
	Set tThis = ..%New()
	Quit tThis.imCodeWalk(pFileName,pInputParameters,.pOutput)
}

Method imCodeWalk(pFileName = "", pInputParameters, Output pOutput) As %Status
{
	try {
		Set tStart = $zh
		Kill $$$FormCode
		Kill $$$InverseScheme
		Set tSC = ..ParseInputParameters(pInputParameters)
		Return:$$$ISERR(tSC) tSC
		Set tClassName = ..GetClassName(pFileName,$$$Param(ClassName))
		If '$$$Param(Reprocess) && ##class(%Dictionary.ClassDefinition).%ExistsId(tClassName) {
			Write !,"Class already exists"
			Return $$$ERROR($$$GeneralError,"Class already exists "_tClassName)
		}
		For tST = "source","target" {
			Set tNode=""
			For  {
				Set tNode=$O(%hint(tST,tNode),1,tData) Quit:tNode=""
				Set ..SelectedTranslation(tST,tNode)=tData
			}
		}
		Set ..Debug=$S($$$Param(Debug):$$$Param(Debug),1:$G(^%zjb("Debug"),$$$Param(Debug)))
		Set ..Filename=pFileName
		Set tCode = ##class(Code).%OpenId(##class(Code).GetIDForName(pFileName)) 
		If $IsObject(tCode) {
			For tIdx=tCode.Items.Count():-1:1 {
				Set tItem = tCode.Items.GetAt(tIdx) 
				If $IsObject(tItem) {
					Do tItem.%Delete(tItem.%Oid())
				}
				Do tCode.Items.RemoveAt(tIdx)
			}
		} Else {
			Set tCode = ##class(Code).%New()
			Set tCode.Name=pFileName
		}
		Set ..Code("Code")=tCode
		Set tCode.ClassName=tClassName
		Set pOutput("ClassName") = tCode.ClassName
		Do ..ReportItem("Classname:"_tCode.ClassName,0)
		Set tCode.SourceDocType=$$$Param(SourceDocType)
		Set tPart1 = $p($$$Param(SourceDocType),":")
		If tPart1 = "" {
			Set tVersion = ..#DEFAULTVERSION
		} Else {
		 	Set tVersion = tPart1  //$G(^EnsHL7.Schema(tPart1,"base"),tPart1)
		}
		Set ..Code("SourceVersion")=tVersion
		Set ..Code("SourceDocType")=$p($$$Param(SourceDocType),":",2)
		Set tCode.TargetDocType=$$$Param(TargetDocType)
		Set tPart1 = $p($$$Param(TargetDocType),":")
		If tPart1 = "" {
			Set tVersion = ..#DEFAULTVERSION
		} Else {
		 	Set tVersion = tPart1 //$G(^EnsHL7.Schema(tPart1,"base"),tPart1)
		}
		Set ..Code("TargetVersion")=tVersion
		Set ..Code("TargetDocType")=$p($$$Param(TargetDocType),":",2)
		//

		Set tFileName = $zcvt(pFileName,"U")
		Set tfn=##class(%File).GetFilename(tFileName)
		If '$$$Param(Reprocess) && $D($$$SkipFile("Started",tFileName)) {
			Return $$$OK
		}
		If '$$$Param(Reprocess)&&$D($$$DoneFile("F",tFileName)) Return $$$OK
		Kill $$$SkipFile("F",tFileName)
		Kill $$$SkipFile("P",tfn)
		Set $$$SkipFile("Started",tFileName)=""
		Set tXMLFileName=pFileName
		If $$$Param(Timer) {
			Write !,"Startup:",$zh-tStart,!
		}
		Set tStart=$zh
		If $p(pFileName,".",$L(pFileName,"."))'="xml" {
			Set tFN=pFileName,tXMLFileName=tFN_".xml"
			Do ..ScriptToXML(tFN,tXMLFileName,$$$Param(RebuildXML),.tExists)
		}
		If $$$Param(Timer) {
			Write !,"ScriptToXML:",$zh-tStart,!
		}
		Set tStart=$zh
		Set tCodeCOS=##class(CodeCOS).%New()
		Do tCode.Items.Insert(tCodeCOS)
		Do tCodeCOS.Lines.Insert($c(9)_"// original file "_pFileName)
		Set tCodeCOS.Annotation="Comment"

		Set tFile=##class(%Stream.FileBinary).%New()
		Do tFile.LinkToFile(tXMLFileName)  
		If 'tFile.Size {
			Do ..ReportItem("Empty file:"_tXMLFileName)
			Set ..Bail=1
			Quit
		}
		Set tSC = ##class(%XML.Document).GetDocumentFromStream(tFile,.tDocument)
		If 'tSC Do ..ReportItem("failed to parse document:"_pFileName_" "_$system.Status.GetErrorText(tSC),0) break:..Debug  Quit
		If $$$Param(Timer) {
			Write !,"Ready to parse:",$zh-tStart,!
		}
		Set tStart=$zh
	
		#dim tNode as %XML.Node=tDocument.GetDocumentElement()
		If tNode.HasChildNodes(1) {
			Set tSaveNodeId = tNode.NodeId
			Set tName = tNode.LocalName
			Do ..CodeWalkChildren(tNode,$$$Param(Debug),tXMLFileName)
		}
		} catch ex {
			Set tSC = ex.AsStatus() break
		}
		If $$$Param(Timer) {
			Write !,"CodeWalkChildren:",$zh-tStart,!
		}
		Set tStart=$zh

			
		Do ..CodeOutput()
		If $$$Param(Timer) {
			Write !,"CodeOutput:",$zh-tStart,!
		}
		Set tStart=$zh
	Kill $$$SkipFile("Started",tFileName)
	break:..Debug=2
	If '..Bail {
		// Substitute [|||ref.ref.ref||] for known reference in code items
		Set tBuildCode = ..Code("Code")
		Set tSC = ..DereferenceVariables()
		If $$$Param(Timer) {
			Write !,"Dereference Varialbes:",$zh-tStart,!
		}
		Set tStart=$zh
		//Set tBuildCode.SourceDocType=..Code("SourceVersion")_":"_..Code("SourceDocType")
		Set tSourceDocType = $G(..Code("SourceVerDocType"))
		If $p(tSourceDocType,":")="" || ($p(tSourceDocType,":",2)="") {
			Set tSourceDocType=..Code("SourceVersion")_":"_..Code("SourceDocType")
		}
		Set tBuildCode.SourceDocType=tSourceDocType
		Set tTargetDocType=$G(..Code("TargetVerDocType"))
		If $p(tTargetDocType,":")="" || ($p(tTargetDocType,":",2)="") {
			Set tTargetDocType=..Code("TargetVersion")_":"_..Code("TargetDocType")
		}
		Do ..ReportItem("SourceDocType:"_tSourceDocType_" TargetDocType:"_tTargetDocType,0)
		Set tBuildCode.TargetDocType=tTargetDocType
		//Set tBuildCode.SourceDocType=$G(..Code("SourceVerDocType"),..Code("SourceVersion")_":"_..Code("SourceDocType"))
		//Set tBuildCode.TargetDocType=..Code("TargetVersion")_":"_..Code("TargetDocType")
		//Set tBuildCode.TargetDocType=$G(..Code("TargetVerDocType"),..Code("TargetVersion")_":"_..Code("TargetDocType"))
		If $$$Param(Timer) {
			Write !,"Before Update:",$zh-tStart,!
		}
		Set tStart=$zh
		Set tSC = ..UpdateCode() break:'tSC
		Set tSC = tBuildCode.%Save() break:'tSC
		If $$$Param(Timer) {
			Write !,"UpdateCode:",$zh-tStart,!
		}
		Set tStart=$zh
		Set tSC = ..BuildClass(pFileName,$$$Param(BuildDTL))
		If $$$Param(Timer) {
			Write !,"BuildClass:",$zh-tStart,!
		}
		Set tStart=$zh
		If $$$ISERR(tSC) {
			Do ..ReportItem("Failed to compile DTL",0) 
		} Else {
			Set $$$DoneFile("P",tfn)=$i($$$DoneFile("P",tfn))
			Set $$$DoneFile("F",tFileName)=pFileName
			Kill $$$DoneFile("F",tFileName,"Report")
			Merge $$$DoneFile("F",tFileName,"Report")=..Report
			Kill $$$SkipFile("F",tFileName)
			Kill $$$SkipFile("P",tfn)
		}
	}

	If $G(..Report(0)) {
	 	Write !
		For tIdx=1:1:$G(..Report(0)) {
			Write ..Report(tIdx),!
		}
		Write !
	}
	If ..Bail {
		Write "Skipped:",..Filename,!
		Set $$$SkipFile("P",tfn)=$i($$$SkipFile("P",tfn))
		Set $$$SkipFile("F",tFileName)=..Filename
		Kill $$$SkipFile("F",tFileName,"Report")
		Merge $$$SkipFile("F",tFileName,"Report")=..Report
		If ..Bail=..#PERMANENTBAIL Set $$$SkipFile("F",tFileName,"PERMANENT")=""
		Quit $$$OK
	}
	Kill ..Report
	break:..Debug=2
	Quit $S(..Bail:$$$ERROR($$$GeneralError,"Processing not completed"),1:$$$OK)
}

Method CodeOutput()
{
	Quit $$$OK
}

Method BuildClass(pFileName, pCompile = 1)
{
	Quit $classMethod(..#CODEBUILDER,"Build",pFileName,,pCompile)
}

Method DereferenceVariables() As %Status
{
	try {
		Set tSC = $$$OK
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit $$$OK
}

/// Override 
/// ability to update the code (CodeBuilder.Code) before saving, inserting comments at the beginning etc.
Method UpdateCode() As %Status
{
	try {
		Set tSC = $$$OK
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method CodeWalkChildren(pNode As %XML.Node, pDebug = 0, pFileName)
{
	If 'pNode.MoveToFirstChild(1) Quit
	Set tSiblingCount=1,tLevel=0
	Set tName = pNode.LocalName

	For  {
		Do ..CodeWalkNode(pNode,,,,pDebug,pFileName)
		Quit:..Bail
		If 'pNode.MoveToNextSibling(1) Quit
	}
	Quit 1
}

Method CodeWalkNode(pNode As %XML.Node, pLevel = 0, pSet = 1, pCommandLine = "", pDebug = 1, pFileName)
{
	/// implement custom CodeWalkNode
}

Method ProcessReplaceCollection(pCollection)
{
	For tIdx=1:1:pCollection.Count() {
		Set tItem = pCollection.GetAt(tIdx)
		Set tMethod = "ReplaceVars"_tItem.%ClassName(0)
		Do $method($this,tMethod,tItem)
	}
}

Method ReplaceVarsCodeCOS(pItem)
{
	Quit
}

Method ReplaceVarsCodeCaseDefault(pItem)
{
	Do ..ProcessReplaceCollection(pItem.Statements)
	If 'pItem.Disabled && '..Annotate {
		Set pItem.Annotation=""
	}
}

Method ReplaceVarsCodeSwitch(pItem)
{
	For tIdx=1:1:pItem.Cases.Count() {
		Set tItem = pItem.Cases.GetAt(tIdx)
		If tItem.%ClassName(0)["Default" {
			Do ..ReplaceVarsCodeCaseDefault(tItem)
		} Else {
			Do ..ReplaceVarsCodeCase(tItem)
		}
	}
}

Method ReplaceVarsCodeCase(pItem)
{
	Set pItem.Condition = ..Replace(pItem.Condition,pItem)
	$$$DisableCode(pItem,Condition)
	Do ..ProcessReplaceCollection(pItem.Statements)
}

Method ReplaceVarsCodeSet(pItem)
{
	If pItem.Annotation="" {
		Set pItem.Annotation = pItem.Variable_  "=" _pItem.Value
	}
	Set pItem.Variable = ..Replace(pItem.Variable,pItem)
	Set pItem.Value = ..Replace(pItem.Value,pItem)
	$$$DisableCode(pItem,Variable)
	$$$DisableCode(pItem,Value)
	If pItem.Variable[".GetValueAt(0)" && (pItem.Value[".GetValueAt(0)") Set pItem.Disabled=1
	If 'pItem.Disabled && '..Annotate {
		Set pItem.Annotation=""
	}
}

Method ReplaceVarsCodeIf(pItem)
{
	Set pItem.Condition = ..Replace(pItem.Condition,pItem)
	$$$DisableCode(pItem,Condition)
	break:('pItem.Disabled&&(pItem.Condition["[|||"))
	Do ..ProcessReplaceCollection(pItem.True)
	Do ..ProcessReplaceCollection(pItem.False)
	If 'pItem.Disabled && '..Annotate {
		Set pItem.Annotation=""
	}
}

Method ReplaceVarsCodeForEach(pItem)
{
	Set pItem.Property = ..Replace(pItem.Property,pItem)
	If $E(pItem.Property,*-4,*)="()()}" {
		Set pItem.Property = $E(pItem.Property,1,*-3)_"}"  /// datagate specific
	} ElseIf $E(pItem.Property,*-2,*)'="()}" {
		Set pItem.Property = $E(pItem.Property,1,*-1)_"()}"  /// cloverleaf specific
	}
	$$$DisableCode(pItem,Property)
	Do ..ProcessReplaceCollection(pItem.Lines)
	If 'pItem.Disabled && '..Annotate {
		Set pItem.Annotation=""
	}
}

Method Replace(pValue, pItem) As %String
{
	Set tPosStart = 0,tAry=0
	Set tValue = pValue
	For  {
		Set tPosStart = $F(tValue,"{[|||",tPosStart)
		Quit:'tPosStart
		Set tPosEnd = $F(tValue,"|||]",tPosStart)  /// could be |||]()} break it out into two steps
		Set tPosEnd = $F(tValue,"}",tPosEnd)
		Set tAry($i(tAry))=$lb(tPosStart-12,tPosEnd-1)  /// update starting to include source. or target.
	}
	For tIdx = tAry:-1:1 {
		Set tStart = $li(tAry(tIdx))
		Set tEnd = $li(tAry(tIdx),2)
		Set tVariable = $E(tValue,tStart,tEnd)
		Set tStrip = 0
		If $e(tVariable,*-2,*)="()}" {
			Set tVariable=$E(tVariable,1,*-3)_"}"
			Set tStrip=1
		}
		
		If tVariable]"" && $D(..VariableReplacement(tVariable),tNewVar) {
			If tNewVar]"" {
				Set tLeft=$p(tNewVar,":"),tRight=$p(tNewVar,":",2),tNote=""
				/// PID:PatientIdentifierList(1).IDNumber
				If $D(..NoteVariable(tVariable),tNote) { Set tNotedVar = tVariable } 
				ElseIf $D(..NoteVariable(tNewVar),tNote) { Set tNotedVar = tNewVar } 
				ElseIf tLeft]"" && $D(..NoteVariable(tLeft),tNote) { Set tNotedVar = tLeft} 
				ElseIf tRight]"" && $D(..NoteVariable(tRight),tNote) { Set tNotedVar = tRight}
				If tNote]"" {
					/// only note first occurrence
					If '$D(..NoteVariable(tNotedVar,"ack"))||$D(..NoteVariable(tNotedVar,"noack")) {
						Do ..AddAnnotation(pItem, tNote) Set pItem.Disabled=1
						Do ..FixNote($C(9)_"//** "_tNote)
						Set ..NoteVariable(tNotedVar,"ack")=1
					}
				}
				Set tNewVar=$E(tVariable,1,6)_".{"_tNewVar_$S(tStrip:"()",1:"")_"}"
				Set $E(tValue,tStart,tEnd)=tNewVar
			} Else {
				Set tTempVar = $p($p(tVariable,"[|||",2),"|||]")
				If $D(..NoteVariable(tTempVar),tNote) && (tNote]"") {
					If '$D(..NoteVariable(tTempVar,"ack"))||$D(..NoteVariable(tTempVar,"noack")) {
						Do ..AddAnnotation(pItem, tNote) Set pItem.Disabled=1
						Do ..FixNote($C(9)_"//** "_tNote)
						Set ..NoteVariable(tTempVar,"ack")=1
					}
				}
			}
		} else { break:..Debug } // tVariable = "" or no variable replacement $D(..Code("Variables(tVariable))
	}
	Quit tValue
}

Method AddAnnotation(pItem, pText)
{
	If pItem.Annotation[pText Quit
	Set pItem.Annotation = $S(pItem.Disabled:pItem.Annotation_$c(13,10),1:"")_pText,pItem.Disabled=1
}

/// for problems found during conversion notes can be inserted at the top of the code pText = $C(9)_" *** some note "<br>
/// when pItems is included the note will also be inserted at the current code position
Method FixNote(pText, pItems = "", pTop = 1)
{
	Set tCodeComment = ..FixNote
	If '$IsObject(tCodeComment) {
		Set tCodeComment = ##class(CodeCOS).%New()
		Set tCodeComment.Annotation="Comment"
		//Do ..Code("Code").Items.InsertAt(tCodeComment,1)
		Set ..FixNote= tCodeComment
	}
	Do:pTop tCodeComment.Lines.Insert(pText)
	If $IsObject(pItems) {
		Set tItemsComment = ##class(CodeCOS).%New()
		Set tCodeComment.Annotation="Comment"
		Do tItemsComment.Lines.Insert(pText)
		Do pItems.Insert(tCodeComment)
	}
}

/// pRef - variable reference
/// pText - text about issue
/// pTop - note at the top of the new class
/// pNoAck - note every time when pNoAck=1 (don't accept an acknowledgment), pNoAck = 0 indicates once it's been reported it won't be reported again
Method NoteVariable(pRef, pText, pTop = 1, pNoAck = 0)
{
	Set ..NoteVariable(pRef)=pText
	Set:pTop ..NoteVariable(pRef,"Top")=1
	Set:pNoAck ..NoteVariable(pRef,"noack")=pNoAck
}

ClassMethod NodeAsText(pNode, ByRef pText = "", pTop = 1) As %String
{
	Set:pTop pText=""
	Set tRembmerNodeId = pNode.NodeId
	For  {
		If pNode.NodeType = $$$xmlTEXTNODE || (pNode.NodeType=$$$xmlWHITESPACENODE) {
			Set pText = pText _ pNode.NodeData
		} ElseIf pNode.NodeType=$$$xmlELEMENTNODE {
			Set tNodeId = pNode.NodeId
			If pNode.MoveToFirstChild(0) {
				Do ..NodeAsText(pNode,.pText,0)
			}
			Set pNode.NodeId = tNodeId
		} Else {break}
		Quit:'pNode.MoveToNextSibling(0)
	}
	Set pNode.NodeId = tRembmerNodeId
	Set:pTop pText=$replace(pText,$C(10),$c(13,10))
	If pTop Quit pText
	Quit
}

ClassMethod Count(pFileName = "", ByRef pClassName = "", pSourceDocType = "", pTargetDocType = "", pReprocess = 1, pDebug = 0, pAllowSkip = 1, pBuildDTL = 1, pRebuildXML = 0) As %Status
{
	Set %count=%count+1
	Quit $$$OK
}

}
