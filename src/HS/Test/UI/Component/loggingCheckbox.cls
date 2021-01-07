/// checkbox for IHE.Test/LogTransactions boolean
Class HS.Test.UI.Component.loggingCheckbox Extends (%ZEN.Component.composite, HS.Test.UI.Component.hsComponent) [ Inheritance = right ]
{

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite xmlns="http://www.intersystems.com/zen">
<checkbox label="Enable logging" id="chkLogging" title="Route traffic through tcp trace utility"/>
</composite>
}

Method InitializeLogging() As %Status [ Private ]
{
	Set ..getChildById("chkLogging").value=+$g(%session.Data("IHE.Test","LogTransactions"),0)
	Quit $$$OK
}

Method GetLogging() As %Boolean
{
	Quit ..getChildById("chkLogging").value
}

}
