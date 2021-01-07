/// This resource provides: the claim details; adjudication details from the processing of a Claim; and optionally account balance information, for informing the subscriber of the benefits provided.
Class HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Item Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit.Item";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExplanationOfBenefit.Item";

Parameter JSONTYPEFIELD;

/// A service line number.
Property sequence As HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "sequence", XMLPROJECTION = "ELEMENT") [ Required ];

/// Careteam applicable for this service or product line.
Property careTeamLinkId As list Of HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "careTeamLinkId", XMLPROJECTION = "ELEMENT");

/// Diagnosis applicable for this service or product line.
Property diagnosisLinkId As list Of HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "diagnosisLinkId", XMLPROJECTION = "ELEMENT");

/// Procedures applicable for this service or product line.
Property procedureLinkId As list Of HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "procedureLinkId", XMLPROJECTION = "ELEMENT");

/// Exceptions, special conditions and supporting information pplicable for this service or product line.
Property informationLinkId As list Of HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "informationLinkId", XMLPROJECTION = "ELEMENT");

/// The type of reveneu or cost center providing the product and/or service.
Property revenue As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "revenue", XMLPROJECTION = "ELEMENT");

/// Health Care Service Type Codes  to identify the classification of service or benefits.
Property category As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// If this is an actual service or product line, ie. not a Group, then use code to indicate the Professional Service or Product supplied (eg. CTP, HCPCS,USCLS,ICD10, NCPDP,DIN,ACHI,CCI). If a grouping item then use a group code to indicate the type of thing being grouped eg. 'glasses' or 'compound'.
Property service As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "service", XMLPROJECTION = "ELEMENT");

/// Item typification or modifiers codes, eg for Oral whether the treatment is cosmetic or associated with TMJ, or for medical whether the treatment was outside the clinic or out of office hours.
Property modifier As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "modifier", XMLPROJECTION = "ELEMENT");

/// For programs which require reson codes for the inclusion, covering, of this billed item under the program or sub-program.
Property programCode As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "programCode", XMLPROJECTION = "ELEMENT");

Property servicedDate As HS.FHIR.vSTU3.Model.Datatype.Date(XMLNAME = "servicedDate", XMLPROJECTION = "ELEMENT");

Property servicedPeriod As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "servicedPeriod", XMLPROJECTION = "ELEMENT");

Property locationCodeableConcept As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "locationCodeableConcept", XMLPROJECTION = "ELEMENT");

Property locationAddress As HS.FHIR.vSTU3.Model.Base.Address(XMLNAME = "locationAddress", XMLPROJECTION = "ELEMENT");

Property locationReference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "locationReference", XMLPROJECTION = "ELEMENT");

/// The number of repetitions of a service or product.
Property quantity As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// If the item is a node then this is the fee for the product or service, otherwise this is the total of the fees for the children of the group.
Property unitPrice As HS.FHIR.vSTU3.Model.Base.Money(XMLNAME = "unitPrice", XMLPROJECTION = "ELEMENT");

/// A real number that represents a multiplier used in determining the overall value of services delivered and/or goods received. The concept of a Factor allows for a discount or surcharge multiplier to be applied to a monetary amount.
Property factor As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "factor", XMLPROJECTION = "ELEMENT");

/// The quantity times the unit price for an addittional service or product or charge. For example, the formula: unit Quantity * unit Price (Cost per Point) * factor Number  * points = net Amount. Quantity, factor and points are assumed to be 1 if not supplied.
Property net As HS.FHIR.vSTU3.Model.Base.Money(XMLNAME = "net", XMLPROJECTION = "ELEMENT");

/// List of Unique Device Identifiers associated with this line item.
Property udi As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "udi", XMLPROJECTION = "ELEMENT");

/// Physical service site on the patient (limb, tooth, etc).
Property bodySite As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// A region or surface of the site, eg. limb region or tooth surface(s).
Property subSite As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "subSite", XMLPROJECTION = "ELEMENT");

/// A billed item may include goods or services provided in multiple encounters.
Property encounter As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// A list of note references to the notes provided below.
Property noteNumber As list Of HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

/// The adjudications results.
Property adjudication As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

/// Second tier of goods and services.
Property detail As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

/// Set method for the "sequence" property.
Method SetSequence(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..sequence = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "careTeamLinkId" property.
Method SetCareTeamLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..careTeamLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "diagnosisLinkId" property.
Method SetDiagnosisLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..diagnosisLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "procedureLinkId" property.
Method SetProcedureLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..procedureLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "informationLinkId" property.
Method SetInformationLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..informationLinkId.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "revenue" property.
Method SetRevenue(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..revenue = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "category" property.
Method SetCategory(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..category = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "service" property.
Method SetService(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..service = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "modifier" property.
Method SetModifier(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..modifier.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "programCode" property.
Method SetProgramCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..programCode.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "servicedDate" property.
Method SetServicedDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..servicedDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "servicedPeriod" property.
Method SetServicedPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..servicedPeriod = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "locationCodeableConcept" property.
Method SetLocationCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..locationCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "locationReference" property.
Method SetLocationReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..locationReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "quantity" property.
Method SetQuantity(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..quantity = tObj
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

/// Insert method for the "udi" property.
Method SetUdi(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..udi.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "bodySite" property.
Method SetBodySite(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..bodySite = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "subSite" property.
Method SetSubSite(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..subSite.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "encounter" property.
Method SetEncounter(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..encounter.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "noteNumber" property.
Method SetNoteNumber(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..noteNumber.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
