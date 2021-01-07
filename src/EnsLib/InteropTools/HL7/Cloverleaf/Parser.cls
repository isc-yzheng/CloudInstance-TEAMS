/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.CodeBuilder

Include EnsLib.InteropTools.HL7.Cloverleaf

Class EnsLib.InteropTools.HL7.Cloverleaf.Parser Extends EnsLib.InteropTools.HL7.Common
{

Property TCLVariables As %String [ MultiDimensional ];

Property TCLMD5 As %String;

Parameter TCLLOGECHO = 1;

Method CodeWalkNode(pNode As %XML.Node, pLevel = 0, pSet = 1, pCommandLine = "", pDebug = 1, pFileName)
{
	//#define Name(%value,%end) if %value]"" { Write "<",$S(%end:"/",1:""),%value,">"}
	//#define Write(%value) Write $zcvt(%value,"O","XML")
	Set tSaveNodeId = pNode.NodeId
	//Write !,pNode.LocalName
	Set tCode = ..Code("Code")
	If pNode.NodeType=$$$xmlELEMENTNODE {
		try {
			Do $method($this,"CodeWalk"_pNode.LocalName,pNode,tCode.Items)
		} catch ex { break}
		/*
		Do ..CodeWalkpblock(pNode,$I(pLevel),,,pDebug,.tForm)  //break:$G(tForm(tForm-1))="result"   //outer
		Merge $$$FormCode($i($$$FormCode))=tForm
		If $g(tForm(1))="define" {
		} ElseIf $g(tForm(1))="" {
			break
		}
		Kill tForm
		*/

	} elseIf pNode.NodeData="&lt;EOF" {
	} elseIf pNode.NodeData=">" {
	} else {
		zdn pNode  Break
	}
	Set pNode.NodeId=tSaveNodeId
	Quit 1
}

Method CodeWalkpblock(pNode As %XML.Node, ByRef pCode)
{
	Set tSaveNodeId = pNode.NodeId
	If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected {",1) Quit
	If pNode.NodeType'=$$$xmlTEXTNODE Do ..ReportItem("Expected {",1) Quit
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected bodyitem",1) Quit
	If pNode.NodeType'=$$$xmlELEMENTNODE Do ..ReportItem("Expected bodyitem",1)  Quit
	If pNode.LocalName="bodyitem" {
		If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected Command",1)  Quit  /// expecting opcopy opif etc
		//write pNode.LocalName
		Do $method($this,"CodeWalk"_pNode.LocalName,pNode,.pCode)
		If pNode.MoveToNextSibling(1) Do ..ReportItem("Only expecting one command per body item",1) Quit
	} else { break}
	Set pNode.NodeId=tSaveNodeId
	Quit 1
}

Method CodeWalkoppathcopy(pNode As %XML.Node, ByRef pCode)
{
	Quit ..CodeWalkopcopy(pNode,.pCode,"{OPPATHCOPY}")
}

/// <opif>{OPIF}<ifinstr>{<ifinstrbody><reminstr>REM<term>1</term></reminstr></ifinstrbody>}</ifinstr><ifinstr>{<ifinstrbody><errinstr>ERR<term>0</term></errinstr></ifinstrbody>}</ifinstr><ifinstr>{<ifinstrbody><condinstr>COND{<preblockbody><preblockitem>0(0).FT1(0).#2(0).[0]eq@null</preblockitem></preblockbody>}</condinstr></ifinstrbody>}</ifinstr><ifinstr>{<ifinstrbody><theninstr>THENBODY<wrappedpblocks>{<pblock>{<bodyitem><opcopy>{OPCOPY}<instr>{<instrbody><errinstr>ERR<term>0</term></errinstr></instrbody>}</instr><instr>{<instrbody><preinstr>PRE<preblock>{<preblockbody><preblockitem>setxlateOutVals[stringrange$xlateInVals1518]</preblockitem></preblockbody>}</preblock></preinstr></instrbody>}</instr><instr>{<instrbody><ininstr>IN<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem>0(0).MSH(0).#10(0).[0]</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody>}</preblock></preblockitem></preblockbody></ininstr></instrbody>}</instr><instr>{<instrbody><outinstr>OUT<preblockbody><preblockitem>@seqnum</preblockitem></preblockbody></outinstr></instrbody>}</instr></opcopy></bodyitem>}</pblock><pblock>{<bodyitem><opcopy>{OPCOPY}<instr>{<instrbody><errinstr>ERR<term>0</term></errinstr></instrbody>}</instr><instr>{<instrbody><ininstr>IN<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem>0(0).FT1(0).#3(0).[0]</preblockitem></preblockbody>}</preblock></preblockitem><preblockitem>@seqnum</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody></ininstr></instrbody>}</instr><instr>{<instrbody><outinstr>OUT<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem>1(0).0(0).FT1(0).#2(0).[0]</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody>}</preblock></preblockitem></preblockbody></outinstr></instrbody>}</instr><instr>{<instrbody><copysepinstr>COPYSEP{}</copysepinstr></instrbody>}</instr></opcopy></bodyitem>}</pblock>}</wrappedpblocks></theninstr></ifinstrbody>}</ifinstr><ifinstr>{<ifinstrbody><elseinstr>ELSEBODY<wrappedpblocks>{<pblock>{<bodyitem><opcopy>{OPCOPY}<instr>{<instrbody><errinstr>ERR<term>0</term></errinstr></instrbody>}</instr><instr>{<instrbody><ininstr>IN<preblockbody><preblockitem>0(0).FT1(0).#2(0)</preblockitem></preblockbody></ininstr></instrbody>}</instr><instr>{<instrbody><outinstr>OUT<preblockbody><preblockitem>1(0).0(0).FT1(0).#2(0)</preblockitem></preblockbody></outinstr></instrbody>}</instr></opcopy></bodyitem>}</pblock>}</wrappedpblocks></elseinstr></ifinstrbody>}</ifinstr></opif>
Method CodeWalkopif(pNode As %XML.Node, ByRef pCode)
{
	try {
		Set tSaveNodeId = pNode.NodeId
		If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected OPIF",1) break:..Debug  Quit
		If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="{OPIF}") Do ..ReportItem("Expected OPIF",1) break:..Debug  Quit
		Set tCode = ##class(CodeIf).%New()
		For  {
			Quit:'pNode.MoveToNextSibling(1)  /// ifinstr
			Set tInstr = pNode.NodeId
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected {",1) break:..Debug  Quit
			If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="{") Do ..ReportItem("Expected {",1) break:..Debug  Quit
			If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected ifinstrbody",1) break:..Debug  Quit  ///ifinstrbody
			If pNode.LocalName '= "ifinstrbody" Do ..ReportItem("Expected instrbody",1) break:..Debug  Quit
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a type",1) break:..Debug  Quit  ///some item
			If pNode.NodeType'=$$$xmlELEMENTNODE Do ..ReportItem("Expected item",1) break:..Debug  Quit
			If pNode.LocalName = "reminstr" {
				Set tREM = ..instrTerm(pNode)
				If tREM = 1 || (tREM = 3) Quit  /// REM 1 disable both if and else, REM 2 disable else, REM 3 disable ELSE then disable IF
			} ElseIf pNode.LocalName = "errinstr" {
				Set tERR = ..instrTerm(pNode)
			} ElseIf pNode.LocalName = "condinstr" {
				//Do ..preblockValues(,.tCond," COND") 
				Do ..GetConditions(pNode,tCode) break:tCode.Condition=""
			} ElseIf pNode.LocalName = "theninstr" {
				If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a THENBODY",1) break:..Debug  Quit 
				If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="THENBODY") Do ..ReportItem("Expected THENBODY",1) break:..Debug  Quit
				If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected wrappedpblocks",1) break:..Debug  Quit 
				If pNode.LocalName '= "wrappedpblocks" Do ..ReportItem("Expected wrappedpblocks",1) break:..Debug  Quit
				If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a {",1) break:..Debug  Quit 
				If pNode.NodeType=$$$xmlTEXTNODE && ($$$WhiteControl(pNode.NodeData)="{}") {
					Continue
				}
				If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="{") Do ..ReportItem("Expected {",1) break:..Debug  Quit
				For  {
					Quit:'pNode.MoveToNextSibling(1) 
					Quit:$$$WhiteControl(pNode.NodeData)="}"
					Do ..CodeWalkpblock(pNode,tCode.True)
				}
			} ElseIf pNode.LocalName = "elseinstr" {
				If $G(tREM)'=2 {   /// REM 2 disables else
					If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a ELSEBODY",1) break:..Debug  Quit 
					If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="ELSEBODY") Do ..ReportItem("Expected ELSeBODY",1) break:..Debug  Quit
					If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected wrappedpblocks",1) break:..Debug  Quit 
					If pNode.LocalName '= "wrappedpblocks" Do ..ReportItem("Expected wrappedpblocks",1) break:..Debug  Quit
					If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a {",1) break:..Debug  Quit 
					If pNode.NodeType=$$$xmlTEXTNODE && ($$$WhiteControl(pNode.NodeData)="{}") {
						Continue
					}
					If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="{") Do ..ReportItem("Expected {",1) break:..Debug  Quit
					For  {
						Quit:'pNode.MoveToNextSibling(1)
						Quit:$$$WhiteControl(pNode.NodeData)="}"
						Do ..CodeWalkpblock(pNode,tCode.False)
					}
				}
			} Else {break}
			/// will accept a } sibling???
			//If pNode.MoveToNextSibling(1) {
			//	If pNode.NodeData '= "}" Do ..ReportItem("Expected }",1)  break:..Debug  Quit  /// shouldn't be more siblings
			//}
			If pNode.MoveToNextSibling(1) break:..Debug  Quit  /// shouldn't be more siblings
			Set pNode.NodeId = tInstr
		}
		If $G(tREM) = 1 || ($g(tREM) = 3) Quit  /// REM 1 disable both if and else, REM 2 disable else, REM 3 disable ELSE then disable IF
		Do pCode.Insert(tCode)
	} catch ex {
		Write ex.AsStatus()  break
	}
	Set pNode.NodeId=tSaveNodeId
	Quit 1
}

Method CodeWalkopbulkcopy(pNode As %XML.Node, ByRef pCode)
{
	Set tCodeCOS = ##class(CodeCOS).%New()
	Do tCodeCOS.Lines.Insert($c(9)_"/// clear target and replace with source (bulkcopy)" )
	Do tCodeCOS.Lines.Insert($c(9)_"Set target = source.%ConstructClone(1)" )
	Set tCodeCOS.Disabled=1
	Do pCode.Insert(tCodeCOS)
	Quit $$$OK
}

