Class HS.FHIR.vDSTU2.Model.Resource.Patient.Link Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Patient.Link";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Patient.Link";

/// The other patient resource that the link refers to.
Property other As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "other") [ Required ];

/// The type of link between this patient resource and another patient resource.
Property type As HS.FHIR.vDSTU2.Model.Base.LinkType(XMLNAME = "type") [ Required ];

/// Set method for the "other" property.
Method SetOther(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..other = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.LinkType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR LinkType object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
Method %OnNew(pReference As %String, pDisplay As %String, pType As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pReference)=0)&&($Data(pDisplay)=0)&&($Data(pType)=0)&&($Data(pExtension)=0) Quit
		If ($Get(pReference)'="")||($Get(pDisplay)'="") Set tSC = ..SetOther($Get(pReference),$Get(pDisplay)) Quit:$$$ISERR(tSC)
		If $Get(pType)'="" Set tSC = ..SetType(pType) Quit:$$$ISERR(tSC)
		#; pExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pExtension)) {
			If (pExtension.%Extends("%Collection.ListOfObj")=0)&&(pExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..extension.Insert(pExtension) Quit:$$$ISERR(tSC)
			} Else {
				Set ..extension = pExtension
			}
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
