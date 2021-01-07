Include %ZHSLIB

IncludeGenerator %ZHSLIB

/// Extends %ZEN.DataModel.Adaptor and adds security resource checking capabilities
Class HS.Util.DataModel.Adaptor Extends %ZEN.DataModel.Adaptor
{

/// If specified, this RESOURCE:PERMISSION is checked before any operation on this class via Zen MVC. (Create, Read, Update, or Delete.)
Parameter RESOURCE As STRING [ Abstract ];

/// If specified, this RESOURCE:PERMISSION is checked before creating a new record via Zen MVC.
/// This overrides <parameter>RESOURCE</parameter>.
Parameter CREATERESOURCE As STRING [ Abstract ];

/// If specified, this RESOURCE:PERMISSION is checked before returning loaded data to the client via Zen MVC.
/// This overrides <parameter>RESOURCE</parameter>.
Parameter READRESOURCE As STRING [ Abstract ];

/// If specified, this RESOURCE:PERMISSION is checked before updating an existing record. via Zen MVC
/// This overrides <parameter>RESOURCE</parameter>.
Parameter UPDATERESOURCE As STRING [ Abstract ];

/// If specified, this RESOURCE:PERMISSION is checked before deleting a record via Zen MVC.
/// This overrides <parameter>RESOURCE</parameter>.
Parameter DELETERESOURCE As STRING [ Abstract ];

/// Create an instance of this DataModel object.<br>
/// Subclasses may override this for special behavior.
ClassMethod %CreateModelInstance(pID As %String, pConcurrency As %Integer = -1, Output pSC As %Status = {$$$OK}) As %RegisteredObject [ CodeMode = objectgenerator, ForceGenerate ]
{
	Set tType = $$$getClassType(%compiledclass.Name)
	If (tType = $$$cCLASSCLASSTYPEPERSISTENT) {
		Do %code.WriteLine("	Set tInstance = $Case(pID,"""":..%New(),:..%OpenId(pID,pConcurrency,.pSC))")
		// Check permission for READ - this could be used to open an object.
		// CREATE is enforced in %OnSaveSource.
		Do %code.WriteLine("	Set tSC = ..CheckPermission(""R"",pID,tInstance)")
		Do %code.WriteLine("	If $$$ISERR(tSC) {")
		Do %code.WriteLine("		Set pSC = tSC")
		Do %code.WriteLine("		Quit $$$NULLOREF")
		Do %code.WriteLine("	}")
		Do %code.WriteLine("	Quit tInstance")
	} Else {
		Do %code.WriteLine("	Quit ..%New()")
	}
	Quit $$$OK
}

/// This callback method is invoked when a DataModel is opened.
/// If implemented, it opens an instance of the data source object
/// used by the DataModel.
Method %OnOpenSource(pID As %String, pConcurrency As %Integer = -1, Output pSC As %Status = {$$$OK}) As %RegisteredObject
{
	Set tSC = ..CheckPermission("R",pID,$This)
	If $$$ISERR(tSC) {
		Set pSC = tSC
		Quit $$$NULLOREF
	}
	Quit $This
}

/// This callback method is called when the DataModel is deleted.
ClassMethod %OnDeleteSource(pID As %String) As %Status [ CodeMode = objectgenerator, ForceGenerate ]
{
	Set tType = $$$getClassType(%compiledclass.Name)
	If (tType = $$$cCLASSCLASSTYPEPERSISTENT) {
		Do %code.WriteLine("	Set tSC = ..CheckPermission(""D"",pID,$$$NULLOREF)")
		Do %code.WriteLine("	If $$$ISERR(tSC) {")
		Do %code.WriteLine("		Quit tSC")
		Do %code.WriteLine("	}")
		Do %code.WriteLine("	Quit ..%DeleteId(pID)")
	} Else {
		Do %code.WriteLine("	Quit $$$OK")
	}
	Quit $$$OK
}

/// This callback method is called when the DataModel is saved. If
/// implemented, it is responsible for saving changes to the data source.
Method %OnSaveSource(pSource As %RegisteredObject) As %Status [ CodeMode = objectgenerator, ForceGenerate ]
{
	Set tType = $$$getClassType(%compiledclass.Name)
	If (tType = $$$cCLASSCLASSTYPEPERSISTENT) {
		Do %code.WriteLine("	Set tSC = ..CheckPermission($Case(..%Id(),"""":""C"",:""U""),..%Id(),$This)")
		Do %code.WriteLine("	If $$$ISERR(tSC) {")
		Do %code.WriteLine("		Quit tSC")
		Do %code.WriteLine("	}")
		Do %code.WriteLine("	Set tSC = ..%Save()")
		Do %code.WriteLine("	If $$$ISOK(tSC) {")
		Do %code.WriteLine("		Set ..%id = ..%Id()")
		Do %code.WriteLine("	}")
		Do %code.WriteLine("	Quit tSC")
	} Else {
		Do %code.WriteLine("	Quit $$$OK")
	}
	Quit $$$OK
}

/// Checks permissions (parameter-based) on a particular operation + object. <br />
/// <var>pOperation</var> is "C" (create), "R" (read), "U" (update), or "D" (delete) <br />
/// <var>pID</var> is the ID of the object being operated on (empty for new objects) <br />
/// <var>pObject</var> is the object being operated on (for create/read/update; empty for delete) <br />
/// Returns <code>$$$ERROR($$$AccessDenied)</code> if the user does not have the requisite permission.
ClassMethod CheckPermission(pOperation As %String, pID As %Integer, pObject As %RegisteredObject) As %Status [ CodeMode = objectgenerator, ForceGenerate ]
{
	Set tAllResource = %parameter("RESOURCE")
	For tOperation = "C","R","U","D" {
		Set tParam = $Case(tOperation,
			"C":"CREATE",
			"R":"READ",
			"U":"UPDATE",
			"D":"DELETE")_"RESOURCE"
		Set tOperationResource = %parameter(tParam)
		If (tOperationResource '= "") {
			Set tResource(tOperation) = tOperationResource
		} ElseIf (tAllResource '= "") {
			Set tResource(tOperation) = tAllResource
		}
	}
	Do %code.WriteLine("	Set tSC = ..OnCheckPermission(.tHandled, pOperation, pID, pObject)")
	Do %code.WriteLine("	If tHandled || $$$ISERR(tSC) { // Intentional no-op")
	Set tOperation = ""
	For {
		Set tOperation = $Order(tResource(tOperation),1,tResourceAndPermission)
		If (tOperation = "") {
			Quit
		}
		Set tResource = $Piece(tResourceAndPermission,":")
		Set tPermission = $Piece(tResourceAndPermission,":",2)
		If (tPermission = "") {
			Set tPermission = "USE"
		}
		Do %code.WriteLine("	} ElseIf (pOperation = "_$$$QUOTE(tOperation)_") {")
		Do %code.WriteLine("		If '$System.Security.Check("_$$$QUOTE(tResource)_","_$$$QUOTE(tPermission)_") { ")
		Do %code.WriteLine("			Set tSC = $$$ERROR($$$AccessToResourceDenied,"_$$$QUOTE(tResourceAndPermission)_")")
		Do %code.WriteLine("		}")
	}
	Do %code.WriteLine("	}")
	Do %code.WriteLine("	Quit tSC")
}

/// Checks permissions (parameter-based) on a particular operation + object. <br />
/// If <var>pHandled</var> is set to true, <method>CheckPermission</method> will be bypassed. <br />
/// <var>pOperation</var> is "C" (create), "R" (read), "U" (update), or "D" (delete) <br />
/// <var>pID</var> is the ID of the object being operated on (empty for new objects) <br />
/// <var>pObject</var> is the object being operated on (for create/read/update; empty for delete) <br />
/// Returns <code>$$$ERROR($$$AccessDenied)</code> if the user does not have the requisite permission.
ClassMethod OnCheckPermission(Output pHandled As %Boolean = 0, pOperation As %String, pID As %Integer, pObject As %RegisteredObject) As %Status
{
	Quit $$$OK
}

}
