ROUTINE EnsSAPJCO [Type=INC]
#; Definitions for SAP
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#define SapName2EnsName(%input) ($Translate(%input,"_/","us"))

#; Direction flags for marshalling values
#define ENS2SAP 0
#define SAP2ENS 1