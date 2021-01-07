Class HS.FHIR.DTL.Util.Element.Object
{

/// This method is used when going between a Stream object and a
/// base64Binary element in FHIR.
ClassMethod FromStream(source As %Stream.Object) As %String
{
	//3000000 is the largest supported streamlet size in SDA.
	//Since this is a single element being added to a JSON string, we should probably limit the
	//output here to 3000000 as well
	//However, base 64 encoding it will expand it by about 1/3, and we don't want to blow
	//the string limitso we'll cap this off at 2250000
	do source.Rewind()
	quit ##class(HS.FHIR.DTL.Util.Element.TypeCast).Base64Encode(source.Read(2250000))
}

/// This method is used when going between a base64Binary element in
/// FHIR and a Stream object.
ClassMethod ToStream(source As %String) As %Stream.Object
{
	set stream = ##class(%Stream.TmpCharacter).%New()
	do stream.Write(##class(HS.FHIR.DTL.Util.Element.TypeCast).Base64Decode(source))
	do stream.Rewind()
	quit stream
}

/// Convert a string to a FHIR Identifier object.
/// source - The string to be put in the Identifier value.
/// propertyName - The property name that can be used to classify the identifier type.
/// Will be saved in the Identifier:type.text.
ClassMethod StringToIdentifier(source As %String, propertyName As %String) As %RegisteredObject
{
	set tSC = $$$OK
	try {
		if source = "" {
			set target = ""
			quit
		}
		set packageModel = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageModelName("vSTU3")
		if (packageModel = "") quit
		set target = $classmethod(packageModel _ ".Datatype.Identifier", "%New")
		set target.value = source
		set target.use = "official"
		set target.type = $classmethod(packageModel _ ".Datatype.CodeableConcept", "%New")
		set target.type.text = propertyName
	} catch ex {
		set target = ""
	}
	quit target
}

/// Used to determine if an SDA3 property is defined (not empty) without inspecting
/// it, which would cause it to be instantiated.
/// source - The object containing the element in question.
/// element - The name of the element that is to be checked within the source object.
ClassMethod Defined(source As %RegisteredObject, element As %String) As %Boolean
{
	if source = "" quit 0
	quit source.IsDefined(element)
}

}
