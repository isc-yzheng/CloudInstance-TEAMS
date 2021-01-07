Class HS.Doc.Mapping.CheckMappingFile [ Abstract ]
{

ClassMethod Run(Path As %String) As %Status
{
	// Identify the type of file and check that all the expected tags are in place and
	// that all the referenced StructuredMappings-s exist and that all are used.
	//
	// Run example:
	// 		HSLIB>d ##class(HS.Doc.Mapping.CheckMappingFile).Run("C:\temp\MyMappingFile.xml")
	// 		
	// 		File: C:\temp\MyMappingFile.xml
	// 		
	// 		3 Errors:
	// 		    Missing structured mapping, "EnteredBy".
	// 		    Unused structured mapping, "CareProviderDetail".
	// 		    Unused structured mapping, "PerformedAt".
	// 		HSLIB>
    
    Set status = $$$OK
	
	k ^||tErrors
	Try
	{
	    // Check that all the expected tags are in place.
	    k tNodes
	    set status = ##class(%XML.TextReader).ParseFile(Path,.textreader)
	    //check status
	    if $$$ISERR(status) {do $System.Status.DisplayError(status) quit}
	    //iterate through document, node by node
	    while textreader.Read()
	    {
	        if (textreader.NodeType = "element") 
	        {
	            s tNodes(textreader.Name)=""
	        }
	    }
	    i '$d(tNodes("Source"))             s ^||tErrors($i(^||tErrors))="Missing ""Source"" node."
	    i '$d(tNodes("Target"))             s ^||tErrors($i(^||tErrors))="Missing ""Target"" node."
	    i '$d(tNodes("Mappings"))           s ^||tErrors($i(^||tErrors))="Missing ""Mappings"" node."
	    i '$d(tNodes("StructuredMappings")) s ^||tErrors($i(^||tErrors))="Missing ""StructuredMappings"" node."
	    k tNodes
	    
	    // Check that the structure is sound for each component.
	    set status=##class(%XML.TextReader).ParseFile(Path,.textreader)
	    //check status
	    if $$$ISERR(status) {do $System.Status.DisplayError(status) quit}
	    //iterate through document, node by node
	    k tFileType,tPaths,tID
	    s tPop=0
	    while textreader.Read() && 'tPop
	    {
	        If $p(textreader.Path,"/",$l(textreader.Path,"/"))="StructuredMappingRef" && textreader.HasValue s tStructuredMappingRefs(textreader.Value)=""
	        If $p(textreader.Path,"/",$l(textreader.Path,"/"))="StructuredMapping" && textreader.MoveToAttributeName("id") s tStructuredMappings(textreader.Value)=""
		    	    
		    If (textreader.NodeType = "element")
	        {
		        If textreader.Name = "HealthShareMapping"
		        {
			        k tPaths
			        I (textreader.MoveToAttributeName("name"))
		        	{
				        If textreader.Value = "CDA To SDA Mapping (Import)" s tFileType = "CDA To SDA (Import)"
			        	If textreader.Value = "SDA To CDA Mapping (Export)" s tFileType = "SDA To CDA (Export)"
		        	}
			        If '$d(tFileType) s ^||tErrors($i(^||tErrors))="Unable to determine file type." s tPop=1
			    }
			    I $lf($lb("Mapping","StructuredMapping"),textreader.Name) && (textreader.MoveToAttributeName("id")) s tID=textreader.Value
		        s tPaths(textreader.Path)=""
	        }
	        
	        If (textreader.NodeType = "endelement") && $lf($lb("Mapping","StructuredMapping"),textreader.Name)
	        {
		        If $lf($lb("/HealthShareMapping/Source","/HealthShareMapping/Target"),textreader.Path) k tPaths,tID
		        
		        If tFileType = "CDA To SDA (Import)"
		        {
		        	If $d(tPaths("/HealthShareMapping/Source")) && '$d(tPaths("/HealthShareMapping/Source/cdaType")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Source/cdaType."
		        	If $d(tPaths("/HealthShareMapping/Target")) && '$d(tPaths("/HealthShareMapping/Target/Streamlet")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Target/Streamlet." 
					
					If $d(tPaths("/HealthShareMapping/Mappings/Mapping"))
					{
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target. (id="""_tID_""")"
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target/Path")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target/Path. (id="""_tID_""")"
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target/Source")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target/Source. (id="""_tID_""")"
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target/Streamlet")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target/Streamlet. (id="""_tID_""")"
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target/XPath")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target/XPath. (id="""_tID_""")"
					}
		        }
		        
		        If tFileType = "SDA To CDA (Export)"
		        {
			        If $d(tPaths("/HealthShareMapping/Source")) && '$d(tPaths("/HealthShareMapping/Source/Streamlet")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Source/Streamlet."
		        	If $d(tPaths("/HealthShareMapping/Target")) && '$d(tPaths("/HealthShareMapping/Target/cdaType")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Target/cdaType."
		        	
		        	If $d(tPaths("/HealthShareMapping/Mappings/Mapping"))
					{
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target. (id="""_tID_""")"
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target/Path")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target/Path. (id="""_tID_""")"
						If '$d(tPaths("/HealthShareMapping/Mappings/Mapping/Target/Source")) s ^||tErrors($i(^||tErrors))="Missing path /HealthShareMapping/Mappings/Mapping/Target/Source. (id="""_tID_""")"
					}
		        }

		        k tPaths,tID
	        }
	    }
	    
	    I tPop w !,"Unknown file type." quit
	    
	    // Check that all the referenced StructuredMappings-s exist and that all are used.
	    //w !,"Structured Mapping References: "
	    
	    s tMap="" f
	    {
	    	s tMap=$o(tStructuredMappingRefs(tMap)) q:tMap=""
	    	//w "MR ",tMap,"  "	// "MR" as in "Mapping Reference"
	    	If '$d(tStructuredMappings(tMap)) s ^||tErrors($i(^||tErrors))="Missing structured mapping, """_tMap_"""."
	    }
	    //w !,"Structured Mappings: "
	    s tMap="" f
	    {
		    s tMap=$o(tStructuredMappings(tMap)) q:tMap=""
		    //w "SM ",tMap,"  "	// "SM" as in "Structured Mapping"
		    I '$d(tStructuredMappingRefs(tMap)) s ^||tErrors($i(^||tErrors))="Unused structured mapping, """_tMap_"""."
	    }
		
		Set reader = ##class(%XML.Reader).%New()
		Set status = reader.OpenFile(Path)
		If $$$ISERR(status) quit
		Do reader.Correlate("HealthShareMapping","HS.Doc.Mapping.Common.HealthShareMapping")
		s (tMappingSourceCount,tStructuredMappingSourceCount)=0
		If reader.Next(.pMapping,.status) {
			For i=1:1:pMapping.Mappings.Count() {
				s tMapping=pMapping.Mappings.GetAt(i)
				For j=1:1:tMapping.Target.Count() {
					s tTarget=tMapping.Target.GetAt(j)
					For k=1:1:tTarget.Source.Count() {
						//s tSource=tTarget.Source.GetAt(k)
						s tMappingSourceCount = tMappingSourceCount + 1
						//w !,$j(tStructuredMappingSourceCount,4),?10,tSource.Streamlet
					}
				}
			}
			For i=1:1:pMapping.StructuredMappings.Count() {
				s tStructuredMapping=pMapping.StructuredMappings.GetAt(i)
				For j=1:1:tStructuredMapping.TargetStructure.Field.Count() {
					s tField=tStructuredMapping.TargetStructure.Field.GetAt(j)
					For k=1:1:tField.Source.Count() {
						//s tSource=tField.Source.GetAt(k)
						s tStructuredMappingSourceCount = tStructuredMappingSourceCount + 1
						//w !,$j(tStructuredMappingSourceCount,4),?10,tField.Path,"- ",tSource.Streamlet
					}
				}
			}
		}
		
		w !,"File: ",Path,!,"Type: ",tFileType,!
	    w !,"Total Mappings/Mapping/Target/Source: ",tMappingSourceCount
		w !,"Total StructuredMappings/StructureMapping/TargetStructure/Field/Source: ",tStructuredMappingSourceCount
		w !
		
	    If '$d(^||tErrors) w !,"File OK."
	    else  w !,^||tErrors," Error",$s(^||tErrors>1:"s",1:""),":" for i=1:1:^||tErrors w !,?4,^||tErrors(i)

	}
	Catch ex
	{
		Set status = ex.AsStatus()
		Do $System.Status.DisplayError(status)
	}

	quit status
}

}
