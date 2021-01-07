Include %ZHSLIB

Class HS.UI.BaseUtil Extends %ZEN.Component.page
{

Parameter HSDEPLOY = 1;

/// This text can be displayed on browser tab as the title next to the small favoriate icon. <br>
/// To display it, you need to define the title attribute for a Zen page in the XData Contents in this fashion:<br>
/// E.g: <page xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#">
Property StdTitle As %ZEN.Datatype.string [ InitialExpression = {$P($ZU(86),"*",2) _" - "_$Case(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance(),1:"HealthShare",:"Health")} ];

/// Utility Method used by $$$HSUILink and $$$HSUILinkQuery and $$$HSUILinkNS
ClassMethod HSUILink(pKey, pDefault, ByRef pQuery, pNamespace As %String = "") As %String
{
	Set:$E(pKey,1,4)'="\UI\" pKey="\UI\"_pKey
	If '$D(%session.Data("UILink",pKey),tURL) {
		If pNamespace'="",'$D(^%SYS("HealthShare","Instances",$NAMESPACE)) {
			//called from UI home in HSLIB, so it needs to look in a real namespace to find the config registry
			Set tURL=##Class(%ZHSLIB.SessionEventUtil).GetRegistryConfigValue(pKey,pDefault)
		} Else {
			Set tURL=##class(HS.Registry.Config).GetKeyValue(pKey,pDefault)
		}
		Set %session.Data("UILink",pKey)=tURL
	}
	Quit:tURL="" ""
	
	If '..%CheckHSClass(tURL) Quit ""
	Set:pNamespace'="" tURL=pNamespace_"/"_tURL
	Quit ..Link(tURL,.pQuery)
}

ClassMethod %OnPreHTTP() As %Boolean [ Final, ServerOnly = 1 ]
{
	#dim %request As %CSP.Request
	If ($UserName = "UnknownUser") {
		Set %zenPageError = $$Error^%apiOBJ(822,$ZE)
		Set %session.AppTimeout=1
		Set %response.Status = "403 Forbidden"
	} ElseIf '..%CheckHSClass() {
		Set %zenPageError = $$Error^%apiOBJ(6083,$ZE)
	} Else {
		#if ##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance()
			Set sc = $$$OK
			Try {
				// Check if CSPOAUTH2 parameter is defined and remove if so
				Set oAuthQueryParam = ##class(%ZHS.OAuth2.UI.Login).#SessionQueryParameter
				If ($Get(%request.Data(oAuthQueryParam, 1)) '= "") {
					Set originalQueryParams = $Get(%request.CgiEnvs("QUERY_STRING"))
					Set originalQueryParamsList = $ListFromString(originalQueryParams, "&")
					Set redirectQueryParamsList = ""
					Set ptr = 0
					While $ListNext(originalQueryParamsList, ptr, param) {
						If ($Piece(param, "=", 1) '= oAuthQueryParam) {
							Set redirectQueryParamsList = redirectQueryParamsList _ $ListBuild(param)
						}
					}
					Set %response.Redirect = %request.URL _ "?" _ $ListToString(redirectQueryParamsList, "&")
					Return 1
				}
				// Do token validation. If invalid, then quit
				Set isValid = ##class(HS.OAuth2.Client.Utils).DoTokenValidation($Get(%session))
				If 'isValid {
					Return 1
				}
			} Catch ex {
				Set sc = ex.AsStatus()
				Set %zenPageError = sc
			}
		#endif
	}
	Quit ..%OnHSPreHTTP()
}

/// Event handler which is invoked before a hyperevent method is called on all Zen pages.
/// This dispatched to a common PreHyperEvent handler.<br/>
/// If an application overrides this method, then it <em>must</em> invoke this base implementation
/// code (using ##super).
ClassMethod OnPreHyperEvent(class As %String, method As %String) As %Status [ ServerOnly = 1 ]
{
	Set sc = $$$OK
	Try {
		#if ##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance()
			// Do token validation. If invalid, then quit
			Set isValid = ##class(HS.OAuth2.Client.Utils).DoTokenValidation($Get(%session))
			If 'isValid {
				Quit
			}
		#endif
		Set sc = ##class(%ZEN.Controller).OnPreHyperEvent($classname(),$G(method),+..#AUTONS,..#RESOURCE)
		$$$ThrowOnError(sc)
	} Catch ex {
		Set sc = ex.AsStatus()
	}
	Return sc
}

