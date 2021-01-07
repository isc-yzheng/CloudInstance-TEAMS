/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Adapter for sending HTTP requests to a designated HTTP server, with HTTP headers, URL, form variables and cookies if so invoked
Class EnsLib.HTTP.OutboundAdapter Extends Ens.OutboundAdapter [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// IP address of the server to send HTTP requests to.
Property HTTPServer As %String(MAXLEN = 1000) [ Required ];

/// TCP Port on the server to send HTTP requests to (will use 80 by default, or 443 if SSLConfig is specified)
Property HTTPPort As %Integer(MAXVAL = 65535, MINVAL = 0);

/// The name of an existing SSL/TLS system configuration set to use (Secure Socket Layer / Transport Layer Security, configured via the system portal's Security Management page).
/// <p>If your SSL Configuration requires you to supply a password for the local private key file, specify it in 
/// the Private key password property of the SSL/TLS Configuration.
Property SSLConfig As %String;

/// When making an SSL connection check the server identity in the certificate matches the name of the system we are connecting to.
/// This defaults to being on and matches based on the rules layed out in section 3.1 of RFC 2818.
Property SSLCheckServerIdentity As %Boolean [ InitialExpression = 1 ];

/// Proxy server through which to send HTTP requests, if any
Property ProxyServer As %String(MAXLEN = 1000);

/// Proxy server port on which to send HTTP requests, if using a proxy server (will use 8080 by default)
Property ProxyPort As %Integer(MAXVAL = 65535, MINVAL = 0);

/// Should the proxy (if any) use HTTPS to communicate with the real HTTP/HTTPS server?
Property ProxyHTTPS As %Boolean;

/// Should the Adapter use the HTTP CONNECT command to establish a tunnel through the proxy to the target HTTP server?
Property ProxyHttpTunnel As %Boolean [ InitialExpression = 0 ];

/// URL path to request from the server (not including 'http://' or server address) <ul>
/// <li>If set to empty or '*' and used on a GenericOperation, this setting will employ the HTTPHeaders array value for the key 'URL' (case insensitive) contained in the GenericMessage being processed.</li>
/// <li>If this value starts with '^' and is used on a GenericOperation, this setting will remove the Application attribute from the URL of the GenericMessage being processed and replace it with the remaining portion of this value if any.
///     If combined with '*' the '^' should come first.</li>
/// <li>If this value starts with '|' and is used on a GenericOperation, this setting will remove the Application and ConfigName attributes from the URL of the GenericMessage being processed and replace them with the remaining portion of this value if any.
///     If combined with '*' the '|' should come first.</li></ul>
Property URL As %String(MAXLEN = 1000) [ Required ];

/// This is the ID name of the set of credentials values (Username, Password) to be used to access the HTTP server
Property Credentials As %String [ InitialExpression = "None" ];

/// Save Cookies received in HTTP responses while this adapter is instantiated, and insert them in each subsequent HTTP request.
Property UseCookies As %Boolean [ InitialExpression = 0 ];

/// Number of seconds to wait on each connection attempt
Property ConnectTimeout As %Numeric(MINVAL = 0) [ InitialExpression = 5 ];

/// Timeout for getting a response from the server (the timeout for opening the connection to the server is always 5 seconds). Setting the timeout to -1 means wait forever.
Property ResponseTimeout As %Numeric(MINVAL = -1) [ InitialExpression = 30, Required ];

/// Set this to the timeout to use when writing to the remote HTTP server.<br>
/// The default is -1 means it will wait indefinitely for the remote server to accept the
/// written data, change it to another value to specify the timeout in seconds.
Property WriteTimeout As %Numeric(MINVAL = -1) [ InitialExpression = -1 ];

/// In a multi-homed system, specify which network interface the TCP connection should go through.  An empty value means to use any interface. <br/>
/// To be able to bind to IPv6 interfaces you may need to enable IPv6 in your instance.  This is done in the System Management Portal under 
/// System Administration > Configuration > Additional Settings > Startup, by editing the IPv6 setting.
Property LocalInterface As %String(MAXLEN = 250);

/// These are the production settings for this object
Parameter SETTINGS = "RegistryID:Basic:selector?context={Ens.ServiceRegistry.External.ContextSearch/Services?Protocols_1=REST&Protocols_2=HTTP},HTTPServer:Basic,HTTPPort:Basic,SSLConfig:Connection:sslConfigSelector,SSLCheckServerIdentity:Connection,LocalInterface:Connection:selector?context={Ens.ContextSearch/TCPLocalInterfaces},ProxyServer:Connection,ProxyPort:Connection,ProxyHTTPS:Connection,ProxyHttpTunnel:Connection,URL:Basic,Credentials:Basic:credentialsSelector,UseCookies,ConnectTimeout:Connection,ResponseTimeout:Connection,WriteTimeout:Connection";

/// Array of Cookies. Indexed by Domain/Server; each element is $LB(name, domain, path, value, expires, secure)
Property %Cookies As %String [ MultiDimensional, Transient ];

/// A comma-separated list of body stream attribute names that should not be copied to the outbound HTTP header.
/// The default value of "*" means to skip all, i.e. to copy none.
/// If this value is empty and the input stream is a %Library.AbstractStream subclass, then double copying of
/// the stream data will be avoided by passing the stream object directly through to the %Net.HttpRequest.Send() method.
Property SkipBodyAttrs As %String [ InitialExpression = "*" ];

/// This is the debug flag setting (0 do nothing, 1 show request, 2 show request/response)
Parameter DEBUG As %Integer = 0;

/// Send a POST to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. To use a request Body
/// instead of form variables, leave <var>pFormVarNames</var> empty and pass the body text as the <var>pData</var> argument.
/// Otherwise, for each name in the list, a <var>pData</var> argument should be supplied. If you need to pass multiple
/// values for any form variable, you can put the name of that variable multiple times in the <var>pFormVarNames</var> list.
/// Also, any extra <var>pData</var> arguments you supply will be assigned to the last form variable in the list.
///  
///  Note: A Data value passed for body text may be of either String type or Stream. Data values
///   passed for form variables must be of String type.
Method Post(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"POST",,.pFormVarNames,.pData)
}

