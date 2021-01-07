Class HS.FHIR.vDSTU2.Model.Resource.DiagnosticReport.Image Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticReport.Image";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticReport.Image";

/// A comment about the image. Typically, this is used to provide an explanation for why the image is included, or to draw the viewer's attention to important features.
Property comment As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "comment");

/// Reference to the image source.
Property link As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "link") [ Required ];

/// Set method for the "comment" property.
Method SetComment(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..comment = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "link" property.
Method SetLink(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..link = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
