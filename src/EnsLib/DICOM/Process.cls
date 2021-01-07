/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsDICOM

/// This is the superclass for user-define DICOM business processes
Class EnsLib.DICOM.Process Extends EnsLib.PrivateSession.Process [ ClassType = persistent, ProcedureBlock, System = 4 ]
{

// -------------------------------------------------------------------------------------------- 

/// A message has been received from the service/operation, typically these are instances of EnsLib.DICOM.Document.
/// Its the responsbility of the subclass to handle these messages
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
	#; SubclassResponsibility
	Quit $$$OK
}

/// This call back is called by the framework when an Association is established
Method OnAssociationEstablished(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Established) As %Status
{
	#; SubclassResponsibility
	Quit $$$OK
}

/// This callback is called by the framework when an Association is released
Method OnAssociationReleased(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Released) As %Status
{
	#; SubclassResponsibility
	Quit $$$OK
}

/// This callback is called by the framework when an Association is rejected
Method OnAssociationRejected(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Rejected) As %Status
{
	#; SubclassResponsibility
	Quit $$$OK
}

/// This callback is called by the framework when an assocation encounters an error
Method OnAssociationErrored(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Errored) As %Status
{
	#; Subclass Responsibility
	Quit $$$OK
}

/// This callback is called by the framework when an association is aborted
Method OnAssociationAborted(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Aborted) As %Status
{
	#; Subclass Responsibility
	Quit $$$OK
}

/// This method is called when an error response is received
/// Returning the same error will cause the BusinessProcess to set its status to error and close down
/// Returning $$$OK from this method causes the BusinessProcess to recover from this error
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	#; Subclass Responsibility
	Quit $$$OK
}

// ------------------------------------------------------------------------------------------

/// This method can be called to ABORT an association, typically in response to an ABORT received
/// from an external device
Method AbortAssociation(pDuplexConfigName As %String, pInput As EnsLib.DICOM.Command.Abort) As %Status
{
	#; Command the duplex to abort, no reply expected
	If ..IsInPrivateSession(pDuplexConfigName) {
		Quit ..StopPrivateSession(pDuplexConfigName,pInput)
	}
	Quit $$$OK
}

Method EstablishAssociation(pDuplexConfigName As %String) As %Status
{
	Quit ..StartPrivateSession(pDuplexConfigName)
}

