/// A human-readable formatted text, 
/// including images.
Class HS.FHIR.DTL.vSTU3.Model.Base.Narrative Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// generated | extensions | additional | empty
/// <p>
/// narrative-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend narrative-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Limited xhtml content. 
/// The narrative SHALL have some non-whitespace content (text or an image). 
/// The narrative SHALL contain only the basic html formatting elements and attributes described in chapters 7-11 (except section 4 of chapter 9) and 15 of the HTML 4.0 standard, 
/// <a> elements (either name or href), 
/// images and internally contained style attributes. 
/// The inner portion of the div content is often used for the innerHTML property in a browser. 
/// In order to simplify this kind of processing, 
/// when the narrative is represented in JSON, 
/// it SHALL be encoded so that the characters between the first '>' and the last '<' delimiters is the content of the <div> element; 
/// e.g. 
/// "div": "<div>text</div>" is legal, 
/// but this is not: "div": "<?xml ...><div>text</div>" Note that the XHTML is contained in general XML so there is no support for HTML entities like &nbsp; 
/// or &copy; 
/// etc. 
/// Unicode characters SHALL be used instead. 
/// Unicode &#160; 
/// substitutes for &nbsp;.
Property div As %String(MAXLEN = 1000000, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://www.w3.org/1999/xhtml", XMLNAME = "div", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Narrative";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Narrative";

}
