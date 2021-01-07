Include HS.FHIRServer.Errors

Class HS.FHIRServer.API.Data.Request Extends (%SerialObject, %XML.Adaptor)
{

/// Time stamp of when we received this message
Property TimestampUTC As %TimeStamp [ InitialExpression = {$ZDT($ZTS,3)}, Required ];

/// This is the "Application" name as specified by the CSP layer.  It is the
/// base URL of the endpoint and is used as a unique key for this instance.
Property SessionApplication As %String(MAXLEN = 255);

/// The HTTP Verb specified for this RequestPath
Property RequestMethod As %String;

/// The portion of the URL that represents the REST request.  This string
/// always begins with '/' and does not end with '/'  This string can
/// be appended to the BaseURL property to recreate the full URL path
/// used by the caller.
Property RequestPath As %String(MAXLEN = "");

/// The part of the incoming URL that represent any query parameters.  This path
/// does NOT begin with '?', but does contain embedded '&' to separate multiple
/// query parameters
Property QueryString As %String(MAXLEN = "");

/// This should be set to true when dispatching the service during the processing of an
/// interaction.  This will often occur during the processing of $Operation and Transaction 
/// interactions.  Setting this to true suppresses the invocation of OnBeforeRequest.
Property IsRecursive As %Boolean [ InitialExpression = 0 ];

/// JSON Input object (from POST, PUT, and PATCH requests)
/// Note: This is not typed as a %DynamicObject because IRIS automatically creates an empty one
/// which we do not want.
Property Json [ Internal, Transient ];

/// The base URL for this request (provided by the caller to allow for
/// construction of full URLs in FHIR Responses)
Property BaseURL As %String(MAXLEN = "");

/// FHIR REST takes this from the Http 'IF_NONE_MATCH' Header
/// This is used for managing concurrency
Property IfNoneMatch As %String;

/// FHIR REST takes this from the Http 'IF_MODIFIED_SINCE' Header
/// This is used for managing concurrency
Property IfModifiedSince As %String;

/// FHIR REST takes this from the Http 'IF_MATCH' Header
/// This is used for managing update contention
Property IfMatch As %String;

/// FHIR REST takes this from the Http 'IF_NONE_EXIST' Header
/// This is used for conditional creates
Property IfNoneExist As %String(MAXLEN = "");

/// FHIR REST takes this from the Http 'PREFER' Header
/// This is used for conditional creates
Property Prefer As %String;

/// Used for ad hoc data that is meant to travel only between config items and not between productions/systems.
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

Property Username As %String [ Calculated ];

Property Roles As %String [ Calculated ];

/// Query Parameters
/// (This Property is derived during dispatch, DO NOT MODIFY)
Property Parameters As HS.FHIRServer.API.Data.QueryParameters [ Internal, Transient ];

/// Query Parameters take from any 'application/x-www-form-urlencoded' Payload
/// (This Property is derived during dispatch, DO NOT MODIFY)
Property FormData As HS.FHIRServer.API.Data.QueryParameters [ Internal, Transient ];

/// (This Property is derived during dispatch, DO NOT MODIFY)
Property Type As %String [ Internal, Transient ];

/// (This Property is derived during dispatch, DO NOT MODIFY)
/// Length restriction will be enforced elsewhere by schema-based validation on id data type.
Property Id As %String(MAXLEN = "") [ Internal, Transient ];

/// (This Property is derived during dispatch, DO NOT MODIFY)
Property VId As %String [ Internal, Transient ];

/// Compartment
/// (This Property is derived during dispatch, DO NOT MODIFY)
Property Compartment As %String [ Internal, Transient ];

/// The Operation Name (if any)
/// (This Property is derived during dispatch, DO NOT MODIFY)
Property OperationName As %String [ Internal, Transient ];

/// The Scope of an Operation
/// (This Property is derived during dispatch, DO NOT MODIFY)
Property OperationScope As %String [ Internal, Transient ];

/// The FHIR interaction
Property Interaction As %String [ Internal, Transient ];

Property RequestFormatCode As %String;

Property ResponseFormatCode As %String;

Property SessionId As %String(MAXLEN = 255);

Property %Username As %String(MAXLEN = 255) [ Final, InitialExpression = {$Username}, Private ];

Property %Roles As %String(MAXLEN = 8192) [ Final, InitialExpression = {$Roles}, Private ];

Parameter RESPONSECLASSNAME As %String = "HS.FHIRServer.API.Data.Response";

Method UsernameGet() As %String
{
	If ($Username'=..%Username) && ('$System.Security.Check("%HS_ImpersonateUser", "USE")) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrUsernameReadNotAllowed))
	}
	Return ..%Username
}

