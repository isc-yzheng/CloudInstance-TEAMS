Class HS.FHIR.DTL.Util.Test.HC.Transform
{

ClassMethod SDAObjectsToFHIR(dirName As %String, fhirVersion As %String)
{
	set outputDirectory = ##class(%Library.File).SubDirectoryName(dirName, fhirVersion)
	do ##class(%Library.File).CreateDirectory(outputDirectory)
	
	set inputFilename = $zsearch(##class(%Library.File).NormalizeFilename("*.xml", dirName))
	if (inputFilename = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "Directory contains no .xml files"))
	
	set transformer = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).%New(##class(HS.FHIRServer.Schema).LoadSchema(fhirVersion))
	
	while inputFilename '= "" {
		set fileStream = ##class(%Stream.FileCharacter).%New()
		set tSC = fileStream.LinkToFile(inputFilename)
		
		set firstLine = $zstrip(fileStream.ReadLine(),"<W")
		do fileStream.Rewind()
		set SDAClass = "HS.SDA3." _ $extract(firstLine, 2, $find(firstLine, ">") - 2)
		
		set obj = $classmethod(SDAClass, "%New")
		do obj.XMLImportSDAString($replace($replace(fileStream.Read(3700000), $char(13,10), ""), $char(9), ""))
		
		set patientId = "12345"
		set encounterId = "1"
		//set transformer = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).TransformStream(fileStream, SDAClass, fhirVersion, patientId, encounterId)
		do transformer.TransformSDA(obj, patientId, encounterId)
		
		set inputFilename = $zsearch("")
	}
	
		
	set fileStream = ##class(%Stream.FileCharacter).%New()
	set shortFileName = "Bundle"
	while ##class(%Library.File).Exists(##class(%File).NormalizeFilename(shortFileName _ ".json", outputDirectory)) {
		set i=0, num=""
		while $isvalidnum($extract(shortFileName, *-i, *)) {
			set num = $extract(shortFileName, *-i, *)
			set i = i + 1
		}
		if num = "" {
			set shortFileName = shortFileName _ "_" _ 1
		}
		else {
			set num = num + 1
			set shortFileName = $extract(shortFileName, 1, *-i-1) _ "_" _ num
		}
		set $piece(fileName, ".", 1, *-1) = shortFileName
	}
	do fileStream.LinkToFile(##class(%File).NormalizeFilename(shortFileName _ ".json", outputDirectory))
	do fileStream.Write(transformer.bundle.%ToJSON())
	$$$ThrowOnError(fileStream.%Save())
}

ClassMethod SDAContainersToFHIR(dirName As %String, fhirVersion As %String)
{
	set outputDirectory = ##class(%Library.File).SubDirectoryName(dirName, fhirVersion)
	do ##class(%Library.File).CreateDirectory(outputDirectory)
	
	set inputFilename = $zsearch(##class(%Library.File).NormalizeFilename("*.xml", dirName))
	if (inputFilename = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "Directory contains no .xml files"))
	
	while inputFilename '= "" {
		set fileStream = ##class(%Stream.FileCharacter).%New()
		set tSC = fileStream.LinkToFile(inputFilename)
		
		do fileStream.Write($replace($replace(fileStream.Read(3700000), $char(13,10), ""), $char(9), ""))
		
		set transformer = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).TransformStream(fileStream, "HS.SDA3.Container", fhirVersion)
		
		set fileStream = ##class(%Stream.FileCharacter).%New()
		set shortFileName = "Bundle"
		while ##class(%Library.File).Exists(##class(%File).NormalizeFilename(shortFileName _ ".json", outputDirectory)) {
			set i=0, num=""
			while $isvalidnum($extract(shortFileName, *-i, *)) {
				set num = $extract(shortFileName, *-i, *)
				set i = i + 1
			}
			if num = "" {
				set shortFileName = shortFileName _ "_" _ 1
			}
			else {
				set num = num + 1
				set shortFileName = $extract(shortFileName, 1, *-i-1) _ "_" _ num
			}
			set $piece(fileName, ".", 1, *-1) = shortFileName
		}
		do fileStream.LinkToFile(##class(%File).NormalizeFilename(shortFileName _ ".json", outputDirectory))
		do fileStream.Write(transformer.bundle.%ToJSON())
		$$$ThrowOnError(fileStream.%Save())
		
		set inputFilename = $zsearch("")
	}
}

ClassMethod WriteFile(stream As %Stream.Object, objectType As %String, outputDirectory As %String, format As %String) As %Status
{
	set tSC = $$$OK
	try {
		set outputFileName = ##class(%File).NormalizeFilename(objectType _ "." _ format, outputDirectory)
		while ##class(%Library.File).Exists(outputFileName) {
			set shortFileName = $piece(outputFileName,".", 1, *-1)
			set j=0, num=""
			while $isvalidnum($extract(shortFileName, *-j, *)) {
				set num = $extract(shortFileName, *-j, *)
				set j = j + 1
			}
			if num = "" {
				set shortFileName = shortFileName _ "_" _ 1
			}
			else {
				set num = num + 1
				set shortFileName = $extract(shortFileName, 1, *-j-1) _ "_" _ num
			}
			set $piece(outputFileName, ".", 1, *-1) = shortFileName
		}
		set file = ##class(%File).%New(outputFileName)
		set tSC = file.Open("WRN")
		set tSC = file.Write(stream.Read(10000000))
		quit:$$$ISERR(tSC)
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
