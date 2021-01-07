ROUTINE EnsebXML [Type=INC]
#;
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#; The version for the ebXML headers
#;
#define EnsebXMLSOAPAction "ebXML"
#define EnsebXMLVersion	"2.0"
#;
#define EnsebXMLMessageService "urn:oasis:names:tc:ebxml-msg:service"
#define EnsebXMLMessageServiceStatusRequestAction "StatusRequest"
#define EnsebXMLMessageServiceStatusResponseAction "StatusResponse"
#define EnsebXMLMessageServicePingAction "Ping"
#define EnsebXMLMessageServicePongAction "Pong"
#define EnsebXMLMessageServiceAcknowledgmentAction "Acknowledgment"
#define EnsebXMLMessageServiceMessageErrorAction "MessageError"
#;
#define EnsebXMLActorNextMHS "urn:oasis:names:tc:ebxml-msg:actor:nextMSH"
#define EnsebXMLActorToPartyMSH "urn:oasis:names:tc:ebxml-msg:actor:toPartyMSH"
#;
#define EnsebXMLStatusResponseUnAuthorized "UnAuthorized"
#define EnsebXMLStatusResponseNotRecognized "NotRecognized"
#define EnsebXMLStatusResponseReceived "Received"
#define EnsebXMLStatusResponseForwarded "Forwarded"
#define EnsebXMLStatusResponseProcessed "Processed"
#;
#include EnsebXMLErrors
#;
#define EnsebXMLMessageIdFromSessionId(%id,%d)	"Ens-"_$tr($zdt($h,3)," :-")_"-"_$re($zu(114,""))_"-"_%id_"@"_%d
#define EnsebXMLDefaultLanguageForMHS			$$GetDefaultLanguage^%occMessages()
#;
#define EnsebXMLErrorCodeContext				$$$EnsebXMLMessageService_":errors"
#define EnsebXMLErrorSeverityError				"Error"
#define EnsebXMLErrorSeverityWarning			"Warning"
#define EnsebXMLErrorCodeValueNotRecognized 	"ValueNotRecognized"
#define EnsebXMLErrorCodeNotSupported       	"NotSupported"
#define EnsebXMLErrorCodeInconsistent       	"Inconsistent"
#define EnsebXMLErrorCodeOtherXml				"OtherXml"
#define EnsebXMLErrorCodeDeliveryFailure		"DeliveryFailure"
#define EnsebXMLErrorCodeTimeToLiveExpired		"TimeToLiveExpired"
#define EnsebXMLErrorCodeSecurityFailure		"SecurityFailure"
#define EnsebXMLErrorCodeMimeProblem			"MimeProblem"
#define EnsebXMLErrorCodeUnknown				"Unknown"
#;