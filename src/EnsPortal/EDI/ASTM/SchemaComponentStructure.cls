/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsPortal.EDI.ASTM.SchemaComponentStructure Extends EnsPortal.EDI.ASTM.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "ASTM Component Structure";

/// Path
Property segPath As %String(ZENURL = "PATH");

/// Document structure
Property dStruct As %String(ZENURL = "DS");

/// Segment Structure
Property segStruct As %String(ZENURL = "SS");

/// Field
Property cField As %String(ZENURL = "FIELD");

/// Component Structure
Property cStruct As %String(ZENURL = "CS");

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
	set category=$p(..cStruct,":",2)
	set secondary=$p(..cStruct,":",3)

	If ((category'="")&&(secondary'="")) {
		if '$data($$$vaSchemaGbl(category,"CS",secondary)) {
			quit ..DrawError(..cStruct)
		}
		set description=..EscapeHTML($get($$$vaSchemaDescGbl(category,"CS",secondary)))
		If $L(..segPath) {
			set pathText = $$$Text("Path you followed to get to this component structure:")
			Set compText = $$$Text("Component Structure")
			Set fNumText = $$$Text("Field Number")
			Set fieldText = $$$Text("At Field")
			set segText = $$$Text("Of Segment Structure")
			set docText = $$$Text("Of Document Structure")
			&html<
				<div>
					<i>#(pathText)#</i>&nbsp;<b>#($zconvert(..segPath,"O","HTML"))#</b><br/>
					<i>#(fieldText)#</i>&nbsp;<b>#($zconvert(..cField,"O","HTML"))#</b><br/>
			>
			If $L(..segStruct) {
				&html<
					<i>#(segText)#</i>&nbsp;<b>#($zconvert($P(..segStruct,":",2,3),"O","HTML"))#</b><br/>
				>
			}
			If $L(..dStruct) {
				&html<
					<i>#(docText)#</i>&nbsp;<b>#($zconvert($P(..dStruct,":",2,3),"O","HTML"))#</b><br/>
				>
			}
			&html<
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
									<th>#($$$Text("Code Table"))#</th>
										<th class="altDesc">#($$$Text("Alternate Description"))#</th>
				</tr>
		>

		set struct=$$$vaSchemaGbl(category,"CS",secondary)
		kill names set name="" for { set name=$o($$$vaSchemaGbl(category,"CS",secondary,"names",name)) quit:name=""
			set names($$$vaSchemaGbl(category,"CS",secondary,"names",name))=name
		}
		for i=1:1:$LL(struct)  {
			if (i#2=0) {
				set rowClass="tpEven"
			}
			else {
				set rowClass="tpOdd"
			}
			&html<<tr class="#(rowClass)#"><td>#(i)#</td>>

			; description
			set description=..EscapeHTML($get($$$vaSchemaDescGbl(category,"CS",secondary,i)))
			&html<<td>#($s(description="":"&nbsp;",1:description))#</td>>

			; property name
			set tPropPath=$S(""=..segPath||(""=$get(names(i))):"",1:..segPath_"."_$get(names(i)))

			set label = $get(names(i),"&nbsp")
			if (..segPath="") {
				 &html<<td>#(label)#</td>>
			}
			else {
				set segmentLink = ..Link("EnsPortal.EDI.ASTM.SchemaPath.zen?PATH="_$$$URLENCODE(tPropPath)_"&CS="_$$$URLENCODE(..cStruct)_"&CSFIELD="_i_"&FIELD="_$$$URLENCODE(..cField)_"&DS="_$$$URLENCODE(..dStruct)_"&SS="_$$$URLENCODE(..segStruct))
				&html<<td><a title='#(tPropPath)#' href='#(segmentLink)#'>#(label)#</a></td>>
			}

			; code table
			set value=$g($$$vaSchemaGbl(category,"CS",secondary,"tables",i))
			&html<<td>#($s(value="":"&nbsp;",1:"<a href='"_..Link("EnsPortal.EDI.ASTM.SchemaCodeTable.zen?CT=CT:"_$$$URLENCODE(value))_"'>"_value_"</a>"))#</td>>

			; alternate description
			set altdesc=..EscapeHTML($get($$$vaSchemaDescGbl(category,"CS",secondary,i,"alt")))
			&html<<td>#($s(altdesc="":"&nbsp;",1:altdesc))#</td>>
		}
	}
	&html<</table>>
	Quit $$$OK
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("ASTM Component Structure","Ensemble")
}

}
