/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Practitioner.Qualification when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Practitioner.Qualification Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Practitioner.Qualification";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Practitioner.Qualification";

///  
Property identifier As list Of HS.FHIR.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

///  
Property code As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "code") [ Required ];

///  
Property period As HS.FHIR.Model.Base.Period(XMLNAME = "period");

///  
Property issuer As HS.FHIR.Model.Base.Reference(XMLNAME = "issuer");

///  
Method SetIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed") Quit
		Set tSC = ..identifier.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed") Quit
		Set ..period = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetIssuer(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..issuer = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