/// This method can be called to release a previously established association with the operations peer
Method ReleaseAssociation(pDuplexConfigName) As %Status
{
	Quit ..SendRequestAsync(pDuplexConfigName,##class(EnsLib.DICOM.Command.Release).%New(),0)
}

// ------------------------------------------------------------------------------------------

/// This method is called when a Private Session stops. The session may stop for a variety of reasons,
/// primarily the association being released, but also when an assocation aborts, errors or is rejected
/// A user should not need to override this method as it merely dispatches to the appropriate event handler 
Method OnPrivateSessionStopped(pSourceConfigName As %String, pSelfGenerated As %Boolean, pAttachedMessage As %Persistent = "") As %Status [ Final, Internal ]
{
	If $IsObject(pAttachedMessage) {
		
		If pAttachedMessage.%Extends("EnsLib.DICOM.Notify.Released") {
			 Quit ..OnAssociationReleased(pSourceConfigName,pAttachedMessage)
		} Elseif pAttachedMessage.%Extends("EnsLib.DICOM.Notify.Aborted") {
			 Quit ..OnAssociationAborted(pSourceConfigName,pAttachedMessage)
		}  Elseif pAttachedMessage.%Extends("EnsLib.DICOM.Notify.Errored") {
			 Quit ..OnAssociationErrored(pSourceConfigName,pAttachedMessage)
		}  Elseif pAttachedMessage.%Extends("EnsLib.DICOM.Notify.Rejected") {
			 Quit ..OnAssociationRejected(pSourceConfigName,pAttachedMessage)
		}
	}
	Quit $$$OK
}

/// Override the superclasses OnDocument() method to provide custom dispatch. Some messages are
/// handled by the framework, e.g. the ECHO (DICOM PING)
Method OnDocument(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status [ Final, Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim tMsgType As %String

	try {
		
		#; Handle notifications
		If pInput.%Extends("EnsLib.DICOM.Notify.Established") {
			Set tSC=..OnAssociationEstablished(pSourceConfigName,pInput)
		} else {
		
			#; Handle Echo Requests here
			If pInput.%Extends("EnsLib.DICOM.Document") {
 		
				#; Get the CommandField, it contains the type of request
				Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
				If $$$ISERR(tSC) Quit

				If tMsgType="C-ECHO-RQ" Set tSC=..OnEchoRequest(pSourceConfigName,pInput) Quit
			}
			
			#; Dispatch to the subclass
			Set tSC=..OnMessage(pSourceConfigName, pInput)
		}
	
	} catch {
		Set tSC=$$$EnsSystemError
	}
	
	Quit tSC
}

/// This method handles the EchoRequest message. The EchoRequest is the logical equivalent of the TCP ping, effectively
/// asking, 'are you there?'. An EchoRequest message has only a command set, no data set.
Method OnEchoRequest(pSourceConfigName, pInput As EnsLib.DICOM.Document) As %Status [ Final, Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim tDocOut As EnsLib.DICOM.Document
	#dim tStorageLocation As %String
	#dim tTemp As %String
	
	try {
	
		#; Get the current storage location
		Set tStorageLocation=..GetProductionSettingValue("StorageLocation",.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Create an instance of document to form the response
		Kill %objlasterror Set tDocOut=##class(EnsLib.DICOM.Document).%New(tStorageLocation)
		If '$IsObject(tDocOut) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
		
		#; Need to copy over the AffectedSOPClassUID (Mandatory field)
		Set tTemp=pInput.GetValueAt("CommandSet.AffectedSOPClassUID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=tDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPClassUID")
		If $$$ISERR(tSC) Quit
		
		#; And indicate the message id being responded to (Mandatory field)
		Set tTemp=pInput.GetValueAt("CommandSet.MessageID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=tDocOut.SetValueAt(tTemp,"CommandSet.MessageIDBeingRespondedTo")
		If $$$ISERR(tSC) Quit
		 
		#; Set the CommandField, this is an Echo Response
		Set tSC=tDocOut.SetValueAt($$$Str2MsgTyp("C-ECHO-RSP"),"CommandSet.CommandField") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; Set the Status to Success
		Set tSC=tDocOut.SetValueAt(0,"CommandSet.Status") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; Send the reply back to the service (don't want a response)
		Set tSC=..SendRequestAsync(pSourceConfigName,tDocOut,0)
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

Method OnPrivateSessionStarted(pSourceConfigName As %String, pSelfGenerated As %Boolean) As %Status [ Final, Internal ]
{
	#dim tMsg As EnsLib.DICOM.Command.Establish
	#dim tTransferSyntax As %String
	#dim tSC As %Status = $$$OK
	
	If pSelfGenerated {
		
		#; Create an new Establish message
		Set tMsg=##class(EnsLib.DICOM.Command.Establish).%New()
		 
		#; Provide the opportunity to overide the transfer syntax for the
		#; configured Association Definition
		Set tSC = ..OnDetermineTransferSyntax(.tTransferSyntax)
		If $$$ISERR(tSC) Quit
		
		#; Fill in the value in the Establish message
		Set tMsg.TransferSyntax=tTransferSyntax
					
		#; And send the request
		Quit ..SendRequestAsync(pSourceConfigName,tMsg,0)
	}
	Quit $$$OK
}

/// Use this method to dynamically configure the transfer syntax for outbound connections to
/// DICOM peers. The transfer syntax now supports a comma delimted list of transfer syntaxes
Method OnDetermineTransferSyntax(Output pTransferSyntax = "") As %Status
{
	#; Example, to offer implicit and explicit little endian :-
	#; Set pTransferSyntax=IMPLICITVRLETRANSFERSYNTAX_","_RAWDATAEXPLICITVRLTLENDIAN
	#;
	#; Subclass Responsibility
	Quit $$$OK
}

Method ScheduleWakeupCall(pTimeout As %Integer) As %Status
{
	Set tAlarmRequest = ##class(Ens.AlarmRequest).%New()
	$$$ASSERT($IsObject(tAlarmRequest))
	Set tAlarmRequest.Timeout = pTimeout
	Quit ..SendRequestAsync("Ens.Alarm",tAlarmRequest)
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
