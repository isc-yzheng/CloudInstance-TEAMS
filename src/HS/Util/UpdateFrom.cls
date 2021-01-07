/// Utility class to copy properties from one instance to another
Class HS.Util.UpdateFrom Extends %RegisteredObject [ Abstract ]
{

/// This is like CopyFrom, except that it won't overwrite data with nulls
ClassMethod UpdateFrom(tSrc As %RegisteredObject, ByRef pTarget As %RegisteredObject) As %Status [ CodeMode = generator ]
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
		
		If ($$$getClassType(tRuntimeType)=$$$cCLASSCLASSTYPEDATATYPE) && ($E(tProperty,1)'="%") {
			// Copy this property (if it exists in the src object)
			$$$GENERATE("	Set:$$$comMemberDefined(tType,"""_$$$cCLASSproperty_""","""_tProperty_""")&&($c(0)'[tSrc."_tProperty_") pTarget."_tProperty_" = $S(tSrc."_tProperty_"=$C(34,34):"""",1:tSrc."_tProperty_")")
		}
	}
	
	$$$GENERATE("	Quit $$$OK")

	Quit $$$OK
}

}
