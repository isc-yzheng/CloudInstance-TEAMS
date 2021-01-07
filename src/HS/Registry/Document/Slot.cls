/// 
Class HS.Registry.Document.Slot Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Property Name As %String(MAXLEN = 32000, SELECTIVITY = "10%");

Property ValueList As list Of %String(MAXLEN = 32000, SELECTIVITY = "20%", STORAGEDEFAULT = "array");

/// Index only the first 450 characters of the ValueList value
Index ValueListIndex On (ValueList(ELEMENTS) As SQLUPPER(450), ValueList(KEYS));

Relationship Document As HS.Registry.Document(SELECTIVITY = ".0000667%", XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = Slots ];

Relationship RegistryPackage As HS.Registry.Document.RegistryPackage(SELECTIVITY = ".0000667%", XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = Slots ];

Index DocumentIndex On Document;

Index NameDocumentIndex On (Name, Document);

Index RegistryPackageDocumentIndex On (RegistryPackage, Document);

Relationship Classification As HS.Registry.Document.Classification(SELECTIVITY = ".0000667%") [ Cardinality = one, Inverse = Slots ];

Index ClassificationIndex On Classification;

/// used for single value entries (serviceStartTime ...)
ClassMethod ValueForNameDocument(pName = "", pDocument = "") As %String
{
	&sql(select valuelist into :value from hs_registry_document.slot_valuelist where slot->name=:pName and slot->document=:pDocument)
	Quit $S(SQLCODE:"",1:value)
}

ClassMethod ValueForNameRegistryPackage(pName = "", pRegistryPackage = "") As %String
{
	&sql(select valuelist into :value from hs_registry_document.slot_valuelist where slot->name=:pName and slot->RegistryPackage=:pRegistryPackage)
	Quit $S(SQLCODE:"",1:value)
}

Storage Default
{
<Data name="SlotDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Document</Value>
</Value>
<Value name="4">
<Value>RegistryPackage</Value>
</Value>
<Value name="5">
<Value>Classification</Value>
</Value>
</Data>
<Data name="ValueList">
<Attribute>ValueList</Attribute>
<Structure>subnode</Structure>
<Subscript>"ValueList"</Subscript>
</Data>
<DataLocation>^HS.Registry.Document.SlotD</DataLocation>
<DefaultData>SlotDefaultData</DefaultData>
<IdLocation>^HS.Registry.Document.SlotD</IdLocation>
<IndexLocation>^HS.Registry.Document.SlotI</IndexLocation>
<StreamLocation>^HS.Registry.Document.SlotS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
