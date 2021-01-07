ROUTINE EnsEDIEDIFACT [Type=INC]
#; EnsEDIEDIFACT.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#;
#Include EnsEDISEF
#Include EnsEDIEDIFACTErrors
 
#; LVD array macros
#define vaSegmentGbl             ^EnsEDI.EDIFACT.Segment
#define vaSegment(%sid)          $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2))
#define vaSegmentExt(%sid,%sub)  $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2),%sub)
#define vaSegmentRef(%sid,%doc)  $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2),0,%doc)
#define vaSegmentRefs(%sid)      $$$vaSegmentGbl($P(%sid,","),$P(%sid,",",2),0)
#define vaOpenSegmentPPG		 ^||EnsEDI.EDIFACT.OpenSegment
#define vaExtentGbl              ^EnsLib.EDI.EDIFACT.DocumentD
#; Note: SchemaGbl macros are defined in EnsEDISEF
 
#ifndef LOCALMAPS
#define vaTempInstanceGbl        ^IRIS.Temp.EnsEDI.EDIFACT
#endif
#;
#; 22=Name MAXLEN
#define vaDataSegHeader(%segdata)	   $P($E(%segdata,5,5+22-1),$$$ELESEP(%segdata))
#define vaDataSegName(%segdata)		   $P($$$vaDataSegHeader(%segdata),$$$COMSEP(%segdata))
#define vaDataTypeName(%segdata)       $P($$$SEGELEM(%segdata,2),$$$COMSEP(%segdata),1)
#define vaDataTypeVersion(%segdata)    $TR($P($$$SEGELEM(%segdata,2),$$$COMSEP(%segdata),2,3),$$$COMSEP(%segdata))
#define vaDataIdentifier(%segdata)     $$$SEGELEM(%segdata,1)
#define vaDataUIHTypeName(%segdata)    $P($$$SEGELEM(%segdata,1),$$$COMSEP(%segdata),1)
#define vaDataUIHTypeVersion(%segdata) $TR($P($$$SEGELEM(%segdata,1),$$$COMSEP(%segdata),2,3),$$$COMSEP(%segdata))
#define vaDataUIHIdentifier(%segdata)  $$$SEGELEM(%segdata,3)
#define vaDataUNBTypeVersion(%segdata) $TR($P($$$SEGELEM(%segdata,1),$$$COMSEP(%segdata),1,2),$$$COMSEP(%segdata))
#define vaDataUNBIdentifier(%segdata)  $$$SEGELEM(%segdata,5)
#define vaDataUIBTypeVersion(%segdata) $TR($P($$$SEGELEM(%segdata,1),$$$COMSEP(%segdata),1,2),$$$COMSEP(%segdata))
#define vaDataUIBIdentifier(%segdata)  $P($$$SEGELEM(%segdata,3),$$$COMSEP(%segdata),1)
#define vaDataUNGIdentifier(%segdata)  $$$SEGELEM(%segdata,5)
#define vaDataUNGTypeVersion(%segdata) $TR($P($$$SEGELEM(%segdata,7),$$$COMSEP(%segdata),1,2),$$$COMSEP(%segdata))
#define vaDataUNOTypeName(%segdata)    "Object"
#define vaDataUNOTypeVersion(%segdata) "OBJECT"
#define vaDataUNOIdentifier(%segdata)  $$$SEGELEM(%segdata,1)
 
#; Accessors
#define TYPEID(%t)                $Piece(%t,"|",1)
#define ITEMID(%t)                $Piece(%t,"|",2)
#define REQUIR(%t)                $Piece(%t,"|",3)
#define DATYPE(%t)                $Piece(%t,"|",4)
#define MINLEN(%t)                $Piece(%t,"|",5)
#define MAXLEN(%t)                $Piece(%t,"|",6)
#define REPEAT(%t)                $Piece(%t,"|",7)
 
#define COMSEP(%s)                $E(%s,1)
#define ELESEP(%s)                $E(%s,2)
#define ESCSEP(%s)                $E(%s,3)
#define REPSEP(%s)                $E(%s,4)
#define SEGTERM(%s)               $E(%s,5,7)
 
#; Default Separator values
#define EDIFACTDefComponentSeparator  ":"
#define EDIFACTDefElementSeparator    "+"
#define EDIFACTDefEscapeSeparator     "?"
#define EDIFACTDefRepetitionSeparator "*"
#define EDIFACTDefSeparators          ($$$EDIFACTDefComponentSeparator_$$$EDIFACTDefElementSeparator_$$$EDIFACTDefEscapeSeparator_$$$EDIFACTDefRepetitionSeparator)
#define EDIFACTDefSegTerminator       "'"
 
#; Get stuff directly out of segment global
#define SEGELEM(%seg,%el)         $P(%seg,$$$ELESEP(%seg),2+%el)
#define SEGIDELEM(%id,%el)        $$$SEGELEM($G($$$vaSegmentGbl(+%id)),%el)
#define SEGIDNAME(%id)            $$$SEGIDELEM(%id,0)
 
#define SingleByteAcceptAscii     6
#define SingleByteErrorAscii      21
 
#; Enable all validation levels
#define ValidationFull            7
 
#; Control Segment Ordinals
#define UNKNOWN                           "X-0"
 
#; Events
#define InterchangeStart                  1
#define GroupStart                        2
#define TransactionStart                  4
#define TransactionEnd                    8
#define GroupEnd                          16
#define InterchangeEnd                    32
 
#; Symbols For ControlSegmentItems
#define UNAAuthorizationInformationQual   1
#define UNAAuthorizationInformation       2
#define UNASecurityInformationQualifier   3
#define UNASecurityInformation            4
#define UNAInterchangeIDQualifier         5
#define UNAInterchangeSenderID            6
#define UNAInterchangeIDQualifier2        7
#define UNAInterchangeReceiverID          8
#define UNAInterchangeDate                9
#define UNAInterchangeTime                10
#define UNAInterchangeControlStandardsI   11
#define UNAInterchangeControlVersionNum   12
#define UNAInterchangeControlNumber       13
#define UNAAcknowledgmentRequested        14
#define UNAUsageIndicator                 15
#define UNAComponentElementSeparator      16
 
#define IEANumberofIncludedFunctionalGr   1
#define IEAInterchangeControlNumber       2
 
#define GSFunctionalIdentifierCode        1
#define GSApplicationSendersCode          2
#define GSApplicationReceiversCode        3
#define GSDate                            4
#define GSTime                            5
#define GSGroupControlNumber              6
#define GSResponsibleAgencyCode           7
#define GSVersionReleaseIndustryIdenti    8
 
#define GENumberofTransactionSetsInclu    1
#define GEGroupControlNumber              2
 
#define STTransactionSetIdentifierCode    1
#define STTransactionSetControlNumber     2
 
#define SENumberofIncludedSegments        1
#define SETransactionSetControlNumber     2
 
#; Code Types
 
#define AddCode(%code,%type,%errors)      Set %errors(%type,$Increment(%errors(%type)))=%code
 