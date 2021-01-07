ROUTINE EnsLib.InteropTools.HL7.Cloverleaf [Type=INC]
#include EnsLib.InteropTools.HL7.Common
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#define WhiteControl(%s) $TR(%s,$c(9,10,32),"")
#define Variable(%s) If $E(%s)="@" { Set %s=$E(%s,2,*) Set:%s="null" %s=$c(34,34)} Else { Set %s="[|||"_%s_"|||]" } Set ..VariableReplacement(%s)=""
#define NumPosition ^Ens.InteropTools.HL7.CL.Positions
#define Defaults ^Ens.InteropTools.HL7.CL.Default
#define Lines ^Ens.InteropTools.HL7.CL.Lines
#define TCLString ^Ens.InteropTools.HL7.CL.TCL
#define pos(%seg,%item,%pos) Set $$$NumPosition(%seg,%item)=%pos
#define missingpos(%seg,%pos) Set $$$NumPosition("Missing",%seg_":"_%pos)=""
#define DebugGlobal ^Ens.InteropTools.HL7.CL.Debug
