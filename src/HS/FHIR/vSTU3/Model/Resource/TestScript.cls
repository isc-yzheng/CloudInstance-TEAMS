/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.TestScript Extends HS.FHIR.vSTU3.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript";

Parameter XMLSEQUENCE = 1;

/// An absolute URI that is used to identify this test script when it is referenced in a specification, model, design or an instance. This SHALL be a URL, SHOULD be globally unique, and SHOULD be an address at which this test script is (or will be) published. The URL SHOULD include the major version of the test script. For more information see [Technical and Business Versions](resource.html#versions).
Property url As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "url", XMLPROJECTION = "ELEMENT") [ Required ];

/// A formal identifier that is used to identify this test script when it is represented in other formats, or referenced in a specification, model, design or an instance.
Property identifier As HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// The identifier that is used to identify this version of the test script when it is referenced in a specification, model, design or instance. This is an arbitrary value managed by the test script author and is not expected to be globally unique. For example, it might be a timestamp (e.g. yyyymmdd) if a managed version is not available. There is also no expectation that versions can be placed in a lexicographical sequence.
Property version As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "version", XMLPROJECTION = "ELEMENT");

/// A natural language name identifying the test script. This name should be usable as an identifier for the module by machine processing applications such as code generation.
Property name As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "name", XMLPROJECTION = "ELEMENT") [ Required ];

/// A short, descriptive, user-friendly title for the test script.
Property title As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "title", XMLPROJECTION = "ELEMENT");

/// The status of this test script. Enables tracking the life-cycle of the content.
Property status As HS.FHIR.vSTU3.Model.Base.PublicationStatus(XMLNAME = "status", XMLPROJECTION = "ELEMENT") [ Required ];

/// A boolean value to indicate that this test script is authored for testing purposes (or education/evaluation/marketing), and is not intended to be used for genuine usage.
Property experimental As HS.FHIR.vSTU3.Model.Datatype.Boolean(XMLNAME = "experimental", XMLPROJECTION = "ELEMENT");

/// The date  (and optionally time) when the test script was published. The date must change if and when the business version changes and it must change if the status code changes. In addition, it should change when the substantive content of the test script changes.
Property date As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "date", XMLPROJECTION = "ELEMENT");

/// The name of the individual or organization that published the test script.
Property publisher As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "publisher", XMLPROJECTION = "ELEMENT");

/// Contact details to assist a user in finding and communicating with the publisher.
Property contact As list Of HS.FHIR.vSTU3.Model.Base.ContactDetail(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// A free text natural language description of the test script from a consumer's perspective.
Property description As HS.FHIR.vSTU3.Model.Datatype.Markdown(XMLNAME = "description", XMLPROJECTION = "ELEMENT");

/// The content was developed with a focus and intent of supporting the contexts that are listed. These terms may be used to assist with indexing and searching for appropriate test script instances.
Property useContext As list Of HS.FHIR.vSTU3.Model.Base.UsageContext(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// A legal or geographic region in which the test script is intended to be used.
Property jurisdiction As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "jurisdiction", XMLPROJECTION = "ELEMENT");

/// Explaination of why this test script is needed and why it has been designed as it has.
Property purpose As HS.FHIR.vSTU3.Model.Datatype.Markdown(XMLNAME = "purpose", XMLPROJECTION = "ELEMENT");

/// A copyright statement relating to the test script and/or its contents. Copyright statements are generally legal restrictions on the use and publishing of the test script.
Property copyright As HS.FHIR.vSTU3.Model.Datatype.Markdown(XMLNAME = "copyright", XMLPROJECTION = "ELEMENT");

/// An abstract server used in operations within this test script in the origin element.
Property origin As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Origin(XMLNAME = "origin", XMLPROJECTION = "ELEMENT");

/// An abstract server used in operations within this test script in the destination element.
Property destination As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Destination(XMLNAME = "destination", XMLPROJECTION = "ELEMENT");

/// The required capability must exist and are assumed to function correctly on the FHIR server being tested.
Property metadata As HS.FHIR.vSTU3.Model.Resource.TestScript.Metadata(XMLNAME = "metadata", XMLPROJECTION = "ELEMENT");

/// Fixture in the test script - by reference (uri). All fixtures are required for the test script to execute.
Property fixture As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Fixture(XMLNAME = "fixture", XMLPROJECTION = "ELEMENT");

/// Reference to the profile to be used for validation.
Property profile As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// Variable is set based either on element value in response body or on header field value in the response headers.
Property variable As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Variable(XMLNAME = "variable", XMLPROJECTION = "ELEMENT");

/// Assert rule to be used in one or more asserts within the test script.
Property rule As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

/// Contains one or more rules.  Offers a way to group rules so assertions could reference the group of rules and have them all applied.
Property ruleset As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Ruleset(XMLNAME = "ruleset", XMLPROJECTION = "ELEMENT");

/// A series of required setup operations before tests are executed.
Property setup As HS.FHIR.vSTU3.Model.Resource.TestScript.Setup(XMLNAME = "setup", XMLPROJECTION = "ELEMENT");

/// A test in this script.
Property test As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Test(XMLNAME = "test", XMLPROJECTION = "ELEMENT");

/// A series of operations required to clean up after the all the tests are executed (successfully or otherwise).
Property teardown As HS.FHIR.vSTU3.Model.Resource.TestScript.Teardown(XMLNAME = "teardown", XMLPROJECTION = "ELEMENT");

/// Set method for the "url" property.
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..identifier = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "title" property.
Method SetTitle(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..title = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.PublicationStatus).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PublicationStatus object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..experimental = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..date = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..publisher = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Markdown).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Markdown object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "jurisdiction" property.
Method SetJurisdiction(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..jurisdiction.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "purpose" property.
Method SetPurpose(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Markdown).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Markdown object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..purpose = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Markdown).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Markdown object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..copyright = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..profile.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
