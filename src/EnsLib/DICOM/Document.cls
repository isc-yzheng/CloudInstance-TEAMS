/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsDICOM

/// This class represents a DICOM Message. The message consists of two logical sub-structures, the CommandSet and the DataSet. 
/// The command set contains information about the message ( message meta-data ) and the data set contains the actual payload
Class EnsLib.DICOM.Document Extends (%Persistent, Ens.Util.MessageBodyMethods, EnsLib.DICOM.Util.ULP) [ ClassType = persistent, Inheritance = right, System = 4 ]
{

/// Domain for Error Messages
Parameter DOMAIN = "EnsDICOM";

// -----------------------------------------------------------------

/// This holds the command-set, a collection of DICOM tags which contains the messages meta-data
Property CommandSet As EnsLib.DICOM.CommandSet;

/// This determines if the document actually has data, this can occur when a message has no data set
/// for example, an echo request (C-ECHO)
Property HasData As %Boolean [ Calculated, Internal ];

/// Accessor for HasData
Method HasDataGet() As %Boolean [ CodeMode = expression ]
{
..DataSet.HasData
}

/// This holds the data-set, a collection of DICOM tags which contains data that forms the payload of the message. This
/// is typically patient/study details and image data. The physical data may be stored in the file system or with the
/// database. Data which is only read remains at rest in the file system for maximum performance
Property DataSet As EnsLib.DICOM.DataSetInterface [ Calculated, Internal, Private ];

/// Accessor for DataSet
Method DataSetGet() [ CodeMode = expression ]
{
$Case(..Modified,1:..MutableDataSet,0:..FixedDataSet)
}

/// This holds the modifiable data set. When a document is modified the externally stored data is read 
/// into the database and becomes modifiable
Property MutableDataSet As EnsLib.DICOM.MutableDataSet [ Internal ];

/// This holds the read-only dataset, the data is kept in the file system, NOT the database
Property FixedDataSet As EnsLib.DICOM.FixedDataSet [ Internal ];

/// This holds the Modified flag
Property Modified As %Boolean [ InitialExpression = 0, Internal ];

/// This holds the AET of the Originating Application ( will only be automatically set for TCP inbound documents)
Property SourceAET As %String;

/// This holds the IP Address of the Source ( will only be automatically set for TCP inbound documents)
Property SourceIPAddress As %String;

/// This holds the AET of the Our Application ( will only be automatically set for TCP inbound documents)
Property DestinationAET As %String;

/// This holds the AET of the Originating Application prior to any transformation. ( will only be automatically
/// set for TCP inbound documents)
Property OriginalSourceAET As %String;

// ----------------------------------------------------------------------------------------------------------

/// When a document is created a storage location may be passed indicating where in the file system the external
/// data (if any) should be physically stored. The storage location is a directory name
Method %OnNew(pStorageLocation As %String = "") As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	#dim tSC As %Status = $$$OK
	
	try {
		
		#; Create the command set ( doesn't need a storage location, data is kept in the database)
		Kill %objlasterror Set ..CommandSet=##class(EnsLib.DICOM.CommandSet).%New()
		If '$IsObject(..CommandSet) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.CommandSet")) Quit
	
		#; Modifiable DataSet needs the storage location
		Kill %objlasterror Set ..MutableDataSet=##class(EnsLib.DICOM.MutableDataSet).%New(pStorageLocation)
		If '$IsObject(..MutableDataSet) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.MutableDataSet")) Quit
		
		#; ReadOnly DataSet needs the storage location
		Kill %objlasterror Set ..FixedDataSet=##class(EnsLib.DICOM.FixedDataSet).%New(pStorageLocation)
		If '$IsObject(..FixedDataSet) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.FixedDataSet")) Quit
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	
	Quit tSC
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ ServerOnly = 1 ]
{
	#dim tSC As %Status = $$$OK
	#dim tThis As EnsLib.DICOM.Document
	#dim tOid As %ObjectIdentity
	try {
			
		Kill %objlasterror Set tThis=..%Open(oid)
		If '$IsObject(tThis) Set tSC=$$$EnsError($$$DeleteObjectNotFound,$classname(),oid) Quit
		
		#; Ensure that we remove references to file streams that no longer exist before trying to
		#; delete the object, as attempts to delete these stale file pointers will result in errors.
		Set tMod = 0
		If (tThis.MutableDataSet.PixelData.Filename '= "") && '##class(%Library.File).Exists(tThis.MutableDataSet.PixelData.Filename) {
			Set tMod = 1
			Set tThis.MutableDataSet.PixelData.%Location = ""
		}
		If (tThis.FixedDataSet.FileStream.Filename '= "") && '##class(%Library.File).Exists(tThis.FixedDataSet.FileStream.Filename) {
			Set tMod = 1
			Set tThis.FixedDataSet.FileStream.%Location = ""
		}
		Set:tMod tSC = tThis.%Save()
		Quit:$$$ISERR(tSC)
		
		#; Clear the command set, this reclaims the global space
		Set tSC=tThis.CommandSet.Clear() If $$$ISERR(tSC) Quit
		
		#; Clear the Modifiable DataSet, this reclaims the global space
		Set tSC=tThis.MutableDataSet.Clear() If $$$ISERR(tSC) Quit
		
		#; Delete the ReadOnly DataSet
		Set tSC=tThis.FixedDataSet.%Delete(tThis.FixedDataSet.%Oid())
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Use this method to create a dicom document from a file binary stream containing DICOM data in DICOM format
ClassMethod CreateFromDicomFileStream(pFileBinaryStream As %FileBinaryStream, Output pDocument As EnsLib.DICOM.Document)
{
	#dim tSC As %Status = $$$OK
	#dim tFile As EnsLib.DICOM.File
	#dim tDataSetType As %Integer
	#dim tTransferSyntax,tValue As %String
	try {
		
		#; Create a dicom file from the specified stream
		Set tSC=##class(EnsLib.DICOM.File).CreateFromDicomFileStream(pFileBinaryStream,.tFile)
		If $$$ISERR(tSC) Quit
		
		#; Create an instance of a DICOM Document
		Kill %objlasterror Set pDocument=##class(EnsLib.DICOM.Document).%New()
		If '$IsObject(pDocument) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
		
		#; Copy the data set from the file
		Set tSC=pDocument.MutableDataSet.CopyFrom(tFile.MutableDataSet) If $$$ISERR(tSC) Quit
		
		#; Now mark the document as modified
		Set pDocument.Modified=1
		
		#; Need to copy over the SOPClassUID - According to the DICOM guidelines, This should be manually updated by 
		#; the user to reflect that a copy has been made
		Set tValue=pDocument.GetValueAt("DataSet.SOPClassUID",,.tSC)
		If $$$ISERR(tSC) Quit
		
		Set tSC=pDocument.SetValueAt(tValue,"CommandSet.AffectedSOPClassUID")
		If $$$ISERR(tSC) Quit
		
		#; And the SOPInstanceUID - According to the DICOM guidelines, This should be manually updated by 
		#; the user to reflect that a copy has been made
		Set tValue=pDocument.GetValueAt("DataSet.SOPInstanceUID",,.tSC)
		If $$$ISERR(tSC) Quit
		
		Set tSC=pDocument.SetValueAt(tValue,"CommandSet.AffectedSOPInstanceUID")
		If $$$ISERR(tSC) Quit
		
	} catch {
	
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Use this method to create a dicom document from a file binary stream containing DICOM data in DataSet format
ClassMethod CreateFromDataSetFileStream(pFileBinaryStream As %FileBinaryStream, pTransferSyntax As %String, Output pDocument As EnsLib.DICOM.Document) [ Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim tFile As EnsLib.DICOM.File
	#dim tDataSetType As %Integer
	#dim tTransferSyntax,tValue As %String
	try {
		
		#; Create a dicom file from the specified stream
		Set tSC=##class(EnsLib.DICOM.File).CreateFromDataSetFileStream(pFileBinaryStream,pTransferSyntax,.tFile)
		If $$$ISERR(tSC) Quit
		
		#; Create an instance of a DICOM Document
		Kill %objlasterror Set pDocument=##class(EnsLib.DICOM.Document).%New()
		If '$IsObject(pDocument) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
		
		#; Copy the data set from the file
		Set tSC=pDocument.MutableDataSet.CopyFrom(tFile.MutableDataSet) If $$$ISERR(tSC) Quit
		
		#; Now mark the document as modified
		Set pDocument.Modified=1
		
		#; Need to copy over the SOPClassUID - According to the DICOM guidelines, This should be manually updated by 
		#; the user to reflect that a copy has been made
		Set tValue=pDocument.GetValueAt("DataSet.SOPClassUID",,.tSC)
		If $$$ISERR(tSC) Quit
		
		Set tSC=pDocument.SetValueAt(tValue,"CommandSet.AffectedSOPClassUID")
		If $$$ISERR(tSC) Quit
		
		#; And the SOPInstanceUID - According to the DICOM guidelines, This should be manually updated by 
		#; the user to reflect that a copy has been made
		Set tValue=pDocument.GetValueAt("DataSet.SOPInstanceUID",,.tSC)
		If $$$ISERR(tSC) Quit
		
		Set tSC=pDocument.SetValueAt(tValue,"CommandSet.AffectedSOPInstanceUID")
		If $$$ISERR(tSC) Quit
		
	} catch {
	
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

// ----------------------------------------------------------------------------------------------------------

/// Initialize the command set from an external stream
Method InitializeCommandSet(pStream) As %Status
{
	#; Delegate to the command set
	Quit ..CommandSet.Initialize(pStream,$$$IMPLICITVRLETRANSFERSYNTAX)
}

// ----------------------------------------------------------------------------------------------------------

/// This VDOC Compliant method gets the value of the given property.<br>
/// This is implemented by the document class.<br>
/// <var>pPropertyPath</var> contains the property name.<br>
/// For this class it is only applicable to the CommandSet and DataSet properties<br>	
/// pFormat can be defined or not. If defined it can take the values "",0 or 1.<br>
/// pFormat of "" is the same as not defined.<br>
/// pFormat of 0 means return an empty string and not an error if the value does not exist. <br>
/// pFormat of 1 means force an error if a value does not exist. <br>
Method GetValueAt(pPropertyPath As %String, pFormat As %String, pStatus As %Status, pDummy) As %String
{
	#dim tProperty,tTrailer,tRetVal As %String = ""
	#dim e As %Exception.AbstractException
	Try { 
		Set tProperty=$Piece(pPropertyPath,"."),tTrailer=$Piece(pPropertyPath,".",2,$Length(pPropertyPath,"."))
		If (tProperty="CommandSet") {
			Set tRetVal=..CommandSet.GetValueAt(tTrailer,.pFormat,.pStatus)
		} elseif (tProperty="DataSet") {
			Set tRetVal=..DataSet.GetValueAt(tTrailer,.pFormat,.pStatus)
		} else {
			If $G(pFormat)=0 Set pStatus = $$$OK Quit
			Set pStatus=$$$ERROR($$$EnsDICOMDataElementNotFound,pPropertyPath)
		}
	} Catch e {
		Set pStatus = e.AsStatus()	
	}
	Quit tRetVal
}

/// This VDOC Compliant method sets the value of the given property.<br>
/// This is implemented by the document class.<br>
/// <var>pPropertyPath</var> contains the property name.<br>
/// <var>pAction</var> contains an action code: "set", etc..<br>
/// <var>pKey</var> contains an optional key value.<br>
/// For this class it is only applicable to the CommandSet and DataSet properties
Method SetValueAt(pValue As %String, pPropertyPath As %String, pAction As %String = "set", pKey As %String = "") As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tTrailer,tProperty As %String = ""
	
	do {
		Set tProperty=$Piece(pPropertyPath,"."),tTrailer=$Piece(pPropertyPath,".",2,$Length(pPropertyPath,"."))
		If (tProperty="CommandSet") {
			Set tSC=..CommandSet.SetValueAt(pValue,tTrailer,pAction,pKey)
		} elseif (tProperty="DataSet") {
		
			#; If we are read only
			If ..Modified = 0 {
			
				#; Make the document editable
				Set tSC=..MakeEditable() If $$$ISERR(tSC) Quit 
			}
		
			Set tSC=..DataSet.SetValueAt(pValue,tTrailer,pAction,pKey)		
		} else {	
			Set tSC=$$$ERROR($$$EnsDICOMDataElementNotFound,pPropertyPath)
		}
	} while (0)
	
	Quit tSC
}

/// This VDOC Compliant method gets the next index for a subscripted VDOC reference
Method GetNextIndex(pPropertyPath As %String, pIndex As %String = "", Output pStatus As %Status = {$$$OK}) As %String
{
	#dim tProperty,tTrailer,tRetVal As %String = ""
	
	Set tProperty=$Piece(pPropertyPath,"."),tTrailer=$Piece(pPropertyPath,".",2,$Length(pPropertyPath,"."))
	If (tProperty="CommandSet") {
		Set tRetVal=..CommandSet.GetNextIndex(tTrailer,.pStatus)
	} elseif (tProperty="DataSet") {
		Set tRetVal=..DataSet.GetNextIndex(tTrailer,pIndex,.pStatus)	
	} else {	
		Set pStatus=$$$ERROR($$$EnsDICOMDataElementNotFound,pPropertyPath)
	}
	Quit tRetVal
}

// ----------------------------------------------------------------------------------------------------------

/// From 'Ens.Util.MessageBodyMethods'
Method %ShowContents(pZenOutput As %Boolean = 0)
{
	Do ..CommandSet.OutputHtmlToDevice()
	Write "</P>"
	Do ..DataSet.OutputHtmlToDevice()
}

// ----------------------------------------------------------------------------------------------------------

Method MakeEditable() As %Status [ Internal, Private ]
{
	#dim tSC As %Status = $$$OK
	
	try {
		If (..Modified=0) {
			
			Set tSC=..MutableDataSet.Initialize(..FixedDataSet.FileStream,..FixedDataSet.TransferSyntax)
			If $$$ISERR(tSC) Quit
		
			Set ..Modified=1
		}
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Compose the Tag Data into a Set of Protocol Data Units and transmit them to the peer
Method SendWireStream(pAdapter As EnsLib.DICOM.Adapter.TCP, pContextId As %Integer, pTransferSyntax As %String) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim tDataSetType As %Integer
	try {
		
		#; Get the data-set type
		Set tDataSetType=$Case(..HasData,1:$$$DATASETISPRESENT,0:$$$NODATASETPRESENT)
	
		#; Add the data-set's type to the command-set
		Set tSC=..CommandSet.SetValueAt(tDataSetType,"CommandDataSetType") 
		If $$$ISERR(tSC) Quit
		
		#; Send the CommandSet (knows its own tranfer syntax)
		Set tSC=..CommandSet.SendWireStream(pAdapter,pContextId) 
		If $$$ISERR(tSC) Quit
		
		#; If there is data in the DataSet then send that too
		If tDataSetType=$$$DATASETISPRESENT {
			Set tSC=..DataSet.SendWireStream(pAdapter,pContextId,pTransferSyntax) If $$$ISERR(tSC) 
		}
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

Storage Default
{
<Data name="DocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommandSet</Value>
</Value>
<Value name="3">
<Value>MutableDataSet</Value>
</Value>
<Value name="4">
<Value>FixedDataSet</Value>
</Value>
<Value name="5">
<Value>Modified</Value>
</Value>
<Value name="6">
<Value>SourceAET</Value>
</Value>
<Value name="7">
<Value>SourceIPAddress</Value>
</Value>
<Value name="8">
<Value>DocType</Value>
</Value>
<Value name="9">
<Value>TimeCreated</Value>
</Value>
<Value name="10">
<Value>Source</Value>
</Value>
<Value name="11">
<Value>IsMutable</Value>
</Value>
<Value name="12">
<Value>OriginalDocId</Value>
</Value>
<Value name="13">
<Value>DestinationAET</Value>
</Value>
<Value name="14">
<Value>OriginalSourceAET</Value>
</Value>
</Data>
<DataLocation>^EnsLib.DICOM.DocumentD</DataLocation>
<DefaultData>DocumentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.DICOM.DocumentD</IdLocation>
<IndexLocation>^EnsLib.DICOM.DocumentI</IndexLocation>
<StreamLocation>^EnsLib.DICOM.DocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
