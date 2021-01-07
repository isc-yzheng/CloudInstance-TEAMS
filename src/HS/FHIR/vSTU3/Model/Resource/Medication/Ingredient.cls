/// This resource is primarily used for the identification and definition of a medication. It covers the ingredients and the packaging for a medication.
Class HS.FHIR.vSTU3.Model.Resource.Medication.Ingredient Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Ingredient";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Ingredient";

Parameter JSONTYPEFIELD;

Property itemCodeableConcept As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "itemCodeableConcept", XMLPROJECTION = "ELEMENT");

Property itemReference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "itemReference", XMLPROJECTION = "ELEMENT");

/// Indication of whether this ingredient affects the therapeutic action of the drug.
Property isActive As HS.FHIR.vSTU3.Model.Datatype.Boolean(XMLNAME = "isActive", XMLPROJECTION = "ELEMENT");

/// Specifies how many (or how much) of the items there are in this Medication.  For example, 250 mg per tablet.  This is expressed as a ratio where the numerator is 250mg and the denominator is 1 tablet.
Property amount As HS.FHIR.vSTU3.Model.Base.Ratio(XMLNAME = "amount", XMLPROJECTION = "ELEMENT");

/// Set method for the "itemCodeableConcept" property.
Method SetItemCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..itemCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "itemReference" property.
Method SetItemReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..itemReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "isActive" property.
Method SetIsActive(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..isActive = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
