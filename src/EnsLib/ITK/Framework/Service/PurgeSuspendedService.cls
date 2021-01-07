/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Service to trigger purging of Suspended Message Log.
Class EnsLib.ITK.Framework.Service.PurgeSuspendedService Extends Ens.BusinessService [ ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: Service to trigger purging of Suspended Message Log.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pRequest As %RegisteredObject, pResponse As %RegisteredObject) As %Status
{
	set required=0

	if 'required {
		&sql(select Count(ID) into :count FROM EnsLib_ITK_Framework.SubscriptionPullLog where SubscriptionPullStatus = '2')
		set:(SQLCODE=0)&&$G(count)>0 required=1
	}

	if 'required {
		set purgeDays=##class(Ens.Director).GetHostSettingValue("SuspendedPurgeRoutine", "PurgeDays", .sc)
		if $$$ISOK(sc) {
			&sql(select Count(ID) into :count from EnsLib_ITK_Framework.SubscriptionPullLog where DATEDIFF('d',SubscriptionPullMsgCreatedDate,SYSDATE) > :purgeDays)
			set:(SQLCODE=0)&&$G(count)>0 required=1
		}
	}

	if 'required {
		set resetDays=##class(Ens.Director).GetHostSettingValue("SuspendedPurgeRoutine", "ReSetToUnCollectedInNoDays", .sc)
		if $$$ISOK(sc) {
			&sql(select Count(ID) into :count from EnsLib_ITK_Framework.SubscriptionPullLog where SubscriptionPullStatus = '1' AND DATEDIFF('d',SubscriptionPullMsgStatusUpdatedDate,SYSDATE) > :resetDays)
			set:(SQLCODE=0)&&$G(count)>0 required=1
		}
	}

	set sc=$$$OK
	if required {
		// We know or are unsure if there suspended messages to purge, call process
		set sc=..SendRequestAsync("SuspendedPurgeRoutine", pRequest)
	}

	quit sc
}

}
