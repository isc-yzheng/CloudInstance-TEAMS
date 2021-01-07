/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Patient.Link when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Patient.Link Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Patient.Link";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Patient.Link";

///  
Property other As HS.FHIR.Model.Base.Reference(XMLNAME = "other") [ Required ];

///  
Property type As HS.FHIR.Model.Base.LinkType(XMLNAME = "type") [ Required ];

///  
Method SetOther(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..other = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.LinkType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR LinkType object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
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
