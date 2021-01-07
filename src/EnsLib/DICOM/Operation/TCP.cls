/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsDICOM

Class EnsLib.DICOM.Operation.TCP Extends EnsLib.DICOM.Duplex.TCP [ System = 4 ]
{

/// From the message-map, the adapter is asked to open the association
Method EstablishAssociation(pRequest As EnsLib.DICOM.Command.Establish, Output pResponse As %Library.Persistent) As %Status
{
	#; Ask the adapter to establish an association
	Quit ..Adapter.EstablishAssociation(pRequest)
}

/// From the message-map, the adapter is asked to close the association
Method ReleaseAssociation(pRequest As EnsLib.DICOM.Command.Release, Output pResponse As %Library.Persistent) As %Status
{
	#; Ask the adapter to Release the assocation	
	Quit ..Adapter.ReleaseAssociation()
}

/// This  Callback method is called by the adapter if it encounters a fatal error
Method OnAdapterErrored(pStatus As %Status) As %Status
{
	#; Send the notification to the process
	#dim tSC As %Status = $$$OK

	/* 
		Check if will be retrying on the error and hence not send ReleaseAssociation 
		OnGetReplyAction uses the setting Reply Code Actions
	*/
	If $$$ISERR(pStatus) {
				
		#dim tReplyAction = ..OnGetReplyAction(..%RequestHeader,"",pStatus)
		
		#; If retry will be the action pass back pStatus to MessageHeaderHandler.
		If tReplyAction["R" Return pStatus
		
	}
	If ..%InPrivateSession {
		Set tSC=..StopPrivateSession(##class(EnsLib.DICOM.Notify.Errored).%New(pStatus))
	}
	Quit ..Adapter.ReleaseAssociation()
}

/// Override this method to provide custom handling of retry / failure timeout.<p/>
/// Set ..Retry=1 to override normal error return and re-evaluate flag properties.<p/>
/// Return 0 to skip further (default) FailureTimeout processing, 1 to perform default processing.
Method OnFailureTimeout(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent, ByRef pSC As %Status) As %Boolean
{
	If ..%InPrivateSession {
		Do ..StopPrivateSession(##class(EnsLib.DICOM.Notify.Errored).%New(pSC))
	}
	Do ..Adapter.ReleaseAssociation()
	Quit 1
}

}