/// / 
Method CodeWalkoptable(pNode As %XML.Node, ByRef pCode)
{
	Quit ..CodeWalkopcopy(pNode,.pCode,"{OPTABLE}")
	/*
	        { { OP TABLE } 
            { ERR 0 }
            { IN {{0(0).MSH(0).#6(0).[0]}} }
            { OUT {{0(0).MSH(0).#4(0).[0]}} }
            { TBL HPF_facility.tbl }
            { SIDE {} }
        }
        { { OP TABLE } 
	*/
}

/// <opiterate>{OPITERATE}<instr>{<instrbody><basisinstr>BASIS<preblockbody><preblockitem>1(0).0(0).0(0).PID(0).#3</preblockitem></preblockbody></basisinstr></instrbody>}</instr><instr>{<instrbody><varinstr>VAR<term>%f1</term></varinstr></instrbody>}</instr><instr>{<instrbody><typeinstr>TYPE<term>field</term></typeinstr></instrbody>}</instr><instr>{<instrbody><bodyinstr>BODY<wrappedpblocks>{<pblock>{<bodyitem><opcomment>{OPCOMMENT}<commentpart>{COMMENT<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem>12/14/15readingMRNtodetermineiftestorproducitonmessagethisisfortheCernersystem,setting@prefixtofirstcharacteroftheMRN.IF1=PRODanyothercharacter-TEST</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody>}</commentpart></opcomment></bodyitem>}</pblock><pblock>{<bodyitem><opif>{OPIF}<ifinstr>{<ifinstrbody><errinstr>ERR<term>0</term></errinstr></ifinstrbody>}</ifinstr><ifinstr>{<ifinstrbody><condinstr>COND{<preblockbody><preblockitem>1(0).0(0).0(0).PID(0).#3(%f1).[3]eq=VCMRN</preblockitem></preblockbody>}</condinstr></ifinstrbody>}</ifinstr><ifinstr>{<ifinstrbody><theninstr>THENBODY<wrappedpblocks>{<pblock>{<bodyitem><opcopy>{OPCOPY}<instr>{<instrbody><errinstr>ERR<term>0</term></errinstr></instrbody>}</instr><instr>{<instrbody><preinstr>PRE<preblock>{<preblockbody><preblockitem>#echoMRN=$xlateInValssetxlateOutVals[stringrange$xlateInVals00]#echoout$xlateOutVals</preblockitem></preblockbody>}</preblock></preinstr></instrbody>}</instr><instr>{<instrbody><ininstr>IN<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem>1(0).0(0).0(0).PID(0).#3(%f1).[0]</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody>}</preblock></preblockitem></preblockbody></ininstr></instrbody>}</instr><instr>{<instrbody><outinstr>OUT<preblockbody><preblockitem>@prefix</preblockitem></preblockbody></outinstr></instrbody>}</instr></opcopy></bodyitem>}</pblock>}</wrappedpblocks></theninstr></ifinstrbody>}</ifinstr><ifinstr>{<ifinstrbody><elseinstr>ELSEBODY<wrappedpblocks>{}</wrappedpblocks></elseinstr></ifinstrbody>}</ifinstr></opif></bodyitem>}</pblock>}</wrappedpblocks></bodyinstr></instrbody>}</instr></opiterate>
Method CodeWalkopiterate(pNode As %XML.Node, ByRef pCode)
{
	try {
		Set tSaveNodeId = pNode.NodeId
		If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected OPITERATE",1) break:..Debug  Quit
		If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="{OPITERATE}") Do ..ReportItem("Expected OPITERATE",1) break:..Debug  Quit
		Set tCode = ##class(CodeForEach).%New()
		For  {
			Quit:'pNode.MoveToNextSibling(1)  /// instr
			Set tInstr = pNode.NodeId
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected {",1) break:..Debug  Quit
			If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="{") Do ..ReportItem("Expected {",1) break:..Debug  Quit
			If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected instrbody",1) break:..Debug  Quit  ///ifinstrbody
			If pNode.LocalName '= "instrbody" Do ..ReportItem("Expected instrbody",1) break:..Debug  Quit
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a item",1) break:..Debug  Quit  ///some item
			If pNode.NodeType'=$$$xmlELEMENTNODE Do ..ReportItem("Expected item",1) break:..Debug  Quit
			If pNode.LocalName = "basisinstr" {
				Set tBasis=..preblockValues(pNode,.tBasis," BASIS",1)
				//Set tBasisValues = ..preblockValues(pNode) 
				Set tProperty = ..GetVariable("source",.tBasis,tCode)
				/*
				If tProperty["{[|||" {
					Set tProperty = $p(tProperty,"|||]}")_"()|||]}" 
				}
				*/
				Set tCode.Property = tProperty 
				//break  If tCode.Property["[|||"&&($e(tCode.Property,*)'=")") Set tCode.Property=tCode.Property_"()"  /// 
			} ElseIf pNode.LocalName = "varinstr" {
				Set tCode.Variable = ..instrTerm(pNode)
				$$$FixVariable(tCode.Variable,tCode.Variable,..#VARIABLETRANSLATEFROM,..#VARIALBETRANSLATETO)
			} ElseIf pNode.LocalName = "postinstr" {
				/// /WTemp/ascension/Cloverleaf/WIGLE/EPIC_A18A34_HPF.xlt
				Do ..preblockValues(pNode,.tPostValues," POST") 
				Set tCodePOST = ##class(CodeCOS).%New()
				For tIdx1 = 1:1:tPostValues {
					Set tValue = tPostValues(tIdx1)
					For tIdx2=1:1:$l(tValue,$c(10)) {
						Set tItem = $p(tValue,$c(10),tIdx2) 
						Do:tItem]"" tCodePOST.Lines.Insert($c(9)_"//"_tItem)
					}
				}
				Set tIdxC = $i(^%zjb("Migration","CodePOST"))
				Merge ^%zjb("Migration","CodePOST",tIdxC)=tPostValues
				Set ^%zjb("Migration","CodePOST",tIdxC,"FN")=..Filename
				Set tCodePOST.Disabled=1
				
			} ElseIf pNode.LocalName = "typeinstr" {
				Set tType = ..instrTerm(pNode)
				//// not sure what to do with this
			//} ElseIf pNode.LocalName = "errinstr" {
			//	Set tERR = ..instrTerm(pNode)
			//} ElseIf pNode.LocalName = "condinstr" {
			//	Do ..preblockValues(pNode,.tConditionValues) 
			} ElseIf pNode.LocalName="reminstr" {
				/// don't finish parsing sometimes see IN {} OUT {} with REM 1
				Set tCode.Discard = $S(..instrTerm(pNode):1,1:0)
				Quit
			} ElseIf pNode.LocalName = "bodyinstr" {
				If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a BODY",1) break:..Debug  Quit 
				If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="BODY") Do ..ReportItem("Expected BODY",1) break:..Debug  Quit
				If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected wrappedpblocks",1) break:..Debug  Quit 
				If pNode.LocalName '= "wrappedpblocks" Do ..ReportItem("Expected wrappedpblocks",1) break:..Debug  Quit
				If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected a {",1) break:..Debug  Quit 
				If pNode.NodeType=$$$xmlTEXTNODE && ($$$WhiteControl(pNode.NodeData)="{}") {
					Continue
				}
				If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'="{") Do ..ReportItem("Expected {",1) break:..Debug  Quit
				For  {
					Quit:'pNode.MoveToNextSibling(1) 
					Quit:$$$WhiteControl(pNode.NodeData)="}"
					Do ..CodeWalkpblock(pNode,tCode.Lines)
				}
			} Else {break}
			If pNode.MoveToNextSibling(1) Do ..ReportItem("Expected no more siblings",1)  break:..Debug  Quit  /// shouldn't be more siblings
			//If pNode.MoveToNextSibling(1) break  Quit  /// shouldn't be more siblings
			Set pNode.NodeId = tInstr
		}
		If 'tCode.Discard {
			Do pCode.Insert(tCode)
			break:tCode.Property=""
		}
		If $G(tCodePOST) Do pCode.Insert(tCodePOST)
	} catch ex {
		Write ex.AsStatus()  break
	}
	Set pNode.NodeId=tSaveNodeId
	Quit 1
}

/*
Method (pNode As %XML.Node,ByRef pCode)
{
	//// 
}
*/
Method CodeWalkopsend(pNode As %XML.Node, ByRef pCode)
{
	Do ..ReportItem("Found routing code (Send)",0)
	Set tCodeCOS = ##class(CodeCOS).%New()
	Do tCodeCOS.Lines.Insert($c(9)_"/// send command" )
	Set tCodeCOS.Disabled=1
	Do pCode.Insert(tCodeCOS)
	Quit $$$OK
}

Method CodeWalkopsuppress(pNode As %XML.Node, ByRef pCode)
{
	Do ..ReportItem("Found routing code (Suppress)",0)
	Set tCodeCOS = ##class(CodeCOS).%New()
	Do tCodeCOS.Lines.Insert($c(9)_"/// *** suppress command - this condition should be added as a routing rule" )
	Set tCodeCOS.Disabled=1
	Do pCode.Insert(tCodeCOS)
	Quit $$$OK
	//// /WTemp/ascension/Cloverleaf/KSWIC/Cerner-VCC_Penrad_ORM_O01.xlt
}

Method CodeWalkopcontinue(pNode As %XML.Node, ByRef pCode)
{
	Do ..ReportItem("Found routing code (Continue)",0)
	Set tCodeCOS = ##class(CodeCOS).%New()
	Do tCodeCOS.Lines.Insert($c(9)_"/// continue command" )
	Set tCodeCOS.Disabled=1
	Do pCode.Insert(tCodeCOS)
	Quit $$$OK
	//// /WTemp/ascension/Cloverleaf/KSWIC/Cerner-VCC_Penrad_ORM_O01.xlt
}

Method CodeWalkopcall(pNode As %XML.Node, ByRef pCode)
{
	Quit ..UnknownNode(pNode,.pCode)

	/*
        { { OP CALL } 
            { ERR 0 }
            { IN {{2(%g1).2(0).RXE.00221.[1].[1]} =ScheduledTime_@frequencyIndex} }
            { OUT {} }
            { TCL {
                xltStoreFrequency
            }}
        }
	
	*/
}

/// Math function multiply
Method CodeWalkopmul(pNode As %XML.Node, ByRef pCode)
{
	Quit ..Math(pNode,pCode,"{OPMUL}")

	/*
               { { OP MUL } 
                    { ERR 0 }
                    { IN {{1(0).0(0).ZMQ(0).#3(0).[0].[0]} {1(0).0(0).FT1(0).#10(0).[0].[0]}} }
                    { OUT @tempcalc }
                    { FUNCTION MUL }
                }
	*/
	Quit $$$OK

	//// /WTemp/ascension/Cloverleaf/miroc_site_cerner/cerner_dft_to_mck_iterate_doc.xlt
}

