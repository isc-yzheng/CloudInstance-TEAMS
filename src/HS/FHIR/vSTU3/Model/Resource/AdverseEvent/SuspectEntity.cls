/// Actual or  potential/avoided event causing unintended physical injury resulting from or contributed to by medical care, a research study or other healthcare setting factors that requires additional monitoring, treatment, or hospitalization, or that results in death.
Class HS.FHIR.vSTU3.Model.Resource.AdverseEvent.SuspectEntity Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AdverseEvent.SuspectEntity";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AdverseEvent.SuspectEntity";

Parameter JSONTYPEFIELD;

/// Identifies the actual instance of what caused the adverse event.  May be a substance, medication, medication administration, medication statement or a device.
Property instance As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "instance", XMLPROJECTION = "ELEMENT") [ Required ];

/// causality1 | causality2.
Property causality As HS.FHIR.vSTU3.Model.Base.AdverseEventCausality(XMLNAME = "causality", XMLPROJECTION = "ELEMENT");

/// assess1 | assess2.
Property causalityAssessment As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "causalityAssessment", XMLPROJECTION = "ELEMENT");

/// AdverseEvent.suspectEntity.causalityProductRelatedness.
Property causalityProductRelatedness As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "causalityProductRelatedness", XMLPROJECTION = "ELEMENT");

/// method1 | method2.
Property causalityMethod As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "causalityMethod", XMLPROJECTION = "ELEMENT");

/// AdverseEvent.suspectEntity.causalityAuthor.
Property causalityAuthor As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "causalityAuthor", XMLPROJECTION = "ELEMENT");

/// result1 | result2.
Property causalityResult As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "causalityResult", XMLPROJECTION = "ELEMENT");

/// Set method for the "instance" property.
Method SetInstance(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..instance = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "causality" property.
Method SetCausality(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.AdverseEventCausality).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR AdverseEventCausality object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..causality = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "causalityAssessment" property.
Method SetCausalityAssessment(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..causalityAssessment = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "causalityProductRelatedness" property.
Method SetCausalityProductRelatedness(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..causalityProductRelatedness = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "causalityMethod" property.
Method SetCausalityMethod(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..causalityMethod = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "causalityAuthor" property.
Method SetCausalityAuthor(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..causalityAuthor = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "causalityResult" property.
Method SetCausalityResult(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..causalityResult = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
