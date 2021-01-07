Include HS.Test

/// Base class for all unit testing types
/// <p>
/// Convention used by this package:
/// <ul>
/// <li>All properties begin with capital letter
/// <li>XML attribute properties begin with lowercase in XML (using XMLNAME parameter)
/// <li>Common properites (like Name.First) are attributes to improve XML readability
/// </ul>
Class HS.Test.Types.Base Extends (%RegisteredObject, %XML.Adaptor) [ Abstract ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 0;

/// The name of the item used for session lookup 
Property Key As %String(MAXLEN = "", XMLNAME = "key", XMLPROJECTION = "ATTRIBUTE");

/// A reference to a parent item. References will change values already in the session
Property Ref As %String(MAXLEN = "", XMLNAME = "ref", XMLPROJECTION = "ATTRIBUTE");

/// A copy of the parent item. Copies will NOT change values already in the session
Property Copy As %String(MAXLEN = "", XMLNAME = "copy", XMLPROJECTION = "ATTRIBUTE");

}