ClassMethod %CheckHSClass(pClassName = {..%ClassName(1)}) As %Boolean [ ServerOnly = 1 ]
{
	Set tClassName=$p(pClassName,".cls")
	Quit:tClassName="" 1
	Try {
		Set tLic=$Parameter(tClassName,"LICENSEDPRODUCT")
	} catch ex {
		Set tLic=""
	}
	If tLic="" Quit 1
	Set tGood=0
	If tLic["," {
		Set tGood=0
		For tI=1:1:$L(tLic,",") If $$$HSLicensed($P(tLic,",",tI)) Set tGood=1 Quit
		Quit tGood
	} Else {
		Set tGood=1
		For tI=1:1:$L(tLic,"&") If '$$$HSLicensed($P(tLic,"&",tI)) Set tGood=0 Quit
		Quit tGood
	}
}

ClassMethod %OnHSPreHTTP() As %Boolean [ CodeMode = expression, ServerOnly = 1 ]
{
1
}

Method %OnDrawHTMLMeta() As %Status
{
	//Prevent page from being tracked by search engines
	&html<<META NAME="ROBOTS" CONTENT="NOINDEX,NOFOLLOW,NOARCHIVE"/> >
	Quit $$$OK
}

/// Return 1 if the string is improperly formatted.
/// No apostrophes
ClassMethod CheckFormatting(string) As %Boolean [ ZenMethod ]
{
	Set (x,i,space,apos,invalid)=""
	For i=1:1 
		{
		s x=$e(string,i)
		q:x=""
		// Remove check for spaces
		//i x?1" " s space=1
		i x?1"'" s apos=1
		i space_apos '= "" {
			s invalid = 1
			quit
		}
	}
	quit invalid
}

/// If in the Nav Frame, return true, otherwise return false.
ClientMethod inNavFrame() [ Language = javascript ]
{
  if (!!sessionStorage.getItem('inNavFrame')) {
    return true;
  }
  else {
    var url = window.location.href;
    var parentFrameIsNavApp = url.indexOf("inNavFrame=1") !== -1;
    if (parentFrameIsNavApp) {
      sessionStorage.setItem('inNavFrame', true);
      return true;
    }
    else {
      return false;
    }
  }
}

/// Helper method to simplify the logic for calling a parent function by using ISC-Frame postEvent function
/// with parameters <var>eventName<var> and one <var>argument<var>. This argument could be a string, boolean or object.
ClientMethod postMessageToParent(eventName, arg) [ Language = javascript ]
{
	if ((typeof window.parentFrameApi !== 'undefined') &&  
		(!!window.parentFrameApi.parentDomain)) {
		window.parentFrameApi.postEvent(eventName, arg);
	}
}

/// Helper method to notify a parent frame that a child frame is going to log out.
ClientMethod triggerLogoutNotification() [ Language = javascript ]
{
	this.postMessageToParent('childLogout', '');
}

/// Callback that tells the parent that the child is still showing a valid page. 
/// If we are showing some other page, like the login page or a non-HealthShare page, 
/// this function won't exist, so we won't tell the parent that this page is active.
ClientMethod checkChildStatus() [ Language = javascript ]
{
	window.HS_UI_BaseUtil_postMessageToParent('childIsActive');
}

/// Callback that updates the parent with the child active URL
ClientMethod pollChildUrl() [ Language = javascript ]
{
	window.HS_UI_BaseUtil_postMessageToParent('childUrlUpdate', window.location.href);
}

/// Received event from the nav app to log out, log out
ClientMethod logoutChild() [ Language = javascript ]
{
	window.sessionStorage.clear();
	document.location = 'HS.UI.Logout.cls';
	window.HS_UI_BaseUtil_postMessageToParent('childLogout');
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	
	var self = this;
	
	function onInit() {
		if ((typeof ISCFrame !== 'undefined') && (typeof ISCFrame.Child !== 'undefined')) {
			var options = {
				messageHandlers: {
					checkChildStatus: self.checkChildStatus,
					pollChildUrl: self.pollChildUrl,
					logoutChild: self.logoutChild
				}
			};
			
			window.parentFrameApi = new ISCFrame.Child( options );
		}
	}
	
	onInit();
}

Method %OnDrawHTMLHead() As %Status
{
    set tSC = ##super()
    if $$$ISERR(tSC) {
	    quit tSC
    }

    // write the script tag to the HTML header if it's a HealthShare instance
    If ##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance() {
  		&html<<script type="text/javascript" src="zenIscFrame.js"></script>>
	}
                    
    quit $$$OK
}

}
