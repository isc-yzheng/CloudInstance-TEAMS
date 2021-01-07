/// Find transformatino mappig documentation
Class HS.UI.Doc.Mapping Extends HS.HC.UI.Util
{

Parameter PAGENAME = "SDA/CDA Annotations";

Parameter RESOURCE = "%Ens_EDISchemaAnnotations:READ";

Property dropdownLimit As %Integer [ InitialExpression = 250 ];

Property typeList As %String;

XData Style
{
<style type="text/css">
.hintDiv {
	width:800px;
	font-size:9pt;
}
.resultDiv {
	font-size:9pt;
}
.resultDiv p {
	font-size:9pt;
}
.resultDiv h1 {
	font-size:14pt;
	padding-bottom:12px;
}
.resultDiv h2 {
	font-size:12pt;
	padding-top:5px;
	padding-left:30px;
}
div.ancestorContainer {
	padding-top:0px;
	padding-left:5px;
	border-left:1px solid lightgray;
}
a.portalTitleLink {
	font-family:verdana,Tahoma;
	color: #3b84bc;
	text-decoration: none;
	cursor:pointer;
    -webkit-transition-property: color;
    -webkit-transition-duration: 0.33s;
    -webkit-transition-timing-function: ease;
    -moz-transition-property: color;
    -moz-transition-duration: 0.33s;
    -moz-transition-timing-function: ease;
    -ms-transition-property: color;
    -ms-transition-duration: 0.33s;
    -ms-transition-timing-function: ease;
}
hr.targetMarker {
	margin-left:30px;
	border:none;
	border-bottom:1px solid lightgray;
}
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#">
<html OnDrawContent="DrawTitle" id="title" seed=""/>
<spacer height="10" />
<hgroup>
<spacer width="20"/>
<vgroup id="stepByStep" cellVAlign="top">
<html OnDrawContent="DrawHint" id="typeChoiceHint" seed="1:TypeChoice"/>
<html OnDrawContent="DrawTypeChoice" id="typeChoiceContainer" seed=""/>
<html OnDrawContent="DrawHint" id="textareaHint" seed="2:Textarea"/>
<textarea id="inputText" cols="100" rows="4" onkeypress="zenPage.enterKey(zenEvent);"/>
<html OnDrawContent="DrawHint" id="generateHint" seed="3:Generate"/>
<button id="generateButton" caption="Show Options" onclick="zenPage.populateDropdown();" controlClass="commandButton"/>
<html OnDrawContent="DrawHint" id="dropdownHint" seed="4:Dropdown"/>
<html OnDrawContent="DrawDropdown" id="dropdownContainer" seed=""/>
<html OnDrawContent="DrawHint" id="resultsHint" seed="5:Results"/>
<html OnDrawContent="DrawResults" id="results"  seed=""/>
</vgroup>
</hgroup>
</page>
}

Method DrawTitle(pSeed As %String) As %Status
{
	Set tTitle = $$$TextHTML("SDA/CDA Annotations")
	do %application.DrawTitle(tTitle,0)
	Quit $$$OK
}

Method DrawHeading(pSeed As %String) As %Status
{
	Set tSC = $$$OK
	try {
		if (pSeed = "Field") {
			set text = $$$Text("Choose Field")
		}
		elseif (pSeed = "Results") {
			set text = $$$Text("View Mappings")
		}
		write "<div class=""resultDiv""><h1>"_text_"</h1></div>"
	}
	catch (ex) {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method DrawHint(pSeed As %String) As %Status
{
	Set tSC = $$$OK
	try {
		quit:pSeed=""
		quit:$l(pSeed,":")'=2
		set step = $p(pSeed,":",1)
		set which = $p(pSeed,":",2)
		set stepText = $$$FormatText($$$Text("Step %1: "),step)
		set titleText = ""
		if (which = "BuildButton") {
			set hintText = 
				$$$Text("Build all document transformation mapping information by clicking the button below.")_" "_
				$$$Text("You only need to do this once per installation.")
		}
		elseif (which = "TypeChoice") {
			set hintText = 
				$$$Text("Choose target document type(s).")
		}
		elseif (which = "Textarea") {
			set hintText = 
			   $$$Text("Indicate a field by typing all or part of the field name or path.")_" "_
			   $$$FormatText($$$Text("Use %1 or a space to substitute for missing text."),"*")
			set titleText =
			   $$$Text("Instead of typing, you may copy and paste in any fragment of XML.")_" "_
			   $$$Text("Begin and end tags need not match, but to be found in the fragment, a field name must begin and end with < and >.")
		}
		elseif (which = "Generate") {
			set hintText = 
			   $$$Text("Generate a menu of options by clicking the button below.")_" "_
			   $$$Text("As a shortcut, you may press Enter while typing in Step 2.")
		}
		elseif (which = "Dropdown") {
			set hintText = 
			   $$$Text("Choose a target field from the dropdown menu.")
		}
		elseif (which = "Results") {
			set hintText = 
			   $$$Text("View document transformation mapping information below.")
		}
		w "<div class=""hintDiv"" title="""_titleText_"""><p><strong><nobr>"_stepText_"&nbsp;</nobr></strong>"_hintText_"</p></div>"
	}
	catch (ex) {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method DrawResults(pSeed As %String) As %Status
{
	Set status = $$$OK
	try {
		quit:pSeed=""
		Set status = ##class(HS.UI.Doc.Util).GetTargetDisplay(pSeed, .display)
		Quit:$$$ISERR(status)
		
		set opening = "<html><head></head><body><div class=""resultDiv"">"
		Set closing = "<p style=""margin-top:25px;""><a href=""#results"" class=""portalTitleLink"">"_
			$$$Text("Top of Results")_"</a></p>"_
			"<p style=""margin-top:10px;""><a href=""#"" class=""portalTitleLink"">"_
			$$$Text("Top of Page")_"</a></p>"_
			"<p id=""bottom"">&nbsp;</p>"_
			"</div></body></html>"
		set tableStart =  "<table border=0 cellpadding=0 cellspacing=2 style=""margin-left:50px;"">"
		set tableEnd = "</table>"
		set spacer = "<p style=""padding:0px;padding-top:5px;margin:0px;"">&nbsp;</p>"
		kill intro
		kill sinfo
		kill tinfo
		
		Set keyLevel = ""
		For {
			Set level = display.levels.GetNext(.keyLevel)
			Quit:keyLevel=""
			set number = level.number
			set title = $$$FormatText($$$Text("Level %1"), number)
			set i = 0
			if (number = 1) {
				set intro(number,$i(i)) = "<p><a href=""#results"" class=""portalTitleLink"">"_
					$$$Text("Move Results to Top")_"</a></p>"_
					"<p id=""results"" style=""margin-top:10px;""><a href=""#bottom"" class=""portalTitleLink"">"_
					$$$Text("Go to Bottom of Results")_"</a></p>"_
					"<p style=""margin-top:10px;""><a href=""#"" class=""portalTitleLink"">"_
					$$$Text("Go to Top of Page")_"</a></p>"_
					"<h1 id=""level"_number_""" style=""margin-top:30px;"">"_title_"</h1>"
			}
			else {
				set intro(number,$i(i)) = "<h1 id=""level"_number_""">"_title_"</h1>"
			}
			
			set keyTarget = ""
			For {
				set target = level.targets.GetNext(.keyTarget)
				Quit:keyTarget=""
				set tinfo(number, keyTarget, $i(i)) = "<hr class=""targetMarker"" />"
				set tinfo(number, keyTarget, $i(i)) = "<h2 id=""level"_number_"target"_target.id_""">"_$$$Text("Target")_"</h2>"
				Set status = ..WriteField(target.type, target.name, target.path, number, target.id, "", target.sourceOfLevel, target.ancestors, target.aIdList, target.aMappingList, .text)
				quit:$$$ISERR(status)
				set tinfo(number, keyTarget, $i(i)) = tableStart
				set tinfo(number, keyTarget, $i(i)) = text
				set tinfo(number, keyTarget, $i(i)) = tableEnd
				Set count = target.sources.Count()
				if (count <= 0) {
					Set tinfo(number, keyTarget, $i(i)) = "<p>"_$$$Text("No sources known for this target.")_"</p>"
					quit
				}
				elseif (count = 1) {
					set tinfo(number, keyTarget, $i(i)) = "<h2 id=""level"_number_"source"">"_$$$Text("Source")_"</h2>"
				}
				else {
					set tinfo(number, keyTarget, $i(i)) = "<h2 id=""level"_number_"source"">"_$$$Text("Sources")_"</h2>"
				}
				
				Set keySource = ""
				for {
					Set source = target.sources.GetNext(.keySource)
					Quit:keySource=""
					Set status = ..WriteField(source.type, source.name, source.path, number, target.id, source.id, source.sourceOfLevel, source.ancestors, source.aIdList, source.aMappingList, .textField)
					quit:$$$ISERR(status)
					Set status = ..WriteMapping(source.mapping, source.type, source.notes, source.targetOfLevel, number, target.id, source.id, source.path, source.ancestors, source.aIdList, source.aMappingList, .textMapping)
					quit:$$$ISERR(status)
					set j = 0
					set sinfo(number, keyTarget, keySource, $i(j)) = tableStart
					set sinfo(number, keyTarget, keySource, $i(j)) = textField
					set sinfo(number, keyTarget, keySource, $i(j)) = textMapping
					set sinfo(number, keyTarget, keySource, $i(j)) = tableEnd 
					set sinfo(number, keyTarget, keySource, $i(j)) = spacer
				}
			}
		}
		
		Write opening
		set keyLevel = ""
		for {
			set keyLevel = $o(intro(keyLevel))
			quit:keyLevel=""
			set keyIntro = ""
			for {
				set keyIntro = $o(intro(keyLevel,keyIntro),1,value)
				quit:keyIntro=""
				Write value
			}
			set keyTargetWrite = ""
			for {
				set keyTargetWrite = $o(tinfo(keyLevel,keyTargetWrite))
				quit:keyTargetWrite=""
				set keyLineTarget = ""
				for {
					set keyLineTarget = $o(tinfo(keyLevel,keyTargetWrite,keyLineTarget),1,info)
					quit:keyLineTarget=""
					Write info
				}
				set keySourceWrite = ""
				for {
					set keySourceWrite = $o(sinfo(keyLevel,keyTargetWrite,keySourceWrite))
					quit:keySourceWrite=""
					set keyLine = ""
					for {
						set keyLine = $o(sinfo(keyLevel,keyTargetWrite,keySourceWrite,keyLine),1,text)
						quit:keyLine=""
						Write text
					}
				}
			}
		}
		Write closing
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

Method DrawDropdown(pSeed As %ZEN.proxyObject) As %Status
{
	Set status = $$$OK
	Try {
		if ('$isObject(pSeed)) quit
		set path = ##class(HS.UI.Doc.Util).Strip(pSeed.path)
		if (path = "") quit
		if ($f(path,">")) {
			set status = ..GenerateQueryStrings(path, .list) quit:$$$ISERR(status)
		}
		else {
			set status = ..GenerateSimpleList(path, .list) quit:$$$ISERR(status)
		}
		set status = ..GenerateDropdownList(list, pSeed.typeList, .options, .values, .maxlen) quit:$$$ISERR(status)
		set status = ..RenderDropdown(options, values, maxlen) quit:$$$ISERR(status)
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

Method GenerateSimpleList(text As %String, Output list As %ListOfDataTypes) As %Status
{
	Set status = $$$OK
	Try {
		set text = ##class(HS.UI.Doc.Util).Strip(text)
		set text = $replace(text," ","*")
		if (text = "") quit
		set list = ##class(%ListOfDataTypes).%New()
		for i=1:1:$l(text,"*") {
			set tag(i) = $p(text,"*",i)
		}
		set string = "%"
		set key = "" for { set key = $o(tag(key),1,value) quit:key=""
			if (value '= "") {
				set string = string _ value _ "%"
			}
		}
		do list.Insert(string)
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

Method GenerateQueryStrings(text As %String, Output list As %ListOfDataTypes) As %Status
{
	Set status = $$$OK
	Try {
		set text = ##class(HS.UI.Doc.Util).Strip(text)
		if ((text = "") || ($l(text,">") <= 0)) quit
		set list = ##class(%ListOfDataTypes).%New()

		for i=1:1:$l(text,">") {
			set tag(i) = $p(text,">",i)
		}
		set key = "" for { set key = $o(tag(key),1,value) quit:key=""
			if ($l(value,"<") = 2) {
				set tag(key) = $p(value,"<",2)
			}
			else {
				set tag(key) = ""
			}
		}
		set key = "" for { set key = $o(tag(key),1,value) quit:key=""
			if ($l(value," ") > 0) {
				set tag(key) = $p(value," ",1)
			}
		}
		set j = 0
		set key = "" for { set key = $o(tag(key),1,value) quit:key=""
			if (value '= "") {
				set final($i(j)) = value
			}
		}
		set prev = ""
		set next = ""
		set currentHigher = ""
		set current = ""
		set key = "" 
		set prevIsEnd = 0
		set prevIsLeafEnd = 0
		for { 
			set key = $o(final(key),1,value) 
			quit:key=""
			set item = value
			if ($e(item,1,1) = "/") {
				set prev = next
				set next = $e(item,2,*)
				if (next = prev) {
					do list.Insert(current_"%")
					set prevIsLeafEnd = 1
				}
				else {
					if ((prevIsLeafEnd) || (prevIsEnd)) {
						set current = currentHigher
						set pos=1
						for {
							set possible = pos
							set pos = $f(currentHigher, "%", pos)
							if ('pos) {
								if (possible > 2) {
									set currentHigher = $e(currentHigher,1,possible-2)
								}
								else {
									set currentHigher = ""
								}
								quit
							}
						}
					}
					set prevIsLeafEnd = 0
				}
				set prevIsEnd = 1
			}
			else {
				set prev = next
				set next = item
				if (('prevIsLeafEnd) && ('prevIsEnd)) {
					set currentHigher = current
				}
				set current = currentHigher _ "%" _ next
				set prevIsEnd = 0
				set prevIsLeafEnd = 0
			}
		}
		if (current '= "") {
			do list.Insert(current_"%")
		}
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

Method GenerateDropdownList(list As %ListOfDataTypes, currentList As %String, Output options As %ListOfDataTypes, Output values As %ListOfDataTypes, Output maxlen As %Integer) As %Status
{
	Set status = $$$OK
	Try {
		if ('$isObject(list)) quit
		
		// where clause and type prefix
		set whereType = ""
		set count = 0
		Set tParams=0
		if ((currentList '= "All") && (currentList '= ..typeList)) {
			for n=1:1:$l(currentList,":") {
				set item = $p(currentList,":",n)
				continue:item=""
				set count = $i(count)
				set connector = $s(whereType="":"(", 1:"OR (")
				set whereType = whereType _ connector _ "DocumentType = ?) "
				Set tParams($I(tParams))=item
			}
			if (whereType '= "") {
				set whereType = "("_whereType_") "
			}
		}
		set wherePath = ""
		set key = ""
		for {
			set item = list.GetNext(.key)
			quit:key=""
			set item = ##class(HS.UI.Doc.Util).SQLEscape(item)
			set connector = $s(wherePath="":"(", 1:"OR (")
			set wherePath = wherePath _ connector _ "FIELD.Path LIKE ?) "
			Set tParams($I(tParams))=item
		}
		if (wherePath '= "") {
			set wherePath = "("_wherePath_") "
		}
		set where = ""
		if (whereType '= "") {
			set where = "WHERE "_whereType
			if (wherePath '= "") {
				set where = where_"AND "_wherePath
			}
		}
		else {
			if (wherePath '= "") {
				set where = "WHERE "_wherePath
			}
		}
		
		// other sql parts
		set select = "select FIELD.ID as ID, FIELD.DocumentType as Type, FIELD.Path as Path "
		set from = "from HS_Doc_Data.Field FIELD  "_
			"RIGHT JOIN HS_Doc_Data.Link LINK "_
			"ON LINK.TargetField=FIELD.ID "
		set groupBy = "GROUP BY FIELD.ID "
		set orderBy = "ORDER BY FIELD.DocumentType "
		set sql = select_from_where_groupBy_orderBy
		
		// get the data
		set statement = ##class(%SQL.Statement).%New()
		set status = statement.%Prepare(sql) quit:$$$ISERR(status)
		If (tParams>0){
			set result = statement.%Execute(tParams...)
		}
		Else{
			set result = statement.%Execute()
		}
		set limit = ..dropdownLimit
		set count = 0
		set maxlen = 0
		set options = ##class(%ListOfDataTypes).%New()
		set values = ##class(%ListOfDataTypes).%New()
		while result.%Next() {
			set count = $i(count) quit:count>limit
			set path = result.Path
			set len = $l(path)
			if (len > maxlen) set maxlen = len
			set option = "("_result.Type_")&nbsp;&nbsp;"_path
			do options.Insert(option)
			do values.Insert(result.ID)
		}
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

Method RenderDropdown(options As %ListOfDataTypes, values As %ListOfDataTypes, maxlen As %Integer) As %Status
{
	Set status = $$$OK
	Try {
		Write "<select id=""selectField"" onchange=""zenPage.renderResults();"">"
		if (($isObject(options)) && ($isObject(values))) {
			if (maxlen > 120) {
				Write "<option value=""@"" style=""color:gray;"">"_
					$$$Text("(Click here to toggle the list of fields)")_"</option>"
			}
			else {
				Write "<option value=""@""></option>"
			}
			set count = options.Count()
			set keyOption = ""
			set keyValue = ""
			for {
				set option = options.GetNext(.keyOption)
				quit:keyOption=""
				set value = values.GetNext(.keyValue)
				quit:keyValue=""
				Write "<option value="""_value_""">"_option_"</option>"
			}
			if (count = ..dropdownLimit) {
				Write "<option value=""*"">"_
					$$$FormatText($$$Text("(Results limited to %1 options)"),..dropdownLimit)_
					"</option>"
			}
			elseif (count = 0) {
				Write "<option value=""+"">"_
					$$$Text("(No results found)")_
					"</option>"
			}
			elseif (count = 1) {
				Write "<option value=""+"">"_
					$$$Text("(1 result found)")_
					"</option>"
			}
			else {
				Write "<option value=""+"">"_
					$$$FormatText($$$Text("(%1 results found)"),count)_
					"</option>"
			}
		}
		Write "</select>"
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

/// Even though we are writing about only one field, we provide arguments for level
/// and for both targetId and sourceId.
/// This is because, in order to be unique, the HTML div ids we construct for sources 
/// must also contain the level and targetId under which that source appears.
/// If the field we are writing about is a target, we only need the targetId, so sourceId is blank ("").
/// If the field we are writing about is a source, we need both targetId and sourceId to be non-blank to construct the HTML.
ClassMethod WriteField(type As %String, name As %String = "", path As %String, level As %Integer, targetId As %String, sourceId As %String, sourceOfLevel As %Integer, ancestors As %ListOfDataTypes, aIdList As %ListOfDataTypes, aMappingList As %ListOfDataTypes, Output text As %String) As %Status
{
	Set status = $$$OK
	Try {
		quit:targetId=""
		if (sourceId = "") {
			set id = targetId
			set fieldLabel = $$$Text("Target Field Name")
		}
		else {
			set id = sourceId
			set fieldLabel = $$$Text("Source Field Name")
		}
		set idString = " class="""_id_""" onclick=""zenPage.toggleHighlight('"_id_"');"""
		set text = "<tr>"_
			"<td style=""text-align:right;padding-right:10px;""><strong><nobr>"_$$$Text("Document Type")_"</nobr></strong></td>"_
			"<td>"_type_"</td>"
		if (name '= "") {
			set text = text _
				"</tr><tr>"_
				"<td style=""text-align:right;padding-right:10px;""><strong><nobr>"_fieldLabel_"</nobr></strong></td>"_
				"<td>"_name_"</td>"
		}
		set text = text _
			"</tr><tr>"_
			"<td style=""text-align:right;padding-right:10px;""><strong><nobr>"_$$$Text("Path")_"</nobr></strong></td>"
		set text = text _ 
			"<td"_idString_">" _ path _ "</td>"
		if (sourceOfLevel '= "") { // this should happen only for targets
			if ((ancestors '= "") && (aIdList '= "") && (aMappingList '= "")) { // the new way
				set status = ..WriteAncestors(level, targetId, sourceId, type, path, ancestors, aIdList, aMappingList, .mapToTop)
				quit:$$$ISERR(status)
				set text = text _ mapToTop
			}
			else { // the old way: should probably never happen
				set text = text_
					"</tr><tr>"_
					"<td style=""text-align:right;padding-right:10px;""><strong><nobr>"_$$$Text("Trace Up")_"</nobr></strong></td>"_
					"<td><a href=""#level"_sourceOfLevel_""" class=""portalTitleLink"" onclick=""zenPage.highlightField('"_id_"');"">"_
					$$$FormatText($$$Text("This target is a source in Level %1."), sourceOfLevel)_
					"</a></td>"
			}
		}
		set text = text_"</tr>"
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

/// Even though we are writing about only one field, we provide arguments for level and both targetId and sourceId.
/// This is because, in order to be unique, the HTML div ids we construct for sources 
/// must also contain the level and targetId under which that source appears.
ClassMethod WriteMapping(mapping As %String, type As %String, notes As %ListOfDataTypes, targetOfLevel As %Integer, level As %Integer, targetId As %String, sourceId As %String, path As %String, ancestors As %ListOfDataTypes, aIdList As %ListOfDataTypes, aMappingList As %ListOfDataTypes, Output text As %String) As %Status
{
	Set status = $$$OK
	Try {
		set text = "<tr>"_
			"<td style=""text-align:right;padding-right:10px;""><strong><nobr>"_$$$Text("Mapping")_"</nobr></strong></td>"_
			"<td>"_mapping_"</td>"
		if (notes.Count() > 0) {
			set text = text_"</tr><tr valign=""top"">"_
				"<td style=""text-align:right;padding-right:10px;""><strong><nobr>"_$$$Text("Notes")_"</nobr></strong></td>"_
				"<td>"
			Set key = ""
			for {
				Set para = notes.GetNext(.key)
				quit:key=""
				if (para '= "") {
					set text = text_para_"<br/>"
				}
			}
			set text = text_"</td>"
		}
		if (targetOfLevel '= "") {
			set text = text_"</tr><tr>"_
				"<td style=""text-align:right;padding-right:10px;""><strong><nobr>"_$$$Text("Trace Down")_"</nobr></strong></td>"_
				"<td>"
			set href = "<a href=""#level"_targetOfLevel_"target"_sourceId_""" class=""portalTitleLink"" onclick=""zenPage.highlightField('"_sourceId_"');"">"
			set text = text_href_$$$FormatText($$$Text("This source is a target in Level %1."), targetOfLevel)_"</a>"
			set text = text_"</td>"
		}
		if ((ancestors '= "") && (aIdList '= "") && (aMappingList '= "")) {
			set status = ..WriteAncestors(level, targetId, sourceId, type, path, ancestors, aIdList, aMappingList, .mapToTop)
			quit:$$$ISERR(status)
			set text = text _ mapToTop
		}
		set text = text_"</tr>"
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

/// Even though we are writing about only one field, we provide arguments for both targetId and sourceId.
/// This is because, in order to be unique, the HTML div ids we construct for sources 
/// must also contain the targetId under which that source appears.
/// If the field we are writing about is a target, we only need the targetId, so sourceId is blank ("").
/// If the field we are writing about is a source, we need both targetId and sourceId to construct the HTML.
ClassMethod WriteAncestors(level As %Integer, targetId As %String, sourceId As %String, type As %String, path As %String, ancestors As %ListOfDataTypes, aIdList As %ListOfDataTypes, aMappingList As %ListOfDataTypes, Output text As %String) As %Status
{
	Set status = $$$OK
	Try {
		quit:targetId=""
		if (sourceId = "") {
			// the field is a target field
			// level = the number of the level where targetId is a target
			set idString = "Level"_level_"target"_targetId
		}
		else {
			// the field is a source field
			// level = the number of the level where sourceId is a source for targetId
			set idString = "Level"_level_"target"_targetId_"source"_sourceId
		}
		set text = ""
		set text = text _ 
			"</tr><tr valign=""top"">"_
			"<td style=""text-align:right;padding-right:10px;"">" _
			"<strong><nobr>"_$$$Text("Trace to Top")_"</nobr></strong></td>"_
			"<td>"_
			"<div style=""padding-top:0px;padding-bottom:0px;"">"_
			"<img id=""img"_idString_""" src=""portal/disc_up_16.gif"" "_
			"onclick=""zenPage.toggleTraceToTop('"_idString_"');""/></div>"_
			"<div id=""div"_idString_""" class=""ancestorContainer"" style=""display:none;"">"
		set key1 = ""
		set key2 = ""
		set key3 = ""
		set count = 0
		for {
			set field = ancestors.GetNext(.key1)
			quit:key1=""
			set id = aIdList.GetNext(.key2)
			quit:key2=""
			set map = aMappingList.GetNext(.key3)
			quit:key3=""
			set count = $i(count)
			set text = text _ "<a href=""#level" _ count _ "target" _ id_ """ class=""portalTitleLink"" onclick=""zenPage.highlightField('"_id_"');"">" _ field _ "</a><br/>"
			set text = text _ "&nbsp;&nbsp;^&nbsp;&nbsp;<em>" _ map _ "</em><br/>"
		}
		set text = text _ "<span onclick=""zenPage.highlightField('"_id_"');"">(" _ type _ ")&nbsp;&nbsp;" _ path _ "</span><br/></div></td>"
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

Method DrawTypeChoice(pSeed As %String) As %Status
{
	Set status = $$$OK
	Try {
		set ..typeList = ""
		Write "<table border=0 cellpadding=0 cellspacing=0><tr>"
		// get targets only
		set sql = "select Distinct %Exact FIELD.DocumentType as Type "_
			"from HS_Doc_Data.Field FIELD  "_
			"RIGHT JOIN HS_Doc_Data.Link LINK "_
			"ON LINK.TargetField=FIELD.ID"
		set statement = ##class(%SQL.Statement).%New()
		set status = statement.%Prepare(sql) quit:$$$ISERR(status)
		set result = statement.%Execute()
		while result.%Next() {
			set type = result.Type
			set connector = $s(($l(..typeList) = 0):"", 1:":")
			set ..typeList = ..typeList _ connector _ type
			Write "<td>"
			Write "<input id=""check"_type_""" type=""checkbox"" checked "_
				"documentType="""_type_""" "_
				"onclick=""zenPage.typeChecked('check"_type_"');"" "_
				"class=""checkboxTypeChoice"" />"
			Write "</td><td style=""padding-left:3px;padding-right:30px;font-size:11pt;"">"
			Write type
			Write "</td>"
		}
		Write "<td>"
		Write "<input id=""checkAll"" type=""checkbox"" checked "_
			"onclick=""zenPage.typeChecked('checkAll');"" />"
		Write "</td><td style=""padding-right:20px;"">"
		Write $$$Text("All Types")
		Write "</td>"
		Write "</tr></table>"
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

ClientMethod enterKey(event) [ Language = javascript ]
{
    var e = window.event || event;
	var key = (e.keyCode) ? e.keyCode : e.which;
	if (key == zenENTER) {
		zenPage.populateDropdown();
	}
	zenPage.emptyResults();
}

ClientMethod populateDropdown() [ Language = javascript ]
{
	var text = zen("inputText").getValue();
	text = zenPage.stripLeadingTrailingWhiteSpace(text);
	if (text.length <= 0) {
		alert($$$Text("Please enter text in Step 2."));
		zenPage.emptyDropdown();
		return;
	}
	var dropdown = zen("dropdownContainer");
	var proxy = new zenProxy();
	proxy.path = text;
	var currentList = zenPage.getCurrentTypeList();
	if (currentList == "") {
		alert($$$Text("Please choose a document type, or All, in Step 1."));
		zenPage.emptyDropdown();
		return;
	}
	else {
		proxy.typeList = currentList;
	}
	dropdown.setProperty("seed", proxy);
	zenPage.emptyResults();
}

ClientMethod emptyResults() [ Language = javascript ]
{
	var result = zen("results");
	result.setProperty("seed", "");
}

ClientMethod emptyDropdown() [ Language = javascript ]
{
	var dropdown = zen("dropdownContainer");
	dropdown.setProperty("seed", "");
}

ClientMethod getCurrentTypeList() [ Language = javascript ]
{
	var div = zen("stepByStep").getEnclosingDiv();
	if (!div) return;
	var boxes = div.getElementsByClassName("checkboxTypeChoice");
	var len = boxes.length;
	var currentList = "";
	var connector = "";
	var all = self.document.getElementById("checkAll");
	if (!all.indeterminate) return (all.checked) ? "All" : "";
	for (var i = 0; i < len; i++) {
		connector = (i == 0) ? "" : ":";
		currentList += connector;
		if (boxes[i].checked) currentList += boxes[i].id.substring(5);
	}
	return currentList;
}

ClientMethod renderResults() [ Language = javascript ]
{
	var select = self.document.getElementById("selectField");
	var value = select.options[select.selectedIndex].value;
	if (value.length <= 0) {
		zenPage.emptyResults();
		alert($$$Text("Please choose a field in Step 4."));
	}
	else if (value == "@") {
		zenPage.emptyResults();
	}
	else if (value == "*") {
		zenPage.emptyResults();
		alert($$$Text("Please try more specific text in Step 2."));
	}
	else if (value == "+") {
		zenPage.emptyResults();
		select.selectedIndex = 0;
	}
	else {
		var result = zen("results");
		result.setProperty("seed", value);
	}
}

ClientMethod typeChecked(which) [ Language = javascript ]
{
	var check = self.document.getElementById(which);
	if (!check) return;
	var all = self.document.getElementById("checkAll");
	var div = zen("stepByStep").getEnclosingDiv();
	if (!div) return;
	var boxes = div.getElementsByClassName("checkboxTypeChoice");
	var len = boxes.length;
	if (which == "checkAll") {
		var checked = check.checked;
		for (var i = 0; i < len; i++) {
			boxes[i].checked = checked;
		}
		all.indeterminate = false;
	}
	else {
		var count = 0;
		for (var i = 0; i < len; i++) {
			if (boxes[i].checked) count++;
		}
		if (count == len) {
			all.checked = true;
			all.indeterminate = false;
		}
		else {
			all.checked = false;
			all.indeterminate = true;
		}
	}
	zenPage.emptyDropdown();
	zenPage.emptyResults();
}

ClientMethod highlightField(id) [ Language = javascript ]
{
	if (zenPage._oldHighlight && (zenPage._oldHighlight.length > 0)) {
		zenPage.clearHighlight(zenPage._oldHighlight);
	}
	zenPage.setHighlight(id);
	zenPage._oldHighlight = id;
}

ClientMethod toggleHighlight(id) [ Language = javascript ]
{
	if (!id || (id.length <= 0)) return;
	if (id == zenPage._oldHighlight) {
		zenPage.clearHighlight(zenPage._oldHighlight);
		zenPage._oldHighlight = "";
		return;
	}
	zenPage.highlightField(id);
}

ClientMethod setHighlight(id) [ Language = javascript ]
{
	if (!id || (id.length <= 0)) return;
	var div = zen("stepByStep").getEnclosingDiv();
	if (!div) return;
	var tds = div.getElementsByClassName(id);
	var td;
	for (var i = 0; i < tds.length; i++) {
		td = tds[i];
		td.style.backgroundColor = "#F5EAD8";	
	}
}

ClientMethod clearHighlight(id) [ Language = javascript ]
{
	if (!id || (id.length <= 0)) return;
	var div = zen("stepByStep").getEnclosingDiv();
	if (!div) return;
	var tds = div.getElementsByClassName(id);
	var td;
	for (var i = 0; i < tds.length; i++) {
		td = tds[i];
		td.style.backgroundColor = "white";	
	}
}

/// Callback to return a list of resources required for a specific HyperEvent.
/// The user must have sufficient privileges on one of the resource/permission pairs
/// to be permitted to execute the hyperevent. An empty string implies the user already
/// has sufficient privileges for the ZenMethod specified in <var>pMethod</var>.
ClassMethod GetHyperEventResources(pMethod As %String = "") As %String
{
	Quit $case(pMethod,
				"GenerateDropdownList": ..#RESOURCE,
				"DrawResults": ..#RESOURCE,
				"DrawTypeChoice": ..#RESOURCE,
				: "")
}

ClientMethod stripLeadingTrailingWhiteSpace(text) [ Language = javascript ]
{
	return text.replace(/^\s+|\s+$/g, "").replace(/^\t+|\t+$/g, "");
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	set textArea = ..%GetComponentById("inputText")
	set textArea.title =
		$$$Text("Instead of typing, you may copy and paste in any fragment of XML.")_" "_
		$$$Text("Begin and end tags need not match, but to be found in the fragment, a field name must begin and end with < and >.")
	Quit $$$OK
}

ClientMethod toggleTraceToTop(id) [ Language = javascript ]
{
	if (!id || (id.length <= 0)) return;
	var img = self.document.getElementById("img"+id);
	if (!img) return;
	var div = self.document.getElementById("div"+id);
	if (!div) return;
	if (div.style.display == "block") {
		img.src = "portal/disc_up_16.gif";
		div.style.display = "none";
	}
	else {
		img.src = "portal/disc_down_16.gif";
		div.style.display = "block";
	}
}

}
