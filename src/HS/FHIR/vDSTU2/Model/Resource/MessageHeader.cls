Class HS.FHIR.vDSTU2.Model.Resource.MessageHeader Extends HS.FHIR.vDSTU2.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageHeader";

Parameter XMLSEQUENCE = 1;

/// The time that the message was sent.
Property timestamp As HS.FHIR.vDSTU2.Model.Datatype.Instant(XMLNAME = "timestamp") [ Required ];

/// Code that identifies the event this message represents and connects it with its definition. Events defined as part of the FHIR specification have the system value"http://hl7.org/fhir/message-events".
Property event As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "event") [ Required ];

/// Information about the message that this message is a response to.  Only present if this message is a response.
Property response As HS.FHIR.vDSTU2.Model.Resource.MessageHeader.Response(XMLNAME = "response");

/// The source application from which this message originated.
Property source As HS.FHIR.vDSTU2.Model.Resource.MessageHeader.Source(XMLNAME = "source") [ Required ];

/// The destination application which the message is intended for.
Property destination As list Of HS.FHIR.vDSTU2.Model.Resource.MessageHeader.Destination(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// The person or device that performed the data entry leading to this message. Where there is more than one candidate, pick the most proximal to the message. Can provide other enterers in extensions.
Property enterer As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "enterer");

/// The logical author of the message - the person or device that decided the described event should happen. Where there is more than one candidate, pick the most proximal to the MessageHeader. Can provide other authors in extensions.
Property author As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "author");

/// Allows data conveyed by a message to be addressed to a particular person or department when routing to a specific application isn't sufficient.
Property receiver As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "receiver");

/// The person or organization that accepts overall responsibility for the contents of the message. The implication is that the message event happened under the policies of the responsible party.
Property responsible As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "responsible");

/// Coded indication of the cause for the event - indicates  a reason for the occurrence of the event that is a focus of this message.
Property reason As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "reason");

/// The actual data of the message - a reference to the root/focus class of the event.
Property data As list Of HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

/// Set method for the "timestamp" property.
Method SetTimestamp(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed") Quit
		Set ..timestamp = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "event" property.
Method SetEvent(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..event = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "enterer" property.
Method SetEnterer(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..enterer = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "author" property.
Method SetAuthor(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..author = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "receiver" property.
Method SetReceiver(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..receiver = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "responsible" property.
Method SetResponsible(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..responsible = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "reason" property.
Method SetReason(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..reason = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "data" property.
Method SetData(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set tSC = ..data.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
