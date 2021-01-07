/// Utility class to copy properties from one instance to another
Class HS.Util.CopyFrom Extends %RegisteredObject [ Abstract ]
{

ClassMethod CopyFrom(tSrc As %RegisteredObject, ByRef pTarget As %RegisteredObject, pCopyCollections As %Boolean = 1) As %Status [ CodeMode = generator ]
{
	$$$GENERATE("	If '$IsObject($GET(pTarget)) {")
	$$$GENERATE("		Set pTarget = ..%New()")
	$$$GENERATE("	} Else {")
	$$$GENERATE("		Quit:'pTarget.%Extends("""_%class_""") $$$ERROR($$$ObjectInstanceRequired)")
	$$$GENERATE("	}")
	$$$GENERATE("	Set tType = tSrc.%ClassName(1)")
	
	Set tProperty = ""
	For {
		Set tProperty = $$$comMemberNext(%class,$$$cCLASSproperty,tProperty)
		Quit:tProperty=""
		
		$$$comMemberKeyGetLvar(tRuntimeType,%class,$$$cCLASSproperty,tProperty,$$$cPROPruntimetype)
		$$$comMemberKeyGetLvar(tCalculated,%class,$$$cCLASSproperty,tProperty,$$$cPROPcalculated)
		If ($$$getClassType(tRuntimeType)=$$$cCLASSCLASSTYPEDATATYPE)
			 ||(tRuntimeType="%Collection.ListOfDT")||(tRuntimeType="%Collection.ArrayOfDT")
			 && ($E(tProperty,1)'="%") && 'tCalculated {
			Set tCheckCollection=""
			If tRuntimeType="%Collection.ListOfDT"||(tRuntimeType="%Collection.ArrayOfDT") Set tCheckCollection="&&pCopyCollections"
			// Copy this property (if it exists in the src object)
			$$$GENERATE("	Set:$$$comMemberDefined(tType,"""_$$$cCLASSproperty_""","""_tProperty_""")"_tCheckCollection_" pTarget."_tProperty_" = tSrc."_tProperty)
		}
	}
	
	$$$GENERATE("	Quit $$$OK")

	Quit $$$OK
}

}
