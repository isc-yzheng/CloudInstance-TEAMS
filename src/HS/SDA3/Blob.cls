/// Used to hold very long objects in the SDA
Class HS.SDA3.Blob Extends HS.SDA3.DataType
{

/// The blob stream is not actually stored in the streamlet's SDA string.  It is stored either
/// in a file, or in ^HS.SDA3.Blob.  This allows long data to be used without exceeding the 3MB
/// limit on total streamlet size.  When the streamlet is exported to a container, the HSBlobStream
/// does get included inline
Property HSBlobStream As %Stream.GblBinCompress;

/// Used internally - a pointer to the blob contents when stored in the database.
/// When stored in the streamlet database, we'll use a tag of $C(4) instead of the "HSBlobId"
/// to allow easy parsing of the SDA string, to allow it to insert the blob stream contents
/// from the place where it is stored.
Property HSBlobId As %Integer;

/// If the blob can be stored as a file, this will be the extension
Property FileType As %String;

/// Not stored
/// May be input as "D" as a delete instruction
/// Internally, we may temporarily set it to U to indicate that we're in the process of updating it
Property ActionCode As %String;

/// Not Stored
/// Used only on the original SDA input, to allow the contents of the HSBlobStream
/// to be loaded from an external file, instead of being input.
/// If used, this should be a fully qualified file reference, and HSBlobStream
/// should not be populated.
/// If supplied, the value of this property will be copied into OriginalFileReference.
Property LoadFromFile As %String(MAXLEN = 200);

/// For informational purposes, this will store whatever was input in LoadFromFile
Property OriginalFileReference As %String(MAXLEN = 200);

/// Override the generated method
Method UpdateSDA(pFromObject, pOmitProperties As %String = "", pIsDeleted As %Boolean = 0)
{
	If (pIsDeleted){
		Set ..FileType=""
		Set ..OriginalFileReference=""
		Do ..HSBlobStream.Clear(1)
	}
	Set val=pFromObject.FileType If val'="" Set ..FileType=$S(val="""""":"",1:val)
	Set val=pFromObject.OriginalFileReference If val'="" Set ..OriginalFileReference=$S(val="""""":"",1:val)
	If pFromObject.ActionCode="D" {Set ..ActionCode="D"}
	ElseIf pFromObject.IsDefined("HSBlobStream") {Do ..HSBlobStream.Clear(1),..HSBlobStream.CopyFrom(pFromObject.HSBlobStream) }
	Quit
}

/// Override the generated method
/// %HSBlobMode="ID" means only export the blob ID
/// %HSBlobMode="Save" means we're in the middle of saving a blob, so store it in the Blob store,
/// %HSBlobMode="Export" (or undef) means output the blob into the stream
/// If %HSStreamletBlobs is defined, we'll output to it a comma separated list of blob IDs
Method ToQuickXML(pTag As %String = "", pType As %String = "", pGroup = 0)
{
	Set tBlobMode=$G(%HSBlobMode,"Export")
	If tBlobMode="Save", ..ActionCode="D" {
		//delete the blob
		Do:..HSBlobId ..DeleteBlob(..HSBlobId) Quit
	}
	Set:pTag="" pTag="Blob"
	IF pType=""||(pType="Blob") {Write "<" ,pTag,">"}
	ElseIf pGroup {Set pTag="Blob" Write "<Blob>"}
	Else {Write "<",pTag," d5p1:type=""Blob"" xmlns:d5p1=""http://www.w3.org/2001/XMLSchema-instance"">"}
	Set val=..FileType If val'="",val'="""""" {Write "<FileType>",..FileType,"</FileType>"}
	Set val=..OriginalFileReference If val'="",val'="""""" {Write "<OriginalFileReference>",..OriginalFileReference,"</OriginalFileReference>"}
	If $D(%HSStreamletBlobs),..HSBlobId Set %HSStreamletBlobs=%HSStreamletBlobs_..HSBlobId_","
	If tBlobMode="Save" {
		Do:..HSBlobId ..DeleteBlob(..HSBlobId) //clear previous blob
		Do ..SaveBlob()
		W:..HSBlobId "<"_$C(4)_">",..HSBlobId,"</"_$C(4)_">"
	} ElseIf tBlobMode="Export" {
		Set val=..HSBlobStream,len=1200000
		If val'=""&&'val.IsNull() {
			Write "<HSBlobStream>" Do val.Rewind()
			While 'val.AtEnd { Write $system.Encryption.Base64Encode(val.Read(.len)) }
			Write "</HSBlobStream>"
		}
		Set val=..ActionCode If val'="",val'="""""" {Write "<ActionCode>",..ActionCode,"</ActionCode>"}
	} ElseIf tBlobMode="HSTrace" {
		//only write first part of blob to debug trace, to avoid blowing string limit
		Set val=..HSBlobStream
		If val'=""&&'val.IsNull() {
			Write "<HSBlobStream><![CDATA[" Do val.Rewind()
			Set qval=val.Read(12000) //arbitrary limit
			Set:'val.AtEnd qval=qval_". . . Trace truncated here."
			Write $Replace(qval,"]]>","]]]]><![CDATA[>")
			Write "]]></HSBlobStream>"
		}
	} Else {
		//blobmode ID
		Set val=..HSBlobId If val'="",val'="""""" {Write "<HSBlobId>",..HSBlobId,"</HSBlobId>"}
		Set val=..ActionCode If val'="",val'="""""" {Write "<ActionCode>",..ActionCode,"</ActionCode>"}
	}
	Write "</",pTag,">" Quit
}

/// Override the generated method
Method XMLImportSDAString(ByRef pSDAString, pTag = "", ByRef pPos = 1, pStreamlet = "", pContainer = "") As %Status
{
	Set tSC=1
	IF pTag="" Do PopTag Set pTag=tTag
	Set tMyEnd="/"_pTag
	For {
		Quit:('tSC)  Do PopTag Quit:tTag=tMyEnd
		If tTag=$C(4) {Do GetVal Set ..HSBlobId=val Do:pStreamlet ..FetchBlobToObject() Continue}
		If tTag'?1A.AN Continue:$E(tTag,*)="/"  Set tSC = $$Error^%apiOBJ(5001,"Bad Tag: "_tTag) Quit
		If tTag="FileType" {Do GetVal Set ..FileType=val CONTINUE}
		If tTag="OriginalFileReference" {Do GetVal Set ..OriginalFileReference=val CONTINUE}
		If tTag="LoadFromFile" {
			Do GetVal Continue:val=""
			Set ..OriginalFileReference=val
			Set ..HSBlobStream=##class(%Stream.GblBinCompress).%New()
			Set tFile=##class(%Stream.FileBinary).%New()
			Set tSC=tFile.LinkToFile(val) Quit:$$$ISERR(tSC)
			Do ..HSBlobStream.CopyFrom(tFile)
			Kill tFile Continue
		}
		If tTag="HSBlobStream" {
			//We really need to have a container to get the blob stream
			Set ..HSBlobStream=##class(%Stream.GblBinCompress).%New()
			For {
				Set f=$F(pSDAString,"<",pPos), tAtEnd=f
				If f {Set val=$E(pSDAString,pPos,f-2)}
				Else {
					//because we're running Base64Decode, each chunk length needs to be a multiple of 4
					Set f=$L(pSDAString),len=f-pPos+1,extra=len#4,val=$E(pSDAString,pPos,f-extra)
				}
				Do ..HSBlobStream.Write($system.Encryption.Base64Decode(val))
				Set pPos=$S(f:f,1:$L(pSDAString)-extra+1)
				If pContainer Do pContainer.FillBuffer(.pSDAString,.pPos)
				Quit:tAtEnd
			}
			Do PopTag Continue
		}
		If tTag="HSBlobId" {
			Do GetVal Set ..HSBlobId=val
			If val'="",$D(%HSAABlobInfo(val)) {
				//we're coming from GetNextStreamlet in HS.Gateway.Access.AnalyticsProcess
				Set tBlobInfo=%HSAABlobInfo(val) //oref to the pass in blob info structure
				Set ..HSBlobStream=##class(%Stream.GblBinCompress).%New()
				#dim tBlobInfo As HS.Types.BlobInfo
				Do ..HSBlobStream.CopyFrom(tBlobInfo.HSBlobStream)
			}
			Continue
		}
		If tTag="ActionCode" {Do GetVal Set ..ActionCode=val CONTINUE}
	}
	QUIT tSC
GetVal Set f=$F(pSDAString,"<",pPos),val=$E(pSDAString,pPos,f-2),pPos=f-1 Set:val["&" val=$ZCVT(val,"I","XML")
PopTag Set f=$F(pSDAString,">",pPos),tTag=$E(pSDAString,pPos+1,f-2),pPos=f G PopTag:$E(tTag,*)="/" Quit
}

ClassMethod DeleteBlob(pBlobId)
{
	If $D(^HS.SDA3.Blob(pBlobId,"FileDirectory")) {
		Set tDir=^HS.SDA3.Blob(pBlobId,"FileDirectory")
		Set tFileType=^HS.SDA3.Blob(pBlobId,"FileType")
		Set tFileName=##class(%File).NormalizeDirectory(tDir)_pBlobId_"."_tFileType
		Do ##class(%File).Delete(tFileName)
	}
	Kill ^HS.SDA3.Blob(pBlobId)
	Quit
}

Method SaveBlob()
{
	If '..IsDefined("HSBlobStream") Set ..HSBlobId="" Quit
	Do ..HSBlobStream.Rewind()
	Set:..HSBlobId="" ..HSBlobId=$I(^HS.SDA3.Blob)
	Set tDir=$G(^HS.SDA3.BlobFileDirectory)
	If ..FileType'="",tDir'="" {
		Set ^HS.SDA3.Blob(..HSBlobId,"FileType")=..FileType,^("FileDirectory")=tDir
		Set tFile=##class(%Stream.FileBinary).%New()
		Set tFile.Filename=##class(%File).NormalizeDirectory(tDir)_..HSBlobId_"."_..FileType
		Do tFile.CopyFrom(..HSBlobStream)
	} Else {
		Set val=..HSBlobStream,len=1200000,cnt=0 Do val.Rewind()
		While 'val.AtEnd { Set ^HS.SDA3.Blob(..HSBlobId,$I(cnt))=$System.Util.Compress(val.Read(.len)) }
		Set ^HS.SDA3.Blob(..HSBlobId,"C")=cnt
	}
}

/// Fetch a blob from streamlet storage and output it to ..HSBlobStream (a %Stream.GblBinCompress)
Method FetchBlobToObject()
{
	Set ..HSBlobStream=##class(%Stream.GblBinCompress).%New()
	If $D(^HS.SDA3.Blob(..HSBlobId,"FileDirectory")) {
		Set tDir=^HS.SDA3.Blob(..HSBlobId,"FileDirectory")
		Set tFileName=##class(%File).NormalizeDirectory(tDir)_..HSBlobId_"."_..FileType
		Set tFile=##class(%Stream.FileBinary).%New()
		Do tFile.LinkToFile(tFileName)
		Do ..HSBlobStream.CopyFrom(tFile)
	} Else {
		For tI=1:1:$G(^HS.SDA3.Blob(..HSBlobId,"C")) Do ..HSBlobStream.Write($System.Util.Decompress(^HS.SDA3.Blob(..HSBlobId,tI)))
	}
}

/// Fetch a blob from streamlet storage and output it to the specified SDA strean stream
ClassMethod FetchBlobToStream(pBlobId, ByRef pSDAStream)
{
	If $D(^HS.SDA3.Blob(pBlobId,"FileDirectory")) {
		Set tDir=^HS.SDA3.Blob(pBlobId,"FileDirectory")
		Set tFileType=^HS.SDA3.Blob(pBlobId,"FileType")
		Set tFileName=##class(%File).NormalizeDirectory(tDir)_pBlobId_"."_tFileType
		Set tFile=##class(%Stream.FileBinary).%New()
		Do tFile.LinkToFile(tFileName), tFile.Rewind()
		Set len=1200000 //must be multiple of 3
		While 'tFile.AtEnd {Do pSDAStream.Write($system.Encryption.Base64Encode(tFile.Read(.len)))}
	} Else {
		For tI=1:1:$G(^HS.SDA3.Blob(pBlobId,"C")) Do pSDAStream.Write($system.Encryption.Base64Encode($System.Util.Decompress(^HS.SDA3.Blob(pBlobId,tI))))
	}
}

Storage Default
{
<Data name="BlobState">
<Subscript>"Blob"</Subscript>
<Value name="1">
<Value>HSBlobStream</Value>
</Value>
<Value name="2">
<Value>HSBlobId</Value>
</Value>
<Value name="3">
<Value>ActionCode</Value>
</Value>
<Value name="4">
<Value>FileType</Value>
</Value>
<Value name="5">
<Value>LoadFromFile</Value>
</Value>
<Value name="6">
<Value>OriginalFileReference</Value>
</Value>
</Data>
<State>BlobState</State>
<Type>%Storage.Serial</Type>
}

}
