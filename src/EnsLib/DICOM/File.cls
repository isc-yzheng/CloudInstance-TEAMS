/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsDICOM)

/// This class represents a DICOM file. A dicom file consists of two constituent parsts, MetaData and the DataSet. 
/// The MetaData contains DICOM elements which contain details about the characteristics of the DataSet
Class EnsLib.DICOM.File Extends %RegisteredObject [ SqlTableName = _File, System = 4 ]
{

/// This holds the File pre-amble. This is an 128 field which can contain proprietry information. The standard
/// does not specify the contents other than that it should be set to nulls ($Char(0)) if no information is present.
Property Preamble As %String [ InitialExpression = {$Translate($Justify("",128)," ",$Char(0))}, Internal, Private ];

/// This holds the meta data
Property MetaData As EnsLib.DICOM.MetaData [ Internal ];

/// This holds the data set
Property MutableDataSet As EnsLib.DICOM.MutableDataSet [ Internal ];

/// This holds the transfer syntax
Property TransferSyntax As %String;

/// Accessors for TransferSyntax
Method TransferSyntaxSet(pTransferSyntax As %String) As %Status
{
	#; Delegate to the data set
	Set ..MutableDataSet.TransferSyntax=pTransferSyntax
	Quit $$$OK
}

Method TransferSyntaxGet() As %String
{
	Quit ..MutableDataSet.TransferSyntax
}

/// Retrieve the ValueRepresentation of the specified property
Method GetVRAt(pPropertyReference As %String, Output pVR As %String) As %Status
{
	#dim tTrailer,tProperty As %String = ""
	#dim tSC As %Status
	
	Set tProperty=$Piece(pPropertyReference,"."),tTrailer=$Piece(pPropertyReference,".",2,$Length(pPropertyReference,"."))
	If (tProperty="MetaData") {
		Set tSC=..MetaData.GetVRAt(tTrailer,.pVR)
	} elseif (tProperty="DataSet") {
		Set tSC=..MutableDataSet.GetVRAt(tTrailer,.pVR)		
	} else {	
		Set tSC=$$$EnsError($$$EnsDICOMDataElementNotFound,pPropertyReference)
	}
	Quit tSC
}

/// Set the ValueRepresentation of the specified property
Method SetVRAt(pPropertyReference As %String, pVR As %String) As %Status
{
	#dim tTrailer,tProperty As %String = ""
	#dim tSC As %Status
	
	Set tProperty=$Piece(pPropertyReference,"."),tTrailer=$Piece(pPropertyReference,".",2,$Length(pPropertyReference,"."))
	If (tProperty="MetaData") {
		Set tSC=..MetaData.SetVRAt(tTrailer,pVR)
	} elseif (tProperty="DataSet") {
		Set tSC=..MutableDataSet.SetVRAt(tTrailer,pVR)		
	} else {	
		Set tSC=$$$EnsError($$$EnsDICOMDataElementNotFound,pPropertyReference)
	}
	Quit tSC
}

/// Create an instance of a file by loading its data from a document. Note that this will create a file with meta data
/// which contains OUR implementation version and id. These can be overwritten if required
ClassMethod CreateFromDocument(pDocument As EnsLib.DICOM.Document, Output pDicomFile As EnsLib.DICOM.File) As %String
{
	#dim tSC As %Status = $$$OK
	#dim tFileStream As %Stream.FileBinary
	#dim tTransferSyntax As %String
	try {
		
		#; Create an instance of a File binary stream
		Kill %objlasterror Set tFileStream=##Class(%Stream.FileBinary).%New()
		If '$IsObject(tFileStream) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"%Stream.FileBinary")) Quit
	
		#; Get the transfer syntax of the dataset
		Set tTransferSyntax=pDocument.DataSet.TransferSyntax
		
		#; Compose the dataset document onto the temporary stream
		Set tSC=pDocument.DataSet.ComposeStream(tFileStream,tTransferSyntax)
		If $$$ISERR(tSC) Quit
		
		#; Now create the file from the dataset file stream
		Set tSC=..CreateFromDataSetFileStream(tFileStream,tTransferSyntax,.pDicomFile)
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Create an instance of a DICOM file by loading it's data from the specified file. The file MUST contain data in
/// the DICOM File Format (See PS 3.10 - Media Storage and File Format for Media Interchange). If the file doesn't have
/// the DICM header then we can't load the dataset as we donot know for sure what the transfer syntax is !
ClassMethod CreateFromDicomFile(pFileName As %String, Output pDicomFile As EnsLib.DICOM.File) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tFileStream As %Stream.FileBinary
	do {
		
		#; Test for file existence
		If '##class(%File).Exists(pFileName) Set tSC=$$$EnsError($$$FileDoesNotExist,pFileName) Quit
		
		#; Create an instance of a File binary stream
		Kill %objlasterror Set tFileStream=##Class(%Stream.FileBinary).%New()
		If '$IsObject(tFileStream) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"%Stream.FileBinary")) Quit
	
		#; Set the file name of the stream
		Set tFileStream.Filename=pFileName
			
		#; Delegate
		Set tSC=..CreateFromDicomFileStream(tFileStream,.pDicomFile)
	
	} while (0)
	Quit tSC
}

/// Create an instance of a DICOM file by loading it's data from the specified file binary stream. The file should contain data in
/// the DICOM File Format (See PS 3.10 - Media Storage and File Format for Media Interchange). If the file doesn't have
/// the DICM header then we can't load the dataset as we donot know for sure what the transfer syntax is !
ClassMethod CreateFromDicomFileStream(pFileStream As %FileBinaryStream, Output pDicomFile As EnsLib.DICOM.File) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tValueLen As %Integer
	#dim tBytes As %String
	do {
		
		#; Create a StreamAdapter and wrap the provided stream, this gives us the ability to query the streams position
		Kill %objlasterror Set tStream=##class(EnsLib.DICOM.Util.InputStreamAdapter).%New(pFileStream)
		If '$IsObject(tStream) {
			Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.InputStreamAdapter")) Quit
		}
		
		#; Create an instance of a DICOM file
		Kill %objlasterror Set pDicomFile=##Class(EnsLib.DICOM.File).%New()
		If '$IsObject(pDicomFile) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.File")) Quit
	
		#; Decompose the file-format data stream
		Set tSC=pDicomFile.DecomposeFileStream(tStream)
		
	} while (0)
	Quit tSC
}

