Class HS.Test.UI.History Extends HS.Test.UI.Main
{

/// Displayed name of this page.
Parameter PAGENAME = "Test Tool History";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textReadOnly {
	border: 1px inset threedface;
	color:#777777;
	background: #EEEEEE;
}
</style>
}

/// This XML block defines the contents of the ICE IHE test workflow pane.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page title="HealthShare IHE Testing Utility" xmlns="http://www.intersystems.com/zen" xmlns:ihetest="http://www.intersystems.com/ihetest">
<pane xmlns="http://www.intersystems.com/zen">
<spacer height="5" />

<vgroup>
<tableNavigatorBar tablePaneId="table" showPageSize="true"/>
<tablePane id="table"
sql="SELECT ID,ClassName, Name, RunTime from HS_Test_UI.TestGroup order by ID DESC"
caption="History items:"
fixedHeaders="false"

maxRows="1000"
showZebra="true"
valueColumn="ID"
onselectrow="zenPage.LoadPage(zenThis.getValue());"
useSnapshot="true"
pageSize="35"
>
<column colName="ID"/>
<column colName="ClassName"/>
<column colName="Name" />
<column colName="RunTime"/>
</tablePane>

</vgroup>

</pane>
</page>
}

Method LoadPage(pID) [ ZenMethod ]
{
	Set obj=##class(HS.Test.UI.TestGroup).%OpenId(pID)
	Quit:'$IsObject(obj)
	&js< this.location='#(obj.ClassName)#.cls?TestGroupID=#(pID)#'>
	//&js< parent.jsShowItem('#(obj.ClassName)#.cls?TestGroupID=#(pID)#','History - #(obj.ClassName)#');>
	Quit
}

}
