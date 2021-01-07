Class HS.FHIR.DTL.Util.Execute [ Abstract ]
{

/// The className input to ExecuteDTL is the full package and class name of a
/// standard DTL class. className must be prefixed with either the configured
/// standard DTL package name or the configured custom package name.
/// Otherwise ExecuteDTL throws an error.
/// <p>
/// ExecuteDTL looks to see if the corresponding custom DTL class exists, 
/// and executes the custom class if found, otherwise executes the standard
/// product DTL. If neither is found, then ExecuteDTL throws an error.
/// <p>
/// ExecuteDTL calls the Transform method in that DTL class.
/// ExecuteDTL passes the input source and aux values unchanged to Transform.
ClassMethod ExecuteDTL(className As %String, source As %RegisteredObject, ByRef target As %RegisteredObject, ByRef aux = "") As %Status
{
	set runclassName = ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetDTLPackageAndClass(className)
	if (runclassName = "") {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "Invalid DTL class name "_$Select(className'="":className,1:"(blank)")_" specified"))
	}
	set tSC = $classmethod(runclassName, "Transform", source, .target, .aux)
	$$$ThrowOnError(tSC)
	quit tSC
}

/// API
/// ExecuteStandardClass provides a simple means for invoking the standard product
/// version of a transformation class from the customized version of that product
/// class. This method facilitates implementing customizations simply as post-
/// processors or pre-processors. This method depends on transformation config
/// definitions established in the local namespace.<br>
/// This method will NOT work with the FHIR DSTU2 transform classes that are
/// located in the HS.FHIR.DTL.FromSDA and HS.FHIR.DTL.ToSDA packages. It will
/// work with the newer transform classes.<br>
/// Input:<br>
/// <li>className : Name of the calling class.
/// <li>source    : Transformation source object instance.
/// <li>target    : Transformation target object instance.
/// <li>aux       : Auxiliary data.
ClassMethod ExecuteStandardClass(className As %String, source As %RegisteredObject, ByRef target As %RegisteredObject, ByRef aux = "") As %Status
{
	Set tSC = $$$OK
	
	// aux should already include the callback object.
	
	// If all of these conditions are true, then call the standard version of className:
	// - Standard package name is configured
	// - Custom package name is configured
	// - className is in the custom package
	// - Derived standard class exists
	
	// Throw an error, rather than set it into tSC and return, so that the Transform()
	// call that is calling this method gets the error properly handled.
	
	// Buffer StandardPackage in aux.
	If $Get(aux("StandardPackage"))="" {
		Set aux("StandardPackage") = ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetStandardDTLPackage()
		If aux("StandardPackage")="" {
			$$$ThrowOnError($$$ERROR($$$GeneralError, "Standard transformation class package definition is not configured"))
		}
	}
	
	// Buffer CustomPackage in aux.
	If $Get(aux("CustomPackage"))="" {
		Set aux("CustomPackage") = ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetCustomDTLPackage()
		If aux("CustomPackage")="" {
			$$$ThrowOnError($$$ERROR($$$GeneralError, "Custom transformation class package definition is not configured"))
		}
	}
	
	// Buffer CustomClass-StandardClass association in aux.
	If $Get(aux("StandardClass", className))="" {
		// If the current class name does not start with the custom package name, then error.
		If $Extract(className, 1, $Length(aux("CustomPackage")))'=aux("CustomPackage") {
			$$$ThrowOnError($$$ERROR($$$GeneralError, "Specified custom class is not in the configured custom class package"))
		}
		
		// Replace the custom package name with the standard package name.
		Set tStandardClassName = aux("StandardPackage")_$Extract(className,$Length(aux("CustomPackage"))+1,*)
		
		If ##class(%Dictionary.ClassDefinition).%ExistsId(tStandardClassName) {
			Set aux("StandardClass", className) = tStandardClassName
		} Else {
			$$$ThrowOnError($$$ERROR($$$GeneralError, "Derived standard class '"_tStandardClassName_"' not found"))
		}
	}
	
	// This calls directly to the Transform() method of the standard class.
	// Does not use ExecuteDTL(), which would cause infinite loop in this case.
	Set tSC = $ClassMethod(aux("StandardClass", className), "Transform", source, .target, .aux)
	$$$ThrowOnError(tSC)
	
	Quit tSC
}

}
