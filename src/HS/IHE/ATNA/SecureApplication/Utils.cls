Include HS.HC

Class HS.IHE.ATNA.SecureApplication.Utils Extends %RegisteredObject
{

Parameter FOUNDATION = 1;

Parameter XSLRelativePath As STRING = "IHE/ATNA/";

/// Export an EnsLib or HS XMLMessage without attachments (to speed up XSLT processing)
/// See ##class(%XML.Adaptor).XMLExportToStream() for parameter description
ClassMethod XMLExportToStreamWithoutAttachments(ByRef pMessage As HS.Message.XMLMessage, ByRef export As %Stream.Object, top As %String, format As %String, namespaces As %XML.Namespaces, attrs, createId As %String, typeAttr As %String, ByRef oreflist, ByRef idlist, initialIndent As %String) As %Status
{
	#;FUTURE: Make this an instance method of the XMLMessage classes so i%StreamCollection can be manipulated directly rather than using clone
	#;Set tAttachments = pMessage.StreamCollection
	#;Set pMessage.StreamCollection = ""
	#;Set tSC = pMessage.XMLExportToStream(.export,.top,.format,.namespaces,.attrs,.createId,.typeAttr,.oreflist,.idlist,.initialIndent)
	#;Set pMessage.StreamCollection = tAttachments
	Set tMessage = pMessage.%ConstructClone(1)
	Set tMessage.StreamCollection = ""
	Set tSC = tMessage.XMLExportToStream(.export,.top,.format,.namespaces,.attrs,.createId,.typeAttr,.oreflist,.idlist,.initialIndent)
	Quit tSC
}

/// Returns true if the given object is an EnsLib or HS XMLMessage
ClassMethod IsXMLMessage(pMessage As %RegisteredObject) As %Boolean [ CodeMode = expression ]
{
$S('$IsObject(pMessage):0,pMessage.%Extends("HS.Message.XMLMessage"):1,1:0)
}

/// Create an ATNA Audit. Called by the ATNAEvent macro.
/// If pUnitTest is true, this will output a local array of audit message strings in pAuditMessages
ClassMethod Audit(pActor As %String, pRequest As %RegisteredObject = {$$$NULLOREF}, pResponse As %RegisteredObject = {$$$NULLOREF}, pStatus As %Status = {$$$OK}, pAuditSource As %String = "", pSessionId As %String = "", Output pAuditMessages, pUnitTest As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pAuditMessages = 0
		
		#; Check requirements
		If $G(pActor) = "" $$$ThrowStatus($$$ERROR($$$GeneralError,"Audit message actor required"))
		If '$IsObject(pRequest) $$$ThrowStatus($$$ERROR($$$GeneralError,"Request message required"))
		Set tFile =""
		If ..IsXMLMessage(pRequest) {
			Set tFile = $P(pRequest.Name,"Request",1)
			If pRequest.AdditionalInfo.GetAt("USER:Roles")="" Do pRequest.AdditionalInfo.SetAt($Roles,"USER:Roles")
		} ElseIf pRequest.%IsA("EnsLib.HL7.Message") {
			Set tParams("v2SendingApplication") = pRequest.GetValueAt("MSH:3")
			Set tParams("v2SendingFacility") = pRequest.GetValueAt("MSH:4")
			Set tParams("v2ReceivingApplication") = pRequest.GetValueAt("MSH:5")
			Set tParams("v2ReceivingFacility") = pRequest.GetValueAt("MSH:6")
			Set tParams("v2UserRoles") = $Piece($Piece(pRequest.Envelope,"|UserRoles=",2),"|",1)
			If tParams("v2UserRoles")="" Set tParams("v2UserRoles") = $Roles
			Set tParams("v2FromHost") = $Piece($Piece(pRequest.Envelope,"|FromHost=",2),"|",1)
			Set tParams("v2ToHost") = $Piece($Piece(pRequest.Envelope,"|ToHost=",2),"|",1)
			Set tParams("v2HL7Message") = pRequest.OutputToString()
			Set tParams("v2MSH10") = pRequest.GetValueAt("MSH:10")
			If $IsObject(pResponse) Set tParams("v2Status") = pResponse.GetValueAt("MSA:1")
			If $Extract(pRequest.Name,1,7)="QBP_Q22" {
				Set tFile = "PDQv2_Query"
				Set tSC = ..MakePDQv2PatStr(pResponse, .tPatientString)
				Set tParams("v2Patients") = tPatientString
			} ElseIf $Extract(pRequest.Name,1,7)="QBP_Q23" {
				Set tFile = "PIXv2_Query"
				Set tSC = ..MakePIXv2QueryPatStr(pResponse, .tPatientString)
				Set tParams("v2Patients") = tPatientString
			} ElseIf $Extract(pRequest.Name,1,3)="ADT","|A01|A04|A05|A08|"[("|"_$Extract(pRequest.Name,5,7)_"|") {
				Set tFile = "PIXv2_PatientAdd"
				Set tSC = ..MakePIXv2AddPatStr(pRequest, pResponse, .tPatientString)
				Set tParams("v2Patients") = tPatientString
			} ElseIf $Extract(pRequest.Name,1,7)="ADT_A31" {
				Set tFile = "PIXv2_PatientRevise"
				Set tSC = ..MakePIXv2RevPatStr(pRequest, .tPatientString)
				Set tParams("v2Patients") = tPatientString
			} ElseIf $Extract(pRequest.Name,1,7)="ADT_A40" {
				Set tFile = "PIXv2_PatientMerge"
				Set tSC = ..MakePIXv2MrgPatStrs(pRequest, .tPatientString, .tPriorPatientString)
				Set tParams("v2Patients") = tPatientString
				Set tParams("v2PriorPatient") = tPriorPatientString
			}
		}
		If tFile="" $$$ThrowStatus($$$ERROR($$$GeneralError,"Unable to determine message type"))

		#; Prepare the input		
		#;  <Root><Request>...xml message...</Request><Response>...xml message..</Response><Status>...error text...</Status></Root>
		Set tSC = ..MakeInput(.tInput,pRequest,pResponse,pStatus)
		
		#; Transform request/response/status into an audit message
		Set tXSLPath = $$$FormatText("%1/%2.xsl",..#XSLRelativePath,tFile)
		Set tParams("actor") = pActor
		Set tParams("auditSource") = pAuditSource
		Set tParams("instance") = $ZU(131,1)
		Set tParams("namespace") = $Namespace
		Set tParams("pid") = $J
		Set tParams("session") = pSessionId
		Set tParams("now") = ##class(%TimeStamp).LogicalToXSD($$$timeUTC)
		Set tParams("homeCommunity") = $$$HomeCommunity
		Set tParams("homeCommunityOID") = $$$HomeCommunityOID
		Set tParams("affinityDomain") = $$$AffinityDomain
		Set tParams("affinityDomainOID") = $$$AffinityDomainOID
		Set tParams("homeCommunityOIDs") = ""
		If pActor="XCAInitiatingGateway" Set tParams("homeCommunityOIDs") = ##class(HS.IHE.Util).GetHomeCommunityOIDs()
		// XML-escape all fields before calling the XSLT transform that creates
		// the ATNA message. This will prevent the XSLT Transform from incurring
		// a fatal error. However, the output of that Transform will leave many
		// fields double-XML-escaped as they are saved to the audit database.
		// This is unavoidable, as the audit string eventually (in RecordAudit)
		// needs to be Correlated to a class, and the XML needs to be valid at
		// that point, so we cannot un-do the escaping after the XSLT call.
		Set tSub = ""
		For {
			Set tSub = $Order(tParams(tSub))
			If tSub="" Quit
			Set tParams(tSub) = $ZConvert(tParams(tSub), "O", "XML")
		}
		$$$GetTransformer(tTransformer)
		Set tSC = tTransformer.Transform(tInput, tXSLPath, .tOutput, .tParams)
		$$$ThrowOnError(tSC)
		If tOutput.Size < 15 { // using 15 protect against bonus newlines
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Audit message is empty and will not be sent: Actor="_pActor_" Request="_pRequest.Name))
		} 
		/// Look for localized changes
		Set tRegion = ##class(HS.Registry.Config).GetKeyValue("\Application\Region")
		If tRegion]"" {
			Set tFoundRegional=0
			For tCustom = "","Custom" {
				Set tXSLPath = $$$FormatText("%1/%2.xsl",..#XSLRelativePath_tCustom,tRegion_"_"_tFile)
				IF $ZSE(##class(%File).NormalizeFilename(tTransformer.XSLTDirectory_tXSLPath))]"" {
					Set tFoundRegional=1
					Quit
				}
			}
			If tFoundRegional {
				Set tXSLPath = $$$FormatText("%1/%2.xsl",..#XSLRelativePath,tRegion_"_"_tFile)
				Do ..MakeInput(.tInput,pRequest,pResponse,pStatus,tOutput)
				Set tOutput=""
				Set tSC = tTransformer.Transform(tInput, tXSLPath, .tOutput, .tParams)
				$$$ThrowOnError(tSC)
				Do tOutput.Rewind()
			}
		}
		Set tOutputString = tOutput.Read(tOutput.Size)
		#; Save to audit request queue
		For i=1:1:$L(tOutputString,"</Aggregation>") { // for each Aggregation
			Set tAuditString = $ZStrip($P(tOutputString,"</Aggregation>",i),"<>W",$C(13,10))
			If tAuditString ] "" {
				Set tAuditString=tAuditString_"</Aggregation>"
				Set tSC=##class(HS.IHE.ATNA.Repository.Aggregation).RecordAudit(,tAuditString)
				Quit:$$$ISERR(tSC)
				Set:pUnitTest pAuditMessages($i(pAuditMessages))=tAuditString
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

ClassMethod MakeInput(Output pInput, pRequest, pResponse, pStatus, pCurrentOutput = "")
{
	Set pInput = ##class(%Stream.GlobalCharacter).%New()
	Set tSC = pInput.Write("<Root>") $$$ThrowOnError(tSC)
	If ..IsXMLMessage(pRequest) {
		Set tSC = ..XMLExportToStreamWithoutAttachments(pRequest,pInput,"Request") $$$ThrowOnError(tSC)
	}
	If ..IsXMLMessage(pResponse) {
		Set tSC = ..XMLExportToStreamWithoutAttachments(pResponse,pInput,"Response") $$$ThrowOnError(tSC)
	}
	If $IsObject(pCurrentOutput) {
		Do pCurrentOutput.Rewind()
		Do pInput.CopyFrom(pCurrentOutput)
	}

	If $$$ISERR(pStatus) {
		Set tSC = pInput.Write("<Status>"_$ZCVT($SYSTEM.Status.GetErrorText(pStatus),"O","XML")_"</Status>") $$$ThrowOnError(tSC)
	}
	Set tSC = pInput.Write("</Root>")
	If $IsObject(pCurrentOutput) {
		Do pInput.Rewind()
	}
	Quit tSC
}

ClassMethod MakePDQv2PatStr(pHL7Response As EnsLib.HL7.Message, Output pPatientString As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pPatientString = ""
	
	Try {
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(##class(HS.IHE.Util).GetAffinityDomain(),"")
		
		#; Build match collection
		For i = 1:1:pHL7Response.GetValueAt("PIDgrp(*)") {
			Set tIdentifier = ""
			Set tFirstIdentifier = ""
			Set tAssigningAuthorityOID = ""
			Set tFirstAssigningAuthorityOID = ""
			Set tMPIID = ""
			For j = 1:1:pHL7Response.GetValueAt("PIDgrp("_i_").PID:3(*)") {
				Set tIdentifier = pHL7Response.GetValueAt("PIDgrp("_i_").PID:3("_j_").1")
				Set tAssigningAuthorityOID = pHL7Response.GetValueAt("PIDgrp("_i_").PID:3("_j_").4.2")
				If j=1 Set tFirstIdentifier = tIdentifier Set tFirstAssigningAuthorityOID = tAssigningAuthorityOID
				If tAssigningAuthorityOID=tAffinityDomainOID Set tMPIID = tIdentifier Quit
			}
			If tFirstIdentifier="" Quit
			
			If tMPIID="",tFirstIdentifier'="" Set tMPIID=tFirstIdentfier,tAssigningAuthorityOID=tFirstAssigningAuthorityOID
			
			Set tLastName = pHL7Response.GetValueAt("PIDgrp("_i_").PID:5.1.1")
			Set tFirstName = pHL7Response.GetValueAt("PIDgrp("_i_").PID:5.2")
			Set tMiddleName = pHL7Response.GetValueAt("PIDgrp("_i_").PID:5.3")
			
			Set pPatientString = pPatientString_"|"
			Set pPatientString = pPatientString_tMPIID_"^^^&"_tAssigningAuthorityOID_"&ISO"
			Set pPatientString = pPatientString_"~"
			Set pPatientString = pPatientString_"^"_tLastName_"^"_tFirstName
			Set pPatientString = pPatientString_"|"
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

ClassMethod MakePIXv2QueryPatStr(pHL7Response As EnsLib.HL7.Message, Output pPatientString As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pPatientString = ""
	
	Try {
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(##class(HS.IHE.Util).GetAffinityDomain(),"")
		Set tIdentifier = ""
		Set tFirstIdentifier = ""
		Set tAssigningAuthorityOID = ""
		Set tFirstAssigningAuthorityOID = ""
		Set tMPIID = ""
		
		For j = 1:1:pHL7Response.GetValueAt("PID:3(*)") {
			Set tIdentifier = pHL7Response.GetValueAt("PID:3("_j_").1")
			Set tAssigningAuthorityOID = pHL7Response.GetValueAt("PID:3("_j_").4.2")
			If j=1 Set tFirstIdentifier = tIdentifier Set tFirstAssigningAuthorityOID = tAssigningAuthorityOID
			If tAssigningAuthorityOID=tAffinityDomainOID Set tMPIID = tIdentifier Quit
		}
		If tFirstIdentifier="" Quit
		
		If tMPIID="",tFirstIdentifier'="" Set tMPIID=tFirstIdentfier,tAssigningAuthorityOID=tFirstAssigningAuthorityOID
		
		Set tLastName = pHL7Response.GetValueAt("PID:5.1.1")
		Set tFirstName = pHL7Response.GetValueAt("PID:5.2")
		Set tMiddleName = pHL7Response.GetValueAt("PID:5.3")
		
		Set pPatientString = pPatientString_"|"
		Set pPatientString = pPatientString_tMPIID_"^^^&"_tAssigningAuthorityOID_"&ISO"
		Set pPatientString = pPatientString_"~"
		Set pPatientString = pPatientString_"^"_tLastName_"^"_tFirstName
		Set pPatientString = pPatientString_"|"
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

ClassMethod MakePIXv2AddPatStr(pHL7Request As EnsLib.HL7.Message, pHL7Response As EnsLib.HL7.Message, Output pPatientString As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pPatientString = ""
	
	Try {
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(##class(HS.IHE.Util).GetAffinityDomain(),"")
		
		Set tMPIID = pHL7Response.GetValueAt("MSA:3")
		Set tAssigningAuthorityOID = tAffinityDomainOID
		
		Set tLastName = pHL7Request.GetValueAt("PID:5.1.1")
		Set tFirstName = pHL7Request.GetValueAt("PID:5.2")
		Set tMiddleName = pHL7Request.GetValueAt("PID:5.3")
		
		Set pPatientString = pPatientString_"|"
		Set pPatientString = pPatientString_tMPIID_"^^^&"_tAssigningAuthorityOID_"&ISO"
		Set pPatientString = pPatientString_"~"
		Set pPatientString = pPatientString_"^"_tLastName_"^"_tFirstName
		Set pPatientString = pPatientString_"|"
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

ClassMethod MakePIXv2RevPatStr(pHL7Request As EnsLib.HL7.Message, Output pPatientString As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pPatientString = ""
	
	Try {
		Set pHL7Request.DocType = "2.5:ADT_A05"
		
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(##class(HS.IHE.Util).GetAffinityDomain(),"")
		Set tIdentifier = ""
		Set tFirstIdentifier = ""
		Set tAssigningAuthorityOID = ""
		Set tFirstAssigningAuthorityOID = ""
		Set tMPIID = ""
		
		For j = 1:1:pHL7Request.GetValueAt("PID:3(*)") {
			Set tIdentifier = pHL7Request.GetValueAt("PID:3("_j_").1")
			Set tAssigningAuthorityOID = pHL7Request.GetValueAt("PID:3("_j_").4.2")
			If j=1 Set tFirstIdentifier = tIdentifier Set tFirstAssigningAuthorityOID = tAssigningAuthorityOID
			If tAssigningAuthorityOID=tAffinityDomainOID Set tMPIID = tIdentifier Quit
		}
		If tFirstIdentifier="" Quit
		
		If tMPIID="",tFirstIdentifier'="" Set tMPIID=tFirstIdentfier,tAssigningAuthorityOID=tFirstAssigningAuthorityOID		
		Set tLastName = pHL7Request.GetValueAt("PID:5.1.1")
		Set tFirstName = pHL7Request.GetValueAt("PID:5.2")
		Set tMiddleName = pHL7Request.GetValueAt("PID:5.3")
		
		Set pPatientString = pPatientString_"|"
		Set pPatientString = pPatientString_tMPIID_"^^^&"_tAssigningAuthorityOID_"&ISO"
		Set pPatientString = pPatientString_"~"
		Set pPatientString = pPatientString_"^"_tLastName_"^"_tFirstName
		Set pPatientString = pPatientString_"|"
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

ClassMethod MakePIXv2MrgPatStrs(pHL7Request As EnsLib.HL7.Message, Output pPatientString As %String, Output pPriorPatientString) As %Status
{
	Set tSC = $$$OK
	
	Set pPatientString = ""
	Set pPriorPatientString = ""
	
	Try {
		Set pHL7Request.DocType = "2.5:ADT_A39"
		
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(##class(HS.IHE.Util).GetAffinityDomain(),"")
		
		Set tIdentifier = pHL7Request.GetValueAt("PIDgrp(1).PID:3(1).1")
		Set tAssigningAuthorityOID = pHL7Request.GetValueAt("PIDgrp(1).PID:3(1).4.2")
		
		Set tLastName = pHL7Request.GetValueAt("PIDgrp(1).PID:5.1.1")
		Set tFirstName = pHL7Request.GetValueAt("PIDgrp(1).PID:5.2")
		Set tMiddleName = pHL7Request.GetValueAt("PIDgrp(1).PID:5.3")
		
		Set pPatientString = pPatientString_"|"
		Set pPatientString = pPatientString_tIdentifier_"^^^&"_tAssigningAuthorityOID_"&ISO"
		Set pPatientString = pPatientString_"~"
		Set pPatientString = pPatientString_"^"_tLastName_"^"_tFirstName
		Set pPatientString = pPatientString_"|"
		
		Set tIdentifier = pHL7Request.GetValueAt("PIDgrp(1).MRG:4(1).1")
		Set tAssigningAuthorityOID = pHL7Request.GetValueAt("PIDgrp(1).MRG:4(1).4.2")
		
		Set tLastName = pHL7Request.GetValueAt("PIDgrp(1).MRG:7.1.1")
		Set tFirstName = pHL7Request.GetValueAt("PIDgrp(1).MRG:7.2")
		Set tMiddleName = pHL7Request.GetValueAt("PIDgrp(1).MRG:7.3")
		
		Set pPriorPatientString = pPriorPatientString_"|"
		Set pPriorPatientString = pPriorPatientString_tIdentifier_"^^^&"_tAssigningAuthorityOID_"&ISO"
		Set pPriorPatientString = pPriorPatientString_"~"
		Set pPriorPatientString = pPriorPatientString_"^"_tLastName_"^"_tFirstName
		Set pPriorPatientString = pPriorPatientString_"|"
		
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

}
