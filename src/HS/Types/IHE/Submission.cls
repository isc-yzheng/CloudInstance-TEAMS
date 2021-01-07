Class HS.Types.IHE.Submission Extends HS.Types.IHE.Errors
{

Parameter XMLIGNORENULL = "inputonly";

Property Documents As list Of HS.Registry.Document(XMLNAME = "Document", XMLPROJECTION = "ELEMENT");

/// each classification at this level needs to be assigned to defined submission set or folder
Property Classifications As list Of HS.Registry.Document.Classification(XMLNAME = "Classification", XMLPROJECTION = "ELEMENT");

/// Either a submission set or a folder need to determine by classification and move to correct class
Property RegistryPackages As list Of HS.Registry.Document.RegistryPackage(XMLNAME = "RegistryPackage", XMLPROJECTION = "ELEMENT");

Property Associations As list Of HS.Registry.Document.Association(XMLNAME = "Association", XMLPROJECTION = "ELEMENT");

Property ObjectRefs As list Of %String(XMLNAME = "ObjectRef", XMLPROJECTION = "ELEMENT");

Property RegistryPackagesStream As %Stream.GlobalCharacter(CONTENT = "MIXED", XMLIO = "OUT", XMLSTREAMMODE = "LINE");

Property AssociationsStream As %Stream.GlobalCharacter(CONTENT = "MIXED", XMLIO = "OUT", XMLSTREAMMODE = "LINE");

Property DocumentsStream As %Stream.GlobalCharacter(CONTENT = "MIXED", XMLIO = "OUT", XMLSTREAMMODE = "LINE");

/// Items added during registration / update request, that should not be considered when doing other validation
/// for example, UpdateAvailabilityStatus locates the document updates the status adds it to the submission set
/// but there shouldn't be a check to see if there is a hasmember to the submission set since it wasn't really in the set
Property AddedItems As array Of %String [ Transient ];

Storage Default
{
<Data name="ErrorsState">
<Value name="1">
<Value>Errors</Value>
</Value>
<Value name="2">
<Value>HighestError</Value>
</Value>
<Value name="3">
<Value>Documents</Value>
</Value>
<Value name="4">
<Value>Classifications</Value>
</Value>
<Value name="5">
<Value>RegistryPackages</Value>
</Value>
<Value name="6">
<Value>Associations</Value>
</Value>
<Value name="7">
<Value>ObjectRefs</Value>
</Value>
<Value name="8">
<Value>RegistryPackagesStream</Value>
</Value>
<Value name="9">
<Value>AssociationsStream</Value>
</Value>
<Value name="10">
<Value>DocumentsStream</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
