Class HS.UI.HL7 Extends HS.UI.Base
{

/// Displayed name of this page.
Parameter PAGENAME = "HL7";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<html id="title" OnDrawContent="DrawTitle" seed="HL7 Annotations"/>

<iframe id="iframe" src="" width="100%" height="500"/>

</page>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = $$$OK
	try {
		Set ..%GetComponentById("iframe").src = ..Link("HS.HL7.Annotation.Browse.cls")
	}
	catch(ex) {
		#dim ex As %Exception.AbstractException
		Set tSC = ex.AsStatus()
	}	

	Quit $$$OK
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
     // adjust size of iframe
	var iframe = zenPage.getComponentById('iframe');
	zenASSERT(iframe,'Unable to find iframe',arguments);

    // find divs for title
    var title = zenPage.getComponentById('title');
    var divTitle = title.getEnclosingDiv();

    // find height of window
    var winHeight = zenGetWindowHeight();

    // adjust height of iframe (width is 100% so it won't need readjust)
    var sz = winHeight - (parseInt(divTitle.offsetHeight)) - 25;
    iframe.setProperty("height",sz);
}

Method DrawTitle(pTitle As %String) As %Status
{
	Set tSC = %application.DrawHSTitle(pTitle,"Annotations")
	Quit $$$OK
}

}
