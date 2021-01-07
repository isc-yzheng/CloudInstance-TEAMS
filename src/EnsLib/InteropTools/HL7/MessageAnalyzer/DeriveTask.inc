ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#define CTYPE "C"
#define STYPE "S"
#define RTYPE "R"
#define OTYPE "O"
#define ORTYPE "OR"

#define CNODE $$$NODE($$$CTYPE)
#define SNODE $$$NODE($$$STYPE)
#define RNODE $$$NODE($$$RTYPE)
#define ONODE $$$NODE($$$OTYPE)
#define ORNODE $$$NODE($$$ORTYPE)

#define NODE(%type) $LB(1,%type)

#define PLAINNODE(%list) $LB(0)_%list

#define EXTRACTPLAIN(%list) $List(%list,2,*)

#define NODETYPE(%node) $Select($List(%node)=1:$List(%node,2),1:"")

#define SINGLE(%list) $Select($LL(%list)'=1:$$$THROWE("expected single-item list: "_$ListToString(%list,",")),1:$List(%list))