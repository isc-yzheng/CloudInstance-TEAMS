Include (Ensemble, EnsUI, %occErrors)

/// Utility page that does the real work after being invoked from EnsPortal.Dialog.UpdateProduction.
/// That dialog captures and displays all output from the real work commands invoked here.
Class HS.UI.StartStopFrame Extends EnsPortal.Template.standardPage [ System = 4 ]
{

/// User needs USE permissions on the %Ens_ProductionRun or the %Ens_ConfigItemRun resource to view this page.
Parameter RESOURCE = "%All";

ClassMethod OnPage() As %Status
{
	Set tAction = $G(%request.Data("ACTION",1),"missing")
	If $IsObject($get(%session)) {
		Do %session.Unlock()
	}
	&html<<html>

<style>
pre {
	background: white;
	margin: 0px;
	padding: 4px;
	white-space: pre-wrap;
}
</style>>
	
	&html<
	<body topmargin="0" leftmargin="0">>

	//Do %response.Flush()
	//Hang 0.1

	Set tSC = $$$OK
	If (tAction '= "missing") {
		&html<<pre>>
		Set tTraceDevice=$G($$$JobTraceDevice,0), $$$JobTraceDevice=$IO
		If (tAction = "start") {
			Set tSC = ..StartProductions()
		} ElseIf (tAction = "stop"){
			Set tSC = ..StopProductions()
		}
		If 0=tTraceDevice { Kill $$$JobTraceDevice } Else { Set $$$JobTraceDevice=tTraceDevice } 
		If $$$ISERR(tSC) {
			Set Err = $$$Text("Error")
			Set tFinishedMsg = "<span style=""color:red;"">"_Err_"</span>"
		}
		&html<</pre>>
	}
	&html<</body>
	</html>>
	Quit $$$OK
}

/// Start a production
ClassMethod StartProductions() As %Status
{
	Set $ZT = "Trap"
	Set tSC = ##Class(HS.Director).StartAll()
Exit
	If $$$ISERR(tSC) {
		Write $ZCVT($$$StatusDisplayString(tSC),"O","HTML"),!
	} Else {
		Write !,$$$TextHTML("Done."),!
	}
	Quit tSC
Trap
	Set $ZT="", tSC=$$$SystemError
	Goto Exit
}

/// Stop the production
ClassMethod StopProductions() As %Status
{
	Set $ZT = "Trap", tSC = $$$OK
		Write $$$TextHTML("StoppingProduction","Stopping Production..."),!
		Do %response.Flush()
		Hang 0.1
		Set tSC = ##class(HS.Director).StopAll()
Exit
	If $$$ISERR(tSC) {
		Write $ZCVT($$$StatusDisplayString(tSC),"O","HTML"),!
	} Else {
		Write !,$$$TextHTML("Done."),!
	}
	Quit tSC
Trap
	Set $ZT="", tSC=$$$SystemError
	Goto Exit
}

ClassMethod OnPreHTTP() As %Boolean
{
	Set tResult = ##super()
	
	If %response.Redirect = "" {
		// Set the timeout for 5 minutes for a start/stop
		Set %response.Timeout = 5*60
	}
	Quit tResult
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Production update status")
}

/// Get information to display in the ribbon bar.
/// Make appropriate choices for Production Delete. 
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String) As %Status
{
	Quit $$$OK
}

}