/// Create an instance of a DataSet file by loading it's data from the specified file. The file MUST contain a DICOM
/// dataset ( without the DICOM header ). The Transfer Syntax MUST be known to guarantee data integrity
ClassMethod CreateFromDataSetFile(pFileName As %String, pTransferSyntax As %String, Output pDicomFile As EnsLib.DICOM.File) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tFileStream As %Stream.FileBinary
	do {
		
		#; Test for file existence
		If '##class(%File).Exists(pFileName) Set tSC=$$$EnsError($$$FileDoesNotExist,pFileName) Quit
		
		#; Create an instance of a File binary stream
		Kill %objlasterror Set tFileStream=##Class(%Stream.FileBinary).%New()
		If '$IsObject(tFileStream) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"%Stream.FileBinary")) Quit
	
		#; Set the file name of the stream
		Set tFileStream.Filename=pFileName
			
		#; Delegate
		Set tSC=..CreateFromDataSetFileStream(tFileStream, pTransferSyntax, .pDicomFile)
	
	} while (0)
	Quit tSC
}

/// Load a file from a data-set format binary stream. The Transfer Syntax MUST be known to guarantee data integrity
ClassMethod CreateFromDataSetFileStream(pStream, pTransferSyntax As %String, Output pDicomFile As EnsLib.DICOM.File) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim tStream As EnsLib.DICOM.Util.InputStreamAdapter
	#dim tMutableDataSet As EnsLib.DICOM.MutableDataSet
	#dim tContentHandler As EnsLib.DICOM.Util.ContentHandler
	#dim tSOPClassUID,tSOPInstanceUID As %String

	do {
		#; Create a StreamAdapter and wrap the provided stream, this gives us the ability to query the streams position
		Kill %objlasterror Set tStream=##class(EnsLib.DICOM.Util.InputStreamAdapter).%New(pStream)
		If '$IsObject(tStream) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.InputStreamAdapter")) Quit
		
		#; Create an instance of a DICOM file
		Kill %objlasterror Set pDicomFile=##Class(EnsLib.DICOM.File).%New()
		If '$IsObject(pDicomFile) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.File")) Quit
	
		#; Set the transfer syntax
		Set pDicomFile.TransferSyntax=pTransferSyntax
		
		#; Attempt to load the stream.
		Set tSC=pDicomFile.DecomposeDataSetStream(tStream,pTransferSyntax)
		If $$$ISERR(tSC) Quit
	
		#; Need the SOP Class ID
		Set tSOPClassUID=pDicomFile.GetValueAt("DataSet.(0008,0016)",,.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Set the Media Storage SOP Class UID
		Set tSC=pDicomFile.SetValueAt(tSOPClassUID,"MetaData.(0002,0002)")
		If $$$ISERR(tSC) Quit
		
		#; Need the SOP Instance ID
		Set tSOPInstanceUID=pDicomFile.GetValueAt("DataSet.(0008,0018)",,.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Set the MediaStorage SOP Instance UID
		Set tSC=pDicomFile.SetValueAt(tSOPInstanceUID,"MetaData.(0002,0003)")
		If $$$ISERR(tSC) Quit
		
	} while (0)
	Quit tSC
}

/// Decompose the data-set stream contents.
Method DecomposeFileStream(pStream As EnsLib.DICOM.Util.InputStreamAdapter) As %Status [ Internal, Private ]
{
	#dim tBytes,tTransferSyntax As %String
	#dim tValueLen As %Integer
	#dim tContentHandler As EnsLib.DICOM.Util.ContentHandler
	#dim tSC As %Status = $$$OK
	
	do {
	
		#; Read the pre-amble
		Set tValueLen=128,tBytes=pStream.Read(.tValueLen,.tSC) If $$$ISERR(tSC) Quit
		If tValueLen'=128 Set tSC=$$$EnsError($$$EnsDICOMInvalidFileFormat) Quit
		
		#; Record the pre-amble, we may need it for re-construction later
		Set ..Preamble=tBytes
		
		#; Read and discard the 'DICM' header
		Set tValueLen=4,tBytes=pStream.Read(.tValueLen,.tSC) If $$$ISERR(tSC) Quit
		If tValueLen'=4||(tBytes'="DICM") Set tSC=$$$EnsError($$$EnsDICOMInvalidFileFormat) Quit
		
		#; Create a content handler for the metadata
		Set tSC=..CreateContentHandler(.tContentHandler,..MetaData) If $$$ISERR(tSC) Quit
		
		#; Ask the MetaData to decompose the stream and populate its data
		Set tSC=..MetaData.DecomposeStream(pStream,$$$RAWDATAEXPLICITVRLTLENDIAN,tContentHandler) 
		If $$$ISERR(tSC) Quit
		
		#; Get the transfer syntax
		Set tTransferSyntax=..MetaData.GetValueAt("TransferSyntaxUID",,.tSC)
		If $$$ISERR(tSC) Quit
		
		$$$ASSERT(tTransferSyntax'="")
		
		#; Now decompose the data-set
		Set tSC=..DecomposeDataSetStream(pStream,tTransferSyntax)
	
	} while (0)
	
	Quit tSC
}

/// Decompose the data-set stream contents.
Method DecomposeDataSetStream(pStream As EnsLib.DICOM.Util.InputStreamAdapter, pTransferSyntax As %String) As %Status [ Internal, Private ]
{
	#dim tTransferSyntax As %String
	#dim tContentHandler As EnsLib.DICOM.Util.ContentHandler
	#dim tSC As %Status = $$$OK
	
	do {
	
		#; Create a new instance of a content handler for the dataset
		Set tSC=..CreateContentHandler(.tContentHandler,..MutableDataSet) If $$$ISERR(tSC) Quit
		
		#; Now decompose the stream
		Set tSC=..MutableDataSet.DecomposeStream(pStream,pTransferSyntax,tContentHandler)
		
	} while (0)
	
	Quit tSC
}

/// This methods composes the data to the specified (binary) stream
Method ComposeStream(pStream, pFormat) As %Status [ Internal, Private ]
{
	#dim tSC As %Status = $$$OK
	#dim tTransferSyntax As %String
	do {

		#; Get the transfer syntax from the data set
		Set tTransferSyntax=..TransferSyntax
		
		If pFormat=$$$FORMATFILE {
			
			#; Write out the preamble
			Set tSC=pStream.Write($$$PAD2LEN(..Preamble,128,$Char(0))) If $$$ISERR(tSC) Quit
		
			#; Write out the DICM header
			Set tSC=pStream.Write("DICM") If $$$ISERR(tSC) Quit
		
			#; The DataSet will be written with the specified Transfer Syntax
			Set tSC=..MetaData.SetValueAt(tTransferSyntax,"TransferSyntaxUID")
			If $$$ISERR(tSC) Quit
		
			#; Ask the meta data to compose its portion of the stream
			Set tSC=..MetaData.ComposeStream(pStream,$$$RAWDATAEXPLICITVRLTLENDIAN) If $$$ISERR(tSC) Quit
		}
		
		#; Ask the data set to compose its portion of the stream
		Set tSC=..MutableDataSet.ComposeStream(pStream,tTransferSyntax) If $$$ISERR(tSC) Quit
		
	} while (0)
	Quit tSC
}

/// This method composes the file data and saves it to the specified file. The Format argument determines
/// how the file is written. By default the file is written as a DICOM file including header data and file
/// metadata. If the format arguments is set to $$$FORMATDATA, then just the dataset is written to the file
Method Save(pFilename As %String, pFormat As %Integer = {$$$FORMATFILE}) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tStream,tPixelStream As %Library.FileBinaryStream
	#dim tChunk As %String
	
	do {
		Set pFilename=##class(%File).NormalizeFilename(pFilename)
		
		#; Create an instance of a file stream
		Kill %objlasterror Set tStream=##class(%Library.FileBinaryStream).%New()
		If '$IsObject(tStream) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"%Library.FileBinaryStream")) Quit
	
		#; Set the file name
		Set tStream.Filename=pFilename
		
		#; Compose the stream
		Set tSC=..ComposeStream(tStream,pFormat) If $$$ISERR(tSC) Quit
		
		#; Save it
		Set tSC=tStream.%Save()
		
	} while (0)
	Quit tSC
}

