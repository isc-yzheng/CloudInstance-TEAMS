ROUTINE EnsEDIX12 [Type=INC]
#; EnsEDIX12.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#;
#Include EnsEDISEF
#Include EnsEDIX12Errors
 
#; LVD array macros
#define vaSegmentGbl             ^EnsEDI.X12.Segment
#define vaExtentGbl              ^EnsLib.EDI.X12.DocumentD
#define vaOpenSegmentPPG		 ^||EnsEDI.X12.OpenSegment

#; PPG to make sure don't get stuck in recursive loop during document deletion
#define vaDocsInDeletePPG		 ^||EnsEDI.X12.InDelete
 
#; Note: SchemaGbl macros are overridden from EnsEDISEF
#define vaSchemaGbl              ^EnsEDI.X12.Schema
#define vaSchemaDescGbl          ^EnsEDI.X12.Description

#; PPG's used for XSD schema import
#define XSDSchemaImportPPG			^||EDI.X12.XSDImport.Schema
#define XSDDescImportPPG			^||EDI.X12.XSDImport.Desc

#ifndef LOCALMAPS
#define vaTempInstanceGbl        ^IRIS.Temp.EnsEDI.X12
#endif

#; These are the V SEF versions that we just overrode
#define vaVSchemaGbl             ^EnsEDI.Schema
#define vaVSchemaDescGbl         ^EnsEDI.Description

#; 22 = Name MAXLEN
#define vaDataSegName(%segdata)        $P($E(%segdata,4,4+22-1),$$$ELESEP(%segdata))
#define vaDataTypeName(%segdata)       $$$SEGELEM(%segdata,1)
#define vaDataTypeVersion(%segdata)    $$$SEGELEM(%segdata,3)
#define vaDataIdentifier(%segdata)     $$$SEGELEM(%segdata,2)
#define vaDataISATypeVersion(%segdata) ($$$SEGELEM(%segdata,12)_"0")
#define vaDataISAIdentifier(%segdata)  $$$SEGELEM(%segdata,13)
#define vaDataGSTypeVersion(%segdata)  $$$SEGELEM(%segdata,8)
#define vaDataGSIdentifier(%segdata)   $$$SEGELEM(%segdata,6)
 
#; Accessors
#define TYPEID(%t)                $Piece(%t,"|",1)
#define ITEMID(%t)                $Piece(%t,"|",2)
#define REQUIR(%t)                $Piece(%t,"|",3)
#define DATYPE(%t)                $Piece(%t,"|",4)
#define MINLEN(%t)                $Piece(%t,"|",5)
#define MAXLEN(%t)                $Piece(%t,"|",6)
#define REPEAT(%t)                $Piece(%t,"|",7)
 
#define ELESEP(%s)                $E(%s,1)
#define COMSEP(%s)                $E(%s,2)
#define REPSEP(%s)                $E(%s,3)
#define SEGTERM(%s)               $E(%s,4,6)
 
#define X12DefControlVersion      "00405"
#define 999ImplementationRef	  "005010X231A1"
 
#; Default Separator values
#define X12DefElementSeparator    "*"
#define X12DefComponentSeparator  ":"
#define X12DefRepetitionSeparator $Char(30)
#define X12DefSeparators          ($$$X12DefElementSeparator_$$$X12DefComponentSeparator_$$$X12DefRepetitionSeparator)
#define X12DefSegTerminator       "~"
 
#; Escaped default Separator values
#define X12DefRepetitionSeparatorEsc "\a"
#define X12DefSeparatorsEsc       ($$$X12DefElementSeparator_$$$X12DefComponentSeparator_$$$X12DefRepetitionSeparatorEsc)
 
#; Get stuff directly out of segment global
#define SEGELEM(%seg,%el)         $P(%seg,$$$ELESEP(%seg),2+%el)
#define SEGIDELEM(%id,%el)        $$$SEGELEM($G($$$vaSegmentGbl(+%id)),%el)
#define SEGIDNAME(%id)            $$$SEGIDELEM(%id,0)
 
#; Ascii values of Start- and End- Block marker characters
#define X12DefStartBlockAscii 2
#define X12DefEndBlockAscii 3
#define HL7DefStartBlockAscii 11
#define HL7DefEndBlockAscii 28 