/// Math function multiply
Method CodeWalkopdiv(pNode As %XML.Node, ByRef pCode)
{
	Quit ..Math(pNode,pCode,"{OPDIV}")
}

Method Math(pNode As %XML.Node, ByRef pCode, pText = "")
{
	try {
		Set tSaveNodeId = pNode.NodeId
		Set tOperator = $CASE(pText,"{OPMUL}":"*","{OPADD}":"+","{OPSUB}":"-","{OPDIV}":"/")
		If 'pNode.MoveToFirstChild(1) Set ..Bail=1 break:..Debug  Quit
		If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'=pText) Do ..ReportItem("Expected "_pText_" found "_$$$WhiteControl(pNode.NodeData),1) break:..Debug  Quit
		For  {
			Quit:'pNode.MoveToNextSibling(1)
			If pNode.LocalName'="instr" { Do ..ReportItem("Expected instr",1) break:..Debug  Quit }
			Set tInstr = pNode.NodeId
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected instrbody",1) break:..Debug  Quit   // {
			If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected instrbody",1) break:..Debug  Quit  ///instrbody
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected {",1) break:..Debug  Quit   // {
			If pNode.LocalName = "errinstr" {
				//break  /// in errinstr
				Set tERR = ..instrTerm(pNode)
			} ElseIf pNode.LocalName="ininstr" {
				//Do ..preblockValues(pNode,.tInValues," IN")
				Do ..Simplify(pNode,.tInValues," IN","source")
			} ElseIf pNode.LocalName="outinstr" {
				//Do ..preblockValues(pNode,.tOutValues," OUT")
				Do ..Simplify(pNode,.tOutValues," OUT","target")
			} ElseIf pNode.LocalName="functioninstr" {
				If pNode.MoveToFirstChild(1) && ($zstrip(pNode.NodeData,"<>W") = ("FUNCTION "_$CASE(tOperator,"+":"ADD","-":"SUB","*":"MUL","/":"DIV",1:""))) {
				} Else {
					Do ..ReportItem("unhandled function instr",0)
					break
				}
				//break
				//
			} ElseIf pNode.LocalName="reminstr" {
				Set tREM = ..instrTerm(pNode)
				If tREM = 1 Quit  /// REM 1 disabled - keeping this code could potentially cause parsing issues later as there is no guarantee the code makes sense
			} ElseIf pNode.LocalName = "preinstr" {
				Set tPRE = ..NodeAsText(pNode)
			} ElseIf pNode.LocalName="postinstr" {
				Set tPOST = ..NodeAsText(pNode)
			} Else {break:..Debug  quit}   /// unexpected pNode.LocalName
			If pNode.MoveToNextSibling(1) Do ..ReportItem("Didn't expect more siblings",1) break:..Debug  Quit  /// shouldn't be more siblings
			Set pNode.NodeId = tInstr
		}
	} catch ex {
		Set tSC = ex.AsStatus()
		Set ..Bail=1 break:..Debug
	}
	Set pNode.NodeId=tSaveNodeId
	quit:..Bail $$$OK
	If '$G(tREM) {
		Do ..StoreMath(pNode,pCode,.tPRE,.tInValues,.tOutValues,tOperator,.tPostValues)
	}
	/*
                { { OP ADD } 
                    { ERR 0 }
                    { IN {{$%s10} =1} }
                    { OUT {{$%s10}} }
                    { FUNCTION ADD }
                }
	*/
	Quit $$$OK
}

Method StoreMath(pNode As %XML.Node, ByRef pCode, pPRE = "", ByRef pInValues, ByRef pOutValues, pOperator, pPOST = "")
{
	Set tCode = ##class(CodeSet).%New()
	Do pCode.Insert(tCode)
	Set tCode.Annotation = ..NodeAsText(pNode)
	If $G(pInValues)=2 && $G(pOutValues)=1 {
		Set tCode.Variable = pOutValues(1)
		Set tCode.Value = pInValues(1) _ pOperator _pInValues(2) 
	} Else {
		Set tCode.Disabled=1
		Do ..ReportItem("check math "_tCode.Annotation)  break
	}
	If pPRE]""|| (pPOST]"") {
		Set tPRE = ..GetPREPOST(pPRE,"PRE")
		Do ..ReportItem("Math "_pOperator_" has pre/post instr")
		Set tCode.Disabled=1
		Set ^%zjb("MigrationMath",..Filename,$i(^%zjb("MigrationMath",..Filename)))=tCode.Annotation
	}
}

/// Math function add
Method CodeWalkopadd(pNode As %XML.Node, ByRef pCode)
{
	Quit ..Math(pNode,pCode,"{OPADD}")
	//// /WTemp/ascension/Cloverleaf/KSWIC/Cerner-Cerner_Axx_alias.xlt
}

/// Math function subtract
Method CodeWalkopsub(pNode As %XML.Node, ByRef pCode)
{
	Quit ..Math(pNode,pCode,"{OPSUB}")
	//// /WTemp/ascension/Cloverleaf/KSWIC/Cerner-VCH_Cbord_ORM.xlt
}

Method UnknownNode(pNode As %XML.Node, ByRef pCode)
{
	Set tText = ..NodeAsText(pNode)
	Quit:tText["{ REM 1 }" $$$OK
	Set tCode = ##class(CodeCOS).%New()
	Do pCode.Insert(tCode)
	Do tCode.Lines.Insert(tText)
	Set tCode.Disabled=1
	Quit $$$OK
}

Method CodeWalkopdatecopyopt(pNode As %XML.Node, ByRef pCode)
{
	Quit ..UnknownNode(pNode,.pCode)
	/*
{ { OP DATECOPYOPT } 
    { ADDPREC 0 }  Add Precision box: 1=checked 0=not checked
    { FABRICATE 1 } Missing Centuries 0=Use date rule, 1 – use system date
    { USECURTM 1 } Time Options toggle for use current time 1=use system time 0=use custom time
    { RANGE {49 20 19} } Missing Centuries fields {years 00 through, use century, years greater than use}
    { TMDEFS {01 01 00 00 00 0000 +0000} } Time Options (Month Day Hour Minute Second Fraction Timezone}
    { DELIMIT {/ :} } Date Delimiter Time Delimiter
}
 	*/
	/////WTemp/ascension/Cloverleaf/KSWIC/Cerner-Accretive_Axx.xlt
}

Method CodeWalkopcopy(pNode As %XML.Node, ByRef pCode, pNodeData = "{OPCOPY}")
{
	try {
		Set tSaveNodeId = pNode.NodeId
		If 'pNode.MoveToFirstChild(1) break:..Debug  Quit
		If pNode.NodeType'=$$$xmlTEXTNODE || ($$$WhiteControl(pNode.NodeData)'=pNodeData) Do ..ReportItem("Expected "_pNodeData,1) Quit
		For  {
			Quit:'pNode.MoveToNextSibling(1)
			If pNode.LocalName'="instr" { Do ..ReportItem("Expected instr",1) Quit }
			Set tInstr = pNode.NodeId
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected instrbody",1) Quit   // {
			If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected instrbody",1) Quit  ///instrbody
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected {",1) Quit   // {
			If pNode.LocalName = "preinstr" {
				Set tPRE = ..NodeAsText(pNode)
				Set tVariables("PRE")=tPRE
			} ElseIf pNode.LocalName = "errinstr" {
				//break  /// in errinstr
				Set tERR = ..instrTerm(pNode)
				Set:tERR ^%zjb("Unexpected",..Filename,"ERR")=tERR
				Set tVariables("ERR")=tERR
			} ElseIf pNode.LocalName="dfltinstr" {
				//break:..Debug  /// todo... what to do with this
				/// todo... what to do with this
				Set tDFLT = ..instrTerm(pNode)
				Set:tDFLT]"" ^%zjb("Unexpected",..Filename,"DFLT")=tDFLT
				Set tVariables("DFLT")=tDFLT
			} ElseIf pNode.LocalName="ininstr" {
				Do ..preblockValues(pNode,.tInValues," IN")
				Merge tVariables("IN")=tInValues
			} ElseIf pNode.LocalName="outinstr" {
				Do ..SimplifyOut(pNode,.tOutValues," OUT")
				Merge tVariables("OUT")=tOutValues
			} ElseIf pNode.LocalName="copysepinstr" {
				Set tSepValues = $E($zstrip(..preblockValues(pNode,," COPYSEP",1),"<>W"),2,*-1) break:..Debug&&(tSepValues]"")
				Set tVariables("SEP")=tSepValues
			} ElseIf pNode.LocalName="postinstr" {
				///  /WTemp/ascension/Cloverleaf/RML/labemr2/norm_ORM_O01_to_O02_to_rml_out_aq1.xlt
				Set tPOST = ..NodeAsText(pNode)
				Set tVariables("POST")=tPOST
			} ElseIf pNode.LocalName="reminstr" {
				Set tREM = ..instrTerm(pNode)
				Set tVariables("REM")=tREM
				If tREM = 1 Quit  /// REM 1 disabled - keeping this code could potentially cause parsing issues later as there is no guarantee the code makes sense
			} ElseIf pNode.LocalName="tblinstr" {
				Set tTable=..preblockValues(pNode,""," TBL",1)
				Set tVariables("TABLE")=tTable
			} ElseIf pNode.LocalName="sideinstr" {
				Set tSide=..preblockValues(pNode,""," SIDE",1) //break:$zstrip(tSide,"<>W")'="{}"
				Set tVariables("SIDE")=tSide
			} Else {break:..Debug  quit}   /// unexpected pNode.LocalName
			If pNode.MoveToNextSibling(1) break:..Debug  Quit  /// shouldn't be more siblings
			Set pNode.NodeId = tInstr
			///<instr>{<instrbody><errinstr>ERR<term>0</term></errinstr></instrbody>}</instr>
			///<instr>{<instrbody><ininstr>IN<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem>0(0).MSH(0).#1(0).[0]</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody>}</preblock></preblockitem></preblockbody></ininstr></instrbody>}</instr>
			///<instr>{<instrbody><outinstr>OUT<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem><preblock>{<preblockbody><preblockitem>0(0).MSH(0).#1(0).[0]</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody>}</preblock></preblockitem></preblockbody></outinstr></instrbody>}</instr>
			//break
		}
	} catch ex {
		Set tSC = ex.AsStatus()
		Set ..Bail=1 break:..Debug
	}
	Quit:..Bail 1
	/// How many tOutValues are there, if multiple then we need to create multiple statements
	Set pNode.NodeId=tSaveNodeId
	If '$G(tREM) {
		Do ..OPCopySet(pNode,pCode,.tVariables)
		/*
		If $IsObject($G(tCodePOST)) {
			Set tCode.Annotation = tCode.Annotation _" POST code set"
			Set tCode.Disabled=1
		}
		If $IsObject($G(tCodePOST)) { Do pCode.Insert(tCodePOST)}
		break:tCode.Variable=""
		*/
	}
	
	Quit 1
}

