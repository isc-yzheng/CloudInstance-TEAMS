Class HS.Doc.Utility.Search [ Abstract ]
{

/// Given a target field, find all the mappings from other data sources to it.
/// <p>
/// FieldId is an ID value from the HS_Doc_Data.Field table.
/// This ID value uniquely identifies a field in some document type.
/// An ID is used instead of a Path (used in prior versions of this method) 
/// because Path values in the HS_Doc_Data.Field table are not unique.
/// <p>
/// If displayDetail is 1, the Run() method will send 
/// detailed informational text to the current output device (e.g. Terminal).
/// When calling the Run() method method to get results for a user interface page,
/// set displayDetail to 0 (the default).
/// <p>
/// The output argument tRun is an identifier to use as 
/// input to any methods that display the results, i.e. UI rendering methods.
/// See HS.Doc.UI.Util and HS.Doc.UI.Mapping.
ClassMethod Run(FieldId As %String = "", displayDetail As %Boolean = 0, tRun As %String)
{
	// Search for a given target.
	// Example:
	// 		HSLIB>zn "HSEDGE1" Do ##class(HS.Doc.Utility.Search).Run("97",1)
	//
	//		Level: 1           C-CDA     /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.6.1']/entry/act/entryRelationship/observation/entryRelationship[@typeCode='MFST']/observation/effectiveTime/low/@value   (ID 3189)                                                                                                                                  
	//		          Source:  SDA     HS.SDA3.Allergy.FromTime   (ID 55)
	//		          Mapping: SDA To C-CDA Mapping
	//		          Notes:
 	// 		          
 	//                Level: 2           SDA     HS.SDA3.Allergy.FromTime   (ID 55)
 	//
 	//                          Source:  HL7     AL1-6   (ID 43)
 	//                          Mapping: HL7 to SDA3 Mapping
 	//		                    Notes:
 	//                                   The time of the onset of the allergy.The time of the onset of the allergy.
 	//
 	//                          Source:  C-CDA     /ClinicalDocument/component/structuredBody/component/section[templateId/@root='2.16.840.1.113883.10.20.22.2.6.1']/entry/act/entryRelationship/observation/effectiveTime/low/@value   (ID 1956)
 	//                          Mapping: C-CDA To SDA Mapping
 	//                          Notes:
 	//		Done.
 	//		HSEDGE1>
	
	set st = $$$OK
	try {
		set st = ..SearchTarget(FieldId, .tRun)
	}
	catch ex {
		set st = ex.AsStatus()
	}
	If ($$$ISERR(st)) {
		Do $System.Status.DisplayError(st)
	}
	Else {
		I displayDetail Do ..DisplayTarget(tRun) w !!,"Done."
	}
}

/// Given a target field, build a tree from other data sources to it.
/// Go down as many levels of mapping as required, avoiding any full circles.
/// <p>
/// FieldId is an ID value from the HS_Doc_Data.Field table.
/// This ID value uniquely identifies a field in some document type.
/// An ID is used instead of a Path (used in prior versions of this method) 
/// because Path values in the HS_Doc_Data.Field table are not unique.
/// <p>
/// The output argument tRun is an identifier to use as 
/// input to any methods that display the results.
ClassMethod SearchTarget(FieldId As %String = "", tRun As %String) As %Status
{
	// Produces a list of source<->targets<->source links in this global:
	// 		^||MapLink=#
	//		^||MapLink(tRun)=#
	//		^||MapLink(tRun,tLevel,tTargetId,tSourceId)=""
	//		^||MapLink(tRun,"Error")	<- if there are no levels in the run
	// Example:
	//		^||MapLink=3					meaning: There were 3 runs in this process
	//		^||MapLink(1)=0
	//		^||MapLink(1,"Error")="Invalid target path: InvalidPath"
	//		^||MapLink(2)=0
	//		^||MapLink(2,"Error")="No sources found for target path: /ClinicalDocument/component/InvalidPath"
	//		^||MapLink(3)=2
	//		^||MapLink(3,1,3189,55)=""		meaning: At link Level 1, Target FieldId 3189 has 1 Source fieldId, 55
	//		^||MapLink(3,2,55,43)=""		meaning: At link level 2, Target FieldId 55 has 1 Source fieldId-s,  43 and
	//		^||MapLink(3,2,55,1956)=""		                                                                   1956
	
	Set status = $$$OK
		
	Try
	{
		If (FieldId = "") {
			W !, "Field identifier is null"
			Set status = $$$ERROR($$$FileDoesNotExist, FieldId)
			Quit
		}
		
		Set tRootNode = ##class(HS.Doc.Utility.SearchNode).%New()
		
		// Find Field ID for given target
		Set query = "SELECT ID FROM HS_Doc_Data.Field WHERE ID = ?"
		//If displayDetail W !,"Query to verify target field ID: ",!,?5,query
		Set rs = ##class(%SQL.Statement).%ExecDirect(, query, FieldId)
		Set tRun=$i(^||MapLink),^||MapLink=tRun
		If ('rs.%Next()) {
			Set status = $$$ERROR($$$GeneralError, FieldId_" not a valid field identifier.")
			Set ^||MapLink(tRun)=0,^||MapLink(tRun,"Error")="No sources found for field identifier: "_FieldId
			Quit
		}
		Else {
			//If displayDetail W !,"Target ID: ",rs.ID,!
			Set ^||MapLink(tRun)=0
			Set tTargetsList=1,tTargetsList("targetsIDs",1)=rs.ID,tTargetsList("target level",rs.ID)=1	// the seed target we're searching for
		}
				
		Set tTargetNodeIds = ##class(%ListOfDataTypes).%New()
		Do tTargetNodeIds.Insert(tRootNode.%Oid())
		
		Set tTargetCount=0
		While tTargetsList>tTargetCount {
			Set tTargetCount=$i(tTargetCount)
			//w !,"*** tTargetCount = ",tTargetCount,!
			Set query = "SELECT SourceField, MappingName FROM HS_Doc_Data.Link WHERE TargetField = ?"
			//If displayDetail W !,"Query to identify the links with this target ID: ",!,?5,query,!
			Set rs = ##class(%SQL.Statement).%ExecDirect(, query, tTargetsList("targetsIDs",tTargetCount))
			While (rs.%Next()) {
				// We found at least one source (rs.SourceField) for this target (tTargetsList("targetsIDs",tTargetCount)).
				// However, if we already found that this source was this target's target, skip it.
				// That's because when we build the SDA<->CCDA mapping, many items are in [target-source], as well as [source-target]
				// relationship and the code below would get in an infinite loop. 
				If $d(tLink("Source/Target",tTargetsList("targetsIDs",tTargetCount),rs.SourceField)) continue
				// Create new node
				Set (tLevel,^||MapLink(tRun))=tTargetsList("target level",tTargetsList("targetsIDs",tTargetCount))
				If '$data(tTargetsList("target level",rs.SourceField)){	//Don't add to target list more than once, to prevent cycles
					Set tTargetsList("targetsIDs",$i(tTargetsList))=rs.SourceField,tTargetsList("target level",rs.SourceField)=tLevel+1
				}
				Set tLink("Source/Target",rs.SourceField,tTargetsList("targetsIDs",tTargetCount))=""
				Set ^||MapLink(tRun,tLevel,tTargetsList("targetsIDs",tTargetCount),rs.SourceField)=""
				Set ^||MapLink(tRun,tLevel,tTargetsList("targetsIDs",tTargetCount),rs.SourceField,"mapping")=rs.MappingName
			}
			
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
		Write $SYSTEM.Status.GetErrorText(status)
	}
	Quit status
}

ClassMethod DisplayTarget(tRun) As %Status
{
	Set status = $$$OK
	
	Try
	{
		For tLevel=1:1:^||MapLink(tRun) {
			Set tTargetId="" For  {
				Set tTargetId=$o(^||MapLink(tRun,tLevel,tTargetId)) q:tTargetId=""
				W !!,$j("",(tLevel-1)*10),"Level: ", tLevel," ",$j("",10-$l("Level: "_tLevel_" ")+$l("Mapping: ")) d ..showField(tTargetId)
				Set tSourceId="" For  {
					Set tSourceId=$o(^||MapLink(tRun,tLevel,tTargetId,tSourceId)) q:tSourceId=""
					W !!,$j("",tLevel*10),"Source:  " d ..showField(tSourceId)
					d ..getLinkInfo(tSourceId,tTargetId,.tMappingName,.tComment)
					W !,$j("",tLevel*10),"Mapping: ",tMappingName
					W !,$j("",tLevel*10),"Notes:   " d ..showComment(tComment,tLevel*10+9)
				}
			}
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
		Write $SYSTEM.Status.GetErrorText(status)
	}
	Quit status
}

ClassMethod showField(tFieldId As %String) As %Status
{
	Set status = $$$OK
	
	Try
	{
		Set tField = ##class(HS.Doc.Data.Field).%OpenId(tFieldId)
		w tField.DocumentType,$j("",5),tField.Path
		w "   (ID ",tFieldId,")"
	}
	Catch ex
	{
		Set status = ex.AsStatus()
		Write $SYSTEM.Status.GetErrorText(status)
	}
	Quit status
}

ClassMethod getLinkInfo(pSourceId As %String, pTargetId As %String, pMappingName As %String, pComment As %String) As %Status
{
	Set status = $$$OK
	
	Try
	{
		Set query =       "SELECT * FROM HS_Doc_Data.Link "
		Set query = query_"WHERE SourceField = ?"
		Set query = query_"  AND TargetField = ?"
		
		Set rs = ##class(%SQL.Statement).%ExecDirect(, query, pSourceId, pTargetId)
		While (rs.%Next()) {
			// Create new node
			s pComment = rs.Comment //w !,$replace($replace(tComment,$c(13),""),$c(10),"")
			s pMappingName = rs.MappingName //w !,tMappingName
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
		Write $SYSTEM.Status.GetErrorText(status)
	}
	Quit status
}

ClassMethod showComment(pComment As %String, pAllignment As %String)
{
	f lineCount=1:1:$l(pComment,$c(10,13)) {
		w !,$j("",pAllignment),$p(pComment,$c(10,13),lineCount)
	}
}

}
