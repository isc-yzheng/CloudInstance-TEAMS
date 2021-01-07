/// A series of measurements taken by a device, with upper and lower limits. There may be more than one dimension in the data.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.SampledData Extends HS.FHIR.vSTU3.Model.Base.Element [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SampledData";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

/// The base quantity that a measured value of zero represents. In addition, this provides the units of the entire measurement series.
Property origin As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "origin", XMLPROJECTION = "ELEMENT") [ Required ];

/// The length of time between sampling times, measured in milliseconds.
Property period As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

/// A correction factor that is applied to the sampled data points before they are added to the origin.
Property factor As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "factor", XMLPROJECTION = "ELEMENT");

/// The lower limit of detection of the measured points. This is needed if any of the data points have the value "L" (lower than detection limit).
Property lowerLimit As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "lowerLimit", XMLPROJECTION = "ELEMENT");

/// The upper limit of detection of the measured points. This is needed if any of the data points have the value "U" (higher than detection limit).
Property upperLimit As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "upperLimit", XMLPROJECTION = "ELEMENT");

/// The number of sample points at each time point. If this value is greater than one, then the dimensions will be interlaced - all the sample points for a point in time will be recorded at once.
Property dimensions As HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "dimensions", XMLPROJECTION = "ELEMENT") [ Required ];

/// A series of data points which are decimal values separated by a single space (character u20). The special values "E" (error), "L" (below detection limit) and "U" (above detection limit) can also be used in place of a decimal value.
Property data As HS.FHIR.vSTU3.Model.Datatype.SampledDataDataType(XMLNAME = "data", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "origin" property.
Method SetOrigin(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..origin = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "period" property.
Method SetPeriod(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..period = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "factor" property.
Method SetFactor(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..factor = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "lowerLimit" property.
Method SetLowerLimit(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..lowerLimit = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "upperLimit" property.
Method SetUpperLimit(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..upperLimit = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "dimensions" property.
Method SetDimensions(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..dimensions = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "data" property.
Method SetData(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.SampledDataDataType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR SampledDataDataType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..data = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