/// Helper method to create a content handler
ClassMethod CreateContentHandler(Output pContentHandler As EnsLib.DICOM.Util.ContentHandler, pData As EnsLib.DICOM.Util.Data) As %Status [ Internal ]
{
	#dim tContentHandler As EnsLib.DICOM.Util.ContentHandler
	
	#; Create a new instance of a content handler
	Kill %objlasterror
	If $Data(^EnsDICOM.Debug("content")) {
		Set tContentHandler=##class(EnsLib.DICOM.Util.ImportHandler).%New(pData)
		If '$IsObject(tContentHandler) Quit $Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.ContentHandler"))
		Set pContentHandler=##class(EnsLib.DICOM.Util.DebugHandler).%New(tContentHandler)
	}
	Else {
		Set pContentHandler=##class(EnsLib.DICOM.Util.ImportHandler).%New(pData)
	}
	If '$IsObject(pContentHandler) Quit $Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.ContentHandler"))
	
	Quit $$$OK
}

/// This methods dumps an xml representation of the datastructure to the current device. Elements have their tag, name, value representation
/// value multiplicity and length represented as attributes of the <element> xml tag. The data is the CACHE representation of the data value.
/// Note that the length attribute specifies the length of the data item's binary DICOM representation. Sequences and items within sequences 
/// additionally specify their cardinality, ie. now many members there are in the collection 
Method OutputXmlToDevice() As %Status
{
	#dim tSC As %Status = $$$OK
	do { 
		Write "<?xml version=""1.0"" ?>",!
		
		Write "<file-format>",!
		
		#; First output the meta-data
		Set tSC=..MetaData.OutputXmlToDevice() If $$$ISERR(tSC) Quit
		
		#; Then the dataset	
		Set tSC=..MutableDataSet.OutputXmlToDevice() If $$$ISERR(tSC) Quit
		
		Write "</file-format>",!
	} while (0)
	Quit tSC
}

