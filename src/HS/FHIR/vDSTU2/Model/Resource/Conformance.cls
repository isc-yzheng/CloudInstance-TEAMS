Class HS.FHIR.vDSTU2.Model.Resource.Conformance Extends HS.FHIR.vDSTU2.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance";

Parameter XMLSEQUENCE = 1;

/// An absolute URL that is used to identify this conformance statement when it is referenced in a specification, model, design or an instance. This SHALL be a URL, SHOULD be globally unique, and SHOULD be an address at which this conformance statement is (or will be) published.
Property url As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "url");

/// The identifier that is used to identify this version of the conformance statement when it is referenced in a specification, model, design or instance. This is an arbitrary value managed by the profile author manually and the value should be a timestamp.
Property version As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "version");

/// A free text natural language name identifying the conformance statement.
Property name As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "name");

/// The status of this conformance statement.
Property status As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "status");

/// A flag to indicate that this conformance statement is authored for testing purposes (or education/evaluation/marketing), and is not intended to be used for genuine usage.
Property experimental As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "experimental");

/// The name of the individual or organization that published the conformance.
Property publisher As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "publisher");

/// Contacts to assist a user in finding and communicating with the publisher.
Property contact As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// The date  (and optionally time) when the conformance statement was published. The date must change when the business version changes, if it does, and it must change if the status code changes. In addition, it should change when the substantive content of the conformance statement changes.
Property date As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "date") [ Required, SqlFieldName = _date ];

/// A free text natural language description of the conformance statement and its use. Typically, this is used when the conformance statement describes a desired rather than an actual solution, for example as a formal expression of requirements as part of an RFP.
Property description As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "description");

/// Explains why this conformance statement is needed and why it's been constrained as it has.
Property requirements As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "requirements");

/// A copyright statement relating to the conformance statement and/or its contents. Copyright statements are generally legal restrictions on the use and publishing of the details of the system described by the conformance statement.
Property copyright As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "copyright");

/// The way that this statement is intended to be used, to describe an actual running instance of software, a particular product (kind not instance of software) or a class of implementation (e.g. a desired purchase).
Property kind As HS.FHIR.vDSTU2.Model.Base.ConformanceStatementKind(XMLNAME = "kind") [ Required ];

/// Software that is covered by this conformance statement.  It is used when the conformance statement describes the capabilities of a particular software version, independent of an installation.
Property software As HS.FHIR.vDSTU2.Model.Resource.Conformance.Software(XMLNAME = "software");

/// Identifies a specific implementation instance that is described by the conformance statement - i.e. a particular installation, rather than the capabilities of a software program.
Property implementation As HS.FHIR.vDSTU2.Model.Resource.Conformance.Implementation(XMLNAME = "implementation");

/// The version of the FHIR specification on which this conformance statement is based.
Property fhirVersion As HS.FHIR.vDSTU2.Model.Datatype.Id(XMLNAME = "fhirVersion") [ Required ];

/// A code that indicates whether the application accepts unknown elements or extensions when reading resources.
Property acceptUnknown As HS.FHIR.vDSTU2.Model.Base.UnknownContentCode(XMLNAME = "acceptUnknown") [ Required ];

/// A list of the formats supported by this implementation using their content types.
Property format As list Of HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "format", XMLPROJECTION = "ELEMENT") [ Required ];

/// A list of profiles that represent different use cases supported by the system. For a server,"supported by the system" means the system hosts/produces a set of resources that are conformant to a particular profile, and allows clients that use its services to search using this profile and to find appropriate data. For a client, it means the system will search by this profile and process data according to the guidance implicit in the profile. See further discussion in [Using Profiles]{profiling.html#profile-uses}.
Property profile As list Of HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// A definition of the restful capabilities of the solution, if any.
Property rest As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Rest(XMLNAME = "rest", XMLPROJECTION = "ELEMENT");

/// A description of the messaging capabilities of the solution.
Property messaging As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Messaging(XMLNAME = "messaging", XMLPROJECTION = "ELEMENT");

/// A document definition.
Property document As list Of HS.FHIR.vDSTU2.Model.Resource.Conformance.Document(XMLNAME = "document", XMLPROJECTION = "ELEMENT");

/// Set method for the "url" property.
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "version" property.
Method SetVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..version = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "status" property.
Method SetStatus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..status = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "experimental" property.
Method SetExperimental(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..experimental = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "publisher" property.
Method SetPublisher(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..publisher = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "date" property.
Method SetDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..date = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "requirements" property.
Method SetRequirements(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..requirements = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "copyright" property.
Method SetCopyright(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..copyright = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "kind" property.
Method SetKind(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ConformanceStatementKind).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ConformanceStatementKind object failed") Quit
		Set ..kind = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "fhirVersion" property.
Method SetFhirVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed") Quit
		Set ..fhirVersion = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "acceptUnknown" property.
Method SetAcceptUnknown(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.UnknownContentCode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnknownContentCode object failed") Quit
		Set ..acceptUnknown = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "format" property.
Method SetFormat(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set tSC = ..format.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "profile" property.
Method SetProfile(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set tSC = ..profile.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
