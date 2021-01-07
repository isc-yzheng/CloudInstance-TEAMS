ROUTINE EnsLib.InteropTools.HL7.Common [Type=INC]
#define FormCode ^||FormCode
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#define CodeNode ^||CodeNode
#define SkipFile ^Ens.InteropTools.HL7.Skip
#define DoneFile ^Ens.InteropTools.HL7.Done
#; variables are defined with ? - and _ translate them out defined by parameters 
#define FixVariable(%value,%variable,%from,%to) If %variable'["[|||" {Set:%variable?1N.E %variable="t"_%variable Set %value=$Translate(%variable,%from,%to)} Else {Set %value=%variable} Set:%value'=%variable ..Code("ConvertedVariables",%variable)=%value
#;#define FixVariable(%value,%variable,%from,%to) If %variable'["[|||" {Set:%variable?1N.E %variable="t"_%variable Set:%variable?1"%".E %variable="percent"_$E(%variable,2,*) Set %value=$Translate(%variable,%from,%to)} Else {Set %value=%variable} Set:%value'=%variable ..Code("ConvertedVariables",%variable)=%value
#define Bail ..Bail=1
#define DisableCode(%item,%variable) If %item.%variable["[|||" Set %item.Disabled=1
#define MoveToFirstChild(%pNode,%pValue) If ('%pNode.MoveToFirstChild(1) || ((%pValue]"") && ($zstrip($tr(%pNode.NodeData,$c(10)),"<>W","{}")'=%pValue))) Do ..ReportItem("Expected "_%pValue_" @"_..NodeAsText(pNode)) break:..Debug  Quit
#define MoveToNextSibling(%pNode,%pValue) If ('%pNode.MoveToNextSibling(1) || (%pValue]"" && ($zstrip($tr(%pNode.NodeData,$c(10)),"<>W","{}")'=%pValue))) Do ..ReportItem("Expected "_%pValue_" @"_..NodeAsText(pNode)) break:..Debug  Quit
#define InverseScheme ^||Ens.InteropTools.HL7.InvScheme
#define LiteralInverseScheme ##quote($$$InverseScheme)
#define NamesForPosition ^||Ens.InteropTools.HL7.NamedPosition
#define Param(%name) $G(..InputParameters($zcvt(##quote(%name),"U"))) 
#define TableDefaults(%tablename) ^Ens.InteropTools.HL7.TblDefault(%tablename)
#define LogMissingFunction(%function,%system,%file) Set ^Ens.InteropTools.HL7.Missing(%system,%function,%file)=""
#; eGate/DataGate items
#define GateStructure ^Ens.InteropTools.Gate.Structure
#define GateInverseScheme ^Ens.InteropTools.Gate.InvScheme
#define LiteralGateStructure ##quote($$$GateStructure)
#define SubstituteHex(%value) 	IF $L(%value)=6,$E(%value,2,3)="\x" Set %value = "$C("_$zhex($e(%value,4,5))_")"