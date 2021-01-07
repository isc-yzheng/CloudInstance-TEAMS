ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.VTColors [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#define VTLEADIN ($Char(27)_"[")

#define VTHIGH(%code) $$$VTLEADIN_%code_"m"

#define VTRESET $$$VTHIGH("")

#define VTFGBLACK $$$VTHIGH(30)

#define VTFGRED $$$VTHIGH(31)

#define VTFGGREEN $$$VTHIGH(32)

#define VTFGYELLOW $$$VTHIGH(33)

#define VTFGBLUE $$$VTHIGH(34)

#define VTFGMAGENTA $$$VTHIGH(35)

#define VTFGCYAN $$$VTHIGH(36)

#define VTFGWHITE $$$VTHIGH(37)