Method PostURL(pURL As %String, Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"POST",,.pFormVarNames,.pData,pURL)
}

/// Send a POST to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. For each name in the list,
/// a <var>pData</var> argument should be supplied. The <var>pData</var> argument is an array. The top node of the array is not used. Each sub-node
/// is subscripted by the index of the
/// form variable from the <var>pFormVarNames</var> list that it corresponds to. The value at that subscript
/// is the form data for that variable. For single-valued form variables this value is just the value. In
/// this case this node should have no sub-nodes.
/// For multiple valued form variables, the value at this node should be the count of form variable values,
/// and each of the values for this form variable should appear in a sub-node, subscripted by its position in the node.
Method PostFormDataArray(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, ByRef pData) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"POST",,.pFormVarNames,.pData)
}

/// Send a GET to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. To use a request Body
///  instead of form variables, leave <var>pFormVarNames</var> empty and pass the body text as the <var>pData</var> argument. Otherwise,
///  for each name in the list, a <var>pData</var> argument should be supplied. If you need to pass multiple
///  values for any form variable, you can put the name of that variable multiple times in the <var>pFormVarNames</var> list.
///  Also, any extra <var>pData</var> arguments will be assigned to the last form variable in the list.
///  
///  Note: Data values passed for body text may be of either String type or Stream. Data values
///   passed for form variables must be of String type.
Method Get(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"GET",,.pFormVarNames,.pData)
}

Method GetURL(pURL As %String, Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"GET",,.pFormVarNames,.pData,pURL)
}

