/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// A dummy operation to Defer response to a Synchronous Request.
Class EnsLib.ITK.Framework.Operation.DeferResponse Extends Ens.BusinessOperation [ ProcedureBlock, System = 4 ]
{

Parameter SrcVer = "$Id$";

Parameter INVOCATION = "Queue";

Method DeferSyncResponse(pRequest As %RegisteredObject, pResponse As %RegisteredObject) As %Status
{
	Do ..DeferResponse(.token)
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Ens.Request">
    <Method>DeferSyncResponse</Method>
  </MapItem>  
</MapItems>
}

}
