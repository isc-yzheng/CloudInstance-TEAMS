Class HS.FHIRServer.Tools.Minimize Extends %Persistent
{

/// Minimize a FHIR Resources removing text properties.  The output can 
/// optionally be pretty printed or minimized
ClassMethod Minimize(inputDir As %String, outputPretty As %Boolean = 0, outputDir As %String = "")
{
	Set inputDir = ##class(%File).NormalizeDirectory(inputDir)
	if outputDir = "" {
		Set outputDir = $E(inputDir,1,*-1) _ $Select(outputPretty:"-dev", 1:"-min")
	} else {
		Set outputDir = ##class(%File).NormalizeFilename(outputDir, inputDir)
	}
	
	if inputDir = outputDir {
		w "Cannot overwrite input files. Choose a different output directory.",!
		return
	}
	if '##class(%File).DirectoryExists(outputDir) {
		if ' ##class(%File).CreateDirectory(outputDir) {
			w "Unable to create directory: ",outputDir,!	
		}
	}
	
	//Load everything in the directory
	Set ixfile = ##class(%File).NormalizeFilename(".index.json", inputDir)
	if ##class(%File).Exists(ixfile) {
		w "Loading from Index ", ixfile, !
		#dim jindex as %DynamicObject = ##class(%DynamicObject).%FromJSON(ixfile)
		Set iter = jindex.files.%GetIterator()
		while iter.%GetNext(.subsc, .entry) {
			Do writeRsrc(entry.filename)
		}
	} else {
		set filepath = $zsearch(##class(%File).NormalizeFilename("*.json", inputDir))
		while filepath '= "" {
			if '##class(%File).DirectoryExists(filepath) {
				Do writeRsrc(##class(%File).GetFilename(filepath))
			}
		    set filepath = $zsearch("")
		}
	}
	
writeRsrc(fn)
	try {
		Set inpath = ##class(%File).NormalizeFilename(fn, inputDir)
		Set outpath = ##class(%File).NormalizeFilename(fn, outputDir)
		
		w "reading..."
		#dim rsrc as %DynamicObject = ##class(%DynamicObject).%FromJSON(inpath)
		w "rsrc: ",rsrc.resourceType," -> ",fn,!
		Set rt = rsrc.resourceType
		if rt = "" {
			Quit
		}
		do rsrc.%Remove("text")
		if rt = "Bundle" {
			Set iter = rsrc.entry.%GetIterator()
			while iter.%GetNext(.subsc, .entry) {
				// Remove the documentation node ... its just alot of noise
				Do entry.resource.%Remove("text")
			}
			
		}
		
		Set tFile = ##class(%Stream.FileCharacter).%New()
		Do ##class(%File).Delete(outpath)
		$$$ThrowOnError(tFile.LinkToFile(outpath))
		Set tFile.TranslateTable = "UTF8"
		w "writing..."
		if outputPretty {
			do ##class(HS.FHIRServer.Util.JsonHelper).ToJSONStream(rsrc, .tFile, "  ",$Char(13,10))
		} else {
			Do rsrc.%ToJSON(tFile)
		}
		w "saving..."
		$$$ThrowOnError(tFile.%Save())
		w !
		
	} catch ex {
		w !,"Exception processing ",fn,": ", $System.Status.GetOneErrorText(ex.AsStatus()),!
	}
	Quit
}

Storage Default
{
<Data name="MinimizeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^HS.FHIRServer.Tools.MinimizeD</DataLocation>
<DefaultData>MinimizeDefaultData</DefaultData>
<IdLocation>^HS.FHIRServer.Tools.MinimizeD</IdLocation>
<IndexLocation>^HS.FHIRServer.Tools.MinimizeI</IndexLocation>
<StreamLocation>^HS.FHIRServer.Tools.MinimizeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
