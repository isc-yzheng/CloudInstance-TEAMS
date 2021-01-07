/// A string that may contain markdown syntax for optional processing by a mark down presentation engine<br>
/// Systems are not required to have markdown support, and there is considerable variation in markdown syntax, so the text should be readable without markdown processing. The preferred markdown syntax is described here: http://daringfireball.net/projects/markdown/syntax (and tests here: http://daringfireball.net/projects/downloads/MarkdownTest_1.0.zip)<br>
/// If the element is present, it must have either a @value, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Datatype.Markdown Extends HS.FHIR.vSTU3.Model.Base.Element [ CompileAfter = HS.FHIR.vSTU3.Model.Datatype.MarkdownPrimitive, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "markdown";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

Property value As HS.FHIR.vSTU3.Model.Datatype.MarkdownPrimitive(XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// Get new object, populated with specified data.
Method %OnNew(pValue As %String, pExtension As %RegisteredObject, pId As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pExtension)=0)&&($Data(pId)=0) Quit
		If $Get(pValue)'="" Set ..value = pValue
		If $Get(pId)'="" Set ..id = pId
		#; pExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pExtension)) {
			If (pExtension.%Extends("%Collection.ListOfObj")=0)&&(pExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..extension.Insert(pExtension) Quit:$$$ISERR(tSC)
			} ElseIf pExtension.Count()>0 {
				For i = 1:1:pExtension.Count() {
					Set tSC = ..extension.Insert(pExtension.GetAt(i)) Quit:$$$ISERR(tSC)
				}
			}
			Quit:$$$ISERR(tSC)
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
