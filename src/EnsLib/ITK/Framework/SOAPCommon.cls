/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (%soap, Ensemble, EnsITK)

/// Base class for both the ITK SOAP Service and Operation
Class EnsLib.ITK.Framework.SOAPCommon Extends %RegisteredObject [ System = 4 ]
{

Parameter SrcVer = "$Id$";

ClassMethod MakeFaultDetail(pVocab As %String, pDetail As %String, sc As %Status, ByRef itkError As EnsLib.ITK.Framework.ToolkitErrorInfoStruct) As %String
{
	// Extract Error Type from pDetail
	// 1. Check if it is SOAP Error i.e. of type 'ERROR #6284: ...'
	Set tCode = +($P($P(pDetail, ":", 1), "ERROR #", 2))
			
	Set tSummary=pDetail
			
	If (tCode >= 6201) && (tCode <= 6399) {
		Set tCode = $$$ITKSOAPError
		
		Set tSummary=$P(pDetail, ":", 2, $L(pDetail, ":"))
		Set tSummary=$ZSTRIP(tSummary, "<>W")
	} Else {
		// Check if an ITK Code is present
		Set tCode = "", cp=0
		Set:cp=0 cp=$FIND(pDetail,$$$ITKUnauthorisedRequest,1) Set:(cp>0)&&(tCode="") tCode=$$$ITKUnauthorisedRequest
		Set:cp=0 cp=$FIND(pDetail,$$$ITKInvalidRequest,1)    Set:(cp>0)&&(tCode="") tCode=$$$ITKInvalidRequest
		Set:cp=0 cp=$FIND(pDetail,$$$ITKInvalidAddressing,1) Set:(cp>0)&&(tCode="") tCode=$$$ITKInvalidAddressing
		Set:cp=0 cp=$FIND(pDetail,$$$ITKInvalidSecurity,1)   Set:(cp>0)&&(tCode="") tCode=$$$ITKInvalidSecurity
		Set:cp=0 cp=$FIND(pDetail,$$$ITKGeneralError,1)      Set:(cp>0)&&(tCode="") tCode=$$$ITKGeneralError
		Set:cp=0 cp=$FIND(pDetail,$$$ITKRetryableError,1)    Set:(cp>0)&&(tCode="") tCode=$$$ITKRetryableError
		Set:cp=0 cp=$FIND(pDetail,$$$ITKNonRetryableError,1) Set:(cp>0)&&(tCode="") tCode=$$$ITKNonRetryableError

		If cp>0 {
			// Original: Set tSummary=$E(pDetail,cp+$L(tCode),*)
			// TPS: 1.0.4, May 2011. Changed because above was double counting errors
			Set tSummary=$E(pDetail,cp,*)
		} Else {
			// TPS: 1.0.4, May 2011. Added so that other errors are still formatted correctly.
			Set tCode=$$$ITKGeneralError
			Set tSummary=$P(pDetail, ":", 2, $L(pDetail, ":"))
		}
	}
	If tCode = "" {
		// Check id pDetail has ENS error
		Set cp=$FIND(pDetail,$$$EnsErrException,1) 
		
		if cp>0 {
			Set tCode=$$$ITKNonRetryableError
			Set tSummary=$E(pDetail,cp+$L($$$EnsErrException),*)
		}
	}
	If tCode = "" Set tCode=$$$ITKGeneralError

	Set tVocabCode = ##class(EnsLib.ITK.Framework.FaultVocabularyMap).%OpenId($E(tCode,2,*-1)_"||"_pVocab)

	If $IsObject(tVocabCode) {
		Set tITKError = ##class(EnsLib.ITK.Framework.ToolkitErrorInfoStruct).%New()
		Set tITKError.ErrorCode = ##class(EnsLib.ITK.Framework.ErrorCode).%New()
		Set tITKError.ErrorCode.codeSystem = pVocab
		
		Set tFaultCode = ##class(EnsLib.ITK.Framework.FaultCode).%OpenId(pVocab_"||"_tVocabCode.VocabularyCode) 
		Set tITKError.ErrorCode.content = tVocabCode.VocabularyCode // Vocab Fault Code
		Set tITKError.ErrorID = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
		Set tITKError.ErrorText = tSummary

		If sc="" {
			Set tITKError.ErrorDiagnosticText = pDetail	
		} Else {
			For i=1:1 {
				Set pDetail=$system.Status.GetOneErrorText(sc,i)
				Quit:pDetail=""
				Set:tITKError.ErrorDiagnosticText'="" tITKError.ErrorDiagnosticText=tITKError.ErrorDiagnosticText_","
				Set tITKError.ErrorDiagnosticText=tITKError.ErrorDiagnosticText_pDetail
			}
		}
		$$$LOGWARNING("FAULT:"_tITKError.ErrorID_" "_tITKError.ErrorDiagnosticText)
		set itkError=tITKError
		Quit ##class(EnsLib.ITK.Util.UtilityMethods).XMLExportToString(tITKError,1)
	} Else {
		$$$LOGERROR("Unrecognised Fault code:"_tCode_" in vocabulary:"_pVocab_" therefore unable to send back following fault as an error: "_pDetail)
		Quit pDetail
	}
}

/// This helper method generates a new ITK request containing a technical NACK
ClassMethod MakeTechnicalNack(pOriginalMessage As EnsLib.ITK.Framework.RequestData, status As %Status, pErrorDesc As %String, pVocab As %String, pReportor As %String) As EnsLib.ITK.Framework.RequestData
{
	set ackService = ##class(EnsLib.ITK.Setup.ServiceDefinition).FromAction("urn:nhs-itk:services:201005:SendInfrastructureAck-v1-0")

	// Constructing via Stream as this is quicker
	set deStream = ##class(%Stream.GlobalCharacter).%New()
	
	set tPayloadId = "uuid_"_##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
	set tProfile = ackService.SOAPAction
	set tService = ackService.SOAPAction
	set tTrackingId = pOriginalMessage.DistributionEnvelope.GetValueAt("*:/header/@trackingId")			//.TrackingId
	set tOrigSender = pOriginalMessage.DistributionEnvelope.GetValueAt("*:/header/sender/uri")			//.SenderAddress
	set tOrigService = pOriginalMessage.DistributionEnvelope.GetValueAt("*:/header/@service")			//.Service

 	do deStream.WriteLine("		<itk:DistributionEnvelope xmlns:itk=""urn:nhs-itk:ns:201005"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">")
 	do deStream.WriteLine("			<itk:header service="""_tService_""" trackingid="""_tTrackingId_""">")
 	do deStream.WriteLine("				<addresslist><address uri="""_tOrigSender_"""></address></addresslist>")
 	do deStream.WriteLine("				<itk:manifestitem id="""_tPayloadId_""" mimetype=""text/xml"" profileid="""_tProfile_""" base64=""false"" compressed=""false"" encrypted=""false""/>")
 	do deStream.WriteLine("			</itk:header>")
 	do deStream.WriteLine("			<itk:payloads count=""1"">")
 	do deStream.WriteLine("				<itk:payload id="""_tPayloadId_""">")
 	do deStream.WriteLine("					<InfrastructureResponse xmlns=""urn:nhs-itk:ns:201005"" xmlns:itk=""urn:nhs-itk:ns:201005"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" result=""Failure"" timestamp="""_$ZDT($ZTIMESTAMP,3,7)_""" trackingIdRef="""_tTrackingId_""" serviceRef="""_tOrigService_""">")
	do deStream.WriteLine("						<reportingIdentity><id type="""_pVocab_""" uri="""_pReportor_"""></id></reportingIdentity>")
	do deStream.WriteLine("						<errors>")
	
	do ..MakeFaultDetail(pVocab, $$$ITKGeneralError_": "_pErrorDesc, status, .err)
	do err.XMLExportToStream(deStream, "errorInfo")
	do deStream.WriteLine("						</errors>")
	do deStream.WriteLine("					</InfrastructureResponse>")
 	do deStream.WriteLine("				</itk:payload>")
 	do deStream.WriteLine("			</itk:payloads>")
 	do deStream.WriteLine("		</itk:DistributionEnvelope>")

	// c. The New Request
    set ret=##class(EnsLib.ITK.Framework.RequestData).%New()
    set ret.ServiceName=ackService.ServiceName
    set ret.Action=ackService.SOAPAction
	set ret.InvocationPattern="Asynchronous"
	set ret.MessageId=##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
	set ret.To=pOriginalMessage.To
	set ret.RelatesTo=pOriginalMessage.MessageId
	set ret.OriginalRelatesTo=pOriginalMessage.OriginalRelatesTo
	set ret.Status=$$$OK
	set ret.Payload=deStream
	set ret.DistributionMode=$$$ITKDMRoute

	// No need to set distribution envelope as payload has everything
	quit ret
}

}