/// Send a GET to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. For each name in the list,
/// a <var>pData</var> argument should be supplied. The <var>pData</var> argument is an array. The top node of the array is not used. Each sub-node
/// is subscripted by the index of the
/// form variable from the <var>pFormVarNames</var> list that it corresponds to. The value at that subscript
/// is the form data for that variable. For single-valued form variables this value is just the value. In
/// this case this node should have no sub-nodes.
/// For multiple valued form variables, the value at this node should be the count of form variable values,
/// and each of the values for this form variable should appear in a sub-node, subscripted by its position in the node.
Method GetFormDataArray(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, ByRef pData) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"GET",,.pFormVarNames,.pData)
}

/// Send a PUT to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. To use a request Body
///  instead of form variables, leave <var>pFormVarNames</var> empty and pass the body text as the <var>pData</var> argument. Otherwise,
///  for each name in the list, a <var>pData</var> argument should be supplied. If you need to pass multiple
///  values for any form variable, you can put the name of that variable multiple times in the <var>pFormVarNames</var> list.
///  Also, any extra <var>pData</var> arguments will be assigned to the last form variable in the list.
///  
///  Note: Data values passed for body text may be of either String type or Stream. Data values
///   passed for form variables must be of String type.
Method Put(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"PUT",,.pFormVarNames,.pData)
}

Method PutURL(pURL As %String, Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"PUT",,.pFormVarNames,.pData,pURL)
}

/// Send a PUT to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. For each name in the list,
/// a <var>pData</var> argument should be supplied. The <var>pData</var> argument is an array. The top node of the array is not used. Each sub-node
/// is subscripted by the index of the
/// form variable from the <var>pFormVarNames</var> list that it corresponds to. The value at that subscript
/// is the form data for that variable. For single-valued form variables this value is just the value. In
/// this case this node should have no sub-nodes.
/// For multiple valued form variables, the value at this node should be the count of form variable values,
/// and each of the values for this form variable should appear in a sub-node, subscripted by its position in the node.
Method PutFormDataArray(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, ByRef pData) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"PUT",,.pFormVarNames,.pData)
}

/// Send a DELETE to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. To use a request Body
///  instead of form variables, leave <var>pFormVarNames</var> empty and pass the body text as the <var>pData</var> argument. Otherwise,
///  for each name in the list, a <var>pData</var> argument should be supplied. If you need to pass multiple
///  values for any form variable, you can put the name of that variable multiple times in the <var>pFormVarNames</var> list.
///  Also, any extra <var>pData</var> arguments will be assigned to the last form variable in the list.
///  
///  Note: Data values passed for body text may be of either String type or Stream. Data values
///   passed for form variables must be of String type.
Method Delete(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"DELETE",,.pFormVarNames,.pData)
}

Method DeleteURL(pURL As %String, Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"DELETE",,.pFormVarNames,.pData,pURL)
}

/// Send a DELETE to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. For each name in the list,
/// a <var>pData</var> argument should be supplied. The <var>pData</var> argument is an array. The top node of the array is not used. Each sub-node
/// is subscripted by the index of the
/// form variable from the <var>pFormVarNames</var> list that it corresponds to. The value at that subscript
/// is the form data for that variable. For single-valued form variables this value is just the value. In
/// this case this node should have no sub-nodes.
/// For multiple valued form variables, the value at this node should be the count of form variable values,
/// and each of the values for this form variable should appear in a sub-node, subscripted by its position in the node.
Method DeleteFormDataArray(Output pHttpResponse As %Net.HttpResponse, pFormVarNames As %String, ByRef pData) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,"DELETE",,.pFormVarNames,.pData)
}

Method SendFormDataURL(pURL As %String, Output pHttpResponse As %Net.HttpResponse, pOp As %String, pHttpRequestIn As %Net.HttpRequest, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,.pOp,.pHttpRequestIn,.pFormVarNames,.pData,pURL)
}

Method SendFormData(Output pHttpResponse As %Net.HttpResponse, pOp As %String, pHttpRequestIn As %Net.HttpRequest, pFormVarNames As %String, pData...) As %Status [ CodeMode = expression ]
{
..SendFormDataArray(.pHttpResponse,.pOp,.pHttpRequestIn,.pFormVarNames,.pData)
}

