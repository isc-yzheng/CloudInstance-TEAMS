/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Service to trigger purging of Callback Log.
Class EnsLib.ITK.Framework.Service.PurgeCallBackService Extends Ens.BusinessService [ ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: Service to trigger purging of Callback Log.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pRequest As %RegisteredObject, pResponse As %RegisteredObject) As %Status
{
	// Determine purge days for call and check if call is neccessary
	Set purgeDays=##class(Ens.Director).GetHostSettingValue("CallBackPurgeRoutine","PurgeDays",.sc)
	If $$$ISOK(sc) {
		&sql(select count(ID) into :count From EnsLib_ITK_Framework.CallBackLog where DATEDIFF('d',CallBackLogCreated,SYSDATE) > :purgeDays)
		Quit:(SQLCODE=0)&&$D(count)&&($G(count)=0) $$$OK
	}

	// There are callbacks to purge or we are not sure!
	Set sc=..SendRequestAsync("CallBackPurgeRoutine", pRequest)
	Quit sc
}

}