#define X12DefEndDataCRAscii 13
 
#; For AckMode=Byte ACK
#define SingleByteAcceptAscii 6
#define SingleByteErrorAscii 21
 
#; Enable all validation levels
#define ValidationFull            7
 
#; Control Segment Ordinals
#define UNKNOWN                           "X-0"
#define AK1                               "AK1-1"
#define AK2                               "AK2-2"
#define AK3                               "AK3-3"
#define AK4                               "AK4-4"
#define AK5                               "AK5-5"
#define AK9                               "AK9-6"
#define GE                                "GE-7"
#define GS                                "GS-8"
#define IEA                               "IEA-9"
#define ISA                               "ISA-10"
#define LE                                "LE-11"
#define LS                                "LS-12"
#define SE                                "SE-13"
#define ST                                "ST-14"
#define TA1                               "TA1-15"
 
#; Events
#define InterchangeStart                  1
#define GroupStart                        2
#define TransactionStart                  4
#define TransactionEnd                    8
#define GroupEnd                          16
#define InterchangeEnd                    32
 
#; Symbols For ControlSegmentItems
#define ISAAuthorizationInformationQual   1
#define ISAAuthorizationInformation       2
#define ISASecurityInformationQualifier   3
#define ISASecurityInformation            4
#define ISAInterchangeIDQualifier         5
#define ISAInterchangeSenderID            6
#define ISAInterchangeIDQualifier2        7
#define ISAInterchangeReceiverID          8
#define ISAInterchangeDate                9
#define ISAInterchangeTime                10
#define ISAInterchangeControlStandardsI   11
#define ISARepetitionSeparator			  11
#define ISAInterchangeControlVersionNum   12
#define ISAInterchangeControlNumber       13
#define ISAAcknowledgmentRequested        14
#define ISAUsageIndicator                 15
#define ISAComponentElementSeparator      16
 
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
#define STImplementationConventionRefe    3
 
#define SENumberofIncludedSegments        1
#define SETransactionSetControlNumber     2
 
#define TA1InterchangeControlNumber       1
#define TA1InterchangeDate                2
#define TA1InterchangeTime                3
#define TA1InterchangeAcknowledgmentCod   4
#define TA1InterchangeNoteCode            5
#define TA1InterchangeErrorText           6
 
#define AK1FunctionalIdentifierCode       1
#define AK1GroupControlNumber             2
#define AK1VersionReleaseIndustryIdenti   3
 
#define AK5TransactionSetAcknowledgment   1
#define AK5TransactionSetSyntaxErrorCod   2
#define AK5TransactionSetSyntaxErrorCod2  3
#define AK5TransactionSetSyntaxErrorCod3  4
#define AK5TransactionSetSyntaxErrorCod4  5
#define AK5TransactionSetSyntaxErrorCod5  6
#define AK5TransactionSetErrorText        7
 
#define AK9FunctionalGroupAcknowledgeCo   1
#define AK9NumberofTransactionSetsInclu   2
#define AK9NumberofReceivedTransactionS   3
#define AK9NumberofAcceptedTransactionS   4
#define AK9FunctionalGroupSyntaxErrorCo   5
#define AK9FunctionalGroupSyntaxErrorCo2  6
#define AK9FunctionalGroupSyntaxErrorCo3  7
#define AK9FunctionalGroupSyntaxErrorCo4  8
#define AK9FunctionalGroupSyntaxErrorCo5  9
#define AK9FunctionalGroupErrorText       10
 
#; Code Types
#define CodeTA1I17                        1
#define CodeTA1I18                        2
#define CodeAK3720                        3
#define CodeAK4723                        4
#define CodeAK5717                        5
#define CodeAK5718                        6
#define CodeAK9715                        7
#define CodeAK9716                        8
 
#define AddCode(%code,%type,%errors)      Set %errors(%type,$Increment(%errors(%type)))=%code
 
#; Codes used in TA1 for element I17
#; 
#define CodeTA1I17Accepted                "A"
#define CodeTA1I17AcceptedButErrorsNoted  "E"
#define CodeTA1I17Rejected                "R"
 
