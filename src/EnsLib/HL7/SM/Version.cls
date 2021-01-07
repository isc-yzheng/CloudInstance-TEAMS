/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsBuild)

Class EnsLib.HL7.SM.Version [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

ClassMethod Upgrade() As %Status
{
	set tSC=$$$OK,tLocked=0
	try {
		Lock +^EnsHL7.SM:10
			set tLocked=$test
			if 'tLocked {
				set tSC=$$$EnsError($$$EnsErrGeneral,"Can not acquire lock on Sequence Manager global (^EnsHL7.SM) to do upgrade.") 
				Quit
			}
		if $g(^EnsHL7.SM)>##class(EnsLib.HL7.SequenceManager).CurrentRuntimeDataVersion() set tSC=$$$ERROR($$$GeneralError,"SequenceManager runtime data version is too high") quit
		if $d(^EnsHL7.SM)<10 set ^EnsHL7.SM=##class(EnsLib.HL7.SequenceManager).CurrentRuntimeDataVersion() quit
		for tVersion=2:1:##class(EnsLib.HL7.SequenceManager).CurrentRuntimeDataVersion() {
			if $g(^EnsHL7.SM)<tVersion {
				set tSC=$classmethod($this,"Upgrade"_tVersion) quit:$$$ISERR(tSC)
				set ^EnsHL7.SM=tVersion
			}
		}
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}
	Lock:tLocked -^EnsHL7.SM
	quit tSC
}

