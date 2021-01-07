ROUTINE EnsHL7 [Type=INC]
#; EnsHL7.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#;
#define LOCALMAPS
#;
#Include EnsEDI
#Include EnsEDIHL7Errors
 
#define ExpectedSequenceNumber $$$EnsStaticAppData(..%ConfigName,"ExpectedSequenceNumber")
 
#; LVD array macros
#define vaSegmentGbl             ^EnsHL7.Segment
#define vaSegment(%sid)          $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2))
#define vaSegmentExt(%sid,%sub)  $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2),%sub)
#define vaSegmentRef(%sid,%doc)  $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2),0,%doc)
#define vaSegmentRefs(%sid)      $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2),0)
#define vaExtentGbl              ^EnsLib.H.MessageD
#define vaSchemaGbl              ^EnsHL7.Schema
#define vaSchemaDescGbl          ^EnsHL7.Description
#define vaOpenSegmentPPG		 ^||EnsHL7.OpenSegment
#define vaSchemaGblPPG           ^||EnsHL7.Schema
#define vaSchemaDescGblPPG       ^||EnsHL7.Description
#;
#ifndef LOCALMAPS
#define vaTempInstanceGbl        ^IRIS.Temp.EnsHL7
#endif
#;
#define HL7DefFS  "|"
#define HL7DefCS  "^"
#define HL7DefRS  "~"
#define HL7DefESC "\"
#define HL7DefSS  "&"
#define HL7DefSeparators         $$$HL7DefFS_$$$HL7DefCS_$$$HL7DefRS_$$$HL7DefESC_$$$HL7DefSS
#;
#define MAXSEGNAME 22
#define vaDataSegName(%segdata)         $P($E(%segdata,6,5+$$$MAXSEGNAME),$$$FSSEP(%segdata))
#define vaDataDocNameRaw(%segdata)      $P(%segdata,$$$FSSEP(%segdata),10)
#define vaDataDocName(%segdata)         $S("_~\&"_$E(%segdata,3,5)'=$TR("_~\&"_$E(%segdata,3,5),$P(%segdata,$$$FSSEP(%segdata),10)):$E(##class(EnsLib.HL7.Segment).replaceSeparators($E(%segdata,1,5)_$P(%segdata,$$$FSSEP(%segdata),10),":_~\&"),6,*),1:$TR($P(%segdata,$$$FSSEP(%segdata),10),$E(%segdata,1,5),":_~\&"))
#define vaDataDocIdentifier(%segdata)   $TR($P(%segdata,$$$FSSEP(%segdata),11),$E(%segdata,1,5),":_~\&")
#define vaDataBatchIdentifier(%segdata) $TR($P(%segdata,$$$FSSEP(%segdata),12),$E(%segdata,1,5),":_~\&")
#define vaDataTypeVersion(%segdata)     $TR($P(%segdata,$$$FSSEP(%segdata),13),$E(%segdata,1,5),":_~\&")
 
#define FSSEP(%s)                $E(%s,1)
#define CSSEP(%s)                $E(%s,2)
#define RSSEP(%s)                $E(%s,3)
#define ESCSEP(%s)               $E(%s,4)
#define SSSEP(%s)                $E(%s,5)
#define SEGTERM(%s)              $E(%s,6,8)
 
#; Ascii value of Start-Block marker character
#define HL7DefStartBlockAscii 11
 
#; Ascii value of End-Data marker character
#define HL7DefEndBlockAscii 28
 
#; Ascii value of End-Block marker character
#define HL7DefEndDataCRAscii 13
 
#; Ascii value of End-Segment marker character
#define HL7DefSegTerminatorAscii 13
 
#; For AckMode=Byte ACK
#define SingleByteAckAcceptAscii 6
 
#; For AckMode=Byte NACK
#define SingleByteAckErrorAscii 21

#; For long string support
#define HL7MaxReadLen		$S($G($$$EnsConfig("HL7-NoLongStrings")): 32760, 1: $$$MaxLocalLength - 5)
#define HL7MaxSegLen		$S($G($$$EnsConfig("HL7-NoLongStrings")): $$$MAXSEG, 1: $$$MaxLocalLength)