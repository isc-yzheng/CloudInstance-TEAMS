Include HS.HC

Class HS.IHE.ATNA.Repository.MoveRepository [ Abstract ]
{

ClassMethod DoMove()
{
	Set $namespace="HSLIB"
	If (","_$Roles_",")'[",%All," Write !,"Insufficient privileges" quit
	If $$$IsAuditInstance(tDB) W !,"Audit Database already on this instance" quit
	W !,"Before starting, make sure you are prepared to do a backup of the audit"
	W !," database, and to mount it on this instance,"
	W !," and then to mount that backup on this instance."
	W !!,"First, use the installer wizard to create an edge gateway namespace that is"
	W !,"not an audit production.  Use any template.  Activate and Start the production."
	W !,"After the production starts . . ."
NS	R !!,"Enter New Audit Production Namespace: ",tNamespace Quit:tNamespace=""
	Set tNamespace=$zcvt(tNamespace,"U")
	IF '..CheckNamespace(tNamespace) W !,"Invalid Namespace" GOTO NS
	W !!,"This will move the audit production into that namespace,",!," and move the audit data into the HSAUDIT database"
	R !,"Are You Sure you want to do this? N // ",R
	Quit:$E($zcvt(R,"U"))'="Y"
	// This call to the registry will first validate that the audit repository is on the registry instance, and then
	// will unmark it - save the registry config item as not the audit production, kill the nodes
	// in ^%SYS("HealthShare") for the audit DB & NS.  It will then stop and delete the DeepSee task,
	// and remove the audit consolidation service from the production.
	// It will set the configuration registry keys of \AuditAggregationSuspended and \AuditAggregationMoveTransition,
	// and delete the service registry entry for the audit production.  It will then return and OK status,
	// along with the counter nodes from ^HS.IHE.Audit
	W !!,"Stopping audit aggregation . . ."
	Set $namespace="HSSYS"
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Audit.WebServices","HS.Audit.WebServicesClient","InitiateMove",.tSC2,tNamespace)
	If $$$ISERR(tSC) d $SYSTEM.Status.DisplayError(tSC) Quit
	If $$$ISERR(tSC2) d $SYSTEM.Status.DisplayError(tSC2) Quit
	// Wait for audit alert queue to clear
	For i=1:1 {
		Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Audit.WebServices","HS.Audit.WebServicesClient","ConfirmAuditAlertQueueClear",.tResponse)
		If $$$ISOK(tSC) Set tSC=tResponse.Status
		If $$$ISERR(tSC) {
			Do $SYSTEM.Status.DisplayError(tSC)
			Return
		}
		If (tResponse.AlertQueueEmpty) {
			Quit
		}
		Hang 10
	}
	If $$$ISOK(tSC) Set tSC=tResponse.Status
	If $$$ISERR(tSC) d $SYSTEM.Status.DisplayError(tSC) Quit
	W !,"Please start the backup now."
	W !!,"waiting for audit suspension to propagate . . . "
	//Wait for the audit suspension to propagate
	For i=1:1 {
		Quit:##class(HS.Registry.Config).GetKeyValue("\AuditAggregationSuspended")
		Hang 1
	}
	Set $namespace="HSLIB"
	Hang 30 // allow time for other gateways to get the message
	//Now, make this namespace an audit production
	W !,"Setting up audit production"
	Set tEdge=##class(HS.Util.Installer.EdgeGateway).%OpenId(tNamespace)
	Set tEdge.AuditProduction=1
	Do tEdge.%Save()
	Set tSC=##class(HS.Util.Installer.EdgeGateway).Install(tNamespace)
	If $$$ISERR(tSC) d $SYSTEM.Status.DisplayError(tSC) Quit
	//Set the counter nodes
	Set $namespace="HSSYS"
	For tI=1:1:tResponse.Nodes.Count() {
		Set tNode=tResponse.Nodes.GetAt(tI)
		Set ^HS.IHE.Audit(tNode.Subscript)=tNode.Value
	}
	//start the production
	Set tSC=##class(HS.Director).Start(tNamespace,1)
	If $$$ISERR(tSC) d $SYSTEM.Status.DisplayError(tSC) Quit
	// Now unsuspend, but leave the "in progress" flag set
	Set tConfig=##class(HS.Hub.HSWS.WebServices.Containers.Configuration).%New()
	Set tConfig.RegKey="\AuditAggregationSuspended", tConfig.RegValue=0
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","AddEditConfiguration",.tSC2,tConfig)
	Set:$$$ISOK(tSC) tSC=tSC2
	If $$$ISERR(tSC) d $SYSTEM.Status.DisplayError(tSC) Quit
	W !!,"Now mount the backup of the audit database"
Dir	R !,"Please enter the directory path to that database: ",tDir If tDir="" GOTO Dir
	Set tMount="^^"_tDir
	Try {
		Set tGot=$D(^|tMount|HS.IHE.Audit)
	} Catch(ex) {
		set tSC = ex.AsStatus()
		d $SYSTEM.Status.DisplayError(tSC)
		GOTO Dir
	}
	If 'tGot W !,"Audit global is not on that database" GOTO Dir
	W !,"Copying . . ."
	Set tElapsed=..LazyCopy(tMount,10)
	W !,"Copy Complete.  You may dismount the backup database."
	W !!,"This does not delete ^HS.IHE.Audit from the registry - you may"
	W !,"delete this any time later."
	// Now clear the "in progress" flag set
	Set tConfig=##class(HS.Hub.HSWS.WebServices.Containers.Configuration).%New()
	Set tConfig.RegKey="\AuditAggregationMoveTransition", tConfig.RegValue=0
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","AddEditConfiguration",.tSC2,tConfig)
	Set:$$$ISOK(tSC) tSC=tSC2
	If $$$ISERR(tSC) d $SYSTEM.Status.DisplayError(tSC) Quit
	Set tSC= ##class(HS.Util.Installer.EdgeGateway).SetupSampleDeepSee(tNamespace)
	Quit
}

ClassMethod LazyCopy(pMount, pDisplayUpdate = 60) As %String
{
	W !,"Copying . . ."
	Set tFirstH=$ZH,tLastH="",tNode="^|pMount|HS.IHE.Audit("""")"
	For {
		Set tNode=$Q(@tNode,1,tData) Quit:tNode=""
		Continue:$QL(tNode)=1  //skip counter node
		If $ZH-tLastH>pDisplayUpdate w !,tNode Set tLastH=$ZH
		Set @("^"_$P(tNode,"|",3,99))=tData
	}
	Set tElapsed=$ZH-tFirstH
	Quit tElapsed
}

ClassMethod CheckNamespace(ByRef pNamespace) As %Boolean
{
	Set pNamespace=$zcvt(pNamespace,"U")
	Quit:'##class(HS.UI.Installer.Config).validateName(pNamespace) 0
	Set tInstance=##class(HS.Util.Installer.ConfigItem).%OpenId(pNamespace)
	Quit:'$IsObject(tInstance) 0
	Quit:tInstance.Type'="EdgeGateway" 0
	Quit 1
}

}
