/// Describes a set of tests.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.TestScript Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Absolute URL used to reference this TestScript.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Logical id for this version of the TestScript.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Informal name for this TestScript.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// draft | active | retired
/// <p>
/// conformance-resource-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend conformance-resource-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// External identifier.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If for testing purposes, 
/// not real usage.
Property experimental As %Boolean(XMLNAME = "experimental", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name of the publisher (Organization or individual)
Property publisher As %String(MAXLEN = 1000000, XMLNAME = "publisher", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contact details of the publisher.
Property contact As list Of HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.contact(XMLNAME = "contact", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Date for this version of the TestScript.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Natural language description of the TestScript.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Content intends to support these contexts.
/// <p>
/// use-context is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in use-context, 
/// you may formally EXTEND use-context to add codes to it.
Property useContext As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "useContext", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Scope and Usage this Test Script is for.
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Use and/or publishing restrictions.
Property copyright As %String(MAXLEN = 1000000, XMLNAME = "copyright", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Required capability that is assumed to function correctly on the FHIR server being tested.
Property metadata As HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.metadata(XMLNAME = "metadata", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// Whether or not the tests apply to more than one FHIR server.
Property multiserver As %Boolean(XMLNAME = "multiserver", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Fixture in the test script - by reference (uri)
Property fixture As list Of HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.fixture(XMLNAME = "fixture", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Reference of the validation profile.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property profile As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Placeholder for evaluated elements.
Property variable As list Of HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.variable(XMLNAME = "variable", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A series of required setup operations before tests are executed.
Property setup As HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.setup(XMLNAME = "setup", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A test in this script.
Property test As list Of HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.test(XMLNAME = "test", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A series of required clean up steps.
Property teardown As HS.FHIR.DTL.vDSTU2.Model.Element.TestScript.teardown(XMLNAME = "teardown", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript";

}
