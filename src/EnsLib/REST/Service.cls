/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// REST Service class. Can use an HTTP InboundAdapter listener, or the standard CSP Service mechanism, or both.
/// In order for the CSP mechanism to work, HTTP Services using this class must be configured with the invoking URL including ?CfgItem= giving the config item name.
/// (Configured Services exposed using the HTTP Inbound Adapter may also be invoked with this URL parameter but because
///  each configured Inbound Adapter listens on its own TCP/IP port this parameter is just a safety check for them.)
Class EnsLib.REST.Service Extends (EnsLib.HTTP.Service, %CSP.REST, Ens.Util.JSON) [ Abstract, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

/// This prefix will be removed from the beginning of the actual URL before matching it against the UrlMap.
/// If this prefix begins with '^' then the CSP Application will also be removed from the beginning of the URL if this service is being invoked via the CSP gateway.
/// If this prefix begins with '|' then the Config Name for this service will be removed from the beginning of the URL, as well as the CSP Application if this service is being invoked via the CSP gateway.
Parameter EnsServicePrefix As %String;

Parameter PREFIXCASESENSITIVE As %Boolean = 0;

ClassMethod Page(skipheader As %Boolean = 1) As %Status [ Final, ProcedureBlock = 0 ]
{
	#; We do not want the session token
	Set %response.OutputSessionToken=(''..#UseSession)

	#; For this REST service we do not want the %CSP.REST implementation of Page(); go right to the super-superclass
	Quit ##class(EnsLib.HTTP.Service).Page(skipheader)
}

/// Override this method in your subclass if you want to handle dispatching yourself.
/// This implementation paraphrases the %CSP.REST:DispatchRequest() implementation with modifications to support the input and output streams used by the HTTP Adapter.
Method OnProcessInput(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object = {$$$NULLOREF}) As %Status
{
	#Dim tMethod, tURL, tApp, tCfg As %String = ""
	Set tMethod=$ZConvert(pInput.GetAttribute("HttpRequest"),"U")
	Set tURL=pInput.GetAttribute("URL") ; don't URL-decode because that could mess up the parse into '/' pieces
	Set tApp=pInput.GetAttribute("CSPApplication")
	Set tCfg=pInput.GetAttribute("EnsConfigName")

	Set tService=..#EnsServicePrefix, tPre1=$E(tService)
	If tPre1="^" {
		#; strip Application from URL, if any
		Set:(""'=tApp)&&$S(..#PREFIXCASESENSITIVE:(tApp=$E(tURL,1,$L(tApp))), 1:($ZCVT(tApp,"L")=$ZCVT($E(tURL,1,$L(tApp)),"L")))&&("/"=$E(tApp,*)) tURL=$E(tURL,$L(tApp),*)
		Set $E(tService,1)=""
	} ElseIf tPre1="|" {
		#; strip Application and ConfigName from URL, if any
		If ""=tApp { Set:""'=tCfg tCfg="/"_tCfg_"/" } Else { Set tCfg=$S(""=tCfg:tApp, 1:tApp_tCfg_"/") }
		Set:(""'=tCfg)&&$S(..#PREFIXCASESENSITIVE:(tCfg=$E(tURL,1,$L(tCfg))), 1:($ZCVT(tCfg,"L")=$ZCVT($E(tURL,1,$L(tCfg)),"L"))) tURL=$E(tURL,$L(tCfg),*)
		Set $E(tService,1)=""
	}
	Set:"*"=tService tService=""  Set:"/"'=$E(tService,1) tService="/"_tService  Set:"/"'=$E(tService,*) tService=tService_"/"
	Set:'..#PREFIXCASESENSITIVE tService=$ZCVT(tService,"L")
	Set tURLPrefix=$E(tURL,1,$L(tService))
	Set:'..#PREFIXCASESENSITIVE tURLPrefix=$ZCVT(tURLPrefix,"L")
	If tService'=tURLPrefix {
		Quit $$$ERROR($$$EnsErrGeneral,"Service "_tURLPrefix_" does not match supported service prefix "_tService_".")
	}
	Set $E(tURL,1,$L(tService)-1)=""

	#; Ensure that any query string is not taken into account
	Set tMatchUrl=$Piece(tURL,"?")

	#; Save local variables so super class classmethods can have access to them
	Set $$$EnsJobLocal("REST.Svc")=$this, $$$EnsJobLocal("REST.InStream")=pInput
	try {
		#; Pre-Dispatch
		Set tContinue=1, tSC=..OnPreDispatch(tMatchUrl,tMethod,.tContinue)
		Quit:$$$ISERR(tSC)

		#; It's the user's responsibility to return the response in OnPreDispatch() if Continue = 0
		Quit:'tContinue

		#; Walk the dispatch map in collation order of definition
		Set (tResourceMatched,tMethodMatched)=0
		For tIndex=1:1 { Set tMapEntry=..DispatchMap(tIndex)  Quit:""=tMapEntry

			#; Pick out the RegEx
			Set tRegEx=$List(tMapEntry,2)

			#; Create a matcher
			Set:$L(tRegEx) tMatcher=##class(%Regex.Matcher).%New(tRegEx)

			#; Test each regular expression in turn, extracting the arguments, dispatching to the named method
			If $S('$L(tRegEx):'$L(tMatchUrl), 1:tMatcher.Match(tMatchUrl)) {

				#; We have matched the resource
				Set tResourceMatched=1
				Set tType=$List(tMapEntry,1)

				#; If we are a simple <Route>
				If tType="R" {
					#; Support OPTIONS VERB (cannot be overriden)
					If tMethod="OPTIONS" {
						Set tMethodMatched=1
					} Else {
						#; Check HTTP command/method name (case-insensitive, supports multiple methods delimited by ",")
						Set tMethods = $ZSTRIP($ZCVT($List(tMapEntry,3),"U"),"*W"),tFound = 0
						For tI = 1:1:$Length(tMethods,",") If tMethod = $Piece(tMethods,",",tI) Set tFound = 1 Quit
						Continue:'tFound

						#; We have matched a method
						Set tTarget=$List(tMapEntry,4)
						Set tMethodMatched=1
					}
				} Else {
					#; We are a <Map>; massage the URL and forward the request
					Set tForward=$ListGet(tMapEntry,3)
					Set tMethodMatched=1
				}
				Quit:tMethodMatched
			}
		} ; end dispatch map loop

		#; No match for the resource, report not found
		If 'tResourceMatched Set tSC=$$$ERROR($$$EnsErrGeneral,"Unsupported REST URL: "_tMatchUrl_" for HTTP command "_tMethod)  Quit

		#; Had a match for resource but method not matched
		If 'tMethodMatched Set tSC=$$$ERROR($$$EnsErrGeneral,"Unsupported HTTP command "_tMethod_" for REST URL: "_tMatchUrl)  Quit

		#; Got a match, marshall the standard arguments
		Set tArgs=0
		Set tArgs($I(tArgs))=pInput
		Set pOutput=##class(%GlobalBinaryStream).%New()
		Set tArgs($I(tArgs))=pOutput
		Set $$$EnsJobLocal("REST.OutStream")=pOutput

		#; If we are a simple <Route>
		If tType="R" {
			#; Support OPTIONS command (cannot be overriden)
			If tMethod="OPTIONS" {
				Set tSC=..OnHandleOptionsRequest(tMatchUrl)
				Quit:$$$ISERR(tSC)

				#; Dispatch CORS
				Set tSC=..ProcessCorsRequest(tURL,$list(tMapEntry,5))
			} Else {
				#; Dispatch CORS
				Set tSC=..ProcessCorsRequest(tURL,$list(tMapEntry,5))
				Quit:$$$ISERR(tSC)

				#; Marshall the regex arguments
				If $L(tRegEx) {
					For tI=1:1:tMatcher.GroupCount Set tArgs($I(tArgs))=tMatcher.Group(tI)
				}
				#; Dispatch; Check for optional ClassName prefix
				If tTarget'[":" {
					Set tSC=$method($this,tTarget,tArgs...)
				} Else {
					Set tClass=$Piece(tTarget,":"), tTarget=$Piece(tTarget,":",2)
					Set tSC=$classmethod(tClass,tTarget,tArgs...)
				}
			}
		} Else {
			#; We are a <Map>; massage the URL, marshall the regex arguments and forward the request
			If $L(tRegEx) {
				For tI=1:1:tMatcher.GroupCount Set tArgs($increment(tArgs))=tMatcher.Group(tI)
			}
			If tRegEx'="",$G(tArgs)>0 {
				Set tMatchUrl=tArgs(tArgs)
				Kill tArgs(tArgs)
				Set tArgs=tArgs-1
			} Else {
				Set tMatchUrl=""
			}
			#; Dispatch with modified URL
			Set tSC=$classmethod(tForward,"DispatchRequest",tMatchUrl,tMethod,1,$this,tArgs...)
		}
	} catch {
		Set tSC=$$$SystemError
	}
	#; Remove the local stream references; the service host reference can stay for now
	Kill $$$EnsJobLocal("REST.InStream"), $$$EnsJobLocal("REST.OutStream")
	Quit tSC
}

/// Handle an OPTIONS request for this CSP application
ClassMethod HandleDefaultOptionsRequest(pURL As %String) As %Status [ Internal, Private ]
{
	Set tSC = $$$OK
	try {
		#; No content
		Set outStream = $$$EnsJobLocal("REST.OutStream")
		Set outStream.Attributes("Content-Type")=""
		Set tSC=..SupportedVerbs(pURL,.supportedVerbs)  Quit:$$$ISERR(tSC)
		Set outStream.Attributes("Allow")=supportedVerbs
	} catch {
		Set tSC=$$$SystemError
	}
	Quit tSC
}

/// Provide reasonable default handling for a CORS-enabled request for those who 'JUST WANT IT TO WORK'
ClassMethod HandleDefaultCorsRequest(pURL As %String) As %Status [ Internal, Private ]
{
	Set tSC = $$$OK
	try {
		// Get the origin
		Set inStream = $$$EnsJobLocal("REST.InStream")
		Set outStream = $$$EnsJobLocal("REST.OutStream")
		Set origin=$Get(inStream.Attributes("Origin"))
		If origin'="" {
			// Allow requested origin
			Set:""=$Get(outStream.Attributes("Access-Control-Allow-Origin")) outStream.Attributes("Access-Control-Allow-Origin") = origin

			// Set Allow-Credentials to true
			Set:""=$Get(outStream.Attributes("Access-Control-Allow-Credentials")) outStream.Attributes("Access-Control-Allow-Credentials") = "true"
		}
		// Allow requested headers
		Set headers=$Get(inStream.Attributes("Access-Control-Request-Headers"))
		Set:""=$Get(outStream.Attributes("Access-Control-Allow-Headers")) outStream.Attributes("Access-Control-Allow-Headers") = headers

		// Allow requested method
		Set method=$Get(inStream.Attributes("Access-Control-Request-Method"))
		Set:""=$Get(outStream.Attributes("Access-Control-Allow-Methods")) outStream.Attributes("Access-Control-Allow-Methods") = method
	} catch {
		Set tSC=$$$SystemError
	}
	Quit tSC
}

/// Issue a '405' error ( user can override)
ClassMethod Http405(pSupportedVerbs As %String = "") As %Status
{
	Set outStream = $$$EnsJobLocal("REST.OutStream")
	Set outStream.Attributes("ResponseCode")=..#HTTP405METHODNOTALLOWED
	Set outStream.Attributes("Allow")=pSupportedVerbs
	Set outStream.Attributes("Content-Type")=""
	Quit $$$OK
}

/// Issue an HTTP error
ClassMethod ReportHttpStatusCode(pHttpStatus, pSC As %Status = {$$$OK}) As %Status
{
		//Set %response.Status=pHttpStatus
	Set outStream = $$$EnsJobLocal("REST.OutStream")
	Set outStream.Attributes("ResponseCode")=pHttpStatus
	If $$$ISERR(pSC) {
		Set outStream.Attributes("Content-Type")=..#CONTENTTYPEJSON
		Set tSC = ..StatusToProxyObject(pSC, .tJSON)  Quit:$$$ISERR(tSC) tSC
		Set tSC = ##class(Ens.Util.JSON).ObjectToJSONStream(tJSON,outStream)  Quit:$$$ISERR(tSC) tSC
	}
	Quit $$$OK
}

}