/// This methods dumps an html representation of the datastructure to the current device.
Method OutputHtmlToDevice() As %Status
{
	#dim tSC As %Status = $$$OK
	do { 
		
		#; First output the meta-data
		Set tSC=..MetaData.OutputHtmlToDevice() If $$$ISERR(tSC) Quit
		
		#; Then the dataset	
		Set tSC=..MutableDataSet.OutputHtmlToDevice() If $$$ISERR(tSC) Quit
		
	} while (0)
	Quit tSC
}

/// This methods dumps a VDOC text representation of the datastructure to the current device.
Method OutputToDevice() As %Status
{
	#dim tSC As %Status = $$$OK
	do { 
		
		#; First output the meta-data
		Set tSC=..MetaData.OutputVDocToDevice() If $$$ISERR(tSC) Quit
		
		#; Then the dataset	
		Set tSC=..MutableDataSet.OutputVDocToDevice() If $$$ISERR(tSC) Quit
		
	} while (0)
	Quit tSC
}

/// This VDOC Compliant method gets the value of the given property.<br>
/// This is implemented by the document class.<br>
/// <var>pPropertyPath</var> contains the property path.<br>
/// For this class it is only applicable to the CommandSet and DataSet properties.<br>
/// pFormat can be defined or not. If defined it can take the values "",0 or 1.<br>
/// pFormat of "" is the same as not defined.<br>
/// pFormat of 0 means return an empty string and not an error if the value does not exist. <br>
/// pFormat of 1 means force an error if a value does not exist. <br>
Method GetValueAt(pPropertyPath As %String, pFormat As %String, Output pStatus As %Status, pDummy) As %String
{
	#dim tProperty,tTrailer,tRetVal As %String = ""
	#dim e As %Exception.AbstractException
	Try { 
		Set tProperty=$Piece(pPropertyPath,"."),tTrailer=$Piece(pPropertyPath,".",2,$Length(pPropertyPath,"."))
		If (tProperty="MetaData") {
			Set tRetVal=..MetaData.GetValueAt(tTrailer,.pFormat,.pStatus)
		} elseif (tProperty="DataSet") {
			Set tRetVal=..MutableDataSet.GetValueAt(tTrailer,.pFormat,.pStatus)	
		} else {	
			If $G(pFormat)=0 Set pStatus = $$$OK Quit
			Set pStatus=$$$EnsError($$$EnsDICOMDataElementNotFound,pPropertyPath)
		}
	} Catch e {
		Set pStatus = e.AsStatus()	
	}
	Quit tRetVal
}

