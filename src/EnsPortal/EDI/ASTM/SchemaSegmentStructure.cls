/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsPortal.EDI.ASTM.SchemaSegmentStructure Extends EnsPortal.EDI.ASTM.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "ASTM Segment Structure";

Property segStruct As %String(MAXLEN = "", ZENURL = "SS");

Property dStruct As %String(MAXLEN = "", ZENURL = "DS");

Property segPath As %String(MAXLEN = "", ZENURL = "PATH");

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<spacer height="20"/>
<hgroup valign="top">
<spacer width="20"/>
<html id="content" OnDrawContent="DrawContent"/>
<spacer width="20"/>
</hgroup>
</pane>
}

/// Draw main HTML content for this page.
Method DrawContent(pSeed As %String) As %Status
{
	set category=$p(..segStruct,":",2)
	set secondary=$p(..segStruct,":",3)

	If ((category'="")&&(secondary'="")) {
		if '$data($$$vaSchemaDescGbl(category,"SS",secondary)) {
			quit ..DrawError(..segStruct)
		}
		set description=..EscapeHTML($get($$$vaSchemaDescGbl(category,"SS",secondary)))
		If $L(..segPath) {
			set pathText = $$$Text("Path you followed to get to this segment structure:")
			&html<
				<div>
					<i>#(pathText)#</i>&nbsp;<b>#($zconvert(..segPath,"O","HTML"))#</b><br/>
					<br/>
					#($zconvert(category_":"_secondary,"O","HTML"))# #($G(description))#
				</div>
				<p/>
			>
		}
		Else {
			&html<
				<div>
					#($zconvert(category_":"_secondary,"O","HTML"))# #($G(description))#
				</div>
				<p/>
			>
		}
		&html<
 			<table class="tpTable" cellpadding=4 cellspacing=2>
				<tr class="headers"><th>#($$$Text("Field"))#</th>
									<th>#($$$Text("Description"))#</th>
									<th>#($$$Text("Property Name"))#</th>
									<th>#($$$Text("Component Structure"))#</th>
									<th>#($$$Text("Symbol"))#</th>
									<th>#($$$Text("Repeat Count"))#</th>
									<th>#($$$Text("Length"))#</th>
									<th>#($$$Text("Required"))#</th>
									<th>#($$$Text("Repeating"))#</th>
									<th>#($$$Text("Code Table"))#</th>
									<th class="altDesc">#($$$Text("Alternate Description"))#</th>
				</tr>
		>

		set struct=$$$vaSchemaGbl(category,"SS",secondary)
		kill names set name="" for { set name=$o($$$vaSchemaGbl(category,"SS",secondary,"names",name)) quit:name=""
			set names($$$vaSchemaGbl(category,"SS",secondary,"names",name))=name
		}
		for i=1:1:$LL(struct) {
			if (i#2=0) {
				set rowClass="tpEven"
			}
			else {
				set rowClass="tpOdd"
			}
			set one=$li(struct,i)
			&html<<tr class="#(rowClass)#"><td>#(i)#</td>>

			; description
			set description=..EscapeHTML($get($$$vaSchemaDescGbl(category,"SS",secondary,i)))
			&html<<td>#($s(description="":"&nbsp;",1:description))#</td>>

			; property name
			set tPropPath=$S(""=$get(names(i)):"",1:..segPath_":"_$get(names(i)))_$S($li(one,6):"()",1:"")

			set label = $get(names(i),"&nbsp")
			if (..segPath="") {
				&html<<td>#(label)#</td>>
			}
			else {
				set segmentLink = ..Link("EnsPortal.EDI.ASTM.SchemaPath.zen?PATH="_$$$URLENCODE(tPropPath)_"&FIELD="_i_"&DS="_$$$URLENCODE(..dStruct)_"&SS="_$$$URLENCODE(..segStruct))
				&html<<td><a title='#(tPropPath)#' href='#(segmentLink)#'>#(label)#</a></td>>
			}

			; Component Structure 
			set value=$li(one,1) 
			if (value="") {
				&html<<td>&nbsp;</td>>
			}
			else {
				set valueLink = ..Link("EnsPortal.EDI.ASTM.SchemaComponentStructure.zen?CS=CS:"_$$$URLENCODE(value)_"&PATH="_$$$URLENCODE(tPropPath)_"&FIELD="_i_"&DS="_$$$URLENCODE(..dStruct)_"&SS="_$$$URLENCODE(..segStruct))
				&html<<td><a href='#(valueLink)#'>#(value)#</a></td>>
			}

			; symbol column
			set value=$li(one,2)
			if (value ="") {
				&html<<td>&nbsp;</td>>
			}
			else {
				set annotate=$case(value,"*":"zero or more", "+":"one or more", "!":"exactly one&nbsp;required", "?":"conditional", "&":"conditional", :"")
				set label = $s(value="":"&nbsp;",1:value_$s(annotate="":"",1:" ("_annotate_")"))
				&html<<td>#(label)#</td>>
			}

			; repeat count column
			set value=$li(one,3) &html<<td>#($s(value="":"&nbsp;",1:value))#</td>>

			; length
			set value=$li(one,4) &html<<td class="lengthCol">#($s(value="":"&nbsp;",1:value))#</td>>

			; required
			set value=$li(one,5) &html<<td class="requiredCol">#($s(value="":"&nbsp;",1:value))#</td>>

			; if repeating
			set value=$li(one,6) &html<<td class="repeatCol">#($s(value="":"&nbsp;",1:value))#</td>>

			; code table
			set value=$g($$$vaSchemaGbl(category,"SS",secondary,"tables",i))
			if (value ="") {
				&html<<td>&nbsp;</td>>
			}
			else {
				set valueLink = ..Link("EnsPortal.EDI.ASTM.SchemaCodeTable.zen?CT=CT:"_$$$URLENCODE(value))
				&html<<td><a href='#(valueLink)#'>#(value)#</a></td>>
			}

			; alternate description
			set altdesc=..EscapeHTML($get($$$vaSchemaDescGbl(category,"SS",secondary,i,"alt")))
			&html<<td>#($s(altdesc="":"&nbsp;",1:altdesc))#</td>>
		}
	}
	&html<</table>>
	Quit $$$OK
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("ASTM Segment Structure","Ensemble")
}

}
