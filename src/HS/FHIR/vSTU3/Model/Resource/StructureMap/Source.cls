/// A Map of relationships between 2 structures that can be used to transform data.
Class HS.FHIR.vSTU3.Model.Resource.StructureMap.Source Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureMap.Source";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureMap.Source";

Parameter JSONTYPEFIELD;

/// Type or variable this rule applies to.
Property context As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "context", XMLPROJECTION = "ELEMENT") [ Required ];

/// Specified minimum cardinality for the element. This is optional; if present, it acts an implicit check on the input content.
Property min As HS.FHIR.vSTU3.Model.Datatype.Integer(XMLNAME = "min", XMLPROJECTION = "ELEMENT");

/// Specified maximum cardinality for the element - a number or a "*". This is optional; if present, it acts an implicit check on the input content (* just serves as documentation; it's the default value).
Property max As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "max", XMLPROJECTION = "ELEMENT");

/// Specified type for the element. This works as a condition on the mapping - use for polymorphic elements.
Property type As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

Property defaultValueBase64Binary As HS.FHIR.vSTU3.Model.Datatype.Base64Binary(XMLNAME = "defaultValueBase64Binary", XMLPROJECTION = "ELEMENT");

Property defaultValueBoolean As HS.FHIR.vSTU3.Model.Datatype.Boolean(XMLNAME = "defaultValueBoolean", XMLPROJECTION = "ELEMENT");

Property defaultValueCode As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "defaultValueCode", XMLPROJECTION = "ELEMENT");

Property defaultValueDate As HS.FHIR.vSTU3.Model.Datatype.Date(XMLNAME = "defaultValueDate", XMLPROJECTION = "ELEMENT");

Property defaultValueDateTime As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "defaultValueDateTime", XMLPROJECTION = "ELEMENT");

Property defaultValueDecimal As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "defaultValueDecimal", XMLPROJECTION = "ELEMENT");

Property defaultValueId As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "defaultValueId", XMLPROJECTION = "ELEMENT");

Property defaultValueInstant As HS.FHIR.vSTU3.Model.Datatype.Instant(XMLNAME = "defaultValueInstant", XMLPROJECTION = "ELEMENT");

Property defaultValueInteger As HS.FHIR.vSTU3.Model.Datatype.Integer(XMLNAME = "defaultValueInteger", XMLPROJECTION = "ELEMENT");

Property defaultValueMarkdown As HS.FHIR.vSTU3.Model.Datatype.Markdown(XMLNAME = "defaultValueMarkdown", XMLPROJECTION = "ELEMENT");

Property defaultValueOid As HS.FHIR.vSTU3.Model.Datatype.Oid(XMLNAME = "defaultValueOid", XMLPROJECTION = "ELEMENT");

Property defaultValuePositiveInt As HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "defaultValuePositiveInt", XMLPROJECTION = "ELEMENT");

Property defaultValueString As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "defaultValueString", XMLPROJECTION = "ELEMENT");

Property defaultValueTime As HS.FHIR.vSTU3.Model.Datatype.Time(XMLNAME = "defaultValueTime", XMLPROJECTION = "ELEMENT");

Property defaultValueUnsignedInt As HS.FHIR.vSTU3.Model.Datatype.UnsignedInt(XMLNAME = "defaultValueUnsignedInt", XMLPROJECTION = "ELEMENT");

Property defaultValueUri As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "defaultValueUri", XMLPROJECTION = "ELEMENT");

Property defaultValueAddress As HS.FHIR.vSTU3.Model.Base.Address(XMLNAME = "defaultValueAddress", XMLPROJECTION = "ELEMENT");

Property defaultValueAge As HS.FHIR.vSTU3.Model.Base.Age(XMLNAME = "defaultValueAge", XMLPROJECTION = "ELEMENT");

Property defaultValueAnnotation As HS.FHIR.vSTU3.Model.Base.Annotation(XMLNAME = "defaultValueAnnotation", XMLPROJECTION = "ELEMENT");

Property defaultValueAttachment As HS.FHIR.vSTU3.Model.Base.Attachment(XMLNAME = "defaultValueAttachment", XMLPROJECTION = "ELEMENT");

Property defaultValueCodeableConcept As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "defaultValueCodeableConcept", XMLPROJECTION = "ELEMENT");

Property defaultValueCoding As HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "defaultValueCoding", XMLPROJECTION = "ELEMENT");

Property defaultValueContactPoint As HS.FHIR.vSTU3.Model.Base.ContactPoint(XMLNAME = "defaultValueContactPoint", XMLPROJECTION = "ELEMENT");

Property defaultValueCount As HS.FHIR.vSTU3.Model.Base.Count(XMLNAME = "defaultValueCount", XMLPROJECTION = "ELEMENT");

Property defaultValueDistance As HS.FHIR.vSTU3.Model.Base.Distance(XMLNAME = "defaultValueDistance", XMLPROJECTION = "ELEMENT");

Property defaultValueDuration As HS.FHIR.vSTU3.Model.Base.Duration(XMLNAME = "defaultValueDuration", XMLPROJECTION = "ELEMENT");

Property defaultValueHumanName As HS.FHIR.vSTU3.Model.Base.HumanName(XMLNAME = "defaultValueHumanName", XMLPROJECTION = "ELEMENT");

Property defaultValueIdentifier As HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "defaultValueIdentifier", XMLPROJECTION = "ELEMENT");

