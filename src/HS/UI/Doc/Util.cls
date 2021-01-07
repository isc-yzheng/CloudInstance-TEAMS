Class HS.UI.Doc.Util [ Abstract ]
{

/// Domain used for localization.
Parameter DOMAIN = "HS";

ClassMethod GetTargetDisplay(FieldId As %String = "", display As %ZEN.proxyObject) As %Status
{
	Set status = $$$OK
	Try {
		Do ##class(HS.Doc.Utility.Search).Run(FieldId, 0, .tRun)
		Set status = ..DisplayTarget(tRun, .display)
	}
	Catch (ex) {
		Set status = ex.AsStatus()
	}
	Quit status
}

ClassMethod DisplayTarget(tRun, display As %ZEN.proxyObject) As %Status
{
	Set status = $$$OK
	Set display = ##class(%ZEN.proxyObject).%New()
	Try
	{
		Set levels = ##class(%ListOfDataTypes).%New()
		For tLevel=1:1:^||MapLink(tRun) {
			Set level = ##class(%ZEN.proxyObject).%New()
			Set level.number = tLevel
			Set targets = ##class(%ListOfDataTypes).%New()
			Set tTargetId="" For  {
				Set tTargetId=$o(^||MapLink(tRun,tLevel,tTargetId)) q:tTargetId=""
				Set status = ..getField(tTargetId, .target)
				Continue:$$$ISERR(status)
				set prev = tLevel - 1
				set target.sourceOfLevel = ""
				set keyPrev = ""
				for {
					set keyPrev = $o(^||MapLink(tRun,prev,keyPrev)) q:keyPrev=""
					if ($d(^||MapLink(tRun,prev,keyPrev,tTargetId))) {
						set target.sourceOfLevel = prev
						set status = ..getTargetAncestors(tRun,prev,keyPrev,tTargetId,.target)
						Continue:$$$ISERR(status)
						quit
					}
				}
				Set sources = ##class(%ListOfDataTypes).%New()
				Set tSourceId="" For  {
					Set tSourceId=$o(^||MapLink(tRun,tLevel,tTargetId,tSourceId)) q:tSourceId=""
					Set status = ..getField(tSourceId, .source)
					Continue:$$$ISERR(status)
					Set status = ##class(HS.Doc.Utility.Search).getLinkInfo(tSourceId,tTargetId,.tMappingName,.tComment)
					Continue:$$$ISERR(status)
					Set source.mapping = tMappingName
					Set status = ..getComment(tComment, .notes)
					Continue:$$$ISERR(status)
					Set source.notes = notes
					set next = tLevel + 1
					if ($o(^||MapLink(tRun,next,tSourceId,"")) '= "") {
						set source.targetOfLevel = next
					}
					else {
						set source.targetOfLevel = ""
					}
					set status = ..getSourceAncestors(tRun, tLevel, tSourceId, tTargetId, .source)
					Continue:$$$ISERR(status)
					Do sources.Insert(source)
				}
				Set target.sources = sources
				Do targets.Insert(target)
			}
			Set level.targets = targets
			Do levels.Insert(level)
		}
		Set display.levels = levels
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

ClassMethod getField(tFieldId As %String, field As %ZEN.proxyObject) As %Status
{
	Set status = $$$OK
	Try {
		Set tField = ##class(HS.Doc.Data.Field).%OpenId(tFieldId)
		Set field = ##class(%ZEN.proxyObject).%New()
		set field.type = tField.DocumentType
		set field.name = tField.Name
		set field.path = tField.Path
		set field.id = tFieldId
	}
	Catch (ex) {
		Set status = ex.AsStatus()
	}
	Quit status
}

ClassMethod getComment(tComment As %String, notes As %ListOfDataTypes)
{
	Set status = $$$OK
	Try
	{
		Set newPara = 1
		Set para = ""
		Set notes = ##class(%ListOfDataTypes).%New()
		For lineCount=1:1:$l(tComment,$c(10,13)) {
			Set line = ..Strip($p(tComment,$c(10,13),lineCount))
			If (line = "") {
				If (para '= "") {
					Do notes.Insert(para)
					Set para = ""
				}
			}
			Else {
				Set para = para _ line _ " "
			}

		}
		If (para '= "") {
			Do notes.Insert(para)
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

ClassMethod getTargetAncestors(run As %Integer, prev As %Integer, keyPrev As %String, targetId As %String, target As %ZEN.proxyObject) As %Status
{
	Set status = $$$OK
	Try {
		set aList = $g(^||MapLink(run,prev,keyPrev,targetId,"ancestors"),"")
		if (aList = "") {
			set target.ancestors = ""
			set target.aIdList = ""
		}
		else {
			set status = ..getAncestorsFromList(aList, .ancestors, .aIdList)
			set target.ancestors = ancestors
			set target.aIdList = aIdList
		}
		set mList = $g(^||MapLink(run,prev,keyPrev,targetId,"aMapping"),"")
		if (mList = "") {
			set target.aMappingList = ""
		}
		else {
			Set aMappingList = ##class(%ListOfDataTypes).%New()
			for n=1:1:$l(mList,",") {
				set mapping = $p(mList,",",n)
				Do aMappingList.Insert(mapping)
			}
			set target.aMappingList = aMappingList
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

ClassMethod getAncestorsFromList(aList As %String, ancestors As %ListOfDataTypes, aIdList As %ListOfDataTypes) As %Status
{
	Set status = $$$OK
	Try {
		Set ancestors = ##class(%ListOfDataTypes).%New()
		Set aIdList = ##class(%ListOfDataTypes).%New()
		for n=1:1:$l(aList,",") {
			set id = $p(aList,",",n)
			Set field = ##class(HS.Doc.Data.Field).%OpenId(id)
			if ($IsObject(field) && (field.Path '= "")) {
				set entry = "("_field.DocumentType_")&nbsp;&nbsp;"_field.Path
				Do ancestors.Insert(entry)
				Do aIdList.Insert(id)
			}
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

ClassMethod getSourceAncestors(run As %Integer, level As %Integer, sourceId As %String, targetId As %String, source As %ZEN.proxyObject) As %Status
{
	Set status = $$$OK
	Try {
		// find maplink entry such that the current targetId is the sourceId;
		// get the ancestors value from that entry;
		// append the current targetId;
		// make it the ancestors value for this sourceId entry in maplink;
		set prev = level - 1
		if (prev = 0) {
			set ^||MapLink(run,level,targetId,sourceId,"ancestors") = targetId
			set ^||MapLink(run,level,targetId,sourceId,"aMapping") = $g(^||MapLink(run,level,targetId,sourceId,"mapping"),"")
		}
		else {
			set parentKey = "" for {
				set parentKey=$o(^||MapLink(run,prev,parentKey)) q:parentKey=""
				set childKey = "" for {
					set childKey = $o(^||MapLink(run,prev,parentKey,childKey)) q:childKey=""
					if (childKey = targetId) {
						set ^||MapLink(run,level,targetId,sourceId,"ancestors") = $g(^||MapLink(run,prev,parentKey,childKey,"ancestors"),"")_","_targetId
						set ^||MapLink(run,level,targetId,sourceId,"aMapping") = $g(^||MapLink(run,prev,parentKey,childKey,"aMapping"),"")_","_$g(^||MapLink(run,level,targetId,sourceId,"mapping"),"")
						quit
					}
				}
			}
		}
		set aList = $g(^||MapLink(run,level,targetId,sourceId,"ancestors"),"")
		if (aList = "") {
			set source.ancestors = ""
			set source.aIdList = ""
		}
		else {
			set status = ..getAncestorsFromList(aList, .ancestors, .aIdList)
			set source.ancestors = ancestors
			set source.aIdList = aIdList
		}
		set mList = $g(^||MapLink(run,level,targetId,sourceId,"aMapping"),"")
		if (mList = "") {
			set source.aMappingList = ""
		}
		else {
			Set aMappingList = ##class(%ListOfDataTypes).%New()
			for n=1:1:$l(mList,",") {
				set mapping = $p(mList,",",n)
				Do aMappingList.Insert(mapping)
			}
			set source.aMappingList = aMappingList
		}
	}
	Catch (ex) {
		Set status = ex.AsStatus()
	}
	Quit status
}

/// Change carriage returns and line feeds to spaces.
/// Strip leading and trailing spaces.
ClassMethod Strip(text As %String) As %String
{
	set text = $ZConvert(text,"O","HTML")
	set text = $replace(text,$c(13,10),"<br/>")
	set text = $replace(text,$c(10,13),"<br/>")
	set text = $replace(text,$c(13),"<br/>")
	set text = $replace(text,$c(10),"<br/>")
	set text = $ZSTRIP(text,"<>W")
	quit text
}

/// Escape single quote characters in a string intended to be
/// placed within single quote characters as a literal value in SQL.
ClassMethod SQLEscape(text As %String) As %String
{
	set text = $replace(text,"'","''")
	quit text
}

}
