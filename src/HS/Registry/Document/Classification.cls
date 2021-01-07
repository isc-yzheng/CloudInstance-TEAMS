Include HS.HC

Class HS.Registry.Document.Classification Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Property Attributes As array Of %String(MAXLEN = 32000, STORAGEDEFAULT = "array", XMLNAME = "Attributes", XMLPROJECTION = "ELEMENT");

Index AttributesIndex On (Attributes(ELEMENTS), Attributes(KEYS));

Property IID As %String(MAXLEN = 256, SELECTIVITY = 1, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property Title As HS.Registry.Document.Type.ValueType(SELECTIVITY = "7%", XMLNAME = "Title", XMLPROJECTION = "ELEMENT");

Property Comments As HS.Registry.Document.Type.ValueType(SELECTIVITY = "99%", XMLNAME = "Comments", XMLPROJECTION = "ELEMENT");

Property Name As list Of HS.Registry.Document.Type.ValueType(SELECTIVITY = "7%", XMLNAME = "Name", XMLPROJECTION = "ELEMENT");

Property Description As list Of HS.Registry.Document.Type.ValueType(SELECTIVITY = "99%", XMLNAME = "Description", XMLPROJECTION = "ELEMENT");

Property NodeRepresentation As %String(MAXLEN = "", SELECTIVITY = "7%");

Property ClassificationScheme As %String(MAXLEN = "", SELECTIVITY = "10%");

Property ClassificationNode As %String(MAXLEN = "", SELECTIVITY = "50%");

Property Scheme As %String(MAXLEN = "", SELECTIVITY = "99.9%");

Relationship Slots As HS.Registry.Document.Slot(SELECTIVITY = ".04%", XMLNAME = "Slot", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = Classification ];

Relationship RegistryPackage As HS.Registry.Document.RegistryPackage(SELECTIVITY = ".022%", XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = Classifications ];

Relationship Document As HS.Registry.Document(SELECTIVITY = ".0052%", XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = Classifications ];

Index DocumentIndex On Document;

Index SchemeIndex On ClassificationScheme [ Type = bitmap ];

Index NodeIndex On ClassificationNode [ Type = bitmap ];

Index NodeRepresentationIndex On NodeRepresentation;

Index RegistryPackageIndex On RegistryPackage;

Index IIDIndex On IID [ Unique ];

Property ClassifiedObject As %String(MAXLEN = 256, SELECTIVITY = ".0000269%") [ Calculated, SqlComputeCode = {Set {*} = $S({Document}'="":##class(HS.Registry.Document).%OpenId({Document}).IID,{RegistryPackage}'="":##class(HS.Registry.Document.RegistryPackage).%OpenId({RegistryPackage}).IID,1:"")}, SqlComputed ];

Method Validate(pOutputSet) As %Boolean
{
	try {
		Set tCodingScheme = "",tValid=0
		For tIdx=1:1:..Slots.Count() {
			Set tSlot=..Slots.GetAt(tIdx)
			If tSlot.Name="codingScheme" Set tCodingScheme=tSlot.ValueList.GetAt(1) Quit
		}
		Set tSC=##class(HS.IHE.CodedEntry).ValidateEntry(..ClassificationScheme,..NodeRepresentation,tCodingScheme,.tValid)
		If 'tValid {
			Do pOutputSet.logError("XDSRegistryMetadataError","Error","Error Validating Classification scheme:"_..ClassificationScheme_" node:"_..NodeRepresentation_" codingscheme:"_tCodingScheme)
		}

	} catch eException {
		Do pOutputSet.logError("XDSRegistryMetadataError","Error","Internal error validating Classifications:"_$ze)
		throw eException
	}
	Quit tValid
}

/// find ClassifiedObject references for scheme
ClassMethod DocumentsForScheme(pScheme As %String, pValue As %String, ByRef pDocuments As %String, pOutputSet As HS.Types.IHE.Errors) As %Status
{
	try {
		Set tSC=$$$OK
		Set tValueCode=$p(pValue,"^")
		Set tValueScheme=$p(pValue,"^",3)
		If (tValueCode="") || (tValueScheme="") {
			Do pOutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_pValue)
			Quit
		}
		Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
		Set tSQL="select slot->classification->classifiedObject as ClassifiedObject from hs_registry_document.Slot_valuelist where slot->classification->classificationscheme=? and slot->classification->noderepresentation "_tEval_"? and valuelist=?"
		Set tRS=##class(%ResultSet.SQL).%Prepare(tSQL,.tER,"",pScheme,tValueCode,tValueScheme)
		If $isObject(tER) {
			Do pOutputSet.logError("XDSRegistryMetadataError","Error","Unable to process query for "_tSQL)
			Quit
		}
		While tRS.%Next() {
			Set pDocuments(tRS.%Get("ClassifiedObject"))=""
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod DocumentIDsForScheme(pScheme As %String, pValue As %String, %pDocuments As %String, pOutputSet As HS.Types.IHE.Errors, pSchemeText = "") As %Status
{
	try {
		Set tSC=$$$OK
		Set tValueCode=$p(pValue,"^")
		Set tValueScheme=$p(pValue,"^",3)
		If (tValueCode="") || (tValueScheme="") {
			Do pOutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_pValue)
			Quit
		}
		Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
		Set tSQL="select id,iid from hs_registry.document where iid in (select slot->classification->classifiedObject as ClassifiedObject from hs_registry_document.Slot_valuelist where slot->classification->classificationscheme=? and slot->classification->noderepresentation "_tEval_"? and valuelist=?)"
		Set tRS=##class(%ResultSet.SQL).%Prepare(tSQL,.tER,"",pScheme,tValueCode,tValueScheme)
		If $isObject(tER) {
			Do pOutputSet.logError("XDSRegistryMetadataError","Error","Unable to process query for "_tSQL)
			Quit
		}
		While tRS.%Next() {
			Set @%pDocuments@(tRS.%GetData(1))=tRS.%GetData(2)
		}
		Set tField=$p(pSchemeText,"$XDSDocumentEntry",2)
		If ",ClassCode,HealthcareFacilityTypeCode,TypeCode,PracticeSettingCode,FormatCode,"'[(","_tField_",") Quit
		Set tSQL="select id,iid from hs_registry.document where "_tField_"_Code "_tEval_"? and "_tField_"_CodingScheme=?"
		/*
		If pSchemeText="$XDSDocumentEntryClassCode" {
			Set tSQL="select id,iid from hs_registry.document where ClassCode_Code "_tEval_"? and ClassCode_CodingScheme=?"
		} ElseIf pSchemeText="$XDSDocumentEntryHealthcareFacilityTypeCode" {
			Set tSQL="select id,iid from hs_registry.document where HealthCareFacilityTypeCode_Code "_tEval_"? and HealthCareFacilityTypeCode_CodingScheme=?"
		} 
	Set pFilterCodes("$XDSDocumentEntryPracticeSettingCode")="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead"
	Set pFilterCodes("$XDSDocumentEntryClassificationNode")="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1"
	Set pFilterCodes("$XDSDocumentEntryClassCode")="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a"
	Set pFilterCodes("$XDSDocumentEntryConfidentialityCode")="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f"
	Set pFilterCodes("$XDSDocumentEntryEventCodeList")="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4"
	Set pFilterCodes("$XDSDocumentEntryFormatCode")="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d"
	Set pFilterCodes("$XDSDocumentEntryHealthcareFacilityTypeCode")="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1"
	Set pFilterCodes("$XDSDocumentEntryTypeCode")="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983"
		*/		
		If tSQL]"" {
			Set tRS=##class(%ResultSet.SQL).%Prepare(tSQL,.tER,"",tValueCode,tValueScheme)
			If $isObject(tER) {
				Do pOutputSet.logError("XDSRegistryMetadataError","Error","Unable to process query for "_tSQL)
				Quit
			}
			While tRS.%Next() {
				Set @%pDocuments@(tRS.%GetData(1))=tRS.%GetData(2)
			}
		}

	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

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
			Set tSC = tSlot.%DeleteId(tSlot.%Id()) $$$HSThrowErrors(tSC)
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
<Data name="ClassificationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>NodeRepresentation</Value>
</Value>
<Value name="6">
<Value>ClassificationScheme</Value>
</Value>
<Value name="7">
<Value>ClassificationNode</Value>
</Value>
<Value name="8">
<Value>Scheme</Value>
</Value>
<Value name="9">
<Value>RegistryPackage</Value>
</Value>
<Value name="10">
<Value>Document</Value>
</Value>
<Value name="11">
<Value>ClassifiedObject</Value>
</Value>
<Value name="12">
<Value>Title</Value>
</Value>
</Data>
<Data name="Comments">
<Attribute>Comments</Attribute>
<Structure>subnode</Structure>
<Subscript>"Comments"</Subscript>
</Data>
<DataLocation>^HS.Registry.DocClassificationD</DataLocation>
<DefaultData>ClassificationDefaultData</DefaultData>
<IdLocation>^HS.Registry.DocClassificationD</IdLocation>
<IndexLocation>^HS.Registry.DocClassificationI</IndexLocation>
<StreamLocation>^HS.Registry.DocClassificationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
