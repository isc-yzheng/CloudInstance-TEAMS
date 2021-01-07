ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.ConfigChange [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

#define CONFIGCHANGEROOT $$$MAGLOBAL("CONFIGCHANGE")

#define CONFIGCHANGETOP(%key1) $$$MAGLOBAL("CONFIGCHANGE",%key1)

#define CONFIGCHANGESESS(%key1,%key2) $$$MAGLOBAL("CONFIGCHANGE",%key1,%key2)

#define CONFIGCHANGESTARTTIME(%key1,%key2) $$$MAGLOBAL("CONFIGCHANGE",%key1,%key2,0)

#define CONFIGCHANGEFIX(%key1,%key2,%key3) $$$MAGLOBAL("CONFIGCHANGE",%key1,%key2,%key3)