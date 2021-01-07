ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Session root: ^("SESSION")=sessioncounter
#define MXSESSIONROOT $$$MAGLOBAL("SESSION"
#define MXSESSIONROOTREF $$$MXSESSIONROOT)

#; General

/// A session: ^("SESSION",session)=$H start
#define MXSESSION(%session) $$$MXSESSIONROOT,%session
#define MXSESSIONREF(%session) $$$MXSESSION(%session))

/// Run root: ^("SESSION",session,"RUN")=runcounter
#define MXRUNROOT(%session) $$$MXSESSION(%session),"RUN"
#define MXRUNROOTREF(%session) $$$MXRUNROOT(%session))

/// A run: ^("SESSION",session,"RUN",run)=$H start
#define MXRUN(%session,%run) $$$MXRUNROOT(%session),%run
#define MXRUNREF(%session,%run) $$$MXRUN(%session,%run))

/// Scan root: ^("SESSION",session,"RUN",run,"SCAN")=scancounter
#define MXSCANROOT(%session,%run) $$$MXRUN(%session,%run),"SCAN"
#define MXSCANROOTREF(%session,%run) $$$MXSCANROOT(%session,%run))

/// A scan: ^("SESSION",session,"RUN",run,"SCAN",scan)=$H start
#define MXSCAN(%session,%run,%scan) $$$MXSCANROOT(%session,%run),%scan
#define MXSCANREF(%session,%run,%scan) $$$MXSCAN(%session,%run,%scan))

/// Scan event root: ^("SESSION",session,"RUN",run,"SCAN",scan,"EVENT")=eventcounter
#define MXSCANEVENTROOT(%session,%run,%scan) $$$MXSCAN(%session,%run,%scan),"EVENT"
#define MXSCANEVENTROOTREF(%session,%run,%scan) $$$MXSCANEVENTROOT(%session,%run,%scan))

/// A scan event: ^("SESSION",session,"RUN",run,"SCAN",scan,"EVENT",event)=eventtype
#define MXSCANEVENT(%session,%run,%scan,%event) $$$MXSCANEVENTROOT(%session,%run,%scan),%event
#define MXSCANEVENTREF(%session,%run,%scan,%event) $$$MXSCANEVENT(%session,%run,%scan,%event))

/// Scan event subdatum: ^("SESSION",session,"RUN",run,"SCAN",scan,"EVENT",event,key)=value
#define MXSCANEVENTSUBREF(%session,%run,%scan,%event,%key) $$$MXSCANEVENT(%session,%run,%scan,%event),%key)

#;

#if 0

/// A single message type
#define MXMT(%session,%run,%scan,%messagetype) $$$MXSCAN(%session,%run,%scan),%messagetype
#define MXMTREF(%session,%run,%scan,%messagetype) $$$MXMT(%session,%run,%scan,%messagetype))

/// A single message
#define MXMESSAGE(%session,%run,%scan,%messagetype,%message) $$$MXMT(%session,%run,%scan,%messagetype),%message
#define MXMESSAGEREF(%session,%run,%scan,%messagetype,%message) $$$MXMESSAGE(%session,%run,%scan,%messagetype,%message))

#; Local

/// Variable which holds the current session for this process
#define MCS %masession

/// Variable which holds the current run for this process
#define MCSR %masession("RUN")

/// A single session
#define MSESSION $$$MXSESSION($$$MCS)
#define MSESSIONREF $$$MXSESSIONREF($$$MCS)

/// Run root
#define MRUNROOT $$$MXRUNROOT($$$MCS)
#define MRUNROOTREF $$$MRUNROOTREF($$$MCS)

/// A single run
#define MRUN $$$MXRUN($$$MCS)
#define MRUNREF $$$MXRUNREF($$$MCS,$$$MCSR)

/// A single scan
#define MSCAN(%scan) $$$MXSCAN($$$MCS,$$$MCSR,%scan)
#define MSCANREF(%scan) $$$MXSCANREF($$$MCS,$$$MCSR,%scan)

/// A single message type
#define MMT(%session,%run,%scan,%messagetype) $$$MSCAN(%session,%run,%scan),%messagetype
#define MMTREF(%session,%run,%scan,%messagetype) $$$MMT(%session,%run,%scan,%messagetype))

/// A single message
#define MMESSAGE(%session,%run,%scan,%messagetype,%message) $$$MMT(%session,%run,%scan,%messagetype),%message
#define MMESSAGEREF(%session,%run,%scan,%messagetype,%message) $$$MMESSAGE(%session,%run,%scan,%messagetype,%message))

#;

/// Create a new session
#define MNEWSESSION(%var) Set %var=$I($$$MSESSIONROOTREF),$$$MSESSIONREF(%var)=""

/// Create a new run
#define MNEWRUN(%session,%var) Set %var=$I($$$MRUNROOTREF(%session)),$$$MRUNREF(%session,%var)=""

#;

#endif