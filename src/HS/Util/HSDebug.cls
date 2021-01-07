/// Class to log debug information throughout HealthShare.
/// Activate by setting macro HSDebug in HS.Common.inc
Class HS.Util.HSDebug Extends %Persistent
{

Property DateTime As %TimeStamp;

/// Description of where the log occurred (eg label + offset)
Property Place As %String(MAXLEN = 200);

/// Component where it occurred (eg class name)
Property Component As %String(MAXLEN = 200);

/// The message id (if any) (or oref text string like 17@User.Test)
Property Message As %String(MAXLEN = 200);

/// The debug text, if any
Property Text As %String(MAXLEN = "");

/// The file containing the stream, if any
Property FileName As %String(MAXLEN = 200);

/// Place = location inside component, often label or method name
/// Component = full name of component, e.g. "HS.Hub.HubOperataions"
/// Type = Currently only used to provide extension for stream file
/// Text = text to log.  if >30 chars will be written to a file HSDebug<nnn>.txt
/// Message (optional) = oref of message object, if body logs the header
///        else logs the message content as xml file
/// Stream (optional) = oref of %CharacterStream
///         will save the stream as file HSDebug<nnn>.<Type>
ClassMethod Debug(Place As %String, Component As %String, Type As %String, Text As %String = "", Message As EnsLib.HL7.Message = "", Stream As %GlobalCharacterStream = "")
{
 set $zt="Error",ok=1,currentio=$IO
 set d=..%New(),d.Place=$g(Place),d.Component=$g(Component)
 set d.DateTime=$zdt($zutil(188),3,,4)
 set d.Text=Text
 set ok=d.%Save()
 if ok {
	if $IsObject(Message) {
		do {
			// first try to handle as Ensemble message
			set bid=Message.%Id() // message body id
			if bid'="" {
				&sql(select id into :hid from Ens.MessageHeader
					where MessageBodyId=:bid)
				if 'SQLCODE set d.Message=hid quit}
			// then try to export as XML to stream
				set class=Message.%ClassName(1)
				if ##class(%Dictionary.CompiledMethod).%ExistsId(class_"||XMLExportToStream") {
					do Message.XMLExportToStream(.Stream,class,",indent")
					set Type="xml" quit
				}
			// else just save it
			set d.Message=Message}
		while 0}
	if $IsObject(Stream) {
		set file="HSDebug"_d.%Id()_"."_$s($g(Type)="":"txt",1:Type)
		open file:"WNS" use file do Stream.Rewind(),Stream.OutputToDevice(),Stream.Rewind() close file
		set d.FileName=file}
	else {
		if $l(Text)>34 {
			set f=##class(%File).%New(),f.Name="HSDebug"_d.%Id()_".txt"
			do f.Open("wns"),f.WriteLine(Text),f.Close()
			set d.FileName=f.Name}}
	set ok=d.%Save()
 }
 if 'ok goto Error
 use currentio
 quit
Error set $zt="Error2",ze=$ze
 if $d(file) close file
 set d.Place="Debug",d.Component=..%ClassName(1)
 set d.Message=""
 if 'ok {set d.Text=$system.Status.GetErrorText(ok)}
 else {set d.Text=ze}
 do d.%Save()
 use currentio
 quit
Error2 set $zt="" // error within error - give up
 use currentio
 quit
}

/// Display HSDebug
/// Device="" or 0   : Display on terminal, 80-chars wide
/// Device=<filename>: Output to <filename> with wider columns
ClassMethod Show(Device)
{
 set $zt="err",wide=0
 set Device=$g(Device) if Device="" set Device=0
 if Device'=0 {open Device:"wns" use Device set wide=1}
 set sc=..ExtentExecute(.qh)
 if wide {
	write !,"Time",?13,"Place",?34,"Component",?61,
		"Msg#/File",?77,"Text"
	write !,"------------",?13,"--------------------",?34,"--------------------------",?61,
		"-------------",?77,"-------------------------------------------------"	 
 }
 else {
	write !,"Time",?9,"Place",?22,"Component",?41,
		"Text",?66,"Msg#/File"
	write !,"--------",?9,"----------",?22,"----------------",?41,
		"------------------------",?66,"--------------"
 }
 for {
	set sc=..ExtentFetch(.qh,.row,.atend) quit:row=""!'sc
	set id=$listget(row),d=..%OpenId(id)
	set time=$p(d.DateTime," ",2),comp=d.Component
	set mf=d.Message,text=d.Text
	if $l(d.FileName) set mf=mf_$s($l(mf):"/",1:"")_d.FileName
	if text?1"***".e write ! // new message (except for overlaps!)
	if wide {
		write !,$e(time,1,12),?13,$e(d.Place,1,20),?34,$e(comp,*-25,*),?61
		set text=$$printable($e(text,1,100))
		write $e(mf,1,15),?77,$e(text,1,100) if $l(text)>100 write "..."
	}
	else {
		write !,$p(time,"."),?9,$e(d.Place,1,12),?22,$e(comp,*-17,*),?41
		set text=$$printable($e(text,1,100))
		if $l(text)>34 {write $e(text,1,24)}
		else {write $e(text,1,34)," "}
		write ?66,$e(mf,1,14)
	}
 }
 do ..ExtentClose(qh)
err set $zt=""
 if Device'=0 close Device
 quit
printable(s)
 set S="" for i=1:1:$l(s) set t=$e(s,i),S=S_$s(t?1anp:t,1:"$c("_$a(t)_")")
 quit S
}

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ ServerOnly = 1 ]
{
 // remove the stream file, if it exists
 set d=..%Open(oid) if d="" quit 1
 set file=d.FileName if file="" quit 1
 if ##class(%File).Delete(file)
 quit 1
}

Storage Default
{
<Data name="HSDebugDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateTime</Value>
</Value>
<Value name="3">
<Value>Place</Value>
</Value>
<Value name="4">
<Value>Component</Value>
</Value>
<Value name="5">
<Value>Message</Value>
</Value>
<Value name="6">
<Value>Text</Value>
</Value>
<Value name="7">
<Value>File</Value>
</Value>
<Value name="8">
<Value>FileName</Value>
</Value>
</Data>
<DataLocation>^HS.Util.HSDebugD</DataLocation>
<DefaultData>HSDebugDefaultData</DefaultData>
<IdLocation>^HS.Util.HSDebugD</IdLocation>
<IndexLocation>^HS.Util.HSDebugI</IndexLocation>
<StreamLocation>^HS.Util.HSDebugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
