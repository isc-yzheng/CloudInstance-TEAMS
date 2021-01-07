/// 
Class HS.IHE.Common.Services.SOAPServer.Base Extends (HS.HC.Util.Trace.Helper, EnsLib.SOAP.Service) [ Inheritance = right ]
{

Parameter MUSTUNDERSTANDACTION As %Boolean = 1;

Parameter XMLIGNOREINVALIDTAG As BOOLEAN [ Internal ] = 1;

Parameter WSADDRESSING = "OFF";

Parameter ADAPTER;

Parameter SECURITYIN = "allow";

Parameter SETTINGS = "ResourceRequired,UserMaximumRequests,UserInterval,UserIntervalUnits,IPAddressMaximumRequests,IPAddressInterval,IPAddressIntervalUnits,SAMLProcessor,OrgURLAttributeCode,UseSAMLUserName,RequireValidSAMLToken,InvalidTokenLogging,XMLValidator,AdditionalSecurityClass";

/// If specified, then users of this web service must have this resource.
Property ResourceRequired As %String;

/// Indicate the maximum number of user requests supported.
/// A value less than 1 (including an empty value) disables user-based enforcement.
Property UserMaximumRequests As %Integer;

/// Indicate the rolling time period for which maximum requests by user should be counted (defaults to 'Hour' if unspecified).
Property UserInterval As %String(DISPLAYLIST = ",Second,Minute,Hour,Day,Week,Month,Year", VALUELIST = ",ss,mi,hh,dd,wk,mm,yy");

/// Indicate the number of units for the selected user enforcement interval.
Property UserIntervalUnits As %Integer [ InitialExpression = 1 ];

/// Indicate the maximum number of IP-based requests supported.
/// A value less than 1 (including an empty value) disables IP-based enforcement.
Property IPAddressMaximumRequests As %Integer;

/// Indicate the rolling time period for which maximum requests by IP should be counted (defaults to 'Hour' if unspecified).
Property IPAddressInterval As %String(DISPLAYLIST = ",Second,Minute,Hour,Day,Week,Month,Year", VALUELIST = ",ss,mi,hh,dd,wk,mm,yy");

/// Indicate the number of units for the selected IP enforcement interval.
Property IPAddressIntervalUnits As %Integer [ InitialExpression = 1 ];

/// Class to process incoming SAML tokens. This class should extend HS.HC.IHE.XUA.Processor or deprecated HS.CHIxP.SAML.SAMLProcessor.
Property SAMLProcessor As %Dictionary.Classname;

/// SAML Processing: For obscure use cases where the organization(-id) attribute name is not "urn:oasis:names:tc:xspa:1.0:subject:organization-id"
/// Use Class:Method to locate the OrganizationOID or URL from the assertion [equivalent to organization = ##class(Class).Method(pAssertion)]
/// Example Value  HS.IHE.XUA.SHINNY.Processor:GetOrganizationID
Property OrgURLAttributeCode As %String;

/// If this class is receiving and processing SAML Assertions, this flag controls whether
/// the class should use the "UserName" property retrieved from the SAML Assertion for auditing
/// purposes. The default is true, but in some cases the value of $Username may be preferred.
Property UseSAMLUserName As %Boolean [ InitialExpression = 1 ];

/// If this class is receiving and processing SAML Assertions (where a SAMLProcessor is defined), this flag controls whether
/// a SAML token which fails to pass validation in the ValidateSAML() method of the specified SAMLProcessor
/// will still be processed. The default is true, meaning that a failure here will throw a SOAP fault.  Without a SAMLProcessor defined, this setting does nothing.
Property RequireValidSAMLToken As %Boolean [ InitialExpression = 1 ];

/// This setting controls the log level used to log information about
/// validation failures. The default setting is Warning.
Property InvalidTokenLogging As %String(VALUELIST = ",None,Trace,Info,Warning") [ InitialExpression = "Warning" ];

/// Property to contain the results returned from the call to <..MessageXUAProcessor>:ProcessSAML() call.
Property SAMLData As HS.IHE.XUA.SAMLData [ Private, Transient ];

Property processErrorStatus As %Boolean [ InitialExpression = 1, Internal ];

/// whether request is specified as asynchronous
Property isAsync As %Boolean [ InitialExpression = 0, Internal ];

/// Class to perform xsd validation on request / response
Property XMLValidator As %Dictionary.Classname;

/// If the service is interested in stopping based on the XML validation response, it can review XMLValidatorResponse results (of type HS.Util.XML.Validator)
Property XMLValidatorResponse As %Dictionary.Classname;

/// SAML processor to be used for this messsage (based on GetSAMLProcessor and DEFAULT)
Property MessageXUAProcessor As HS.HC.IHE.XUA.Processor;

/// Class to perform additional security validation
/// Specific callbacks include
/// 		PreProcessor(pService as HS.IHE.Common.Services.SOAPServer.Base,ByRef pFault) as %Status
/// 			this method allows custom validation to cause a soap fault on the service
/// 		ReturnFault(fault As %SOAP.Fault, pService As HS.IHE.Common.Services.SOAPServer.Base)
/// 				This method allows the additional user code to be added during a return fault call
Property AdditionalSecurityClass As %Dictionary.Classname;

Method ProcessBodyNode(pAction As %String = "", pNodeBody As %XML.Node, ByRef pResponseBody As %CharacterStream = {$$$NULLOREF}) As %Boolean [ ServerOnly = 1 ]
{
	#dim eProcessBodyNode As %Exception.AbstractException
	Do ..OnPreWebMethod()
	
	Try {
		Set tReturnValue = 1,tFaultReturned=0
		Set tSC = $$$OK

		If ..AdditionalSecurityClass]"" {
			try {
				Set tSC = $classMethod(..AdditionalSecurityClass,"PreProcessor",$this,.tFault)
				If $IsObject($G(tFault)) Do ..ReturnFault(tFault,$this) 
			} catch ex {
				Set tSC = ex.AsStatus()
				Set tFaultReturned=1
			}
			If $$$ISERR(tSC) Quit
		}
		
	
		#dim tWriter as %XML.Writer

		Set tRequestBody = ##class(%Stream.GlobalCharacter).%New()
		Set tWriter = ##class(%XML.Writer).%New()
		
		Do tWriter.OutputToStream(tRequestBody)
		If $$$ISERR(tWriter.Canonicalize(pNodeBody,,1)) Set tReturnValue = 0 Quit

		Set pAction = $Translate(pAction, """", "")

		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set:..SAMLData.%Extends("HS.IHE.XUA.SAMLData") tRequest.SAMLData=..SAMLData
		Do tRequest.AdditionalInfo.SetAt(pAction, "SOAPAction")
		Do tRequest.AdditionalInfo.SetAt(%request.CgiEnvs("REMOTE_ADDR"), "WSA:From")
		If ..AddressingIn.SourceEndpoint.Address'="" Do tRequest.AdditionalInfo.SetAt(..AddressingIn.SourceEndpoint.Address, "WSA:From")
		If ..AddressingIn.Destination'="" Do tRequest.AdditionalInfo.SetAt(..AddressingIn.Destination, "WSA:To")
		Set tReplyTo=..AddressingIn.ReplyEndpoint.Address
		if tReplyTo]"" && (tReplyTo'["anonymous") {
			Do tRequest.AdditionalInfo.SetAt(..AddressingIn.MessageId, "RelatesTo")
			Do tRequest.AdditionalInfo.SetAt(tReplyTo, "ReplyAddress")
			Set ..isAsync=1
			Do ..ReturnOneWay()
		}

		$$$ThrowOnError(..InsertAttachements(tRequest,pAction))
		
		#; define user and roles which may be overridden by SAML later
		Do tRequest.AdditionalInfo.SetAt($username,"USER:UserID")
		Do tRequest.AdditionalInfo.SetAt($roles,"USER:Roles")
		
		Do tRequest.ContentStream.CopyFrom(tRequestBody)
		#; required to support older version / new code is a no-op
		If ($IsObject(..SAMLData))&&(..SAMLData.SAMLInfo.Count()) Do ..SAMLData.CopySAMLInfoToXMLMessage(tRequest)
		
		// Callback for processing data in the request
		If $isObject(..MessageXUAProcessor) {
			Set tSC = $method(..MessageXUAProcessor, "ProcessRequest", tRequest)
			If $$$ISERR(tSC) {
				Set tSAMLAssertion = $select($IsObject(..SecurityIn): ..SecurityIn.FindElement("Assertion"), 1: $$$NULLOREF)
				If $isObject(tSAMLAssertion) {
					Do tSAMLAssertion.XMLExportToString(.tSAMLXML)
					$$$HSTRACEERROR("Assertion Error","MessageXUAProcessor,tSC,tRequest,Assertion",$S($isObject(..MessageXUAProcessor):..MessageXUAProcessor.%ClassName(1),1:..MessageXUAProcessor),tSC,tRequest,tSAMLXML)
					Do:$case(..InvalidTokenLogging, "Trace":1, "Info": 1, "Warning":1, :0) $classmethod("Ens.Util.Log","Log"_..InvalidTokenLogging, $$$CurrentClass, $$$CurrentMethod, "Error processing request:"_tSAMLXML)
				}
			}
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		$$$HSTRACEMIN("Service","RequestContent",tRequest)
		Set tSC = ..ProcessInput(tRequest, .tResponse)
		$$$HSTRACEMIN("Service","ResponseContent",tResponse)
		Set tID=..%RequestHeaderGetObjectId(),tIP=%request.CgiEnvs("REMOTE_ADDR")_" (Source IP)"
		&sql(update ens.messageheader set description=:tIP where ID=:tID)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		#; possible that it is one-way and there is no response
		If $IsObject(tResponse) {Do pResponseBody.CopyFrom(tResponse.ContentStream)}
	}
	Catch eProcessBodyNode {
		Set tReturnValue = 1
		Set tSC = eProcessBodyNode.AsStatus()
		$$$LOGERROR("Error: "_$$$StatusDisplayString(tSC))
	}
	
	#; Give service chance to cleanup before processing fault (e.g. remove temp files)
	Try {
		$$$ThrowOnError(..OnFinalizeProcessBodyNode(.tRequest,.tResponse,tSC))
	}
	Catch ex {
		#; log the error but don't override original status
		$$$LOGSTATUS(ex.AsStatus())
	}
	
	If $isObject($G(tResponse)) && tResponse.%IsA("HS.Message.XMLMessage") && (tResponse.SOAPFault]"") {
		If ..SoapVersion="1.2" {
			If $isObject(tResponse.SOAPFault) {Set tFault = tResponse.SOAPFault}
			Else {Set tFault = ..MakeFault12($$$FAULTReceiver,$li(tResponse.SOAPFault,1),$li(tResponse.SOAPFault,2))}
		} Else {
			If $isObject(tResponse.SOAPFault) { Set tFault = tResponse.SOAPFault}
			Else {Set tFault = ..MakeFault($$$FAULTServer,$li(tResponse.SOAPFault,1),$li(tResponse.SOAPFault,2))}
		}
		Do ..ReturnFault(tFault,$this)
	}
	If tFaultReturned Zt "SOAP"
	If ($$$ISERR(tSC)&&..processErrorStatus) Do ..ReturnFault(..MakeStatusFault(,,tSC),$this)
	Quit tReturnValue
}

ClassMethod ReturnFault(fault As %SOAP.Fault, pService As HS.IHE.Common.Services.SOAPServer.Base = {$g(%cspsoapservice)}) [ ServerOnly = 1 ]
{
	If pService.AdditionalSecurityClass]"" {
		try {
			do $classMethod(pService.AdditionalSecurityClass,"ReturnFault",fault,pService)
		} catch {}
	}
	Do ##super(fault)
}

/// Set the relatesto (which inbound message) and the response action
Method SetAddressingOut(pAction)
{
	try {
		Set tSC=$$$OK
		Set ..AddressingOut = ##class(%SOAP.Addressing.Properties).GetDefaultResponseProperties(..AddressingIn,pAction)
		Set tRelatesToID = ..AddressingIn.MessageId
		If tRelatesToID]"" {
			Set tRelatesTo=##class(%SOAP.Addressing.RelatesTo).%New()
			Set tRelatesTo.RelatesTo=tRelatesToID
			Set ..AddressingOut.Relationship=tRelatesTo
		}
		Set:..#MUSTUNDERSTANDACTION&&('$D(..AddressingOut.mustUnderstand("Action"))) ..AddressingOut.mustUnderstand("Action")=..#MUSTUNDERSTANDACTION
	} catch ex {
		Set tSC = ex.AsStatus()
	} 
	Quit tSC
}

Method OnPreWebMethod() [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	Set tSAMLError = ""
	
	Try {
		Set tSC = ..EnforceServiceUsage()
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		Set tSAMLAssertion = $select($IsObject(..SecurityIn): ..SecurityIn.FindElement("Assertion"), 1: $$$NULLOREF)
		Set tSC = ..GetSAMLProcessor(tSAMLAssertion) 
		If $$$ISERR(tSC) $$$HSTRACEERROR("Failed to get Processor","Assertion,tSC",tSAMLAssertion,tSC) $$$ThrowOnError(tSC)
		Set ..SAMLData = $$$NULLOREF
		
		If $isObject(..MessageXUAProcessor) {
			// Note this only finds the *FIRST* SAML Assertion
			If ..MessageXUAProcessor.%Extends("HS.HC.IHE.XUA.Processor") {
				Set tOK=$method(..MessageXUAProcessor, "ValidateSAML", tSAMLAssertion, .tReason,..ImportHandler,.tSAMLData)
			} Else {
				Set tOK=$method(..MessageXUAProcessor, "ValidateSAML", tSAMLAssertion, .tReason)
			}
			If 'tOK {
				$$$HSTRACEERROR("Assertion failed validation","MessageXUAProcessor,Assertion,tReason",$S($isObject(..MessageXUAProcessor):..MessageXUAProcessor.%ClassName(1),1:..MessageXUAProcessor),tSAMLAssertion,tReason)
				If $case(..InvalidTokenLogging, "Trace":1, "Info": 1, "Warning":1, :0) {
					Do $classmethod("Ens.Util.Log","Log"_..InvalidTokenLogging, $$$CurrentClass, $$$CurrentMethod, "SAML token"_$S(..RequireValidSAMLToken:"",1:" accepted despite")_" validation failure: "_tReason)
					If $isObject(tSAMLAssertion) {
						Do tSAMLAssertion.XMLExportToString(.tSAMLXML)
					} Else {
						Set tSAMLXML = "(No SAML Assertion)"
					}
						Do $classmethod("Ens.Util.Log","Log"_..InvalidTokenLogging, $$$CurrentClass, $$$CurrentMethod, tSAMLXML)
				}
				If ..RequireValidSAMLToken {
					Set tSAMLError = tReason
					Quit
				} 
			}
			Set tSC = $method(..MessageXUAProcessor, "ProcessSAML", tSAMLAssertion, .tSAMLData)
			If $$$ISERR(tSC) {
				$$$HSTRACEERROR("Assertion failed processing","tSC,MessageXUAProcessor,Assertion",tSC,$S($isObject(..MessageXUAProcessor):..MessageXUAProcessor.%ClassName(1),1:..MessageXUAProcessor),tSAMLAssertion)
				If $case(..InvalidTokenLogging, "Trace":1, "Info": 1, "Warning":1, :0) {
					If $isObject(tSAMLAssertion) {
						Do tSAMLAssertion.XMLExportToString(.tSAMLXML)
					} Else {
						Set tSAMLXML = "(No SAML Assertion)"
					}
					Do $classmethod("Ens.Util.Log","Log"_..InvalidTokenLogging, $$$CurrentClass, $$$CurrentMethod, "SAML token"_$S(..RequireValidSAMLToken:"",1:" accepted despite")_" validation failure: "_tReason)
					Do $classmethod("Ens.Util.Log","Log"_..InvalidTokenLogging, $$$CurrentClass, $$$CurrentMethod, tSAMLXML)
				}
				
				Set tSAMLError = "General Processing Error"
			}
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Set ..SAMLData = tSAMLData
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
		// If some unhandled error happens and a valid SAMLToken is required, Mark as a SAML Error to ensure we don't accidentally let them in
		If ..RequireValidSAMLToken {
			Set tSAMLError = "General Processing Error"
		}
	}
	If tSAMLError '= "" {
		$$$LOGERROR("SAML Validation failure: "_tSAMLError)
		If tSAMLError="NO TOKEN" || (tSAMLError = "NO ASSERTION") {
			Set tFault = ..MakeSecurityFault("SecurityTokenUnavailable")
		}
		Else {
			Set tFault = ..MakeSecurityFault("InvalidSecurityToken")
		}
		Set tFault.detail = tSAMLError
		Set tFault.faultPrefixDefinition = tFault.faultPrefixDefinition _ " xmlns:saml2="""_$$$SAMLns_""""
		Do ..ReturnFault(tFault,$this)
	} ElseIf ..ResourceRequired'=""&&'$SYSTEM.Security.Check(..ResourceRequired,"USE") {
		$$$LOGERROR("Resource Error")
		Set tFault = ..MakeSecurityFault("FailedAuthentication")
		Do ..ReturnFault(tFault,$this)
	}
	Quit
}

Method GetSAMLProcessor(pSAMLAssertion) As %Status
{
	try {
		Set ..MessageXUAProcessor=$$$NULLOREF
		Set tSC=$$$OK
		If $ISObject(pSAMLAssertion) {
			Set (tUserOrganizationID,tUserOrganization)=""
			For tIdx=1:1:pSAMLAssertion.Statement.Count() {
				Set tStatement = pSAMLAssertion.Statement.GetAt(tIdx)
				If '$IsObject(tStatement) Continue
				If 'tStatement.%IsA("%SAML.AttributeStatement") Continue
				For tIdx2=1:1:tStatement.Attribute.Count() {
					Set tAttribute = tStatement.Attribute.GetAt(tIdx2)
					If '$IsObject(tAttribute) Continue

					Set tAttributeValue = tAttribute.AttributeValue.GetAt(1)
					If '$IsObject(tAttributeValue) Continue

					Set tName = tAttribute.Name
					If tName="urn:oasis:names:tc:xspa:1.0:subject:organization-id" Set:tUserOrganizationID="" tUserOrganizationID = tAttributeValue.GetString() 
					If tName="urn:oasis:names:tc:xspa:1.0:subject:organization" Set:tUserOrganization="" tUserOrganization = tAttributeValue.GetString() 
					#; specific to SHIN-NY
					If tName="UserOrganizationOID" Set:tUserOrganizationID="" tUserOrganizationID = tAttributeValue.GetString() 
					
				}
			}
			If tUserOrganization="" && (tUserOrganizationID="") && (..OrgURLAttributeCode]"") {
				Set tClass=$p(..OrgURLAttributeCode,":"),tMethod=$p(..OrgURLAttributeCode,":",2)
				If tClass]"",tMethod]"" Set tUserOrganizationID=$classmethod(tClass,tMethod,pSAMLAssertion)
				$$$HSTRACE("organization id secondary lookup:"_tUserOrganizationID)
			}
			#; use organization ID (maybe an oid or url) or try the name
			For tOrganization = tUserOrganizationID,tUserOrganization {
				Continue:tOrganization=""
				Set ..MessageXUAProcessor = ##class(HS.IHE.XUA.Config).GetProcessor(tOrganization) 
				Quit:$isObject(..MessageXUAProcessor)
			}
		}
		If '$IsObject(..MessageXUAProcessor) && (..SAMLProcessor]"") {
			Set ..MessageXUAProcessor=$classMethod(..SAMLProcessor,"%New")
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	} 
	Quit tSC
}

/// Prevent "denial of service" or similar attacks against a web service.
/// Allow user-defined thresholds based on requesting IP address and/or user name to be defined.
/// Note that if the "UserName" key of ..SAMLData.SAMLInfo is populated, this value will be
/// used as the username for the incoming user.
Method EnforceServiceUsage() As %Status [ Private ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK

	Try {
		If ..UserInterval = ""	Set ..UserInterval = "hh"
		If ..IPAddressInterval = "" Set ..IPAddressInterval = "hh"
		
		Set tIPAddress		= %request.CgiEnvs("REMOTE_ADDR")
		Set tUserName		= $USERNAME
		Set tDateTime		= $ZDateTime($Horolog, 3)
		Set tServiceName	= ..%ConfigName
		Set tRequestDenied	= 0
		
		If ..UseSAMLUserName && $IsObject(..SAMLData) {
			If ..SAMLData.%IsA("HS.CHIxP.SAML.SAMLData") {
				Set:..SAMLData.SAMLInfo.GetAt("UserName")]"" tUserName = ..SAMLData.SAMLInfo.GetAt("UserName")
			} Else {
				Set:..SAMLData.UserName]"" tUserName=..SAMLData.UserName
			}
		}
		
		If (..UserMaximumRequests > 0) {
			Set tSQL = "Select count(*) As UserCount From HS_IHE_Common_Services_SOAPServer.RequestLog Where (ServiceName = ?) And (UserName = ?) And (DATEDIFF('" _ ..UserInterval _ "', RequestDateTime, CURRENT_TIMESTAMP) <= ?)"
			Set tResultSet = ##class(%ResultSet).%New("%DynamicQuery:SQL")
			Set tSC = tResultSet.Prepare(tSQL) Quit:$$$ISERR(tSC)
			Set tSC = tResultSet.Execute(tServiceName, tUserName, ..UserIntervalUnits) Quit:$$$ISERR(tSC)
			
			Set tUserCount = $Case(tResultSet.Next(), 1:tResultSet.Get("UserCount"), :0)
			
			If (tUserCount >= ..UserMaximumRequests) {
				Set tRequestDenied = 1
				Set tUserFaultDescription = "Maximum requests from user '" _ tUserName _ "' reached:  [no more than " _ ..UserMaximumRequests _ " request(s) allowed per " _ ..UserIntervalUnits _ " " _ ..UserIntervalLogicalToDisplay(..UserInterval) _ "(s)]"
			}
		}
		If (..IPAddressMaximumRequests > 0) {
			Set tSQL = "Select count(*) As IPAddressCount From HS_IHE_Common_Services_SOAPServer.RequestLog Where (ServiceName = ?) And (IPAddress = ?) And (DATEDIFF('" _ ..IPAddressInterval _ "', RequestDateTime, CURRENT_TIMESTAMP) <= ?)"
			Set tResultSet = ##class(%ResultSet).%New("%DynamicQuery:SQL")
			Set tSC = tResultSet.Prepare(tSQL) Quit:$$$ISERR(tSC)
			Set tSC = tResultSet.Execute(tServiceName, tIPAddress, ..IPAddressIntervalUnits) Quit:$$$ISERR(tSC)
			
			Set tIPAddressCount = $Case(tResultSet.Next(), 1:tResultSet.Get("IPAddressCount"), :0)
			
			If (tIPAddressCount >= ..IPAddressMaximumRequests) {
				Set tRequestDenied = 1
				Set tIPAddressFaultDescription = "Maximum requests from IP address '" _ tIPAddress _ "' reached:  [no more than " _ ..IPAddressMaximumRequests _ " request(s) allowed per " _ ..IPAddressIntervalUnits _ " " _ ..IPAddressIntervalLogicalToDisplay(..IPAddressInterval) _ "(s)]"
			}
		}

		&sql(
			Insert Into HS_IHE_Common_Services_SOAPServer.RequestLog (
				ServiceName, UserName, IPAddress, RequestDateTime, RequestDenied
			)
			Values(
				:tServiceName, :tUserName, :tIPAddress, :tDateTime, :tRequestDenied
			)
		)

		If +tRequestDenied {
			Set tSC = $$$EnsError($Get(tUserFaultDescription) _ $Case($Data(tIPAddressFaultDescription), 1:", " _ tIPAddressFaultDescription, :""))
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ValidateMessage(pRequest = "", pAction = "", pType = "") [ ForceGenerate ]
{
	try {
		If ..XMLValidator]"" {
			Set ..XMLValidatorResponse = $classMethod(..XMLValidator,"Validate",pRequest,pAction,..GetSchema(pAction))
			Set tString = ..SchemaErrorString()
			if tString]"" {
				$$$LOGERROR("Problem validating "_$s(pType="":"",1:pType_" ")_"message "_tString)
			}
			If $IsObject(..XMLValidatorResponse),..XMLValidatorResponse.%Extends("%XML.Adaptor") $$$HSTRACE("Validation Result","..XMLValidatorResponse",..XMLValidatorResponse)
			
}
	} catch ex {
		$$$LOGSTATUS(ex.AsStatus())
	}
}

Method SchemaErrorString() As %String
{
	If '$IsObject(..XMLValidatorResponse) Quit ""
	Set tString=""
	If ..XMLValidatorResponse.Errors.Count() {
		For tIdx = 1:1:..XMLValidatorResponse.Errors.Count() {
			Set:tString]"" tString=tString_$c(13,10)
			Set tString=tString_..XMLValidatorResponse.Errors.GetAt(tIdx)
		}
	}
	Quit tString
}

/// Report the number of errors from schema validation (zero if no validation has been run)
Method SchemaErrorCount() As %Integer
{
	If '$IsObject(..XMLValidatorResponse) Quit 0
	Quit ..XMLValidatorResponse.Errors.Count()
}

/// Ensure that the ..SAMLProcessor class exists and extends HS.HC.IHE.XUA.Processor or deprecated HS.CHIxP.SAML.SAMLProcessor
Method OnInit() As %Status
{
	If ..SAMLProcessor '= "" {
		If '##class(%Dictionary.CompiledClass).%ExistsId(..SAMLProcessor) {
			Quit $$$ERROR($$$ClassDoesNotExist, ..SAMLProcessor)
		}
		If ..SAMLProcessor="HS.IHE.XUA.Processor" || ..SAMLProcessor="HS.HC.IHE.XUA.Processor" Quit $$$OK
		If ('##class(%Dictionary.CompiledMethod).%ExistsId(..SAMLProcessor_"||%Extends")) || (('$classmethod(..SAMLProcessor, "%Extends", "HS.CHIxP.SAML.SAMLProcessor")) && ('$classmethod(..SAMLProcessor, "%Extends", "HS.CHIxP.SAML.SAMLProcessor")) && ('$classmethod(..SAMLProcessor, "%Extends", "HS.HC.IHE.XUA.Processor"))) {
			Quit $$$ERROR($$$EnsErrGeneral, ..SAMLProcessor_" does not extend HS.HC.IHE.XUA.Processor")
		}
	}
	Quit $$$OK
}

/// Copy SOAP attachments into request StreamCollection
Method InsertAttachements(pRequest As HS.Message.XMLMessage, pAction As %String) As %Status
{
	#dim tMIME As %Net.MIMEPart
	#dim tAtt  As HS.IHE.Common.Messages.MIMEAttachment
	Set tSC = $$$OK
	Try {
		Set i="" For { Set tMIME = ..Attachments.GetNext(.i) Quit:i=""
			Set tAtt = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
			Set tAtt.ContentId = tMIME.ContentId
			Set tAtt.ContentTransferEncoding = tMIME.ContentTransferEncoding
			Set tAtt.ContentType = tMIME.ContentType
			$$$ThrowOnError(..OnSetAttachmentBody(pAction,tMIME,tAtt))
			$$$ThrowOnError(pRequest.StreamCollection.Insert(tAtt))
		}	
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Callback to copy MIME body into StreamCollection item body
Method OnSetAttachmentBody(pAction As %String, pFrom As %Net.MIMEPart, pTo As HS.IHE.Common.Messages.MIMEAttachment) As %Status
{
	Set pTo.Body = pFrom.Body
	Quit $$$OK
}

/// Copy response StreamCollection into SOAP attachments 
Method MoveAttachments(pResponse As HS.Message.XMLMessage) As %Status
{
	#dim tMIME As %Net.MIMEPart
	#dim tAtt  As HS.IHE.Common.Messages.MIMEAttachment
	Set tSC = $$$OK
	Try {
		Quit:'$IsObject(pResponse.StreamCollection)
		Quit:pResponse.StreamCollection.Count()<1
		Set ..IsMTOM = 1
		Set tIdx="" 
		For { 
			Set tAtt = pResponse.StreamCollection.GetNext(.tIdx) Quit:tIdx=""
			Set tMIME = ##class(%Net.MIMEPart).%New()
			Set tMIME.Body = tAtt.GetBody()
			Set tMIME.ContentId = tAtt.ContentId
			Set tMIME.ContentTransferEncoding = $S(tAtt.ContentTransferEncoding="":"binary",1:tAtt.ContentTransferEncoding)
			Set tMIME.ContentType = $S(tAtt.ContentType="":"application/octet-stream",1:tAtt.ContentType)
			Do ..ResponseAttachments.Insert(tMIME)
			If tAtt.FilePath'="" {
				// ignore failures, task will clean them up
				Do ##class(%File).Delete(tAtt.FilePath)
			}
		}
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Callback after Ensemble messaging but before processing fault
Method OnFinalizeProcessBodyNode(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage, pSC As %Status) As %Status
{
	Quit $$$OK
}

ClassMethod OnPage() As %Status [ Internal, ServerOnly = 1 ]
{
	#Dim eException As %Exception.AbstractException
	Try {
		Set tSC = $$$OK
		try {
			if (%cspsoapservice.SoapFault '= ""){
				#; at this point the %cspsoapservice is the service we called, but doesn't have the ensemble production settings 
				If ##class(Ens.Director).IsProductionRunning() {
					Set %cspsoapservice.AdditionalSecurityClass=$$$ConfigSetting(%cspsoapservice.%ClassName(1),"Host","AdditionalSecurityClass")
				}
				do ..ReturnFault(%cspsoapservice.SoapFault,$g(%cspsoapservice))
				
			}
		} Catch { Quit }
		If '($Data(%request.Data("WSDL"))||$Data(%request.Data("wsdl"))) Set tSC = ##super() Quit

		#; user looking for the WSDL
		For tClass = ..%ClassName(1),"HS.IHE.Common.Services.SOAPServer.Base" {
			Set tSC = ##class(Ens.Util.URLStream).GetURLStream("xdata://"_tClass_":WSDL",.tOrigWSDL)
			Quit:$$$ISOK(tSC)
		}
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$ObjectScriptError,"Unable to retrieve WSDL. Please report to system administrator."))
		For tClass = ..%ClassName(1),"HS.IHE.Common.Services.SOAPServer.Base"{
			Set tSC = ##class(Ens.Util.URLStream).GetURLStream("xdata://"_tClass_":ModifyWSDL",.tXSLStream)
			 Quit:$$$ISOK(tSC)
		}
		
		// WSDL Location = current server name [+ port] + URL path
		Set tPort = $Get(%request.CgiEnvs("SERVER_PORT"))
		Set tParams("URL") = "'"_$Select(%request.Secure = 1: "https://", 1:"http://")_$Get(%request.CgiEnvs("SERVER_NAME"), "localhost")_$Select(tPort '= "" : ":"_tPort, 1:"")_%request.URL_"'"
		Set tOutputWSDL = ##class(%FileCharacterStream).%New()
		Set tSC = ##class(%XML.XSLT.Transformer).TransformStream(tOrigWSDL,tXSLStream,.tOutputWSDL,,.tParams)
		
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$ObjectScriptError,"Unable to retrieve WSDL. Please report to system administrator."))
		Set tSSC = tOutputWSDL.OutputToDevice()
			
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

ClassMethod GetSchema(pAction As %String = "") As %String [ CodeMode = expression ]
{
""
}

XData ModifyWSDL
{
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	xmlns:wsntw="http://docs.oasis-open.org/wsn/bw-2"
	xmlns:wsnt="http://docs.oasis-open.org/wsn/b-2"
	xmlns:wsa="http://www.w3.org/2005/08/addressing" 
	xmlns:wsrf-rw="http://docs.oasis-open.org/wsrf/rw-2" 
	xmlns:wsrf-rlw="http://docs.oasis-open.org/wsrf/rlw-2" 
	xmlns:wsrf-rp="http://docs.oasis-open.org/wsrf/rp-2" 
	xmlns:wsrf-rpw="http://docs.oasis-open.org/wsrf/rpw-2" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
	xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/"
	version="2.0"
	>
<xsl:output indent="yes"/>
<xsl:param name="URL" />
<xsl:template match="node()|@*">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>
<xsl:template match="/wsdl:definitions/wsdl:service/wsdl:port/soap:address/@location">
	<xsl:attribute name="location"><xsl:value-of select="$URL"/></xsl:attribute>
</xsl:template>

<xsl:template match="/wsdl:definitions/wsdl:service/wsdl:port/soap12:address/@location">
	<xsl:attribute name="location"><xsl:value-of select="$URL"/></xsl:attribute>
</xsl:template>
</xsl:stylesheet>
}

XData WSDL
{
<?xml version="1.0" encoding="utf-8"?>
<definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/">WSDL is not available, please refer to ftp://ftp.ihe.net/TF_Implementation_Material/ITI/wsdl/</definitions>
}

}
