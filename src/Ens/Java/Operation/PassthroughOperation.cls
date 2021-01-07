/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessOperation to create a Java
/// Business Operation.  This operation can handle incoming messages of type Ens.StreamContainer or EnsLib.EDI.XML.VDoc.
/// All messages are sent along to the Java class as a string. 
Class Ens.Java.Operation.PassthroughOperation Extends Ens.Java.Operation.Standard [ Abstract ]
{

Method OnStreamMessage(pRequest As Ens.StreamContainer, Output pResponse As Ens.StreamContainer) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim ex As %Exception.StatusException

	Try {
		#dim tStream As %Stream.GlobalBinary = pRequest.Stream
		
		// send payload to the Java implementation
		Set tSC = ##class(com.intersystems.gateway.bh.ProductionConcrete).messageHandlerStream(..JavaGateway, ..%ConfigName, tStream)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$ErrorExecutingJavaCommand, "messageHandlerStream()"_" returned: """_$System.Status.GetErrorText(tSC)_"""")
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method OnStringMessage(pRequest As Ens.StringContainer, Output pResponse As Ens.StringContainer) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim ex As %Exception.StatusException

	Try {
		// send payload to the Java implementation
		Set tSC = ##class(com.intersystems.gateway.bh.ProductionConcrete).messageHandlerString(..JavaGateway, ..%ConfigName, pRequest.StringValue)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$ErrorExecutingJavaCommand, "messageHandlerString()"_" returned: """_$System.Status.GetErrorText(tSC)_"""")
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// This is the message handler for requests of type EnsLib.EDI..Document
Method OnVDocMessage(pRequest As EnsLib.EDI.Document, Output pResponse As EnsLib.EDI.Document) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim ex As %Exception.StatusException

	Try {
		#dim tStream As %Stream.GlobalBinary = ##class(%Stream.TmpBinary).%New()
		Set tSC = pRequest.OutputToLibraryStream(.tStream)
		Quit:$$$ISERR(tSC)
		
		// send payload to the Java implementation
		Set tSC = ##class(com.intersystems.gateway.bh.ProductionConcrete).messageHandlerStream(..JavaGateway, ..%ConfigName, tStream)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$ErrorExecutingJavaCommand, "messageHandlerStream()"_" returned: """_$System.Status.GetErrorText(tSC)_"""")
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Quit $$$ERROR($$$GeneralError,"Received unexpected message type ("_pRequest.%ClassName()_")")
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="EnsLib.EDI.ASTM.Document">
	<Method>OnVDocMessage</Method>
	</MapItem>
	<MapItem MessageType="EnsLib.EDI.EDIFACT.Document">
	<Method>OnVDocMessage</Method>
	</MapItem>
	<MapItem MessageType="EnsLib.HL7.Message">
	<Method>OnVDocMessage</Method>
	</MapItem>
	<MapItem MessageType="EnsLib.EDI.XML.Document">
	<Method>OnVDocMessage</Method>
	</MapItem>
	<MapItem MessageType="EnsLib.EDI.X12.Document">
	<Method>OnVDocMessage</Method>
	</MapItem>
	<MapItem MessageType="Ens.StringContainer">
	<Method>OnStringMessage</Method>
	</MapItem>
	<MapItem MessageType="Ens.StreamContainer">
	<Method>OnStreamMessage</Method>
	</MapItem>
	</MapItems>
}

}
