/// Optional Extension Element - found in all resources.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.Extension Extends HS.FHIR.vSTU3.Model.Base.Element [ CompileAfter = HS.FHIR.vSTU3.Model.Datatype.UriPrimitive, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Extension";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

Property valueBase64Binary As HS.FHIR.vSTU3.Model.Datatype.Base64Binary(XMLNAME = "valueBase64Binary", XMLPROJECTION = "ELEMENT");

Property valueBoolean As HS.FHIR.vSTU3.Model.Datatype.Boolean(XMLNAME = "valueBoolean", XMLPROJECTION = "ELEMENT");

Property valueCode As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "valueCode", XMLPROJECTION = "ELEMENT");

Property valueDate As HS.FHIR.vSTU3.Model.Datatype.Date(XMLNAME = "valueDate", XMLPROJECTION = "ELEMENT");

Property valueDateTime As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "valueDateTime", XMLPROJECTION = "ELEMENT");

Property valueDecimal As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "valueDecimal", XMLPROJECTION = "ELEMENT");

Property valueId As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "valueId", XMLPROJECTION = "ELEMENT");

Property valueInstant As HS.FHIR.vSTU3.Model.Datatype.Instant(XMLNAME = "valueInstant", XMLPROJECTION = "ELEMENT");

Property valueInteger As HS.FHIR.vSTU3.Model.Datatype.Integer(XMLNAME = "valueInteger", XMLPROJECTION = "ELEMENT");

Property valueMarkdown As HS.FHIR.vSTU3.Model.Datatype.Markdown(XMLNAME = "valueMarkdown", XMLPROJECTION = "ELEMENT");

Property valueOid As HS.FHIR.vSTU3.Model.Datatype.Oid(XMLNAME = "valueOid", XMLPROJECTION = "ELEMENT");

Property valuePositiveInt As HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "valuePositiveInt", XMLPROJECTION = "ELEMENT");

Property valueString As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "valueString", XMLPROJECTION = "ELEMENT");

Property valueTime As HS.FHIR.vSTU3.Model.Datatype.Time(XMLNAME = "valueTime", XMLPROJECTION = "ELEMENT");

Property valueUnsignedInt As HS.FHIR.vSTU3.Model.Datatype.UnsignedInt(XMLNAME = "valueUnsignedInt", XMLPROJECTION = "ELEMENT");

Property valueUri As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "valueUri", XMLPROJECTION = "ELEMENT");

Property valueAddress As HS.FHIR.vSTU3.Model.Base.Address(XMLNAME = "valueAddress", XMLPROJECTION = "ELEMENT");

Property valueAge As HS.FHIR.vSTU3.Model.Base.Age(XMLNAME = "valueAge", XMLPROJECTION = "ELEMENT");

Property valueAnnotation As HS.FHIR.vSTU3.Model.Base.Annotation(XMLNAME = "valueAnnotation", XMLPROJECTION = "ELEMENT");

Property valueAttachment As HS.FHIR.vSTU3.Model.Base.Attachment(XMLNAME = "valueAttachment", XMLPROJECTION = "ELEMENT");

Property valueCodeableConcept As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "valueCodeableConcept", XMLPROJECTION = "ELEMENT");

Property valueCoding As HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "valueCoding", XMLPROJECTION = "ELEMENT");

Property valueContactPoint As HS.FHIR.vSTU3.Model.Base.ContactPoint(XMLNAME = "valueContactPoint", XMLPROJECTION = "ELEMENT");

Property valueCount As HS.FHIR.vSTU3.Model.Base.Count(XMLNAME = "valueCount", XMLPROJECTION = "ELEMENT");

Property valueDistance As HS.FHIR.vSTU3.Model.Base.Distance(XMLNAME = "valueDistance", XMLPROJECTION = "ELEMENT");

Property valueDuration As HS.FHIR.vSTU3.Model.Base.Duration(XMLNAME = "valueDuration", XMLPROJECTION = "ELEMENT");

Property valueHumanName As HS.FHIR.vSTU3.Model.Base.HumanName(XMLNAME = "valueHumanName", XMLPROJECTION = "ELEMENT");

Property valueIdentifier As HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "valueIdentifier", XMLPROJECTION = "ELEMENT");

Property valueMoney As HS.FHIR.vSTU3.Model.Base.Money(XMLNAME = "valueMoney", XMLPROJECTION = "ELEMENT");

Property valuePeriod As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "valuePeriod", XMLPROJECTION = "ELEMENT");

