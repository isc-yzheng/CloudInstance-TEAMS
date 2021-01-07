/// HS.FHIR.ReferenceUtils provides a series of methods to simplify the
/// handling of FHIR properties that are typed as the FHIR reference
/// data type.
Class HS.FHIR.ReferenceUtils Extends %RegisteredObject
{

/// UpdateReferences generate a method that allows for streamlined
/// checking for existing reference values in an object and updates
/// those reference values as per the data previously gathered in
/// the pReferences array.
Method UpdateReferences(ByRef pReferences As %String, pBundleEntryNumber As %Integer = 0) [ CodeMode = objectgenerator ]
{
	#; pReferences is an array
	
	#; pReferences(OldReferenceValue, BundleEntryNumber) = NewReferenceValue
	
	#; BundleEntryNumber subscript is necessary because contained resource ids
	#; only need be unique within the resource in which they are contained.
	
	Set tReferenceType = "Reference"
	
	Set tRoot = $Piece(%compiledclass.Name,".Model",1)_".Model."
	
	Set tRootLen = $Length(tRoot)
	Set tResourceRoot = tRoot_"Resource."
	Set tResourceRootLen = $Length(tResourceRoot)
	
	Set tExcludeNames("%Concurrency") = ""
	Set tExcludeNames("div") = ""
	
	Set tIncludeTypes(tRoot_"Base.Annotation") = ""
	Set tIncludeTypes(tRoot_"Base.Identifier") = ""
	Set tIncludeTypes(tRoot_"Base.Reference") = ""
	Set tIncludeTypes(tRoot_"Base.Signature") = ""
	
	If (%class.Abstract) {
		Quit $$$OK
	}
	Do %code.WriteLine(" Set tSC = $$$OK")
	Do %code.WriteLine(" Try {")
	
	For n=1:1:%compiledclass.Properties.Count() {
		Set tPropDef = %compiledclass.Properties.GetAt(n)
		Set tPropType = tPropDef.Type
		Set tPropTypeShort = $Piece(tPropType,".",$Length(tPropType,"."))
		Set tPropColl = (tPropDef.Collection'="")
		Set tPropName = ".."_tPropDef.Name
		If tPropName="..url" {
			#; special case - is a url, is not a collection
			Do %code.WriteLine("  If $IsObject("_tPropName_") {")
			Do %code.WriteLine("   Set tRefVal = "_tPropName_".value")
			Do %code.WriteLine("   If (tRefVal'="""")&&($Data(pReferences(tRefVal, pBundleEntryNumber))) Set "_tPropName_".value = pReferences(tRefVal, pBundleEntryNumber)")
			Do %code.WriteLine("  }")
			Continue
		}
		
		If tPropDef.Name="extension" {
			Do %code.WriteLine("  If ($IsObject(..extension))&&(..extension.Count()>0) {")
			Do %code.WriteLine("   For i = 1:1:..extension.Count() {")
			Do %code.WriteLine("    If (($IsObject(..extension.GetAt(i).valueReference))) {")
			Do %code.WriteLine("     Set tRefVal = ..extension.GetAt(i).valueReference.reference.value")
			Do %code.WriteLine("     If (tRefVal'="""")&&($Data(pReferences(tRefVal, pBundleEntryNumber))) Set ..extension.GetAt(i).valueReference.reference.value = pReferences(tRefVal, pBundleEntryNumber)")
			Do %code.WriteLine("    }")
			Do %code.WriteLine("   }")
			Do %code.WriteLine("  }")
			Continue
		}
		
		If ($Data(tExcludeNames(tPropDef.Name)))||($Extract(tPropDef.Name,1,2)="%%")||(($Extract(tPropType,1,tResourceRootLen)'=tResourceRoot)&&('$Data(tIncludeTypes(tPropType)))) Continue
		
		If $Piece(%compiledclass.Name,".",$Length(%compiledclass.Name,"."))="ResourceContainer" {
			Do %code.WriteLine("  If $IsObject("_tPropName_") Set tSC = "_tPropName_".UpdateReferences(.pReferences) If $$$ISERR(tSC) Quit")
		} ElseIf (tPropTypeShort=tReferenceType)&&('tPropColl) {
			#; is a reference, is not a collection
			Do %code.WriteLine("  If $IsObject("_tPropName_") {")
			Do %code.WriteLine("   Set tRefVal = "_tPropName_".reference.value")
			Do %code.WriteLine("   If (tRefVal'="""")&&($Data(pReferences(tRefVal, pBundleEntryNumber))) Set "_tPropName_".reference.value = pReferences(tRefVal, pBundleEntryNumber)")
			Do %code.WriteLine("  }")
		} ElseIf (tPropTypeShort=tReferenceType)&&(tPropColl) {
			#; is a reference, is a collection
			Do %code.WriteLine("  If ($IsObject("_tPropName_"))&&("_tPropName_".Count()>0) {")
			Do %code.WriteLine("   For i = 1:1:"_tPropName_".Count() {")
			Do %code.WriteLine("    Set tRefVal = "_tPropName_".GetAt(i).reference.value")
			Do %code.WriteLine("    If (tRefVal'="""")&&($Data(pReferences(tRefVal, pBundleEntryNumber))) Set "_tPropName_".GetAt(i).reference.value = pReferences(tRefVal, pBundleEntryNumber)")
			Do %code.WriteLine("   }")
			Do %code.WriteLine("  }")
		} ElseIf (tPropTypeShort'=tReferenceType)&&('tPropColl) {
			#; is not a reference, is not a collection
			Do %code.WriteLine("  If $IsObject("_tPropName_") Set tSC = "_tPropName_".UpdateReferences(.pReferences, pBundleEntryNumber) If $$$ISERR(tSC) Quit")
		} ElseIf (tPropTypeShort'=tReferenceType)&&(tPropColl) {
			#; is not a reference, is a collection
			Do %code.WriteLine("  If ($IsObject("_tPropName_"))&&("_tPropName_".Count()>0) {")
			Do %code.WriteLine("   For i = 1:1:"_tPropName_".Count() {")
			Do %code.WriteLine("    Set tSC = "_tPropName_".GetAt(i).UpdateReferences(.pReferences, pBundleEntryNumber) If $$$ISERR(tSC) Quit")
			Do %code.WriteLine("   }")
			Do %code.WriteLine("   If $$$ISERR(tSC) Quit")
			Do %code.WriteLine("  }")
		}
	}
	
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Catch(ex) {")
	Do %code.WriteLine("  Set tSC = ex.AsStatus()")
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Quit tSC")
	Quit $$$OK
}

Method GetReferenceMap(ByRef pEntryIndex As %String, pBundleEntryNumber, ByRef pReferenceMap As %String) [ CodeMode = objectgenerator ]
{
	#; pReferenceMap(targetBundleEntryNumber, sourceBundleEntryNumber) = reference value
	
	#; targetBundleEntryNumber = Bundle entry to add source resource as a contained
	
	
	Set tReferenceType = "HS.FHIR.Model.Base.Reference"
	
	Set tRoot = "HS.FHIR.Model."
	Set tRootLen = $Length(tRoot)
	Set tResourceRoot = tRoot_"Resource."
	Set tResourceRootLen = $Length(tResourceRoot)
	
	Set tExcludeNames("%Concurrency") = ""
	Set tExcludeNames("div") = ""
	Set tExcludeNames("encounter") = ""
	Set tExcludeNames("patient") = ""
	Set tExcludeNames("subject") = ""
	
	Set tIncludeTypes(tRoot_"Base.Annotation") = ""
	Set tIncludeTypes(tRoot_"Base.Identifier") = ""
	Set tIncludeTypes(tRoot_"Base.Reference") = ""
	Set tIncludeTypes(tRoot_"Base.Signature") = ""
	
	If (%class.Abstract) {
		Quit $$$OK
	}
	Do %code.WriteLine(" Set tSC = $$$OK")
	Do %code.WriteLine(" Try {")
	
	For n=1:1:%compiledclass.Properties.Count() {
		Set tPropDef = %compiledclass.Properties.GetAt(n)
		Set tPropType = tPropDef.Type
		Set tPropColl = (tPropDef.Collection'="")
		Set tPropName = ".."_tPropDef.Name
		If tPropName="..url" {
			/*
			#; special case - is a url, is not a collection
			Do %code.WriteLine("  If $IsObject("_tPropName_") {")
			Do %code.WriteLine("   Set tRefVal = "_tPropName_".value")
			Do %code.WriteLine("   If (tRefVal'="""")&&($Data(pEntryIndex(""ByFullUrl"",tRefVal))) Set pReferenceMap(pBundleEntryNumber, pEntryIndex(""ByFullUrl"",tRefVal)) = tRefVal")
			Do %code.WriteLine("  }")
			*/
			Continue
		}
		
		If ($Data(tExcludeNames(tPropDef.Name)))||($Extract(tPropDef.Name,1,2)="%%")||(($Extract(tPropType,1,tResourceRootLen)'=tResourceRoot)&&('$Data(tIncludeTypes(tPropType)))) Continue
		
		If $Piece(%compiledclass.Name,".",$Length(%compiledclass.Name,"."))="ResourceContainer" {
			Do %code.WriteLine("  If $IsObject("_tPropName_") Set tSC = "_tPropName_".GetReferenceMap(.pEntryIndex, pBundleEntryNumber, .pReferenceMap) If $$$ISERR(tSC) Quit")
		} ElseIf (tPropType=tReferenceType)&&('tPropColl) {
			#; is a reference, is not a collection
			Do %code.WriteLine("  If $IsObject("_tPropName_") {")
			Do %code.WriteLine("   Set tRefVal = "_tPropName_".reference.value")
			Do %code.WriteLine("   If (tRefVal'="""")&&($Data(pEntryIndex(""ByFullUrl"",tRefVal))) Set pReferenceMap(pBundleEntryNumber, pEntryIndex(""ByFullUrl"",tRefVal)) = tRefVal")
			Do %code.WriteLine("  }")
		} ElseIf (tPropType=tReferenceType)&&(tPropColl) {
			#; is a reference, is a collection
			Do %code.WriteLine("  If ($IsObject("_tPropName_"))&&("_tPropName_".Count()>0) {")
			Do %code.WriteLine("   For i = 1:1:"_tPropName_".Count() {")
			Do %code.WriteLine("    Set tRefVal = "_tPropName_".GetAt(i).reference.value")
			Do %code.WriteLine("   If (tRefVal'="""")&&($Data(pEntryIndex(""ByFullUrl"",tRefVal))) Set pReferenceMap(pBundleEntryNumber, pEntryIndex(""ByFullUrl"",tRefVal)) = tRefVal")
			Do %code.WriteLine("   }")
			Do %code.WriteLine("  }")
		} ElseIf (tPropType'=tReferenceType)&&('tPropColl) {
			#; is not a reference, is not a collection
			Do %code.WriteLine("  If $IsObject("_tPropName_") Set tSC = "_tPropName_".GetReferenceMap(.pEntryIndex, pBundleEntryNumber, .pReferenceMap) If $$$ISERR(tSC) Quit")
		} ElseIf (tPropType'=tReferenceType)&&(tPropColl) {
			#; is not a reference, is a collection
			Do %code.WriteLine("  If ($IsObject("_tPropName_"))&&("_tPropName_".Count()>0) {")
			Do %code.WriteLine("   For i = 1:1:"_tPropName_".Count() {")
			Do %code.WriteLine("    Set tSC = "_tPropName_".GetAt(i).GetReferenceMap(.pEntryIndex, pBundleEntryNumber, .pReferenceMap) If $$$ISERR(tSC) Quit")
			Do %code.WriteLine("   }")
			Do %code.WriteLine("   If $$$ISERR(tSC) Quit")
			Do %code.WriteLine("  }")
		}
	}
	
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Catch(ex) {")
	Do %code.WriteLine("  Set tSC = ex.AsStatus()")
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Quit tSC")
	Quit $$$OK
}

}