ClassMethod GetPREPOST(pText, pType)
{
	Set tFunction = $p(pText,"{",2,999)
	Set tFunction = $p(tFunction,"}",1,$l(tFunction,"}")-1)
	Set tString=""
	Set tDelim = $C(10)
	For tIdx = 1:1:$l(tFunction,tDelim) {
		Set tItem = $zstrip($p(tFunction,tDelim,tIdx),"<>W",$c(13))
		Set:tItem]"" tString=tString_$lb(tItem)
	}
	Quit tString
}

Method OPCopySet(pNode As %XML.Node, ByRef pDTLCode, ByRef pVariables)
{
	Set tProcessed=0
	Set tCode = ##class(CodeSet).%New()
	Do ..SimplifyIN(.pVariables,pDTLCode,pNode)
	Set tAnnotation = ..NodeAsText(pNode)
	If $g(pVariables("PRE"))]"" {
		Set tPreFunction = ..GetPREPOST(pVariables("PRE"),"PRE")
		Set pVariables("PRELines")=tPreFunction
		
		//Set tPostFunction = ..GetPREPOST($G(pVariables("POST")),"POST")

		Set tProcessed=0

		Try {
			If $ll(tPreFunction)=1 {
				/// functions seen as "StripLeadingZeros" or "xltZFLeft 9" where the 9 is a parameter 
				Do $method($this,"PreFunc"_$p($li(tPreFunction)," "),pNode,pDTLCode,tPreFunction,.tCode,.pVariables,.tProcessed)
			}
		} Catch {
		}
		/// some functions that are ignored kill pVariables("PRE")
		If $D(pVariables("PRE")) && 'tProcessed {
			Do $method($this,"CommonPreFunctions",pNode,pDTLCode,tPreFunction,.pCode,.pVariables,.tProcessed)
		}
		If 'tProcessed {
			Set ^%zjb("Migration","CodePRE",..Filename,$i(^%zjb("Migration","CodePRE",..Filename)))=tPreFunction
		}
	}

	If 'tProcessed {
		If ('$D(pVariables("OUT")) || '$D(pVariables("IN"))) {  // until we start parsing preblock items we might have no IN values
			Set tCode = ##class(CodeSet).%New()
			Set tCode.Disabled=1
			Set tCode.Variable="ERRORuEMPTY"
			Set tCode.Value="ERRORuEMPTY"
			Set tCode.Annotation = ..NodeAsText(pNode)
			Do pDTLCode.Insert(tCode) //break:..Debug
			//break  /// empty in or out
			Quit
		}
		Merge tInVars = pVariables("IN")
		Set tSep=$G(pVariables("Sep"))
		If tSep]"" Break:..Debug
		If tSep]"" && (pVariables("OUT")>1) break:..Debug  /// what to do with separator
		/// Handle multiple input values going into 1 output
		If pVariables("OUT")=1 && (tInVars>1) {
			/// need to concatenate
			Set tValue = ""
			For tIdx=1:1:tInVars {
				Set tValue = tValue _tSep_"_"_ tInVars(tIdx) 
			}
			Kill tInVars
			Set tInVars($i(tInVars))=$E(tValue,$l(tSep)+2,*)  /// skip the beginning separator and _
		}
		If tInVars'=$g(pVariables("OUT")) {
			Set tCodeCOS = ##class(CodeCOS).%New()
			Set tCodeCOS.Annotation = ..NodeAsText(pNode)
			Do pDTLCode.Insert(tCodeCOS)
			Set tCodeCOS.Disabled=1
			Do tCodeCOS.Lines.Insert($C(9)_"/// number of input values ("_tInVars_") does not match output values ("_pVariables("OUT")_")")
			Set tValue = ""
			For tIdx = 1:1:tInVars { Set tValue = tValue _"{"_tInVars(tIdx)_"} "}
			Do tCodeCOS.Lines.Insert($C(9)_"/// input "_tValue)
			Set tValue = ""
			For tIdx = 1:1:pVariables("OUT") { Set tValue = tValue _"{"_pVariables("OUT",tIdx)_"} "}
			Do tCodeCOS.Lines.Insert($C(9)_"/// output "_tValue)
			Quit
		}

		
		For tIdx = 1:1:$g(pVariables("OUT")) {
			Set tCode = ##class(CodeSet).%New()
			If 'tProcessed && ($g(pVariables("PRE"))]"") {
				Do ..AddAnnotation(tCode,..NodeAsText(pNode))
			}
			If $G(pVariables("ERR")) {
				Do ..AddAnnotation(tCode," ERR set to "_pVariables("ERR"))
			}
			Do pDTLCode.Insert(tCode)
			If '$D(pVariables("OUT",tIdx)) || ($g(pVariables("OUT",tIdx))=$c(34,34)) {
				Set tCode.Variable = "ERRORuEMPTY"
				Do ..AddAnnotation(tCode,..NodeAsText(pNode))
			} Else {
				Set tCode.Variable = pVariables("OUT",tIdx)
				If tCode.Variable="" {
					Set tCode.Variable = "ERRORuEMPTY"
					Do ..AddAnnotation(tCode,..NodeAsText(pNode))
				}	
			}
			If '$D(tInVars(tIdx)) {
				Set tCode.Value = "<ERROR EMPTY>"
				Do ..AddAnnotation(tCode,..NodeAsText(pNode))
			} Else {
				Set tValue = tInVars(tIdx)
				Set tCode.Value = tValue
			}
			If $isObject($g(tCodePRE)) {
				//Set tCode.Annotation = $S(tCode.Disabled:tCode.Annotation_$c(10),1:"") _" PRE code set"
				Set tCode.Disabled=1
			}
			If $G(pVariables("TABLE"))]"" {
				Do ..AddTableToCopy(.pVariables,tCode)
			}
			If $G(pVariables("DFLT"))]"" {
				Do ..AddAnnotation(tCode," DFLT set but not used:"_pVariables("DFLT"))
			}
		}
	}
	If $G(pVariables("POST"))]"" {
		Try {
			Do $method("PostFunction"_tFunction,pNode,pNode,.pVariables,,.tProcessed)
		} Catch {
			Set ^%zjb("Migration","CodePOST",..Filename,$i(^%zjb("Migration","CodePOST",..Filename)))=..GetPREPOST(pVariables("POST"),"POST")
			Do ..AddAnnotation(tCode,..NodeAsText(pNode))
		}
	}
}

Method AddTableToCopy(pVariables, pCodeSet)
{
	Set tTableName = $$$Param(TableGroupName)_$E($zstrip(pVariables("TABLE"),"<>W"),1,*-4)
	Set tDefault = $G($$$Defaults(tTableName,"dflt"))
	If tDefault=$C(0) {
		Set tDefault = pCodeSet.Value
	} Else {
		Set tDefault=$C(34)_tDefault_$C(34)
	}
	Set pCodeSet.Value = "..Lookup("_$c(34)_tTableName_$C(34)_","_pCodeSet.Value_","_tDefault_")"
}

/// Override
/// pNode - the XML node object working on
/// 	pMethodCode - object representing method with items processed so far
/// pFunction full function expression where some are function parameter the function is used for the method but the full value is passed in for parameters pFunction=$lb("set xlateOutVals [lindex $xlateInVals 0]")
/// pCode - this Code item being inserted
/// 	pVariables - array containing nodes "IN","OUT","PRE","POST","ERR","DFLT"
/// pProcessed - set to 1 when successfully parsed
Method CommonPreFunctions(pNode, pMethodCode, pFunction, ByRef pCode, ByRef pVariables, Output pProcessed, Output pParsedTCL)
{
	Set pProcessed = 0
	Set pParsedTCL = ""
	Set tCommented=1
	For tIdx=1:1:$ll(pFunction) {
		Set tLine = $li(pFunction,tIdx)
		If $E($zstrip(tLine,"<W"))'="#" Set tCommented=0
	}
	If tCommented {
		Kill pVariables("PRE")
	}
	If $d(pVariables("PRE")) {
		Set tSC = ..ParseTCL(pVariables("PRE"),.pParsedTCL)
		//break:pVariables("PRE")["csubstr"
		If $$$ISOK(tSC) {
			/*
			<programimpl><commandlist><commandlike><command><othercommand>xlt_GetSeqNbr</othercommand></command></commandlike></commandlist></programimpl>
			<commandlist><commandlike><command><othercommand>xltZFLeft<number>9</number></othercommand></command></commandlike></commandlist>
			<commandlist><commandlike><command><echocommand>echo<expr><term><string>"here"</string></term></expr></echocommand></command></commandlike></commandlist>
			
			*/
			Set tNodeId = pParsedTCL.NodeId
			Quit:'pParsedTCL.MoveToFirstChild(1)
			If pParsedTCL.NodeData'="program" {break:..Debug  Quit}  /// item will end up as annotation
			Quit:'pParsedTCL.MoveToFirstChild(1)
			If pParsedTCL.NodeData'="programimpl" {break:..Debug  Quit}  /// item will end up as annotation
			Kill ..TCLVariables
			Quit:'pParsedTCL.MoveToFirstChild(1)
			If pParsedTCL.NodeData'="commandlist" {
				break:..Debug  Quit  /// item will end up as annotation
			}
			Quit:'pParsedTCL.MoveToFirstChild(1)
			For {
				If pParsedTCL.NodeData'="commandlike" {break:..Debug  Quit}
				Set tCommandLikeId = pParsedTCL.NodeId
				Set tSC = pParsedTCL.MoveToFirstChild(1) Quit:$$$ISERR(tSC)
				If pParsedTCL.NodeData = "comment" {
					Do ..TCLComment(.pParsedTCL,.pProcessed)
				} ElseIf pParsedTCL.NodeData'="command"  {
					break:..Debug  
					Do ..ReportItem("Unexpected Structure from TCL parse "_pParsedTCL.NodeData,0)
					Set ..TCLVariables("pProcessed")=0
					Quit
				} Else {
					If 'pParsedTCL.MoveToFirstChild(1) break:..Debug  quit
					Set tNodeData = pParsedTCL.NodeData
					If tNodeData]"" {
						try {
							//break:pVariables("PRE")["trim"
							/// expecting this to be program
							Set ..TCLVariables("pNode")=pNode
							Set ..TCLVariables("pMethodCode")=pMethodCode
							Set ..TCLVariables("pFunction")=pFunction
							Merge ..TCLVariables("pVariables")=pVariables
							Set tSC = $Method($this,"TCLcall"_tNodeData,.pParsedTCL)
							If '$D(..TCLVariables("pVariables","PRE")) {
								Kill pVariables("PRE")
							}
							If $$$ISERR(tSC) {
								Set ..TCLVariables("pProcessed")=0
								Quit
							}
							If '$D(..TCLVariables("pProcessed"),pProcessed) Quit
						} catch ex {
							Set tSC = ex.AsStatus() break:..Debug  
							Set ..TCLVariables("pProcessed")=0
						}
						
					} Else {
						break
					}
				}
				Quit:$g(..TCLVariables("pProcessed"))=0
				//Set pParsedTCL.NodeId = tProgramItemId
				Set pParsedTCL.NodeId = tCommandLikeId  
				Quit:'pParsedTCL.MoveToNextSibling(1)
			}
			Set pProcessed=+$G(..TCLVariables("pProcessed"))
			//break:'pProcessed&&$D(..TCLVariables("Code"))
			IF pProcessed {
				Set tAllComments = 1
				For tIdx = 1:1: $G(..TCLVariables("Code")) {
					Set tCode = ..TCLVariables("Code",tIdx)
					If tCode.%IsA("EnsLib.InteropTools.CodeBuilder.CodeCOS") && (tCode.Annotation="Comment") {
					} Else { Set tAllComments=0 break:tCode.Annotation="Comment"}
					Do pMethodCode.Insert(tCode)
				}
				If tAllComments {
					/*
					 Sometimes we see 
					 	# something 
					 	echo $xlateInVals
					 we are dropping the echo, and the other is just a comment, so we want the standard processing to happen on the COPY
					 */
					Kill pVariables("PRE")
					Set pProcessed=0
				}
			}
			
			Set pParsedTCL.NodeId=tNodeId
		}
		If 'pProcessed && $D(pVariables("PRE")) {
			Set $$$TCLString(..TCLMD5,"NotProcessed",..Filename)=1
		}
	}
	Quit  /// not implemented
}

