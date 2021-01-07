/// Import the SDA to CDA mapping file generated by SDAtoCDAMapper 
/// and store the mappings to database for searching.
Class HS.Doc.Mapping.ImportSDAToCDAMapping [ Abstract ]
{

ClassMethod XMLImport(Path As %String = "", KeepCurrentData As %Boolean = 0, displayDetail As %Boolean = 0) As %Status
{
	// Run:
	//		Do ##class(HS.Doc.Mapping.ImportSDAToCDAMapping).XMLImport("C:\temp\Export.xml")
	//		By default, it initializes the prior tables entries and doesn't show details of the run.
	// To keep current data, run:
	//		Do ##class(HS.Doc.Mapping.ImportSDAToCDAMapping).XMLImport("C:\temp\Export.xml",1)
	// To show details while running run:
	//		Do ##class(HS.Doc.Mapping.ImportSDAToCDAMapping).XMLImport("C:\temp\Export.xml",,1)
	
	Set status = $$$OK
	
	Try
	{
		If Path="" Set status = $$$ERROR($$$GeneralError,"Input file not specified") Quit
		
		If '##class(%File).Exists(Path) Set status = $$$ERROR($$$FileDoesNotExist,Path) Quit
		
		Set reader = ##class(%XML.Reader).%New()
		Set status = reader.OpenFile(Path)
		If $$$ISERR(status) quit
		
		Do reader.Correlate("HealthShareMapping","HS.Doc.Mapping.Common.HealthShareMapping")
		If reader.Next(.tMapping,.status) {
			Set status = ..ParseHSMapping(tMapping,KeepCurrentData,displayDetail)
		}
		Else {
			Set status = $$$ERROR($$$GeneralError,Path_" does not contain HealthShareMapping")
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	If $$$ISERR(status) Write !,$System.Status.GetErrorText(status),!!
	
	quit status
}

ClassMethod ParseHSMapping(pMapping As HS.Doc.Mapping.Common.HealthShareMapping, KeepCurrentData As %Boolean, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	
	Try
	{
		Kill ^||tErrors
		
		Set linkCounter = 0
		Set (  newTargetCounter,   newSourceCounter,   newXPathSourceCounter) = 0
		Set (priorTargetCounter, priorSourceCounter, priorXPathSourceCounter) = 0

		If 'KeepCurrentData {
			W !, "Initialize HS.Doc.Data.Field table."
			Do ##class(HS.Doc.Data.Field).%DeleteExtent()
			W !, "Initialize HS.Doc.Data.Link table.", !
			Do ##class(HS.Doc.Data.Link).%DeleteExtent()
		}
		
		For i=1:1:pMapping.Mappings.Count() {
			Set currentMapping = pMapping.Mappings.GetAt(i)
			If displayDetail w !!,"<Mapping id=""",currentMapping.id,""">"
			//Else  W "."
			For j=1:1:currentMapping.Target.Count() {
				Set (tNewSource,tNewTarget)=1
				Set currentTarget = currentMapping.Target.GetAt(j)
				
				// build&save pairs of Target&Source fields.
				// note that you can have more than 1 Source per Target, in which case the target would get stored only once.
				
				For k=1:1:currentTarget.Source.Count() {
					Set currentSource = currentTarget.Source.GetAt(k)
					// only display the details if you are not sending to a StructuredMapping
					Set tDisplayDetail=$s(currentSource.StructuredMappingRef="":displayDetail,1:0)
					
					// build&save Target
					Set tDocumentType = pMapping.Target.cdaType
					// Example Path: /ClinicalDocument/recordTarget/patientRole/patient/administrativeGenderCode/@code
					Set tPath = $replace(currentTarget.Path,".CurrentProperty","")
					Set tPath = ..TrimPath(tPath)
					// Does this newTarget already exist in db?
					// If so, use its Id.
					Set currentTargetFieldId = ..GetCurrentFieldId(tDocumentType,tPath,tDisplayDetail,"target")
					If 'currentTargetFieldId
					{
						Set newTarget = ##class(HS.Doc.Data.Field).%New()
						Set newTarget.DocumentType = tDocumentType
						Set newTarget.Path = tPath
						Set newTarget.Name = currentMapping.id
					}
					else
					{
						Set newTarget=##class(HS.Doc.Data.Field).%OpenId(currentTargetFieldId)
					}
									
					// build&save Source
					Set tDocumentType = "SDA"
					// path = Source.Streamlet + Source.Path
					// Example Path: HS.SDA3.Patient.Gender.Code
					Set tPath = currentSource.Streamlet
					Set tCurrentSourcePath=$replace(currentSource.Path,".CurrentProperty","")
					If tCurrentSourcePath'="" Set tPath=tPath _ "." _ tCurrentSourcePath 
					Set tPath = ..TrimPath(tPath)
					Set currentSourceFieldId = ..GetCurrentFieldId(tDocumentType,tPath,tDisplayDetail,"source")
					If 'currentSourceFieldId
					{
						Set newSource = ##class(HS.Doc.Data.Field).%New()
						Set newSource.DocumentType = tDocumentType
						Set newSource.Path = tPath
						Set newSource.Name = currentMapping.id
					}
					else
					{
						Set newSource=##class(HS.Doc.Data.Field).%OpenId(currentSourceFieldId)
					}
					
					// build&save XPathSource
					Set tDocumentType = "XPathSDA"
					// Example XPath: /Container/Allergies/Allergy/Severity
					Set currentXPathSourceFieldId = ..GetCurrentFieldId(tDocumentType,currentSource.XPath,tDisplayDetail,"source")
					If 'currentXPathSourceFieldId
					{
						Set newXPathSource = ##class(HS.Doc.Data.Field).%New()
						Set newXPathSource.DocumentType = tDocumentType
						Set newXPathSource.Path = currentSource.XPath
						Set newXPathSource.Name = currentMapping.id
					}
					else
					{
						Set newXPathSource=##class(HS.Doc.Data.Field).%OpenId(currentXPathSourceFieldId)
					}
					
					// if there is no StructuredMapping reference, you got the paths ... save them and build the link
					// otherwise, follow through that StructuredMapping reference to build the paths before saving them
					If currentSource.StructuredMappingRef=""
					{
						// Do not file invalid SDA paths
						If '..isValidSDAPath(newSource.Path,newTarget.Path,currentTarget.Note,displayDetail) continue
					
						Set tSaveStatus = newSource.%Save()
						If $$$ISERR(tSaveStatus) Do ..LogError("ParseHSMapping newSource.%Save() failed - "_$system.Status.GetErrorText(tSaveStatus))
						
						If currentSourceFieldId Set priorSourceCounter = priorSourceCounter + 1
						else  Set newSourceCounter = newSourceCounter + 1
						
						Set tSaveStatus = newXPathSource.%Save()
						If $$$ISERR(tSaveStatus) Do ..LogError("ParseHSMapping newXPathSource.%Save() failed - "_$system.Status.GetErrorText(tSaveStatus))
						
						If currentXPathSourceFieldId Set priorXPathSourceCounter = priorXPathSourceCounter + 1
						else  Set newXPathSourceCounter = newXPathSourceCounter + 1
						
						Set tSaveStatus = newTarget.%Save()
						If $$$ISERR(tSaveStatus) Do ..LogError("ParseHSMapping newTarget.%Save() failed - "_$system.Status.GetErrorText(tSaveStatus))
						
						If currentTargetFieldId Set priorTargetCounter = priorTargetCounter + 1
						else  Set newTargetCounter = newTargetCounter + 1
						
						// Build link to connect Target and Source.
						If displayDetail {
							w !,?5,"Source Path  = ",newSource.Path
							w !,?5,"Target Path  = ",newTarget.Path
							If $replace(currentTarget.Note,$c(10),"")'="" w !,?5,"Link Comment = ",currentTarget.Note
						}
						If ('currentSourceFieldId)||('currentTargetFieldId) {
							d ..CreateLink(newTarget, newSource, pMapping.name,.linkCounter,currentTarget.Note)
						}
						ElseIf (currentSourceFieldId)&&(currentTargetFieldId) {
							Set currentPairId = ..GetCurrentPairId(currentSourceFieldId,currentTargetFieldId,displayDetail)
							If 'currentPairId d ..CreateLink(newTarget, newSource, pMapping.name,.linkCounter,currentTarget.Note)
						}
						
						// Build link to connect Target and XPathSource.
						If displayDetail {
							w !,?5,"Source XPath = ",newXPathSource.Path
							w !,?5,"Target Path  = ",newTarget.Path
							If $replace(currentTarget.Note,$c(10),"")'="" w !,?5,"Link Comment = ",currentTarget.Note
						}
						If ('currentXPathSourceFieldId)||('currentTargetFieldId) {
							d ..CreateLink(newTarget, newSource, pMapping.name,.linkCounter,currentTarget.Note)
						}
						ElseIf (currentXPathSourceFieldId)&&(currentTargetFieldId) {
							Set currentPairId = ..GetCurrentPairId(currentXPathSourceFieldId,currentTargetFieldId,displayDetail)
							If 'currentPairId d ..CreateLink(newTarget, newXPathSource, pMapping.name,.linkCounter,currentTarget.Note)
						}
					}
					Else
					{
						d ..buildPathsFromStructuredMappings(newTarget,newSource,newXPathSource,pMapping,currentSource.StructuredMappingRef,.newTargetCounter,.newSourceCounter,.newXPathSourceCounter,.linkCounter,.priorTargetCounter,.priorSourceCounter,.priorXPathSourceCounter,displayDetail,currentTarget.Note)
					}
					If displayDetail w !!,"</Mapping>"
				}
			}
		}
			    
	    //If displayDetail {
			W !!, "Import of SDA to CDA ("_pMapping.Target.cdaType_") mapping finished"
			If $g(^||tErrors)>0 {
				w !,"Errors: ",?16,^||tErrors
				for i=1:1:^||tErrors w !,?16,^||tErrors(i)
				w !
				// If we don't already have a failure status then put the last error into status.
				If $$$ISOK(status) Set status = $$$ERROR($$$GeneralError,^||tErrors(^||tErrors))
			}
			W !,         "Links: ",?16, $j(linkCounter,3)
			W !,       "Targets: ",?16, $j(newTargetCounter+priorTargetCounter,3),          " (",$j(newTargetCounter,3),     " new & ",$j(priorTargetCounter,3),      " prior)"
			W !,       "Sources: ",?16, $j(newSourceCounter+priorSourceCounter,3),          " (",$j(newSourceCounter,3),     " new & ",$j(priorSourceCounter,3),      " prior)"
			W !, "XPath Sources: ",?16, $j(newXPathSourceCounter+priorXPathSourceCounter,3)," (",$j(newXPathSourceCounter,3)," new & ",$j(priorXPathSourceCounter,3), " prior)"
			W !
	    //}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

ClassMethod buildPathsFromStructuredMappings(newTarget As HS.Doc.Data.Field, newSource As HS.Doc.Data.Field, newXPathSource As HS.Doc.Data.Field, pMapping As HS.Doc.Mapping.Common.HealthShareMapping, StructuredMappingRef As %String, newTargetCounter As %String, newSourceCounter As %String, newXPathSourceCounter As %String, linkCounter As %String, priorTargetCounter As %String, priorSourceCounter As %String, priorXPathSourceCounter As %String, displayDetail As %Boolean = 0, tNote As %String)
{
	// INPUTS:
	//		newSource, newTarget                   - the Source and Target built so far recursively
	//		pMapping                               - all Structuredmapping-s in the data mapping 
	//		StructuredMappingRef                   - the entire data mapping
	//		newTargetCounter, newSourceCounter     - how many new Sources&Targets were filed so far
	//		linkCounter                            - how many links were saved
	//		priorTargetCounter, priorSourceCounter - how many prior Sources&Targets were filed so far
	//		displayDetail                          - boolean to show/not-show processing detail (duplicates, for instance) 
	//		Note                                   - Note string that will be stored with the link. It is a build-up through all the levels 
	
	// find the StructuredMapping that has id=currentSource.StructuredMappingRef
	set tFoundStructuredMappingRef = 0
	For l=1:1:pMapping.StructuredMappings.Count() {
		Set currentStructuredMapping = pMapping.StructuredMappings.GetAt(l)
		// not the referenced StructuredMapping we are looking for
		If currentStructuredMapping.id'=StructuredMappingRef continue
		// debugging suggestions: you can break into the recursive looping by ...
		//    the StructuredMapping id
		//      OR
		//    the passed in newSource or newTarget
		//      OR
		//    both
		//b:(currentStructuredMapping.id="associatedEntity")
		//b:(currentStructuredMapping.id="id-Clinician")&&(newSource.Path["HS.SDA3.SupportContact")
		s tFoundStructuredMappingRef = 1
		If displayDetail w !!,?5,"<StructuredMapping id=""",currentStructuredMapping.id,""">"
				
		// add the StructuredMapping level note
		s tCurrentStructuredMappingNote=""
		If currentStructuredMapping.Note'="" s tCurrentStructuredMappingNote=$s(tNote'="":tNote_$c(10),1:"")_currentStructuredMapping.Note
		else  Set tCurrentStructuredMappingNote=tNote
		
		For m=1:1:currentStructuredMapping.TargetStructure.Field.Count() {
			Set currentField=currentStructuredMapping.TargetStructure.Field.GetAt(m)
			// newFieldTarget is the new target field that we're building and we intend to save
			// ... or pass to the referenced StructuredMapping (if any)
			Set newFieldTarget=newTarget.%ConstructClone()
			Set tCurrentFieldPath=$replace($replace(currentField.Path,"CurrentProperty",""),"./","")
			If tCurrentFieldPath'="" Set newFieldTarget.Path = newFieldTarget.Path_"/"_tCurrentFieldPath
			Set newFieldTarget.Path = ..TrimPath(newFieldTarget.Path)
									
			For n=1:1:currentField.Source.Count() {
				Set currentSource = currentField.Source.GetAt(n)
				// newFieldSource is the new Source field that we're building and we intend to save
				// ... or pass to the referenced StructuredMapping (if any)
				Set newFieldSource=newSource.%ConstructClone()
				Set newFieldSource.Path=$replace(newFieldSource.Path,"CurrentProperty","")
				Set tCurrentSourceStreamlet=currentSource.Streamlet
				If (currentSource.Streamlet["ParentClass.") {
					Set newFieldSource.Path=$p(newFieldSource.Path,".",1,$l(newFieldSource.Path,".")-1)
					Set tCurrentSourceStreamlet=$replace(tCurrentSourceStreamlet,"ParentClass.","")
				}
				ElseIf (currentSource.Streamlet["ParentProperty.") {
					Set newFieldSource.Path=$p(newFieldSource.Path,".",1,$l(newFieldSource.Path,".")-1)
					Set tCurrentSourceStreamlet=$replace(tCurrentSourceStreamlet,"ParentProperty.","")
				}
				ElseIf (currentSource.Streamlet["ParentProperty") {
					Set newFieldSource.Path=$p(newFieldSource.Path,".",1,$l(newFieldSource.Path,".")-1)
					Set tCurrentSourceStreamlet=$replace(tCurrentSourceStreamlet,"ParentProperty","")
				}
				ElseIf (currentSource.Streamlet["CurrentProperty") {
					Set tCurrentSourceStreamlet=$replace(tCurrentSourceStreamlet,"CurrentProperty","")
				}
				If tCurrentSourceStreamlet'="" Set newFieldSource.Path = newFieldSource.Path_"."_tCurrentSourceStreamlet
				Set newFieldSource.Path = ..TrimPath(newFieldSource.Path)
				
				// newFieldXPathSource is the new XPath Source field that we're building and we intend to save
				// ... or pass to the referenced StructuredMapping (if any)
				Set newFieldXPathSource=newXPathSource.%ConstructClone()
				Set tCurrentXPathSource=currentSource.XPath
				If (currentSource.XPath["../") {
					Set newFieldXPathSource.Path=$p(newFieldXPathSource.Path,"/",1,$l(newFieldXPathSource.Path,"/")-1)
					Set tCurrentXPathSource=$replace(tCurrentXPathSource,"../","")
				}
				ElseIf (currentSource.XPath["./") {
					Set tCurrentXPathSource=$replace(tCurrentXPathSource,"./","")
				}
				If tCurrentXPathSource?1"/".E Set tCurrentXPathSource=$E(tCurrentXPathSource,2,*)
				If tCurrentXPathSource'="" Set newFieldXPathSource.Path = newFieldXPathSource.Path_"/"_tCurrentXPathSource
				Set newFieldXPathSource.Path = ..TrimPath(newFieldXPathSource.Path)
								
				// add the currentSource note
				s tNote=""
				If currentField.Note'="" s tNote=$s(tCurrentStructuredMappingNote'="":tCurrentStructuredMappingNote_$c(10),1:"")_currentField.Note
				else  Set tNote=tCurrentStructuredMappingNote
				
				// Debugging suggestion:
				//b:newFieldSource.Path["HS.SDA3.AdvanceDirective.EnteredBy.WorkPhoneNumber"	//BEFORE FILING
				// if there is no StructuredMapping reference, you got the paths ... save them and build the link
				// otherwise, follow recursively through that StructuredMapping reference to build the paths before saving them
				If currentField.StructuredMappingRef=""
				{
					// Do not file invalid SDA paths
					If '..isValidSDAPath(newFieldSource.Path,newFieldTarget.Path,tNote,displayDetail) continue
					
					s (tNewFieldSource,tNewFieldTarget)=1
					// Does this newSource already exist in db?
					// If so, use its Id.
					//b:(newFieldSource.Path="HS.SDA3.Result.EnteredBy.Country.Code")
					s currentSourceFieldId = ..GetCurrentFieldId(newFieldSource.DocumentType,newFieldSource.Path, displayDetail,"source")
					If 'currentSourceFieldId
					{
						Set tSaveStatus = newFieldSource.%Save()
						If $$$ISERR(tSaveStatus) Do ..LogError("buildPathsFromStructuredMappings newFieldSource.%Save() failed - "_$system.Status.GetErrorText(tSaveStatus))
						Set newSourceCounter = newSourceCounter + 1			
					}
					else
					{
						Set newFieldSource=##class(HS.Doc.Data.Field).%OpenId(currentSourceFieldId)
						Set priorSourceCounter = priorSourceCounter + 1
					}
					
					// Does this newSource already exist in db?
					// If so, use its Id.
					s currentXPathSourceFieldId = ..GetCurrentFieldId(newFieldXPathSource.DocumentType,newFieldXPathSource.Path, displayDetail,"source")
					If 'currentXPathSourceFieldId
					{
						Set tSaveStatus = newFieldXPathSource.%Save()
						If $$$ISERR(tSaveStatus) Do ..LogError("buildPathsFromStructuredMappings newFieldXPathSource.%Save() failed - "_$system.Status.GetErrorText(tSaveStatus))
						Set newXPathSourceCounter = newXPathSourceCounter + 1			
					}
					else
					{
						Set newFieldXPathSource=##class(HS.Doc.Data.Field).%OpenId(currentXPathSourceFieldId)
						Set priorXPathSourceCounter = priorXPathSourceCounter + 1
					}
					
					// Does this newTarget already exist in db?
					// If so, use its Id.
					//b:(newFieldTarget.Path="/ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.3.1]/entry/organizer/author/assignedAuthor/representedOrganization/addr/addr/country")
					s currentTargetFieldId = ..GetCurrentFieldId(newFieldTarget.DocumentType,newFieldTarget.Path,displayDetail,"target")
					If 'currentTargetFieldId
					{
						Set tSaveStatus = newFieldTarget.%Save()
						If $$$ISERR(tSaveStatus) Do ..LogError("buildPathsFromStructuredMappings newFieldTarget.%Save() failed - "_$system.Status.GetErrorText(tSaveStatus))
						Set newTargetCounter = newTargetCounter + 1				
					}
					else
					{
						Set newFieldTarget=##class(HS.Doc.Data.Field).%OpenId(currentTargetFieldId)
						Set priorTargetCounter = priorTargetCounter + 1
					}
										
					// Build link to connect Target and Source.
					//b:(newFieldSource.Path="HS.SDA3.Result.EnteredBy.Country.Code")&&(newFieldTarget.Path="/ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.3.1]/entry/organizer/author/assignedAuthor/representedOrganization/addr/addr/country")
					If displayDetail {
						w !,?10,"Source Path  = ",newFieldSource.Path
						w !,?10,"Target Path  = ",newFieldTarget.Path
						If $replace(tNote,$c(10),"")'="" w !,?10,"Link Comment = ",tNote
						w !
						//If StructuredMappingRef'="" w ?10,"(StructuredMapping: ",StructuredMappingRef,")",!
					}
					// only file this link if at least one item (source or target) is new.
					If ('currentSourceFieldId)||('currentTargetFieldId) {
						d ..CreateLink(newFieldTarget, newFieldSource, pMapping.name,.linkCounter,tNote)
					}
					ElseIf (currentSourceFieldId&&currentTargetFieldId) {
						Set currentPairId = ..GetCurrentPairId(currentSourceFieldId,currentTargetFieldId,displayDetail)
						If 'currentPairId d ..CreateLink(newFieldTarget, newFieldSource, pMapping.name,.linkCounter,tNote)
					}
					
					// Build link to connect Target and XPathSource.
					If displayDetail {
						w !,?10,"Source XPath = ",newFieldXPathSource.Path
						w !,?10,"Target Path  = ",newFieldTarget.Path
						If $replace(tNote,$c(10),"")'="" w !,?10,"Link Comment = ",tNote
						w !
						//If StructuredMappingRef'="" w ?10,"(StructuredMapping: ",StructuredMappingRef,")",!
					}
					// only file this link if at least one item (source or target) is new.
					If ('currentXPathSourceFieldId)||('currentTargetFieldId) {
						d ..CreateLink(newFieldTarget, newFieldSource, pMapping.name,.linkCounter,tNote)
					}
					ElseIf (currentXPathSourceFieldId&&currentTargetFieldId) {
						Set currentPairId = ..GetCurrentPairId(currentXPathSourceFieldId,currentTargetFieldId,displayDetail)
						If 'currentPairId d ..CreateLink(newFieldTarget, newFieldXPathSource, pMapping.name,.linkCounter,tNote)
					}
				}
				Else
				{
					d ..buildPathsFromStructuredMappings(newFieldTarget,newFieldSource,newFieldXPathSource,pMapping,currentField.StructuredMappingRef,.newTargetCounter,.newSourceCounter,.newXPathSourceCounter,.linkCounter,.priorTargetCounter,.priorSourceCounter,.priorXPathSourceCounter,displayDetail,tNote)
				}
				// Debugging suggestion:
				//b:newFieldSource.Path["HS.SDA3.AdvanceDirective.EnteredBy.WorkPhoneNumber"	//AFTER FILING
			}
		}
		If displayDetail w !,?5,"</StructuredMapping>"
	}
	
	i 'tFoundStructuredMappingRef Do ..LogError("Missing structured mapping, """_StructuredMappingRef_""".")
}

ClassMethod GetCurrentFieldId(pDocumentType As %String, pPath As %String, displayDetail As %Boolean = 0, FieldType As %String) As %String
{
	s currentFieldId=0
	
	Set query =         "SELECT *"
	Set query = query _ " FROM HS_Doc_Data.Field"
	Set query = query _ " WHERE DocumentType = ? AND Path = ?"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, query,pDocumentType,pPath)
	
	While (rs.%Next()) {
		If displayDetail W !, "    Found ",FieldType," duplicate: ","HS_Doc_Data.Field ID = ",rs.ID," (DocumentType=",rs.DocumentType,", Path=",rs.Path,")"
		s currentFieldId = rs.ID
	}
	Quit currentFieldId
}

ClassMethod GetCurrentPairId(pSourceFieldId As %String, pTargetFieldId As %String, displayDetail As %Boolean = 0) As %String
{
	s currentPairId=0
	
	Set query =         "SELECT *"
	Set query = query _ " FROM HS_Doc_Data.Link"
	Set query = query _ " WHERE SourceField	= ? AND TargetField = ?"
	Set rs = ##class(%SQL.Statement).%ExecDirect(, query, pSourceFieldId, pTargetFieldId)
	
	While (rs.%Next()) {
		If displayDetail W !,?10,"Found Pair duplicate: ","HS_Doc_Data.Link ID = ",rs.ID," (SourceField=",rs.SourceField,", TargetField=",rs.TargetField,")"
		s currentPairId = rs.ID
	}
	Quit currentPairId
}

ClassMethod CreateLink(newTarget As HS.Doc.Data.Field, newSource As HS.Doc.Data.Field, mappingName As %String, linkCounter As %String, Note As %String)
{
	Set newLink = ##class(HS.Doc.Data.Link).%New()
	Set newLink.SourceField = newSource
	Set newLink.TargetField = newTarget
	Set newLink.MappingName = mappingName
	Set newLink.Comment = Note
	Set tSaveStatus = newLink.%Save()
	
	If $$$ISERR(tSaveStatus) Do ..LogError("CreateLink newLink.%Save() failed - "_$system.Status.GetErrorText(tSaveStatus))
	
	Set linkCounter = linkCounter + 1
	
	Quit
}

ClassMethod isValidSDAPath(tSourcePath As %String, tTargetPath As %String, tNote As %String, displayDetail As %String) As %Boolean
{
	// Examples.
	//    VALID
	//        HS.SDA3.Allergy.Allergy.OriginalText
	//        HS.SDA3.Allergy.Allergy.PriorCodes.*
	//    INVALID
	//        HS.SDA3.AdvanceDirective.AlertType.OriginalText
	//        HS.SDA3.AdvanceDirective.AlertType.PriorCodes.*
	
	s tIsValidSDAPath=1
	
	If $l(tSourcePath,".")>4
	   &&'$lf($lb("AbstractOrder","AbstractMedication","AbstractResultOrder"),$p(tSourcePath,".",3))
	   &&(($p(tSourcePath,".",5)="PriorCodes")||($p(tSourcePath,".",5)="OriginalText")) {
		If '..getValidSDAPath(tSourcePath) {
			s tIsValidSDAPath=0
			If displayDetail {
				w !,?10,"Skipping Invalid SDA Path: ",tSourcePath
				w !,?5,"  Source Path  = ",tSourcePath
				w !,?5,"  Target Path  = ",tTargetPath
				If tNote'="" w !,?5,"  Link Comment = ",tNote
				w !
			}
		}
	}
	
	Quit tIsValidSDAPath
}

ClassMethod getValidSDAPath(tFieldPath As %String) As %Boolean
{
	Set tIsValidSDAPath=$$$NO
	
	Set tClass=$ClassMethod($p(tFieldPath,".",1,3),"%New")
	Set tProp=$Property(tClass,$p(tFieldPath,".",4))
	If tProp="" Quit tIsValidSDAPath
	Set tPropClassName=tProp.%ClassName(1)
	Set tPropClass=$classmethod(tPropClassName,"%New")
	try {
		Set tPropClassProp=$Property(tPropClass,$p(tFieldPath,".",5))
		Set tIsValidSDAPath=$$$YES
	}
	catch {
		// this is not a valid property in the SDA class ... it will get skipped.
	}
	
	Quit tIsValidSDAPath
}

ClassMethod TrimPath(Path As %String)
{
	If (Path [ "text()") {
		Set Path = $extract(Path, 1, $length(Path) - 7)
	}
	Return Path
}

ClassMethod ParseHL7SourcePath(Source As HS.Doc.Mapping.HL7.SourceField)
{
	Return Source.Segment_"-"_Source.Field.Number
}

ClassMethod LogError(pErrorMessage)
{
	Set ^||tErrors($i(^||tErrors))=pErrorMessage
	Quit
}

}