Class HS.Registry.Document.Association Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Property Attributes As array Of %String(MAXLEN = 32000, STORAGEDEFAULT = "array", XMLNAME = "Attributes", XMLPROJECTION = "ELEMENT");

Index AttributesIndex On (Attributes(ELEMENTS), Attributes(KEYS));

Property IID As %String(MAXLEN = 256, SELECTIVITY = 1, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property LogicalIID As %String(MAXLEN = 256, SELECTIVITY = 1);

Property AssociationType As HS.Types.IHE.Association(MAXLEN = "", SELECTIVITY = "99.9%");

Property SourceObject As %String(MAXLEN = "", SELECTIVITY = ".0001%");

Property TargetObject As %String(MAXLEN = "", SELECTIVITY = ".0001%");

Property Classifications As list Of HS.Registry.Document.Classification(SELECTIVITY = "99.9%", XMLNAME = "Classification", XMLPROJECTION = "ELEMENT");

Property Status As HS.Types.IHE.Status(SELECTIVITY = "99.9%", XMLNAME = "Status", XMLPROJECTION = "Element");

/// Hold on to OriginalStatus and NewStatus for MetadataUpdate
Property Slots As list Of HS.IHE.XDSb.Types.Slot(STORAGEDEFAULT = "array", XMLNAME = "Slot", XMLPROJECTION = "ELEMENT");

Index SourceObjectIndex On SourceObject;

Index TargetObjectIndex On TargetObject;

Index IIDIndex On IID [ Unique ];

Index LogicalIIDIndex On LogicalIID;

Index StatusIndex On Status [ Type = bitmap ];

Index AssociationTypeIndex On AssociationType [ Type = bitmap ];

/// Used for locating association IIDs for a given IID for confirmation in DeleteDocumentSet
ClassMethod AssociationIIDsForIID(pIID, ByRef pAryIIDs) As %Status
{
	Set tSQL="select iid,AssociationType,sourceobject,targetobject from hs_registry_document.association where (sourceobject=? or targetobject=?) "
	Set tRS = ##class(%SQL.Statement).%ExecDirect(.tStatement,tSQL,pIID,pIID)
	If tRS.SQLCODE Quit $$$ERROR($$$GeneralError,tRS.%Message)
	While tRS.%Next() { 
		Set pType = tRS.%GetData(2) 
		Set pAryIIDs(tRS.%GetData(1))=pType  /// ensure the association is in the deletion set
		If ",urn:ihe:iti:2007:AssociationType:RPLC,urn:ihe:iti:2007:AssociationType:XFRM,urn:ihe:iti:2007:AssociationType:APND,urn:ihe:iti:2007:AssociationType:XFRM_RPLC"[(","_pType_",") {
			Set tOtherObject=$S(pIID=tRS.%Get("SourceObject"):tRS.%Get("TargetObject"),1:tRS.%Get("SourceObject"))
			Set tObject = ##class(HS.Registry.Document).IIDIndexOpen(tOtherObject)
			Set pAryIIDs(tOtherObject)=pType // the other object needs to be in the deletion set
		}
	}
	Quit $$$OK
}

ClassMethod IDsForIID(pIID, ByRef pAryIDs, pType = "HasMember") As %Status
{
	If pType="" {
		Set tRS = ##class(%SQL.Statement).%ExecDirect(.tStatement,"select id from hs_registry_document.association where (sourceobject=? or targetobject=?)",pIID,pIID)
	} Else {
		Set tRS = ##class(%SQL.Statement).%ExecDirect(.tStatement,"select id from hs_registry_document.association where (sourceobject=? or targetobject=?) and AssociationType=?",pIID,pIID,pType)
	}
	If tRS.SQLCODE Quit $$$ERROR($$$GeneralError,tRS.%Message)
	While tRS.%Next() { 
		Set pAryIDs(tRS.ID)=""
	}
	Quit $$$OK
}

ClassMethod IDsForTargetIID(pIID, ByRef pAryIDs, pType = "HasMember") As %Status
{
	
	&sql(DECLARE CURTarget CURSOR FOR select id into :tID from hs_registry_document.association where targetobject=:pIID and AssociationType=:pType)
	&sql(OPEN CURTarget)
	For {
		&sql(FETCH CURTarget)
		Quit:SQLCODE
		Set pAryIDs(tID)=""
	}
	&sql(CLOSE CURTarget)
	Quit $$$OK
}

/// return targetObject IDs for associations given the sourceObjectID (submission set)
ClassMethod TargetIDsForSourceIID(pIID, ByRef pAryIDs, pType = "HasMember") As %Status
{
	
	&sql(DECLARE CURSource CURSOR FOR select ID,targetObject into :tID,:tTargetID from hs_registry_document.association where sourceObject=:pIID and AssociationType=:pType)
	&sql(OPEN CURSource)
	For {
		&sql(FETCH CURSource)
		Quit:SQLCODE
		Set pAryIDs(tTargetID)=tID
	}
	&sql(CLOSE CURSource)
	Quit $$$OK
}

/// return targetObject IDs for associations given the sourceObjectID (submission set)
ClassMethod SourceIDsForTargetIID(pIID, ByRef pAryIDs, pType = "HasMember") As %Status
{
	&sql(DECLARE CURSourceForTarget CURSOR FOR select ID,sourceObject into :tID,:tSourceID from hs_registry_document.association where targetObject=:pIID and AssociationType=:pType)
	&sql(OPEN CURSourceForTarget)
	For {
		&sql(FETCH CURSourceForTarget)
		Quit:SQLCODE
		Set pAryIDs(tSourceID)=tID
	}
	&sql(CLOSE CURSourceForTarget)
	Quit $$$OK
}

/// return targetObject IDs for associations given the sourceObjectID (submission set)
ClassMethod IDsForSourceAndTargetIID(pSourceIID, pTargetIID, ByRef pAryIDs, pType = "HasMember") As %Status
{
	
	&sql(DECLARE CURSourceTarget CURSOR FOR select ID into :tID from hs_registry_document.association where sourceObject=:pSourceIID and targetObject=:pTargetIID and AssociationType=:pType)
	&sql(OPEN CURSourceTarget)
	For {
		&sql(FETCH CURSourceTarget)
		Quit:SQLCODE
		Set pAryIDs(tID)=""
	}
	&sql(CLOSE CURSourceTarget)
	Quit $$$OK
}

Storage Default
{
<Data name="AssociationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IID</Value>
</Value>
<Value name="3">
<Value>AssociationType</Value>
</Value>
<Value name="4">
<Value>SourceObject</Value>
</Value>
<Value name="5">
<Value>TargetObject</Value>
</Value>
<Value name="6">
<Value>Classifications</Value>
</Value>
<Value name="7">
<Value>LogicalIID</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
</Data>
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="Slots">
<Attribute>Slots</Attribute>
<Structure>subnode</Structure>
<Subscript>"Slots"</Subscript>
</Data>
<DataLocation>^HS.Registry.DocAssociationD</DataLocation>
<DefaultData>AssociationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.DocAssociationD</IdLocation>
<IndexLocation>^HS.Registry.DocAssociationI</IndexLocation>
<StreamLocation>^HS.Registry.DocAssociationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