Method TCLComment(pParsedTCL, Output pProcessed)
{
	Set pProcessed=0
	If 'pParsedTCL.MoveToFirstChild(1) break:..Debug  quit
	Set tCode = ##class(CodeCOS).%New()
	Set tCode.Annotation = "Comment"
	Do tCode.Lines.Insert($c(9)_"// "_pParsedTCL.NodeData)
	Set ..TCLVariables("Code",$i(..TCLVariables("Code")))=tCode
	Set pProcessed=1
}

Method ParseTCL(pText, pXML) As %Status
{
	Set tSC = $$$OK
	try {
		//Set tText = $p(pText,"PRE",2,*)
		Set tText = $p(pText,"{",2,*)
		Set tText = $p(tText,"}",1,*-1)
		Set tText = $zstrip(tText,"<>WC")
		Set ..TCLMD5 = $system.Encryption.MD5Encode(tText)
		If $D($$$TCLString(..TCLMD5),tLookup) {
			If tLookup'=tText break
		} Else {
			Set $$$TCLString(..TCLMD5)=tText
			
			Set tFile = ##class(%Stream.FileCharacter).%New()
			Do tFile.LinkToFile(##class(%File).TempFilename())
			Do tFile.Write(tText)
			Set tSC = tFile.%Save()
			Quit:$$$ISERR(tSC)
			Set tXMLFilename = tFile.Filename_".xml"
			Set tSC = ..ScriptToXML(tFile.Filename, tXMLFilename, , ,"TclToXML") 
			Quit:$$$ISERR(tSC)
			Set tXMLFile=##class(%Stream.FileCharacter).%New()
			Do tXMLFile.LinkToFile(tXMLFilename)  
			If 'tXMLFile.Size {
				Write !,..Filename,!,pText,!,tText
			}
			Do tXMLFile.Rewind()
			Set $$$TCLString(..TCLMD5,"XML")=tXMLFile.Read(30000000)
		}
		Set tXML = $$$TCLString(..TCLMD5,"XML")
		If tXML="" {
			Set tSC = $$$ERROR($$$GeneralError,"Failed to parse")
			Quit
		}
		Set tStream = ##class(%Stream.FileCharacter).%New()
		Do tStream.Write(tXML)
		Set tSC = ##class(%XML.Document).GetDocumentFromStream(tStream,.pXML)
		break:'tSC 
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	If $isObject($g(tXMLFile)) {
		If tXMLFile.Size {
			Do tFile.%DeleteId(tFile.Filename)
		}
		//Do tFile.%DeleteId(tFile.Filename)
		Do tXMLFile.%DeleteId(tXMLFile.Filename)
	}
	Quit tSC
}

Method TCLGetVariable(pParsedTCL, ByRef pThisExpr, pNextSibling = 1) As %String
{
	If $D(pThisExpr) Set pParsedTCL.NodeId = pThisExpr
	If pNextSibling {
		If 'pParsedTCL.MoveToNextSibling(1) Write No_Sibling
	}
	If $D(pThisExpr) Set pThisExpr = pParsedTCL.NodeId
	Set tVariable = $Method($this,"TCL"_pParsedTCL.NodeData, .pParsedTCL)
	If tVariable]"" {
		Set tVariable = ..TCLGetVariableProcessing(tVariable)
	}
	If $D(pThisExpr) {
		Set pParsedTCL.NodeId = pThisExpr
	}
	Quit tVariable
}

Method TCLGetVariableProcessing(pVariable)
{
	If pVariable="$xlateInVals" {
		If ..TCLVariables("pVariables","IN")'=1 {
			$$$ThrowOnError($$$ERROR($$$GeneralError,"multiple in values")) 
		}
		Set pVariable = ..TCLVariables("pVariables","IN",1)
	} ElseIf pVariable="xlateOutVals" {
		If ..TCLVariables("pVariables","OUT")'=1 {
			$$$ThrowOnError($$$ERROR($$$GeneralError,"multiple in values")) 
		}
		Set pVariable = ..TCLVariables("pVariables","OUT",1)
	} ElseIf $E(pVariable)="$" {
		Set pVariable = $E(pVariable,2,*)   /// variables references are $Enum
	}
	Quit pVariable
}

