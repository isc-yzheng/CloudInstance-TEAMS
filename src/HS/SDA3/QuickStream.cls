/// Stream class that stores character data in global nodes.<br>
/// This is cloned from %Stream.GlobalCharacter, for use for quick messaging.
/// Both the temporary and stored version of the stream are stored in the same
/// place, usually ^CacheTemp.HS.Stream(Id).  The Id is assigned when the stream is created,
/// and the creator can pass in an ID as an argument to %New.<br>
/// Unlike %Stream.GlobalCharacter, this never participates in a transaction,
/// and is never journaled.  This drastically reduces both journal usage and contention,
/// eliminating performance delays.<br>
/// Optionally, one of these can be created using %New(,0).  This is a hybrid usage, which stores
/// both the temporary and stored versions in ^HS.Stream(id).  It's somewhat slower, since this is
/// journalled, but it's still used outside the scope of transactions, and the stream ID can be
/// passed around in Ensemble messages to avoid repeated saving of the stream.  This variation
/// should be used, for instance, with Async messaging of inbound data, where the stream needs to
/// survive a machine crash.
Class HS.SDA3.QuickStream Extends %Stream.Object [ ClassType = stream, ClientDataType = CHARACTERSTREAM, OdbcType = LONGVARCHAR ]
{

Parameter READNODATA [ Final ] = 0;

Parameter READNOTCHANGED [ Final ] = 1;

Parameter READCHANGED [ Final ] = 2;

Parameter WRITE [ Final ] = 3;

Property Mode As %Integer [ InitialExpression = 0, Private ];

/// Number of characters that we are storing in each global node
Parameter BUFFERLEN = 32000;

Property TempNode As %Integer [ Private, Transient ];

/// will either be of form ^CacheTemp.HS.Stream(number) or
/// ^HS.Stream(number)
Property GRef As %String;

/// The current node we are reading from.
Property NodeNo As %String(MAXLEN = 5000) [ InitialExpression = 0, Private, Transient ];

Property Buffer As %Binary(MAXLEN = "") [ Private, Transient ];

Property Position As %Integer [ InitialExpression = 1, Private, Transient ];

Property IOSize As %Integer [ InitialExpression = 0, Private ];

/// Type of line terminator we use for this stream, defaults to Cr/Lf. Maximum length is 10 characters.
Property LineTerminator As %String(MAXLEN = 10) [ InitialExpression = {$char(13,10)}, Transient ];

Method %NormalizeObject() As %Status [ CodeMode = expression ]
{
$$$OK
}

Method %ValidateObject(force As %Integer = 0) As %Status [ CodeMode = expression ]
{
$$$OK
}

Property mLastModified As %String [ Private, Transient ];

/// Returns true if this is a "NULL" stream; that is, a stream which has never 
/// been written to and saved. This is used by the Cach&eacute; ODBC server.
Method IsNull() As %Boolean [ CodeMode = expression ]
{
..Mode=..#READNODATA
}

Method LastModifiedGet() As %TimeStamp [ CodeMode = expression, Final ]
{
$zdt($select(..mLastModified="":$ZTimeStamp,1:..mLastModified),3)
}

/// When creating a new one, optional arg 1 is the ID to use.  If you are passing this in,
/// be sure to coordinate it with arg 2.  If arg2 =1 (or null), then the ID must start with "T"
/// to indicate that it lives in CacheTemp.
/// Optional argument 2 - if 0, then instead of using CacheTemp, will use a regular global,
/// in order to make this use recoverable after a system crash
Method %OnNew(pID As %String = "", pTemp = 1) As %Status [ Private ]
{
	Do ..Initialize(pID,pTemp)
	Quit $$$OK
}

/// This will only work for cloning another QuickStream. This will also clone the storage global (cache temp vs. regular)
Method %OnConstructClone(object As %RegisteredObject, deep As %Boolean = 0, ByRef cloned As %String) As %Status [ Private ]
{
	Do ..Initialize(,$E(object.%Id)="T")
	If object.Mode=..#READNODATA Quit $$$OK
	Set glv=object.GRef
	Merge:glv'="" @i%GRef=@glv
	If i%Mode=..#READNOTCHANGED Set i%Mode=..#READCHANGED
	Quit $$$OK
}

Method Initialize(pID = "", pTemp = 1)
{
	Set i%AtEnd=1,i%%Location=$S(pTemp:"^CacheTemp.HS.Stream",1:"^HS.Stream")
	Set i%TempNode=$S(pID="":$S(pTemp:"T",1:"")_$increment(@i%%Location),1:pID), i%Id=i%TempNode
	Set i%GRef=i%%Location_"("""_i%Id_""")"
	If (pID '= "") Do ..Clear(0)
}

Method %OnClose() As %Status [ Private ]
{
	Quit ..Flush()
}

Method %LoadData(id As %String) As %Status [ Private ]
{
	Set i%Id = id
	If i%%Location="" {
		Set i%%Location=$S($E(id)="T":"^CacheTemp.HS.Stream",1:"^HS.Stream")
		Set i%TempNode=id,i%Id=id,i%GRef=i%%Location_"("""_i%Id_""")"
	}

	If id="" {
		Set i%Mode=..#READNODATA,i%AtEnd=1,i%IOSize=0
	} Else {
		#; read size from "0" node, if present, if not calculate it
		If '$data(@(i%%Location)@(id,0),size) {
			Set size=0,i=0 For  Set data="",i=$order(^(i),1,data) Quit:i=""  Set size=size+$length(data)
		}
		Set i%IOSize=size,i%AtEnd='size,i%Mode=..#READNOTCHANGED
	}
	Quit $$$OK
}

Method GSave(related) As %Status
{
	#; save the stream;
	If i%Mode=..#READNODATA||(i%Mode=..#READNOTCHANGED) Quit $$$OK
	Do ..Flush()
	
	#; save size in "0" node
	Set @(i%GRef)@(0)=i%IOSize
	
	Set i%Mode=..#READNOTCHANGED
	Set i%NodeNo=0,i%Position=1,i%Buffer="",i%AtEnd=0

	Quit $$$OK
}

Method %SaveData(ByRef sid As %String) As %Status [ Private ]
{
	Quit $$$OK  //not relevant
}

/// [Previously private]
ClassMethod %DeleteData(streamvalue As %String, concurrency As %Integer) As %Status
{
	Quit $$$OK //not relevant
}

Method Read(ByRef len As %Integer = 32000, ByRef sc As %Status) As %Library.RawString
{
	Set sc=$$$OK
	#; Mode ..#READNODATA: no data 
	If (i%Mode=..#READNODATA) Set i%AtEnd=1,len=-1 Quit ""
	#; Mode ..#WRITE: in middle of Write with no rewind; automatically rewind
	If i%Mode=..#WRITE Do ..Rewind()
	If i%AtEnd Set len=-1 Quit ""
	
	Set:len>$$$MaxLocalLength len=$$$MaxLocalLength
	
	#; try to read from i%Buffer
	Set done=0,out=""
	For  Do  Quit:done=1
	#; do we need to read another chunk from global
	. If i%Position>$length(i%Buffer),..ReadIntoBuffer()=0 Set done=1 Quit
	. Set needed=len-$length(out),out=out_$extract(i%Buffer,i%Position,i%Position+needed-1),i%Position=i%Position+needed
	. If $length(out)'<len Set done=1
	#; Fill the buffer here so we can set AtEnd flag without another round trip
	If 'i%AtEnd,i%Position>$length(i%Buffer) Do ..ReadIntoBuffer()
	
	#;if we are at the end with no data return -1
	Set len=$select((i%AtEnd=1)&($length(out)=0):-1,1:$length(out))
	
	Quit out
}

Method ReadLine(ByRef len As %Integer = 32000, ByRef sc As %Status, ByRef eol As %Boolean) As %Library.RawString
{
	Set sc=$$$OK,eol=0
	#; Mode ..#READNODATA: no data 
	If (i%Mode=..#READNODATA)||(i%AtEnd=1) Set i%AtEnd=1,len=-1 Quit ""
	
	Set:len>$$$MaxLocalLength len=$$$MaxLocalLength
	
	#; Mode ..#WRITE: in middle of Write with no rewind; automatically rewind
	Do:i%Mode=..#WRITE ..Rewind()
	
	#; try to read from i%Buffer
	Set done=0,out="",terminator=..LineTerminator
	For  Do  Quit:done  Quit:$L(out)'<len
	#; do we need to read another chunk from global
	. If i%Position>$L(i%Buffer),..ReadIntoBuffer()=0 Set done=1 Quit
	#; Need to allow for the line terminator to be at the end of the current read section
	. Set needed=len-$L(out),out=out_$E(i%Buffer,i%Position,i%Position+needed-1+$L(terminator))
	. Set found=$F(out,terminator)
	. If found Do  Quit
	#; Set the current position just after the terminator, set the output to the text just before the terminator
	#; (len-needed) give me the previous length of 'out' before we appended more data to it.
	. . Set i%Position=i%Position+found-1-(len-needed)
	. . Set out=$E(out,1,found-$L(terminator)-1)
	. . Set done=1,eol=1
	. Set i%Position=i%Position+needed
	#; Reading the next chunk into the buffer will also set AtEnd flag is we are at the end
	If i%Position>$length(i%Buffer) Do ..ReadIntoBuffer()
	
	#;if we are at the end with no data return -1
	Set len=$S((i%AtEnd=1)&&(out=""):-1,$L(out)>len:len,1:$L(out))

	Quit $E(out,1,len)
}

/// This reads from the stream until it find the <property>LineTerminator</property> and returns
/// this as a stream. If the stream does not contain the line terminator this can potentially be the
/// entire stream.
Method ReadLineIntoStream(ByRef sc As %Status) As %Stream.Object
{
	Set sc=$$$OK,stream=..%New()
	#; Mode ..#READNODATA: no data 
	If (i%Mode=..#READNODATA)||(i%AtEnd=1) Set i%AtEnd=1 Quit stream
	
	#; Mode ..#WRITE: in middle of Write with no rewind; automatically rewind
	Do:i%Mode=..#WRITE ..Rewind()
	
	#; try to read from i%Buffer
	Set done=0,out="",terminator=..LineTerminator
	For  Do  Quit:done
	#; do we need to read another chunk from global
	. If i%Position>$L(i%Buffer),..ReadIntoBuffer()=0 Set done=1 Quit
	#; Need to allow for the line terminator to be at the end of the current read section
	. Set needed=$$$MaxStringLength-$L(out),out=out_$E(i%Buffer,i%Position,i%Position+needed-1+$L(terminator))
	. Set found=$F(out,terminator)
	. If found Do  Quit
	#; Set the current position just after the terminator, set the output to the text just before the terminator
	#; (len-needed) give me the previous length of 'out' before we appended more data to it.
	. . Set i%Position=i%Position+found-1-($$$MaxStringLength-needed)
	. . Set out=$E(out,1,found-$L(terminator)-1)
	. . Set done=1
	. Set i%Position=i%Position+needed
	. Do stream.Write($extract(out,1,$length(out)-$length(terminator)+1)) Set out=$extract(out,$length(out)-$length(terminator)+2,*)
	#; Reading the next chunk into the buffer will also set AtEnd flag is we are at the end
	If i%Position>$length(i%Buffer) Do ..ReadIntoBuffer()
	Do:out'="" stream.Write(out)
	Quit stream
}

Method Write(data As %Library.RawString = "") As %Status
{
	#; Mode = ..#READNODATA,..#READNOTCHANGED: set up for write, rewind
	If i%Mode'=..#WRITE {
		Do ..Rewind()
		If i%Mode=..#READCHANGED Kill @i%GRef
		Set i%Mode=..#WRITE,i%IOSize=0
	}
	
	#; a write is always at the end
	Set i%AtEnd=1,i%IOSize=i%IOSize+$length(data),..mLastModified=$ZTimeStamp
	
	#; if it fits, append data to Buffer
	Set bufneed=..#BUFFERLEN-$Length(i%Buffer)
	If bufneed'<$length(data) Set i%Buffer=i%Buffer_data Quit $$$OK

	#; otherwise store Buffer to global
	Set batch=$zu(68,25,1)
	
	Set @i%GRef@($I(@i%GRef))=i%Buffer_$extract(data,1,bufneed),data=$extract(data,bufneed+1,*)

	While $length(data)>..#BUFFERLEN {	
		Set @i%GRef@($I(@i%GRef))=$extract(data,1,..#BUFFERLEN)
		Set data=$extract(data,..#BUFFERLEN+1,*)
	}
	Do:batch=0 $zu(68,25,0)

	Set i%Buffer=data
	Quit $$$OK
}

/// Appends the string <var>data</var> along with a line terminator to the stream and advances the 
/// current stream position by the number of characters in <var>data</var> plus the line terminator.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method WriteLine(data As %Library.RawString = "") As %Status [ CodeMode = expression ]
{
..Write(data_..LineTerminator)
}

Method MoveToEnd() As %Status
{
	#; If no data or in write mode already nothing to do
	If (i%Mode=..#READNODATA)||(i%Mode=..#WRITE) Quit $$$OK
	
	#; Copy the permanent data into temporary structure ready for appending
	Set i%Mode=..#WRITE,i%Buffer="",i%Position=1
	
	#; a write is always at the end
	Set i%AtEnd=1
	
	Quit $$$OK
}

Method Rewind() As %Status
{
	#; Mode ..#WRITE: Flush
	If i%Mode=..#WRITE Do ..Flush() Set i%Mode=..#READCHANGED
	Set i%NodeNo=0,i%Position=1,i%Buffer="",i%AtEnd=0
	Set:i%Mode=..#READNODATA i%AtEnd=1
	Quit $$$OK
}

Method Flush() As %Status
{
	If i%Mode'=..#WRITE||((i%Buffer)="") Quit $$$OK
	#; Turn on batch mode so writing stream does not kill the cache
	Set batch=$zu(68,25,1)
	While i%Buffer'="" {	
		#; Move to next node, write data
		Set @i%GRef@($I(@i%GRef))=$extract(i%Buffer,1,..#BUFFERLEN)
		Set i%Buffer=$extract(i%Buffer,..#BUFFERLEN+1,*)
	}
	Do:batch=0 $zu(68,25,0)
	Quit $$$OK
}

// Size attribute

/// Return the current size of the data stream. 
Method SizeGet() As %Integer [ CodeMode = expression ]
{
i%IOSize
}

/// Reads the next node into Buffer.
/// <p>Returns 0 if there is no more data.
Method ReadIntoBuffer() As %Boolean [ Private ]
{
	If i%Mode=..#READNOTCHANGED {
		#; Turn on batch mode so reading stream does not kill the cache
		Set batch=$zu(68,25,1)
		Set i%NodeNo=$order(@(i%GRef)@(i%NodeNo),1,newval)
		Do:batch=0 $zu(68,25,0)
	} Else {
		Set i%NodeNo=$order(@(i%GRef)@(i%NodeNo),1,newval)
	}
	Set i%Buffer=$get(newval),i%Position=1
	#; test for no more data
	If i%NodeNo="" Set i%AtEnd=1,i%NodeNo=0 Quit 0
	Quit 1
}

Method CopyFrom(source As %Stream.Object) As %Status
{
	Quit:source=$$$NULLOREF $$$ERR($$$OrefInvalid)
	Set sc=$$$OK
	#; Optimise for copy from one global to another
	#; %IsA does not pick up multiple inheritance so we can not test for %GlobalStreamAdapter :-(
	// For quickstreams
	If $classname(source)=$classname() Do
	. Do source.GSave()
	. Set sourceGlvn=source.GRef
	#; Update the last modified timestamp
	. Set ..mLastModified=$ZTimeStamp
	
	#; If this is replacing the old data we can use a merge
	. If i%Mode'=..#WRITE Do
	#; clear temp to prepare for write to same location as last write
	. . If i%Mode=..#READCHANGED Kill @i%GRef
	#; Copy the data and setup the properties
	. . If sourceGlvn'="" Merge @i%GRef=@sourceGlvn Kill @(i%GRef)@(0)
	. . Set i%Mode=..#WRITE
	. . Set i%IOSize=source.Size
	. . Set i%Buffer=""
	
	#; Else we can $O through the global using the three parameter loop which is faster than the generic
	#; copy mechanism, and add the new information to the end of the current data.
	. Else  If sourceGlvn'="" Do
	. . If i%Buffer'="" Do ..Flush()
	. . Set newNode=$Increment(@i%GRef)-1
	. . Set sourceNode=0
	. . For  Set sourceNode=$order(@sourceGlvn@(sourceNode),1,sourceVal) Quit:sourceNode=""  Set @(i%GRef)@(sourceNode+newNode)=sourceVal
	. . Set @i%GRef=$order(@(i%GRef)@(""),-1)
	. . Set i%IOSize=i%IOSize+source.Size
	
	#; Else use the generic copy mechanism
	Else  Do
	. Set sc1=$$$OK,sc2=$$$OK
	. Do source.Rewind()
	. For  Quit:source.AtEnd  Set sc1=..Write(source.Read(,.sc2)) If $$$ISERR(sc1) { Set sc=sc1 Quit } ElseIf $$$ISERR(sc2) { Set sc=sc2 Quit }	
	. Do ..Flush()

	If $$$ISERR(sc) Quit sc

	#; Now copy the LineTerminator attribute
	If source.%Extends("%Library.AbstractStream") || source.%Extends("%Stream.GlobalCharacter") || source.%Extends("HS.SDA3.QuickStream") {
		Set ..LineTerminator=source.LineTerminator
	}
	
	Quit sc
}

Method CopyFromAndSave(source As %Stream.Object) As %Status
{
	Set tSC=..CopyFrom(source)
	Set:$$$ISOK(tSC) tSC=..GSave()
	Quit tSC
}

Method OutputToDevice(ByRef len As %Integer = -1) As %Status
{
	Set $Ztrap="OutputError"
	If (i%Mode=..#READNODATA)||(i%AtEnd=1) Set i%AtEnd=1,len=-1 Quit $$$OK
	If len=0 Quit $$$OK
	If i%Position=1,i%NodeNo=0,len=..Size Set len=-1
	Set sc=$$$OK
	If len=-1 Do
	#; Note that Rewind turns off WRITE mode so we do not need to test for this
	. Do ..Rewind()
	. Set glvn=i%GRef
	. Set node=0
	. For  Set node=$O(@glvn@(node),1,data) Quit:node=""  Write data
	. Set len=..Size
	
	#; Else write out just part of the global
	Else  Do
	#; Mode ..#WRITE: in middle of Write with no rewind; automatically rewind
	. If i%Mode=..#WRITE Do ..Rewind()
	
	. Set written=0
	
	#; If they only want less than in the current buffer so give it to them
	. If len<($L(i%Buffer)-i%Position+2) Do
	. . Write $E(i%Buffer,i%Position,i%Position+len-1)
	. . Set i%Position=i%Position+len
	. . Set written=len
	
	#; Else they want more than in the buffer
	. Else  Do
	#; Output the buffer to start with
	. . Write $E(i%Buffer,i%Position,$L(i%Buffer))
	. . Set written=written+$L(i%Buffer)-i%Position+1
	
	. . Set glvn=i%GRef
	. . Set node=i%NodeNo
	. . For  Set node=$O(@glvn@(node),1,data) Quit:node=""  Quit:written+$L(data)>len  Write data Set written=written+$L(data)
	. . Set i%NodeNo=$S(node="":0,1:node)
	
	#; End of stream
	. . If node=""  Set i%AtEnd=1,i%Buffer="",i%Position=1 Quit
	
	#; Now write out the final data
	. . Write $extract(data,1,len-written)
	. . Set i%Buffer=data
	. . Set i%Position=len-written+1
	. . Set written=len
	
	#; Check if we are at the end
	. If 'i%AtEnd,i%Position>$length(i%Buffer) Do ..ReadIntoBuffer()
	
	#;if we are at the end with no data return -1
	. Set len=$S((i%AtEnd=1)&(written=0):-1,1:written)
	
	Quit sc
OutputError	Quit $$$ERROR($$$ObjectScriptError,$ZE)
}

Method Clear(permanent As %Boolean = 1) As %Status
{
	#; Get rid of the attributes first
	Set ..mLastModified=$ZTimeStamp
	If i%Mode=..#READNODATA Quit $$$OK
	If i%Mode=..#WRITE Do ..Rewind()
	Kill @i%GRef
	Set i%Mode=..#READNODATA
	// for a permanent clear, this will completely diswable the quickstream.  Any OREFs are then meaningless
	If permanent {Set i%Id="",i%GRef="",i%TempNode=""}
	Set i%Buffer="",i%Position=1,i%NodeNo=0,i%IOSize=0,i%AtEnd=1
	Quit $$$OK
}

ClassMethod %Exists(soid As %ObjectIdentity) As %Boolean
{
	Quit 0 //not relevant
}

ClassMethod TestCopy()
{
	Set tSC=$$$OK
FN	R !,"Enter Input File Name: ",tFileName Quit:tFileName=""  GoTo FN:tFileName["*"
	Set tFile=##Class(%File).%New(tFileName)
	Set tSC=tFile.Open("RU")
	IF $$$ISERR(tSC) { W !,"Error Opening: ",$system.Status.GetErrorText(tSC) Quit  }
	Set tQuick1=..%New()
	Set tSC=tQuick1.CopyFrom(tFile) Break:$$$ISERR(tSC)
	Set tID1=tQuick1.%Id()
	Kill tQuick1
	Set tQuick2=..%New(,0)
	Set tID2=tQuick2.%Id()
	Set tQuick1a=..%OpenId(tID1)
	Set tSC=tQuick2.CopyFrom(tQuick1a) Break:$$$ISERR(tSC)
	Kill tQuick2
	Set tQuick2a=..%OpenId(tID2)
	Set tGStream=##class(%Stream.GlobalCharacter).%New()
	Set tSC=tGStream.CopyFrom(tQuick2a) Break:$$$ISERR(tSC)
FN2	R !,"Enter Output File Name: ",tFileName Quit:tFileName=""  GoTo FN2:tFileName["*"
	Set tStream=##Class(%GlobalCharacterStream).%New()
	Do ##class(%File).Delete(tFileName)
	Set tFile=##Class(%File).%New(tFileName)
	Do tFile.Open("WSN")
	Do tFile.CopyFrom(tGStream)
	Do tFile.%Save()
	w !,"^CacheTemp.HS.Stream ID: ",tID1
	w !,"^HS.Stream ID: ",tID2
	Break  //all set except for cleanup
	Do tQuick1a.Clear(1),tQuick2a.Clear(1)
	W !,"Done"
}

}
