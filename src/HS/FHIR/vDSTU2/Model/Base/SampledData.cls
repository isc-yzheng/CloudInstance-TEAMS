Class HS.FHIR.vDSTU2.Model.Base.SampledData Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SampledData";

Parameter XMLSEQUENCE = 1;

/// The base quantity that a measured value of zero represents. In addition, this provides the units of the entire measurement series.
Property origin As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "origin") [ Required ];

/// The length of time between sampling times, measured in milliseconds.
Property period As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "period") [ Required ];

/// A correction factor that is applied to the sampled data points before they are added to the origin.
Property factor As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "factor");

/// The lower limit of detection of the measured points. This is needed if any of the data points have the value"L" (lower than detection limit).
Property lowerLimit As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "lowerLimit");

/// The upper limit of detection of the measured points. This is needed if any of the data points have the value"U" (higher than detection limit).
Property upperLimit As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "upperLimit");

/// The number of sample points at each time point. If this value is greater than one, then the dimensions will be interlaced - all the sample points for a point in time will be recorded at once.
Property dimensions As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "dimensions") [ Required ];

/// A series of data points which are decimal values separated by a single space (character u20). The special values"E" (error),"L" (below detection limit) and"U" (above detection limit) can also be used in place of a decimal value.
Property data As HS.FHIR.vDSTU2.Model.Datatype.SampledDataDataType(XMLNAME = "data") [ Required ];

/// Set method for the "period" property.
Method SetPeriod(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.SampledDataDataType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR SampledDataDataType object failed") Quit
		Set ..data = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