Property defaultValueMoney As HS.FHIR.vSTU3.Model.Base.Money(XMLNAME = "defaultValueMoney", XMLPROJECTION = "ELEMENT");

Property defaultValuePeriod As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "defaultValuePeriod", XMLPROJECTION = "ELEMENT");

Property defaultValueQuantity As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "defaultValueQuantity", XMLPROJECTION = "ELEMENT");

Property defaultValueRange As HS.FHIR.vSTU3.Model.Base.Range(XMLNAME = "defaultValueRange", XMLPROJECTION = "ELEMENT");

Property defaultValueRatio As HS.FHIR.vSTU3.Model.Base.Ratio(XMLNAME = "defaultValueRatio", XMLPROJECTION = "ELEMENT");

Property defaultValueReference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "defaultValueReference", XMLPROJECTION = "ELEMENT");

Property defaultValueSampledData As HS.FHIR.vSTU3.Model.Base.SampledData(XMLNAME = "defaultValueSampledData", XMLPROJECTION = "ELEMENT");

Property defaultValueSignature As HS.FHIR.vSTU3.Model.Base.Signature(XMLNAME = "defaultValueSignature", XMLPROJECTION = "ELEMENT");

Property defaultValueTiming As HS.FHIR.vSTU3.Model.Base.Timing(XMLNAME = "defaultValueTiming", XMLPROJECTION = "ELEMENT");

Property defaultValueMeta As HS.FHIR.vSTU3.Model.Base.Meta(XMLNAME = "defaultValueMeta", XMLPROJECTION = "ELEMENT");

/// Optional field for this source.
Property element As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "element", XMLPROJECTION = "ELEMENT");

/// How to handle the list mode for this element.
Property listMode As HS.FHIR.vSTU3.Model.Base.StructureMapSourceListMode(XMLNAME = "listMode", XMLPROJECTION = "ELEMENT");

/// Named context for field, if a field is specified.
Property variable As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "variable", XMLPROJECTION = "ELEMENT");

/// FHIRPath expression  - must be true or the rule does not apply.
Property condition As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// FHIRPath expression  - must be true or the mapping engine throws an error instead of completing.
Property check As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "check", XMLPROJECTION = "ELEMENT");

/// Set method for the "context" property.
Method SetContext(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..context = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "min" property.
Method SetMin(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..min = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "max" property.
Method SetMax(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..max = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueBase64Binary" property.
Method SetDefaultValueBase64Binary(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Base64Binary).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Base64Binary object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueBase64Binary = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueBoolean" property.
Method SetDefaultValueBoolean(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueBoolean = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueCode" property.
Method SetDefaultValueCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueCode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueDate" property.
Method SetDefaultValueDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueDateTime" property.
Method SetDefaultValueDateTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueDateTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueDecimal" property.
Method SetDefaultValueDecimal(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueDecimal = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueId" property.
Method SetDefaultValueId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueInstant" property.
Method SetDefaultValueInstant(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueInstant = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueInteger" property.
Method SetDefaultValueInteger(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueInteger = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueMarkdown" property.
Method SetDefaultValueMarkdown(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Markdown).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Markdown object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueMarkdown = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueOid" property.
Method SetDefaultValueOid(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueOid = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValuePositiveInt" property.
Method SetDefaultValuePositiveInt(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValuePositiveInt = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueString" property.
Method SetDefaultValueString(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueString = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueTime" property.
Method SetDefaultValueTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueUnsignedInt" property.
Method SetDefaultValueUnsignedInt(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueUnsignedInt = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueUri" property.
Method SetDefaultValueUri(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueUri = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueAttachment" property.
Method SetDefaultValueAttachment(pContentType As %String = "", pLanguage As %String = "", pData As %String = "", pUrl As %String = "", pSize As %String = "", pHash As %String = "", pTitle As %String = "", pCreation As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Attachment).%New(pContentType, pLanguage, pData, pUrl, pSize, pHash, pTitle, pCreation, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Attachment object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueAttachment = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueCodeableConcept" property.
Method SetDefaultValueCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueCoding" property.
Method SetDefaultValueCoding(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueCoding = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueContactPoint" property.
Method SetDefaultValueContactPoint(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pRank As %String = "", pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ContactPoint).%New(pValue, pSystem, pUse, pRank, pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ContactPoint object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueContactPoint = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueHumanName" property.
Method SetDefaultValueHumanName(pLastName As %String = "", pFirstName As %String = "", pMiddleName As %String = "", pPrefix As %String = "", pSuffix As %String = "", pUse As %String = "", pText As %String = "", pStart As %String = "", pEnd As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.HumanName).%New(pLastName, pFirstName, pMiddleName, pPrefix, pSuffix, pUse, pText, pStart, pEnd, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR HumanName object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueHumanName = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueIdentifier" property.
Method SetDefaultValueIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueIdentifier = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValuePeriod" property.
Method SetDefaultValuePeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValuePeriod = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueQuantity" property.
Method SetDefaultValueQuantity(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueQuantity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "defaultValueReference" property.
Method SetDefaultValueReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..defaultValueReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "element" property.
Method SetElement(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..element = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "listMode" property.
Method SetListMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.StructureMapSourceListMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR StructureMapSourceListMode object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..listMode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "variable" property.
Method SetVariable(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..variable = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "condition" property.
Method SetCondition(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..condition = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "check" property.
Method SetCheck(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..check = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
