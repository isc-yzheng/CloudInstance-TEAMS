Class HS.FHIR.DTL.Util.Test.Transform
{

ClassMethod RoundTripVersionTest(inputFilename As %String)
{
	set v3 = "HL7v30"
	set v4 = "HL7v40"
	set inStream = ##class(%Stream.FileCharacter).%New()
	do inStream.LinkToFile(##class(%File).NormalizeFilename(inputFilename))
	
	for version = v3, v4 {
		set bundleStream = ##class(%Stream.FileCharacter).%New()
		do bundleStream.LinkToFile(##class(%File).NormalizeFilename(##class(%File).GetDirectory(inputFilename) _ "\Bundle" _ version _".json"))
		set outStream = ##class(%Stream.FileCharacter).%New()
		do outStream.LinkToFile(##class(%File).NormalizeFilename(##class(%File).GetDirectory(inputFilename) _ "Output" _ version _".xml"))
		
		set sdaToFhir = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).TransformStream(inStream, "HS.SDA3.Container", version, 12345)
		set bundle = sdaToFhir.bundle
		do bundleStream.Write(bundle.%ToJSON())
		$$$ThrowOnError(bundleStream.%Save())
		
		set fhirToSda = ##class(HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3).%New(##class(HS.FHIRServer.Schema).LoadSchema(version))
		do fhirToSda.Transform(bundle)
		
		set container = fhirToSda.container
		do container.XMLExportToString(.cString)
		
		do outStream.Write(cString)
		$$$ThrowOnError(outStream.%Save())
	}
}

ClassMethod FHIRToSDA3Test(inputFilename As %String, fhirVersion As %String)
{
	set transformer = ##class(HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3).%New(##class(HS.FHIRServer.Schema).LoadSchema(fhirVersion))
	set outStream = ##class(%Stream.FileCharacter).%New()
	
	set bundle = {}.%FromJSON(##class(%File).NormalizeFilename(inputFilename))
	d transformer.Transform(bundle)
	
	do outStream.LinkToFile(##class(%File).NormalizeFilename(##class(%File).GetDirectory(inputFilename) _ "Output.xml"))
	do transformer.container.XMLExportToStream(.outStream)
	$$$ThrowOnError(outStream.%Save())
	
	return transformer
}

}
