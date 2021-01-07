/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsPortal.EDI.ASTM.SchemaDocumentStructure Extends EnsPortal.EDI.ASTM.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "ASTM Document Structure";

Property docStruct As %String(MAXLEN = "", ZENURL = "DS");

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<hgroup valign="top">
<spacer width="20"/>
<vgroup valign="top">
<html id="content" OnDrawContent="DrawContent"/>
</vgroup>
<spacer width="20"/>
</hgroup>
</pane>
}

/// Draw main HTML content for this page.
Method DrawContent(pSeed As %String) As %Status
{
	Set category=$P(..docStruct,":",2)
	Set structname=$P(..docStruct,":",3)
	If ((category'="")&&(structname'="")) {
		Quit:'$D($$$vaSchemaGbl(category,"DS",structname)) ..DrawError(..docStruct)
		Set description=..EscapeHTML(##class(EnsLib.EDI.ASTM.Schema).GetDescription(..docStruct))
	} Else {
		Set description=$$$TextHTML("Category and structure name missing. Unable to display definition.")
	}
	Set tCat=$$$Text("Schema Category:")
	Set tDS=$$$Text("Message Structure:")
	Set catLink = ..Link("EnsPortal.EDI.ASTM.SchemaMain.zen?CAT="_$$$URLENCODE(category))

	&html<
		<div>
		<p>
		<I>#(tCat)# </I><b><a href="#(catLink)#">#($zconvert(category,"O","HTML"))#</a></b><br/>
		<I>#(tDS)# </I><b>#($zconvert(structname,"O","HTML"))#</b>
		</p>
		<p>#($zconvert(category_":"_structname,"O","HTML"))# #(description)#</p>
		</div>
	>
	Quit:((category="")||(structname="")) $$$OK

	&html<<div><hr/><table><tr>>

	#; Draw segments table
	&html<<td><table cellpadding=2 cellspacing=2><tbody align=center><tr>>
	New %iSeg,%hadUnion,%hadLoop  Set (%iSeg,%hadUnion,%hadLoop)=0
	Do ..drawArray(category,$Name($$$vaSchemaGbl(category,"DS",structname,"array")),"")
	&html<</table></td>>

	#; Draw legend
	Set tOpt = $$$Text("optional")
	Set tRep = $$$Text("repeating")
	Set tKey = $$$Text("Key")
	&html<<td valign='top'><div style="padding-left:50px;"><b>#(tKey)#</b><table cellpadding=4 cellspacing=2>>
	If %hadLoop {
		Set tLoop= $$$Text("loop")
		&html<<tr><td style="border: 2px solid #ead960; border-right: none;" cellpadding=2 cellspacing=2>#(tLoop)#</td></tr>>
	}
	&html<<tr><td style="border: 2px dotted #3b9c3d; border-right: none;" cellpadding=2 cellspacing=2>#(tOpt)#</td></tr>>
	&html<<tr><td style="border: 2px solid #703838; border-right: none;" cellpadding=2 cellspacing=2>#(tRep)#</td></tr>>

	If %hadUnion {
		Set tUnion = $$$Text("choice")
		&html<<tr><td style="border: 2px dotted #ead960; border-right: none;" cellpadding=2 cellspacing=2>#(tUnion)#</td></tr>>
	}
	&html<</table></div>>

	#; Draw links
	&html<<div class="footlinks">
	<span><img src="images/spacer.gif" width="30" height="2"><img src="images/disclosure-contracted.gif" alt="*" width="8" height="11" border="0">
	<span onclick="zenPage.showRaw();"><a href="#" onclick="return false;">#($$$TextHTML("Show Raw Definition Text"))#</a></span></span><br/>
	</div>>

	#; Draw raw content
	Set tRaw = $$$Text("Raw Definition")
	Set struct=$$$vaSchemaGbl(category,"DS",structname)
	&html<<div id="rawContent" style="padding:20px 0px 0px 50px;display:none;">
	<b>#(tRaw)#</b>
	<table cellspacing="0" cellpadding="2">
	<tr><td>#(struct)#</td></tr>
	</table>
	</div></td>
	</tr></table><hr/><br/></div>>
	Quit $$$OK
}

Method drawArray(category, gname, path) [ Internal ]
{
	For ch=1:1:@gname {
		Set chName=@gname@(ch,"name"), chPath=$E(path_"."_chName,2,*), chName=$P(chName,"(")
		Set tOpt=$G(@gname@(ch,"opt"))
		Set tRep=($E(chPath,*)=")")
		Set tUnion=("union"=$E(chName,*+1-$L("union"),*))  Set:tUnion %hadUnion=1
		Set chLoop=$S($G(@gname@(ch)):chName,1:"")
		If tOpt {
			Set tBorder="2px dotted #60a060"  // green: similar to the box containing system name in title bar
			Write "<tr>"_$S(""=chLoop:"",1:"<td align='right' valign='top' style='font-style:italic;'>"_chLoop_"</td>")_"<td align='left' valign='top'><table cellpadding=2 cellspacing=2 align='left' style='border: "_tBorder_"; border-right: none;'><tr>",!
			Set chLoop=""
		}
		If tRep {
			Set tBorder="2px solid  #703838"  // red: similar to the highlight for icons in ribbon bar
			Write "<tr>"_$S(""=chLoop:"",1:"<td align='right' valign='top' style='font-style:italic;'>"_chLoop_"</td>")_"<td align='left' valign='top'><table cellpadding=2 cellspacing=2 align='left' style='border: "_tBorder_"; border-right: none;'><tr>",!
			Set chLoop=""
		}
		If $G(@gname@(ch)) {
			#; Group/loop/union
			If (""'=chLoop&&'tOpt&&'tRep)||tUnion {
				Set:'tUnion %hadLoop=1
				Set tBorder=$S(tUnion:"2px dotted #ead960;", 1:"2px solid  #ead960") // orange: similar to highlight used in tablePane rows when selected
				Write "<tr>"_$S(""=chLoop:"",1:"<td align='right' valign='top' style='font-style:italic;'>"_chLoop_"</td>")_"<td align='left' valign='top'><table cellpadding=2 cellspacing=2 align='left' style='border: "_tBorder_"; border-right: none;'><tr>",!
			}
			Do ..drawArray(category,$Name(@gname@(ch)),"."_chPath)
			
			If (""'=chLoop&&'tOpt&&'tRep)||tUnion {
				Write "</tr></table></td></tr>",!
			}
		} Else {
			#; ordinary segment
			Set %iSeg=%iSeg+1, chType=$P(@gname@(ch,"type"),"(")
			If "DocsRef"=$E(chName,$L(chName)-$L("DocsRef")+1,$L(chName)) {
				Set link = ..Link($S("Message"=$E(chName,1,*-$L("DocsRef")):"EnsPortal.EDI.ASTM.SchemaMain.zen?CAT="_$$$URLENCODE($S($Case($P(chType,":",2),".":1,"base":1,:0):$G($$$vaSchemaGbl(category,"base"),category),1:$P(chType,":",2))),
									  1:"EnsPortal.EDI.ASTM.SchemaDocumentStructure.zen?DS=DS:"_$$$URLENCODE($P(chType,":",2)_":"_$E(chName,1,*-$L("DocsRef")))))
				Set tooltip = %iSeg_":"_$$$FormatText($$$Text("Zero or more &#39;%1&#39; documents appear here"),$E(chName,1,*-$L("DocsRef")))
			} Else {
				$$$ASSERTNOLOG("SS"=$P(chType,":"))
				Set tDesc=..EscapeHTML(##class(EnsLib.EDI.ASTM.Schema).GetDescription(chType))
				Set tooltip = %iSeg_":"_$S(""'=chPath:chPath, 1:chName)_$S(""=tDesc:"",1:" - "_tDesc)
				Set link = ..Link("EnsPortal.EDI.ASTM.SchemaSegmentStructure.zen?SS="_$$$URLENCODE(chType)_"&PATH="_$S(""=chPath:"",1:$$$URLENCODE(chPath))_"&DS="_$$$URLENCODE(..docStruct))
			}
			&html<<tr><td align='left' style='padding:0px 4px 0px 4px;'><a title='#(tooltip)#' href='#(link)#'>#(chName)#</a></td></tr>>
		}
		Write:tRep "</tr></table></td></tr>",!
		Write:tOpt "</tr></table></td></tr>",!
	}
	Quit
}

/// What to do when the user asks to view the raw definition.
ClientMethod showRaw() [ Language = javascript ]
{
	var rawdiv = document.getElementById('rawContent');
	if (rawdiv.style.display == 'block') {
		rawdiv.style.display = 'none';
	}
	else {
		rawdiv.style.display = 'block';
	}
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Set category=$P(..docStruct,":",2)
	Set structname=$P(..docStruct,":",3)
	If ((category'="")&&(structname'="")&&$D($$$vaSchemaGbl(category,"DS",structname))) {
		Set description=..EscapeHTML(##class(EnsLib.EDI.ASTM.Schema).GetDescription(..docStruct))
		Quit category_":"_structname_" - "_$S($L(description)>40:$E(description,1,40-3)_"...",1:description)
	}
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("ASTM Document Structure")
}

}
