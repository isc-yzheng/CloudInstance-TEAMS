Include HS.HC

Class HS.Registry.Document.ExternalIdentifier Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Property Attributes As array Of %String(MAXLEN = 32000, STORAGEDEFAULT = "array", XMLNAME = "Attributes", XMLPROJECTION = "ELEMENT");

Index AttributesIndex On (Attributes(ELEMENTS), Attributes(KEYS));

Property IID As %String(MAXLEN = 256, SELECTIVITY = 1, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property RegistryObject As %String(MAXLEN = "", SELECTIVITY = .000013);

Property IdentificationScheme As %String(MAXLEN = "", SELECTIVITY = "20%");

Property IdentificationValue As %String(MAXLEN = 255, SELECTIVITY = ".0044%");

Property Classifications As list Of HS.Registry.Document.Classification(XMLNAME = "Classification", XMLPROJECTION = "ELEMENT");

Property Slots As list Of HS.Registry.Document.Slot(SELECTIVITY = ".04%", XMLNAME = "Slot", XMLPROJECTION = "ELEMENT");

Property Title As HS.Registry.Document.Type.ValueType(SELECTIVITY = "20%", XMLNAME = "Title", XMLPROJECTION = "ELEMENT");

Property Comments As HS.Registry.Document.Type.ValueType(SELECTIVITY = "99%", XMLNAME = "Comments", XMLPROJECTION = "ELEMENT");

Property Name As list Of HS.Registry.Document.Type.ValueType(SELECTIVITY = "20%", XMLNAME = "Name", XMLPROJECTION = "ELEMENT");

Property Description As list Of HS.Registry.Document.Type.ValueType(SELECTIVITY = "99%", XMLNAME = "Description", XMLPROJECTION = "ELEMENT");

Index IdentificationSchemeIndex On IdentificationScheme [ Type = bitmap ];

// Index RegistryObjectIndex On RegistryObject;

Index ValueIndex On IdentificationValue;

Index IIDIndex On IID [ Unique ];

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ ServerOnly = 1 ]
{
	try {
		Set obj=..%Open(oid,4,.tSC) $$$HSThrowErrors(tSC)
		tstart
		For tIdx=obj.Slots.Count():-1:1 {
			Set tSlot = obj.Slots.GetAt(tIdx)
			//Do obj.Slots.RemoveAt(tIdxSlot)
			Set tSC = tSlot.%DeleteId(tSlot.%Id()) $$$HSThrowErrors(tSC)
		}

		For tIdx=obj.Classifications.Count():-1:1 {
			Set tClassification = obj.Classifications.GetAt(tIdx)
			Set tSC=tClassification.%DeleteId(tClassification.%Id()) $$$HSThrowErrors(tSC)
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		trollback
	} Else {
		tcommit
	}
	Quit tSC
}

Storage Default
{
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="Comments">
<Attribute>Comments</Attribute>
<Structure>subnode</Structure>
<Subscript>"Comments"</Subscript>
</Data>
<Data name="ExternalIdentifierDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IID</Value>
</Value>
<Value name="3">
<Value>RegistryObject</Value>
</Value>
<Value name="4">
<Value>IdentificationScheme</Value>
</Value>
<Value name="5">
<Value>IdentificationValue</Value>
</Value>
<Value name="6">
<Value>Classifications</Value>
</Value>
<Value name="7">
<Value>Slots</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Description</Value>
</Value>
<Value name="10">
<Value>Title</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.DocExternalIdD</DataLocation>
<DefaultData>ExternalIdentifierDefaultData</DefaultData>
<IdLocation>^HS.Registry.DocExternalIdD</IdLocation>
<IndexLocation>^HS.Registry.DocExternalIdI</IndexLocation>
<StreamLocation>^HS.Registry.DocExternalIdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