/// Send a <var>pOp</var> request ("POST","GET" or "PUT") to the configured Server, Port and URL, sending form data to the named form variables.
/// <var>pFormVarNames</var> is a comma-separated list of form variable names to use. For each name in the list,
/// a <var>pData</var> argument should be supplied. The <var>pData</var> argument is an array. The top node of the array is not used. Each sub-node
/// is subscripted by the index of the
/// form variable from the <var>pFormVarNames</var> list that it corresponds to. The value at that subscript
/// is the form data for that variable. For single-valued form variables this value is just the value. In
/// this case this node should have no sub-nodes.
/// For multiple valued form variables, the value at this node should be the count of form variable values,
/// and each of the values for this form variable should appear in a sub-node, subscripted by its position in the node.
/// For special needs, the <var>pHttpRequestIn</var> argument can be used to pre-populate properties of the %Net.HTTPRequest object used to send the HTTP request.
Method SendFormDataArray(Output pHttpResponse As %Net.HttpResponse, pOp As %String, pHttpRequestIn As %Net.HttpRequest, pFormVarNames As %String = "", ByRef pData, pURL As %String) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Kill pHttpResponse Set pHttpResponse=$$$NULLOREF
	Set pOp=$ZCVT(pOp,"L"),$E(pOp,1,1)=$ZCVT($E(pOp,1,1),"U")
	do {
		#; Create an Http Request Object
		Set tHttpRequest=$S($$$IsdefObject(pHttpRequestIn):pHttpRequestIn,1:##class(%Net.HttpRequest).%New())  $$$ASSERT($IsObject(tHttpRequest)&&tHttpRequest.%IsA("%Net.HttpRequest"))

		#; Send supersession if needed and the HTTP Headers in the request do not include already. Use upper case as GetHeader looks for upper case subscript in Headers array.
		Try {
			If (tHttpRequest.GetHeader($$$EnsHTTPHeaderSuperSessionUC)="") && ..BusinessHost.IncludeSuperSession(.tSC) {
				Do tHttpRequest.SetHeader($$$EnsHTTPHeaderSuperSession,..BusinessHost.%SuperSession)
			}
		} Catch {}
		#; Quit if error generating Super Session
		If $$$ISERR(tSC) Quit

		#; Fill in the server, port etc.
		Set tHttpRequest.Server=..HTTPServer, tHttpRequest.Port=..HTTPPort
		Set tHttpRequest.SSLConfiguration=..SSLConfig, tHttpRequest.Https=(""'=..SSLConfig)
		Set tHttpRequest.SSLCheckServerIdentity=..SSLCheckServerIdentity
		Set tHttpRequest.LocalInterface=..LocalInterface
		Set tHttpRequest.ProxyServer=..ProxyServer, tHttpRequest.ProxyPort=..ProxyPort
		Set tHttpRequest.ProxyHTTPS=..ProxyHTTPS
		Set tHttpRequest.ProxyTunnel=..ProxyHttpTunnel
		Set tHttpRequest.OpenTimeout=$S(..ConnectTimeout=-1:2123456789,1:..ConnectTimeout)
		Set tHttpRequest.Timeout=$S(..ResponseTimeout=-1:2123456789,1:..ResponseTimeout)
		Set tHttpRequest.WriteTimeout=..WriteTimeout

		If '$IsObject(..%CredentialsObj) Do ..CredentialsSet(..Credentials) If '$IsObject(..%CredentialsObj) { Set tSC=$$$EnsError($$$EnsErrNoCredentials,..Credentials) Quit }
		Set tHttpRequest.Username=..%CredentialsObj.Username,tHttpRequest.Password=..%CredentialsObj.Password		

		#; Walk the pData sub-nodes and set values for form data variables
		Set kVal = "" For { Set kVal=$O(pData(kVal)) Quit:""=kVal
			#; Allow indexing by position in pFormVarNames list, or by Form variable name itself
			Set tVarname=$S(kVal=+kVal:$P(pFormVarNames,",",kVal),1:kVal)
			Set:""=tVarname&&(""'=$G(kLastVal)) tVarname = $P(pFormVarNames,",",kLastVal)
			If ""=tVarname { ; if first name in list and name empty
				If $IsObject(pData(kVal)) && (pData(kVal).%Extends("%Stream.Object")||pData(kVal).%Extends("%IO.I.Stream")) {
					Set tLibStream=pData(kVal).%Extends("%Library.AbstractStream")
					If ""=..SkipBodyAttrs && tLibStream {
						Set tHttpRequest.EntityBody = pData(kVal)
					} Else {
						Do tHttpRequest.EntityBody.CopyFrom(pData(kVal))
						If "*"'=$ZStrip(..SkipBodyAttrs,"<>W") && tLibStream {
							Set tCnt=$L(..SkipBodyAttrs,",")  For i=1:1:tCnt { Set tSkip=$ZCVT($ZStrip($P(..SkipBodyAttrs,",",i),"<>W"),"L")  Continue:""=tSkip  Set skips(tSkip)="" }
							Set name=""  For { Set name=pData(kVal).NextAttribute(name)  Quit:""=name
								Do:'$D(skips($ZCVT(name,"L"))) tHttpRequest.EntityBody.SetAttribute(name,pData(kVal).GetAttribute(name))
							}
						}
					}
				}
				Else { Do tHttpRequest.EntityBody.Write(pData(kVal)) }
				Continue
			}
			Set kLastVal=kVal
			If $D(pData(kVal),tValue)=1 { // Has no sub-nodes
				If pOp="Post" { Do tHttpRequest.InsertFormData(tVarname,tValue) }
				Else { Do tHttpRequest.InsertParam(tVarname,tValue) }
			} Else {
				#; Walk the sub-subnodes for multi-valued form vars
				Set kSubVal = "" For { Set kSubVal=$O(pData(kVal,kSubVal),1,tSubValue) Quit:""=kSubVal
					If pOp="Post" Do tHttpRequest.InsertFormData(tVarname,tSubValue)
					Else  Do tHttpRequest.SetParam(tVarname,tSubValue,kSubVal)
				}
			}
		}
		#; Set the Cookies for this domain / server
		If ..UseCookies {
			Set kCookie="" For { Set kCookie = $O(..%Cookies(..HTTPServer,kCookie)) Quit:""=kCookie
				Set lCookie=..%Cookies(..HTTPServer,kCookie)
				$$$sysTRACE("Sending stored Cookie "_kCookie_": ("_$LI(lCookie,1)_":"_$LI(lCookie,2)_":"_$LI(lCookie,3)_":"_$LI(lCookie,4)_":"_$LI(lCookie,5)_":"_$LI(lCookie,6)_")")
				#;lCookie=$LB(1:name, 2:domain, 3:path, 4:value, 5:expires, 6:secure)
				Do tHttpRequest.InsertCookie($LI(lCookie,1),$LI(lCookie,4),$LI(lCookie,3),..HTTPServer,$LG(lCookie,5),$LG(lCookie,6))
			}
		}
		#; Send the Request
		$$$sysTRACE("About to send "_pOp_$S(""'=..ProxyServer&&..ProxyHTTPS:" https ",1:" ")_"request to "_..GetAddress($G(pURL,..URL)))
		Set tSC=tHttpRequest.Send($ZCVT(pOp,"U"),$G(pURL,..URL),..#DEBUG)

		#; Retrieve the response
		Set pHttpResponse=tHttpRequest.HttpResponse

		If $$$ISOK(tSC) && (+pHttpResponse.StatusCode'?1"2"2N) Set tSC=$$$ERROR($$$EnsErrHTTPStatus,pHttpResponse.StatusCode,pHttpResponse.StatusLine)
		#; NO Quit on error; get those cookies anyway if possible

		#; Extract Cookies from the response
		If ..UseCookies {
			#; Filter out expired cookies for this domain, add new ones
			Kill ..%Cookies(..HTTPServer)
			If tHttpRequest.GetFullCookieList(.tCookies) {
				#;Merge ..%Cookies(..HTTPServer) = tCookies
				Set kCookie="" For { Set kCookie = $O(tCookies(kCookie)) Quit:""=kCookie
					Set lCookie=tCookies(kCookie)
					#;lCookie=$LB(1:name, 2:domain, 3:path, 4:value, 5:expires, 6:secure)
					$$$sysTRACE($S($LI(lCookie,2)=..HTTPServer:"",1:"NOT ")_"Storing Cookie "_kCookie_": ("_$LI(lCookie,1)_":"_$LI(lCookie,2)_":"_$LI(lCookie,3)_":"_$LI(lCookie,4)_":"_$LI(lCookie,5)_":"_$LI(lCookie,6)_")")
					Set:$LI(lCookie,2)=..HTTPServer ..%Cookies(..HTTPServer,kCookie)=lCookie
				}
			}
		}
	} while 0
	Set:($$$ISOK(tSC)&&(503=+pHttpResponse.StatusCode))||$$$StatusEquals(tSC,$$$HttpRequestConnect,$$$CSPTimeout) ..BusinessHost.Retry = 1

	#; If we did not already have a %SuperSession value look for it in response.
	#; If we had one and did not send it then we will not update with any received. Use upper case as GetHeader looks for upper case subscript in Headers array.
	If '..BusinessHost.Retry && (..BusinessHost.%SuperSession="") && $IsObject(pHttpResponse) && pHttpResponse.%IsA("%Net.HttpResponse") {
		Set ..BusinessHost.%SuperSession=pHttpResponse.GetHeader($$$EnsHTTPHeaderSuperSessionUC)
	}

Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Delete a particular Cookie
Method DeleteCookie(pName As %String, pPath As %String, pDomain As %String) As %Status
{
	Set kCookie="" For { Set kCookie = $O(..%Cookies(pDomain,kCookie)) Quit:""=kCookie
		Set lCookie=..%Cookies(pDomain,kCookie)
		#;lCookie=$LB(1:name, 2:domain, 3:path, 4:value, 5:expires, 6:secure)
		Kill:$LI(lCookie,1)=pName&&($LI(lCookie,3)=pPath) ..%Cookies(pDomain,kCookie)
	}
	Quit $$$OK
}

/// Delete all cookies from the specified domain and/or path
Method DeleteCookies(pDomain As %String = "", pPath As %String = "") As %Status
{
	If ""=pPath {
		If ""=pDomain { Kill ..%Cookies }
		else { Kill ..%Cookies(pDomain) }
	} else {
		Set:"/"'=$E(pPath,$L(pPath),$L(pPath)) pPath=pPath_"/"
		If ""'=pDomain { Do ..deletePathCookies(pDomain,pPath) }
		else {
			Set kDomain="" For { Set kDomain = $O(..%Cookies(kDomain)) Quit:""=kDomain
				Do ..deletePathCookies(kDomain,pPath)
			}
		}
	}
	Quit $$$OK
}

Method deletePathCookies(pDomain, pPath) [ Private ]
{
	Set kCookie="" For { Set kCookie = $O(..%Cookies(pDomain,kCookie)) Quit:""=kCookie
		#; Kill sub-path cookies too
		Set lCookie=..%Cookies(pDomain,kCookie)
		#;lCookie=$LB(1:name, 2:domain, 3:path, 4:value, 5:expires, 6:secure)
		Kill:$E($LI(lCookie,3),1,$L(pPath))=pPath ..%Cookies(pDomain,kCookie)
	}
}

Method GetAddress(pURL As %String) As %String [ CodeMode = expression, Internal ]
{
..HTTPServer_$S(""=..HTTPPort:"",..HTTPServer[":":"|",1:":")_..HTTPPort_"/"_$G(pURL,..URL)_$S(""=..ProxyServer:"",1:" via "_..ProxyServer_":"_..ProxyPort)
}

Method OnInit() As %Status
{
	Set ..LocalInterface=$ZStrip($P(..LocalInterface,"("),"*W")
	$$$EnsCheckSSLConfig(..SSLConfig)
	Quit $$$OK
}

}
