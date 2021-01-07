/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.DomainResource when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.DomainResource Extends HS.FHIR.Model.Base.Resource [ Deprecated, ProcedureBlock ]
{

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "DomainResource";

///  
Parameter XMLSEQUENCE = 1;

///  
Property text As HS.FHIR.Model.Base.Narrative(XMLNAME = "text");

///  
Property contained As list Of HS.FHIR.Model.Base.ResourceContainer(XMLNAME = "contained", XMLPROJECTION = "ELEMENT");

///  
Property extension As list Of HS.FHIR.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

///  
Property modifierExtension As list Of HS.FHIR.Model.Base.Extension(XMLNAME = "modifierExtension", XMLPROJECTION = "ELEMENT");

///  
Method SetText(pStatus As %String = "", pDiv As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Narrative).%New(pStatus, pDiv)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Narrative object failed") Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetContained(pResource As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.ResourceContainer).%New(pResource)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceContainer object failed") Quit
		Set tSC = ..contained.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
