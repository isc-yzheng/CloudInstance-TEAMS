Include Ensemble

Class HS.IHE.ATNA.Repository.Exclusion Extends (%Persistent, HS.Sync.BaseClass) [ Inheritance = right ]
{

Property EventType As %String(MAXLEN = "");

Index Event On EventType [ IdKey, PrimaryKey, Unique ];

Query ListExcludedEvents() As %SQLQuery
{
SELECT EventType FROM Exclusion
 ORDER BY Upper(EventType)
}

ClassMethod PurgeExcludedEvents()
{
	Quit:'..OKToPurge()
	R !,"Are you sure you want to purge all excluded events? N // ",R
	If $E(R)'="Y",$E(R)'="y" W !,"(cancelled)" Quit
	Set tSQL="select EventType from HS_IHE_ATNA_Repository.Exclusion"
	Set tRS1=##class(%ResultSet.SQL).%Prepare(tSQL,.tSC)
	While tRS1.%Next()  {
		Set tEventType=tRS1.%Get("EventType") Do ..PurgeEventType(tEventType)
	}
}

ClassMethod PurgeEventType(pEventType)
{
	Quit:'..OKToPurge()
	If '$IsObject(..%OpenId(pEventType)) W !,"Event Type Error: ",pEventType Quit
	W !,"Purging Event Type: ",pEventType
	Set tSQL="Select ID from HS_IHE_ATNA_Repository.Aggregation where EventType=?"
	SET tStatement = ##class(%SQL.Statement).%New()
	Set tSC=tStatement.%Prepare(tSQL)
	Set tRS=tStatement.%Execute(pEventType)
	While tRS.%Next()  {
		Set tId=tRS.%Get("ID")
		W " ",tId Do ..PurgeEvent(tId)
	}
}

/// Purge all audit events before the given date
ClassMethod PurgeEventsByDate(pDate As %TimeStamp)
{
	Quit:'..OKToPurge()
	w !,"Are you sure you want to purge all events prior to "_pDate_"? N // "
	R R
	If $E(R)'="Y",$E(R)'="y" W !,"(cancelled)" Quit
	W !,"Purging all events prior to "_pDate
	Set tSQL="Select ID from HS_IHE_ATNA_Repository.Aggregation where IndexedDate < ?"
	SET tStatement = ##class(%SQL.Statement).%New()
	Set tSC=tStatement.%Prepare(tSQL)
	Set tRS=tStatement.%Execute(pDate)
	While tRS.%Next()  {
		Set tId=tRS.%Get("ID")
		W " ",tId Do ..PurgeEvent(tId)
	}
}

ClassMethod PurgeEvent(pId)
{
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		Quit:'..OKToPurge()
		Set tAgg=##class(HS.IHE.ATNA.Repository.Aggregation).%OpenId(pId) Quit:'$IsObject(tAgg)
		TSTART
		Set tSC=##class(HS.IHE.ATNA.Repository.Aggregation).%DeleteId(pId) Quit:$$$ISERR(tSC)
		TCOMMIT
	} While 0
Exit
	If $$$ISERR(tSC) TROLLBACK
	Quit
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

ClassMethod OKToPurge() As %Boolean
{
	If (","_$Roles_",")'[",%All," Write !,"Insufficient privileges" quit 0
	If ##class(HS.Registry.Config).GetKeyValue("\AuditAggregationSuspended") W !,"Purge Disabled during audit database move" quit 0
	If ##class(HS.Registry.Config).GetKeyValue("\AuditAggregationMoveTransition") W !,"Purge Disabled during audit database move" quit 0
	Quit 1
}

/// Used by HS.IHE.ATNA.Repository.Conversion to convert existing messages that use the old AuditMessage structure
ClassMethod PurgeATNA(pATNAId)
{
	Set tSC=$$$OK
	Do {
		Set tLog=##class(HS.IHE.ATNA.Repository.Data.AuditMessage).%OpenId(pATNAId)
		Quit:'$IsObject(tLog)
		For tActNum=1:1:tLog.ActiveParticipant.Count() Do ..PurgeActPar(tLog.ActiveParticipant.GetAt(tActNum))
		For tParNum=1:1:tLog.ParticipantObjectIdentification.Count() Do ..PurgePar(tLog.ParticipantObjectIdentification.GetAt(tParNum))
		For tSrcNum=1:1:tLog.AuditSourceIdentification.Count() Do ..PurgeAudSrc(tLog.AuditSourceIdentification.GetAt(tSrcNum))
		If $IsObject(tLog.EventIdentification) {
			Set tSC=tLog.EventIdentification.%DeleteId(tLog.EventIdentification.%Id())
		}
		Quit:$$$ISERR(tSC)
		Set tSC=tLog.%DeleteId(tLog.%Id())
	} While 0
	Quit tSC
}

ClassMethod PurgeActPar(pActPar As HS.IHE.ATNA.Repository.Data.ActiveParticipant)
{
	//these should not be purged, since they are shared among many events
	/*For tRolNum=1:1:pActPar.RoleIDCode.Count() {
		Set tRol=pActPar.RoleIDCode.GetAt(tRolNum)
		Do:$IsObject(tRol) tRol.%DeleteId(tRol.%Id())
	}*/
	Do pActPar.%DeleteId(pActPar.%Id())
}

ClassMethod PurgePar(pPar As HS.IHE.ATNA.Repository.Data.ParticipantObjectIdentificationType)
{
	For tPairNum=1:1:pPar.ParticipantObjectDetail.Count() {
		Set tPair=pPar.ParticipantObjectDetail.GetAt(tPairNum)
		Do:$IsObject(tPair) tPair.%DeleteId(tPair.%Id())
	}
	Do pPar.%DeleteId(pPar.%Id())
}

ClassMethod PurgeAudSrc(pSrc As HS.IHE.ATNA.Repository.Data.AuditSourceIdentificationType)
{
	Do pSrc.%DeleteId(pSrc.%Id())
}

Storage Default
{
<Data name="ExclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.ATNA.Repos1C5.ExclusionD</DataLocation>
<DefaultData>ExclusionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.ATNA.Repos1C5.ExclusionD</IdLocation>
<IndexLocation>^HS.IHE.ATNA.Repos1C5.ExclusionI</IndexLocation>
<StreamLocation>^HS.IHE.ATNA.Repos1C5.ExclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