#; Codes used in TA1 for element I18
#;
#define CodeTA1I18NoError                                  "000"
#define CodeTA1I18InterchangeControlNumberMismatch         "001"
#define CodeTA1I18StandardNotSupported                     "002"
#define CodeTA1I18ThisControlVersionNotSupported           "003"
#define CodeTA1I18InvalidSegmentTerminator                 "004"
#define CodeTA1I18InvalidSenderIDQualifier                 "005"
#define CodeTA1I18InvalidSenderID                          "006"
#define CodeTA1I18InvalidReceiverIDQualifier               "007"
#define CodeTA1I18InvalidReceiverID                        "008"
#define CodeTA1I18UnknownReceiverID                        "009"
#define CodeTA1I18InvalidAuthorizationQualifier            "010"
#define CodeTA1I18InvalidAuthorizationInformation          "011"
#define CodeTA1I18InvalidSecurityQualifier                 "012"
#define CodeTA1I18InvalidSecurityInformation               "013"
#define CodeTA1I18InvalidDate                              "014"
#define CodeTA1I18InvalidTime                              "015"
#define CodeTA1I18InvalidStandardsID                       "016"
#define CodeTA1I18InvalidVersionID                         "017"
#define CodeTA1I18InvalidControlNumber                     "018"
#define CodeTA1I18InvalidAcknowledgmentRequested           "019"
#define CodeTA1I18InvalidTestIndicator                     "020"
#define CodeTA1I18InvalidNumberOfIncludedGroups            "021"
#define CodeTA1I18InvalidControlStructure                  "022"
#define CodeTA1I18UnexpectedEndOfFile                      "023"
#define CodeTA1I18InvalidContent                           "024"
#define CodeTA1I18DuplicateControlNumber                   "025"
#define CodeTA1I18InvalidDataElementSeparator              "026"
#define CodeTA1I18InvalidComponentElementSeparator         "027"
#define CodeTA1I18InvalidDeliveryDate                      "028"
#define CodeTA1I18InvalidDeliveryTime                      "029"
#define CodeTA1I18InvalidDeliveryTimeCode                  "030"
#define CodeTA1I18InvalidGradeOfServiceCode                "031"
 
#; Codes used in AK3 for element 720
#; 
#define CodeAK3720UnrecognizedSegmentID							1
#define CodeAK3720UnexpectedSegment								2
#define CodeAK3720MandatorySegmentMissing						3
#define CodeAK3720LoopOccursOverMaximumTimes					4
#define CodeAK3270SegmentExceedsMaximumUse						5
#define CodeAK3720SegmentNotInDefinedTransactionSet				6
#define CodeAK3720SegmentNotInProperSequence					7
#define CodeAK3720SegmentHasDataElementErrors					8
#define CodeAK3720ImplementationNotUsedSegmentPresent			"I4"
#define CodeAK3720ImplementationDependentSegmentMissing			"I6"
#define CodeAK3720ImplementationLoopOccursUnderMinimumTimes		"I7"
#define CodeAK3720ImplementationSegmentBelowMinimumUse			"I8"
#define CodeAK3720ImplementationDependentNotUsedSegmentPresent	"I9"
 
#; Codes used in AK4 for element 723
#; 
#define CodeAK4723MandatoryDataElementMissing						1
#define CodeAK4723ConditionalRequiredDataElementMissing				2
#define CodeAK4723TooManyDataElements								3
#define CodeAK4723DataElementTooShort								4
#define CodeAK4723DataElementTooLong								5
#define CodeAK4723InvalidCharacterInDataElement						6
#define CodeAK4723InvalidCodeValue									7
#define CodeAK4723InvalidDate										8
#define CodeAK4723InvalidTime										9
#define CodeAK4723ExclusionConditionViolated						10
#define CodeAK4723TooManyRepetitions								12
#define CodeAK4723TooManyComponents									13
#define CodeAK4723ImplementationNotUsedDataElementPresent			"I10"
#define CodeAK4723ImplementationTooFewRepetitions					"I11"
#define CodeAK4723ImplementationPatternMatchFailure					"I12"
#define CodeAK4723ImplementationDependentNotUsedDataElementPresent	"I13"
#define CodeAK4723CodeValueNotUsedInImplementation					"I6"
#define CodeAK4723ImplementationDependentDataElementMissing			"I9"
 