Method RolesGet() As %String
{
	If ($Username'=..%Username) && ('$System.Security.Check("%HS_ImpersonateUser", "USE")) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrRolesReadNotAllowed))
	}
	Return ..%Roles
}

Method UsernameSet(pNewUsername As %String) As %Status
{
	// Assume that UsernameSet() will be called only once per request object.
	// If impersonating, ensure current user has the permission.
	If (pNewUsername '= $Username) {
		If '$System.Security.Check("%HS_ImpersonateUser", "USE") {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrUsernameChangeNotAllowed))
		}
		Set ..%Username = pNewUsername
	}
	Quit $$$OK
}

Method RolesSet(pNewRoles As %String) As %Status
{
	// Assume that RolesSet() will be called only once per request object.
	// If impersonating, ensure current user has the permission.
	If (pNewRoles '= $Roles) {
		If '$System.Security.Check("%HS_ImpersonateUser", "USE") {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrRolesChangeNotAllowed))
		}
		Set ..%Roles = pNewRoles
	}
	Quit $$$OK
}

Method NewResponse() As HS.FHIRServer.API.Data.Response
{
 	Set tResponse = $ClassMethod(..#RESPONSECLASSNAME, "%New")
	// Default the response format to the requested response format
	Set tResponse.ResponseFormatCode = ..ResponseFormatCode
	Quit tResponse
}

/// GetParameterCount returns the number of instances of a given parameter.
/// Each instance may have a modifier or not
Method GetParameterCount(pParamName As %String) As %Integer
{
	return ..Parameters.GetParameterCount(pParamName)
}

/// GetParameter returns the value of a specified parameter instance,
/// plus any parameter modifier.  This method assumes that all
/// instances of a given parameter include a modifier OR all instances
/// do NOT include a modifier.  Parameter modifier in FHIR is expressed
/// as a colon-delimited suffix on the parameter name (not value), for
/// example family:exact=jones.
Method GetParameterValue(pParamName As %String, pPosition As %Integer = 1, ByRef pModifier As %String) As %String
{
	return ..Parameters.GetParameterValue(pParamName, pPosition, .pModifier)
}

Storage Default
{
<Data name="RequestState">
<Value name="1">
<Value>TimestampUTC</Value>
</Value>
<Value name="2">
<Value>SessionApplication</Value>
</Value>
<Value name="3">
<Value>RequestPath</Value>
</Value>
<Value name="4">
<Value>QueryString</Value>
</Value>
<Value name="5">
<Value>BaseURL</Value>
</Value>
<Value name="6">
<Value>IfNoneMatch</Value>
</Value>
<Value name="7">
<Value>IfModifiedSince</Value>
</Value>
<Value name="8">
<Value>IfMatch</Value>
</Value>
<Value name="9">
<Value>IfNoneExist</Value>
</Value>
<Value name="10">
<Value>Prefer</Value>
</Value>
<Value name="11">
<Value>AdditionalInfo</Value>
</Value>
<Value name="12">
<Value>RequestFormatCode</Value>
</Value>
<Value name="13">
<Value>ResponseFormatCode</Value>
</Value>
<Value name="14">
<Value>SessionId</Value>
</Value>
<Value name="15">
<Value>RequestMethod</Value>
</Value>
<Value name="16">
<Value>IsRecursive</Value>
</Value>
<Value name="17">
<Value>%Username</Value>
</Value>
<Value name="18">
<Value>%Roles</Value>
</Value>
</Data>
<State>RequestState</State>
<StreamLocation>^HS.FHIRServer.API26D2.RequestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
