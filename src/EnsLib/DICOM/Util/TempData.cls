/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsDICOM)

/// This class serves as a temporary repository for data derived from a dataset. It is used by
/// The ConvertStream() method of CalloutDCM when a dataset needs to be converted from one transfer
/// syntax to another. The target stream is decomposed into the database and then re-composed onto
/// another stream in the new binary format
Class EnsLib.DICOM.Util.TempData Extends %RegisteredObject [ System = 4 ]
{

/// This holds the selected transfer syntax
Property TransferSyntax As %String;

/// This holds the byte ordering for the transfer syntax
Property ByteOrdering As %Integer [ Calculated, Internal, Private, ReadOnly ];

/// Getter for ByteOrdering property
Method ByteOrderingGet() As %Integer [ CodeMode = expression, Internal, Private ]
{
$Case($$$TRANSFERSYNTAXISLTLENDIAN(..TransferSyntax),1:$$$LTLENDIAN,:$$$BIGENDIAN)
}

/// This holds the Explicit Syntax flag
Property Explicit As %Boolean [ Calculated, Internal, Private, ReadOnly ];

/// Getter for Explicit property
Method ExplicitGet() As %Boolean [ CodeMode = expression ]
{
$$$TRANSFERSYNTAXISEXPLICIT(..TransferSyntax)
}

/// This holds the PixelData
Property PixelData As %FileBinaryStream [ Internal ];

Property PixelVR As %String [ Internal ];

/// This holds the key to the storage for the data in ^EnsDICOM.Data()
Property Key As %Integer [ InitialExpression = {$Increment(^EnsDICOM.Data)}, Internal, ReadOnly, SqlFieldName = _Key ];

/// Accessor for the Key property
Method KeyGet() As %Integer
{
	If i%Key="" Set i%Key=$Increment(^EnsDICOM.Data)
	Quit i%Key
}

Method %OnNew(initvalue As %RawString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Kill %objlasterror
	Set ..PixelData = ##class(%FileBinaryStream).%New()
	If '$IsObject(..PixelData) Quit $Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"%FileBinaryStream"))
	Quit $$$OK
}

/// This method initializes the object from an adapted stream. The stream should contain data in a format specified
/// by the transfer syntax.
Method Initialize(pStream, pTransferSyntax As %String) As %Status
{
	#dim tContentHandler As EnsLib.DICOM.Util.ImportHandler
	#dim tSC As %Status = $$$OK
	try {
		
		#; Create an import handler
		Kill %objlasterror Set tContentHandler=##class(EnsLib.DICOM.Util.ImportHandler).%New(##this)
		If '$IsObject(tContentHandler) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.ImportHandler")) Quit
					
		#; Decompose the stream
		Set tSC=..DecomposeStream(pStream,pTransferSyntax,tContentHandler)
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Compose the dataset onto the target stream with the specified transfer syntax
Method ComposeStream(pStream, pTransferSyntax As %String) As %Status
{
	Quit ##class(EnsLib.DICOM.Util.CalloutDCM).ComposeStream(pStream,..Key,pTransferSyntax,..TransferSyntax,..PixelData)
}

/// This method can be overriden by subclasses to cause the decomposition of a data set to be exited early.
/// This is useful for parsing file meta data and wire protocol command sets. For this implementation, decomposition 
/// should continue to the end of the data set
Method ShouldStopDecomposition(pTag As %Integer) As %Boolean
{
	Quit 0
}

/// Decompose a stream containing DICOM data
Method DecomposeStream(pStream As EnsLib.DICOM.Util.InputStreamAdapter, pTransferSyntax As %String, pContentHandler As EnsLib.DICOM.Util.ContentHandler) As %Status [ Internal ]
{
	#; Record the transfer syntax
	Set ..TransferSyntax=pTransferSyntax

	#; Decompose the stream
	Quit ##class(EnsLib.DICOM.Util.CalloutDCM).DecomposeStream(pStream,..Key,pTransferSyntax,pContentHandler,##this)
}

Method Clear() As %Status
{
	Kill ^EnsDICOM.Data(..Key) Quit $$$OK
}

}