Property valueQuantity As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT");

Property valueRange As HS.FHIR.vSTU3.Model.Base.Range(XMLNAME = "valueRange", XMLPROJECTION = "ELEMENT");

Property valueRatio As HS.FHIR.vSTU3.Model.Base.Ratio(XMLNAME = "valueRatio", XMLPROJECTION = "ELEMENT");

Property valueReference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "valueReference", XMLPROJECTION = "ELEMENT");

Property valueSampledData As HS.FHIR.vSTU3.Model.Base.SampledData(XMLNAME = "valueSampledData", XMLPROJECTION = "ELEMENT");

Property valueSignature As HS.FHIR.vSTU3.Model.Base.Signature(XMLNAME = "valueSignature", XMLPROJECTION = "ELEMENT");

Property valueTiming As HS.FHIR.vSTU3.Model.Base.Timing(XMLNAME = "valueTiming", XMLPROJECTION = "ELEMENT");

Property valueMeta As HS.FHIR.vSTU3.Model.Base.Meta(XMLNAME = "valueMeta", XMLPROJECTION = "ELEMENT");

Property url As HS.FHIR.vSTU3.Model.Datatype.UriPrimitive(XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Set method for the "valueBase64Binary" property.
Method SetValueBase64Binary(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Base64Binary).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Base64Binary object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueBase64Binary = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueBoolean" property.
Method SetValueBoolean(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueBoolean = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueCode" property.
Method SetValueCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueCode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueDate" property.
Method SetValueDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueDateTime" property.
Method SetValueDateTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueDateTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueDecimal" property.
Method SetValueDecimal(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueDecimal = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueId" property.
Method SetValueId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueInstant" property.
Method SetValueInstant(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueInstant = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueInteger" property.
Method SetValueInteger(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueInteger = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueMarkdown" property.
Method SetValueMarkdown(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Markdown).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Markdown object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueMarkdown = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueOid" property.
Method SetValueOid(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueOid = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valuePositiveInt" property.
Method SetValuePositiveInt(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valuePositiveInt = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueString" property.
Method SetValueString(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueString = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueTime" property.
Method SetValueTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Time).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Time object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueUnsignedInt" property.
Method SetValueUnsignedInt(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueUnsignedInt = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueUri" property.
Method SetValueUri(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueUri = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueAttachment" property.
Method SetValueAttachment(pContentType As %String = "", pLanguage As %String = "", pData As %String = "", pUrl As %String = "", pSize As %String = "", pHash As %String = "", pTitle As %String = "", pCreation As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Attachment).%New(pContentType, pLanguage, pData, pUrl, pSize, pHash, pTitle, pCreation, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Attachment object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueAttachment = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueCodeableConcept" property.
Method SetValueCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueCoding" property.
Method SetValueCoding(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueCoding = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueContactPoint" property.
Method SetValueContactPoint(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pRank As %String = "", pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ContactPoint).%New(pValue, pSystem, pUse, pRank, pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ContactPoint object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueContactPoint = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueHumanName" property.
Method SetValueHumanName(pLastName As %String = "", pFirstName As %String = "", pMiddleName As %String = "", pPrefix As %String = "", pSuffix As %String = "", pUse As %String = "", pText As %String = "", pStart As %String = "", pEnd As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.HumanName).%New(pLastName, pFirstName, pMiddleName, pPrefix, pSuffix, pUse, pText, pStart, pEnd, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR HumanName object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueHumanName = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueIdentifier" property.
Method SetValueIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueIdentifier = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valuePeriod" property.
Method SetValuePeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valuePeriod = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueQuantity" property.
Method SetValueQuantity(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueQuantity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "valueReference" property.
Method SetValueReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..valueReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
Method %OnNew(pUrl As %String, pValueType As %String, pValue, pId As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pUrl)=0)&&($Data(pValueType)=0)&&($Data(pValue)=0)&&($Data(pId)=0) Quit
		If ($Get(pUrl)="")||($Get(pValueType)="")||($Get(pValue)="") Set tSC = $$$ERROR($$$GeneralError,"Incomplete extension data specified") Quit
		Set tSC = $Method($this, "SetValue"_pValueType, pValue) Quit:$$$ISERR(tSC)
		Set ..url = pUrl
		If $Get(pId)'="" Set ..id = pId
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