#; Codes used in AK5 for element 717
#; 
#define CodeAK5717Accepted                                 "A"
#define CodeAK5717AcceptedButErrorsNoted                   "E"
#define CodeAK5717RejectedMessageAuthenticationFailed      "M"
#define CodeAK5717PartiallyAccepted                        "P"
#define CodeAK5717Rejected                                 "R"
#define CodeAK5717RejectedAssuranceFailedValidityTest      "W"
#define CodeAK5717RejectedContentAfterDecryption           "X"
 
#; Codes used in AK5 for element 718
#define CodeAK5718TransactionSetNotSupported					1
#define CodeAK5718TransactionSetTrailerMissing					2
#define CodeAK5718TransactionSetControlNumberMismatch			3
#define CodeAK5718NumberOfIncludedSegmentsMismatch				4
#define CodeAK5718OneOrMoreSegmentsInError						5
#define CodeAK5718MissingOrInvalidTransactionSetIdentifier		6
#define CodeAK5718MissingOrInvalidTransactionSetControlNumber	7
#define CodeAK5718AuthenticationKeyNameUnknown					8
#define CodeAK5718EncryptionKeyNameUnknown						9
#define CodeAK5718RequestedServiceNotAvailable					10
#define CodeAK5718UnknownSecurityRecipient						11
#define CodeAK5718IncorrectMessageLength						12
#define CodeAK5718MessageAuthenticationCodeFailed				13
#define CodeAK5718UnknownSecurityOrginator						15
#define CodeAK5718SyntaxErrorInDecryptedText					16
#define CodeAK5718SecurityNotSupported							17
#define CodeAK5718TransactionSetNotInFunctionalGroup			18
#define CodeAK5718InvalidTransactionSetConventionReference		19
#define CodeAK5718TransactionSetControlNumberNotUnique			23
#define CodeAK5718S3ESecurityEndSegmentMissingForS3S			24
#define CodeAK5718S3SSecurityStartSegmentMissingforS3E			25
#define CodeAK5718S4ESecurityEndSegmentMissingForS4S			26
#define CodeAK5718S4SSecurityStartSegmentMissingForS4E			27
#define CodeAK5718ImplementationOneOrMoreSegmentsInError		"I5"
#define CodeAK5718ImplementationConventionNotSupported			"I6"
 
#; Codes used in AK9 for element 715
#define CodeAK9715Accepted                                 "A"
#define CodeAK9715AcceptedButErrorsNoted                   "E"
#define CodeAK9715RejectedMessageAuthenticationFailed      "M"
#define CodeAK9715PartiallyAccepted                        "P"
#define CodeAK9715Rejected                                 "R"
#define CodeAK9715RejectedAssuranceFailedValidityTest      "W"
#define CodeAK9715RejectedContentAfterDecryption           "X"
 
#; Codes used in AK9 for element 716
#define CodeAK9716NoSpecificErrorCode										""
#define CodeAK9716FunctionalGroupNotSupported								1
#define CodeAK9716FunctionalGroupVersionNotSupported						2
#define CodeAK9716FunctionalGroupTrailerMissing								3
#define CodeAK9716GroupControlNumberMismatch								4
#define CodeAK9716InvalidNumberOfTransactionSets							5
#define CodeAK9716GroupControlNumberViolatesSyntax							6
#define CodeAK9716UnknownAuthenticationKey									10
#define CodeAK9716UnknownEncryptionKey										11
#define CodeAK9716RequestedServiceNotAvailable								12
#define CodeAK9716UnknownSecurityRecipient									13
#define CodeAK9716UnknownSecurityOriginator									14
#define CodeAK9716SyntaxErrorInDecryptedText								15
#define CodeAK9716SecurityNotSupported										16 
#define CodeAK9716IncorrectMessageLengthForEncryption						17
#define CodeAK9716MessageAuthenticationFailed								18
#define CodeAK9716FunctionalGroupControlNumberNotUniqueWithinInterchange	19
#define CodeAK9716S3ESecurityEndSegmentMissingForS3S						23
#define CodeAK9716S3SSecurityStartSegmentMissingforS3E						24
#define CodeAK9716S4ESecurityEndSegmentMissingForS4S						25
#define CodeAK9716S4SSecurityStartSegmentMissingForS4E						26
 
#; Batch child pointer property labels used in DTL
#define GroupsLabel			"FunctionalGroups()"
#define TransactionsLabel	"TransactionSets()"
