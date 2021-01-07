Include %ZHSLIB

Class HS.IHE.Common.Actor.Base Extends HS.HC.Util.Trace.Helper [ Abstract ]
{

Parameter IHEVersion As COSEXPRESSION = "##class(HS.Registry.Config).GetKeyValue(""\General\IHEVersion"",1)";

/// This user callback method is called when the system is being started
ClassMethod OnProductionStart(pConfigName As %String = "Unknown Actor") As %Status
{
	Set tAudit=$$$HSAuditActorStart(pConfigName)
	Quit $S(tAudit:$$$OK,1:$$$ERROR($$$GeneralError,"Unable to audit start of production, check to see that auditing is enabled."))
}

/// This user callback method is called when the system is being stopped
ClassMethod OnProductionStop(pConfigName As %String = "Unknown Actor") As %Status
{
	Set tAudit=$$$HSAuditActorStop(pConfigName)
	Quit $S(tAudit:$$$OK,1:$$$ERROR($$$GeneralError,"Unable to audit stop of production, check to see that auditing is enabled."))
}

}