/// This VDOC Compliant method sets the value of the given property.<br>
/// This is implemented by the document class.<br>
/// <var>pPropertyReference</var> contains the property name.<br>
/// <var>pAction</var> contains an action code: "set", etc..<br>
/// <var>pKey</var> contains an optional key value.<br>
/// For this class it is only applicable to the CommandSet and DataSet properties
Method SetValueAt(pValue As %String, pPropertyReference As %String, pAction As %String = "set", pKey As %String = "") As %Status
{
	#dim tTrailer,tProperty As %String = ""
	#dim tSC As %Status
	
	Set tProperty=$Piece(pPropertyReference,"."),tTrailer=$Piece(pPropertyReference,".",2,$Length(pPropertyReference,"."))
	If (tProperty="MetaData") {
		Set tSC=..MetaData.SetValueAt(pValue,tTrailer,pAction,pKey)
	} elseif (tProperty="DataSet") {
		Set tSC=..MutableDataSet.SetValueAt(pValue,tTrailer,pAction,pKey)		
	} else {	
		Set tSC=$$$EnsError($$$EnsDICOMDataElementNotFound,pPropertyReference)
	}
	Quit tSC
}

/// Load an instance of dicom file from the specified file and save to the specified output file
ClassMethod TestCreateFromDicomFile(pInputFilename As %String, pOutputFilename As %String)
{
	#dim tDicomFile As EnsLib.DICOM.File
	#dim tSC As %Status = $$$OK
	do {
		#; Create an instance of a DICOM file from the specified filename
		Set tSC=..CreateFromDicomFile(pInputFilename,.tDicomFile) If $$$ISERR(tSC) Quit
		
		#; Save the data to the specified file
		Set tSC=tDicomFile.Save(pOutputFilename)
		
	} while (0)
	If $$$ISERR(tSC) Do $System.Status.DisplayError(tSC)
}

/// When a file is created a storage location may be passed indicating where in the file system the external
/// data (if any) should be physically stored. The storage location is a directory name
Method %OnNew(initvalue As %RawString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	#dim tSC As %Status=$$$OK
	do {
		#; Create an instance of the MetaData
		Kill %objlasterror Set ..MetaData=##class(EnsLib.DICOM.MetaData).%New()
		If '$IsObject(..MetaData) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.MetaData")) Quit
	
		#; Create an instance of a MutableDataSet ( pass storage location)
		Kill %objlasterror Set ..MutableDataSet=##class(EnsLib.DICOM.MutableDataSet).%New($Get(initvalue))
		If '$IsObject(..MutableDataSet) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.MutableDataSet")) Quit
	
		#; Fill-in the file metadata version, this is a fixed value which is the same for all DICOM implementations
		Set tSC=..SetValueAt($$$FILEMETADATAVERSION,"MetaData.FileMetaInformationVersion") 
		
		#; Fill in our user implementation fixed fields. If the file is loaded from disk then these values will be overwritten
		#; which is the behavior we desire
		Set tSC=..MetaData.SetValueAt($$$OURUSERIMPLEMENTATIONCLASSUID,"ImplementationClassUID")
		If $$$ISERR(tSC) Quit
		
		Set tSC=..MetaData.SetValueAt($$$OURUSERVERSION,"ImplementationVersionName")
		If $$$ISERR(tSC) Quit
		
	} while (0)
	Quit tSC
}

/// This callback method is invoked by the <METHOD>%Close</METHOD> method to 
/// provide notification that the current object is being closed.
/// 
/// <P>The return value of this method is ignored.
Method %OnClose() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	#dim tSC As %Status = $$$OK
	try {
		#; This is NOT a persistent object, so clear out the temporary data structures
		Set tSC= ..MetaData.Clear() If $$$ISERR(tSC) Quit
		Set tSC= ..MutableDataSet.Clear() If $$$ISERR(tSC) Quit
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

}
