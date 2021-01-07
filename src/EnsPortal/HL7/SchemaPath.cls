/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsPortal.HL7.SchemaPath Extends EnsPortal.HL7.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7 Schema Path";

Property segPath As %String(MAXLEN = "", ZENURL = "PATH");

Property docStruct As %String(MAXLEN = "", ZENURL = "MS");

Property segStruct As %String(MAXLEN = "", ZENURL = "SS");

Property segField As %String(MAXLEN = "", ZENURL = "FIELD");

Property dStruct As %String(MAXLEN = "", ZENURL = "DS");

Property dStructField As %String(MAXLEN = "", ZENURL = "DSFIELD");

Property dStruct1 As %String(MAXLEN = "", ZENURL = "DS1");

Property dStruct1Field As %String(MAXLEN = "", ZENURL = "DS1FIELD");

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
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
	set category = $p(..docStruct,":",2)
	set structname = $p(..docStruct,":",3)

	if ((category'="")&&(structname'="")) {
		if '$data($$$vaSchemaGbl(category,"MS",structname)) {
			quit ..DrawError(..docStruct)
		}
		set description=..EscapeHTML(##class(EnsLib.HL7.Schema).GetDescription(..docStruct))
	}

	set category = $p(..segStruct,":",2)
	set structname = $p(..segStruct,":",3)

	if ((category'="")&&(structname'="")) {
		if ('$data($$$vaSchemaGbl(category,"SS",structname)))  {
			quit ..DrawError(..segStruct)
		}
	}

	set category = $p(..dStruct,":",2)
	set structname = $p(..dStruct,":",3)

	if ((category'="")&&(structname'="")) {
		if (('$data($$$vaSchemaGbl(category,"DT",structname))) && ('$data($$$vaSchemaGbl(category,"DS",structname))) )  {
			quit ..DrawError(..dStruct)
		}
	}

	set category = $p(..dStruct1,":",2)
	set structname = $p(..dStruct1,":",3)

	if ((category'="")&&(structname'="")) {
		if (('$data($$$vaSchemaGbl(category,"DT",structname))) && ('$data($$$vaSchemaGbl(category,"DS",structname))) )  {
			quit ..DrawError(..dStruct1)
		}
	}

	set pathText = $$$Text("Path you followed to get to this field:")
	set ds1Text = $$$Text("of Data Sub-Structure")
	set dsText = $$$Text("of Data Structure")
	set fieldText = $$$Text("at Field")
 	set segText = $$$Text("of Segment Structure")
	set docText = $$$Text("of Message Structure")
	if $L(..segPath) {
		&html<<div>
			<p><i>#(pathText)#</i>&nbsp;<b>#($zconvert(..segPath,"O","HTML"))#</b></p>
		>
		If $L(..dStruct1) {
			&html<
				<i>#(fieldText)#</i>&nbsp;<b>#($zconvert(..dStruct1Field,"O","HTML"))#</b><br/>
				<i>#(ds1Text)#</i>&nbsp;<b>#($zconvert($P(..dStruct1,":",2,3),"O","HTML"))#</b><br/>
			>
		}
		If $L(..dStruct) {
			&html<
				<i>#(fieldText)#</i>&nbsp;<b>#($zconvert(..dStructField,"O","HTML"))#</b><br/>
				<i>#(dsText)#</i>&nbsp;<b>#($zconvert($P(..dStruct,":",2,3),"O","HTML"))#</b><br/>
			>
		}
		If $L(..segStruct) {
			&html<
				<i>#(fieldText)#</i>&nbsp;<b>#($zconvert(..segField,"O","HTML"))#</b><br/>
				<i>#(segText)#</i>&nbsp;<b>#($zconvert($P(..segStruct,":",2,3),"O","HTML"))#</b><br/>
			>
		}
		If $L(..docStruct) {
			&html<
				<i>#(docText)#</i>&nbsp;<b>#($zconvert($P(..docStruct,":",2,3),"O","HTML"))#</b><br/>
			>
		}
		&html<
			</div>
		>
	}

	&html<<br/>>
	Quit $$$OK
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("HL7 Schema Path")
}

}