/// <lassigncommand>lassign<expr><term><varvalue>$xlateInVals</varvalue></term></expr><expr><term><var>lname</var></term></expr></lassigncommand>
Method TCLcalllassigncommand(ByRef pParsedTCL) As %Status
{
	Set tSC = $$$OK
	Try {
		$$$MoveToFirstChild(pParsedTCL,"lassign")
		$$$MoveToNextSibling(pParsedTCL,"expr")
		Set tNodeId = pParsedTCL.NodeId
		Set tVariable = ..TCLGetVariable(pParsedTCL,tNodeId,0)
		Set tToWhere = ..GetNodeData(pParsedTCL,.tNodes,1)
		Set tCode = ##class(CodeSet).%New()
		Set tCode.Variable = tToWhere
		Set tCode.Value = tVariable
		Set ..TCLVariables("Code",$i(..TCLVariables("Code")))=tCode
		If $G(..TCLVariables("pVariables","TABLE"))]"" {
			Merge tVariables = ..TCLVariables("pVariables")
			Do ..AddTableToCopy(.tVariables,tCode)
		}
		Set:'$D(..TCLVariables("pProcessed")) ..TCLVariables("pProcessed")=1
	} Catch ex {
		Set ..TCLVariables("pProcessed")=0
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// regsub -all {[^0-9]} $xlateInVals "" $xlateOutVals
/// <regsubcommand>regsub-all<regex>{<regexbody>[^0-9]</regexbody>}</regex><expr><term><varvalue>$xlateInVals</varvalue></term></expr><expr><term><string>""</string></term></expr><expr><term><var>xlateOutVals</var></term></expr></regsubcommand>
/// **** Not Currently Implemented **** ending line ..TCLVariables("pProcessed")=0
Method TCLcallregsubcommand(ByRef pParsedTCL) As %Status
{
	Set tProcessed = 0
	//break
	If pParsedTCL.MoveToFirstChild(1) {
		Set ^%zjb("REGSUB",pParsedTCL.NodeData_" ")=""
		$$$MoveToNextSibling(pParsedTCL,"regex")
		$$$MoveToFirstChild(pParsedTCL,"{")
		$$$MoveToNextSibling(pParsedTCL,"regexbody")
		Set tNodeId = pParsedTCL.NodeId
		If pParsedTCL.MoveToFirstChild(1) {
			Set tWhat = pParsedTCL.NodeData
		}
		Set tSource = ..TCLGetVariable(pParsedTCL,.tNodeId,1)
		Set tWith = ..GetNodeData(pParsedTCL,.tNodes,1,0)
		Set tNodeId = pParsedTCL.NodeId
		Set tWhere = ..TCLGetVariable(pParsedTCL,.tNodeId,1)
	} Else {
		/// couldn't move to get command
		Set tProcessed = 0
	}
	Set ..TCLVariables("pProcessed")=0 
	Quit $$$OK
}

///  could be expr/term/bracketed or expr/term/var
Method TCLexpr(pParsedTCL, pThisExpr = "") As %String
{
	Set tThisExpr = pParsedTCL.NodeId
	$$$MoveToFirstChild(pParsedTCL,"")
	If pParsedTCL.NodeData'="term" break:..Debug  Quit 
	$$$MoveToFirstChild(pParsedTCL,"")
	Set tNode = pParsedTCL.NodeData
	Set tValue = $method($this,"TCL"_tNode,.pParsedTCL,.pThisExpr)
	Quit tValue
}

Method TCLvar(ByRef pParsedTCL, pThisExpr)
{
	Set tThisExpr = pParsedTCL.NodeId
	$$$MoveToFirstChild(pParsedTCL,"")
	Set tValue = pParsedTCL.NodeData
	If tValue = "string" {
		If pParsedTCL.MoveToFirstChild(1) {
			Set tValue = pParsedTCL.NodeData
		} Else {
			Set pParsedTCL.NodeId=pThisExpr   /// move back to <expr> of string so we can go to next sibling and down
			If 'pParsedTCL.MoveToNextSibling(1) $$$ThrowOnError($$$ERROR($$$GeneralError," no sibling next to string"))
			Set pThisExpr = pParsedTCL.NodeId
			$$$MoveToFirstChild(pParsedTCL,"term")
			$$$MoveToFirstChild(pParsedTCL,"var")
			$$$MoveToFirstChild(pParsedTCL,"")
			//break:pParsedTCL.NodeData["first"
			Set tValue = $Method($this,"TCL"_pParsedTCL.NodeData, .pParsedTCL,.pThisExpr)
		}
	}Else {
		try {
			Set tProcessed=0
			Merge tVariables = ..TCLVariables("pVariables")
			Set pParsedTCL.NodeId=pThisExpr
			//Set tCode = ##class(CodeSet).%New()
			Set tValue = $method($this,"TCLPF"_tValue,.pParsedTCL,.tVariables,.tCode,.tProcessed)
			Set pThisExpr = pParsedTCL.NodeId
		} catch ex {
			Do ..ReportItem("Missing function "_tValue,0)
			
		}
		If tProcessed && $isObject($g(tCode)) {
			Set ..TCLVariables("Code",$i(..TCLVariables("Code")))=tCode
		}
		If 'tProcessed || '$D(..TCLVariables("pProcessed")) {
			Set ..TCLVariables("pProcessed")=tProcessed
		}
		If '$D(tVariables("PRE")) Kill ..TCLVariables("pVariables","PRE")
	}
	Quit tValue

	//
	//Quit tValue
}

Method TCLvarvalue(ByRef pParsedTCL, pThisExpr)
{
	$$$MoveToFirstChild(pParsedTCL,"")
	Quit pParsedTCL.NodeData
}

Method TCLstring(ByRef pParsedTCL, pThisExpr)
{
	//Set pParsedTCL.NodeId = pThisExpr
	Set tValue=""
	Quit:'pParsedTCL.MoveToFirstChild(1)
	Set tValue = pParsedTCL.NodeData
	break:pParsedTCL.MoveToNextSibling(1)
	Quit tValue
}

Method TCLbracketed(ByRef pParsedTCL, pThisExpr)
{
	$$$MoveToFirstChild(pParsedTCL,"[")
	$$$MoveToNextSibling(pParsedTCL,"")
	Set tNode = pParsedTCL.NodeData
	Set pThisExpr = pParsedTCL.NodeId
	Set tReturn=""
	For  {
		Set tValue = $method($this,"TCL"_tNode,.pParsedTCL,.pThisExpr)
		If tValue'="string" {
			Set tReturn = tReturn _ tValue
		}
		Set pParsedTCL.NodeId=pThisExpr
		Quit:'pParsedTCL.MoveToNextSibling(1)
		Set pThisExpr = pParsedTCL.NodeId
		Quit:pParsedTCL.NodeData="]"
	}
		
	Quit "("_tReturn_")"
	Set pParsedTCL.NodeId = pThisExpr
	$$$MoveToNextSibling(pParsedTCL,"")
	Set tThisExpr = pParsedTCL.NodeId
	try {
		Set tValue = $Method($this,"TCL"_tVarNode, .pParsedTCL,tThisExpr)
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
}

Method TCLlength(ByRef pParsedTCL, pThisExpr)
{
	Set pParsedTCL.NodeId = pThisExpr
	Set tValue=""
	Set tVariable = ..TCLGetVariable(pParsedTCL,pThisExpr,1)
	If 'pParsedTCL.MoveToNextSibling(1) Write no_sibling  /// item will end up as annotation
	Set pThisExpr = pParsedTCL.NodeId
	Set tValue = "..Length("_tVariable_")" 	
	Quit tValue
}

Method TCLregsub(ByRef pParsedTCL, pThisExpr)
{
	Set pParsedTCL.NodeId = pThisExpr
	break
	Set ..TCLVariables("pProcessed")=0
}

Method TCLtolower(ByRef pParsedTCL, pThisExpr)
{
	Set tVariable = ..TCLGetVariable(pParsedTCL,.pThisExpr,1)
	Set tValue = "..ToLower("_tVariable_")"
	Quit tValue
}

Method TCLtoupper(ByRef pParsedTCL, pThisExpr)
{
	Set tVariable = ..TCLGetVariable(pParsedTCL,.pThisExpr,1)
	/*
	Set tVariable = $Method($this,"TCL"_pParsedTCL.NodeData, .pParsedTCL,.pThisExpr)
	If tVariable = "$xlateInVals" {
		If ..TCLVariables("pVariables","IN")'=1 { $$$ThrowOnError($$$ERROR($$$GeneralError,"More than 1 input varialbe"))}
		Set tVariable = ..TCLVariables("pVariables","IN",1)
	} ElseIf $E(tVariable)="$" {
		Set tVariable = $E(tVariable,2,*)
	}
	*/
	Set tValue = "..ToUpper("_tVariable_")"
	Quit tValue
}

Method TCLlindex(ByRef pParsedTCL, pThisExpr)
{
	break:..Debug
	Set ..TCLVariables("pProcessed")=0
}

Method TCLrange(ByRef pParsedTCL, pThisExpr)
{
	//break
	Set tValue=""
	Set tVariable = ..TCLGetVariable(pParsedTCL,.pThisExpr,1)
	Set tRangeFrom = ..GetNodeData(pParsedTCL,.tNodes) 
	If tRangeFrom?1.N.N {
		Set tRangeFrom = tRangeFrom+1
	} Else {
		If tRangeTo="end" {
			Set tRangeTo="*"
		} Else {
			Set ..TCLVariables("pProcessed")=0
			break:..Debug
			Quit ""
		}
	}
	
	Set tRangeTo = ..GetNodeData(pParsedTCL,.tNodes)
	If tRangeTo?1.N.N {
		Set tRangeTo = tRangeTo+1
	} Else {
		If tRangeTo="end" {
			Set tRangeTo="*"
		} Else {
			Set ..TCLVariables("pProcessed")=0
			break:..Debug
			Quit ""
		}
	}
	Set pThisExpr=pParsedTCL.NodeId
	Set tValue = "..SubString("_tVariable_","_tRangeFrom_$S(tRangeTo'=tRangeFrom:","_tRangeTo,1:"")_")"
	Quit tValue
}

Method GetNodeData(pParsedTCL, ByRef pNodes, pNextSibling = 1, pAllowEmpty = 0) As %String
{
	try {
		Set pNodes=""
		If pNextSibling && 'pParsedTCL.MoveToNextSibling(1) {
			If pAllowEmpty Return ""
			break:..Debug  Quit
		}
		Set tTopNode = pParsedTCL.NodeId
		Set tValue=""
		For  {
			Quit:'pParsedTCL.MoveToFirstChild(1)
			If tValue]"" {
				Set pNodes=pNodes_$lb(tValue)
			}
			Set tValue = pParsedTCL.NodeData
		}
	} catch ex {
		$$$ThrowOnError(ex)
	}
	break:'$D(tTopNode)
	Set pParsedTCL.NodeId=tTopNode
	Quit tValue
}

Method TCLtrimright(ByRef pParsedTCL, pThisExpr)
{
	Quit ..TCLtrim(.pParsedTCL,.pThisExpr,">")
}

Method TCLtrimleft(ByRef pParsedTCL, pThisExpr)
{
	Quit ..TCLtrim(.pParsedTCL,.pThisExpr,"<")
}