/// Convert ^EnsHL7.SM("output","SequenceNumberOnly") to either ^EnsHL7.SM("output","Sender") or ^EnsHL7.SM("output","Receiver")
/// On some systems, the target nodes may already exist, in which case, we do not merge.
ClassMethod Upgrade2()
{
	set tSC=$$$OK
	try {
		if $d(^EnsHL7.SM("output","Sender"))=0 merge ^EnsHL7.SM("output","Sender")=^EnsHL7.SM("output","SequenceNumberOnly")
		if $d(^EnsHL7.SM("output","Receiver"))=0 merge ^EnsHL7.SM("output","Receiver")=^EnsHL7.SM("output","SequenceNumberOnly")
		kill ^EnsHL7.SM("output","SequenceNumberOnly")
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Convert ^EnsHL7.SM to use ConfigName as the first level subscript
/// "metric" will use global ^EnsHL7.SM.metric
ClassMethod Upgrade3()
{
	set tSC=$$$OK
	try {
		merge ^||EnsHL7.SM=^EnsHL7.SM
		$$$KillRootNode(^EnsHL7.SM)
		;
		merge ^EnsHL7.SM.metric=^||EnsHL7.SM("metric")
		;
		; get config names from existing indexes
		set tConfig="" for  {
			set tConfig=$o(^||EnsHL7.SM("index","st",tConfig)) quit:tConfig=""
			set tConfigList(tConfig)=""
		}
		; get config names from existing productions
		set tSC=..getSequenceManagerItems(.tItemObjList) quit:$$$ISERR(tSC)
		for i=1:1:tItemObjList {
			set tConfig=tItemObjList(i).Name
			if tConfig'="" set tConfigList(tConfig)=""
		}
		;
		; for each config name, copy over the data
		set tConfig="" for  {
			set tConfig=$o(tConfigList(tConfig)) quit:tConfig=""
			;
			merge ^EnsHL7.SM(tConfig,"thread")=^||EnsHL7.SM("thread")
			merge ^EnsHL7.SM(tConfig,"output")=^||EnsHL7.SM("output")
			merge ^EnsHL7.SM(tConfig,"timer")=^||EnsHL7.SM("timer")
			merge ^EnsHL7.SM(tConfig,"index","st")=^||EnsHL7.SM("index","st",tConfig)
			merge ^EnsHL7.SM(tConfig,"index","ts")=^||EnsHL7.SM("index","ts",tConfig)
			merge ^EnsHL7.SM(tConfig,"index","ct")=^||EnsHL7.SM("index","ct",tConfig)
			merge ^EnsHL7.SM(tConfig,"index","tc")=^||EnsHL7.SM("index","tc",tConfig)
		}
		;
		kill ^||EnsHL7.SM
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Convert ^EnsHL7.SM to use "wait index" and resend index.
ClassMethod Upgrade4()
{
	set tSC = $$$OK
	try {
		set tConfigName = "" for {
			set tConfigName=$o(^EnsHL7.SM(tConfigName)) quit:tConfigName=""
			set tType ="" for  {
				set tType=$o(^EnsHL7.SM(tConfigName,"thread",tType)) quit:tType=""
				set tFacility="" for  {
					set tFacility=$o(^EnsHL7.SM(tConfigName,"thread",tType,tFacility)) quit:tFacility=""
					set tApplication="" for  {
						set tApplication=$o(^EnsHL7.SM(tConfigName,"thread",tType,tFacility,tApplication)) quit:tApplication=""
						set tThread="" for  {
							set tThread=$o(^EnsHL7.SM(tConfigName,"thread",tType,tFacility,tApplication,tThread)) quit:tThread=""
							if $d(^EnsHL7.SM(tConfigName,"thread",tType,tFacility,tApplication,tThread,"list"))||($g(^EnsHL7.SM(tConfigName,"thread",tType,tFacility,tApplication,tThread,"wait"))="") {
								Set ^EnsHL7.SM(tConfigName,"wait index","thread",tType,tFacility,tApplication,tThread) =""
							}		
						}
					}
				}
			}
		}
		/* Rewrite resend indices */
		set tConfigName="" for  {
			set tConfigName=$o(^EnsHL7.SM(tConfigName)) quit:tConfigName=""
			for tKind="tc","ts" {
				set tType="" for  {
					set tType=$o(^EnsHL7.SM(tConfigName,"index",tKind,tType)) quit:tType=""
					set tFacility="" for  {
						set tFacility=$o(^EnsHL7.SM(tConfigName,"index",tKind,tType,tFacility)) quit:tFacility=""
						set tApplication="" for  {
							set tApplication=$o(^EnsHL7.SM(tConfigName,"index",tKind,tType,tFacility,tApplication)) quit:tApplication=""
							set tTime="" for  {
								set tTime=$o(^EnsHL7.SM(tConfigName,"index",tKind,tType,tFacility,tApplication,tTime)) quit:tTime=""
								set tIndex="" for  {
									set tIndex=$o(^EnsHL7.SM(tConfigName,"index",tKind,tType,tFacility,tApplication,tTime,tIndex)) quit:tIndex=""
									if tKind="tc" {
										set ^EnsHL7.SMI("ResendIndex",tConfigName,tTime,$I(^EnsHL7.SMI("ResendIndex",tConfigName,tTime)))=$LB("tc","Sender",tFacility,tApplication,$li(tIndex,1),$li(tIndex,2))
										kill ^EnsHL7.SM(tConfigName,"index","tc","Sender",tFacility,tApplication,tTime,tIndex)
									}
									if tKind="ts" {
										set ^EnsHL7.SMI("ResendIndex",tConfigName,tTime,$I(^EnsHL7.SMI("ResendIndex",tConfigName,tTime)))=$LB("ts",tType,tFacility,tApplication,tIndex)
										kill ^EnsHL7.SM(tConfigName,"index","ts",tType,tFacility,tApplication,tTime,tIndex)
									}
								}
							}
						}
					}
				}
			}
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod getSequenceManagerItems(pItemList) As %Status
{
	set tSC = $$$OK
	try {
		kill pItemList set pItemList=0
		set tRS = ##class(%ResultSet).%New()
		set tRS.ClassName = "Ens.Config.Production"
		set tRS.QueryName = "Extent"
		set tSC = tRS.Execute()
		if $$$ISERR(tSC) Quit

		while (tRS.Next(.tSC)) {
			if $$$ISERR(tSC) Quit
			set tProdID=tRS.Data("ID")
			set tProdObj=##class(Ens.Config.Production).%OpenId(tProdID)
			for i=1:1:tProdObj.Items.Count() {
				set tItemObj=tProdObj.Items.GetAt(i)
				set tClass=tItemObj.ClassName
				If (tClass="EnsLib.HL7.SequenceManager")||$$IsDerivedFrom^%occLibrary(tClass,"EnsLib.HL7.SequenceManager") Set pItemList($i(pItemList))=tItemObj
			}
		}
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
