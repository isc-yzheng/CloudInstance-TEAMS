Class HS.Registry.Document.FHIR Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Property DocumentUniqueID As %String(MAXLEN = "", SELECTIVITY = 1) [ Required ];

Property RepositoryUniqueID As %String(MAXLEN = "") [ Required ];

Property FHIRVersion As %String(MAXLEN = "");

Property FHIRResourceId As %String(MAXLEN = "") [ Required ];

Index DocumentIndex On (DocumentUniqueID, RepositoryUniqueID, FHIRVersion) [ Unique ];

Index FHIRIndex On (FHIRVersion, FHIRResourceId) [ Unique ];

ClassMethod GetFHIRResourceId(pDocumentUniqueId As %String, pRepositoryUniqueId As %String, pFHIRVersion As %String, ByRef pFHIRResourceId As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pFHIRResourceId = ""
	
	Try {
		If $Get(pDocumentUniqueId)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Document Unique Id not specified")
		} ElseIf $Get(pRepositoryUniqueId)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Repository Unique Id not specified")
		} ElseIf $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified")
		} ElseIf '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified")
		}
		If $$$ISERR(tSC) Quit
		
		Set tObj = ..DocumentIndexOpen(pDocumentUniqueId, pRepositoryUniqueId, pFHIRVersion)
		
		If $IsObject($Get(tObj)) {
			Set pFHIRResourceId = tObj.FHIRResourceId
		} Else {
			Set tFHIRAbstractClass = "HS.FHIR.v"_pFHIRVersion_".Repository.Resource.Abstract"
			Set tNewResourceId = $ClassMethod(tFHIRAbstractClass, "GenerateResourceId", "DocumentReference")
			Set tObj = ..%New()
			Set tObj.DocumentUniqueID = pDocumentUniqueId
			Set tObj.RepositoryUniqueID = pRepositoryUniqueId
			Set tObj.FHIRResourceId = tNewResourceId
			Set tObj.FHIRVersion = pFHIRVersion
			Set tSC = tObj.%Save()
			If $$$ISOK(tSC) Set pFHIRResourceId = tNewResourceId
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Storage Default
{
<Data name="FHIRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentUniqueID</Value>
</Value>
<Value name="3">
<Value>RepositoryUniqueID</Value>
</Value>
<Value name="4">
<Value>FHIRVersion</Value>
</Value>
<Value name="5">
<Value>FHIRResourceId</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Document.FHIRD</DataLocation>
<DefaultData>FHIRDefaultData</DefaultData>
<IdLocation>^HS.Registry.Document.FHIRD</IdLocation>
<IndexLocation>^HS.Registry.Document.FHIRI</IndexLocation>
<StreamLocation>^HS.Registry.Document.FHIRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
