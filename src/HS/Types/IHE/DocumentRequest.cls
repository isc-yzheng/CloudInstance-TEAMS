Class HS.Types.IHE.DocumentRequest Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property HomeCommunityId As %String(MAXLEN = 255);

Property RepositoryUniqueId As %String(MAXLEN = 255);

Property DocumentUniqueId As %String(MAXLEN = 255);

Property AdditionalInfo As array Of %String(MAXLEN = 1024, XMLPROJECTION = "NONE");

}
