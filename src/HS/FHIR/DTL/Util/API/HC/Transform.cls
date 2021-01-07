Include Ensemble

Class HS.FHIR.DTL.Util.API.HC.Transform
{

/// API Method
/// Transform an HS.SDA3.Container object or stream into a STU3 Bundle stream using the SDA3->STU3 transformations.
/// <var>container</var> - Either a stream with an XML representation of a Container, or an object of type HS.SDA3.Container
/// <var>bundle</var> - Output of the method. A Bundle stored in a stream.
/// <var>bundleType</var> - "transaction" or "batch". See https://www.hl7.org/fhir/http.html#transaction
/// <var>format</var> - "json" or "xml". Note - json performance will always be better than xml.
/// <var>callbackObject</var> - An instance of a callback class that extends HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3
/// that can be used to customize certain aspects of the transformation. Leaving this parameter blank will result in the default
/// implementations being used. Documentation for available customizations can be found in the abstract class definition.
/// <var>validationErrors</var> - List of any errors encountered when performing validation on the Bundle.
ClassMethod SDA3ToSTU3Stream(container, Output bundle As %Stream.Object, bundleType As %String, format As %String, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3 = "", Output validationErrors As HS.Types.FHIR.Errors) As %Status
{
	set tSC = $$$OK
	try {
		set tSC = ..SDA3ToSTU3Helper(container,, .bundle, bundleType, format, callbackObject, .validationErrors)
		quit:$$$ISERR(tSC)
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// API Method
/// Transform an HS.SDA3.Container object or stream into a STU3 Bundle object using the SDA3->STU3 transformations.
/// <var>container</var> - Either a stream with an XML representation of a Container, or an object of type HS.SDA3.Container
/// <var>bundle</var> - Output of the method. A Bundle stored in HS.FHIR.DTL.vSTU3.Model.Resource.Bundle format.
/// <var>bundleType</var> - "transaction" or "batch". See https://www.hl7.org/fhir/http.html#transaction
/// <var>format</var> - "json" or "xml"
/// <var>callbackObject</var> - An instance of a callback class that extends HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3
/// that can be used to customize certain aspects of the transformation. Leaving this parameter blank will result in the default
/// implementations being used. Documentation for available customizations can be found in the abstract class definition.
/// <var>validationErrors</var> - List of any errors encountered when performing validation on the Bundle.
ClassMethod SDA3ToSTU3Object(container, Output bundle As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, bundleType As %String, format As %String, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3 = "", Output validationErrors As HS.Types.FHIR.Errors) As %Status
{
	set tSC = $$$OK
	try {
		set tSC = ..SDA3ToSTU3Helper(container, .bundle,, bundleType, format, callbackObject, .validationErrors)
		quit:$$$ISERR(tSC)
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Common processing for the SDA3 to STU3 methods
ClassMethod SDA3ToSTU3Helper(container, Output bundleObject As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, Output bundleStream As %Stream.Object, bundleType As %String, format As %String, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3 = "", Output validationErrors As HS.Types.FHIR.Errors) As %Status
{
	set tSC = $$$OK
	try {
		if '$isobject(container) {
			set tSC = $$$ERROR($$$GeneralError, "Container is not valid object")
			quit
		}
		if '((container.%Extends("HS.SDA3.Container")) || (container.%Extends("%Stream.Object"))) {
			set tSC = $$$ERROR($$$GeneralError, "Container must be SDA3 Container or stream object")
			quit
		}
		
		set format = $zconvert(format, "L")
		if '((format = "json") || (format = "xml")) {
			set tSC = $$$ERROR($$$GeneralError, "Invalid format specified. Must be either 'json' or 'xml'")
			quit
		}
		if '((bundleType = "transaction") || (bundleType = "batch")) {
			set tSC = $$$ERROR($$$GeneralError, "Invalid bundle type specified. Must be either 'transaction' or 'batch'")
			quit
		}
		
		if '$isobject(callbackObject) {
			set callbackObject = ##class(HS.FHIR.DTL.Util.API.HC.Callback.Default.SDA3ToSTU3).%New()
		}
		if 'callbackObject.%Extends("HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3") {
			set tSC = $$$ERROR($$$GeneralError, "Callback object must extend HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3")
			quit
		}
		
		set $ze = ""
		set bundleObject = ##class(HS.FHIR.DTL.vSTU3.Model.Resource.Bundle).%New()
		
		if container.%Extends("HS.SDA3.Container") {
			set tSC = ..SDA3ObjectToSTU3Helper(container, .bundleObject, callbackObject)
		} else {
			set tSC = ..SDA3StreamToSTU3Helper(container, .bundleObject, callbackObject)
		}
		quit:$$$ISERR(tSC)
		set bundleObject.type = bundleType
		
		set tSC = ##class(HS.FHIR.DTL.Util.HC.Transform).ProcessBundle(.bundleObject, callbackObject)
		quit:$$$ISERR(tSC)
		
		if format = "json" {
			set bundleStream = bundleObject.ToJSON()
		} else {
			set bundleStream = bundleObject.ToXML()
		}
		
		// Do schema-based validation on the resource.
		kill validationErrors
		do ##class(HS.FHIR.Validation.ResourceValidator).ValidateResource(format, bundleStream, "HS.FHIR.vSTU3.Model.Resource", , .validationErrors)
		for i=1:1:validationErrors.Errors.Count() {
			$$$LOGALERT("Validation error: " _ validationErrors.Errors.GetAt(i).DetailsText _ $char(13, 10) _ "Location: " _ validationErrors.Errors.GetAt(i).Location)
		}
		
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Do SDA3 to FHIR STU3 transform using SDA3 Container object and Bundle transformation.
ClassMethod SDA3ObjectToSTU3Helper(container As HS.SDA3.Container, Output bundleObject As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3) As %Status [ Internal ]
{
	set tSC = $$$OK
	try {
		set aux("callbackObject") = callbackObject
		
		set tSC = ##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.SDA3.vSTU3.Container.Bundle", container, .bundleObject, .aux)
		quit:$$$ISERR(tSC)

	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Do SDA3 to FHIR STU3 transform using SDA3 Container stream and individually called Bundle entry transformations.
ClassMethod SDA3StreamToSTU3Helper(container As %Stream.Object, Output bundleObject As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3) As %Status [ Internal ]
{
	set tSC = $$$OK
	try {
		set aux("callbackObject") = callbackObject
		
		// tSDAContainer: SDA3 Container instance for running instance methods InitializeXMLParse() and GetNextSDA().
		// tSDAObj      : Current individual SDA object instantiated from the SDA stream.
		// tSDAType     : SDA type (Patient, Encounter, Observation, etc.) of current SDA object.
		
		set tSDAContainer = ##class(HS.SDA3.Container).%New()
		set tSC = tSDAContainer.InitializeXMLParse(container, "SDA3")
		quit:$$$ISERR(tSC)
		
		while tSDAContainer.GetNextSDA(.tSDAType, .tSDAObj, .tSC) {
			quit:$$$ISERR(tSC)
			if tSDAType = "Medication" {
				set tBundleEntry = ##class(HS.FHIR.DTL.Util.SDA3.Handler.Container).Medication(tSDAObj, .aux, .bundleObject)
				set tSC = bundleObject.entry.Insert(tBundleEntry)
				quit:$$$ISERR(tSC)
				
			}
			else {
				set tTransformClass = "HS.FHIR.DTL.SDA3.vSTU3."_tSDAType_".Bundle.entry"
				if '##class(%Dictionary.ClassDefinition).%ExistsId(tTransformClass) {
					kill tSDAObj
					continue
				}
				set tBundleEntry = ##class(HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry).%New()
				set tSC = ##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL(tTransformClass, tSDAObj, .tBundleEntry, .aux)
				quit:$$$ISERR(tSC)
				set tSC = bundleObject.entry.Insert(tBundleEntry)
				quit:$$$ISERR(tSC)
			}
			kill tSDAObj
		}
		quit:$$$ISERR(tSC)
		
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// API Method
/// Transform an Bundle object or stream into a
/// Container stream using the STU3->SDA3 transformations.
/// <var>bundle</var> - Either a stream with a json or xml serialized representation of the bundle,
/// or an object of type HS.FHIR.DTL.vSTU3.Model.Resource.Bundle. Note - json performance will always be better than xml.
/// <var>container</var> - Output of the method. A Container stored in a stream.
/// <var>callbackObject</var> - An instance of a callback class that extends HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3
/// that can be used to customize certain aspects of the transformation. Leaving this parameter blank will result in the default
/// implementations being used. Documentation for available customizations can be found in the abstract class definition.
ClassMethod STU3ToSDA3Stream(bundle, Output container As %Stream.Object, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3 = "") As %Status
{
	set tSC = $$$OK
	try {
		set tSC = ..STU3ToSDA3Object(bundle, .containerObject, callbackObject)
		quit:$$$ISERR(tSC)
		
		set tSC = containerObject.XMLExportToStream(.container)
		quit:$$$ISERR(tSC)
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// API Method
/// Transform an Bundle object or stream into a
/// Container object using the STU3->SDA3 transformations.
/// <var>bundle</var> - Either a stream with a json or xml serialized representation of the bundle,
/// or an object of type HS.FHIR.DTL.vSTU3.Model.Resource.Bundle
/// <var>container</var> - Output of the method. A Container stored in an HS.SDA3.Container object.
/// <var>callbackObject</var> - An instance of a callback class that extends HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3
/// that can be used to customize certain aspects of the transformation. Leaving this parameter blank will result in the default
/// implementations being used. Documentation for available customizations can be found in the abstract class definition.
ClassMethod STU3ToSDA3Object(bundle, Output container As HS.SDA3.Container, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3 = "") As %Status
{
	set tSC = $$$OK
	try {
		if '$isobject(bundle) {
			set tSC = $$$ERROR($$$GeneralError, "Bundle is not valid object")
			quit
		}
		if bundle.%Extends("%Stream.Object") {
			set tSC = ##class(HS.HC.Util).GetFormatFromData(bundle, .format)
			if $$$ISERR(tSC) quit
			if format = "json" {
				set obj = ##class(HS.FHIR.DTL.vSTU3.Model.Resource.Bundle).FromJSON(bundle)
			} else {
				set obj = ##class(HS.FHIR.DTL.vSTU3.Model.Resource.Bundle).FromXML(bundle)
			}
			set bundle = obj
			if '$isobject(bundle) {
				set tSC = $$$ERROR($$$GeneralError, "Bundle could not be instantiated")
				quit
			}
		}
		
		if $classname(bundle) '= "HS.FHIR.DTL.vSTU3.Model.Resource.Bundle" {
			set tSC = $$$ERROR($$$GeneralError, "Bundle object must be of type 'HS.FHIR.DTL.vSTU3.Model.Resource.Bundle'")
			quit
		}
		
		new %encounterIds
		new %externalIds
		
		if '$isobject(callbackObject) {
			set callbackObject = ##class(HS.FHIR.DTL.Util.API.HC.Callback.Default.STU3ToSDA3).%New()
		}
		if 'callbackObject.%Extends("HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3") {
			set tSC = $$$ERROR($$$GeneralError, "Callback object must extend HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3")
			quit
		}
		set aux("callbackObject") = callbackObject
		set aux("isContained") = 0
		
		set tSC = ##class(HS.FHIR.DTL.Util.HC.Transform).PreProcess(bundle, .aux)
		quit:$$$ISERR(tSC)
		
		set $ze = ""
		set container = ##class(HS.SDA3.Container).%New()
		set tSC = ##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.vSTU3.SDA3.Bundle.Container", bundle, .container, .aux)
		quit:$$$ISERR(tSC)
		
		if 'container.IsDefined("Patient") {
			set tSC = $$$ERROR($$$GeneralError, "Patient resource/streamlet not found")
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
