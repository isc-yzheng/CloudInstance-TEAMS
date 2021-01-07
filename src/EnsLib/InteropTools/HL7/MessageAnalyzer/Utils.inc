ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.Utils [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#define NULLOBJECTREF ""

#define ACDEBUGGING 1

#if $$$ACDEBUGGING

#define ACASSERT(%test,%message) If '(%test) {Throw ##class(%Exception.General).%New("Assertion failed: "_(%message))}
#define SHOULDBEUNDEF(%ref) If $Data(%ref) {U 0 Write !!,"Variable should be undefined",! ZWrite %ref Write ! Do ^%STACK BREAK}

#else

#define ACASSERT(%test,%message)
#define SHOULDBEUNDEF(%ref) Kill %ref

#endif

#;--

#define TRUNCATE(%string,%limit) $Select($Length((%string))>(%limit):$Extract((%string),1,(%limit)-4)_" ...",1:(%string))

#define FATAL(%message) Write !!,(%message),!! ZTrap

#define TRIM(%X) $ZSTRIP((%X),"<>W")
#define TOUP(%X) $ZCVT((%X),"U")

/// XML encode - e.g. "<" to "&lt;"
#define XMLENC(%X) $ZCVT((%X),"O","XML")

/// Expand status code
#define STATUS(%sc) ##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Common).Status((%sc))


#define THROWE(%message) ##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Common).Throw(%message)

#define THROW(%message) Throw ##class(%Exception.General).%New(%message)


/// This macro is specified to be usable anywhere that a global reference can be used 
#define GLOBALSETTING(%key) ^Ens.ACSCHEMA((%key))

#define ANYGLOBALSETTINGS ($Order($$$GLOBALSETTING(""))'="")

/// Only for user messages
#define GLOBALSETTINGSNAME "^Ens.ACSCHEMA"


/// MA global name
#define MAGLOBAL ^Ens.MA

/// Monitor session local
#define MAS %masession

#def1arg IFSESSION(%code) If $Data($$$MAS) {Do $$$MAS.%code}
#def1arg IFSESSION0(%code) If $Data($$$MAS) {Do $$$MAS.%code()}


/// Log counts to this location, by the current and caller entryrefs
#define STACKFRAMECOUNT $ZU(41)
#define STACKFRAME(%a) $ZU(41,%a)
#define STACKFRAMEENTRYREF(%a) $Piece($$$STACKFRAME(%a),"^",2,3)
#define COUNTCALLS If $I(%countcalls("."_$$$STACKFRAMEENTRYREF($$$STACKFRAMECOUNT),"."_$$$STACKFRAMEENTRYREF($$$STACKFRAMECOUNT-1))) {}

#; conservative
#define MAXSUBSCRIPTLENGTH 500

/// MUST NOT BE SWITCHED ON OUTSIDE ISC DEVELOPER ENVIRONMENT (takes effect at *compile* time)
#define ALLOWEXECUTE ##expression($Data(^Ens.ACSCHEMA("ALLOWEXECUTE")))

#define IsWindows ($ZVersion(1)=2)

/// The "MA" in "MADB" stands for "message analyzer"
#define DBFLAG $Get(%MADB)
#define DBOUT(%message) If $$$DBFLAG {Write (%message),!}

/// Set %MADB within this scope - uses variable 'automadb'
/// - the package for the ScopedDebug class must be in the class's Import list
#define DBON Set automadb=##class(ScopedDebug).%New(1)
#define DBOFF Set automadb=##class(ScopedDebug).%New(0)


/// Default to second arg if first arg is ""
#define DEFAULT(%A,%B) $Select(%A="":%B,1:%A)


/// Rethrow <INTERRUPT> exceptions
#define RETHROWINTERRUPT(%var) If $Piece(%var.DisplayString()," ")="<INTERRUPT>" {Throw %var	}

/// Set maximum storage for this process
#define SETMAXSTORE Set $ZS=2147483647


#; - Resyncing codes -
 
/// Not resyncing - most recent movement was a success
#define RSNONE 0

/// Resyncing and not allowed to skip parts of the message
#define RSNOSM 1

/// Resyncing and allowed to skip parts of the message
#define RSCANS 2


#; - Failure Outcome Types -

/// No failure
#define FONONE 0

/// Message ended
#define FOMEND 1

/// Schema ended
#define FOSEND 2

/// Mismatch
#define FOMISM 3

/// Control failure
#define FOCONT 4