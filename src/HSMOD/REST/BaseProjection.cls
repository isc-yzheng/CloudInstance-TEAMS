Include HSMOD.REST.Errors

/// Projection class for <class>HSMOD.REST.Base</class> to do class validation. <br />
Class HSMOD.REST.BaseProjection Extends %Projection.AbstractProjection
{

/// This method is called by the Class Compiler whenever an associated 
/// class has finished compiling. <var>classname</var> contains the name of 
/// the associated class while <var>parameters</var> contains an array of the 
/// projection parameters subscripted by parameter name. Also the special parameter value
/// parameters("%qstruct") contains a merge of the qstruct array this projection is being
/// compiled with. The <var>modified</var> is always blank.<br>
/// Any errors reported by this method are reported by the Class Compiler but
/// do not effect class compilation in any way.
ClassMethod CreateProjection(classname As %String, ByRef parameters As %String, modified As %String, qstruct) As %Status [ Internal ]
{
	Set sc = $$$OK
	Try {
		Do ..CheckUrlMapValidity(classname)
	} Catch ex {
		Set sc = ex.AsStatus()
	}
	Return sc
}

/// Checks validity of the UrlMap for the given class <var>pClassname</var>. <br />
ClassMethod CheckUrlMapValidity(pClassname As %Dictionary.Classname) [ Internal ]
{
	Set index = 0
	While 1 {
		Do $Increment(index)
		// Get each route/map in URL map
		// Each value is a $ListBuild of the form: 
		// For routes: "R", path, request type, method call, cors enabling
		// For maps: "M", map prefix, forwarding class
		Set urlMapValue = $ClassMethod(pClassname, "DispatchMap", index)
		If (urlMapValue = "") {
			Quit
		}
		Set type = $ListGet(urlMapValue, 1)
		If (type = "R") {
			/* Route validation */
			Set $ListBuild(, path, requestType, methodCall) = urlMapValue
			
			// Check if method call exists
			If '$$$comMemberDefined(pClassname, $$$cCLASSmethod, methodCall) {
				$$$ThrowStatus($$$ERROR($$$HSModRESTErrRouteMethodCallDoesNotExist, methodCall, requestType, path))
			}
			
			// Count number of path arguments and ensure method accepts at least those many arguments
			Set numberOfPathArguments = $ListLength($ListFromString(path, "([^/]+)")) - 1
			Set formalSpecParsed = $$$comMemberKeyGet(pClassname, $$$cCLASSmethod, methodCall, $$$cMETHformalspecparsed)
			Set formalSpec = $$$comMemberKeyGet(pClassname, $$$cCLASSmethod, methodCall, $$$cMETHformalspec)
			// Check if any argument name contains ... because then any number of arguments can be passed in
			Set allowsExtraArguments = $Find(formalSpec, "...")#2
			Set numberOfArguments = $ListLength(formalSpecParsed)
			If 'allowsExtraArguments && (numberOfArguments < numberOfPathArguments) {
				$$$ThrowStatus($$$ERROR($$$HSModRESTErrRouteMethodCallTooFewArgs, methodCall, requestType, path))
			}
		} ElseIf (type = "M") {
			/* Map validation */
			Set $ListBuild(, path, forwardClass) = urlMapValue
			
			// Check if forwarding class exists
			If '$$$comClassDefined(forwardClass) {
				$$$ThrowStatus($$$ERROR($$$HSModRESTErrMapForwardClassDoesNotExist, forwardClass, $Piece(path, "(", 1)))
			}
		} Else {
			// No validation for any other type (as of now no other type exists)
		}
	}
}

}
