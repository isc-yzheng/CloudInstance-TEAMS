ROUTINE EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage [Type=INC]

	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils


/// Only for use by the SimpleMessage class
#define SEGMENTTYPE(%S) $Piece(%S,..FSep)

/// Given a message, return the segment delimiter (default CR, LF if no CRs)
#define SEGMENTDELIMITER(%M) $Select(%M[$Char(13):$Char(13),1:$Char(10))

/// Given a message, return the first segment
#define FIRSTSEGMENT(%M) $Piece(%M,$$$SEGMENTDELIMITER(%M))

/// Given a message, return the field delimiter
#define FIELDDELIMITER(%M) $$$DEFAULT($Extract(%M,4),"|")


/// Given a SimpleMessage %M, return the message type (XXX^YYY) as a string
#define SMMSHMESSAGETYPE(%M) $ListToString(%M.AccessComps($$$SMMSHSEGMENT(%M),9,1,2),"^")

/// Given a SimpleMessage %M, return the message control id
#define SMMSHMESSAGECONTROLID(%M) %M.Access($$$SMMSHSEGMENT(%M),10)

/// Given a SimpleMessage %M, return the MSH segment
#define SMMSHSEGMENT(%M) %M.SegmentByIndex(1)

/// Given a SimpleMessage %M, return the Sending Application as a $List
#define SMMSHSENDINGAPPLICATION(%M) %M.AccessComps($$$SMMSHSEGMENT(%M),3,1,3)

/// Given a SimpleMessage %M, return the Sending Facility
#define SMMSHSENDINGFACILITY(%M) %M.AccessComps($$$SMMSHSEGMENT(%M),4,1,3)

/// Given a SimpleMessage %M, return the Sending Application as a $List
#define SMMSHRECEIVINGAPPLICATION(%M) %M.AccessComps($$$SMMSHSEGMENT(%M),5,1,3)

/// Given a SimpleMessage %M, return the Sending Facility as a $List
#define SMMSHRECEIVINGFACILITY(%M) %M.AccessComps($$$SMMSHSEGMENT(%M),6,1,3)
