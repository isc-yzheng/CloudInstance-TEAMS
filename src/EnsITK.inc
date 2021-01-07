ROUTINE EnsITK [Type=INC]
#; EnsITK.inc - Integration Tool Kit (British healthcare)
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#def1arg ITKAppData(%name)  $G(^EnsITK(%name))

#define ITKBPRequestResponse "Request-Response"
#define ITKBPPost "Post"
#define ITKBPAcknowledged "Acknowledged"
#define ITKBPQueueCollection "Queue Collection"
#define ITKBPFaultHandler "Fault Handler"
#define ITKBPAsynchResponseHandler "Asynch Response Handler"

#define ITKAsyncInvocationPattern "Asynchronous"
#define ITKSyncInvocationPattern "Synchronous"
#define ITKAsyncResponseInvocationPattern "Response"
#define ITKDerivedInvocationPattern "Derived"

#define ITKIsSOAPResponse(%action) ($E(%action,*-7,*)="Response")
#define ITKResponseAction(%action) $E(%action,1,*-8)

#define ITKResponse "Response"
#define ITKAsyncResponseHandler "AsyncResponseHandler"
#define ITKFaultHandler "FaultHandler"
#define ITKWSAFaultAction "http://www.w3.org/2005/08/addressing/soap/fault"

#define ITKResponsePending 0
#define ITKResponseComplete 1
#define ITKResponseFault 2

#; Subscription Pull Status
#define ITKSubscriptionPullUncollected 0
#define ITKSubscriptionPullDispatched 1
#define ITKSubscriptionPullConfirmed 2

#define ITKAsynchService "AsynchRequestHandler"
#define ITKSynchService "SynchRequestHandler"
#define ITKFaultService ""

#define ITKTempURN "urn:intersystems-itk:temp"
#define ITKExtensionsURN "urn:intersystems-itk:services:201101"
#define ITKFaultAction "http://www.w3.org/2005/08/addressing/soap/fault"
#define ITKDistributionEnvelope "EnsLib.ITK.Standard.itk.distributionEnvelopeType"

#define ITKDMRoute "Relay"
#define ITKDMAuthoritative "Authoritative"
#define ITKDMNonAuthoritative "Non-Authoritative"

#; Custom SOAP Errors
#define ITKUnauthorisedRequest "<ITKUnauthorisedRequest>"
#define ITKInvalidRequest "<ITKInvalidRequest>"
#define ITKInvalidAddressing "<ITKInvalidAddressing>"
#define ITKInvalidSecurity "<ITKInvalidSecurity>"
#define ITKGeneralError "<ITKGeneralError>"
#define ITKRetryableError "<ITKRetryableError>"
#define ITKNonRetryableError "<ITKNonRetryableError>"
#define ITKSOAPError "<ITKSOAPError>"
 
#define SendSyncResponse 1
#define SendAsyncResponse 2

#; Error strings - !!!put inline
#define ITKWSAFaultNoMessageId "MessageID not present in SOAP Header."
#define ITKWSAFaultBadMessageId "Messages Id format incorrect."
#define ITKWSAFaultNoTo "To element not present in SOAP Header."
#define ITKWSAFaultBadTo "To URL is not same as the end point URL of this service."
#define ITKWSAFaultNoAction "Action not present in SOAP Header."
#define ITKWSAFaultBadAction "Action in SOAP Header is not same as HTTP SOAP Action."
#define ITKWSAFaultNoReplyTo "ReplyTo not present in SOAP Header for this Callback Request."
#define ITKWSAFaultNoRelatesTo "RelatesTo not found in SOAP Header for this Callback Response."
#define ITKWSFaultNoSecurityDetails "Security details not found in SOAP Header."
#define ITKWSFaultNoCreatedTimestamp "Created timestamp not present in SOAP Header."
#define ITKWSFaultNoExpiresTimestamp "Expires timestamp not present in SOAP Header."
#define ITKWSFaultExpiredTimestamp "Message has expired."
#define ITKWSFaultNoUsername "Username not present in SOAP Header."
#define ITKWSFaultUnsignedHeaders "Message Headers that must be signed are not signed."
#define ITKWSFaultNoBinaryToken "Binary Security Token is is not present in SOAP Header."
#define ITKWSFaultMismatchedUsername "Username does not match with the CN of the X509 Certificate."
#define ITKWSFaultInternalSignature "Internal Error. Digital Signature could not be checked."
#define ITKWSFaultNoEncryption "SOAP Body is must be encrypted."
#define ITKWSFaultInternalEncryption "Internal Error. Can not verify if SOAP Body was encrypted."
#define ITKFaultNoResponse "Timeout No response received."
#define ITKFaultBadSubscriptionCall "The Device is in a Subscription-Pull mode. Can not respond to Synchronous call."
#define ITKFaultBadRequestClass(%cl) "Request class not defined for queue collection service "_ %cl _"."
#define ITKFaultUnknownqueueService(%cl) "Unknown Queue Collection Service "_%cl _"."
#define ITKFaultUnregisteredConsumerCapability(%cl) "Consumer capability not registered for service "_ %cl _"."
#define ITKFaultMultipleSubscribers(%srv,%app) "Unable to service synchronous request with multiple subscribers: "_%srv_" from: "_%app
#define ITKNoCallbackDataForMessage(%mid) "No callback data for message: "_%mid
#define ITKNoDuplicatedResponse(%mid) "Response or fault already received for: "_%mid
#define ITKInvalidAddress "Invalid Address: "
