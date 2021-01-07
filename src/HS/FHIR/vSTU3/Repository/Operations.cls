Include %cspBuild

Class HS.FHIR.vSTU3.Repository.Operations Extends (Ens.BusinessOperation, HS.HC.Util.Trace.Helper)
{

Parameter SETTINGS = "StorageClass,BundleProcessorClass,OperationProcessorClass,ResourceSchemaRoot,RepositoryUtilityClass,ApplySchematronValidation,DefaultSearchPageSize,MaxSearchPageSize,MaxSearchResults,MaxConditionalDeleteResults:Basic,SearchPostProcessorClass:Basic,LoadPatientClass:Basic,ReadPostProcessorClass:Basic,";

/// Class to use for handling direct interaction with the desired data and storage model.
Property StorageClass As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Repository.Storage" ];

/// Class that provides the FHIR Bundle processing logic for this storage class.
/// The BundleProcessorClass must implement the class method "ProcessBundle".
Property BundleProcessorClass As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Repository.BundleProcessor" ];

/// Class that provides the FHIR Operation processing logic for this storage class.
/// The OperationProcessorClass must implement the class method "ProcessOperation".
Property OperationProcessorClass As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Repository.OperationProcessor" ];

/// Class package that is the root of all resource schemas for the desired data model.
Property ResourceSchemaRoot As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Model.Resource" ];

/// Class to use for various utility methods needed for repository processing.
Property RepositoryUtilityClass As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.Utils" ];

/// <b>Enabling this validation requires that Java is already installed on the host operating system.</b><br>
/// <br>
/// All incoming FHIR payloads are expected to undergo schema-based validation before being saved
/// to the repository. This setting controls whether <b>schematron</b>-based validation is also applied
/// to all FHIR payloads. Schematron-based validation comes with a significant <b>performance cost</b>.
/// Therefore, it is recommended that this setting is enabled only for testing during implementation.
Property ApplySchematronValidation As %Boolean [ InitialExpression = 0 ];

/// The search result page size to use when no _count parameter is specified on search.
Property DefaultSearchPageSize As %Integer [ InitialExpression = 10 ];

/// The maximum search result page size to prevent excessive user specified page size.
Property MaxSearchPageSize As %Integer [ InitialExpression = 100 ];

/// The maximum number of resources that can be selected by a search before
/// the server will simply respond to the query with an error. This number does
/// not include resources included via an _include parameter, only resources
/// selected by the actual search. This value does not affect the size of pages
/// returned by a search. The reason for not setting this value arbitrarily
/// high is because overly broad searches that select large numbers of
/// resources take a lot of system resources to fulfill, and are probably more
/// broad than the client actually needs. In this case, the client should
/// narrow their search.
Property MaxSearchResults As %Integer [ InitialExpression = 20000 ];

/// Collection of Conformance/CapabilityStatement resources as %XML.XPATH.Document objects.
Property CapabilityStatements As %Library.ArrayOfDataTypes;

/// The maximum allowable number of resources to delete via conditional delete. If the
/// conditional delete search finds more than this number of resources then the conditional
/// delete as a whole is rejected with an HTTP 412 Precondition Failed error.
Property MaxConditionalDeleteResults As %Integer [ InitialExpression = 3 ];

/// XSLT 1.0 transformer object, held for the life of the business operation session to help performance.
Property XSLT1Transformer As HS.Util.XSLTTransformer;

/// XSLT 2.0 transformer object, held for the life of the business operation session to help performance.
Property XSLT2Transformer As HS.Util.XSLTTransformer;

/// Class that implements a class method named "PostProcessSearch". When this setting has a value,
/// the PostProcessSearch class method from the specified class is invoked upon search requests
/// and upon $everything requests.<br>
/// <br>
/// PostProcessSearch is called after the physical storage ids are obtained for the resources that
/// qualify for the search or $everything request. The inputs to this class method are:<br>
/// - pResultSet          : Result set as HS.Util.TransientTable object. Columns of pResultSet are:<br>
/// - - ID                : The physical storage id.<br>
/// - - Deleted           : Initialized as blank for all rows. Provides a means to mark rows for
///                         exclusion from the returned Bundle of resources. The search and $everything
///                         logic subsequent to the return from PostProcessSearch will ignore result
///                         set rows that have the Deleted column set to 1.<br>
/// - - ResourceType      : Resource type.<br>
/// - - ResourceId        : Blank. Is populated with resource id only if StorageClass is configured to do so.<br>
/// - - Mode              : "match" means the resource matched by the search criteria. "include" means
///                         the resource is present only because a "match" resource has a reference to
///                         it.<br>
/// - - RefersTo          : Comma-delimited list of storage ids to which the resource has references.<br>
/// - pSessionApplication : User session application name.<br>
/// - pSessionID          : User session id.<br>
/// - pResourceType       : Resource type. Specified only for homogeneous FHIR search. Will be blank
///                         when called while processing a $everything request or search that uses
///                         the "_include" search parameter.<br>
/// <br>
/// An example of post processing of the result set would be the filtering out of rows due to consent
/// rules or other custom logic.
/// <br><br>
/// The signature of the class method must be:<br>
/// ClassMethod PostProcessSearch(ByRef pResultSet As HS.Util.TransientTable, pSessionApplication As %String, pSessionID As %String, pResourceType As %String) As %Status
Property SearchPostProcessorClass As %String(MAXLEN = 256);

/// Class that implements a class method named "LoadPatient". The input arguments to this class method
/// are the current business host, a patient MPIID, a user session application name, and a user
/// session id.<br><br>
/// The intended purpose of this class method hook is to provide an opportunity for an application
/// to examine the FHIR resource repository for the existence of data for a specified patient
/// (indicated by an MPIID) and call application specific logic to load that patient's data into
/// the repository if it is not already present. This hook is utilized for the search and read
/// interactions.
/// <br><br>
/// For search interactions, the MPIID is derived using this logic:<br>
/// - If the resource type on the search is not Patient, then use the search parameter value of the
/// first found of any "patient" or "subject" search parameters.<br>
/// - If the resource type on the search is Patient, and a search parameter "_id" is specified, then
/// use that value.<br>
/// - If the resource type on the search is Patient, and a search parameter "identifier" is specified,
/// then if the system portion of the value matches that of the current affinity domain, then use
/// the value part of that parameter value.<br>
/// - Otherwise, if an MPIID is not derived by any of the above logic, and the resource type on the
/// search request is a "shared" resource type (e.g., Practitioner, Organization, Medication) then
/// the search is okay and will not invoke LoadPatientClass, since it has no need to do so.
/// <br><br>
/// For read interactions, the MPIID is derived from the resource id specified in the request message.
/// <br><br>
/// The signature of the class method must be:<br>
/// ClassMethod LoadPatient(pHost As Ens.Host, pMPIID As %String, pSessionApplication As %String, pSessionID As %String) As %Status
Property LoadPatientClass As %String(MAXLEN = 256);

/// Class that implements a class method named "PostProcessRead". The inputs to this class method are:<br>
/// - The current business host object<br>
/// - A resource physical storage id<br>
/// - A user session application name<br>
/// - A user session id<br>
/// - The resource type that was the target of the read<br>
/// <br>
/// The output from this class method is a Boolean output parameter value that indicates whether
/// or not the specified resource is okay to be read by the current user.<br>
/// <br>
/// An example of post processing of the read would be the filtering due to consent rules or other
/// custom logic.<br>
/// <br>
/// The signature of the class method must be:<br>
/// ClassMethod PostProcessRead(pHost As Ens.Host, pStorageId As %String, pSessionApplication As %String, pSessionID As %String, pResourceType As %String, ByRef pIsOK As %Boolean) As %Status<br>
/// <br>
/// A failure return status will be treated as a 500 Internal Server error.<br>
/// <br>
/// A successful return with a pIsOK return of 0 will be treated as 404 Not Found.
Property ReadPostProcessorClass As %String(MAXLEN = 256);

/// This property is initially implemented as NOT a business host setting. If true (1), if a FHIR
/// request includes session identification - in the form of the SessionApplication and SessionId
/// properties of HS.Message.FHIR.Request - then for all interactions the session identifier value
/// is passed to the storage class for the SessionIdentifier input parameter. If false (0), then
/// only a blank value is passed to the storage class for the SessionIdentifier input parameter.
Property ApplySessionIdToResources As %Boolean [ InitialExpression = 0 ];

Parameter INVOCATION = "Queue";

Parameter QUERYIDPARAM = "queryId";

Parameter QUERYPAGEPARAM = "page";

Parameter SESSIONDLM = "||";

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.FHIR.Request"> 
		<Method>DispatchRequest</Method>
	</MapItem>
</MapItems>
}

Method OnInit() As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		// In STU3 the resource type is CapabilityStatement.
		Set tSC = ..LoadCapabilities("CapabilityStatement", ..StorageClass, ..RepositoryUtilityClass, ..ResourceSchemaRoot, .tCapabilityStatements)
		If $$$ISERR(tSC) Quit
		
		Set ..CapabilityStatements = tCapabilityStatements
		
		/// Carry out any "startup" tasks that the StorageClass might want to do.
		Set tSC = $ClassMethod(..StorageClass, "OnInit")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// LoadCapabilities finds the Conformance resources currently in the resource repository
/// and loads them into the CapabilityStatements array, indexed by resource id, each as
/// an %XML.XPATH.Document object.
ClassMethod LoadCapabilities(pResourceType As %String, pStorageClass As %String, pRepositoryUtilityClass As %String, pResourceSchemaRoot As %String, Output pCapabilityStatements As %Library.ArrayOfDataTypes) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	#dim tCapabilityDoc As %XML.XPATH.Document
	
	Try {
		Set pCapabilityStatements = ##class(%Library.ArrayOfDataTypes).%New()
		
		Set tSC = $ClassMethod(pStorageClass, "Search", pResourceType, , , , , .tResultSet)
		If $$$ISERR(tSC) Quit
		
		While (tResultSet.%Next()) {
			Set tSC = $ClassMethod(pStorageClass, "ReadByStorageId", "xml", pResourceSchemaRoot, tResultSet.%Get("ID"), , , .tResourceStream, , .tErrors)
			If $$$ISERR(tSC) Quit
			
			Set tSC = $ClassMethod(pRepositoryUtilityClass, "GetFHIRXPathDocFromXMLStream", tResourceStream, .tCapabilityDoc)
			If $$$ISERR(tSC) Quit
			
			#dim tDOMResults As %Library.ListOfObjects
			
			Set tSC = tCapabilityDoc.EvaluateExpression("/f:"_pResourceType_"/f:id", "@value", .tDOMResults)
			If $$$ISERR(tSC) Quit
			If ('$IsObject($Get(tDOMResults)))||(tDOMResults.Count()=0)||(tDOMResults.GetAt(1).Value="") {
				Set tSC = $$$ERROR($$$GeneralError, "Could not find resource id for "_pResourceType_" resource")
				Quit
			}
			
			Set tResourceId = tDOMResults.GetAt(1).Value
			
			Set tSC = pCapabilityStatements.SetAt(tCapabilityDoc, tResourceId)
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit
		

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method DispatchRequest(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	#dim tStatus As %Status = $$$OK
	#dim tException
	Try {
		#dim tMethod As %String
		
		Set tMethod = $CASE(pRequest.Interaction, "read":"Read",
												  "update":"Update",
												  "create":"Create",
												  "delete":"Delete",
												  "search":"Search",
												  "search-all":"Search",
												  "search-compartment":"Search",
												  "history":"History",
												  "vread":"Read",
												  "transaction":"Transaction",
												  "capabilities":"Capabilities",
												  "patch":"Patch",
										 		  :"")
		
		// If invalid ContentType per STU3 then change it to a valid ContentType.
		Set pRequest.ContentType = ##class(HS.FHIR.Utils).EnsureContentType(pRequest.ContentType, "STU3")
		
		If tMethod '= "" {
			Set tStatus = $Method($this, tMethod, pRequest, .pResponse)
			Quit:$$$ISERR(tStatus)
		} ElseIf $Extract(pRequest.Interaction)="$" {
			Set tStatus = $Method($this, "Operation", pRequest, .pResponse)
		} Else {
			Set tStatus = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", pRequest.Interaction_" not supported")
			Quit
		}
										 		  
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	// Rather than pass the application level error itself back through the calling
	// thread, construct an OperationOutcome for the error now, set it to be the
	// response content, set the HTTP status to 500 Internal Server Error, and
	// return the response.
	If $$$ISERR(tStatus) {
		If $IsObject($Get(pResponse)) {
			If (pResponse.Payload.Size=0)&&(pResponse.QuickStreamId="") {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%New()
				Set pResponse.QuickStreamId = tQuickStream.%Id()
			}
		} Else {
			Do pRequest.NewResponse(.pResponse)
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%New()
			Set pResponse.QuickStreamId = tQuickStream.%Id()
		}
		Set tStatus = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tStatus, pRequest.ContentType, .pResponse, pRequest.FormatFHIROutput)
		Set pResponse.Status = ##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
	}
	
	If $$$HSTRACING {
		If pResponse.QuickStreamId'="" {
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
			$$$HSTRACE("FHIR response message to be returned", "pResponse,tQuickStream", pResponse, tQuickStream)
		} Else {
			$$$HSTRACE("FHIR response message to be returned", "pResponse", pResponse)
		}
	}
	
	Quit tStatus
}

