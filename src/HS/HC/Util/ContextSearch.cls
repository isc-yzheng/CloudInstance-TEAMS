Class HS.HC.Util.ContextSearch Extends Ens.ContextSearch
{

/// SubclassOf overrides Ens.ContextSearch SubclassOf to get the sub classes and the
/// specified super class. Neither SubclassOf() nor Classes() from Ens.ContextSearch
/// will return the super class.
ClassMethod SubclassOf(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tSC = ##super(.pCaption, .pTopResults, .pResults, .pParms, .pSearchKey)
	
	If $$$ISOK(tSC) {
		Set tN = ""
		For {
			Set tN = $Order(pResults(tN), -1)
			If tN="" Quit
			Set pResults(tN+1) = pResults(tN)
			Kill pResults(tN)
		}
		Set pResults(1) = $G(pParms("class"))
	}
	
	Quit tSC
}

}