Method TCLtrim(ByRef pParsedTCL, pThisExpr, pTrimWhere = "<>")
{
	Set tValue=""
	Set tVariable = ..TCLGetVariable(pParsedTCL,.pThisExpr,1)
	Set tTrimWhat = $zstrip(..GetNodeData(pParsedTCL,.tNodes,1,1),"<>",$c(34))   /// tTrimWhat could be "0" which would end up ""0""
	If tTrimWhat]"" {
		If 'pParsedTCL.MoveToNextSibling(1) break:..Debug  Quit ""  /// item will end up as annotation
	}
	Set pThisExpr = pParsedTCL.NodeId
	Set tValue = "..Strip("_tVariable_","""_pTrimWhere_""","_$S(tTrimWhat]"":$c(34)_tTrimWhat_$c(34),1:"$C(9,10,13)")_")"
	Quit tValue
}

Method TCLcallothercommand(ByRef pParsedTCL) As %Status
{
	If 'pParsedTCL.MoveToFirstChild(1) Write no_child_error
	Merge tVariables = ..TCLVariables("pVariables")
	Set tCode = ##class(CodeSet).%New()
	Set tNodeData = pParsedTCL.NodeData
	Do $method($this,"TCLPF"_tNodeData,.pParsedTCL,.tVariables,.tCode,.tProcessed)
	If tProcessed {
		Set ..TCLVariables("Code",$i(..TCLVariables("Code")))=tCode
	}
	If 'tProcessed || '$D(..TCLVariables("pProcessed")) {
		Set ..TCLVariables("pProcessed")=tProcessed
	}
	If '$D(tVariables("PRE")) Kill ..TCLVariables("pVariables","PRE")
	Quit $$$OK
}

Method TCLcallechocommand(ByRef pParsedTCL) As %Status
{
	try {
		If $parameter($this,"TCLLOGECHO") {
			If 'pParsedTCL.MoveToFirstChild(1) Write No_first_child  /// echo
			Set tCode = ##class(CodeCOS).%New()
			Set tCode.Annotation = "Comment"
			Set tText = $c(9)_"// echo"
			For  {
				Set tText = tText_" "_..GetNodeData(.pParsedTCL,.tNodes,1,1)
				Quit:tNodes=""
			}
			Do tCode.Lines.Insert(tText)
			Set ..TCLVariables("Code",$i(..TCLVariables("Code")))=tCode
		}
		Set:'$D(..TCLVariables("pProcessed")) ..TCLVariables("pProcessed")=1
	} catch {
		Set ..TCLVariables("pProcessed")=0
	
	}
	Quit $$$OK
}

Method TCLcallsetcommand(ByRef pParsedTCL) As %Status
{
	Set tSC = $$$OK
	Try {
		$$$MoveToFirstChild(pParsedTCL,"set")
		Set tNodeId = pParsedTCL.NodeId  
		$$$MoveToNextSibling(pParsedTCL,"var")
		Set tNodeId = pParsedTCL.NodeId
		If 'pParsedTCL.MoveToFirstChild(1) $$$ThrowOnError($$$ERROR($$$GeneralError,"No child for set var"))  /// item will end up as annotation
		Set tVariable = pParsedTCL.NodeData
		Set pParsedTCL.NodeId = tNodeId
		Set tThisExpr = tNodeId
		Set tVariable = ..TCLGetVariableProcessing(tVariable) 
		Set tThisExpr = pParsedTCL.NodeId
		Set tValue = ..TCLGetVariable(pParsedTCL,.tThisExpr,1)
		If tValue]"" {
			Set tCode = ##class(CodeSet).%New()
			Set tCode.Variable = tVariable
			Set tCode.Value = tValue
			Set ..TCLVariables("Code",$i(..TCLVariables("Code")))=tCode
			If $G(..TCLVariables("pVariables","TABLE"))]"" {
				Merge tVariables = ..TCLVariables("pVariables")
				Do ..AddTableToCopy(.tVariables,tCode)
			}
			
			Set:'$D(..TCLVariables("pProcessed")) ..TCLVariables("pProcessed")=1
		}
	} Catch ex {
		Set ..TCLVariables("pProcessed")=0
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method instrTerm(pNode)
{
	If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected Child",1) break:..Debug  Quit   // ERR
	If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected term",1) break:..Debug  Quit  /// term
	If pNode.LocalName'="term" Do ..ReportItem("Expected term",1) break:..Debug  Quit /// expecting term
	/// what to do with term
	If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected ERR",1) break:..Debug  Quit   // ERR
	If pNode.NodeType=$$$xmlTEXTNODE {
		Set tTerm=pNode.NodeData
	} Else {
		/// could be in <block>
		If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected Child",1) break:..Debug  Quit   // ERR
		If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected term",1) break:..Debug  Quit  /// term
		If pNode.NodeType=$$$xmlELEMENTNODE && (pNode.LocalName="term") {
			If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected Child",1) break:..Debug  Quit   // ERR
			Set tTerm = pNode.NodeData
		} ElseIf pNode.NodeType=$$$xmlTEXTNODE && (pNode.LocalName="term") {
			Set tTerm=pNode.NodeData
		} Else {
			break   }  /// don't have tTerm
	}
	Quit $zstrip(tTerm,"<>W")
}

/// Build an array of values found in the preblockbody
Method preblockValues(pNode, ByRef pData, pStrip = "", pSingleValue = 0) As %String
{
	Set tString=""
	Set pData=+$G(pData)
	For  {
		If pNode.NodeType = $$$xmlTEXTNODE || (pNode.NodeType=$$$xmlWHITESPACENODE) {
			If '('pData && (pStrip=pNode.NodeData)) {
				Set tValue = pNode.NodeData
				If pStrip]"" && (pStrip = $E(tValue,1,$l(pStrip))) {
					Set tValue = $E(tValue,$l(pStrip)+1,*)
					continue:$zstrip(tValue,"<>W")=""
				}
				If $D(pData("InVdoc")) {  /// vdoc items could be 0(0).MSH(0) 0(0).PID(0)
					For tIdx=1:1:$l(tValue," ") {
						Set tPiece = $p(tValue," ",tIdx)
						Continue:tPiece=""
						Set pData($i(pData))=tPiece
					}
				} Else {
					Set pData($i(pData))=tValue
				}
			}
		} ElseIf pNode.NodeType=$$$xmlELEMENTNODE {
			//If pNode.LocalName="block" Set pData=pData+1,pData("InBlock")=1
			If pNode.LocalName="vdoc" Set pData("InVdoc")=1,tInVdoc=1
			Set tNodeId = pNode.NodeId
			If pNode.MoveToFirstChild(0) {
				Do ..preblockValues(pNode,.pData,pStrip)
			}
			If $G(tInVdoc) Kill pData("InVdoc")
			Set pNode.NodeId = tNodeId
		} Else {break}
		Quit:'pNode.MoveToNextSibling(0)
	}
	If pSingleValue {
		If $G(pData)<=1 {
			Quit $G(pData(1))
		} Else {
			break:..Debug  Do ..ReportItem("Expected Single value "_..NodeAsText(pNode),1)
		}
	}
	Quit ""
}

Method EvaluateValue(pValue, pSourceTarget)
{

	Set tValue=$zstrip(pValue,"<W")
	If $e(tValue,1)="@" {
		Set tValue = $E(tValue,2,*)
		If tValue="null" {
			Set tValue = $C(34,34)
		} Else {
			$$$FixVariable(tValue,tValue,..#VARIABLETRANSLATEFROM,..#VARIALBETRANSLATETO)
		}
	} ElseIf $E(tValue)="=" {
		Set tValue = $C(34)_$replace($E(tValue,2,*),$c(34),$c(34,34))_$C(34)
	} ElseIf $E(tValue)="$" {
		/// variable (in math $%s10
		Set tValue = $E(tValue,2,*)
	} Else {
		If $E(tValue)="~" {
			If pSourceTarget="source" {
			Set tValue = "target.{[|||"_$E(tValue,2,*)_"|||]}"
			} Else { 
				Do ..ReportItem("Unexpected ~ for target",1)
			}
		} Else {
			Set tValue = pSourceTarget_".{[|||"_tValue_"|||]}"
		}
		Set ..VariableReplacement(tValue)=""
	}
	Quit tValue
}

Method Simplify(pNode, ByRef pData, pStrip = "", pSourceTarget = "")
{
	Do ..preblockValues(pNode,.tValues,pStrip) 
	/// most common case 3 lines { + 0(0).MSH + }
	If (tValues)=3 && ($zstrip($G(tValues(1)),"<>WC") = "{") && ($zstrip($G(tValues(3)),"<>WC") = "}") {
		Set pData($i(pData))=..EvaluateValue($zstrip($g(tValue(2)),"<>W"))
	} Else {
		New %node,%nodes,%EvaluatedValue
		Set tOpenCount=0,tCloseCount=0
		Set %node="P1"
		Set tParameters=""
		For tIdx=1:1:tValues {
			Set tValue = $zstrip(tValues(tIdx),"<>W")
			If tValue["{" {
				Set tOpenCount=tOpenCount+1
				Set %node=%node_","_tOpenCount
				Set:$E(%node)="," %node=$E(%node,2,*)
			}
			If tValue["}" {
				Set tCloseCount=tCloseCount+1
				Set %node=$p(%node,",",1,$l(%node,",")-1)
				Set $p(%node,",")=$I(tOpenCount(tOpenCount,%node))
				Set:%node="" %node=1
			}

			Set tValue = $zstrip(tValue,"<>W","{}")
			Continue:tValue=""
			If tValue ["{" || (tValue = "}") Continue
			If tValue["{" break:..Debug
			If tValue["}" break:..Debug
			Set %EvaluatedValue = ..EvaluateValue(tValue,pSourceTarget)
			Set pData($i(pData)) = %EvaluatedValue
			Set $p(%node,",")=$I(tOpenCount(tOpenCount,%node))
			Set @("%nodes("_%node_")=%EvaluatedValue")
		}
	}
}

Method SimplifyOut(pNode, ByRef pData, pStrip = "")
{
	Do ..preblockValues(pNode,.tOutValues,pStrip) //break:tOutValues>3
	//Merge pData = tOutValues
	For tIdx=1:1:tOutValues {
		Set tValue = $zstrip(tOutValues(tIdx),"<>W","{}")
		Continue:tValue=""
		If tValue ["{" || (tValue = "}") Continue
		If tValue["{" break:..Debug
		If tValue["}" break:..Debug
		Set pData($i(pData))=..EvaluateValue(tValue,"target")
	}
}

Method SimplifyIN(ByRef pVariables, pDTLCode, pNode)
{
	/*
		pData=3
pData(1)=" {"
pData(2)="1(0).0(0).0(0).PID.00110 =ymdhm_m_slash_d_slash_cy"
pData(3)="}"

pData=8
pData(1)=" {"
pData(2)="{"
pData(3)="~1(0).1(0).1(0).OBX(0).#5(0).[4]"
pData(4)="}"
pData(5)=" {"
pData(6)="1(0).1(0).1(0).OBX(%s1).#5(0).[4]"
pData(7)="}"
pData(8)="}"

pData=5
pData(1)=" {"
pData(2)="=AUT "
pData(3)="{=AUTOPSY REPORT}"
pData(4)=" =AUT"
pData(5)="}"


	*/
		
	/// things to handle ~ @ = 
	//Merge pData = tOutValues

	Merge tInValues = pVariables("IN")
	Kill tData
	For tIdx=1:1:$G(tInValues) {
		Set tValue = $zstrip(tInValues(tIdx),"<>W","{}")
		Continue:tValue=""
		If tValue ["{" || (tValue = "}") Continue
		If tValue["{" {
			Do ..ReportItem("Unexpected input "_tValue,0)
		}
		If tValue["}" {
			Do ..ReportItem("Unexpected input "_tValue,0)
		}
		Set tValue = ..EvaluateValue(tValue,"source")
		//If $l(tValue)>3 && (tValue["@" || (tValue["=") || (tValue["~")) && (tValue'="""^~\""") break:..Debug  // just make sure it makes sense zw pData
		Set tData($i(tData))=tValue
	}
	If '$D(tData) {
		/// must be some pre-processing code
		Quit
	}
	Kill pVariables("IN")
	Merge pVariables("IN")=tData
	Quit
	If $D(pVariables("OUT")) {
		Set tSep=$G(pVariables("Sep"))
		If tSep]"" Break:..Debug
		If tSep]"" && (pVariables("OUT")>1) break:..Debug  /// what to do with separator
		If pVariables("OUT")=1 && (tData>1) {
			Set tValue = ""
			For tIdx=1:1:tData {
				Set tValue = tValue _tSep_"_"_ tData(tIdx) 
			}
			Kill tData
			Set tData($i(tData))=$E(tValue,$l(tSep)+2,*)  /// skip the beginning separator and _
		}
	}
	Kill pVariables("IN")
	Merge pVariables("IN")=tData
	Quit:'$D(pVariables("OUT"))
	If tData'=$g(pVariables("OUT")) {
		Set tCodeCOS = ##class(CodeCOS).%New()
		Do pDTLCode.Insert(tCodeCOS)
		Set tCodeCOS.Disabled=1
		Do tCodeCOS.Lines.Insert($C(9)_"/// number of input values ("_tData_") does not match output values ("_pVariables("OUT")_")")
		Do tCodeCOS.Lines.Insert($c(9)_"/* "_..NodeAsText(pNode)_" */")
		/*
		Set tValue = ""
		For tIdx = 1:1:tData { Set tValue = tValue _"{"_tData(tIdx)_"} "}
		Do tCodeCOS.Lines.Insert($C(9)_"/// input "_tValue)
		Set tValue = ""
		For tIdx = 1:1:pVariables("OUT") { Set tValue = tValue _"{"_pVariables("OUT",tIdx)_"} "}
		Do tCodeCOS.Lines.Insert($C(9)_"/// output "_tValue)
		*/
	}
	Quit
}

/// turn their string into ours
/// {{0(0).PID(0).#5(0).[1]} {= } {0(0).PID(0).#5(0).[2]}}
/// 		==>  source.{{0(0).PID(0).#5(0).[1]} _ " " _ source.{0(0).PID(0).#5(0).[2]}
/// {{~0(0).MSH(0).#4(0).[0]}}
/// 		==>  target.{0(0).MSH(0).#4(0).[0]}
/// 
ClassMethod GetString(pType, pString = "", pCode As EnsLib.InteropTools.CodeBuilder.CodeItem, pSeparator = "")
{
	Set tPos = 0
	Set tPiece="",tString=""
	For tPos =1:1:$l(pString) {
		Set tChar = $E(pString,tPos)
		If tChar="{" {
			If tPiece]"" break
		}
		
	}
}

ClassMethod ParseString(pArray = "")
{
	Set tList=""
	Set tListItem=""
	Set tPiece = ""
	For tIdx=1:1:$l(pArray) {
		Set tChar = $E(pArray,tIdx)
		If tChar="{" {
			If tPiece]"" { 
				Set tListItem = tListItem_$lb(tPiece)
				Set tPiece=""
			}
		} ElseIf tChar = "}" {
			If tPiece]"" {
				Set tListItem = tListItem_$lb(tPiece)
				Set tPiece=""
			}
		}

	}
}

Method GetVariable(pType, pArray = "", pCode As EnsLib.InteropTools.CodeBuilder.CodeItem, pSeparator = "")
{
	Set tVar= pType_".{[|||"_$zstrip($g(pArray),"<>W")_"|||]}"
	Set ..VariableReplacement(tVar)=""
	Quit tVar
}

Method StripBraces(ByRef pArray)
{
	Set tSub=0
	For {
		Set tTopNode = $O(pArray(""),1,tTop) 
		Quit:(tTopNode="" || tTop'="{")
		Set tBottomNode = $O(pArray(""),1,tBottom) Quit:tBottomNode=""
		Quit:(tBottomNode="" || tBottom'="}")
		Kill pArray(tTopNode),pArray(pBottomNode)
	}
}

Method GetConditionValues(pNode As %XML.Node, ByRef pData)
{
	$$$MoveToFirstChild(pNode,"")  /// COND {
	$$$MoveToNextSibling(pNode,"condterm")
	$$$MoveToFirstChild(pNode,"logexpr") 
	$$$MoveToFirstChild(pNode,"relexpr") 
	$$$MoveToFirstChild(pNode,"primary") 
	For  {
		If pNode.NodeData = "primary" {
			Set tSaveID = pNode.NodeId
			$$$MoveToFirstChild(pNode,"term") 
			Set tValue =..NodeAsText(pNode)
			Set pData($i(pData))=..EvaluateValue(tValue,"source")
			Set pNode.NodeId = tSaveID
		} Else { 
			Set pData($i(pData))=pNode.NodeData
			Set pData(pData,"OP")=1
		}  // /nodedata not primary
		Quit:'pNode.MoveToNextSibling(1)
	}
	Set tCondition = ""
	For tIdx = 1:1:pData {
		Set tLParen="",tRParen=""
		If $g(pData(tIdx+1,"OP")) {
			Set tLParen="("
		} ElseIf $G(pData(tIdx-1,"OP")) {
			Set tRParen=")"
		}
		Set tCondition = tCondition_tLParen_pData(tIdx)_tRParen
	}
	Quit tCondition
}

Method GetConditions(pNode As %XML.Node, pCodeIf As EnsLib.InteropTools.CodeBuilder.CodeIf)
{
	Set tSave = pNode.NodeId
	$$$MoveToFirstChild(pNode,"")  /// COND {
	$$$MoveToNextSibling(pNode,"condterm")
	$$$MoveToFirstChild(pNode,"logexpr") 
	$$$MoveToFirstChild(pNode,"relexpr") 
	Set tCondition = "",tCount=0
	For  {
		Set tCount=tCount+1
		Set tCondition = tCondition _..GetConditionals(pNode,.tData)
		If 'pNode.MoveToNextSibling(1) Quit
		//get operator
	}
	//If tCount=1 Set tCondition = $E(tCondition,2,*-1)
	Set pCodeIf.Condition=tCondition
	Quit $$$OK
}

Method GetConditionals(pNode As %XML.Node, pData) As %String
{
	Set tCondition="",tLParen="",tRParen=""
	For  {
		If pNode.NodeData = "logexpr" {
			Set tSaveID = pNode.NodeId
			$$$MoveToFirstChild(pNode,"relexpr")
			Set tCondition = tCondition _ ..GetConditionals(pNode)
			Set pNode.NodeId = tSaveID
		} ElseIf pNode.NodeData = "relexpr" {
			Set tSaveID = pNode.NodeId
			$$$MoveToFirstChild(pNode,"primary") 
			Set tCond = ..GetConditionals(pNode)
			break:tCond=""
			Set tCondition = tCondition _ "(" _ tCond _")"
			Set pNode.NodeId = tSaveID
		} ElseIf pNode.NodeData = "primary" {
			Set tSaveID = pNode.NodeId
			$$$MoveToFirstChild(pNode,"") 
			Set tCondition = tCondition _  ..GetConditionals(pNode) 
			Set pNode.NodeId=tSaveID
		} ElseIf pNode.NodeData = "term" { 
				Set tValue =..NodeAsText(pNode)
				Set tCondition = tCondition _ ..EvaluateValue(tValue,"source")
		} ElseIf pNode.NodeData = "closeparen" || (pNode.NodeData="openparen") {
			Set tSaveID = pNode.NodeId
			$$$MoveToFirstChild(pNode,"")
			Set tCondition = tCondition _ ..GetConditionals(pNode)
			Set pNode.NodeId = tSaveID
		} Else { 
			Set tValue = $zcvt($zstrip(pNode.NodeData,"<>W"),"I","XML")

			If tValue="eq" || (tValue="==") {
				Set tValue = "="
			} ElseIf tValue="ne" || (tValue="!=") {
				Set tValue = "'="
			} ElseIf tValue="lt" || (tValue = "<") {
				Set tValue = "<"
			} ElseIf tValue="le" || (tValue = "<=") {
				Set tValue = "<="
			} ElseIf tValue="gt" || (tValue = ">") {
				Set tValue = ">"
			} ElseIf tValue="ge" ||( tValue = ">=") {
				Set tValue = ">="
			} ElseIf tValue="ct" {
				$$$MoveToNextSibling(pNode,"")
				//Set tSaveID = pNode.NodeId
				Set tValue = ..GetConditionals(pNode)
				/*
				For tIdx=1:1:$l(tValue) {
					Set tChar=$e(tValue,tIdx)
					If tChar=$c(34) Set tChar=tChar_$c(34)
					Set tNewValue=tNewValue_tChar
				}
				*/
				Set tCondition="..Contains("_tCondition_","_tValue_")"
				Set tValue=""
				//Set pNode.NodeId = tSaveID
				
			} 
			Set tCondition = tCondition _ tValue 
		}  // /nodedata not primary
		Quit:'pNode.MoveToNextSibling(1)
	}
	Quit tCondition
}

/// <opcomment> { OP COMMENT }<commentpart>     { COMMENT<preblockbody><preblockitem><preblock> {<preblockbody><preblockitem>if the transaction has an account number =&gt; 9, it's an Epic transaction. Change MSH-4, MSH-6, and PID-3.4 to EHIM</preblockitem></preblockbody>}</preblock></preblockitem></preblockbody> }</commentpart></opcomment>
Method CodeWalkopcomment(pNode As %XML.Node, ByRef pCode)
{
	try {
		Set tSaveNodeId = pNode.NodeId
		Quit:'..#INCLUDECOMMENTS
		$$$MoveToFirstChild(pNode,"")
		$$$MoveToNextSibling(pNode,"")
		If pNode.NodeData = "commentrem" {
			$$$MoveToFirstChild(pNode,"")
			$$$MoveToNextSibling(pNode,"reminstr")
			$$$MoveToFirstChild(pNode,"REM")
			$$$MoveToNextSibling(pNode,"term")
			$$$MoveToFirstChild(pNode,"")
			If $zstrip(pNode.NodeData,"<>W")=1 Quit
			break
		}	

		
		//break  
		$$$MoveToFirstChild(pNode,"COMMENT") 
		$$$MoveToNextSibling(pNode,"")
		//If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected { COMMENT",1) break:..Debug  Quit
		//If pNode.NodeData'["{ COMMENT" break  Do ..ReportItem("Expected { COMMENT",1) break:..Debug  Quit
		//If 'pNode.MoveToNextSibling(1) Do ..ReportItem("Expected <preblockbody>",1) break:..Debug  Quit
		Do ..preblockValues(pNode,.tComments," COMMENT")
		Set tCodeComment = ##class(CodeCOS).%New()
		//Set tCodeComment.Disabled=1
		Do pCode.Insert(tCodeComment)
		Set tIdx = ""
		For tIdx = 1:1:$g(tComments) {
			Set tComment=$zstrip($g(tComments(tIdx)),"<>W","{}")
			Continue:tComment=""
			Do tCodeComment.Lines.Insert($C(9)_"/*"_tComment_" */")
		}
		Set tCodeComment.Annotation="Comment"
	} catch ex {
		Set tSC = ex.AsStatus() break
	}
	Set pNode.NodeId=tSaveNodeId
	Quit 1
}

Method CodeWalkprologue(pNode As %XML.Node, pLevel = 0, pSet = 1, pCommandLine = "", pDebug = 1, pFileName)
{
	#define field(%name) $p($p($p(tPrologue,%name,2),$c(9),2),$c(10))
	If 'pNode.MoveToFirstChild(1) Do ..ReportItem("Expected prologue",1) break:..Debug  Quit
	If pNode.NodeType '= $$$xmlTEXTNODE Do ..ReportItem("Expected text node",1) break:..Debug  Quit
	
	Set tPrologue = pNode.NodeData
	For tInOut = "xlt_infile:","xlt_outfile:" {
		Set tTypeData = $$$field(tInOut)
		Set tType = $p(tTypeData," ")
		If tType'="hl7" Do ..ReportItem("Not HL7:"_tType,1) Quit
		Set tTypeData(tInOut)=tTypeData
		If tInOut= "xlt_infile:" {
			Set:$g(..Code("SourceDocType"))="" ..Code("SourceDocType")=$p(tTypeData," ",4)
			//Set:$g(..Code("SourceDocType"))="" ..Code("SourceDocType")=$p($p(tTypeData," ",4),"_")
			If $p(tTypeData," ",2)=" "||($G(..Code("SourceVersion"))=" ") break
			Set:$G(..Code("SourceVersion"))="" ..Code("SourceVersion")=$p(tTypeData," ",2)
		} Else {
			Set:$g(..Code("TargetDocType"))="" ..Code("TargetDocType")=$p(tTypeData," ",4)
			//Set:$g(..Code("TargetDocType"))="" ..Code("TargetDocType")=$p($p(tTypeData," ",4),"_")
			IF $G(..Code("TargetVersion"))=" " || ($p(tTypeData," ",2)=" ") break
			Set:$G(..Code("TargetVersion"))="" ..Code("TargetVersion")=$p(tTypeData," ",2)
		}
	}
	Quit:..Bail
	Set tDate = $$$field("date:")
	Set tWho = $$$field("who:")
	Set tVersion = $$$field("version:")
	Quit 1
}

}