Method Capabilities(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tNewRequest As HS.Message.FHIR.Request
		
		Set tNewRequest = pRequest.%ConstructClone(1)
		Set tNewRequest.Type = "CapabilityStatement"
		Set tNewRequest.Id = pRequest.AdditionalInfo.GetAt("CapabilityStatementId")
		Set tNewRequest.Interaction = "read"
		
		Set tSC = ..Read(tNewRequest, .pResponse)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Transaction processes a FHIR transaction interaction.  The payload
/// of a transaction interaction is a FHIR Bundle.  The Bundle type may
/// be transaction, batch, document, message, or collection.  Processing
/// of the Bundle varies based on type.
Method Transaction(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		If $$$ISERR(tSC) Quit
		If (+pResponse.Status>399)&&(+pResponse.Status<501) Quit
		
		// Assert that this system level interaction is allowed as per the Conformance/CapabilityStatement.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateSystemInteraction", pRequest.Interaction, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			Set tText = "FHIR system-level "_pRequest.Interaction_" interaction not supported on this end point"
			Set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pRequest.ContentType, .tResponseStream, "error", "not-supported", tText, , , tText)
			If $$$ISERR(tSC) Quit
			Set pResponse.Status = 405
			Quit
		}
		
		Set tSC = $ClassMethod(..BundleProcessorClass, "ProcessBundle", pRequest, .pResponse, $this)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method Create(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		If $$$ISERR(tSC) Quit
		If (+pResponse.Status>399)&&(+pResponse.Status<501) Quit
		
		// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#create
		// says to return 404 Not Found when "resource type not supported,
		// or not a FHIR end-point".
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			// Invalid resource type is a case where we don't want to return diagnostic info.
			Set pResponse.Status = 404
			Quit
		}
		
		// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#create
		// says to return 404 Not Found when "resource type not supported,
		// or not a FHIR end-point".
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			// Invalid resource type is a case where we don't want to return diagnostic info.
			Set pResponse.Status = 404
			Quit
		}
		
		// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceInteraction", pRequest.Type, pRequest.Interaction, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR "_pRequest.Interaction_" interaction on "_pRequest.Type_" resource type not supported on this end point")
			Quit
		}
		
		// Retrieve the resource type, resource id, and the resource meta object from the Payload.
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "resourceType")
		Do tProperties.SetAt("", "id")
		Do tProperties.SetAt("", "meta")
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "GetResourceInfo", pRequest.ContentType, tRequestStream, .tResourceObject, ..ResourceSchemaRoot, .tProperties)
		If $$$ISERR(tSC) Quit
		
		// Assert that the type of the given resource matches the named type in the request.
		If tProperties.GetAt("resourceType")'=pRequest.Type {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Type of resource in request payload ("_tProperties.GetAt("resourceType")_") does not match named type in request ("_pRequest.Type_")")
			Quit
		}
		
		// If an id was provided, create a warning that create will ignore it.
		If tProperties.GetAt("id")'="" {
			Set tText = "To specify the ID of a new resource, use the update operation. Ignoring ID='"_tProperties.GetAt("id")_"'."
			Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("warning", tText, .tResponseStream, pRequest.ContentType, "informational", pRequest.FormatFHIROutput)
			If $$$ISERR(tSC) Quit
		}
		
		// If tPreferReturn is "representation", then it means that the request has asked
		// the server to return a copy of the resource that was saved.
		Set tHeader = pRequest.Headers.GetAt("PREFER")
		Set tPreferReturn = ""
		For i = 1:1:$Length(tHeader,";") {
			If $Piece($Piece(tHeader,";",i),"=",1)="return" {
				Set tPreferReturn = $Piece($Piece(tHeader,";",i),"=",2)
				Quit
			}
		}
		
		// Get the If-None-Exist search string value for conditional create, and include
		// it in the parameters that get passed to the storage class.  As of 11/30/2017,
		// conditional create is not supported, but at least we have a place for it in
		// this code infrastructure.
		Set tIfNoneExist = pRequest.Headers.GetAt("IF_NONE_EXIST")
		If tIfNoneExist'="" {
			If tCapabilityStatementDoc'="" {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceCapabilityItem(pRequest.Type, "conditionalCreate", tCapabilityStatementDoc, .tValue)
				If $$$ISERR(tSC) Quit
				// For booleans, consider the item to be disallowed only when explictly so stated.
				// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#create says
				// "Servers that don't support the conditional create should return an HTTP 412
				// error and an operation outcome".
				If tValue="false" {
					Set pResponse.Status = 412
					Set tText = "FHIR conditionalCreate on resource type "_pRequest.Type_" not supported on this end point"
					Set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pRequest.ContentType, .tResponseStream, "error", "not-supported", tText, , , tText)
					Quit
				}
			}
		}
		
		// Validate the interaction for the current resource type against any OAuth scopes.
		If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, , "create", tResourceObject, tRequestStream, .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				Quit
			}
		}
		
		#dim tErrors As HS.Types.FHIR.Errors
		
		Set tSC = $ClassMethod(..StorageClass, "Create", pRequest.ContentType, ..ResourceSchemaRoot, tIfNoneExist, ..ApplySchematronValidation, ..XSLT2Transformer, tSessionIdentifier, .tRequestStream, .tResourceObject, .tStorageId, .tErrors)
		
		// The call to the storage class incurred error(s). Convert it/them into
		// an OperationOutcome resource and return that as the response Payload.
		If $$$ISERR(tSC) {
			Set tErrorText = $system.Status.GetErrorText(tSC)
			If (tErrorText["Resource failed schema validation")||(tErrorText["Resource failed schematron validation") {
				Set tSC = tErrors.GenerateOperationOutcomeStream(pRequest.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
				If $$$ISOK(tSC) {
					Set pResponse.Status = 400
					Set pResponse.Type = "OperationOutcome"
				}
			} ElseIf tErrorText["If-None-Exist found more than one match" {
				Set pResponse.Status = 412
				Set tSC = $$$OK
				Quit
			}
			Quit
		} ElseIf ($Data(tErrors))&&(tErrors.Errors.Count()>0)&&(tErrors.Errors.GetAt(1).DetailsText["found one match") {
			Set tSC = tErrors.GenerateOperationOutcomeStream(pRequest.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
			If $$$ISOK(tSC) {
				Set pResponse.Status = 200
				Set pResponse.Type = "OperationOutcome"
			}
			Quit
		}
		
		// The Storage Id will be accessible only to components that are using the response
		// message object. The Storage Id will not be returned to external REST clients.
		If $Get(tStorageId)'="" Do pResponse.AdditionalInfo.SetAt(tStorageId, "StorageId")
		
		// HTTP response status 201 = created
		Set pResponse.Status = 201
		
		// Extract the resource id, the resource versionId and the lastUpdated values
		// from the returned resource object.
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "id")
		Do tProperties.SetAt("", "meta")
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "GetResourceInfo", , , tResourceObject, ..ResourceSchemaRoot, .tProperties)
		If $$$ISERR(tSC) Quit
		Set tResourceVId = tProperties.GetAt("meta").versionId.value
		Set tLastModified = tProperties.GetAt("meta").lastUpdated.value
		// Convert Last Modified to a format appropriate for the "Last-Modified" header.
		// Example of the target format is: "Fri, 01 Dec 2017 23:01:20 GMT"
		Set tLastModified = $$$cspHtoD($ZDTH(tLastModified,3,5))
		
		Set tLocation = $ClassMethod(..RepositoryUtilityClass, "GetURLWithParams", pRequest)_"/"_tProperties.GetAt("id")_"/_history/"_tResourceVId
		DO pResponse.Headers.SetAt(tLocation, "Location")
		DO pResponse.Headers.SetAt(tLocation, "Content-Location")
		DO pResponse.Headers.SetAt("W/"""_tResourceVId_"""", "ETag")
		DO pResponse.Headers.SetAt(tLastModified, "Last-Modified")
		Set pResponse.Id = tProperties.GetAt("id")
		Set pResponse.VId = tResourceVId
		
		// If the request has a "Prefer" header with value "return=representation", return the
		// resource as it was saved in the response payload.
		If tPreferReturn="representation" {
			// The contents of tRequestStream will have already been updated with the saved data.
			Do tRequestStream.Rewind()
			Do tResponseStream.CopyFrom(tRequestStream)
			Do tResponseStream.Rewind()
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Note that both the "read" and "vread" interactions are handled by this method. The only difference
/// between the requests is that vread specifies a version, whereas read does not and is understood
/// to be requesting the current version.
Method Read(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	set tSC = $$$OK
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		If $$$ISERR(tSC) quit
		If (+pResponse.Status>399)&&(+pResponse.Status<501) quit
		
		// FHIR REST API for read at http://hl7.org/fhir/STU3/http.html#read lists
		// only 404 Not Found as a response when invalid resource is specified.
		// "invalid" includes invalid resource type.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			set pResponse.Status = 404
			set tText = "Resource not found: "_pRequest.Type_" ID="_pRequest.Id
	  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tText, .tResponseStream, pRequest.ContentType, "not-found", pRequest.FormatFHIROutput)
			quit
		}
		
		// FHIR REST API for read at http://hl7.org/fhir/STU3/http.html#read lists
		// only 404 Not Found as a response when invalid resource is specified.
		// "invalid" includes invalid resource type.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			set pResponse.Status = 404
			set tText = "Resource not found: "_pRequest.Type_" ID="_pRequest.Id
	  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tText, .tResponseStream, pRequest.ContentType, "not-found", pRequest.FormatFHIROutput)
			quit
		}
		
		// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceInteraction", pRequest.Type, pRequest.Interaction, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR "_pRequest.Interaction_" interaction on "_pRequest.Type_" resource type not supported on this end point")
			Quit
		}
		
		// Load any _summary parameter info into the tSummary variable.
		Set tSummary = ""
		Set tKey = ""
		For {
			Set tParamItem = pRequest.Parameters.GetNext(.tKey)
			If tKey="" Quit
			If $Piece(tKey,":",1)="_summary" {
				Set tValue = $ListGet(tParamItem,1)
				If ((tValue="true")||(tValue="false")||(tValue="text")||(tValue="data")) {
					Set tSummary = tValue
				} Else {
					Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", "Invalid "_$Select(tValue="":"blank ",1:"")_"value "_$Select(tValue'="":tValue_" ",1:"")_"for _summary parameter on read interaction", tResponseStream, pRequest.ContentType, "invalid", pRequest.FormatFHIROutput)
					Quit
				}
			}
		}
		If $$$ISERR(tSC) Quit
		
		// In the context of LoadPatientClass, we equate FHIR Patient resource id with HealthShare MPIID.
		If ..LoadPatientClass'="" {
			If pRequest.Type="Patient" {
				Set tSC = $ClassMethod(..LoadPatientClass, "LoadPatient", $this, pRequest.Id, pRequest.SessionApplication, pRequest.SessionId)
				If $$$ISERR(tSC) Quit
			}
		}
		
		// Validate the interaction request for the current resource type against any OAuth scopes.
		If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, pRequest.Id, "read", , , .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				Quit
			}
		}
		
		Set tSC = $ClassMethod(..StorageClass, "Read", pRequest.ContentType, ..ResourceSchemaRoot, pRequest.Type, pRequest.Id, pRequest.VId, tSummary, tSessionIdentifier, .tResponseStream, .tResourceObject, .tErrors, .tStorageId)
		
		If $$$ISERR(tSC) {
			Set tErrorText = $system.Status.GetErrorText(tSC)
			If tErrorText["Resource not found:" {
				// If the resource doesn't exist (not even deleted), return status 404 Not Found
				set pResponse.Status = 404
		  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "not-found", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["Version not found:" {
				// If this is a vread and the specified version does not exist, return status 404 Not Found
				set pResponse.Status = 404
		  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "not-found", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["Resource previously deleted" {
				// If the resource does exist but is deleted, return status 410 Gone.
				// For a regular read, Version should be null, so the method will return the deleted status of the current version.
				set pResponse.Status = 410
				set tSC = $$$OK
			} Else {
				set pResponse.Status = 500
		  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "exception", pRequest.FormatFHIROutput)
			}
			Quit
		}
		
		If ..ReadPostProcessorClass'="" {
			Set tSC = $ClassMethod(..ReadPostProcessorClass, "PostProcessRead", $this, tStorageId, pRequest.SessionApplication, pRequest.SessionId, pRequest.Type, .tIsOK)
			If $$$ISERR(tSC) Quit
			If 'tIsOK {
				Set pResponse.Status = 404
				Set tErrorText = "Resource not found: "_pRequest.Type_" ID="_pRequest.Id
		  		Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "not-found", pRequest.FormatFHIROutput)
		  		Set tSC = $$$OK
		  		Quit
			}
		}
		
		// Validate the interaction returned data for the current resource type against any OAuth scopes.
		If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, pRequest.Id, "read", tResourceObject, tResponseStream, .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				If tResponseStream.%IsA("HS.SDA3.QuickStream") {
					Do tResponseStream.Clear(0)
				} Else {
					Do tResponseStream.Clear()
				}
				Quit
			}
		}
		
		// Retrieve the resource meta object from the Payload.
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "meta")
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "GetResourceInfo", , , tResourceObject, ..ResourceSchemaRoot, .tProperties)
		If $$$ISERR(tSC) Quit
		
		If $IsObject(tProperties.GetAt("meta")) {
			Set tLastModified = tProperties.GetAt("meta").lastUpdated.value
			Set tResourceVId = tProperties.GetAt("meta").versionId.value
			Set tLastModified = $$$cspHtoD($ZDTH(tLastModified,3,5))
		} Else {
			Set tResourceVId = ""
			Set tLastModified = ""
		}
		
		// According to the spec ETag should be 'W/"[versionId]"'
		do pResponse.Headers.SetAt("W/"""_tResourceVId_"""", "ETag")
		do pResponse.Headers.SetAt(tLastModified, "Last-Modified")
		set tLocation = $ClassMethod(..RepositoryUtilityClass, "GetURLWithParams", pRequest)
		if pRequest.Interaction="read" set tLocation = tLocation_"/_history/"_tResourceVId
		do pResponse.Headers.SetAt(tLocation, "Content-Location")
		
		if pRequest.FormatFHIROutput {
			set tTempStream = ##class(%Stream.TmpCharacter).%New()
			set tSC = ##class(HS.FHIR.Utils).FormatFHIR(pRequest.ContentType, tResponseStream, .tTempStream, $Char(32,32), $Char(13,10), ..XSLT1Transformer, 2)
			if $$$ISERR(tSC) quit
			if tResponseStream.%IsA("HS.SDA3.QuickStream") {
				do tResponseStream.Clear(0)
			} else {
				do tResponseStream.Clear()
			}
			do tResponseStream.CopyFrom(tTempStream)
		}
		
		Set pResponse.Status = 200
	}
	catch (tEx) { set tSC = tEx.AsStatus() }
	quit tSC
}

Method Update(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		If $$$ISERR(tSC) quit
		If (+pResponse.Status>399)&&(+pResponse.Status<501) quit
		
		set pResponse.Id = pRequest.Id
		
		// The initial transaction level might not be 0, if this is part of a TRANSACTION interaction
		set tInitLevel = $TLEVEL
		
		if '##class(HS.FHIR.Utils).IsValidResourceId(pRequest.Id) {
			set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Invalid resource id specified: "_pRequest.Id)
			quit
		}
		
		// FHIR REST API for update at http://hl7.org/fhir/STU3/http.html#update
		// says to return 404 Not Found when "resource type not supported,
		// or not a FHIR end-point".
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			// Invalid resource type is a case where we don't want to return diagnostic info.
			Set pResponse.Status = 404
			Quit
		}
		
		// FHIR REST API for update at http://hl7.org/fhir/STU3/http.html#update
		// says to return 404 Not Found when "resource type not supported,
		// or not a FHIR end-point".
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			// Invalid resource type is a case where we don't want to return diagnostic info.
			Set pResponse.Status = 404
			Quit
		}
		
		// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceInteraction", pRequest.Type, pRequest.Interaction, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR "_pRequest.Interaction_" interaction on "_pRequest.Type_" resource type not supported on this end point")
			Quit
		}
		
		// Retrieve the resource type, resource id, and the resource meta object from the Payload.
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "resourceType")
		Do tProperties.SetAt("", "id")
		Do tProperties.SetAt("", "meta")
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "GetResourceInfo", pRequest.ContentType, tRequestStream, .tResourceObject, ..ResourceSchemaRoot, .tProperties)
		If $$$ISERR(tSC) Quit
		
		// Assert that the type of the given resource matches the named type in the request.
		If tProperties.GetAt("resourceType")'=pRequest.Type {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Type of resource in request payload ("_tProperties.GetAt("resourceType")_") does not match named type in request ("_pRequest.Type_")")
			Quit
		}
		
		// assert that the ID in the request matches the ID in the payload
		If tProperties.GetAt("id")'=pRequest.Id {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invariant", "Error updating "_pRequest.Type_" resource: URL and payload ID values do not match ('"_pRequest.Id_"' vs. '"_tProperties.GetAt("id")_"').")
			Quit
		}
		
		// If tPreferReturn is "representation", then it means that the request has asked
		// the server to return a copy of the resource that was saved.
		Set tHeader = pRequest.Headers.GetAt("PREFER")
		Set tPreferReturn = ""
		For i = 1:1:$Length(tHeader,";") {
			If $Piece($Piece(tHeader,";",i),"=",1)="return" {
				Set tPreferReturn = $Piece($Piece(tHeader,";",i),"=",2)
				Quit
			}
		}
		
		// updateCreate specifies whether the server allows update to create new identities
		// (i.e., resource for new resource id). Default to true (allowed) if not found in
		// the Conformance/CapabilityStatement.
		If tCapabilityStatementDoc'="" {
			Set tSC = ##class(HS.FHIR.Utils).GetResourceCapabilityItem(pRequest.Type, "updateCreate", tCapabilityStatementDoc, .tUpdateCreate)
			If $$$ISERR(tSC) Quit
			If tUpdateCreate="" Set tUpdateCreate = 1
		} Else {
			Set tUpdateCreate = 1
		}
		
		If pRequest.Parameters.Count()>0 {
			// Remove non-search keys from the list of parameters, just to make sure that
			// there are actual search criteria specified.
			Set tSearchParameters = ""
			If pRequest.Parameters.Count()>0 {
				Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
				Set tSearchParameters = ##class(%Library.ArrayOfDataTypes).%New()
				Set tKey = ""
				For {
					Set tValue = pRequest.Parameters.GetNext(.tKey)
					If tKey="" Quit
					If tNotSearchKeys'[(","_tKey_",") {
						Do tSearchParameters.SetAt(tValue, .tKey)
					}
				}
				If tSearchParameters.Count()=0 Set tSearchParameters = ""
			}
		} Else {
			Set tSearchParameters = ""
		}
		
		// Must have either resource id or conditional update search parameters, but not both.
		If (pRequest.Id'="")&&(tSearchParameters'="") {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Cannot include resource id and conditional update parameters on the same update request")
			Quit
		} ElseIf (pRequest.Id="")&&(tSearchParameters="") {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Neither resource id nor conditional update parameters specified")
			Quit
		}
		
		// Verify that conditional update is allowed by the Conformance/CapabilityStatement.
		If tSearchParameters'="" {
			// conditionalUpdate specifies whether the end point allows checking for the existence
			// of resources that match a given search criteria before updating.
			If tCapabilityStatementDoc'="" {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceCapabilityItem(pRequest.Type, "conditionalUpdate", tCapabilityStatementDoc, .tValue)
				If $$$ISERR(tSC) Quit
				// For booleans, consider the item to be disallowed only when explictly so stated.
				// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#update says
				// "Servers that don't support the conditional update should return an HTTP 400
				// error and an operation outcome".
				If tValue="false" {
					Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR conditionalUpdate on resource type "_pRequest.Type_" not supported on this end point")
					Quit
				}
			}
		}
		
		// Validate the interaction for the current resource type against any OAuth scopes.
		If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, pRequest.Id, "update", tResourceObject, tRequestStream, .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				Quit
			}
		}
		
		// If the request contains an If-Match header, assert that the value matches the current version ID of the resource
		// (Used for resource contention - see http://hl7.org/fhir/STU3/http.html#update#2.21.0.11)
		set tIfMatch = pRequest.Headers.GetAt("IF_MATCH")
		if (tIfMatch '= "") {
			// Assert that it is formatted correctly
			if (tIfMatch ? 1"W/""".E1"""") {
				Set tIfMatch = $Extract(tIfMatch, 4, *-1)
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Invalid 'If-Match' header ('"_tIfMatch_"'), must be formatted as 'W/""[versionId]""'")
				Quit
			}
		}
		
		#dim tErrors As HS.Types.FHIR.Errors
		
		Set tSC = $ClassMethod(..StorageClass, "Update", pRequest.ContentType, ..ResourceSchemaRoot, tSearchParameters, tIfMatch, tUpdateCreate, ..ApplySchematronValidation, ..XSLT2Transformer, tSessionIdentifier, .tRequestStream, .tResourceObject, .tStorageId, .tErrors)
		
		// The call to the storage class incurred error(s). Convert it/them into
		// an OperationOutcome resource and return that as the response Payload.
		If $$$ISERR(tSC) {
			Set tErrorText = $system.Status.GetErrorText(tSC)
			If (tErrorText["Resource failed schema validation")||(tErrorText["Resource failed schematron validation") {
				Set tSC = tErrors.GenerateOperationOutcomeStream(pRequest.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
				If $$$ISOK(tSC) {
					Set pResponse.Status = "400"
					Set pResponse.Type = "OperationOutcome"
				}
			} ElseIf tErrorText["'If-Match' header" {
				// If the request contains an If-Match header, assert that the value matches the current version ID of the resource
				// (Used for resource contention - see http://hl7.org/fhir/STU3/http.html#update#2.21.0.11)
				set pResponse.Status = 409	// Conflict - for If-Match, would have done 412 if server REQUIRED If-Match on all updates
				Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pResponse.ContentType, "conflict", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["conditional update search found more than one match" {
				set pResponse.Status = 412	// Precondition failed
				set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "conflict", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["FHIR update interaction on non-existent resource id not allowed" {
				set pResponse.Status = 405	// Method not allowed
				set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "forbidden", pRequest.FormatFHIROutput)
			}
			Quit
		}
		
		// The Storage Id will be accessible only to components that are using the response
		// message object. The Storage Id will not be returned to external REST clients.
		If $Get(tStorageId)'="" Do pResponse.AdditionalInfo.SetAt(tStorageId, "StorageId")
		
		// Extract the resource id, the resource versionId and the lastUpdated values
		// from the returned resource object.
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "id")
		Do tProperties.SetAt("", "meta")
		Set tSC = ##class(HS.FHIR.Utils).GetResourceInfo( , , tResourceObject, ..ResourceSchemaRoot, .tProperties)
		If $$$ISERR(tSC) Quit
		Set tResourceVId = tProperties.GetAt("meta").versionId.value
		Set tLastModified = tProperties.GetAt("meta").lastUpdated.value
		// Convert Last Modified to a format appropriate for the "Last-Modified" header.
		// Example of the target format is: "Fri, 01 Dec 2017 23:01:20 GMT"
		set tLastModified = $$$cspHtoD($ZDTH(tLastModified,3,5))
		
		set tLocation = $ClassMethod(..RepositoryUtilityClass, "GetURLBase", pRequest)_"/"_pRequest.Type_"/"_tProperties.GetAt("id")_"/_history/"_tResourceVId
		do pResponse.Headers.SetAt(tLocation, "Location")
		do pResponse.Headers.SetAt(tLocation, "Content-Location")
		do pResponse.Headers.SetAt("W/"""_tResourceVId_"""", "ETag")
		do pResponse.Headers.SetAt(tLastModified, "Last-Modified")
		set pResponse.Id = tProperties.GetAt("id")
		set pResponse.VId = tResourceVId
		
		if tResourceVId=1 {
			// Created
			Set pResponse.Status = 201
		} else {
			// Updated - HTTP OK
			Set pResponse.Status = 200
		}
		
		// If the request has a "Prefer" header with value "return=representation", return the
		// resource as it was saved in the response payload.
		If tPreferReturn="representation" {
			// The contents of tRequestStream will have already been updated with the saved data.
			Do tRequestStream.Rewind()
			Do tResponseStream.CopyFrom(tRequestStream)
			Do tResponseStream.Rewind()
		}
		
	}
	catch (tEx) { set tSC = tEx.AsStatus() }
	if ($$$ISERR(tSC)) { set pResponse.Status = 500 }	// internal server error
	// If the transaction was left uncommitted (ie, error), roll it back.
	// The "1" because it's possible we are in a nested transaction (the TRANSACTION interaction)
	if ($D(tInitLevel) && ($TLEVEL > tInitLevel)) { TROLLBACK 1 }
	quit tSC
}

Method Delete(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		If $$$ISERR(tSC) quit
		If (+pResponse.Status>399)&&(+pResponse.Status<501) quit
		
		if '##class(HS.FHIR.Utils).IsValidResourceId(pRequest.Id) {
			set pResponse.Status = 400
			set tText = "Invalid resource id specified: "_pRequest.Id
	  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tText, .tResponseStream, pRequest.ContentType, "invalid", pRequest.FormatFHIROutput)
			quit
		}
		
		set pResponse.Id = pRequest.Id
		
		// Per http://www.hl7.org/fhir/STU3/http.html#delete, return status code 204 (No Content)
		// whether the identified resource exists or not and whether the resource is already
		// deleted or not.
		set pResponse.Status = 204
		
		// delete is similar to update in that it deprecates the old version of the resource and
		// creates a new one, the difference being that for delete, the new version has no content
		// and is marked as deleted
		
		// FHIR REST API for delete at http://www.hl7.org/fhir/STU3/http.html#delete does not
		// specify what do when invalid or unsupported resource type is specified. Return a
		// 204 No Content in this case.
		set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
		if $$$ISERR(tSC) quit
		if tIsValid=0 {
			quit
		}
		
		// FHIR REST API for delete at http://www.hl7.org/fhir/STU3/http.html#delete does not
		// specify what do when invalid or unsupported resource type is specified. Return a
		// 204 No Content in this case.
		set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
		if $$$ISERR(tSC) quit
		if tIsValid=0 {
			quit
		}
		
		// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceInteraction", pRequest.Type, pRequest.Interaction, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			Set pResponse.Status = 405
			Set tText = "FHIR "_pRequest.Interaction_" interaction on "_pRequest.Type_" resource type not supported on this end point"
	  		Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tText, .tResponseStream, pRequest.ContentType, "not-supported", pRequest.FormatFHIROutput)
			Quit
		}
		
		If pRequest.Parameters.Count()>0 {
			// Remove non-search keys from the list of parameters, just to make sure that
			// there are actual search criteria specified.
			Set tSearchParameters = ""
			If pRequest.Parameters.Count()>0 {
				Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
				Set tSearchParameters = ##class(%Library.ArrayOfDataTypes).%New()
				Set tKey = ""
				For {
					Set tValue = pRequest.Parameters.GetNext(.tKey)
					If tKey="" Quit
					If tNotSearchKeys'[(","_tKey_",") {
						Do tSearchParameters.SetAt(tValue, .tKey)
					}
				}
				If tSearchParameters.Count()=0 Set tSearchParameters = ""
			}
		} Else {
			Set tSearchParameters = ""
		}
		
		// Must have either resource id or conditional delete search parameters, but not both.
		If (pRequest.Id'="")&&(tSearchParameters'="") {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Cannot include resource id and conditional delete parameters on the same delete request")
			Quit
		} ElseIf (pRequest.Id="")&&(tSearchParameters="") {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Neither resource id nor conditional delete parameters specified")
			Quit
		}
		
		// Verify that conditional delete is allowed by the Conformance/CapabilityStatement.
		Set tConditionalDelete = "multiple"
		If tSearchParameters'="" {
			// conditionalDelete specifies whether the end point allows deleting resources
			// based on matching a given set of criteria (search parameters).  Conformance/
			// CapabilityStatement values for this are "not-supported", "single" and "multiple".
			// Support for conditional delete must be explicitly stated, via the "single" or
			// "multiple" values.
			If tCapabilityStatementDoc'="" {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceCapabilityItem(pRequest.Type, "conditionalDelete", tCapabilityStatementDoc, .tConditionalDelete)
				If $$$ISERR(tSC) Quit
				If (tConditionalDelete="not-supported")||(tConditionalDelete="") {
					// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#delete says
					// "Servers that don't support the conditional delete should return an HTTP 400
					// error and an operation outcome".
					Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "conditional delete is not supported on this end point")
					Quit
				}
			} Else {
				Set tConditionalDelete = "multiple"
			}
		}
		
		// Validate the interaction for the current resource type against any OAuth scopes.
		If (pRequest.AdditionalInfo.GetAt("JSONWebToken")'="")&&(tSearchParameters="")&&(pRequest.Id'="") {
			// We need to examine the contents of the resource to be deleted in order to
			// fully understand if the access token scopes grant the right to delete it.
			Set tSC = $ClassMethod(..StorageClass, "GetStorageIdByTypeAndId", pRequest.Type, pRequest.Id, pRequest.VId, tSessionIdentifier, .tStorageId)
			If $$$ISERR(tSC) {
				Set tErrorText = $system.Status.GetErrorText(tSC)
				If (tErrorText["Resource previously deleted")||(tErrorText["Resource not found") {
					// Returning a 200 or 204 could give the impression that a unauthorized
					// delete request was carried out. 200 or 204 imply that the resource
					// was there to begin with, which we may not want a unauthorized user
					// to know.
					// Forbidden, failed due to security reasons other than bad user credentials.
					Set pResponse.Status = 403
					Set tSC = $$$OK
				}
				Quit
			}
			Set tResourceStream = ##class(%Stream.TmpCharacter).%New()
			Set tSC = $ClassMethod(..StorageClass, "ReadByStorageId", pRequest.ContentType, ..ResourceSchemaRoot, tStorageId, , , .tResourceStream, .tResourceObject)
			If $$$ISERR(tSC) Quit
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, pRequest.Id, "delete", tResourceObject, tResourceStream, .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				Quit
			}
		}
		
		Set tSC = $ClassMethod(..StorageClass, "Delete", pRequest.Type, pRequest.Id, tConditionalDelete, tSearchParameters, ..MaxConditionalDeleteResults, tSessionIdentifier, .tResourceIds)
		
		If $$$ISERR(tSC) {
			Set tErrorText = $system.Status.GetErrorText(tSC)
			If tErrorText["Conditional delete of multiple resources not supported" {
				Set pResponse.Status = 412
		  		Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "not-supported", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["Conditional delete selects more than maximum allowed number of results" {
				Set pResponse.Status = 412
		  		Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pRequest.ContentType, "not-supported", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["Resource previously deleted" {
				set pResponse.Status = 204
				set tSC = $$$OK
			}
			Quit
		}
		
		If tSearchParameters="" {
			Do pResponse.Headers.SetAt("W/"""_$Piece(tResourceIds.GetAt(1),",",2)_"""", "ETag")
		} Else {
			Set tString = "Deleted "
			For i = 1:1:tResourceIds.Count() {
				If i>1 Set tString = tString_", "
				Set tString = tString_" resource id "_$Piece(tResourceIds.GetAt(i),",",1)
				Set tString = tString_" resource vid "_$Piece(tResourceIds.GetAt(i),",",2)
			}
			Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("information", tString, .tResponseStream, pRequest.ContentType, "informational", pRequest.FormatFHIROutput)
			If $$$ISERR(tSC) Quit
			Set pResponse.Status = 200
		}
		
	} catch (tEx) {
		set tSC = tEx.AsStatus()
	}
	if ($$$ISERR(tSC)) { set pResponse.Status = 500 }	// internal server error
	
	quit tSC
}

Method Search(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	set tSC = $$$OK
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		if $$$ISERR(tSC) quit
		if (+pResponse.Status>399)&&(+pResponse.Status<501) quit
		
		set tBase = $ClassMethod(..RepositoryUtilityClass, "GetURLBase", pRequest, .tSC) quit:$$$ISERR(tSC)
		set tQueryURL = $ClassMethod(..RepositoryUtilityClass, "GetURLWithQuery", pRequest, .tSC) quit:$$$ISERR(tSC)
		set tType = pRequest.Type
		
		if $ZConvert(pRequest.ContentType,"L")["json" {
			Set tContentType = "json"
		} else {
			Set tContentType = "xml"
		}
		
		if tType'="" {
			// FHIR REST API for search at http://hl7.org/fhir/STU3/http.html#search says to
			// return 404 Not Found when "resource type not supported, or not a FHIR end-point".
			// It also says: "If the search fails (cannot be executed, not that there is no
			// matches), the return value is a status code 4xx or 5xx with an OperationOutcome."
			set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
			if $$$ISERR(tSC) quit
			if tIsValid=0 {
				set pResponse.Status = 404
				set tText = "Invalid resource type specified: "_pRequest.Type
		  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tText, .tResponseStream, pRequest.ContentType, "invalid", pRequest.FormatFHIROutput)
				quit
			}
			
			// FHIR REST API for search at http://hl7.org/fhir/STU3/http.html#search says to
			// return 404 Not Found when "resource type not supported, or not a FHIR end-point".
			// It also says: "If the search fails (cannot be executed, not that there is no
			// matches), the return value is a status code 4xx or 5xx with an OperationOutcome."
			set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
			if $$$ISERR(tSC) quit
			if tIsValid=0 {
				set pResponse.Status = 404
				set tText = "Resource type not supported: "_pRequest.Type
		  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tText, .tResponseStream, pRequest.ContentType, "not-supported", pRequest.FormatFHIROutput)
				quit
			}
			
			// Assert that this interaction on this resource type is allowed as per the
			// Conformance/CapabilityStatement. While the FHIR REST API refers to the search by type
			// interaction as "search", the Conformance/CapabilityStatement resource uses value set
			// TypeRestfulInteraction http://hl7.org/fhir/ValueSet/type-restful-interaction for
			// interaction, which specifies a name of "search-type" for this interaction.
			set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceInteraction", tType, "search-type", tCapabilityStatementDoc, .tIsValid)
			if $$$ISERR(tSC) quit
			if tIsValid=0 {
				set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR "_pRequest.Interaction_" interaction on "_pRequest.Type_" resource type not supported on this end point")
				quit
			}
		} else {
			// Assert that this system level interaction on this resource type is allowed as per the
			// Conformance/CapabilityStatement. While the FHIR REST API refers to the system level
			// search interaction as "search", the Conformance/CapabilityStatement resource uses
			// value set TypeRestfulInteraction http://hl7.org/fhir/ValueSet/type-restful-interaction
			// for interaction, which specifies a name of "search-system" for this interaction.
			set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateSystemInteraction", "search-system", tCapabilityStatementDoc, .tIsValid)
			if $$$ISERR(tSC) quit
			if tIsValid=0 {
				set tText = "FHIR system-level "_pRequest.Interaction_" interaction not supported on this end point"
				set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pRequest.ContentType, .tResponseStream, "error", "not-supported", tText, , , tText)
				if $$$ISERR(tSC) quit
				set pResponse.Status = 400
				quit
			}
		}
		
		// Validate the interaction request for the current resource type against any OAuth scopes.
		If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
			// For search, if a patient scope is specified, the search must be restricted
			// to that patient's Patient resource and to other resource types that refer
			// to that patient's Patient resource. This check and enforcement is done in
			// lieu of checking all the returned resources against the access token.
			Set tResourceId = ""
			If pRequest.Type="Patient" {
				If (pRequest.GetParameterCount("_id")=1)&&(pRequest.GetParameterValue("_id",1)'="") {
					Set tResourceId = pRequest.GetParameterValue("_id",1)
				}
			} ElseIf (pRequest.GetParameterCount("patient")=1)&&(pRequest.GetParameterValue("patient",1)'="") {
				Set tResourceId = pRequest.GetParameterValue("patient",1)
				If $Extract(tResourceId,1,8)="Patient/" Set tResourceId = $Extract(tResourceId,9,*)
			} ElseIf (pRequest.GetParameterCount("subject")=1)&&(pRequest.GetParameterValue("subject",1)'="") {
				Set tResourceId = pRequest.GetParameterValue("subject",1)
				If $Extract(tResourceId,1,8)="Patient/" {
					Set tResourceId = $Extract(tResourceId,9,*)
				} Else {
					Set tResourceId = ""
				}
			}
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, tResourceId, "search", , , .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				Quit
			}
			Set tResourceObject = ""
			Kill tResourceId
		}
		
		Set tSearchWarnings = ##class(HS.Types.FHIR.Errors).%New()
		
		// These are HealthShare-specific parameters to use for paging.
		set tQueryId = pRequest.GetParameterValue(..#QUERYIDPARAM)
		set tPage = pRequest.GetParameterValue(..#QUERYPAGEPARAM)
		
		// If queryId is not present then this is a new search,
		// as opposed to a search that uses an established
		// cache of results from a previous search.
		if (tQueryId="") {
			// Make a new query cache object to hold our results.
			set tQueryCacheObj = ##class(HS.FHIR.vCommon.Repository.QueryCache).%New()
			set tQueryCacheObj.QueryID = $ZConvert($system.Util.CreateGUID(), "L")
			Set tQueryCacheObj.InitialRequestDateTime = $ZDateTime($Horolog,3)
			set tQueryCacheObj.PageSize = ..GetQueryPageSize(pRequest, ..DefaultSearchPageSize, ..MaxSearchPageSize)
			set tQueryCacheObj.Type = tType
			set tPage = 1
			#dim tResultSet As HS.Util.TransientTable
			set tSC = ..SearchNew(pRequest, ..StorageClass, ..SearchPostProcessorClass, pRequest.SessionApplication, pRequest.SessionId, tSessionIdentifier, .tResultSet, .tSearchWarnings)
			if $$$ISERR(tSC) {
				// Check for various error conditions that really should returned as
				// something other than 500 Internal Server Error.
				set tErrorText = $system.Status.GetOneErrorText(tSC)
				if (tErrorText [ "Unsupported modifier on param") {
					// This should set tSC back to $$$OK
					set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", tErrorText)
				} elseif (tErrorText [ "Specifying system value on token-type search parameter") {
					set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", tErrorText)
				} elseif (tErrorText [ "Search request must include patient identifier criteria") {
					set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
				} elseif (tErrorText [ "Use of 'above' or 'below' modifier") {
					set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
				} elseif (tErrorText [ "Invalid search parameters found") {
					set tSC = tSearchWarnings.GenerateOperationOutcomeStream(pRequest.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
					set pResponse.Status = 400
				} elseif ($ZConvert(tErrorText,"L") [ "sort") {
					set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
				}
				quit
			}
			if '$IsObject($Get(tResultSet)) {
				set tSC = $$$ERROR($$$GeneralError, "Unknown search error, resultset object not found")
				quit
			}
			if tResultSet.%ROWCOUNT > ..MaxSearchResults {
				set tErrorText = "Search selects more than maximum allowed number of results: "_..MaxSearchResults
				set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "too-costly", tErrorText)
				quit
			}
			
			// Get the column numbers, because %GetData() is far faster than %Get().
			Set tIDColumnNumber = tResultSet.%ColumnIndex("ID",.tSC)
			Set tDeletedColumnNumber = tResultSet.%ColumnIndex("Deleted",.tSC)
			Set tResourceTypeColumnNumber = tResultSet.%ColumnIndex("ResourceType",.tSC)
			Set tResourceIdColumnNumber = tResultSet.%ColumnIndex("ResourceId",.tSC)
			Set tModeColumnNumber = tResultSet.%ColumnIndex("Mode",.tSC)
			Set tRefersToColumnNumber = tResultSet.%ColumnIndex("RefersTo",.tSC)
			
			if tQueryCacheObj.PageSize=0 {
				// From http://hl7.org/fhir/STU3/search.html#count
				// if _count has the value 0, this shall be treated the same as _summary=count:
				// the server resturns a bundle that reports the total number of resources that
				// match in Bundle.total, but with no entries, and no prev/next/last links. Note
				// that the Bundle.total only include the total number of matching resources. It
				// does not count extra resources such as OperationOutcome or included resources
				// that may also be returned.
				set tResultCount = 0
				while (tResultSet.%Next()) {
					if ('tResultSet.%GetData(tDeletedColumnNumber))&&(tResultSet.%GetData(tModeColumnNumber)="match") {
						if $i(tResultCount)
					}
				}
				set tSC = ##class(HS.FHIR.Utils).StartBundleStream(tContentType, .tResponseStream, , "searchset", tResultCount, , , tQueryURL)
				if $$$ISERR(tSC) quit
				
				// If there were warnings during the validation of the search parameters,
				// add them to the end of the Bundle as an OperationOutcome resource entry.
				// This entry does not count toward the Bundle "total" value.
				if tSearchWarnings.Errors.Count()>0 {
					set tSC = tSearchWarnings.GenerateOperationOutcomeStream(tContentType, 0, .tOperationOutcomeStream)
					if $$$ISERR(tSC) quit
					kill tSearch
					set tSearch("mode") = "outcome"
					set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(tContentType, .tResponseStream, , tOperationOutcomeStream, .tSearch, , , , 1, 0, 1)
					if $$$ISERR(tSC) quit
				}
				
				set tSC = ##class(HS.FHIR.Utils).EndBundleStream(tContentType, .tResponseStream)
				if $$$ISERR(tSC) quit
				if pRequest.FormatFHIROutput {
					set tTempStream = ##class(%Stream.TmpCharacter).%New()
					set tSC = ##class(HS.FHIR.Utils).FormatFHIR(tContentType, tResponseStream, .tTempStream, $Char(32,32), $Char(13,10), ..XSLT1Transformer, 2)
					if $$$ISERR(tSC) quit
					if tResponseStream.%IsA("HS.SDA3.QuickStream") {
						do tResponseStream.Clear(0)
					} else {
						do tResponseStream.Clear()
					}
					do tResponseStream.CopyFrom(tTempStream)
				}
				set pResponse.Status = 200
				quit
			}
			set tResultCount = 0
			while (tResultSet.%Next()) {
				if 'tResultSet.%GetData(tDeletedColumnNumber) {
					set tSC = tQueryCacheObj.StreamletIds.Insert(tResultSet.%GetData(tIDColumnNumber)_"||"_tResultSet.%GetData(tModeColumnNumber))
					if tResultSet.%GetData(tModeColumnNumber)="match" if $i(tResultCount)
				}
			}
			do tResultSet.%SetIterator(0)
		} else {
			set tQueryCacheObj = ##class(HS.FHIR.vCommon.Repository.QueryCache).%OpenId(tQueryId)
			if $IsObject(tQueryCacheObj)=0 set tSC = $$$ERROR($$$GeneralError, "Invalid queryId specified") quit
			set tResultCount = tQueryCacheObj.StreamletIds.Count()
			if +tPage=0 set tPage = 1
		}
		if $$$ISERR(tSC) quit
		
		set tQueryId = tQueryCacheObj.QueryID
		set tTotal = tQueryCacheObj.StreamletIds.Count()
		set tPageSize = tQueryCacheObj.PageSize
		
		set tSC = ..GetPageLinks(pRequest, tQueryId, tTotal, tPageSize, tPage, .tFirstUrl, .tPrevUrl, .tNextUrl, .tLastUrl, tBase)
		if $$$ISERR(tSC) quit
		
		// Set the cache index boundaries for the current response Bundle.
		if tTotal'>tPageSize {
			set tStart = 1
			set tEnd = tTotal
		} elseif tPage=1 {
			set tStart = 1
			set tEnd = tPageSize
		} else {
			set tStart = (tPageSize*(tPage-1))+1
			if (tPageSize*tPage)'<tTotal {
				set tEnd = tTotal 
			} else {
				set tEnd = tPageSize*tPage
			}
		}
		
		// To maximize performance this method avoids the use of HS FHIR objects.
		// Instead it uses %DynamicObject and %XML.Document when an object is
		// needed, and constructs the Bundle using streams only.
		
		set tSC = ##class(HS.FHIR.Utils).StartBundleStream(tContentType, .tResponseStream, , "searchset", tResultCount, tFirstUrl, tPrevUrl, tQueryURL, tNextUrl, tLastUrl)
		if $$$ISERR(tSC) quit
		
		if tTotal=0 {
			// If there were warnings during the validation of the search parameters,
			// add them to the end of the Bundle as an OperationOutcome resource entry.
			// This entry does not count toward the Bundle "total" value.
			if tSearchWarnings.Errors.Count()>0 {
				set tSC = tSearchWarnings.GenerateOperationOutcomeStream(tContentType, 0, .tOperationOutcomeStream)
				if $$$ISERR(tSC) quit
				kill tSearch
				set tSearch("mode") = "outcome"
				set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(tContentType, .tResponseStream, , tOperationOutcomeStream, .tSearch, , , , 1, 0, 1)
				if $$$ISERR(tSC) quit
			}
			
			set tSC = ##class(HS.FHIR.Utils).EndBundleStream(tContentType, .tResponseStream)
			if $$$ISERR(tSC) quit
			
			if pRequest.FormatFHIROutput {
				set tTempStream = ##class(%Stream.TmpCharacter).%New()
				set tSC = ##class(HS.FHIR.Utils).FormatFHIR(tContentType, tResponseStream, .tTempStream, $Char(32,32), $Char(13,10), ..XSLT1Transformer, 2)
				if $$$ISERR(tSC) quit
				if tResponseStream.%IsA("HS.SDA3.QuickStream") {
					do tResponseStream.Clear(0)
				} else {
					do tResponseStream.Clear()
				}
				do tResponseStream.CopyFrom(tTempStream)
			}
			
			set pResponse.Status = 200
			quit
		}
		
		for tI = tStart:1:tEnd {
			set tStreamletId = $Piece(tQueryCacheObj.StreamletIds.GetAt(tI),"||",1)
			set tMode = $Piece(tQueryCacheObj.StreamletIds.GetAt(tI),"||",2)
			
			if (pRequest.Interaction = "search-all") {
				set tSC = $ClassMethod(..StorageClass, "GetStorageObjectByStorageId", tStreamletId, .tStreamlet, .tStorageClass)
				set tType = $P(tStorageClass, ".", *)
			} else {
				set tSC = $ClassMethod(..StorageClass, "GetStorageObjectByStorageId", tStreamletId, .tStreamlet, .tStorageClass)
			}
			
			set tResourceStream = ##class(%Stream.TmpCharacter).%New()
			do tStreamlet.GetResourceAsStream(.tResourceStream)
			
			set tFullUrl = tBase_"/"_tStreamlet.ResourceType_"/"_tStreamlet.ResourceId
			
			if '(((tContentType="xml")&&(tStreamlet.Format="XML"))||((tContentType="json")&&(tStreamlet.Format="JSON"))) {
				set tTempStream = ##class(%Stream.TmpCharacter).%New()
				if tStreamlet.Format="JSON" {
					set tSC = ##class(HS.FHIR.Utils).JSONToXML(tResourceStream, .tTempStream, ..ResourceSchemaRoot)
				} else {
					set tSC = ##class(HS.FHIR.Utils).XMLToJSON(tResourceStream, .tTempStream, ..ResourceSchemaRoot)
				}
				if $$$ISERR(tSC) quit
				kill tResourceStream
				set tResourceStream = tTempStream
			}
			
			// Add the entry.
			kill tSearch
			set tSearch("mode") = tMode
			// The logic of this nested loop prevents any of the AddBundleEntryToStream calls to know
			// if they are the last call to be made for the Bundle. Therefore the pWriteComma and
			// pIsLastEntry input parameters are hard-set to 0, and a comma is written here for all
			// but the first entry.
			if (tI>tStart)&&(tContentType="json") do tResponseStream.Write(",")
			set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(tContentType, .tResponseStream, tFullUrl, tResourceStream, .tSearch, , , , (tI=tStart), 0, 0)
			if $$$ISERR(tSC) quit
			
		}	// Loop over current page in the query cache
		quit:$$$ISERR(tSC)
		
		// Save the query cache object if it may be needed for additional queries.
		if tTotal>tPageSize set tSC = tQueryCacheObj.%Save() quit:$$$ISERR(tSC)
		
		// If there were warnings during the validation of the search parameters,
		// add them to the end of the Bundle as an OperationOutcome resource entry.
		// This entry does not count toward the Bundle "total" value.
		if tSearchWarnings.Errors.Count()>0 {
			set tSC = tSearchWarnings.GenerateOperationOutcomeStream(tContentType, 0, .tOperationOutcomeStream)
			if $$$ISERR(tSC) quit
			if (tContentType="json")&&(tStart>0) do tResponseStream.Write(",")
			kill tSearch
			set tSearch("mode") = "outcome"
			set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(tContentType, .tResponseStream, , tOperationOutcomeStream, .tSearch, , , , ((tStart=0)&&(tEnd=0)), 0, 1)
			if $$$ISERR(tSC) quit
		} elseif tStart>0 {
			// If regular entries were written out but not an OperationOutcome entry,
			// we have not yet written out the closing to the collection of entries
			// for JSON. Do it here now.
			if tContentType="json" do tResponseStream.Write("]")
		}
		
		set tSC = ##class(HS.FHIR.Utils).EndBundleStream(tContentType, .tResponseStream)
		if $$$ISERR(tSC) quit
		
		if pRequest.FormatFHIROutput {
			set tTempStream = ##class(%Stream.TmpCharacter).%New()
			set tSC = ##class(HS.FHIR.Utils).FormatFHIR(tContentType, tResponseStream, .tTempStream, $Char(32,32), $Char(13,10), ..XSLT1Transformer, 2)
			if $$$ISERR(tSC) quit
			if tResponseStream.%IsA("HS.SDA3.QuickStream") {
				do tResponseStream.Clear(0)
			} else {
				do tResponseStream.Clear()
			}
			do tResponseStream.CopyFrom(tTempStream)
		}
		
		Set pResponse.Status = 200
		
	} Catch (tEx) {
		Set tSC = tEx.AsStatus()
	}
	
	Quit tSC
}

/// Get the query page size, based on the _count parameter from
/// the search request, constrained by default and maximum values.
ClassMethod GetQueryPageSize(pRequest As HS.Message.FHIR.Request, pDefault As %String = "", pMaximum As %String = "") As %Integer [ Internal ]
{
	set tPageSize = pRequest.GetParameterValue("_count")
	// From http://hl7.org/fhir/STU3/search.html#count
	// if _count has the value 0, this shall be treated the same as _summary=count:
	// the server resturns a bundle that reports the total number of resources that
	// match in Bundle.total, but with no entries, and no prev/next/last links. Note
	// that the Bundle.total only include the total number of matching resources. It
	// does not count extra resources such as OperationOutcome or included resources
	// that may also be returned.
	if (tPageSize="")&&(+pDefault>0) set tPageSize = pDefault
	if (+pMaximum>0)&&(tPageSize>pMaximum) set tPageSize = pMaximum
	if tPageSize>0 {
		if pRequest.GetParameterValue("summary")="count" set tPageSize = 0
	}
	quit tPageSize
}

/// Get the links for paging to first, previous, next and last, based
/// on the total search results, page size, and current page values.
ClassMethod GetPageLinks(pRequest As HS.Message.FHIR.Request, pQueryId As %String, pTotal As %Integer, pPageSize As %Integer, pPage As %Integer, ByRef pFirst As %String, ByRef pPrev As %String, ByRef pNext As %String, ByRef pLast As %String, pBase As %String) As %Status [ Internal ]
{
	try {
		set tSC = $$$OK
		
		set (tFirst, tPrev, tNext, tLast) = ""
		set (pFirst, pPrev, pNext, pLast) = ""
		
		if pTotal>pPageSize {
			
			set tFirst = 1
			
			If (pTotal#pPageSize)=0 {
				set tLast = pTotal\pPageSize
			} else {
				set tLast = (pTotal\pPageSize)+1
			}
			
			// Previous should not point to the current page.
			if pPage=2 {
				set tPrev = 1
			} elseif pPage>2 {
				set tPrev = pPage-1
			}
			
			// Next should not point to the current page.
			if pPage=(tLast-1) {
				set tNext = tLast
			} elseif pPage<(tLast-1) {
				set tNext = pPage+1
			}
			
			// Include the _format parameter in the page links only if it was provided in the search URL.
			set tFormat = pRequest.GetParameterValue("_format")
			// Also include the _include parameter (may be multiple instances)
			set tIncludeList = pRequest.Parameters.GetAt("_include")
			set tIncludeStr = ""
			for tI=1:1:$LL(tIncludeList) { set tIncludeStr = tIncludeStr_"_include="_$LG(tIncludeList,tI)_"&" }
			set tUrl = pBase_"/"_pRequest.Type_"?"_$Select(tFormat'="":"_format="_tFormat_"&",1:"")_tIncludeStr_"page=<PAGE>&queryId="_pQueryId
			set pFirst = $Replace(tUrl, "<PAGE>", tFirst)
			if tPrev'="" set pPrev = $Replace(tUrl, "<PAGE>", tPrev)
			if tNext'="" set pNext = $Replace(tUrl, "<PAGE>", tNext)
			set pLast = $Replace(tUrl, "<PAGE>", tLast)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

/// Perform a "new" search, as opposed to a search that uses the query cache.
Method SearchNew(pRequest As HS.Message.FHIR.Request, pStorageClass As %String, pSearchPostProcessorClass As %String = "", pSessionApplication As %String = "", pSessionId As %String = "", pSessionIdentifier As %String = "", ByRef pResultSet As HS.Util.TransientTable, ByRef pErrors As HS.Types.FHIR.Errors) As %Status [ Internal ]
{
	set tSC = $$$OK
	
	set pResultSet = ""
	
	try {
		if '$IsObject($Get(pErrors)) set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// If a LoadPatientClass class name is defined, try to derive an MPIID from the
		// request message, and call the class to perform custom logic.  In the context
		// of LoadPatientClass, we equate FHIR resource id with HealthShare MPIID.
		if ..LoadPatientClass'="" {
			set tMPIID = ""
			if pRequest.Type'="Patient" {
				if (pRequest.Compartment="Patient")&&(pRequest.Id'="")&&(pRequest.Type'="") {
					set tMPIID = pRequest.Id
				} else {
					// If this is not a Patient compartment search, then the resource
					// type must have a search parameter that can point to a Patient
					// resource, and the search request must specify one of those
					// search parameters.
					set tKey = ""
					for {
						set tParamItem = pRequest.Parameters.GetNext(.tKey)
						if tKey="" Quit
						// Remove any modifier from the parameter name.
						set tKey1 = $Piece(tKey, ":", 1)
						if tKey1'="" {
							// Gather MPIID values from any reference type search
							// parameters that can point to a Patient resource.
							set tSC = ##class(HS.FHIR.vSTU3.Repository.Storage).GetRefTypeIdsFromSearchParam(tKey1, tParamItem, pRequest.Type, "Patient", .tReturnVals)
							if $$$ISERR(tSC) {
								set tText = $system.Status.GetErrorText(tSC)
								do pErrors.logError("invalid", "error", tText, , , , tText)
								set tSC = $$$ERROR($$$GeneralError, "Invalid search parameters found")
								quit
							}
							if tReturnVals'="" {
								if tMPIID'="" set tMPIID = tMPIID_","
								set tMPIID = tMPIID_tReturnVals
							}
						}
					}
					if $$$ISERR(tSC) quit
				}
				
			} else {
				set tAffinityDomainCode = ##class(HS.Registry.Config).GetKeyValue("\IHE\AffinityDomain")
				set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomainCode,"")
				if $Extract(tAffinityDomainOID, 1, 8)="urn:oid:" Set tAffinityDomainOID = $Extract(tAffinityDomainOID, 9, *)
				if pRequest.GetParameterCount("_id")=1 {
					set tMPIID = pRequest.GetParameterValue("_id", 1)
				} elseif pRequest.GetParameterCount("identifier")>0 {
					set tParamVal = pRequest.GetParameterValue("identifier", 1)
					set tSystem = $Piece(tParamVal, "|", 1)
					set tCode = $Piece(tParamVal, "|", 2)
					if (tSystem'="")&&(tCode'="") {
						if $Extract(tSystem,1,4)="http" set tSystem = ##class(HS.Data.OIDMap).GetOIDForURL(tSystem)
						if $Extract(tSystem, 1, 8)="urn:oid:" Set tSystem = $Extract(tSystem, 9, *)
						if tSystem=tAffinityDomainOID Set tMPIID = tCode
					}
				}
			}
			
			if tMPIID'="" {
				set tSC = $ClassMethod(..LoadPatientClass, "LoadPatient", $this, tMPIID, pSessionApplication, pSessionId)
				if $$$ISERR(tSC) quit
			} elseif '$ClassMethod(..StorageClass, "IsSharedResourceType", pRequest.Type) {
				// When LoadPatientClass has a value, it implies that FHIR search requests on
				// "non-shared" resources must have a patient context. Which means reference
				// to Patient resource for a non-Patient non-shared resource type search, or
				// _id or identifier on a Patient search.
				set tSC = $$$ERROR($$$GeneralError, "Search request must include patient identifier criteria")
				quit
			}
		}
		
		// If tPreferHandling is "strict", then it means that the request has asked
		// the server to consider unrecognized and/or unsupported search parameters
		// to be an error, rather than just being a condition to be ignored with a
		// warning.
		Set tHeader = pRequest.Headers.GetAt("PREFER")
		Set tPreferHandling = ""
		For i = 1:1:$Length(tHeader,";") {
			If $Piece($Piece(tHeader,";",i),"=",1)="handling" {
				Set tPreferHandling = $Piece($Piece(tHeader,";",i),"=",2)
				Quit
			}
		}
		
		set tSC = $ClassMethod(pStorageClass, "Search", pRequest.Type, pRequest.Compartment, pRequest.Id, pRequest.Parameters, pSessionIdentifier, .pResultSet, .pErrors, tPreferHandling, pSearchPostProcessorClass, pSessionApplication, pSessionId)
		if $$$ISERR(tSC) quit
		
		// Search post processing is intended to be handled inside the storage class "Search" method.
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method History(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	#; http://hl7.org/fhir/http.html#history
	
	set tSC = $$$OK
	
	try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		if $$$ISERR(tSC) quit
		if (+pResponse.Status>399)&&(+pResponse.Status<501) quit
		
		if '##class(HS.FHIR.Utils).IsValidResourceId(pRequest.Id) {
			set pResponse.Status = 400
			set tText = "Invalid resource id specified: "_pRequest.Id
	  		set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tText, .tResponseStream, pRequest.ContentType, "invalid", pRequest.FormatFHIROutput)
			quit
		}
		
		set pResponse.Id = pRequest.Id
		
		// FHIR REST API for history at http://hl7.org/fhir/STU3/http.html#history does not
		// specify what to do when invalid or unsupported resource type is specified. In
		// those cases just return 404 Not Found.
		set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
		if $$$ISERR(tSC) quit
		if tIsValid=0 {
			set pResponse.Status = 404
			quit
		}
		
		// FHIR REST API for history at http://hl7.org/fhir/STU3/http.html#history does not
		// specify what to do when invalid or unsupported resource type is specified. In
		// those cases just return 404 Not Found.
		set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
		if $$$ISERR(tSC) quit
		if tIsValid=0 {
			set pResponse.Status = 404
			quit
		}
		
		// Assert that this interaction on this resource type is allowed as per the
		// Conformance/CapabilityStatement. While the FHIR REST API refers to the search by type
		// interaction as "history", the Conformance/CapabilityStatement resource uses value set
		// TypeRestfulInteraction http://hl7.org/fhir/ValueSet/type-restful-interaction for
		// interaction, which specifies a name of "history-instance" for this interaction.
		set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceInteraction", pRequest.Type, "history-instance", tCapabilityStatementDoc, .tIsValid)
		if $$$ISERR(tSC) quit
		if tIsValid=0 {
			set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR "_pRequest.Interaction_" interaction on "_pRequest.Type_" resource type not supported on this end point")
			quit
		}
		
		// Validate the interaction request for the current resource type against any OAuth scopes.
		If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, pRequest.Id, "history", , , .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				Quit
			}
		}
		
		set tErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// Load any _count and _since parameter info into the tCount and tSince variables.
		// If bad values are found, ignore them and include a warning in the returned payload.
		set tCount = ""
		set tSince = ""
		set tKey = ""
		for {
			set tParamItem = pRequest.Parameters.GetNext(.tKey)
			if tKey="" Quit
			if $Piece(tKey,":",1)="_count" {
				set tValue = $ListGet(tParamItem,1)
				if (tCount?1N.N)&&(tCount>0) {
					set tCount = tValue
				} else {
					do tErrors.logError("value", "warning", "Invalid "_$Select(tValue="":"blank ",1:"")_"value "_$Select(tValue'="":tValue_" ",1:"")_"for _count parameter on history interaction")
				}
			} elseif $Piece(tKey,":",1)="_since" {
				// The type of the _since parameter is "instant": "known at least to the second and always includes a time zone".
				// Validate that here.
				// YYYY-MM-DDThh:mm:ss[Z,-hh:mm,+hh:mm]
				if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N1(1"Z",1"-"2N1":"2N,1"+"2N1":"2N)) {
					set tSince = ##class(HS.FHIR.Utils).ConvertToUTC(tValue)
				} else {
					// value as passed in failed validation, so ignore it
					do tErrors.logError("value", "warning", "_since parameter invalid, ignoring: "_tValue)
				}
			}
		}
		if $$$ISERR(tSC) quit
		
		// TODO: Add support for _at.
		set tAt = ""
		
		#dim tHistoryResultSet As HS.Util.TransientTable
		
		set tSC = $ClassMethod(..StorageClass, "History", pRequest.Type, pRequest.Id, tSince, tAt, tSessionIdentifier, .tHistoryResultSet, .tErrors)
		
		if $TLevel=0 $$$HSTRACE("Return data from storage History method", "tSC,%ROWCOUNT", $Select($$$ISERR(tSC):$system.Status.GetErrorText(tSC),1:1), tHistoryResultSet.%ROWCOUNT)
		
		if $$$ISERR(tSC) {
			set tErrorText = $system.Status.GetErrorText(tSC)
			if tErrorText["Resource does not exist" {
				set pResponse.Status = 404
				set tSC = $$$OK
			} else {
				set pResponse.Status = 500
				set tSC = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tSC, pRequest.ContentType, .pResponse, pRequest.FormatFHIROutput)
			}
			quit
		}
		
		set tQueryURL = $ClassMethod(..RepositoryUtilityClass, "GetURLWithQuery", pRequest, .tSC) quit:$$$ISERR(tSC)
		
		set tSC = ##class(HS.FHIR.Utils).StartBundleStream(pRequest.ContentType, .tResponseStream, , "history", tHistoryResultSet.%ROWCOUNT, , , tQueryURL)
		if $$$ISERR(tSC) quit
		
		if tCount="" set tCount = tHistoryResultSet.%ROWCOUNT
		
		set tEntriesWritten = 0
		set tErrorCount = tErrors.Errors.Count()
		
		if tHistoryResultSet.%ROWCOUNT>0 {
			for tI = 1:1:tHistoryResultSet.%ROWCOUNT {
				if (tCount>0)&&(tI>tCount) quit
				set tSCI = tHistoryResultSet.%Next(.tSC)
				if $$$ISERR(tSC) quit
				set tStorageId = tHistoryResultSet.%Get("StorageId")
				set tVerb = tHistoryResultSet.%Get("Verb")
				set tDeleted = tHistoryResultSet.%Get("Deleted")
				set tRequest("method") = tVerb
				set tRequest("url") = pRequest.Type_$S(tVerb'="POST":"/"_pRequest.Id, 1:"")
				if 'tDeleted {
					set tResourceStream = ##class(%Stream.TmpCharacter).%New()
					set tSC = $ClassMethod(..StorageClass, "ReadByStorageId", pRequest.ContentType, ..ResourceSchemaRoot, tStorageId, , , .tResourceStream, .tResourceObject, .tErrors)
					if $$$ISERR(tSC) quit
					// Validate the interaction request for the current resource type against
					// any OAuth scopes. If any of the returned resources fails verify with
					// the access token then reject the entire request and return 401 Unauthorized.
					If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
						Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, pRequest.Id, "history", tResourceObject, , .tApproved)
						If $$$ISERR(tSC) Quit
						If 'tApproved {
							// Forbidden, failed due to security reasons other than bad user credentials.
							If tResponseStream.%IsA("HS.SDA3.QuickStream") {
								Do tResponseStream.Clear(0)
							} Else {
								Do tResponseStream.Clear(1)
							}
							Set pResponse.Status = 403
							Quit
						}
					}
				} else {
					set tResourceStream = ""
				}
				set tWriteComma = ((tCount>1)&&(tI<tCount))||((tI=tCount)&&(tErrorCount>0))
				set tIsLastEntry = ((tI=tCount)&&(tErrorCount=0))
				set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(pRequest.ContentType, .tResponseStream, , tResourceStream, , .tRequest, , ,(tI=1), tWriteComma, tIsLastEntry)
				if $$$ISERR(tSC) quit
				if $i(tEntriesWritten)
			}
		}
		if ($$$ISERR(tSC))||(pResponse.Status=403) quit
		
		set pResponse.Status = 200
		
		if tErrorCount>0 {
			set tSC = tErrors.GenerateOperationOutcomeStream(pRequest.ContentType, 0, .tOperationOutcomeStream)
			if $$$ISERR(tSC) quit
			set tSC = ##class(HS.FHIR.Utils).AddBundleEntryToStream(pRequest.ContentType, .tResponseStream, , tResourceStream, , .tRequest, , , (tCount=0), 0, 1)
			if $$$ISERR(tSC) quit
		}
		
		set tSC = ##class(HS.FHIR.Utils).EndBundleStream(pRequest.ContentType, .tResponseStream)
		if $$$ISERR(tSC) quit
		
		// Add indent and line end formatting if requested.
		if pRequest.FormatFHIROutput {
			set tTempStream = ##class(%Stream.TmpCharacter).%New()
			set tSC = ##class(HS.FHIR.Utils).FormatFHIR(pRequest.ContentType, tResponseStream, .tTempStream, $Char(32,32), $Char(13,10), ..XSLT1Transformer, 2)
			if $$$ISERR(tSC) quit
			if tResponseStream.%IsA("HS.SDA3.QuickStream") {
				do tResponseStream.Clear(0)
			} else {
				do tResponseStream.Clear()
			}
			do tResponseStream.CopyFrom(tTempStream)
		}
		if $$$ISERR(tSC) quit
		
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method Operation(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		If $$$ISERR(tSC) Quit
		If (+pResponse.Status>399)&&(+pResponse.Status<501) Quit
		
		Set tErrorText = ""
		If $Extract(pRequest.Interaction)'="$" {
			Set tErrorText = "Invalid interaction '"_pRequest.Interaction_"' specified"
		} ElseIf pRequest.Interaction="$" {
			Set tErrorText = "Invalid interaction '"_pRequest.Interaction_"' specified"
		} ElseIf $Extract(pRequest.Interaction,2)'?1L {
			Set tErrorText = "Invalid interaction '"_pRequest.Interaction_"' specified"
		} ElseIf $Translate($Extract(pRequest.Interaction,2,*),"-0123456789abcdefghijklmnopqrstuvwxyz")'="" {
			Set tErrorText = "Invalid interaction '"_pRequest.Interaction_"' specified"
		}
		If tErrorText'="" {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", tErrorText)
			Quit
		}
		
		If pRequest.Type'="" {
			// Validate a specified resource type against the FHIR schema.
			// Return 404 Not Found when the resource type is invalid or
			// not supported.
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
			If $$$ISERR(tSC) Quit
			If tIsValid=0 {
				// Invalid resource type is a case where we don't want to return diagnostic info.
				Set pResponse.Status = 404
				Quit
			}
			If $IsObject($Get(tCapabilityStatementDoc)) {
				// Validate a specified resource type against the Conformance/CapabilityStatement.
				// Return 404 Not Found when the resource type is invalid or not supported.
				Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
				If $$$ISERR(tSC) Quit
				If tIsValid=0 {
					// Invalid resource type is a case where we don't want to return diagnostic info.
					Set pResponse.Status = 404
					Quit
				}
			}
		}
		
		// Validate the interaction request for the current resource type against any OAuth scopes.
		If (pRequest.Interaction="$everything")||(pRequest.Interaction="$lastn") {
			If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
				// For the purposes of access token evaluation, these interactions can be
				// considered to be read interactions.
				Set tInteraction = "read"
				Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, pRequest.Id, tInteraction, , , .tApproved)
				If $$$ISERR(tSC) Quit
				If 'tApproved {
					// Forbidden, failed due to security reasons other than bad user credentials.
					Set pResponse.Status = 403
					Quit
				}
			}
		}
		
		// Pass in most business operation setting values using the FHIR request message AdditionalInfo.
		// ApplySessionIdToResources and the CapabilityStatements collection are NOT included here.
		Do pRequest.AdditionalInfo.SetAt(..StorageClass, "operation_StorageClass")
		Do pRequest.AdditionalInfo.SetAt(..BundleProcessorClass, "operation_BundleProcessorClass")
		Do pRequest.AdditionalInfo.SetAt(..ResourceSchemaRoot, "operation_ResourceSchemaRoot")
		Do pRequest.AdditionalInfo.SetAt(..RepositoryUtilityClass, "operation_RepositoryUtilityClass")
		Do pRequest.AdditionalInfo.SetAt(..ApplySchematronValidation, "operation_ApplySchematronValidation")
		Do pRequest.AdditionalInfo.SetAt(..DefaultSearchPageSize, "operation_DefaultSearchPageSize")
		Do pRequest.AdditionalInfo.SetAt(..MaxSearchPageSize, "operation_MaxSearchPageSize")
		Do pRequest.AdditionalInfo.SetAt(..MaxSearchResults, "operation_MaxSearchResults")
		Do pRequest.AdditionalInfo.SetAt(..MaxConditionalDeleteResults, "operation_MaxConditionalDeleteResults")
		Do pRequest.AdditionalInfo.SetAt(..XSLT1Transformer, "operation_XSLT1Transformer")
		Do pRequest.AdditionalInfo.SetAt(..XSLT2Transformer, "operation_XSLT2Transformer")
		Do pRequest.AdditionalInfo.SetAt(..SearchPostProcessorClass, "operation_SearchPostProcessorClass")
		Do pRequest.AdditionalInfo.SetAt(..LoadPatientClass, "operation_LoadPatientClass")
		
		// Pass in the session identifier, which was formulated locally, and the business host object.
		Do pRequest.AdditionalInfo.SetAt(tSessionIdentifier, "operation_SessionIdentifier")
		Do pRequest.AdditionalInfo.SetAt($this, "operation_Host")
		
		// Pass in the pointers to the request and response payload streams to use.
		Do pRequest.AdditionalInfo.SetAt(tRequestStream, "operation_RequestStream")
		Do pRequest.AdditionalInfo.SetAt(tResponseStream, "operation_ResponseStream")
		
		Set tSC = $ClassMethod(..OperationProcessorClass, "ProcessOperation", pRequest, .pResponse)
		If $$$ISERR(tSC) Quit
		If ($IsObject(pResponse))&&(+pResponse.Status>399)&&(+pResponse.Status<500) Quit
		
		Set pResponse.Status = 200
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// InitializeInteraction does several common initialization tasks:
/// <li>Creates a new FHIR response message object.
/// <li>Creates a pointer to the FHIR request payload stream to use. It will point to either
///     a QuickStream or to the request message Payload property.
/// <li>If the request message is using a QuickStream, creates a QuickStream object for the
///     response message to use.
/// <li>Creates a pointer to the FHIR response payload stream to use. It will point to either
///     a QuickStream or to the response message Payload property.
/// <li>Validates the request message ContentType property.
/// <li>Validates the request message user session information, if any.
/// <li>Formulates a user session identifier from the the user session information, if any.
/// <li>Retrieves the CapabilityStatement resource, if any, for the current end point.
ClassMethod InitializeInteraction(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, pRepositoryUtilityClass As %String, pApplySessionIdToResources As %Boolean, pSessionDLM As %String, pCapabilityStatements As %Library.ArrayOfDataTypes, ByRef pSessionIdentifier As %String, ByRef pCapabilityStatementDoc As %XML.XPATH.Document, ByRef pRequestStream, ByRef pResponseStream) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = pRequest.NewResponse(.pResponse)
		If $$$ISERR(tSC) Quit
		
		Set pResponse.Type = pRequest.Type
		
		// Remove the charset parameter from ContentType before
		// copying to the response because CSP will put one in
		// there for us when returning the response.
		Set tString = ""
		For i = 1:1:$Length(pRequest.ContentType, ";") {
			If $Piece(pRequest.ContentType, ";", i)["charset" Continue
			If tString'="" set tString = tString_";"
			Set tString = tString_$Piece(pRequest.ContentType, ";", i)
		}
		Set pResponse.ContentType = tString
		
		Set pRequestStream = pRequest.GetPayloadOref()
		
		// Unconditionally create a QuickStream to hold the response message
		// payload content and set the response message QuickStreamId. Setting
		// up a QuickStream may be unnecessary sometimes, but centralizing its
		// setup here simplifies the rest of the logic for processing interactions.
		// It also makes it easier in the future to implement a configuration
		// setting to toggle the use of response QuickStream.
		Set pResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pResponse.QuickStreamId = pResponseStream.%Id()
		
		// Validate the ContentType Mime Type.
		Do $ClassMethod(pRepositoryUtilityClass, "GetAllValidFormats", .tFormats)
		If pRequest.Interaction="patch" Merge tFormats("ContentType") = tFormats("Patch")
		If '$Data(tFormats("ContentType", pResponse.ContentType)) {
			Set pResponse.Status = 406
			Set tText = "Invalid ContentType "_pRequest.ContentType
			Set tSC = $ClassMethod(pRepositoryUtilityClass, "CreateOutcomeSingleIssueStream", pRequest.ContentType, .pResponseStream, "error", "invalid", tText, , , tText, , , pRequest.FormatFHIROutput)
			If $$$ISOK(tSC) Set pResponse.ContentType="text/xml"
			Quit
		}
		
		Set tSC = ..ValidateSessionIdentification(pApplySessionIdToResources, pRequest.SessionApplication, pRequest.SessionId, pSessionDLM, .pSessionIdentifier)
		If $$$ISERR(tSC) quit
		
		// It is okay for the Conformance statement resource id (CapabilityStatementId)
		// to not be specified. However, if it is specified and no object is found for
		// it, then that is an error.
		Set pCapabilityStatementDoc = ""
		Set tCapabilityStatementId = pRequest.AdditionalInfo.GetAt("CapabilityStatementId")
		If tCapabilityStatementId="" Set tCapabilityStatementId = pRequest.AdditionalInfo.GetAt("ConformanceId")
		If tCapabilityStatementId'="" {
			Set pCapabilityStatementDoc = pCapabilityStatements.GetAt(tCapabilityStatementId)
			If pCapabilityStatementDoc="" {
				Set tSC = $$$ERROR($$$GeneralError, "CapabilityStatement resource "_tCapabilityStatementId_" not found")
				Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// If we want to apply the session identification to the interactions with the FHIR storage layer
/// then validate the inputs, compose the inputs into a single value, and return it.<br>
/// Inputs:<br>
/// <li>pUseSessionId        : (required) Boolean value. True (1) means validate the input and return
///                            the composed identifier (pSessionIdentifier). False (0) means simply
///                            return null string for the composed identifier.
/// <li>pSessionApplication  : SessionApplication value. The use of SessionApplication and SessionId
///                            as two parts of session identification is based on the use of
///                            <class>HS.Util.SessionData.Session</class> and <class>HS.FHIR.SessionData.FHIRSession</class>
///                            as part of user session management.
/// <li>pSessionId           : SessionId value.
/// <li>pIdentifierDelimiter : Delimiter string to separate the SessionApplication and SessionId values
///                            in pSessionIdentifier when those two values are not null.
/// <br>Output:<br>
/// <li>pSessionIdentifier   : The composed session identifier to pass to the FHIR storage layer method calls.
ClassMethod ValidateSessionIdentification(pUseSessionId As %Boolean, pSessionApplication As %String, pSessionId As %String, pIdentifierDelimiter As %String = "||", ByRef pSessionIdentifier As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pSessionIdentifier = ""
	
	Try {
		if pUseSessionId {
			if (pSessionApplication'="")&&(pSessionId'="") { 
				set pSessionIdentifier = pSessionApplication_pIdentifierDelimiter_pSessionId
			}
			elseif (pSessionApplication'="")||(pSessionId'="") {
				set tSC = $$$ERROR($$$GeneralError, "SessionApplication and SessionId must either both be populated or both be null.")
				quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method Patch(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// InitializeInteraction() does several common initialization tasks.
		//
		// InitializeInteraction() returns tRequestStream, which is a pointer to either
		// a QuickStream or to the FHIR request message Payload property, depending on
		// whether the FHIR request message QuickStreamId property has a value or not.
		//
		// InitializeInteraction() returns tResponseStream, which is a pointer to either
		// a QuickStream or to the FHIR response message Payload property, depending on
		// whether the FHIR *request* message QuickStreamId property has a value or not.
		Set tSC = ..InitializeInteraction(pRequest, .pResponse, ..RepositoryUtilityClass, ..ApplySessionIdToResources, ..#SESSIONDLM, ..CapabilityStatements, .tSessionIdentifier, .tCapabilityStatementDoc, .tRequestStream, .tResponseStream)
		If $$$ISERR(tSC) Quit
		If (+pResponse.Status>399)&&(+pResponse.Status<501) Quit
		
		Do $ClassMethod(..RepositoryUtilityClass, "GetAllValidFormats", .tFormats)
		
		// Re-validate ContentType and Accept here, until we update the logic for all
		// interactions to be able to use the new Accept property.
		Set tText = ""
		If pRequest.Accept="" {
			Set pResponse.Status = 406
			Set tCode = "invalid"
			Set tText = "Patch Accept format not specified in FHIR request"
		} ElseIf '$Data(tFormats("Accept", pRequest.Accept)) {
			Set pResponse.Status = 406
			Set tCode = "invalid"
			Set tText = "Invalid Patch Accept format '"_pRequest.Accept_"' specified"
		} ElseIf '$Data(tFormats("Patch", pRequest.ContentType)) {
			Set pResponse.Status = 406
			Set tCode = "invalid"
			Set tText = "Invalid ContentType '"_pRequest.ContentType_"' specified"
		} ElseIf (pRequest.ContentType="application/fhir+xml")||(pRequest.ContentType="application/fhir+json") {
			Set pResponse.Status = 400
			Set tCode = "not-supported"
			Set tText = "FHIRPath Patch is not supported"
		}
		If tText'="" {
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "CreateOutcomeSingleIssueStream", pRequest.Accept, .tResponseStream, "error", tCode, tText, , , tText, , , pRequest.FormatFHIROutput)
			If $$$ISOK(tSC) Set pResponse.ContentType = pRequest.Accept
			Quit
		}
		
		Set pResponse.ContentType = pRequest.Accept
		
		If pRequest.Type="" {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "required", "FHIR "_pRequest.Interaction_" interaction resource type not specified")
			Quit
		}
		
		// The FHIR REST API spec does not state any specific rules for patch
		// regarding how to respond when unsupported or invalid resource type
		// is specified. Since patch most closely aligns with the update
		// interaction, give the same response as would update.
		//
		// FHIR REST API for update at http://hl7.org/fhir/STU3/http.html#update
		// says to return 404 Not Found when "resource type not supported,
		// or not a FHIR end-point".
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeFHIR", pRequest.Type, ..ResourceSchemaRoot, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			// Invalid resource type is a case where we don't want to return diagnostic info.
			Set pResponse.Status = 404
			Quit
		}
		
		// The FHIR REST API spec does not state any specific rules for patch
		// regarding how to respond when unsupported or invalid resource type
		// is specified. Since patch most closely aligns with the update
		// interaction, give the same response as would update.
		//
		// FHIR REST API for update at http://hl7.org/fhir/STU3/http.html#update
		// says to return 404 Not Found when "resource type not supported,
		// or not a FHIR end-point".
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceTypeCapability", pRequest.Type, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			// Invalid resource type is a case where we don't want to return diagnostic info.
			Set pResponse.Status = 404
			Quit
		}
		
		// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "ValidateResourceInteraction", pRequest.Type, pRequest.Interaction, tCapabilityStatementDoc, .tIsValid)
		If $$$ISERR(tSC) Quit
		If tIsValid=0 {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR "_pRequest.Interaction_" interaction on "_pRequest.Type_" resource type not supported on this end point")
			Quit
		}
		
		// If tPreferReturn is "representation", then it means that the request has asked
		// the server to return a copy of the resource that was saved.
		Set tHeader = pRequest.Headers.GetAt("PREFER")
		Set tPreferReturn = ""
		For i = 1:1:$Length(tHeader,";") {
			If $Piece($Piece(tHeader,";",i),"=",1)="return" {
				Set tPreferReturn = $Piece($Piece(tHeader,";",i),"=",2)
				Quit
			}
		}
		
		// If the request contains an If-Match header, assert that the value matches the current version ID of the resource
		// (Used for resource contention - see http://hl7.org/fhir/STU3/http.html#update#2.21.0.11)
		Set tIfMatch = pRequest.Headers.GetAt("IF_MATCH")
		If (tIfMatch '= "") {
			// Assert that it is formatted correctly
			If (tIfMatch ? 1"W/""".E1"""") {
				Set tIfMatch = $Extract(tIfMatch, 4, *-1)
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Invalid 'If-Match' header ('"_tIfMatch_"'), must be formatted as 'W/""[versionId]""'")
				Quit
			}
		}
		
		If pRequest.Parameters.Count()>0 {
			// Remove non-search keys from the list of parameters, just to make sure that
			// there are actual search criteria specified.
			Set tSearchParameters = ""
			If pRequest.Parameters.Count()>0 {
				Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
				Set tSearchParameters = ##class(%Library.ArrayOfDataTypes).%New()
				Set tKey = ""
				For {
					Set tValue = pRequest.Parameters.GetNext(.tKey)
					If tKey="" Quit
					If tNotSearchKeys'[(","_tKey_",") {
						Do tSearchParameters.SetAt(tValue, .tKey)
					}
				}
				If tSearchParameters.Count()=0 Set tSearchParameters = ""
			}
		} Else {
			Set tSearchParameters = ""
		}
		
		// Must have either resource id or conditional update search parameters, but not both.
		If (pRequest.Id'="")&&(tSearchParameters'="") {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Cannot include resource id and conditional patch parameters on the same patch request")
			Quit
		} ElseIf (pRequest.Id="")&&(tSearchParameters="") {
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "invalid", "Neither resource id nor conditional patch parameters specified")
			Quit
		}
		
		// Verify that conditional update is allowed by the Conformance/CapabilityStatement.
		// Check conditionalUpdate, there is no conditionalPatch.
		If tSearchParameters'="" {
			// conditionalUpdate specifies whether the end point allows checking for the existence
			// of resources that match a given search criteria before updating.
			If tCapabilityStatementDoc'="" {
				Set tSC = ##class(HS.FHIR.Utils).GetResourceCapabilityItem(pRequest.Type, "conditionalUpdate", tCapabilityStatementDoc, .tValue)
				If $$$ISERR(tSC) Quit
				// For booleans, consider the item to be disallowed only when explictly so stated.
				// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#update says
				// "Servers that don't support the conditional update should return an HTTP 400
				// error and an operation outcome".
				If tValue="false" {
					Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, "not-supported", "FHIR conditionalUpdate on resource type "_pRequest.Type_" not supported on this end point")
					Quit
				}
			}
		}
		
		// Validate the interaction for the current resource type against any OAuth scopes.
		If pRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
			Set tSC = $ClassMethod(..RepositoryUtilityClass, "VerifyWithAccessToken", pRequest.AdditionalInfo.GetAt("JSONWebToken"), "STU3", pRequest.Type, , "patch", tResourceObject, tRequestStream, .tApproved)
			If $$$ISERR(tSC) Quit
			If 'tApproved {
				// Forbidden, failed due to security reasons other than bad user credentials.
				Set pResponse.Status = 403
				Quit
			}
		}
		
		#dim tErrors As HS.Types.FHIR.Errors
		
		Set tSC = $ClassMethod(..StorageClass, "Patch", pRequest.ContentType, tRequestStream, pRequest.Type, pRequest.Id, ..ResourceSchemaRoot, tSearchParameters ,tIfMatch, tSessionIdentifier, pRequest.Accept, .tResourceStream, .tResourceObject, .tStorageId, .tErrors)
		
		// The call to the storage class incurred error(s). Convert it/them into
		// an OperationOutcome resource and return that as the response Payload.
		If $$$ISERR(tSC) {
			Set tErrorText = $system.Status.GetErrorText(tSC)
			If (tErrorText["Resource failed schema validation")||(tErrorText["Resource failed schematron validation") {
				Set tSC = tErrors.GenerateOperationOutcomeStream(pResponse.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
				If $$$ISOK(tSC) {
					Set pResponse.Status = 400
					Set pResponse.Type = "OperationOutcome"
				}
			} ElseIf (tErrorText?.E1"Patch '"1A.A1"' operation ".E)||(tErrorText["Patch operation op not specified")||(tErrorText["Patch operation invalid op")||(tErrorText["Invalid XML Patch operation '") {
				Set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pResponse.ContentType, .tResponseStream, "error", "invalid", tErrorText, , , tErrorText, , , pRequest.FormatFHIROutput)
				Set pResponse.Status = 400
				Set pResponse.Type = "OperationOutcome"
			} ElseIf tErrorText["conditional patch search found no matches, PATCH rejected" {
				Set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pResponse.ContentType, .tResponseStream, "error", "invalid", tErrorText, , , tErrorText, , , pRequest.FormatFHIROutput)
				Set pResponse.Status = 400
				Set pResponse.Type = "OperationOutcome"
			} ElseIf (tErrorText["#5035")||(tErrorText["Blank Patch input") {
				Set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pResponse.ContentType, .tResponseStream, "error", "structure", tErrorText, , , tErrorText, , , pRequest.FormatFHIROutput)
				Set pResponse.Status = 400
				Set pResponse.Type = "OperationOutcome"
			} ElseIf tErrorText["'If-Match' header" {
				// If the request contains an If-Match header, assert that the value matches the current version ID of the resource
				// (Used for resource contention - see http://hl7.org/fhir/STU3/http.html#update#2.21.0.11)
				set pResponse.Status = 409	// Conflict - for If-Match, would have done 412 if server REQUIRED If-Match on all updates
				Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pResponse.ContentType, "conflict", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["conditional patch search found more than one match" {
				Set pResponse.Status = 412	// Precondition failed
				Set tSC = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, pResponse.ContentType, "conflict", pRequest.FormatFHIROutput)
			} ElseIf tErrorText["Resource does not exist" {
				Set pResponse.Status = 404	// Not found
				Set tSC = $$$OK
			} ElseIf tErrorText["Resource is deleted" {
				Set pResponse.Status = 410	// Gone
				Set tSC = $$$OK
			}
			Quit
		} ElseIf ($Data(tErrors))&&(tErrors.Errors.Count()>0)&&(tErrors.Errors.GetAt(1).DetailsText["found one match") {
			Set tSC = tErrors.GenerateOperationOutcomeStream(pResponse.ContentType, pRequest.FormatFHIROutput, .tResponseStream)
			If $$$ISOK(tSC) {
				Set pResponse.Status = 200
				Set pResponse.Type = "OperationOutcome"
			}
			Quit
		}
		
		// The Storage Id will be accessible only to components that are using the response
		// message object. The Storage Id will not be returned to external REST clients.
		If $Get(tStorageId)'="" Do pResponse.AdditionalInfo.SetAt(tStorageId, "StorageId")
		
		// HTTP response status for update (via patch) is 200 OK
		Set pResponse.Status = 200
		
		// Extract the resource id, the resource versionId and the lastUpdated values
		// from the returned resource object.
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "id")
		Do tProperties.SetAt("", "meta")
		Set tSC = $ClassMethod(..RepositoryUtilityClass, "GetResourceInfo", , , tResourceObject, ..ResourceSchemaRoot, .tProperties)
		If $$$ISERR(tSC) Quit
		Set tResourceVId = tProperties.GetAt("meta").versionId.value
		Set tLastModified = tProperties.GetAt("meta").lastUpdated.value
		// Convert Last Modified to a format appropriate for the "Last-Modified" header.
		// Example of the target format is: "Fri, 01 Dec 2017 23:01:20 GMT"
		Set tLastModified = $$$cspHtoD($ZDTH(tLastModified,3,5))
		
		Set tLocation = $ClassMethod(..RepositoryUtilityClass, "GetURLWithParams", pRequest)_"/"_tProperties.GetAt("id")_"/_history/"_tResourceVId
		DO pResponse.Headers.SetAt(tLocation, "Location")
		DO pResponse.Headers.SetAt(tLocation, "Content-Location")
		DO pResponse.Headers.SetAt("W/"""_tResourceVId_"""", "ETag")
		DO pResponse.Headers.SetAt(tLastModified, "Last-Modified")
		Set pResponse.Id = tProperties.GetAt("id")
		Set pResponse.VId = tResourceVId
		
		// If the request has a "Prefer" header with value "return=representation", return the
		// resource as it was saved in the response payload.
		If tPreferReturn="representation" {
			// The contents of tRequestStream will have already been updated with the saved data.
			Do tRequestStream.Rewind()
			Do tResponseStream.CopyFrom(tResourceStream)
			Do tResponseStream.Rewind()
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
