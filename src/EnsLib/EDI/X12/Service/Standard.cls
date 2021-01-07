/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIX12

Class EnsLib.EDI.X12.Service.Standard Extends (Ens.BusinessService, EnsLib.EDI.X12.Util.IOFraming, EnsLib.EDI.ServiceInterface) [ Abstract, ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

/// Use our own domain for localization
Parameter DOMAIN = "Ensemble";

Parameter DOCCLASS As %String = "EnsLib.EDI.X12.Document";

/// Colon-separated Local ID:Qualifier codes representing this (receiving) facility and application <br>
/// These are used in constructing reply document headers.<br>
/// The '@' symbol represents using the corresponding field from the incoming message.<br>
/// If your ID must contain a literal @ symbol, escape it with backslash: '\@'
Property LocalApplicationID As %String(MAXLEN = 1000) [ InitialExpression = "@:@" ];

/// Configuration items to which to send Documents
Property TargetConfigNames As %String(MAXLEN = 2000);

/// Store a set of searchable properties associated with each X12 TransactionSet processed.<br>
/// These records will be stored in the named SearchTable class, if any.
Property SearchTableClass As %String(MAXLEN = 128) [ InitialExpression = "EnsLib.EDI.X12.SearchTable" ];

/// Category to apply to incoming X12 document type names to produce a complete DocType specification.<p/>
/// Combines with the document type name to produce a DocType assignment.
/// This setting may also contain multiple comma-separated type names followed by = and then a
/// DocTypeCategory or full DocType value to apply to documents declared as that type.<br>
/// A trailing asterisk (*) at the end of a given partial type Name will match any types with that beginning part.<p/>
/// An example: DocSchemaCategory='837=837_X096, 850=850_X12-4010, Interchange=ISC_00401, Group=ISC_00401'; <br>
/// Note that a DocType assignment may be needed for Validation or SearchTableClass indexing.
Property DocSchemaCategory As %String(MAXLEN = 1000);

/// X12 Document outbound framing protocol; options: <br/>
/// - Flexible : Determine framing style from the content of received data of each message received<br/>
/// - Flexible! : Determine framing style from the content of received data of the first message and require subsequent messages to have that same framing style<br/>
/// - None : No framing - Each document is output without prefix or suffix characters <br/>
/// - Epic02/03 : same as Ascii02/03 : EPIC sometimes uses this for TCP. Frame documents with an Ascii(02) prefix character before each document and an Ascii(03) suffix character <br/>
/// - Ascii[nn]/[mm] : Frame documents with an Ascii(nn) prefix character before each document and an Ascii(mm) suffix character, but no trailing Ascii(13) as in MLLP <br/>
/// - Ascii[nn] : Frame documents with an Ascii(nn) suffix character separating each document from the subsequent one. <br/>
/// - AsciiLF : Frame documents with Ascii(10) (Linefeed) separating each document from the subsequent one <br/>
/// - AsciiCR : Frame documents with an extra Ascii(13) (Carriage Return) separating each document from the subsequent one <br/>
/// - MLLP : Minimal Lower Level Protocol (HL7 style) - Frame each X12 Document with Ascii(11) prefix and Ascii(28,13) suffix <br/>
/// - MLLP[nn]/[mm] : Minimal Lower Level Protocol - Frame each X12 Document with Ascii(nn) prefix and Ascii(mm),Ascii(13) suffix <br/>
/// - MsgEnvelope : Use the document's Envelope property verbatim if it is present. The string &lt;!--X12DOC--&gt; if present in the Envelope will be replaced with the document content. Otherwise the document will simply follow the 'Envelope' text <br/>
/// - MLLPMsgEnvelope : Same as 'MsgEnvelope', but with MLLP prefix and suffix also around the document inside the 'Envelope' <p/>
/// Note: All Ascii values should be given in decimal; Ascii(120) ('x') is not allowed as an Ascii framing character.
/// Also, if an asterisk (*) is appended to the framing specification, Flexible framing will be used in parsing received acknowledgement response messages. Otherwise the response messages will be expected with the same kind of framing as that specified here for outbound messages.
Property Framing As %String(DISPLAYLIST = ",Flexible,Flexible!,None,Epic02/03,Ascii11/28,Ascii11,AsciiLF,AsciiCR,MLLP,MLLP11/28,MsgEnvelope,MLLPMsgEnvelope") [ InitialExpression = "None" ];

/// String specifying types of Validation to perform if <parameter>ValMode</parameter> = 'Flags' <p>
/// Set to 1 to block documents that don't pass default validation. Default validation requires a DocType
/// and blocks messages with any other error encountered while mapping the document's 
/// sequence of segments using the X12 schema structure specified by the document's DocType. This is equivalent to 'dm'. <p/>
/// All flags relating to fields/components apply only if 's'/'c' also specified 
/// (eg. if set to 'dmslt' then the length and datatype of fields will be checked, but the length and datatype of components will not be) <p/>
/// 'd' - require DocType <br/>
/// 'm' - don't tolerate BuildMap segment mapping errors <br/>
/// 's' - enforce segment structures (number and repetition of fields) <br/>
/// 'c' - enforce composite structures (number of components) <br/>
/// 'r' - enforce required fields/components being present <br/>
/// 'u' - enforce non-use of fields/components marked 'Not Used' - Note this is not available when using a new-style only schema <br/>
/// 'l' - enforce field/component length restrictions <br/>
/// 't' - enforce correct datatypes used for field/component values <br/>
/// 'v' - enforce correct code table values used where specified in the schema - Note this is not available when using a new-style only schema <br/>
/// 'x' - enforce relational conditions where specified in the schema - Note this is not available when using a new-style only schema <br/>
/// 'n' - perform all validation available to new style schemas.  This is equivalent to 'dmscrlt' <br/>
/// 'a' - perform all available validation. This is equivalent to 'dmscrultv' <br/>
/// 'e' - continue validating after errors are encountered - specify this to scan the entire document and report all errors. 
/// Note, however, that if <parameter>BatchErrorAction</parameter> is 'Reject With All Errors', the entire document will always be scanned. 
/// And if <parameter>BatchErrorAction</parameter> is 'Reject on First Error, then validation will always stop after the first error is encountered. <br/>
Property Validation As %String;

/// Mode to use in validating incoming messages <p>
/// If set to 'Flags', the flags specified in the <parameter>Validation</parameter> setting will be used. <br>
/// If set to 'SNIP', SNIP rules will be used in determining whether messages pass validation and in constructing Acknowledgement messages.  The <parameter>SNIPLevel</parameter> value will determine which SNIP rules are used. <br>
/// If set to 'None', do not perform validation. <br>
Property ValMode As %String(VALUELIST = ",None,Flags,SNIP") [ InitialExpression = "Flags", Required ];

/// Which level of SNIP validation to perform <p>
/// This is only used when <parameter>ValMode</parameter> is set to 'SNIP'. <br>
/// If set to 1, then only integrity testing is performed. <br>
/// If set to 2, then integrity testing and requirements testing are performed. <br> 
Property SNIPLevel As %Integer(VALUELIST = ",1,2") [ InitialExpression = 1 ];

/// How should reply documents be generated? <p>
/// - Never : Do not send back any reply <br>
/// - Immediate : Send back reply message generated immediately in this Service <br>
/// - Application : If the Interchange passes immediate validation, wait for reply or replies from target config item and forward a reply back when it is complete. (If validation fails or some other error occurs, generate an immediate reply anyway, according to the option selected for 'BatchReplyType'
Property ReplyMode As %String(DISPLAYLIST = ",Never,Immediate,Application", VALUELIST = ",Never,Immed,App") [ InitialExpression = "Immed", Required ];

/// Ignore inbound Acknowledgement messages to avoid reply feedback loop.
Property IgnoreInboundAck As %Boolean [ InitialExpression = 1 ];

/// Add extra error-text field to TA1 & 997/999 AKx segments when generating error-status reply messages; otherwise do not embed internal error state information in 997 messages
Property AddNackErrText As %Boolean;

/// How to treat received batch Interchange documents: <br>
/// - Whole Batch : Don't process child documents individually; accumulate and send the whole batch as one composite document <br>
/// - Single-Session Batch : Forward all documents in the Interchange as part of a single session, including final parent document objects containing batch and group header and trailer segments <br>
/// - Multi-Session Batch : Forward each document in the Interchange in its own session, followed by final parent document objects containing the batch and group header and trailer segments <br>
/// - Individual : Forward each child document in the batch in its own session; do not forward parent batch document objects
Property BatchHandling As %String(DISPLAYLIST = ",Whole Batch,Single-Session Batch,Multi-Session Batch,Individual", VALUELIST = ",Whole,1Session,MSession,Indiv") [ InitialExpression = "1Session", Required ];

/// What to do when detecting a validation error in a batch Interchange document: <p>
/// (Note: If ReplyMode is 'Application' and BatchErrorAction is not 'Individual', then some documents in a batch may be forwarded and then the whole batch rejected after errors are encountered) <p>
/// - Reject With All Errors : Reject the whole batch if any error is found in any document within it. Enumerate all errors found if BatchReplyType allows for reporting them. This will prevent forwarding any documents in a batch until all have been read and validated.<br>
/// - Accept With Errors : Accept documents with errors, but do take note of all errors found if BatchReplyType allows for reporting them. This will prevent forwarding any documents in a batch until all have been read and validated.<br>
/// - Reject On First Error : Reject the whole batch when the first error is found in any document within it. Don't bother checking for more errors or parsing any further contents of the Interchange. This will prevent forwarding any documents in a batch until all have been read and validated. <br>
/// - Reject Individual Errors : Reject only those documents within the Interchange that have errors. Forward each acceptable child document to the target config item(s) as soon as it has been read and validated.
Property BatchErrorAction As %String(DISPLAYLIST = ",Reject With All Errors,Accept With Errors,Reject On First Error,Reject Individual Errors", VALUELIST = ",All,Note,First,Indiv") [ InitialExpression = "Indiv", Required ];

/// What kind of batch reply should we construct for an Interchange batch we have received? 
/// Note that all the options here that relate to TA1 segments are used to force a TA1 segment to be generated, often as the only body segment of the reply interchange.
/// This is used to represent the presence or absence of errors in the whole inbound Interchange.  However if an error is found in the incoming
/// ISA or IEA that can only be reported in a TA1 segment, then a TA1 will be generated even if the configured setting does not force a TA1 to appear. <p>
/// - None : Do not generate a batch reply - if an error occurs do not construct any immediate notification reply to the sender <br>
/// - All : Generate a reply Interchange containing a reply notification for every TransactionSet in the Interchange we received <br>
/// - All+TA1 : Generate a reply Interchange containing a TA1 segment that indicates acceptance or error status for the whole Interchange, and a reply notification for every TransactionSet in the Interchange we received <br>
/// - All+ISA14TA1 : Generate a reply Interchange containing a TA1 segment only if either a 1 appears in field ISA:14 of the ISA header segment or if there is an error at the Interchange level.  If no error at the Interchange level, then send a reply for each Transaction Set we received. </br>
/// - Errors : Generate a reply Interchange containing reply notifications only for TransactionSets in which errors are detected, or an empty Interchange if no error is found <br>
/// - OnlyIfErrors : Only if errors are found, generate a reply Interchange containing reply notifications only for TransactionSets in which errors are detected <br>
/// - Successes : Generate a reply Interchange containing reply notifications only for TransactionSets in which no errors are detected, or an empty Interchange if only errors are found <br>
/// - TA1 : Generate a reply Interchange containing only a TA1 segment that indicates acceptance or error status for the whole Interchange we received <br>
/// - OnlyIfErrorTA1 : Only if errors are found, generate a reply Interchange containing only a TA1 segment that indicates error status for the whole Interchange we received <br>
/// - ISA14-TA1 : Generate a reply Interchange containing only a TA1 segment if a 1 appears in field ISA:14 of the ISA header segment of the incoming Interchange; otherwise return nothing. <br>
/// - ISA14-OnlyIfErrorTA1 : Only if errors are found and field ISA:14 of the incoming ISA header segment is set to 1, generate a reply Interchange containing only an error TA1 segment; otherwise return nothing. <br>
/// - Byte : Generate a reply consisting of a single character code : 'A' if the whole Interchange is accepted, 'R' if it is rejected due to one or more errors
Property BatchReplyType As %String(DISPLAYLIST = ",None,All,All+TA1,All+ISA14TA1,Errors,OnlyIfErrors,Successes,TA1,OnlyIfErrorTA1,ISA14-TA1,ISA14-OnlyIfErrorTA1,Byte", VALUELIST = ",None,All,AllTA1,AllI14TA1,Errs,OnlyErrs,Succ,TA1,ErrTA1,I14,I14Err,Byte") [ InitialExpression = "Errs", Required ];

/// Process the file without error even if to enhance readability newlines have been added after or in place of segment terminators. <br/>
/// Also causes tab and space characters to be ignored at the end or beginning of segments (i.e. adjacent to a segment terminator).
Property TolerateNewlines As %Boolean [ InitialExpression = 1 ];

/// Default Character Encoding to use when reading or writing X12 Documents. <p/>
/// Choices you can use for this setting include:<p/>
/// <ul>
/// <li>Native - use the default character encoding of the installed locale of the InterSystems IRIS server</li>
/// <li>latin1 - the ISO Latin1 8-bit encoding; this is the default</li>
/// <li>ISO-8859-1 - the ISO Latin1 8-bit encoding</li>
/// <li>UTF-8 - the Unicode 8-bit encoding</li>
/// <li>Unicode - the Unicode 16-bit encoding  (Little-Endian)</li>
/// <li>UnicodeBig - the Unicode 16-bit encoding (Big-Endian)</li>
/// <li>Any other NLS definitions installed on this InterSystems IRIS server</li>
/// <li>@&lt;ttable&gt; - &lt;ttable&gt; means a raw InterSystems character translation table name. A prefix of '@' means to use the named table.</li>
/// </ul>
Property DefCharEncoding As %String(MAXLEN = 20);

/// Default Repetition Separator to use for parsing any X12 Documents in which the Repetition Separator is not explicitly defined.
/// The Repetition Separator is specified in the Interchange header at ISA:11.
/// Empty string means use the system default value if the Repetition Separator is not explicitly defined in the document interchange.
Property DefRepSep As %String(MAXLEN = 1);

/// Default Component Element Separator to use for parsing any X12 Documents in which the Component Separator is not explicitly defined. 
/// The Component Separator is specified in the Interchange header at ISA:16.
/// Empty string means use the system default value if the Component Element Separator is not explicitly defined in the document interchange.
Property DefCompSep As %String(MAXLEN = 1);

/// Default Segment Terminator to use for parsing any X12 Documents in which the Segment Terminator is not explicitly defined. 
/// The Segment Terminator is specified as the byte immediately following the 105 byte Interchange header.
/// Empty string means use the system default value if the document interchange is missing.
Property DefSegTerm As %String(MAXLEN = 1);

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SearchTableClass::selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.EDI.X12.Service.Standard},DocSchemaCategory:Basic:selector?context={Ens.ContextSearch/SchemaCategories?host=EnsLib.EDI.X12.Service.Standard},Framing:Connection:selector?context={Ens.ContextSearch/getDisplayList?host=@currHostId&prop=Framing},ValMode:Acknowledgement,Validation:Acknowledgement,SNIPLevel:Acknowledgement,LocalApplicationID:Acknowledgement,ReplyMode:Acknowledgement,BatchHandling:Basic,BatchErrorAction:Acknowledgement,BatchReplyType:Acknowledgement,AddNackErrText:Acknowledgement,TolerateNewlines:Connection,DefCharEncoding::selector?context={Ens.ContextSearch/CharacterSets},DefRepSep,DefCompSep,DefSegTerm";

/* Used in AckIn... subclasses (aka ImmediateByteAck) */
/// In addition to forwarding a full reply message according to the ReplyMode and BatchReplyType settings, return a direct immediate Acknowledgement of this type on this Service's TCP connection as soon as we have committed the inbound document to our persistent storage
/// - None : Do not generate a batch reply - if an error occurs do not construct any immediate notification reply to the sender <br>
/// - TA1 : Generate a reply Interchange containing only a TA1 segment that indicates acceptance or error status for the whole Interchange we received <br>
/// - Byte : Generate a reply consisting of a single character code : 'A' if the whole Interchange is accepted, 'R' if it is rejected due to one or more errors
Property CommitAckType As %String(VALUELIST = ",None,TA1,Byte") [ InitialExpression = "None", Required ];

/// For batch documents, don't process contained documents individually; accumulate and send the whole batch at once;
/// Do not begin processing TransactionSets until after validating the end of group and end of interchange segments.
Property %ForwardBatchWhole As %Boolean [ Internal ];

/// When processing child documents individually, forward batch header/trailer segment shell documents in addition to the child Message documents they contain
Property %ForwardBatchHeaders As %Boolean [ InitialExpression = 1, Internal ];

/// For Batch documents, forward every child document in the batch as part of a single session.
Property %SingleBatchSession As %Boolean [ Internal ];

/// Should this Service forward child documents as soon as it encounters them, or store them up until we know if the batch contained any errors
Property %DeferChildSend As %Boolean [ Internal ];

/// Should a Batch Interchange response document include a top-level TA1 response segment?
Property %ForceTA1 As %Boolean [ Internal ];

/// Should a Batch Interchange response document include 997/999 FunctionalGroup- and TransactionSet- level acknowledgement segments?
Property %Do997s As %Boolean [ Internal ];

/// Stop processing a batch document if an error occurs. Otherwise accumulate all errors and report them as a group
Property %AbortBatchOnError As %Boolean [ InitialExpression = 0, Internal ];

/// Does the current BatchReplyType specify a reply only if Errors occur?
Property %ConditionalReply As %Boolean [ Internal ];

/* transient state properties */
/// Is the current document the first in a batch? (used for starting a new session on the first message in a batch; we reset it at the end of each batch)
Property %isNewBatch As %Boolean [ InitialExpression = 1, Internal ];

/// Does the current message belong to a batch Interchange whose ISA requests a TA1 reply?
Property %ISARequestsTA1 As %Boolean [ InitialExpression = 0, Internal ];

/// Keep track of whether the Interchange contained any errors or successes. Empty result means none of the selected-for statuses occurred (i.e. errors or successes).
Property %TopReplyCode As %String [ Internal ];

/// If SearchTableClass is set, use it to index any reply documents
Parameter IndexReplies As %Boolean [ Internal ] = 0;

Property %Parser As EnsLib.EDI.X12.Parser [ Internal ];

Method OnInit() As %Status
{
	Set ..%Parser=##class(EnsLib.EDI.X12.Parser).%New($this)
	If "!"=$E(..Framing,*) { Set ..%Parser.Framing=$E(..Framing,1,*-1), ..%Parser.RememberFlex=1}
	Else { Set ..%Parser.Framing=..Framing }
	Set:..TolerateNewlines ..%Parser.Whitespace=$C(13,10,9,32)
	Set ..%Parser.DefCharEncoding=..DefCharEncoding
	
	#; Apply default initializers (same as InitialExpression values)
	Set:""=..ReplyMode ..ReplyMode="Immed"
	Set:""=..BatchHandling ..BatchHandling="1Session"
	Set:""=..BatchErrorAction ..BatchErrorAction="Indiv"
	Set:""=..BatchReplyType ..BatchReplyType="Errs"
	Set:""=..ValMode ..ValMode="Flags"
	Set:"1"=$ZStrip(..Validation,"<>W") ..Validation="dm"

	#; Populate control flags
	Set ..%ForwardBatchWhole=$Case(..BatchHandling, "Whole":1, :0)
	Set ..%ForwardBatchHeaders=(..BatchHandling'="Indiv")
	Set ..%SingleBatchSession=$Case(..BatchHandling, "1Session":1, :0)
	Set ..%AbortBatchOnError=$Case(..BatchErrorAction, "Indiv":0, :1)
	Set ..%DeferChildSend=$Case(..BatchHandling, "Whole":1, :$Case(..ReplyMode,"Never":0, "App":0,:1))
	Set ..%ForceTA1=$Case(..BatchReplyType, "AllTA1":1, "TA1":1, "ErrTA1":1, "AllI14TA1":-1, "I14":-1, "I14Err":-1, :0)
	Set ..%Do997s=$Case(..BatchReplyType, "None":0, "All":3, "AllTA1":3, "AllI14TA1":3, "Errs":1, "OnlyErrs":1, "Succ":2, "TA1":0, "ErrTA1":0, "I14":0, "I14Err":0, "Byte":0, :0)
	Set ..%ConditionalReply=$Case(..BatchReplyType, "OnlyErrs":1, "ErrTA1":1, "I14Err":1, :0)
	If ..ReplyMode="App" && (..BatchErrorAction'="Indiv") $$$LOGWARNING("ReplyMode is 'Application' and BatchErrorAction is not 'Reject Individual Errors'; this means a partial batch may be forwarded to the target application and then the sender notified that the whole batch is rejected")

	Quit $$$OK
}

/// Note: pDocIn is not declared as EnsLib.EDI.X12.Document so that subclasses can handle other types and transform them before calling ##super().
Method OnProcessInput(pDocIn As %RegisteredObject, Output pDocOut As %RegisteredObject) As %Status
{
	$$$ASSERT(0_"Subclass Responsibility")
}

/// Override this method to implement your own custom method for handling an incoming ACK Message
/// Returning nonzero means you are handling it and the normal framework should ignore it
Method OnInboundAck(pDoc As EnsLib.EDI.Document, ByRef pSC As %Status) As %Boolean
{
	If ..IgnoreInboundAck {
		$$$LOGWARNING("Not processing inbound "_pDoc.Name_" message "_pDoc_"/"_pDoc.getId())
		Set pDoc.IsMutable=0
		Quit 1
	}
	Quit 0
}

/// Override this method to implement your own custom method for validating an incoming Document
/// Return non-zero to prevent default validation of the message (if any);
Method OnValidate(pDoc As EnsLib.EDI.Document, pValSpec As %String, Output pStatus As %Status) As %Boolean
{
	Quit 0
}

/// Override this method to implement your own custom method for resolving the DocType of an incoming Message
/// Returning nonzero means you are overriding the framework's standard DocType resolution.
Method OnResolveDocType(pDoc As EnsLib.EDI.Document, ByRef pDocType As %String) As %Boolean
{
	Quit 0
}

Method standardOnProcessInput(pDocIn As EnsLib.EDI.X12.Document, Output pDocOut As EnsLib.EDI.X12.Document, pParseStatus As %Status = {$$$OK}) As %Status
{
	#dim tSC As %Status = pParseStatus
	#dim tSCVal As %Status = $$$OK
	Set pDocOut=$$$NULLOREF, tReplyCode1=$S("None"=..CommitAckType:"",1:"A"), tDocID = pDocIn.getId()
	Set tReplyCode = ""
	Set:(..BatchHandling="Indiv") pDocIn.HandledIndividually = 1
	#; Important to set this here to avoid mis-processing an errored child document later on because of its ParentId having been set to ""
	Set tHasParent = (pDocIn.ParentId'="")
	$$$ASSERT($$$IsdefObject(pDocIn) && pDocIn.%IsA("EnsLib.EDI.X12.Document"))
	$$$sysTRACE("Got Document "_pDocIn_" / "_tDocID)
	If 'tHasParent && ("ISA"=pDocIn.GetValueAt("1:0")) {
		Set tName2=pDocIn.GetValueAt("2:0")
		If "TA1"=tName2 || ("GS"=tName2 && (("997"=pDocIn.GetValueAt("3:1")||("999"=pDocIn.GetValueAt("3:1"))))) {
			Quit:..OnInboundAck(pDocIn,.tSC) tSC
		}
	}
	Set tSCVal=..resolveAndIndex(pDocIn,tSC)
	Set tResponse=$$$NULLOREF

	#; Control whether batch messages appear in a single session together
	If '..%PreserveSession && (..%isNewBatch || '..%SingleBatchSession) {
		#; We do not want to clean %SuperSession if set before %SessionId
		If '..%SuperSessionCreatedBeforeSession  Set ..%SuperSession = ""
		Set ..%SessionId=""  Kill $$$JobSessionId
	}
	#; Forward the document in the appropriate way (sync, async, or not at all)
	If $$$ISOK(tSC)&&$$$ISOK(tSCVal)&&(""'=..TargetConfigNames) {
		Set pDocIn.IsMutable=0
		If ..ReplyMode'="App" { ; 'Immediate' or 'None'
			#; Send Async; no reply required
			Set tReplyCode=..getReplyCode(pDocIn,tSC,tSCVal,0)
			If "Succ"=..BatchReplyType { Set:"A"=tReplyCode ..%TopReplyCode=tReplyCode }
			Else { Set:$Case(tReplyCode,"":0,"A":0,:1) ..%TopReplyCode=tReplyCode }
			If 'tHasParent || '..%DeferChildSend {
				If 'tHasParent && ..%DeferChildSend && '..%ForwardBatchWhole {
					If '..%ForwardBatchHeaders {
						#; Not sending pDocIn; save DocType & IsMutable updates
						$$$SyncCommitSet(tSyncCommit)
						Set tSC = pDocIn.%Save()
						$$$SyncCommitClear(tSyncCommit)
						If $$$ISERR(tSC) $$$LOGERROR("Failed to save message "_pDocIn_" / "_tDocID_" : "_$$$StatusDisplayString(tSC))
					}
					#; loop through the batch and send them all
					Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code")=..%TopReplyCode ; set the top node to avoid error due to undefined
					Set tCode=..sendBatchChildren(pDocIn)
					If "Succ"=..BatchReplyType { Set:""'=tCode ..%TopReplyCode=tCode }
					Else { Set:$Case(tCode,"":0,"A":0,:1) ..%TopReplyCode=tCode }
					Set:""'=..%TopReplyCode tReplyCode=..%TopReplyCode
				} ElseIf ..%ForwardBatchHeaders || $Case(pDocIn.Name,"Interchange":0,"Group":0,:1) {
					$$$SyncCommitSet(tSyncCommit)
					For iTarget=1:1:$L(..TargetConfigNames,",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
						$$$sysTRACE("Sending X12 document "_pDocIn_" / "_tDocID_" from "_pDocIn.Source_" to '"_tOneTarget_"'")
						Set tSC1=..SendRequestAsync(tOneTarget,pDocIn)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
					}
					$$$SyncCommitClear(tSyncCommit)
					If $$$ISOK(tSC) { $$$sysTRACE("After async forwarding X12 document "_tDocID_", reply code='"_tReplyCode_"'") }
					Else { Set tReplyCode=..getReplyCode(pDocIn,tSC,tSCVal,0) } ; get a new code since we have a new error
				} Else { ; Not sending; save DocType & IsMutable updates
					$$$SyncCommitSet(tSyncCommit)
					Set tSC = pDocIn.%Save()
					$$$SyncCommitClear(tSyncCommit)
					If $$$ISERR(tSC) $$$LOGERROR("Failed to save message "_pDocIn_" / "_tDocID_" : "_$$$StatusDisplayString(tSC))
				}
			} Else { ; ""'=pDocIn.ParentId && ..%DeferChildSend
				#; Not sending yet; save DocType & IsMutable updates
				$$$SyncCommitSet(tSyncCommit)
				Set tSC = pDocIn.%Save()
				$$$SyncCommitClear(tSyncCommit)
				If $$$ISERR(tSC) $$$LOGERROR("Failed to save message "_pDocIn_" / "_tDocID_" : "_$$$StatusDisplayString(tSC))
			}
		} Else { ; 'Application' mode
			#; Send Synchronous; reply required - for Application ACK mode
			If tHasParent && ..%DeferChildSend && ..%ForwardBatchWhole
			 || ('..%ForwardBatchHeaders && $Case(pDocIn.Name,"Interchange":1,"Group":1,:0)) {
				#; Just get code but don't send/forward child docs yet; save DocType & IsMutable updates
				#; note - ..%DeferChildSend not honored for non-Whole App mode (see warning in OnInit())
				$$$SyncCommitSet(tSyncCommit)
				Set tSC = pDocIn.%Save()
				$$$SyncCommitClear(tSyncCommit)
				If $$$ISERR(tSC) $$$LOGERROR("Failed to save message "_pDocIn_" / "_tDocID_" : "_$$$StatusDisplayString(tSC))
				Set tReplyCode=..getReplyCode(pDocIn,tSC,tSCVal,0)
			} Else {
				If ""'=tReplyCode1 {
					$$$sysTRACE("sending immediate-Commit OK Ack; waiting for Application reply")
					$$$SyncCommitSet(tSyncCommit)
					Set tSC=pDocIn.%Save() ; save the message because we're going to ACK it.
					$$$SyncCommitClear(tSyncCommit)
					If $$$ISERR(tSC) $$$LOGERROR("Failed to save message "_pDocIn_" / "_tDocID_" : "_$$$StatusDisplayString(tSC))
					Set tReplyCode1=..getReplyCode(pDocIn,tSC,tSCVal,-1)
					Do ..reportReply(pDocIn,tReplyCode1,.tSC,1)
					Set tReplyCode1="" ; done; suppress later send of commit reply
				}
				If $$$ISOK(tSC) {
					If 1'=$L(..TargetConfigNames,",") $$$LOGWARNING("More than one target config name specified for synchronous forwarding: "_..TargetConfigNames)
					$$$sysTRACE("Sending "_pDocIn_"/"_tDocID_" from "_pDocIn.Source_" to '"_..TargetConfigNames_"'")
					Set tSC=..SendRequestSync(..TargetConfigNames,pDocIn,.tResponse)
				}
				If '$IsObject(tResponse) { ; no reply message - we must construct one
					Set tReplyCode=..getReplyCode(pDocIn,tSC,tSCVal,1) ; get an App reply code to construct
					Set tTxt="Constructing reply with code '"_tReplyCode_"' because SendRequestSync() of "_pDocIn_"/"_tDocID_" returned with no response object and status: "_$$$StatusDisplayString(tSC)
					If $$$ISERR(tSC) { $$$LOGWARNING(tTxt) } ElseIf tReplyCode'="" { $$$sysTRACE(tTxt) }
				} Else {
					$$$sysTRACE("Returning reply document "_tResponse.getId()_" ("_tResponse.Name_") received from document "_tDocID_" forwarded to "_..TargetConfigNames)
				}
			}
		}
	} Else { ; not forwarding due to error or no target
		If tHasParent && ..%DeferChildSend {
			#; Not sending yet; save DocType & IsMutable updates
			$$$SyncCommitSet(tSyncCommit)
			Set tSC = pDocIn.%Save()
			$$$SyncCommitClear(tSyncCommit)
			If $$$ISERR(tSC) $$$LOGERROR("Failed to save message "_pDocIn_" / "_tDocID_" : "_$$$StatusDisplayString(tSC))
		} Else {
			Set tReplyCode=..getReplyCode(pDocIn,tSC,tSCVal,0)
			If (""'=tReplyCode||("None"'=..CommitAckType))&&$$$ISOK(tSC)&&$$$ISOK(tSCVal) {
				$$$SyncCommitSet(tSyncCommit)
				Set pDocIn.IsMutable=0, tSC=pDocIn.%Save() ; save the document because we're going to reply that we got it.
				$$$SyncCommitClear(tSyncCommit)
				If $$$ISERR(tSC) {
					$$$LOGERROR("Failed to save document "_pDocIn_" / "_tDocID_" : "_$$$StatusDisplayString(tSC))
					Set tReplyCode=..getReplyCode(pDocIn,tSC,tSCVal,-1) ; get a new code since we have a new error
				}
			}
			If ""=tReplyCode { $$$sysTRACE("Not returning reply for document "_pDocIn_"/"_tDocID_"; ReplyMode="_..ReplyMode_"; tReplyCode='"_tReplyCode_"'"_$S($$$ISERR(tSC):" status "_$$$StatusDisplayString(tSC),1:"")) }
			Else { $$$sysTRACE("Returning reply code "_tReplyCode_" but not forwarding document "_pDocIn_"/"_tDocID_$S($$$ISERR(tSC):" status "_$$$StatusDisplayString(tSC),1:"")_$S($$$ISERR(tSCVal):" validation status "_$$$StatusDisplayString(tSCVal),1:"")) }
		}
	}
	#; Send early/immediate Commit acknowledgement
	If ""'=tReplyCode1 {
		Set tReplyCode1=$S(""'=tReplyCode:tReplyCode, 1:..getReplyCode(pDocIn,tSC,tSCVal,-1)) ; force a code
		$$$sysTRACE("sending immediate-Commit Ack; code='"_tReplyCode1_"'")
		Do ..reportReply(pDocIn,tReplyCode1,.tSC,1)
	}
	#; Abort the current batch by telling the parser to just scan without notifying from here until the end of the current group and interchange
	Set:tHasParent&&$$$ISERR(tSC)&&..%AbortBatchOnError ..%Parser.FinishBatch=1

	#; Take the appropriate reply action for this document (construct/save/send)
	If $IsObject(tResponse) {
		Set pDocOut=..reportReply(pDocIn,tResponse,.tSC)
	} ElseIf ""'=tReplyCode {
		Set tSC=$$$ADDSC(tSC,tSCVal)
		Set pDocOut=..reportReply(pDocIn,tReplyCode,.tSC)
	}
	Quit tSC
}

Method OnParsingError(pStatus As %Status, pDocument As EnsLib.EDI.X12.Document, pSeparators As %String = "") As %Status
{
	#dim tSC As %Status = pStatus
	#dim tSC1 As %Status = $$$OK
	Quit:'$$$ISERR(pStatus) tSC ; this should not happen

	#dim tDefaultSeparators As %String = pSeparators
	Set:""=$$$COMSEP(tDefaultSeparators) $$$COMSEP(tDefaultSeparators) = $Select(..DefCompSep'="":..DefCompSep,1:$$$X12DefComponentSeparator)
	Set:""=$$$REPSEP(tDefaultSeparators) $$$REPSEP(tDefaultSeparators) = $Select(..DefRepSep'="":..DefRepSep,1:$$$X12DefRepetitionSeparator)
	Set:""=$E(tDefaultSeparators,4) tDefaultSeparators = tDefaultSeparators_$Select(..DefSegTerm'="":..DefSegTerm,1:$$$X12DefSegTerminator)

	#dim tCode,tLine,tISA,tDataElementSeparator,tSegName,tNoteCode,tDocType As %String = ""
	#dim tReplyISA,tReplyIEA,tReplyTA1 As EnsLib.EDI.X12.Segment
	#dim tReplyDoc As EnsLib.EDI.X12.Document
	#dim tFinished,tCreateReplyDoc As %Boolean = 0

	Set tSC1 = $System.Status.DecomposeStatus(pStatus,.tErrList)
	Quit:$$$ISERR(tSC1) $$$ADDSC(tSC1,tSC)

	If $D(tErrList) {
		Set tCode = $G(tErrList(tErrList,"code"))
		Set tLine = $Case(tCode,
			"<EnsEDIX12>InvalidSegmentTerminator":$G(tErrList(tErrList,"param",2)),
			"<EnsEDIX12>UnexpectedEOD":$G(tErrList(tErrList,"param",1)),
			"<EnsEDIX12>TCPTerminatedReadTimeoutExpired":$S($D(tErrList(tErrList,"param",3),val)&&(val'="binary"):val,1:""),
			"<EnsEDIX12>ExpectedSegment":$G(tErrList(tErrList,"param",2)),
			"<EnsEDIX12>ISATruncated":$G(tErrList(tErrList,"param",2)),
			"<EnsErr>TCPReadTimeoutExpired":$G(tErrList(tErrList,"param",3)),
			"<EnsErr>TCPTerminatedReadTimeoutExpired":$G(tErrList(tErrList,"param",3)),
			"<EnsEDIX12>UnexpectedEODBinary":$G(tErrList(tErrList,"param",1)),
			"<EnsEDIX12>InvalidSegmentName":$G(tErrList(tErrList,"param",2)),
			"<EnsEDIX12>BinaryLeftover":$G(tErrList(tErrList,"param",1)),
			"<EnsEDIX12>BadBINLength":$G(tErrList(tErrList,"param",2)),
			:"")

		Set tDataElementSeparator=$E($ZStrip(tLine,"<AN"))
		Set:""'=tDataElementSeparator $$$ELESEP(tDefaultSeparators)=tDataElementSeparator
		Set tSegName = $P(tLine,tDataElementSeparator)
		If (tSegName = "ISA") {
			Set tISA = tLine
			Set tCreateReplyDoc = 1
		}
		If (tSegName'="ISA") && (tCode = "<EnsEDIX12>ExpectedSegment") && ($Case($G(tErrList(tErrList,"param",1)),"ISA":1,"GS":1,:0)) {
			Set tCreateReplyDoc = 1
			Set tISA = pDocument.GetValueAt(1)
			Set tDataElementSeparator=$E($ZStrip(tISA,"<AN"))
			Set:""'=tDataElementSeparator $$$ELESEP(tDefaultSeparators)=tDataElementSeparator
			Set:"ISA"'=$P(tISA,tDataElementSeparator) tISA=""
		}
		#; If this is an error which is caused entirely by the incoming document being poorly formatted (eg. missing GS, but no TCP timeout)
		#; then log it now instead of returning the error to OnProcessInput()
		If $Case(tCode,"<EnsEDIX12>InvalidSegmentTerminator":1,"<EnsEDIX12>ISATruncated":1,"<EnsEDIX12>ExpectedSegment":1,
			"<EnsEDIX12>UnexpectedEOD":$Select($G(tErrList(tErrList,"param",2))="":1,1:0),:0)&&tCreateReplyDoc {
				Set tFinished = 1
				$$$LOGSTATUS(pStatus)
		}
		
		Do {
			#; wait until here to quit, so we can still take appropriate actions with respect to what status to return and whether to delete the document
			Quit:((..ReplyMode="Never")||(..BatchReplyType="None"))
	
			If ..BatchReplyType="Byte" {
				$$$sysTRACE("Returning reply code R but not forwarding document due to errors parsing input")
				Set tSC1 = ..SendReply("R")
			} ElseIf tCreateReplyDoc {
				Set tReplyDoc=##class(EnsLib.EDI.X12.Document).%New($LB("",tDefaultSeparators))
				If '$IsObject(tReplyDoc) {
					Set tSC1=$$$ERROR($$$EnsEDIX12ErrGeneral,"Failed to instantiate reply document after receiving poorly formed input")
					Quit
				}
				
				#; Find the appropriate schema category to use - borrowed from ResolveDocType()
				Set tAcceptTypes=..DocSchemaCategory
				Set nTypes=$S(""=$ZStrip(tAcceptTypes,"<>W"):0, 1:$L(tAcceptTypes,","))
				Set (tVal,tDef)=""
				For i=1:1:nTypes {
					Set tType=$P(tAcceptTypes,",",i) Continue:""=tType
					Set tVal=$ZStrip($P(tType,"=",2),"<>W")
					Set tName=$ZStrip($P(tType,"=",1),"<>W"), tNameLen=$L(tName), tUName=$ZCVT(tName,"U")
					If ""=tVal {
						Set:""=tDef tDef=tName
					} Else {
						#; Quit on match; accept trailing wildcard also
						If "INTERCHANGE"=tUName || ("*"=$E(tName,tNameLen) && ($E(tUName,1,tNameLen-1)=$E("INTERCHANGE",1,tNameLen-1))) {
							If tVal[":" { Set tDocType=tVal }
							Else { Set tDocType=##class(EnsLib.EDI.X12.Schema).ResolveSchemaTypeToDocType(tVal,"Interchange") }
							Quit
						}
						Set tVal=""
					}
				}
				If (tDocType="") && (tDef'="") {
					Set tDocType=##class(EnsLib.EDI.X12.Schema).ResolveSchemaTypeToDocType($P(tDef,":"),"Interchange")
				}
				Do:""'=tDocType tReplyDoc.PokeDocType(tDocType)
				
				Set tReplyISA=##class(EnsLib.EDI.X12.Document).NewReplyHeaderSegsFromString(tISA,..LocalApplicationID,.tReplyIEA,.tSC1, tDefaultSeparators, tDocType)	Quit:$$$ISERR(tSC1)
				Set tSC1 = tReplyDoc.AppendSegment(tReplyISA)	Quit:$$$ISERR(tSC1)
				
				Set tNoteCode = $Case(tCode,
					"<EnsEDIX12>InvalidSegmentTerminator":$$$CodeTA1I18InvalidSegmentTerminator, ; The Segment Terminator is Invalid
					"<EnsEDIX12>UnexpectedEOD":$$$CodeTA1I18UnexpectedEndOfFile, ; Improper (Premature Ens-of-File (Transmission)
					"<EnsEDIX12>TCPTerminatedReadTimeoutExpired":$$$CodeTA1I18UnexpectedEndOfFile,
					"<EnsEDIX12>ISATruncated":$$$CodeTA1I18UnexpectedEndOfFile,
					"<EnsErr>TCPReadTimeoutExpired":$$$CodeTA1I18UnexpectedEndOfFile,
					"<EnsErr>TCPTerminatedReadTimeoutExpired":$$$CodeTA1I18UnexpectedEndOfFile,
					:$$$CodeTA1I18InvalidContent ; Invalid Interchange Content (e.g., Invalid GS Segment)
				)

				Set tReplyTA1 = ##class(EnsLib.EDI.X12.Document).NewReplyTA1SegFromString(tISA, tNoteCode, .tSC1, 1, tDefaultSeparators)	Quit:$$$ISERR(tSC1)
				If $IsObject(tReplyTA1) {
					Set tSC1 = tReplyDoc.AppendSegment(tReplyTA1)	Quit:$$$ISERR(tSC1)
				}
				
				If $IsObject(tReplyIEA) {
					#; No Functional Groups included - set IEA01 accordingly
					Set tSC1 = tReplyIEA.SetValueAt(0,$$$IEANumberofIncludedFunctionalGr)	Quit:$$$ISERR(tSC1)
					Set tSC1 = tReplyDoc.AppendSegment(tReplyIEA)	Quit:$$$ISERR(tSC1)
				}
				$$$sysTRACE("Constructed batch reply document '"_tReplyDoc_" / "_tReplyDoc.getId()_"' after receiving poorly formed input")
				
				Set tSC1 = ..SendReply(tReplyDoc)
			}
		} While 0
		
		#; If the actions we took here are sufficient to report the error, then don't block the file from being deleted, and do make sure the partial document object is deleted
		If tFinished {
			Set tSC = tSC1
			If $$$ISOK(tSC) {
				If $IsObject(pDocument) {
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",pDocument.getId())=""
				}
			}
		} Else {
			Set tSC = $$$ADDSC(tSC1,tSC)
		}
	}
	Quit tSC
}

/// Return ReplyCode 'R' if any Send errors occurred (Validation errors are already logged in ^IRIS.Temp)
Method sendBatchChildren(pDocIn As EnsLib.EDI.Document) As %String [ Internal ]
{
	#; Send the children first, if any, then the current document
	Set tReplyCode="",tChildren="", tSC=$$$OK
	Set tID = pDocIn.getId()
	Set tChild=$$$NULLOREF For { Set tChild=pDocIn.NextChild(tChild)  Quit:tChild=$$$NULLOREF
		Set tCode=..sendBatchChildren(tChild)
		If "Succ"=..BatchReplyType { Set:"A"=tCode tReplyCode=tCode }
		ElseIf ("Indiv"'=..BatchErrorAction) { Set:$Case(tCode,"":0,"A":0,:1) tReplyCode=tCode }
		If ("Indiv"=..BatchErrorAction) {
			Set tChildID = tChild.getId()
			Set tChildren(tChildID)=""
			If ("R"=tCode) {
				#; Avoid sending this rejected child along with the parent document
				Set tChild.ParentId = ""
				Set tSC = tChild.%Save()
				If $$$ISERR(tSC) {
					$$$LOGERROR("Failed to save message "_tChild_" / "_tChildID_" : "_$$$StatusDisplayString(tSC))
				} Else {
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tChildID)=""
				}
			}
		} ElseIf ("R"=tCode) {
			Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"Code")="R"
			Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tID)=""
		}
	}
	If ("Indiv"=..BatchErrorAction) {
		If pDocIn.Name="Group" {
			If pDocIn.ChildCount = 0 {
				Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tID)=""
				Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"Status") = $$$ERROR($$$EnsEDIX12AllChildrenFailedValidation,tID)
				Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"Code")="R"

			} Else {
				Do pDocIn.SetValueAt(pDocIn.ChildCount,"TransactionSetDocsRef:"_$$$REFSEGFLDCOUNT)
				Do pDocIn.SetValueAt(pDocIn.ChildCount,"GE:"_$$$GENumberofTransactionSetsInclu)
			}
		} ElseIf pDocIn.Name="Interchange" {
			If pDocIn.ChildCount = 0 {
				Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tID)=""
				Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"Status") = $$$ERROR($$$EnsEDIX12AllChildrenFailedValidation,tID)
				Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"Code")="R"
			} Else {
				Do pDocIn.SetValueAt(pDocIn.ChildCount,"GroupDocsRef:"_$$$REFSEGFLDCOUNT)
				Do pDocIn.SetValueAt(pDocIn.ChildCount,"IEA:"_$$$IEANumberofIncludedFunctionalGr)
			}
		}	
		Set tSC = pDocIn.%Save()
		If $$$ISERR(tSC) $$$LOGERROR("Failed to save message "_pDocIn_" / "_tID_" : "_$$$StatusDisplayString(tSC))

		Merge ^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"Children")=tChildren
	}
	
	#; Send the current document now, if it wasn't errored and it isn't filtered out
	Set tCode=$G(^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"Code"),"")
	Set:""'=tCode tReplyCode=tCode
	Quit:$Case(tCode,"A":0, "":"Succ"=..BatchReplyType,"R":1, :0) tCode 

	If ..%ForwardBatchHeaders || $Case(pDocIn.Name,"Interchange":0,"Group":0,:1) {
		#; Send Async; no reply required
		$$$SyncCommitSet(tSyncCommit)
		For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
			$$$sysTRACE("Sending X12 document "_pDocIn_" / "_tID_" from "_pDocIn.Source_" to '"_tOneTarget_"'")
			Set tSC1=..SendRequestAsync(tOneTarget,pDocIn)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
		}
		$$$SyncCommitClear(tSyncCommit)
	}
	If $$$ISOK(tSC) {
		$$$sysTRACE("After async forwarding X12 document "_tID_", reply code='"_tReplyCode_"'")
		Quit $S("Succ"=..BatchReplyType:"A",1:tReplyCode)
	} Else {
		Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tID,"SendErr")=tSC
		Quit $S("Succ"=..BatchReplyType:tReplyCode,1:"R")
	}
}

/// Accept only specified document names; resolve DocType and perform requested validation if any
Method resolveAndIndex(pDoc As EnsLib.EDI.X12.Document, pSC As %Status = {$$$OK}) As %Status
{
	#dim tSC,tSCVal As %Status =$$$OK
	Set tDocType=..resolveDocType(pDoc)
	Do pDoc.PokeDocType(tDocType)

	#; Do further validation if required
	If "Flags"=..ValMode {
		Set tDocID = pDoc.getId()
		If (..BatchErrorAction="First")&&(($G(^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code"))="R")||((pDoc.ParentId'="")&&($G(^IRIS.Temp.EnsX12(..%ConfigName,0,$P(pDoc.ParentId,":"),"Code"))="R"))) {
			Quit $$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Skipping validation of document %1 due to earlier validation failure."),tDocID))
		}
		Set tValSpec=..Validation
		Set:tValSpec=1 tValSpec="dm"
		Set tValSpec=##class(EnsLib.MsgRouter.RoutingEngine).normalizeValSpec(tValSpec)
		If ""'=..Validation&&'..OnValidate(pDoc,tValSpec,.tSCVal) {
			If ..Validation["," {
				// for backwards compatibility - if using commas, probably left-over from when description said string should be comma-separated and when we only provided d and m as ValSpec options
				Set tTempValSpec = $S((tValSpec["d"):"d", 1:"")
				Set:(tValSpec["m") tTempValSpec = tTempValSpec_"m"
				Set tValSpec = tTempValSpec	
			}
			If ..BatchErrorAction="First" {
				#; If Reject On First Error, then don't continue beyond first error
				Set tValSpec = $Translate(tValSpec,"eE")
			} ElseIf ..BatchErrorAction="All" {
				#; If Reject With All Errors, then find all errors
				Set tValSpec = tValSpec_"e"
			}
			Set tSCVal = ##class(EnsLib.EDI.X12.Util.Validator).Validate(pDoc,tValSpec,0)
		}
		If (pDoc.ParentId'="")&&("Indiv"=..BatchErrorAction) {
			#; Remember that this child document existed so we can report about it in the ACK message
			Set ^IRIS.Temp.EnsX12(..%ConfigName,0,$P(pDoc.ParentId,":"),"Children",tDocID)=""
		}
		If 'pDoc.ChildCount || $$$ISERR(tSCVal) {
			Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code")= $S($$$ISERR(tSCVal):$Case(..BatchErrorAction,"Note":"E", :"R"),1:"A")
			If $$$ISERR(tSCVal) {
				If (..BatchErrorAction'="Note") {
					Set tSC = $$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Document %1 was rejected due to validation failure: %2"),tDocID,$System.Status.GetErrorText(tSCVal)))
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocID)=""
					Set:""=pDoc.ParentId ..%TopReplyCode = "R"
				} Else {
					Set tSC = $$$OK
				}
				If (pDoc.ParentId'="")&&("Indiv"=..BatchErrorAction) {
					#; Avoid sending this rejected child along with the rest of the batch
					Set pDoc.ParentId = ""
					Set tSC = $$$ADDSC(tSC,pDoc.%Save())
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocID)=""
				}
			} ElseIf ("Indiv"=..BatchErrorAction)&&($Case(pDoc.Name,"Group":1,"Interchange":1,:0)) {
				#; All child documents were rejected
				Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code") = "R"
				Set tSCVal = $$$ERROR($$$EnsEDIX12AllChildrenFailedValidation,tDocID)
				Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocID)=""
				Set tSC = tSCVal
				If (pDoc.Name = "Group") {
					#; Remove the empty Group from the Interchange
					Set pDoc.ParentId = ""
					Set tSC =  $$$ADDSC(tSC,pDoc.%Save())
				}
			}
			Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Status")= tSCVal
		} Else {
			If '$D(^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code")) {
				Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code") = "A"
			}
			If '$D(^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Status")) {
				Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Status") = $$$OK
			}
			If (..BatchErrorAction'="Indiv") {
				Set tChild=$$$NULLOREF
				For {
					Set tChild=pDoc.NextChild(tChild)  Quit:tChild=$$$NULLOREF
					Set tCode=$G(^IRIS.Temp.EnsX12(..%ConfigName,0,tChild.getId(),"Code"))
					If tCode="R" {
						Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code")=tCode
						Set tSC = $$$ERROR($$$EnsEDIX12ChildFailedValidation,tDocID,tChild.Name,tChild.%Id())
						Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Status")=tSC
						Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocID)=""
						Quit
					} ElseIf tCode="E" {
						Set ^IRIS.Temp.EnsX12(..%ConfigName,0,tDocID,"Code")=tCode
						Quit
					}
				}
			}
		}

	} ElseIf "SNIP"=..ValMode {
		Set tSC = ..PerformSNIPValidation(pDoc,,,pSC)
		Set:($$$ISERR(tSC)&&(""=pDoc.ParentId)) ..%TopReplyCode = "R"
	}
	If $$$ISERR(tSC)&&'$$$ISERR(pSC) {
		$$$LOGSTATUS(tSC)
		Quit tSC
	}
	If (""'=..SearchTableClass) {
		try {
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",pDoc)
			If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for document "_pDoc_"/"_pDoc.getId()_" with DocType='"_pDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
		} catch { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_pDoc_"/"_pDoc.getId()_" with DocType='"_pDoc.DocType_"' : "_$$$StatusDisplayString($$$SystemError)) }
	}
	Quit tSC
}

/// Return the DocType that this service will assign to this document
Method resolveDocType(pDoc As EnsLib.EDI.X12.Document) As %String
{
	Set tDocType=pDoc.DocType
	If ""=tDocType {
		#; Match with the DocType specified if any in DocSchemaCategory for the received Document's type name
		Set tAcceptTypes=..DocSchemaCategory, tNameFound=pDoc.Name, tUNameFound=$ZCVT(tNameFound,"U")
		Set tImplGuide=""
		If "ST"=pDoc.GetValueAt("1:0") {
			Set tImplGuide=pDoc.GetValueAt("1:3")
			Set tImplGuide=$E(tImplGuide,$F(tImplGuide,"X")-1,*)
			If ""=tImplGuide {
				Set tGroup=pDoc.Parent
				Set:$IsObject(tGroup) tImplGuide=tGroup.GetValueAt("1:8")
				Set tImplGuide=$E(tImplGuide,$F(tImplGuide,"X")-1,*)
				If ""=tImplGuide {
					Set tRef=pDoc.FindSegment("REF")
					Set:$IsObject(tRef) tImplGuide=tRef.GetValueAt(2)
					Set tImplGuide=$E(tImplGuide,$F(tImplGuide,"X")-1,*)
				}
			}
		}
		Set tPurpose=$S("BHT"=pDoc.GetValueAt("2:0"):pDoc.GetValueAt("2:2"),1:"")
		Set nTypes=$S(""=$ZStrip(tAcceptTypes,"<>W"):0, 1:$L(tAcceptTypes,","))
		Set (tVal,tDef)=""
		For i=1:1:nTypes { Set tType=$P(tAcceptTypes,",",i) Continue:""=tType
			Set tVal=$ZStrip($P(tType,"=",2),"<>W")
			Set tName=$ZStrip($P(tType,"=",1),"<>W"), tNameLen=$L(tName), tUName=$ZCVT(tName,"U")
			If ""=tVal {
				Set:""=tDef tDef=tName
			} Else {
				#; Quit on match; accept trailing wildcard also
				If tUNameFound=tUName
				 || ("*"=$E(tName,tNameLen) && ($E(tUName,1,tNameLen-1)=$E(tUNameFound,1,tNameLen-1))) {
					If tVal[":" { Set tDocType=tVal }
					Else { Set tDocType=##class(EnsLib.EDI.X12.Schema).ResolveSchemaTypeToDocType(tVal,tNameFound,,tImplGuide,tPurpose) }
					Quit
				}
				Set tVal=""
			}
		}
		If ""'=tDocType {
			If tVal[":" {
				$$$sysTRACE("Using DocType='"_tDocType_"' for type name '"_tNameFound_"' matching '"_tUName_"' in DocSchemaCategory list; calling OnResolveDocType()")
			} Else {
				$$$sysTRACE("Using DocType='"_tDocType_"' from schema category '"_tVal_"' for type name '"_tNameFound_"' matching '"_tUName_"' in DocSchemaCategory list; calling OnResolveDocType()")
			}
		} ElseIf ""'=tVal {
			$$$sysTRACE("No DocType returned from ResolveSchemaTypeToDocType() using schema category "_tVal_" found for type name '"_tNameFound_"' matching '"_tUName_"' in DocSchemaCategory list '"_tAcceptTypes_"'; calling OnResolveDocType()")
		} ElseIf ""'=tDef {
			If tDef[":" {
				Set tDocType=tDef
				$$$sysTRACE("Using default DocType='"_tDocType_"' from DocSchemaCategory list '"_tAcceptTypes_"'; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
			} Else {
				Set tDocType=##class(EnsLib.EDI.X12.Schema).ResolveSchemaTypeToDocType(tDef,tNameFound,,tImplGuide,tPurpose)
				If ""'=tDocType {
					$$$sysTRACE("Using DocType='"_tDocType_"' returned from ResolveSchemaTypeToDocType() using default schema category in DocSchemaCategory list '"_tAcceptTypes_"'; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
				} Else {
					$$$sysTRACE("No DocType returned from ResolveSchemaTypeToDocType() using default schema category '"_tDef_"' in DocSchemaCategory list '"_tAcceptTypes_"'; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
				}
			}
		} Else {
			$$$sysTRACE("No match or default DocType found for type name '"_tNameFound_"' in DocSchemaCategory list '"_tAcceptTypes_"'; calling OnResolveDocType()")
		}
	} Else {
		$$$sysTRACE("Accepted document with DocType='"_tDocType_"'; calling OnResolveDocType()")
	}
	Set ttDocType=tDocType  If ..OnResolveDocType(pDoc,.ttDocType) {
		Set tDocType=$G(ttDocType)
		$$$sysTRACE("OnResolveDocType returned DocType="_tDocType)
	}
	Quit tDocType
}

/// pEarlyReply=0 means normal reply, -1 means "Immediate Commit Ack", 1 means Application reply
/// Return the appropriate reply code, or empty string if no Ack needed for the specified mode
Method getReplyCode(pDoc As EnsLib.EDI.Document, pSC As %Status, pSCVal As %Status, pEarlyReply As %Boolean) As %String
{
	If '($D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,pDoc.getId(),"Code"),tCode)#2)||(""=tCode) { 
		#; Choose the appropriate Status character
		Set tCode=$S(($$$ISERR(pSC)||$$$ISERR(pSCVal)):"R", 1:"A")
	}
	If pEarlyReply=-1 {
		Quit:"None"=..CommitAckType ""
	} Else {
		Set tCode=$Case(..ReplyMode,"Never":""
						, :$Case(..BatchReplyType
								,"None"    :""
								,"Errs"    :$S("A"'=tCode:tCode, ""=pDoc.ParentId:"A", 1:"")
								,"OnlyErrs":$S("A"'=tCode:tCode,1:"")
								,"Succ"    :$S(""=pDoc.ParentId:$S(""=..%TopReplyCode:"R",1:..%TopReplyCode), "A"'=tCode:"", 1:tCode)
								,"ErrTA1"  :$S("A"'=tCode:tCode,1:"")
								,"I14Err"  :$S("A"'=tCode:tCode,1:"")
								,:tCode))
		Quit:""=tCode ""
	}
	If "Succ"=..BatchReplyType { Set:"A"=tCode ..%TopReplyCode=tCode }
	Else { Set:$Case(tCode,"":0,"A":0,:1) ..%TopReplyCode=tCode }
	Quit:pDoc.ParentId=""&&(""'=..%TopReplyCode) ..%TopReplyCode
	Quit tCode
}

Method reportReply(pOriginalDoc As EnsLib.EDI.Document, pReplyCode As %String = "", ByRef pSC As %Status, pEarlyReply As %Integer = 0) As EnsLib.EDI.Document
{
	Set tSC=pSC, tID=pOriginalDoc.getId()
	Set tReplyDoc=..constructReply(pOriginalDoc,.pReplyCode,.pSC,pEarlyReply)
	If $$$ISERR(pSC) {
		If $D(^IRIS.Temp.EnsX12(..%ConfigName))&&$D(^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete")) {
			Set tDocToDelete = ""
			For {
				Set tDocToDelete = $O(^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocToDelete))	Quit:tDocToDelete=""
				If ##class(EnsLib.EDI.X12.Document).%ExistsId(tDocToDelete) {
					Set pSC = $$$ADDSC(pSC,##class(EnsLib.EDI.X12.Document).%DeleteId(tDocToDelete))
				}
			}
		}
		Kill ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete")
		Kill ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply)
		$$$LOGSTATUS(pSC)
		Quit $$$NULLOREF
	}
	If ""=pOriginalDoc.ParentId {
		If $IsObject(tReplyDoc) {
			Set pSC=$$$OK
			If ""'=..SearchTableClass && ..#IndexReplies && tReplyDoc.%Extends("EnsLib.EDI.Document") {
				Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",tReplyDoc)
				If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for reply document "_tReplyDoc_" / "_tReplyDoc.getId()_" with DocType='"_tReplyDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
			}
		} ElseIf ""=tReplyDoc { Quit "" }
		$$$sysTRACE("Reporting reply document '"_tReplyDoc_"' for document "_pOriginalDoc_" / "_tID)
		Set:$Case(..%outFraming,"uninitialized":(..%Parser.%outFraming'="xxf"),"xxf":1,:0) ..%outFraming=..%Parser.%outFraming
		Set pSC=..SendReply(tReplyDoc,pOriginalDoc)
		If $D(^IRIS.Temp.EnsX12(..%ConfigName))&&$D(^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete")) {
			Set tDocToDelete = ""
			For {
				Set tDocToDelete = $O(^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocToDelete))	Quit:tDocToDelete=""
				//Set tSC = $$$ADDSC(tSC,##class(EnsLib.EDI.X12.Document).DeleteDocumentAndChildren(tDocToDelete))
				If ##class(EnsLib.EDI.X12.Document).%ExistsId(tDocToDelete) {
					Set pSC = $$$ADDSC(pSC,##class(EnsLib.EDI.X12.Document).%DeleteId(tDocToDelete))
				}
			}
		}
		Kill ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete")
		Kill ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply)
	} Else {
		#; Remember individual reply docs for final batch reply
		If $IsObject(tReplyDoc) {
			Set pSC=$$$OK
			Set:$IsObject(pReplyCode) pReplyCode=..getReplyChildDocCode(tReplyDoc) ; get code from app reply object
			$$$sysTRACE("Deferring reply document "_tReplyDoc_" for document "_pOriginalDoc_" / "_tID)
			Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tID,"ID")=tReplyDoc.getId()

			If ""'=..SearchTableClass && ..#IndexReplies && tReplyDoc.%Extends("EnsLib.EDI.Document") {
				Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",tReplyDoc)
				If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for reply document "_tReplyDoc_" / "_tReplyDoc.getId()_" with DocType='"_tReplyDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
			}
		} Else {
			Set pReplyCode=tReplyDoc
			$$$sysTRACE("Deferring reply code "_pReplyCode_" for document "_pOriginalDoc_" / "_tID_"; status: "_$$$StatusDisplayString(tSC))
		}
		Quit:""=tReplyDoc $$$NULLOREF
	}
	If $$$ISERR(pSC) $$$LOGSTATUS(pSC)
	Quit $$$NULLOREF ; default behavior is not to return the reply doc from OnProcessInput()
}

/// get code from app reply object
Method getReplyChildDocCode(pAppReplyDoc As EnsLib.EDI.Document) As %String
{
	Quit "A" ; !! fish it out from the object...
}

Method constructReply(pOriginalDoc As EnsLib.EDI.Document, ByRef pReplyCode As %String, ByRef pSC As %Status, pEarlyReply As %Integer) As EnsLib.EDI.Document
{
	Set tReplyType=$S(pEarlyReply:..CommitAckType, 1:..BatchReplyType)
	Quit:'..%ISARequestsTA1&&$Case(tReplyType,"I14":1,"I14Err":1,:0) $$$NULLOREF
	Quit:""=..%TopReplyCode&&..%ConditionalReply $$$NULLOREF

	Set tSC=pSC, tOldCode=pReplyCode, pSC=..OnConstructReply(.tReplyDoc, pOriginalDoc,.pReplyCode,tSC,pEarlyReply)  If $$$ISERR(pSC) $$$LOGSTATUS(pSC) Quit $$$NULLOREF
	Set tOriginalDocID = pOriginalDoc.getId()
	Set:'$D(tReplyDoc) tReplyDoc=pReplyCode
	If $IsObject(tReplyDoc) {
		#; Customer-built reply; Quit with what we have
		If '$IsObject(tOldCode) $$$sysTRACE("OnConstructReply created batch reply document '"_tReplyDoc_" / "_tReplyDoc.getId()_"' for original document "_pOriginalDoc_" / "_tOriginalDocID_"; status: "_$$$StatusDisplayString(pSC))
		Set tReplyDoc.OriginalDocId=tOriginalDocID
		Quit tReplyDoc
	}
	Quit:pOriginalDoc.ParentId'="" tReplyDoc ; child doc; quit with what we have
	If pOriginalDoc.Name'="Interchange" {
		#; Non-Interchange parent doc - we should never be asked to reply to such a thing; this will be a strange result
		Set tReplyDoc=pOriginalDoc.NewReplyDocument("",..LocalApplicationID,.pSC)
		$$$sysTRACE("Constructed non-interchange reply document '"_tReplyDoc_"' for original document "_pOriginalDoc_" / "_tOriginalDocID_"; status: "_$$$StatusDisplayString(pSC))
		Set:$IsObject(tReplyDoc) tReplyDoc.OriginalDocId=tOriginalDocID
		Quit tReplyDoc
	}
	If tReplyType="Byte" {
		Quit:(""'=..%TopReplyCode) ..%TopReplyCode
		If $$$ISERR(tSC) || ($$$CodeTA1I18NoError '= ##class(EnsLib.EDI.X12.Validator).GetTA1Code(,pOriginalDoc)) {
			Quit "R"
		}
		Quit "A"
	}

	#; Create new Interchange document with the configured reply segments
	#; for each of the original doc's children
	Set pSC=tSC, tReplyDoc=..constructBatchReply(pOriginalDoc,.pSC,pEarlyReply)

	$$$sysTRACE("Constructed reply document '"_tReplyDoc_$S('$$$IsdefObject(tReplyDoc):"'",1:"' of type '"_tReplyDoc.Name_"'")_" for original document "_pOriginalDoc_" / "_tOriginalDocID_"; code: "_..%TopReplyCode_"; status: "_$$$StatusDisplayString(pSC))
	Quit tReplyDoc
}

/// Override this method to construct a customized reply document. Inputs are the original document and
///  the reply code and the status code that the framework produced in processing the original document.
///  If you change the status code but do not construct a reply document, the framework will use the new value to construct a standard reply document.
Method OnConstructReply(Output pReplyDoc As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document, ByRef pReplyCode As %String, ByRef pSC As %Status, pEarlyReply As %Boolean) As %Status
{
	Quit $$$OK
}

Method constructBatchReply(pOriginalDoc As EnsLib.EDI.X12.Document, ByRef pSC As %Status, pEarlyReply As %Boolean) As EnsLib.EDI.Document
{
	#dim tDoc As EnsLib.EDI.X12.Document
	#dim tSeg As EnsLib.EDI.X12.Segment
	#dim tOriginalDocID = pOriginalDoc.getId()
	#dim tEncounteredFirstErr As %Boolean = 0
	#dim tForceTA1,tInterchangeLevelErr As %Boolean = 0
	#dim tIncludeReplyBody As %Boolean = (..%Do997s && 'pEarlyReply && (""'=..%TopReplyCode))  ; %TopReplyCode is non-empty if we found any TS to report
	
	Kill %objlasterror
	Set tSC=pSC, pSC=$$$OK, tReplyDoc=pOriginalDoc.%New($LB("",$E(pOriginalDoc.Separators,1,3)_pOriginalDoc.SegmentTerminator))
	If '$IsObject(tReplyDoc) Set pSC=$$$ERROR($$$EnsEDIX12ErrGeneral,"Failed to instantiate reply document for doc "_tOriginalDocID_"; status = "_$G(%objlasterror,$$$OK))  Quit $$$NULLOREF
	Set:'$D(^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tOriginalDocID)) tReplyDoc.OriginalDocId=tOriginalDocID
	Set tCategory = pOriginalDoc.DocTypeCategory
	Do:""'=tCategory tReplyDoc.PokeDocType(tCategory_":Interchange")
	Set tISA=pOriginalDoc.GetSegmentAt(1)
	Set tReplyISA=pOriginalDoc.NewReplyHeaderSegs(tISA,..LocalApplicationID,.tReplyIEA,.pSC)  Quit:$$$ISERR(pSC) $$$NULLOREF
	Do:$IsObject(tReplyISA) tReplyDoc.AppendSegment(tReplyISA)
	Set tReplyType=$S(pEarlyReply:..CommitAckType, 1:..BatchReplyType)
	
	#; Include TA1 even if no Interchange-level error if BatchReplyType and/or ISA14 calls for it
	Set tForceTA1 = $Select(tReplyType="TA1":1,1:$Case(..%ForceTA1, -1:''..%ISARequestsTA1, :(..%ForceTA1>0)))
	If '$D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"TA1"),tTA1String) {
		Set tTA1Code=##class(EnsLib.EDI.X12.Validator).GetTA1Code(tSC)
		Set tTA1=pOriginalDoc.NewReplyTA1Seg(tISA, tTA1Code, .pSC)  Quit:$$$ISERR(pSC) $$$NULLOREF
		Do:..AddNackErrText&&$$$ISERR(tSC)&&$IsObject(tTA1) tTA1.SetValueAt($$$StatusDisplayString(tSC),$$$TA1InterchangeErrorText)
	} Else {
		Set tTA1 = ##class(EnsLib.EDI.X12.Segment).%New($LB(,,,tTA1String))
	}
	If $IsObject(tTA1) {
		#; Always include TA1 if Interchange-level error
		If $Case(tTA1.GetValueAt($$$TA1InterchangeNoteCode),"":0,$$$CodeTA1I18NoError:0,$$$CodeTA1I18InvalidContent:0,"999":0,:1) {
			Set tInterchangeLevelErr = 1
			#; No 997/999 if Interchange-level error and have selected one of these settings
			Set:((..BatchReplyType="AllI14TA1") || (..BatchErrorAction="First")) tIncludeReplyBody = 0
		}
		If tForceTA1 || tInterchangeLevelErr { 
			Set tSC = tReplyDoc.AppendSegment(tTA1)
		}
	}
	Set tUseChildGbl = $D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"Children"))
	If tIncludeReplyBody && (tUseChildGbl || (pOriginalDoc.ChildCount > 0)) {
		Set tDataElementSeparator=$E(pOriginalDoc.Separators,1)
		Set tGrpPlacehldr=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(pOriginalDoc.Separators,1,3)_"GroupDocsRef"_tDataElementSeparator_(2+(tForceTA1 || tInterchangeLevelErr))_tDataElementSeparator))
		Do:$IsObject(tGrpPlacehldr) tReplyDoc.AppendSegment(tGrpPlacehldr)
		
		#; Create Group document as child to reply Interchange
		Set tReplyGroup =##class(EnsLib.EDI.X12.Document).%New($LB("",$E(pOriginalDoc.Separators,1,3)_pOriginalDoc.SegmentTerminator))
		Set:""'=tCategory tSC=tReplyGroup.PokeDocType(tCategory_":Group")
		Set tReplyGS=pOriginalDoc.New997OuterGroupSegs(tISA,..LocalApplicationID,,,.tReplyGE,.pSC)  Quit:$$$ISERR(pSC) $$$NULLOREF
		If $IsObject(tReplyGS) {
			#; Adjust Reply GS08 if will be replying with a 999
			Set tGrp=$$$NULLOREF
			
			#; Start by finding first Group from the original
			If tUseChildGbl {
				Set tGrpID = ""
				For {
					Set tGrpID = $O(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"Children",tGrpID))	Quit:""=tGrpID
					Set tGrp = ##class(EnsLib.EDI.X12.Document).%OpenId(tGrpID)	Quit:'$IsObject(tGrp)
					Set tGS=tGrp.GetSegmentAt(1)	Continue:tGS.Name'="GS"
					Quit
				}
			} Else {
				For {
					Set tGrp=pOriginalDoc.NextChild(tGrp)  Quit:'$IsObject(tGrp)
					Set tGS=tGrp.GetSegmentAt(1)  Continue:tGS.Name'="GS"
					Set tGrpID = tGrp.getId()
					Quit
				}
			}
			If $IsObject(tGrp)&&$IsObject(tGS) {
				#; 997 will be 999 instead if version >= 5010 and HIPAA standard transaction
				Set tReplyVersion = ##class(EnsLib.EDI.X12.Document).DetermineReplyVersion(tGS.GetValueAt($$$GSVersionReleaseIndustryIdenti))
				If tReplyVersion=999 {
					Set tSC=tReplyGS.SetValueAt($$$999ImplementationRef,$$$GSVersionReleaseIndustryIdenti)  Quit:$$$ISERR(tSC) $$$NULLOREF
				}
				#; Also make sure that ISA12 value matches up with Version Number from GS08
				Set tVersion = $E(tReplyGS.GetValueAt($$$GSVersionReleaseIndustryIdenti),1,5)
				Set tSC=tReplyDoc.SetValueAt(tVersion,"1:"_$$$ISAInterchangeControlVersionNum)	Quit:$$$ISERR(tSC) $$$NULLOREF
			}
			Do tReplyGroup.AppendSegment(tReplyGS)
		}
		Set tTSPlacehldr=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(pOriginalDoc.Separators,1,3)_"TransactionSetDocsRef"_tDataElementSeparator_2_tDataElementSeparator))
		Do:$IsObject(tTSPlacehldr) tReplyGroup.AppendSegment(tTSPlacehldr)
		
		Set tNumGrps=0
		While $IsObject(tGrp) && ('tEncounteredFirstErr || (..BatchErrorAction'="First")) {
			Set tReplyGrp=$G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"ID"))
			Set tGS=tGrp.GetSegmentAt(1)
			If tGS.Name'="GS" {
				If tUseChildGbl {
					Set tGrpID = $O(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"Children",tGrpID))
					If tGrpID'="" {
						Set tGrp = ##class(EnsLib.EDI.X12.Document).%OpenId(tGrpID)
					} Else {
						Set tGrp=$$$NULLOREF
					}
				} Else {
					Set tGrp=pOriginalDoc.NextChild(tGrp)
					Set tGrpID = tGrp.getId()
				}
				Continue
			}
			Set tGE=tGrp.GetSegmentAt(tGrp.SegCount)
			Set tSCgrp=$G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"Status"),$$$OK)
			Set tSCgrp=$$$ADDSC(tSCgrp,$G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"SendErr"),$$$OK))
			#; Create Transaction Set as child to Group in reply Interchange
			Set tReplyTS = ##class(EnsLib.EDI.X12.Document).%New($LB("",$E(pOriginalDoc.Separators,1,3)_pOriginalDoc.SegmentTerminator))
			Set tReplyST=pOriginalDoc.NewGroupReply997Segs(tGS,$Select($IsObject(tGE)&&(tGE.Name="GE"):tGE,1:$$$NULLOREF),##class(EnsLib.EDI.X12.Validator).Get997GroupCodes(tSCgrp),.tReplyAK1,.tReplyAK9,.tReplySE,.pSC)  Quit:$$$ISERR(pSC)
			If "SNIP"=..ValMode {
				If '$D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"AK9")) {
					Set tSC = ..PerformSNIPGroupValidation(tGrp,pEarlyReply)
				}
				Set tReplyAK9String = $G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"AK9"))
				If ""'=tReplyAK9String {
					Set tReplyAK9 = ##class(EnsLib.EDI.X12.Segment).%New($LB(,,,tReplyAK9String))
				}
			}
			Set:($IsObject(tReplyAK9) && (""'=tReplyAK9.GetValueAt($$$AK9FunctionalGroupSyntaxErrorCo))) tEncounteredFirstErr = 1
			#; 997 will be 999 instead if version >= 5010 and HIPAA standard transaction
			Set tReplyType = ##class(EnsLib.EDI.X12.Document).DetermineReplyVersion(tGS.GetValueAt($$$GSVersionReleaseIndustryIdenti))
			#; AK5 will be IK5 instead if version >= 5010 and HIPAA standard transaction
			Set tGSGreater = (tReplyType>997)
			Set:""'=tCategory tSC=tReplyTS.PokeDocType(tCategory_":"_tReplyType)
			Do:$IsObject(tReplyST) tReplyTS.AppendSegment(tReplyST)
			Do:$IsObject(tReplyAK1) tReplyTS.AppendSegment(tReplyAK1)
			Set (tOrigDocs,tNumDocs,tNumAccepted)=0
			#; Loop over source documents and get the status for each
			Set tDoc=$$$NULLOREF,tNumDocs=0,tNumSegs=4
			If ('tEncounteredFirstErr || ("First"'=..BatchErrorAction)) {
				Set tDocID = ""
				Set tUseGrpChildGbl = $D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"Children"))
				For {
					If tUseGrpChildGbl {
						Set tDocID = $O(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"Children",tDocID))	Quit:""=tDocID
						If ..ValMode'="SNIP" {
							#; need to fetch ST Segment for call to EnsLib.EDI.X12.Document::NewDocumentReply997Segs()
							Set tDoc = ##class(EnsLib.EDI.X12.Document).%OpenId(tDocID)	Continue:'$IsObject(tDoc)
						}
					} Else {
						Set tDoc=tGrp.NextChild(tDoc)  Quit:'$IsObject(tDoc)
						Set tDocID = tDoc.getId()
					}
					If ..ValMode="SNIP" {
						If '($D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Code"),tCode)#2)&&$IsObject(tDoc) {
							Do ..PerformSNIPTSValidation(tDoc,tGSGreater,pEarlyReply,.tCode)
						}
						If $Case(..BatchReplyType,"Succ":("A"=tCode),"Errs":$Case(tCode,"R":1,"E":1,:0),"OnlyErrs":$Case(tCode,"R":1,"E":1,:0),:1) {
							Set tSegNum = ""
							For {
								Set tSegNum = $O(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",tSegNum),1,tSegString) Quit:""=tSegNum
								If ""'=tSegString {
									Set tSeg = ##class(EnsLib.EDI.X12.Segment).%New($LB(,,,tSegString))
									Do tReplyTS.AppendSegment(tSeg)
									Set tNumSegs = tNumSegs + 1
								}
							}
						}
						Set:(tCode'="A") tEncounteredFirstErr = 1
						Quit:(tEncounteredFirstErr && ("First"=..BatchErrorAction))

					} Else {
						If ('tEncounteredFirstErr || ("First"'=..BatchErrorAction)) {
							Set tSCdoc=$G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Status"),$$$OK)
							Set:$$$ISERR(tSCdoc) tEncounteredFirstErr = 1
							Set tST = tDoc.GetSegmentAt(1)
							If tST.Name'="ST" {
								#; create a temp segment to use in making the AK2
								Set tST = ##class(EnsLib.EDI.X12.Segment).%New($LB(,,,pOriginalDoc.Separators_"ST"_pOriginalDoc.ElementSeparator_+tDoc.DocTypeName))
							}

							If $Case(..BatchReplyType,"Succ":$$$ISOK(tSCdoc),"Errs":$$$ISERR(tSCdoc),"OnlyErrs":$$$ISERR(tSCdoc),:1) {
								Set tReplyAK2=pOriginalDoc.NewDocumentReply997Segs(tST,##class(EnsLib.EDI.X12.Validator).Get997Codes(tSCdoc),.tReplyAK5,.pSC,tGSGreater,(..BatchErrorAction'="Note"))  Quit:$$$ISERR(pSC)
								Do:$IsObject(tReplyAK2) tReplyTS.AppendSegment(tReplyAK2)
								#; AK3/AK4 / IK3/CTX/[IK4/CTX] optional
								Do:$$$ISERR(tSCdoc)&&..AddNackErrText tReplyAK5.SetValueAt($$$StatusDisplayString(tSCdoc),$$$AK5TransactionSetErrorText)
								
								Do:$IsObject(tReplyAK5) tReplyTS.AppendSegment(tReplyAK5)
								Set tNumSegs=tNumSegs+2
							}
							Set:($$$ISOK(tSCdoc)||(..BatchErrorAction="Note")) tNumAccepted=tNumAccepted+1
							Set tOrigDocs = tOrigDocs + 1
						}
						Set tNumDocs = tNumDocs + 1
					}
				}
			}
			If "SNIP"'=..ValMode {
				Set tSCd=$G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"Status"),$$$OK)
				#; fill in AK9: $$$AK9NumberofTransactionSetsInclu = 2, $$$AK9NumberofReceivedTransactionS = 3, $$$AK9NumberofAcceptedTransactionS = 4
				If $IsObject(tReplyAK9) {
					If tNumAccepted<tOrigDocs {
						If (0=tNumAccepted) || $Case(..BatchErrorAction,"All":1,"First":1,:0) {
							Do tReplyAK9.SetValueAt("R",$$$AK9FunctionalGroupAcknowledgeCo)
						} Else {
							Do tReplyAK9.SetValueAt("P",$$$AK9FunctionalGroupAcknowledgeCo)
						}
					} ElseIf $D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tGrpID,"Code"),tAK9Code) {
						Do tReplyAK9.SetValueAt(tAK9Code,$$$AK9FunctionalGroupAcknowledgeCo)
					}
					Do tReplyAK9.SetValueAt(tNumDocs,$$$AK9NumberofTransactionSetsInclu)
					Do tReplyAK9.SetValueAt(tOrigDocs,$$$AK9NumberofReceivedTransactionS)
					Do tReplyAK9.SetValueAt(tNumAccepted,$$$AK9NumberofAcceptedTransactionS)
					Do:$$$ISERR(tSCgrp)&&..AddNackErrText tReplyAK9.SetValueAt($$$StatusDisplayString(tSCgrp),$$$AK9FunctionalGroupErrorText)
				}
			}
			Do:$IsObject(tReplyAK9) tReplyTS.AppendSegment(tReplyAK9)
			Do:$IsObject(tReplySE) tReplySE.SetValueAt(tNumSegs,$$$SENumberofIncludedSegments), tReplyTS.AppendSegment(tReplySE)
			Set tSC=tReplyGroup.AddChild(2,tReplyTS)
			Set tNumGrps=tNumGrps+1
			
			If tUseChildGbl {
				Set tGrpID = $O(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"Children",tGrpID))
				If tGrpID'="" {
					Set tGrp = ##class(EnsLib.EDI.X12.Document).%OpenId(tGrpID)
				} Else {
					Set tGrp=$$$NULLOREF
				}
			} Else {
				Set tGrp=pOriginalDoc.NextChild(tGrp)
				Set:$IsObject(tGrp) tGrpID = tGrp.getId()
			}
		}
		Do:$IsObject(tReplyGE) tReplyGE.SetValueAt(tNumGrps,$$$GENumberofTransactionSetsInclu), tReplyGroup.AppendSegment(tReplyGE)
	}
	Set:$IsObject($G(tReplyGroup)) tSC=tReplyDoc.AddChild((2+(tForceTA1 || tInterchangeLevelErr)),tReplyGroup)
	If $IsObject(tReplyIEA) {
		Do tReplyIEA.SetValueAt($IsObject($G(tReplyGroup)),$$$IEANumberofIncludedFunctionalGr)
		Do tReplyDoc.AppendSegment(tReplyIEA)
	}
	$$$sysTRACE("Constructed batch reply document '"_tReplyDoc_" / "_tReplyDoc.getId()_"' for original document "_pOriginalDoc_" / "_tOriginalDocID_"; status: "_$$$StatusDisplayString(pSC))
	Quit tReplyDoc
}

Method PerformSNIPValidation(pOriginalDocument As EnsLib.EDI.X12.Document, pEarlyReply As %Boolean = 0, ByRef pReplyCode As %String, pSC As %Status = {$$$OK}) As %Status
{
	#dim tSC As %Status = $$$OK
	If "Interchange" = pOriginalDocument.Name {
		Do ..PerformSNIPInterchangeVal(pOriginalDocument,pEarlyReply,.pReplyCode, pSC)
	} ElseIf "Group" = pOriginalDocument.Name {
		Do ..PerformSNIPGroupValidation(pOriginalDocument,pEarlyReply,.pReplyCode)
	} Else {
		Set tGSGreater = 1
		If pOriginalDocument.ParentId'="" {
			Set tGroup = ##class(EnsLib.EDI.X12.Document).%OpenId($P(pOriginalDocument.ParentId,":"))
			If $IsObject(tGroup) {
				Set tReleaseID = tGroup.GetValueAt("1:"_$$$GSVersionReleaseIndustryIdenti)
				Set tReplyType = ##class(EnsLib.EDI.X12.Document).DetermineReplyVersion(tReleaseID)
				#; AK5 will be IK5 instead if version >= 5010 and HIPAA standard transaction
				Set tGSGreater = (tReplyType>997)
			}
		}
		Do ..PerformSNIPTSValidation(pOriginalDocument,tGSGreater,pEarlyReply,.pReplyCode)
	}
	Set tSC = ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,pOriginalDocument.getId(),"Status")
	Quit tSC
}

Method PerformSNIPInterchangeVal(pOriginalDoc As EnsLib.EDI.X12.Document, pEarlyReply As %Boolean = 0, ByRef pReplyCode As %String, pSC As %Status = {$$$OK}) As %Status
{
	#dim tSC,tStatus As %Status = $$$OK
	#dim tTA105Code As %String = $$$CodeTA1I18NoError
	#dim tHasGroupErrors As %Boolean = 0
	#dim tNumAccepted As %Integer = 0
	#dim tNumGroups As %Integer = 0
	#dim tOriginalDocID As %Integer = pOriginalDoc.getId()
	Set pReplyCode = ""
	
	Try {
		Set tTA105Code = ..GetInterchangeErrorCodes(pOriginalDoc, pSC)
		Set tTA1=pOriginalDoc.NewReplyTA1Seg(pOriginalDoc.GetSegmentAt(1), tTA105Code, .tSC, ("Note"'=..BatchErrorAction))
		If $IsObject(tTA1) {
			Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"TA1")=$E(pOriginalDoc.Separators,1,3)_$E(tTA1.OutputToString(),1,*-1)
			Quit:($$$CodeTA1I17Rejected=tTA1.GetValueAt($$$TA1InterchangeAcknowledgmentCod))&&("First"=..BatchErrorAction)
		}

		#; Loop over source documents and get the status for each
		Set tDoc=$$$NULLOREF
		For {
			Set tDoc=pOriginalDoc.NextChild(tDoc)  Quit:'$IsObject(tDoc)
			Continue:tDoc.Name'="Group"
			Set tNumGroups = $I(tNumGroups)
			Set tDocID = tDoc.getId()
			If '$D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Status"),tSCgroup) {
				If $$$ISERR(..PerformSNIPGroupValidation(tDoc,pEarlyReply,,.tHasGroupErrors)) {
					Set tSC = $$$ADDSC(tSC,$$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Attempted SNIP validation of child document %1 failed"),tDocID)))
					#; Add error code 024 if there is an error at the Functional Group level
					If tHasGroupErrors&&$IsObject(tTA1)&&(tTA105Code=$$$CodeTA1I18NoError) {
						Set $P(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"TA1"),pOriginalDoc.ElementSeparator,($$$TA1InterchangeNoteCode + 2)) = $$$CodeTA1I18InvalidContent
						Set $P(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"TA1"),pOriginalDoc.ElementSeparator,($$$TA1InterchangeAcknowledgmentCod + 2)) = $Case(..BatchErrorAction,"Note": $$$CodeTA1I17AcceptedButErrorsNoted, : $$$CodeTA1I17Rejected)
						#; Must set tTA105Code here so that we will set the right return code
						Set tTA105Code = $$$CodeTA1I18InvalidContent
					}
				}
				Set tSCgroup = $G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Status"))
			} ElseIf $$$ISERR(tSCgroup)&&$IsObject(tTA1)&&(tTA105Code=$$$CodeTA1I18NoError) {
				#; Function Group Sytax Error Codes only included if error is at Functional Group level - we don't need to add TS errrors to the TA1
				If ""'=$P($G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"AK9")),pOriginalDoc.ElementSeparator,2+$$$AK9FunctionalGroupSyntaxErrorCo,*) {
					Set $P(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"TA1"),pOriginalDoc.ElementSeparator,($$$TA1InterchangeNoteCode + 2)) = $$$CodeTA1I18InvalidContent
					Set $P(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"TA1"),pOriginalDoc.ElementSeparator,($$$TA1InterchangeAcknowledgmentCod + 2)) = $Case(..BatchErrorAction,"Note": $$$CodeTA1I17AcceptedButErrorsNoted, : $$$CodeTA1I17Rejected)
					#; Must set tTA105Code here so that we will set the right return code
					Set tTA105Code = $$$CodeTA1I18InvalidContent
				}
			}
			
			If ("Indiv"=..BatchErrorAction) {
				#; Remember that this child document existed so we can report about it in the ACK message
				Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"Children",tDocID)=""
				If $$$ISERR(tSCgroup) {
					#; Avoid sending this rejected Group along with the Interchange 
					Set tDoc.ParentId = ""
					Set tSC = $$$ADDSC(tSC,tDoc.%Save())
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocID)=""
				} Else {
					Set tNumAccepted = $I(tNumAccepted)
				}
			} ElseIf $$$ISERR(tSCgroup) {
				If $Case(..BatchErrorAction,"First":1,"All":1,:0){
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocID)=""
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tOriginalDocID)=""
					#; Must set tTA105Code here so that we will set the right return code
					Set tTA105Code = $$$CodeTA1I18InvalidContent
				}
				Quit:("First"=..BatchErrorAction)
			} Else {
				Set tNumAccepted = $I(tNumAccepted)
			}
		}
		If ("Indiv"=..BatchErrorAction) {
			If pOriginalDoc.ChildCount > 0 {
				Do pOriginalDoc.SetValueAt(pOriginalDoc.ChildCount,"GroupDocsRef:"_$$$REFSEGFLDCOUNT)
				Do pOriginalDoc.SetValueAt(pOriginalDoc.ChildCount,"IEA:"_$$$IEANumberofIncludedFunctionalGr)	
				Set tSC = $$$ADDSC(tSC,pOriginalDoc.%Save())
			} Else {
				Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tOriginalDocID)=""
				Set tSC = $$$ERROR($$$EnsEDIX12AllChildrenFailedValidation,tOriginalDocID)
			}
		}
	} Catch ex {
		Set tSC = $$$ADDSC(tSC,ex.AsStatus())
	}
	Set:$$$ISERR(tSC) tSC = $$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Attempted SNIP validation of document %1 failed due to error '%2'"),tOriginalDocID,$System.Status.GetErrorText(tSC)))
	Set tStatus = tSC
	If (($$$CodeTA1I18NoError=tTA105Code)) {
		Set pReplyCode = $$$CodeTA1I17Accepted
	} ElseIf ("Note"=..BatchErrorAction)&&$$$ISOK(tSC)&&tNumAccepted {
		Set pReplyCode = $$$CodeTA1I17AcceptedButErrorsNoted
	} ElseIf ($$$CodeTA1I18InvalidContent=tTA105Code) {
		Set pReplyCode = $$$CodeTA1I17Accepted
		Set:'$$$ISERR(tStatus) tStatus = $$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Document %1 failed SNIP validation due to validation failure(s) of child document(s)"),tOriginalDocID))
	} Else {
		Set pReplyCode = $$$CodeTA1I17Rejected
		Set:'$$$ISERR(tStatus) tStatus = $$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Document %1 failed SNIP validation"),tOriginalDocID))
	}
	Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"Code")=pReplyCode
	Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tOriginalDocID,"Status")=tStatus
	Quit tSC
}

Method PerformSNIPGroupValidation(pOriginalDoc As EnsLib.EDI.X12.Document, pEarlyReply As %Boolean = 0, ByRef pReplyCode As %String, ByRef pHasGroupErrs As %Boolean = 0) As %Status
{
	Try {
		Set pReplyCode = ""
		#dim tSC,tStatus As %Status = $$$OK
		#dim tAK9ErrCodes,tTSCode,tReplyAK9 As %String = ""
		#dim tAK9Code As %String = $$$CodeAK9715Accepted
		#dim tST = pOriginalDoc.GetSegmentAt(1)
		#dim tDocID = pOriginalDoc.getId()
		#dim tOrigDocs, tNumAccepted, tErrCount As %Integer = 0
		#dim tNumDocs As %Integer = pOriginalDoc.ChildCount
		#dim tDoc As EnsLib.EDI.X12.Document
		#dim tEleSep = pOriginalDoc.ElementSeparator
		
		Set tAK9ErrCodes = ..GetGroupErrorCodes(pOriginalDoc)
		Set pHasGroupErrs = (""'=tAK9ErrCodes)

		Set $P(tReplyAK9,tEleSep,$$$AK9NumberofReceivedTransactionS) = pOriginalDoc.GetValueAt("GE:"_$$$GENumberofTransactionSetsInclu)
		#; Populate Error Code fields if there are errors to report
		For i=1:1:5 {
			Set tOneCode=$ZStrip($P(tAK9ErrCodes,",",i),"<>W")
			#; Field 5 only included if Field 1 = E or R
			#; Fields 6-9 only included if Field 1 = E or R, previous field used, and there are (additional) error codes to report
			Continue:$Case(tOneCode,"":1,0:1,"00":1,$$$CodeTA1I18NoError:1,:0)
			Set $P(tReplyAK9,tEleSep,$$$AK9FunctionalGroupSyntaxErrorCo+tErrCount) = tOneCode
			Set tErrCount = $I(tErrCount)
		}
		If 'tErrCount || ("First"'=..BatchErrorAction) {
		
			Set tReplyType = ##class(EnsLib.EDI.X12.Document).DetermineReplyVersion(pOriginalDoc.GetValueAt("GS:"_$$$GSVersionReleaseIndustryIdenti))
			#; AK5 will be IK5 instead if version >= 5010 and HIPAA standard transaction
			Set tGSGreater = (tReplyType>997)
			
			#; Loop over source documents and get the status for each
			Set tDoc=$$$NULLOREF
			For {
				Set tDoc=pOriginalDoc.NextChild(tDoc)  Quit:'$IsObject(tDoc)
				Set tTSid = tDoc.getId()
				If $D(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tTSid,"Status")) {
					Set tTSCode = $G(^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tTSid,"Code"))
				} Else {
					If $$$ISERR(..PerformSNIPTSValidation(tDoc,tGSGreater,pEarlyReply,.tTSCode)) {
						Set tSC = $$$ADDSC(tSC,$$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Attempted SNIP validation of child document %1 failed"),tTSid)))
					}
				}
				If ("Indiv"=..BatchErrorAction) {
					#; Remember that this child document existed so we can report about it in the ACK message
					Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Children",tTSid)=""
					If $$$CodeAK5717Rejected=tTSCode {
						#; Avoid sending this rejected TS along with the rest of the Group
						Set tDoc.ParentId = ""
						Set tSC = $$$ADDSC(tSC, tDoc.%Save())
						Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tTSid)=""
					}
				}
				Set tOrigDocs=tOrigDocs+1
				Set:$Case(tTSCode,$$$CodeAK5717Accepted:1,$$$CodeAK5717AcceptedButErrorsNoted:1,:0) tNumAccepted=tNumAccepted+1
				Set:(tTSCode=$$$CodeAK5717AcceptedButErrorsNoted) tAK9Code = $$$CodeAK9715AcceptedButErrorsNoted
				Quit:("First"=..BatchErrorAction)&&($$$CodeAK5717Rejected=tTSCode)
			}
			If ("Indiv"=..BatchErrorAction) {
				If pOriginalDoc.ChildCount > 0 {
					Do pOriginalDoc.SetValueAt(pOriginalDoc.ChildCount,"TransactionSetDocsRef:"_$$$REFSEGFLDCOUNT)
					Do pOriginalDoc.SetValueAt(pOriginalDoc.ChildCount,"GE:"_$$$GENumberofTransactionSetsInclu)
					Set tSC = $$$ADDSC(tSC, pOriginalDoc.%Save())
				}
			}

			#; Set the appropriate Functional Group Acknowledgement Code based on Transaction Set results
			If tNumAccepted<tOrigDocs {
				If (0=tNumAccepted) || $Case(..BatchErrorAction,"All":1,"First":1,:0) {
					Set tAK9Code = $$$CodeAK9715Rejected
					Set ^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",pOriginalDoc.%Id())=""
				} Else {
					Set tAK9Code = $$$CodeAK9715PartiallyAccepted
				}
			}
		}
		#; fill in AK9: $$$AK9FunctionalGroupAcknowledgeCo = 1, $$$AK9NumberofTransactionSetsInclu = 2, $$$AK9NumberofReceivedTransactionS = 3, $$$AK9NumberofAcceptedTransactionS = 4
		Set:""'=tAK9ErrCodes tAK9Code = $S("Note"=..BatchErrorAction:$$$CodeAK9715AcceptedButErrorsNoted ,1:$$$CodeAK9715Rejected)
		Set $P(tReplyAK9,tEleSep,$$$AK9FunctionalGroupAcknowledgeCo)=tAK9Code
		Set $P(tReplyAK9,tEleSep,$$$AK9NumberofTransactionSetsInclu)=tNumDocs
		Set $P(tReplyAK9,tEleSep,$$$AK9NumberofReceivedTransactionS)=tOrigDocs
		Set $P(tReplyAK9,tEleSep,$$$AK9NumberofAcceptedTransactionS)=tNumAccepted
		Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"AK9")=$E(pOriginalDoc.Separators,1,3)_"AK9"_tEleSep_tReplyAK9
	} Catch ex {
		Set tSC = $$$ADDSC(tSC,ex.AsStatus())
	}
	Set:$$$ISERR(tSC) tSC = $$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Attempted SNIP validation of document %1 failed due to error '%2'"),tDocID,$System.Status.GetErrorText(tSC)))
	Set tStatus = tSC
	If (tNumAccepted = tOrigDocs) && (""=tAK9ErrCodes) {
		Set pReplyCode = $$$CodeAK9715Accepted
	} ElseIf "Note"=..BatchErrorAction {
		Set pReplyCode = $$$CodeAK9715AcceptedButErrorsNoted
	} ElseIf ("Indiv"=..BatchErrorAction)&&(""=tAK9ErrCodes)&&(tNumAccepted>0) {
		Set pReplyCode = $$$CodeAK9715PartiallyAccepted
	} Else {
		Set pReplyCode = $$$CodeAK9715Rejected
		Set tStatus = $$$ADDSC(tStatus,$$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Document %1 failed SNIP validation"),tDocID)))
	}
	Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Code")=pReplyCode
	Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Status")=tStatus
	Quit tSC
}

Method PerformSNIPTSValidation(pOriginalDoc As EnsLib.EDI.X12.Document, pGSGreater As %Boolean = 1, pEarlyReply As %Boolean = 0, ByRef pReplyCode As %String) As %Status
{
	#dim tSC,tStatus As %Status = $$$OK
	#dim tSegCount,tOneSegCode, tErrCount As %Integer = 0
	#dim tAK5Codes As %String = ""
	#dim tHasSegErrors As %Boolean = 0
	#dim tCompSep = pOriginalDoc.ComponentSeparator
	#dim tEleSep = pOriginalDoc.ElementSeparator
	#dim tSeparators = $E(pOriginalDoc.Separators,1,3)
	Set pReplyCode = ""
	
	Try {
		#dim tST As EnsLib.EDI.X12.Segment = pOriginalDoc.GetSegmentAt(1)
		#dim tDocID As %Integer = pOriginalDoc.getId()
		#dim tOriginalSegCount As %Integer = pOriginalDoc.SegCount
		#dim tReplyAK2, tReplyAK5 As EnsLib.EDI.X12.Segment
		#dim tTSDocType As %String = $Case($E(pOriginalDoc.DocType),"+":$E(pOriginalDoc.DocType,2,*),"-":$E(pOriginalDoc.DocType,2,*),:pOriginalDoc.DocType)
		
		Set tAK5Codes = ..GetTransactionSetErrorCodes(pOriginalDoc,.tSegErrs)
		Quit:((""'=tAK5Codes)&&("Succ"=..BatchReplyType))
		
		If tST.Name="ST" {
			Set tReplyAK2=##class(EnsLib.EDI.X12.Document).NewDocumentReply997Segs(tST,tAK5Codes,.tReplyAK5,.tSC,pGSGreater,("Note"'=..BatchErrorAction))
			Set:$IsObject(tReplyAK2) ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tSeparators_$E(tReplyAK2.OutputToString(),1,*-1)
			
			If tTSDocType'="" {
				Set tSegIndex = 0
				For {
					Set tSegIndex = $I(tSegIndex)
					If (tSegIndex > tOriginalSegCount) {
						If '$D(tSegErrs(tSegIndex)) {
							Set tSegIndex = $O(tSegErrs(tSegIndex))
							Quit:""=tSegIndex
						}
					} Else {
						Set tSeg = pOriginalDoc.GetSegmentAt(tSegIndex,.tSC)
						Quit:'$IsObject(tSeg)
					}
					Set tSegPath = pOriginalDoc.GetSegmentPath(tSegIndex,.tSCPath)
					If $$$ISERR(tSCPath) {
						#; there was a BuildMap issue with this segment, so we can't find the path, but we can still check for errors within the segment
						Set tLoop = ""
					} Else {					
						#; Find which loop segment is in
						If pOriginalDoc.useValSchema {
							Set tLoop = $Select($L(tSegPath,".")>1:$E($P(tSegPath,".",*-1),1,4),1:"")
						} Else {
							Set tLoop = $Select(tSegPath["loop":$E($P($P(tSegPath,"loop",*),"."),1,4),1:"")
						}
					}
		
					Set tDataElemErrs = 0
					Set tOneSegCode = 0
					#; Check to see if we found segment-level errors for this segment during the BuildMap
					If $D(tSegErrs(tSegIndex))="10" {
						Set tErrCount = +$O(tSegErrs(tSegIndex,""))
						Set:0'=tErrCount tOneSegCode = +$O(tSegErrs(tSegIndex,tErrCount,""),1,tSegName)
						If $L(tSegName,".")=2 {
							Set tLoop = $P(tSegName,".",1)
							Set tSegName = $P(tSegName,".",2)
						} Else {
							Set tLoop = ""
						}
						Set tSegLocData = tSegName_tEleSep_tSegIndex_tEleSep_tLoop
					} Else {
						Set tSegLocData = tSeg.Name_tEleSep_tSegIndex_tEleSep_tLoop
						Kill tDataElemErrs
						Set tOneSegCode = ..GetSegmentErrors(tSeg,tTSDocType,pGSGreater,.tDataElemErrs)
						#; Don't want to report unrecognized segment as unexpected too, but do want to record when a known segment isn't expected
						If $$$ISERR(tSCPath) && (tOneSegCode'=$$$CodeAK3720UnrecognizedSegmentID) {
							Set tIK3String = tSeparators_$S(pGSGreater:"IK3",1:"AK3")_tEleSep_tSegLocData_tEleSep_$$$CodeAK3720UnexpectedSegment
							Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tIK3String
						}
					}
					While (tOneSegCode'=0) {
						If 'tHasSegErrors {
							Set tHasSegErrors = 1
							Quit:"Succ"=..BatchReplyType
						}
						Set tIK3String = tSeparators_$S(pGSGreater:"IK3",1:"AK3")_tEleSep_tSegLocData_tEleSep_tOneSegCode
						Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tIK3String
						If pGSGreater {
							Set tSegInBU = 0
							#; Check if segment in Business Unit
							Set ttStrippedPath = $Replace(tSegPath,"loop","")
							Set tStrippedPath = $P(ttStrippedPath,")",*)
							If ttStrippedPath[")" {
								For l=($L(ttStrippedPath,")")-1):-1:1 {
									Set tStrippedPath = $P($P(ttStrippedPath,")",l),"(")_"()"_tStrippedPath
								}
							}
							For l=($L(tStrippedPath,".")-1):-1:1 {
								If $D($$$vaVSchemaGbl($P(tTSDocType,":"),$P(tTSDocType,":",2),"bu",$P(tStrippedPath,".",1,l)),tContext)#2 {
									If pOriginalDoc.useValSchema {
										Set tBUVal = pOriginalDoc.GetValueAt($P(tSegPath,".",1,l)_"."_$P(tContext,"|",1)_"-"_$P(tContext,"|",3)_":"_$P(tContext,"|",2))
									} Else {
										Set tBUVal = pOriginalDoc.GetValueAt($P(tSegPath,".",1,l)_"."_$P(tContext,"|",1)_":"_$P(tContext,"|",2))
									}
									Set tBUName = $P(tContext,"|",4)
									Set tSegInBU = 1
									Quit
								}
							}
							If 'tSegInBU && $D($$$vaVSchemaGbl($P(tTSDocType,":"),$P(tTSDocType,":",2),"bu","-"),tContext)#2 {
								If pOriginalDoc.useValSchema {
									Set tBUVal = pOriginalDoc.GetValueAt($P(tContext,"|",1)_"-"_$P(tContext,"|",3)_":"_$P(tContext,"|",2))
								} Else {
									Set tBUVal = pOriginalDoc.GetValueAt($P(tContext,"|",1)_":"_$P(tContext,"|",2))
								}
								Set tBUName = $P(tContext,"|",4)
								Set tSegInBU = 1
							}
							If tSegInBU && (tBUVal'="") {
								Set tCTXString = tSeparators_"CTX"_tEleSep_tBUName_tCompSep_tBUVal
								Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tCTXString
							}
						}
						
						Set tIK4Count = +tDataElemErrs
						For i4=1:1:tIK4Count {
							Set tIK4Data = tDataElemErrs(i4)
							Set tIK4String = tSeparators_$S(pGSGreater:"IK4",1:"AK4")_tEleSep_$LG(tIK4Data,1)_tEleSep_$LG(tIK4Data,2)_$Select($LL(tIK4Data)>2:tEleSep_$LG(tIK4Data,3),1:"")
							Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tIK4String
							#; If constructing a 999 and code is 2 or 10, then create CTX segment
							If pGSGreater&&$Case(+$LG(tIK4Data,2),$$$CodeAK4723ConditionalRequiredDataElementMissing:1,$$$CodeAK4723ExclusionConditionViolated:1,:0) {
								Set tCTXString = tSeparators_"CTX"_tEleSep_"SITUATIONAL TRIGGER"_tEleSep_tSegLocData_tEleSep_$LG(tIK4Data,1)
								Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tCTXString
							}
						}
						#; Retrieve next segment-level error code if found in BuildMap
						#; Otherwise, we will have already captured everything at this point
						If ($D(tSegErrs(tSegIndex))="10")&&(tErrCount'=0) {
							Set tErrCount = +$O(tSegErrs(tSegIndex,tErrCount))
							If (0=tErrCount) {
								If (tOneSegCode'=1) {
									Set tSegLocData = tSeg.Name_tEleSep_tSegIndex_tEleSep_tLoop
									Kill tDataElemErrs
									Set tOneSegCode = ..GetSegmentErrors(tSeg,tTSDocType,pGSGreater,.tDataElemErrs)
								} Else {
									Set tOneSegCode = 0
								}
							} Else {
								Set tOneSegCode = +$O(tSegErrs(tSegIndex,tErrCount,""),1,tSegName)
								If $L(tSegName,".")=2 {
									Set tLoop = $P(tSegName,".",1)
									Set tSegName = $P(tSegName,".",2)
								} Else {
									Set tLoop = ""
								}
								Set tSegLocData = tSegName_tEleSep_tSegIndex_tEleSep_tLoop
							}
						} Else {
							Set tOneSegCode = 0
						}	
					}
				}
				If tHasSegErrors&&(tAK5Codes'[$$$CodeAK5718OneOrMoreSegmentsInError)&&($L(tAK5Codes,",")<5) {
					Do tReplyAK5.SetValueAt($S("Note"=..BatchErrorAction:$$$CodeAK5717AcceptedButErrorsNoted,1:$$$CodeAK5717Rejected),1)
					Do tReplyAK5.SetValueAt($$$CodeAK5718OneOrMoreSegmentsInError,2+$S(""=tAK5Codes:0,1:$L(tAK5Codes,",")))
				}
			}
		} Else {
			#; create a temp segment to use in making the AK2
			Set tSeg = ##class(EnsLib.EDI.X12.Segment).%New($LB(,,,pOriginalDoc.Separators_"ST"_pOriginalDoc.ElementSeparator_+pOriginalDoc.DocTypeName))
			Set tReplyAK2=##class(EnsLib.EDI.X12.Document).NewDocumentReply997Segs(tSeg,tAK5Codes,.tReplyAK5,.tSC,pGSGreater,("Note"'=..BatchErrorAction))
			Set:$IsObject(tReplyAK2) ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tSeparators_$E(tReplyAK2.OutputToString(),1,*-1)
			#; Report the missing ST as an IK3/AK3 error
			Set tIK3String = tSeparators_$S(pGSGreater:"IK3",1:"AK3")_tEleSep_"ST"_tEleSep_"1"_tEleSep_tEleSep_$$$CodeAK3720MandatorySegmentMissing
			Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tIK3String			
			Do tReplyAK5.SetValueAt($$$CodeAK5718OneOrMoreSegmentsInError,2+$L(tAK5Codes,","))
		}
		Set:$IsObject(tReplyAK5) ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Segs",$I(tSegCount)) = tSeparators_$E(tReplyAK5.OutputToString(),1,*-1)
		If tTSDocType'=pOriginalDoc.DocType {
			Do pOriginalDoc.PokeDocType(tTSDocType)
			Do pOriginalDoc.BuildMap(1)
		}

	} Catch ex {
		Set tSC = $$$ADDSC(tSC,ex.AsStatus())
	}
	Set:$$$ISERR(tSC) tSC = $$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Attempted SNIP validation of document %1 failed due to error '%2'"),tDocID,$System.Status.GetErrorText(tSC)))
	Set tStatus = tSC
	If ((""=tAK5Codes) && 'tHasSegErrors) {
		Set pReplyCode = $$$CodeAK5717Accepted
	} ElseIf "Note"=..BatchErrorAction {
		Set pReplyCode = $$$CodeAK5717AcceptedButErrorsNoted
	} Else {
		Set pReplyCode = $$$CodeAK5717Rejected
		Set tStatus = $$$ADDSC(tStatus,$$$ERROR($$$EnsEDIX12ErrGeneral,$$$FormatText($$$Text("Document %1 failed SNIP validation"),tDocID)))
	}
	Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Code")=pReplyCode
	Set ^IRIS.Temp.EnsX12(..%ConfigName,pEarlyReply,tDocID,"Status")=tStatus
	Quit tSC
}

Method GetInterchangeErrorCodes(pInterchange As EnsLib.EDI.X12.Document, pSC As %Status = {$$$OK}) As %String
{
	Set tCode = ##class(EnsLib.EDI.X12.Validator).GetTA1Code(pSC,pInterchange)
	Quit:(tCode="999") $$$CodeTA1I18NoError
	Quit tCode
}

Method GetGroupErrorCodes(pGroup As EnsLib.EDI.X12.Document) As %String
{
	Quit ##class(EnsLib.EDI.X12.Validator).Get997GroupCodes(,pGroup)
}

Method GetTransactionSetErrorCodes(pTransactionSet As EnsLib.EDI.X12.Document, ByRef pIK3Errs) As %String
{
	#dim tCodes As %String = ""
	#; Evaluate possible Transaction Set errors to determine AK502 value
	If pTransactionSet.GetValueAt("1:0")'="ST" {
		Set pIK3Errs(1,1,$$$CodeAK3720MandatorySegmentMissing) = "ST"
		Quit $$$CodeAK5718MissingOrInvalidTransactionSetIdentifier_","_$$$CodeAK5718MissingOrInvalidTransactionSetControlNumber
	} ElseIf ""=pTransactionSet.GetValueAt("1:"_$$$STTransactionSetIdentifierCode) {
		#; Missing or Invalid Transaction Identifier
		Set tCodes = tCodes_","_$$$CodeAK5718MissingOrInvalidTransactionSetIdentifier
	} Else {
		Set tDocType = pTransactionSet.resolveChildDocType()
		Set:$Case($E(tDocType),"-":1,"+":1,:0) tDocType=$E(tDocType,2,*)
		If (tDocType="")||($P(tDocType,":")="") {
			#; Transaction Set Not Supported
			Set tCodes=tCodes_","_$$$CodeAK5718TransactionSetNotSupported
		} Else {
			Set tCategory = $P(tDocType,":")
			If (..SNIPLevel > 1) {
				Do pTransactionSet.PokeDocType("-"_tDocType)
			} ElseIf ($D($$$vaVSchemaGbl(tCategory))&&$G($$$vaSchemaGbl(tCategory,"useOld"))) {
				Do pTransactionSet.PokeDocType("+"_tDocType)
			}
			Set tSC = pTransactionSet.BuildMap((..BatchErrorAction'="First"),1)
			#; BuildMap errors are IK3 errors
			If $$$ISERR(tSC) {
				Do $System.Status.DecomposeStatus(tSC,.tErrList)
				#; For each error, determine which error code and find the segment name and location for reporting in the IK3
				For e=1:1:+$G(tErrList) {
					Set tCode = $G(tErrList(e,"code"))
					Set tIK3Code=""
					If (tCode="<EnsEDI>ErrMapSegUnrecog") {
						Set tSeg = $G(tErrList(e,"param",1))
						Set tLocation = 1 + $G(tErrList(e,"param",2)) ; location reported in error was %seglastmatch, which is the one before the error
						#; Test to see whether we recognize this segment name
						Set tSegFound = 0
						Set tCategory = $P(tDocType,":")
						For {
							If $D($$$vaSchemaGbl(tCategory,"SS",tSeg))#2 {
								Set tSegFound = 1
								Quit
							} ElseIf '$D($$$vaSchemaGbl(tCategory,"base"),tCategory) {
								Quit
							}
						}
						If 'tSegFound {
							#; Unrecognized Segment ID
							Set tIK3Code = $$$CodeAK3720UnrecognizedSegmentID
						} Else {
							#; Unexpected segment
							Set tIK3Code = $$$CodeAK3720UnexpectedSegment
						}
					} ElseIf (tCode = "<EnsEDI>ErrMapSegCount") {
						#; ErrMapSegCount has extra parameter for repeat count as its first parameter, segment name and location are parameters 2 and 3
						Set tSeg = $G(tErrList(e,"param",2))
						#; Required Segment Missing
						Set tLocation = +$G(tErrList(e,"param",3))
						Set tIK3Code = $$$CodeAK3720MandatorySegmentMissing
					} ElseIf (tCode = "<EnsEDI>ErrMapRequired") || (tCode = "<EnsEDI>ErrMapRequiredUnion") {
						Set tSeg = $G(tErrList(e,"param",1))
						#; Missing SE will be reported in AK5
						Continue:($P(tSeg,"-")="SE")&&(pTransactionSet.GetValueAt(pTransactionSet.SegCount_":0")'="SE")
						Set tLocation = +$G(tErrList(e,"param",2))
						#; Required Segment Missing
						Set tIK3Code = $$$CodeAK3720MandatorySegmentMissing
					}
					#; Else not an error for which we have a specific IK3 code
					If ""'=tIK3Code {
						Set tSegName = $P($P($P($P(tSeg,".",*),"!"),"-"),"(")	; get just the name and no ordinal, keyfield, or repetition info
						Set tLoop = $S($L(tSeg,".")>1:+$P($P(tSeg,".",*-1),"loop",*)_".",1:"")
						Set pIK3Errs(tLocation,e,tIK3Code) = tLoop_tSegName ; include loop number if segment is in one
					}
					Set:tCodes'[(","_$$$CodeAK5718OneOrMoreSegmentsInError) tCodes = tCodes_","_$$$CodeAK5718OneOrMoreSegmentsInError
				}
			}
		}
	}
	
	If (..SNIPLevel > 1) && (""=pTransactionSet.GetValueAt("1:"_$$$STTransactionSetControlNumber)) {
		#; Missing or Invalid Transaction Set Control Number
		Set tCodes = tCodes_","_$$$CodeAK5718MissingOrInvalidTransactionSetControlNumber
	}
	
	Set tSE = pTransactionSet.GetSegmentAt(pTransactionSet.SegCount,.tSC)
	If ($IsObject(tSE) && (tSE.Name="SE")) {
		#; Number of included segments doesn't match actual count
		Set:tSE.GetValueAt($$$SENumberofIncludedSegments)'=pTransactionSet.SegCount tCodes = tCodes_","_$$$CodeAK5718NumberOfIncludedSegmentsMismatch
		If ((..SNIPLevel > 1) && (tCodes'[(","_$$$CodeAK5718MissingOrInvalidTransactionSetControlNumber))) {
			If (pTransactionSet.GetValueAt("1:"_$$$STTransactionSetControlNumber)'=tSE.GetValueAt($$$SETransactionSetControlNumber)) {
				#; control number mismatch
				Set tCodes = tCodes_","_$$$CodeAK5718TransactionSetControlNumberMismatch
			}
		}
	} Else {
		#; Transaction Set Trailer Missing
		Set tCodes = tCodes_","_$$$CodeAK5718TransactionSetTrailerMissing
	}
	
	Quit $E(tCodes,2,*)
}

Method GetSegmentErrors(pSegment As EnsLib.EDI.X12.Segment, pDocType As %String = "", pGSGreater As %Boolean = 1, ByRef pDataElemErrs) As %Integer
{
	#dim tIK304 As %Integer = 0
	#dim tOrdinal As %Integer = +$P(pSegment.DocTypeName,"-",*)
	#dim tElemCount,tReps,tMinLen,tMaxLen,tLength,tFieldNum As %Integer
	#dim tMatches As %Boolean
	#dim tDTFormat,tOldData,tOldCompData As %String = ""
	#dim tCompSep As %String = pSegment.CS
	#dim tEleSep As %String = pSegment.ES
	#; this captures whether we both are doing SNIP 2 and have the info we need for thorough SNIP 2 validation
	#; if there were BuildMap errors, then we'll have to go off only what we know from the new-style schema structure
	#dim UseHigherSNIPLevel = (tOrdinal>0) && (..SNIPLevel > 1) 
	
	Do {
		#dim tCategory As %String = $P(pDocType,":")
		#dim tSegFound As %Boolean = 0
		Set:'$D(pDataElemErrs) pDataElemErrs = 0
		If tCategory'="" {
			For {
				If $D($$$vaSchemaGbl(tCategory,"SS",pSegment.Name),tSegData)#2 {
					Set tSegFound = 1
					Quit
				} ElseIf '$D($$$vaSchemaGbl(tCategory,"base"),tCategory) {
					Quit
				}
			}
		}
		If 'tSegFound {
			Set tIK304 = $$$CodeAK3720UnrecognizedSegmentID
			Quit
		}

		Set tElemCount = pSegment.Count ; avoid repeated calls to CountGet()
		For tFieldNum=1:1:tElemCount {
			Quit:tFieldNum>$LL(tSegData)
			Set tValue = pSegment.GetValueAt(tFieldNum)
			Set tElemData = $LG(tSegData,tFieldNum)
			Set:UseHigherSNIPLevel tOldData = $G($$$vaVSchemaGbl($P(pDocType,":"),$P(pDocType,":",2),"o",tOrdinal,tFieldNum))
			If tValue'="" {
				Set tComposite = ($LG(tElemData,1)[":")
				If tComposite {
					Set tCompCat = $P($LG(tElemData,1),":")
					Set tCompData = $G($$$vaSchemaGbl($S(tCompCat'="":tCompCat,1:tCategory),"CS",$P($LG(tElemData,1),":",2)))
				}
				Set tReps = $L(tValue,pSegment.RS)
				For r=1:1:tReps {
					Set tOneRep = $P(tValue,pSegment.RS,r)
					If tComposite {
						Set tComponents = $L(tOneRep,pSegment.CS)
						For c=1:1:tComponents {
							Set tOneCompVal = $P(tOneRep,pSegment.CS,c)
							Set tPosition = tFieldNum_tCompSep_c_$S(tReps=1:"",1:tCompSep_r)
							Set:UseHigherSNIPLevel tOldCompData = $G($$$vaVSchemaGbl($P(pDocType,":"),$P(pDocType,":",2),"o",tOrdinal,tFieldNum,c))
							If (c > $LL(tCompData)) {
								#; Too many components
								Set pDataElemErrs($I(pDataElemErrs))=$LB(tPosition_tEleSep,$$$CodeAK4723TooManyComponents,tOneCompVal)
							} ElseIf ""'=tOneCompVal {
								Set tElemRefNum = ..ValidateOneDataElem(tOneCompVal,tPosition,$LG(tCompData,c),tOldCompData,tDTFormat,UseHigherSNIPLevel,.tIK304,.pDataElemErrs,tEleSep)
								If UseHigherSNIPLevel && $D($$$vaVSchemaGbl($P(pDocType,":"),$P(pDocType,":",2),"c",tElemRefNum,"l",tOrdinal,tFieldNum,c),tKey) && '($D($$$vaVSchemaGbl($P(pDocType,":"),$P(pDocType,":",2),"c",tElemRefNum,"c",tKey,tOneCompVal))#2) {
									#; Invalid Code Value
									Set pDataElemErrs($I(pDataElemErrs))=$LB(tPosition_tEleSep_tElemRefNum,$$$CodeAK4723InvalidCodeValue,tOneCompVal)
									Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
								}
								Set:(tElemRefNum=1250) tDTFormat = tOneCompVal
							} ElseIf (..SNIPLevel > 1) {
								If (tOrdinal>0) {
									If ("M"=$P(tOldCompData,"|",3)) {
										#; Required Data Element Missing
										Set pDataElemErrs($I(pDataElemErrs))=$LB(tPosition_tEleSep_$P(tOldCompData,"|",2),$$$CodeAK4723MandatoryDataElementMissing)
										Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
									}
								} ElseIf ($LG($LG(tCompData,c),5) = "M") {
									#; If BuildMap failed, don't know ordinal, so use info we do have from new-style schema
									Set pDataElemErrs($I(pDataElemErrs))=$LB(tPosition_tEleSep_$LG($LG(tCompData,c),6),$$$CodeAK4723MandatoryDataElementMissing)
									Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
								}
							}
						}
					} Else {
						Set tPosition = $S(tReps=1:tFieldNum,1:tFieldNum_tCompSep_tCompSep_r)
						Set:tOneRep'="" tElemRefNum=..ValidateOneDataElem(tOneRep,tPosition,tElemData,tOldData,tDTFormat,UseHigherSNIPLevel,.tIK304,.pDataElemErrs,tEleSep)
						If UseHigherSNIPLevel && $D($$$vaVSchemaGbl($P(pDocType,":"),$P(pDocType,":",2),"c",tElemRefNum,"l",tOrdinal,tFieldNum),tKey) && '($D($$$vaVSchemaGbl($P(pDocType,":"),$P(pDocType,":",2),"c",tElemRefNum,"c",tKey,tOneRep))#2) {
							#; Invalid Code Value
							Set pDataElemErrs($I(pDataElemErrs))=$LB(tPosition_tEleSep_tElemRefNum,$$$CodeAK4723InvalidCodeValue,tOneRep)
							Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
						}
						Set:(tElemRefNum=1250) tDTFormat = tOneRep

					}
				}
			} ElseIf (..SNIPLevel > 1) {
				If (tOrdinal > 0) {
					If ("M"=$P(tOldData,"|",3)) {
						#; Required Data Element Missing
						Set pDataElemErrs($I(pDataElemErrs))=$LB(tFieldNum_tEleSep_$P(tOldData,"|",2),$$$CodeAK4723MandatoryDataElementMissing)
						Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
					}
				} Else {
					#; If BuildMap failed, don't know ordinal, so use info we do have from new-style schema
					If $LG(tElemData,5) = "M" {
						#; Required Data Element Missing
						Set pDataElemErrs($I(pDataElemErrs))=$LB(tFieldNum_tEleSep_$LG(tElemData,6),$$$CodeAK4723MandatoryDataElementMissing)
						Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
					}
				}

			}
		}
		
		If (tElemCount > $ListLength(tSegData)) {
			For tExtraElem = $ListLength(tSegData)+1:1:tElemCount {
				#; Too Many Data Elements
				Set pDataElemErrs($I(pDataElemErrs))=$LB(tExtraElem_tEleSep,$$$CodeAK4723TooManyDataElements,pSegment.GetValueAt(tExtraElem))
			}
			Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
		}
		
		If (..SNIPLevel > 1) {
			If tOrdinal > 0 {
				#; Use data specific to this occurrence of the segment if it is available
				While $I(tFieldNum) <= $LL(tSegData) {
					#; Loop through any missing trailing fields to see if they are mandatory
					Set tOldData = $G($$$vaVSchemaGbl($P(pDocType,":"),$P(pDocType,":",2),"o",tOrdinal,tFieldNum))
					If ("M"=$P(tOldData,"|",3)) {
						#; Required Data Element Missing
						Set pDataElemErrs($I(pDataElemErrs))=$LB(tFieldNum_tEleSep_$P(tOldData,"|",2),$$$CodeAK4723MandatoryDataElementMissing)
						Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
					}
				}
				#; Only have Situational Rule data if using Validation schema and know the ordinal, so we test for it here, but can't test for it if this segment hasn't been mapped properly
				Set tSCRule = ##class(EnsLib.EDI.X12.Util.Validator).CheckTR3Rules(pDocType,pSegment,tOrdinal,"",.pDataElemErrs,0,0)
				If $$$ISERR(tSCRule) {
					Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
				} 

			} Else {
				#; If BuildMap failed, don't know ordinal, so use info we do have from new-style schema
				While $I(tFieldNum) <= $LL(tSegData) {
					#; Loop through any missing trailing fields to see if they are mandatory
					If $LG($LG(tSegData,tFieldNum),5) = "M" {
						#; Required Data Element Missing
						Set pDataElemErrs($I(pDataElemErrs))=$LB(tFieldNum_tEleSep_$LG($LG(tSegData,tFieldNum),6),$$$CodeAK4723MandatoryDataElementMissing)
						Set tIK304 = $$$CodeAK3720SegmentHasDataElementErrors
					}
				}
			}
		}
	} While 0
	Quit tIK304
}

Method ValidateOneDataElem(pValue As %String, pElemPosition As %Integer, pElemData, pOldData As %Integer, pDTFormat As %String = "", pSNIPGreater As %Boolean = 0, ByRef pIK304 As %Integer = 0, ByRef pDataElemErrs As %Integer = 0, pEleSep As %String = {$$$X12DefElementSeparator}) As %String
{
	If pValue'="" {
		
		Set tMinLen = $LG(pElemData,2)
		Set tMaxLen = $LG(pElemData,4)
		Set tDatatype = $LG(pElemData,1)
		Set:tDatatype'[":" tDatatype = $E(tDatatype,2,*-1)
		Set tElemRefNum = $LG(pElemData,6)

		Set tLength = $L(pValue)
		#; optional - sign not counted in length
		Set:(("-"=$E(pValue,1))&&((tDatatype ?1"N".N))) tLength = (tLength-1) 
		If (tLength < tMinLen) {
			#; Data Element Too Short
			Set pDataElemErrs($I(pDataElemErrs))=$LB(pElemPosition_pEleSep_tElemRefNum,$$$CodeAK4723DataElementTooShort,pValue)
			Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
		} ElseIf (tMaxLen && (tLength > tMaxLen)) {
			#; Data Element Too Long
			Set pDataElemErrs($I(pDataElemErrs))=$LB(pElemPosition_pEleSep_tElemRefNum,$$$CodeAK4723DataElementTooLong,pValue)
			Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
		}
		If tDatatype = "R" {
			#; "numeric values that have a varying number of decimal positions"
			If '(pValue ? 0.1"-"0.N0.1".".N) {
				#; Invalid numerical value - no specific IK403 element error code
				Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
			}
			
		} ElseIf tDatatype = "DT" {
			#; Date - YYMMDD or CCYYMMDD
			Set tMatches = 1
			If $zstrip(pValue,"*N")'="" {
				Set tMatches = 0
			} Else {
				Set tMonth = $E(pValue,*-3,*-2)
				If (tMonth < 1) || (tMonth > 12) {
					Set tMatches = 0
				} ElseIf (($E(pValue,*-1,*) < 1) || ($E(pValue,*-1,*)>$Case(tMonth,2:29,4:30,6:30,9:30,11:30,:31))) {
					Set tMatches = 0
				}
			}
			If 'tMatches {
				#; Invalid Date
				Set pDataElemErrs($I(pDataElemErrs))=$LB(pElemPosition_pEleSep_tElemRefNum,$$$CodeAK4723InvalidDate,pValue)
				Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
			}
		} ElseIf tDatatype = "TM" {
			#; Time - HHMMSSd...d
			Set tMatches = 1
			If $zstrip(pValue,"*N")'="" {
				Set tMatches = 0
			} ElseIf (($E(pValue,1,2) < 0) || ($E(pValue,1,2) > 23)) {
				Set tMatches = 0
			} ElseIf (($L(pValue) > 2) && ($E(pValue,3,4) < 0) || ($E(pValue,3,4) > 59)) {
				Set tMatches = 0
			} ElseIf (($L(pValue) > 4) && ($E(pValue,5,6) < 0) || ($E(pValue,5,6) > 59)) {
				Set tMatches = 0
			}
			If 'tMatches {
				#; Invalid Time
				Set pDataElemErrs($I(pDataElemErrs))=$LB(pElemPosition_pEleSep_tElemRefNum,$$$CodeAK4723InvalidTime,pValue)
				Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
			}
		} ElseIf tDatatype ? 1"N".N {
			#; Numeric - "A numeric data element is represented by one or more digits with an optional leading sign... The plus sign must not be transmitted"
			If '(pValue ? 0.1"-"1.N) {
				Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
			}
		} ElseIf (tElemRefNum=1251)&&(pDTFormat'="") {
			Set tCode = ..ValidateDateTime(pValue,pDTFormat)
			If tCode {
				#; Invalid Date or Time
				Set pDataElemErrs($I(pDataElemErrs))=$LB(pElemPosition_pEleSep_tElemRefNum,tCode,pValue)
				Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
			}
		}
		If pSNIPGreater {
			If (("."=$P(pOldData,"|",3)) || (""=pOldData)) {
				#; Implementation "Not Used" Data Element Present
				Set pDataElemErrs($I(pDataElemErrs))=$LB(pElemPosition_pEleSep_tElemRefNum,$$$CodeAK4723ImplementationNotUsedDataElementPresent,pValue)
				Set pIK304 = $$$CodeAK3720SegmentHasDataElementErrors
			}
		}
	}
	
	Quit tElemRefNum
}

/// Validate that date/time value <var>pValue</var> which is expected to follow format code <var>pFormat</var> 
/// Expected formats for each code are as follows: </br>
/// 'CC' = 'First Two Digits of Year Expressed in Format CCYY' </br>
/// 'CD' = 'Month and Year Expressed in Format MMMYYYY' </br>
/// 'CM' = 'Date in Format CCYYMM' </br>
/// 'CQ' = 'Date in Format CCYYQ' </br>
/// 'CY' = 'Year Expressed in Format CCYY' </br>
/// 'D6' = 'Date Expressed in Format YYMMDD' </br>
/// 'D8' = 'Date Expressed in Format CCYYMMDD' </br>
/// 'DA' = 'Range of Dates within a Single Month Expressed in Format DD-DD' </br>
/// 'DB' = 'Date Expressed in Format MMDDCCYY' </br>
/// 'DD' = 'Day of Month in Numeric Format' </br>
/// 'DT' = 'Date and Time Expressed in Format CCYYMMDDHHMM' </br>
/// 'DTS' = 'Range of Date and Time Expressed in Format CCYYMMDDHHMMSS-CCYYMMDDHHMMSS' </br>
/// 'EH' = 'Last Digit of Year and Julian Date Expressed in Format YDDD' </br>
/// 'KA' = 'Date Expressed in Format YYMMMDD' </br>
/// 'MD' = 'Month of Year and Day of Month Expressed in Format MMDD' </br>
/// 'MM' = 'Month of Year in Numeric Format' </br>
/// 'RD' = 'Range of Dates Expressed in Format MMDDCCYY-MMDDCCYY' </br>
/// 'RD2' = 'Range of Years Expressed in Format YY-YY' </br>
/// 'RD4' = 'Range of Years Expressed in Format CCYY-CCYY' </br>
/// 'RD5' = 'Range of Years and Months Expressed in Format CCYYMM-CCYYMM' </br>
/// 'RD6' = 'Range of Dates Expressed in Format YYMMDD-YYMMDD' </br>
/// 'RD8' = 'Range of Dates Expressed in Format CCYYMMDD-CCYYMMDD' </br>
/// 'RDM' = 'Range of Dates Expressed in Format YYMMDD-MMDD' </br>
/// 'RDT' = 'Range of Date and Time, Expressed in Format CCYYMMDDHHMM-CCYYMMDDHHMM' </br>
/// 'RMD' = 'Range of Months and Days Expressed in Format MMDD-MMDD' </br>
/// 'RMY' = 'Range of Years and Months Expressed in Format YYMM-YYMM' </br>
/// 'RTM' = 'Range of Time Expressed in Format HHMM-HHMM' </br>
/// 'RTS' = 'Date and Time Expressed in Format CCYYMMDDHHMMSS' </br>
/// 'TC' = 'Julian Date Expressed in Format DDD' </br>
/// 'TM' = 'Time Expressed in Format HHMM' </br>
/// 'TQ' = 'Date Expressed in Format MMYY' </br>
/// 'TR' = 'Date and Time Expressed in Format DDMMYYHHMM' </br>
/// 'TS' = 'Time Expressed in Format HHMMSS' </br>
/// 'TT' = 'Date Expressed in Format MMDDYY' </br>
/// 'TU' = 'Date Expressed in Format YYDDD' </br>
/// 'UN' = 'Unstructured' </br>
/// 'YM' = 'Year and Month Expressed in Format YYMM' </br>
/// 'YMM' = 'Range of Year and Months, Expressed in CCYYMMM-MMM Format' </br>
/// 'YY' = 'Last Two Digits of Year Expressed in Format CCYY' </br>
Method ValidateDateTime(pValue As %String, pFormat As %String) As %Integer
{
	#dim tErrCode as %Integer = 0 ; will be set to 8 for invalid date or 9 for invalid time
	#; variables for year, quarter, month, day, hours, minutes, and seconds
	#dim tYY,tYYYY,tY,tQ,tMM,tMMM,tDDD,tDD,tHH,tMin,tSS As %String = ""
	#dim tDash,tYY2,tYYYY2,tMM2,tDD2,tHH2,tMin2,tSS2 As %String = ""
	#dim tMatches As %Boolean = 0
	Do {
		If $Case(pFormat,"":1,"UN":1,:0) || (",CC,CD,CM,CQ,CY,D6,D8,DA,DB,DD,DT,DTS,EH,KA,MD,MM,RD,RD2,RD4,RD5,RD6,RD8,RDM,RDT,RMD,RMY,RTM,RTS,TC,TM,TQ,TR,TS,TT,TU,UN,YM,YMM,YY," '[ (","_pFormat_",")) {
			Set tMatches = 1
			Quit
		}
		#; quick check that, if doesn't include month in MMM format, then all numerical with possible range
		Quit:$Case(pFormat,"CD":0,"KA":0,"YMM":0,:1)&&(pValue'?.N0.1"-".N)
		
		#; First check length
		Set tLen = $L(pValue)
		Set tExpectedLen = $Case(pFormat,"CC":2,"CD":7,"CM":6,"CQ":5,"CY":4,"D6":6,"D8":8,"DA":5,"DB":8,"DD":2,"DT":12,"DTS":29,"EH":4,"KA":7,"MD":4,
		  "MM":2,"RD":17,"RD2":5,"RD4":9,"RD5":13,"RD6":13,"RD8":17,"RDM":11,"RDT":25,"RMD":9,"RMY":9,"RTM":9,"RTS":14,"TC":3,"TM":4,"TQ":4,"TR":10,
		  "TS":6,"TT":6,"TU":5,"YM":4,"YMM":11,"YY":2)
		Set tMatches = (tLen=tExpectedLen)
		Quit:'tMatches
		
		#; Year needs to be numerical
		Set tYYYY = $Case(pFormat,"CD":$E(pValue,4,7),"CM":$E(pValue,1,4),"CQ":$E(pValue,1,4),"D8":$E(pValue,1,4),"DB":$E(pValue,5,8),"DT":$E(pValue,1,4),"DTS":$E(pValue,1,4),"RD":$E(pValue,5,8),"RD4":$E(pValue,1,4),"RD5":$E(pValue,1,4),"RD8":$E(pValue,1,4),"RDT":$E(pValue,1,4),"RTS":$E(pValue,1,4),"YMM":$E(pValue,1,4),:"")
		Set tYYYY2 = $Case(pFormat,"DTS":$E(pValue,16,19),"RD":$E(pValue,14,17),"RD4":$E(pValue,6,9),"RD5":$E(pValue,8,11),"RD8":$E(pValue,10,13),"RDT":$E(pValue,14,17),:"")
		Set tYY = $Case(pFormat,"CC":pValue,"D6":$E(pValue,1,2),"KA":$E(pValue,1,2),"RD2":$E(pValue,1,2),"RD6":$E(pValue,1,2),"RDM":$E(1,2),"RMY":$E(pValue,1,2),"TQ":$E(pValue,3,4),"TR":$E(pValue,5,6),"TT":$E(pValue,5,6),"TU":$E(pValue,1,2),"YM":$E(pValue,1,2),"YY":pValue,:"")
		Set tYY2 = $Case(pFormat,"RD2":$E(pValue,4,5),"RD6":$E(pValue,8,9),"RMY":$E(pValue,6,7),:"")
		Set:pFormat="EH" tY = $E(pValue)
		Quit:(tYYYY_tYYYY2_tYY_tYY2_tY)'?.N
		
		#; Quarter
		Quit:(pFormat="CQ")&&("1234"'[$E(pValue,5))
		
		#; Numerical Month
		Set tMM = $Case(pFormat,"CM":$E(pValue,5,6),"D6":$E(pValue,3,4),"D8":$E(pValue,5,6),"DB":$E(pValue,1,2),"DT":$E(pValue,5,6),"DTS":$E(pValue,5,6),"MD":$E(pValue,1,2),"MM":pValue,"RD":$E(pValue,1,2),"RD5":$E(pValue,5,6),"RD6":$E(pValue,3,4),"RD8":$E(pValue,5,6),"RDM":$E(pValue,3,4),"RDT":$E(pValue,5,6),"RMD":$E(pValue,1,2),"RMY":$E(pValue,3,4),"RTS":$E(pValue,5,6),"TQ":$E(pValue,1,2),"TR":$E(pValue,3,4),"TT":$E(pValue,1,2),"YM":$E(pValue,3,4),:"")
		Set tMM2 = $Case(pFormat,"DTS":$E(pValue,20,21),"RD":$E(pValue,10,11),"RD5":$E(pValue,12,13),"RD6":$E(pValue,10,11),"RD8":$E(pValue,14,15),"RDM":$E(pValue,8,9),"RDT":$E(pValue,18-19),"RMD":$E(pValue,6,7),"RMY":$E(pValue,8,9),:"")
		Quit:(tMM'="")&&((tMM>12)||(tMM<1))
		Quit:(tMM2'="")&&((tMM2>12)||(tMM2<1))
		
		#; Alpha Month
		Set tMMM = $Case(pFormat,"CD":$E(pValue,1,3),"KA":$E(pValue,3,5),"YMM":$E(pValue,5,7),:"")
		Quit:$Case(tMMM,"":0,"JAN":0,"FEB":0,"MAR":0,"APR":0,"MAY":0,"JUN":0,"JUL":0,"AUG":0,"SEP":0,"OCT":0,"NOV":0,"DEC":0,:1)
		If pFormat="YMM" {
			If $Case($E(pValue,9,11),"JAN":0,"FEB":0,"MAR":0,"APR":0,"MAY":0,"JUN":0,"JUL":0,"AUG":0,"SEP":0,"OCT":0,"NOV":0,"DEC":0,:1) {
				Set tErrCode = $$$CodeAK4723InvalidDate
				Quit
			}
		}
		
		#; Day in DD format
		Set tDD = $Case(pFormat,"D6":$E(pValue,5,6),"D8":$E(pValue,7,8),"DA":$E(pValue,1,2),"DB":$E(pValue,3,4),"DD":pValue,"DT":$E(pValue,7,8),"DTS":$E(pValue,7,8),"KA":$E(pValue,6,7),"MD":$E(pValue,3,4),"RD":$E(pValue,3,4),"RD6":$E(pValue,5,6),"RD8":$E(pValue,7,8),"RDM":$E(pValue,5,6),"RDT":$E(pValue,7,8),"RMD":$E(pValue,3,4),"RTS":$E(pValue,7,8),"TR":$E(pValue,1,2),"TT":$E(pValue,3,4),:"")
		Set tDD2 = $Case(pFormat,"DA":$E(pValue,4,5),"DTS":$E(pValue,22,23),"RD":$E(pValue,12,13),"RD6":$E(pValue,12,13),"RD8":$E(pValue,16,17),"RDM":$E(pValue,10,11),"RDT":$E(pValue,20,21),"RMD":$E(pValue,8,9),:"")
		Quit:(tDD'="")&&((tDD>31)||(tDD<1))
		Quit:(tDD2'="")&&((tDD2>31)||(tDD2<1))
		
		#; Julian date
		Set tDDD = $Case(pFormat,"EH":$E(pValue,2,4),"TC":pValue,"TU":$E(pValue,3,5),:"")
		Quit:(tDDD'="")&&((tDDD>366)||(tDDD<1))
		
		#; Range
		Set tDash = $E(pValue,$Case(pFormat,"DA":3,"DTS":15,"RD":9,"RD2":3,"RD4":5,"RD5":7,"RD6":7,"RD8":9,"RDM":7,"RDT":13,"RMD":5,"RMY":5,"RTM":5,"YMM":8,:0))
		Quit:"-"'=tDash
		
		#; Hour
		Set tHH = $Case(pFormat,"DT":$E(pValue,9,10),"DTS":$E(pValue,9,10),"RDT":$E(pValue,9,10),"RTM":$E(pValue,1,2),"RTS":$E(pValue,9,10),"TM":$E(pValue,1,2),"TR":$E(pValue,7,8),"TS":$E(pValue,1,2),:"")
		Set tHH2 = $Case(pFormat,"DTS":$E(pValue,24,25),"RDT":$E(pValue,22,23),"RTM":$E(pValue,6,7),:"")
		If (""'=tHH) && ((tHH>24)||(tHH<0)) {
			Set tErrCode = $$$CodeAK4723InvalidTime
			Quit
		}
		If (""'=tHH2) && ((tHH2>24)||(tHH2<0)) {
			Set tErrCode = $$$CodeAK4723InvalidTime
			Quit
		}
		
		#; Minutes
		Set tMin = $Case(pFormat,"DT":$E(pValue,11,12),"DTS":$E(pValue,11,12),"RDT":$E(pValue,11,12),"RTM":$E(pValue,3,4),"RTS":$E(pValue,11,12),"TM":$E(pValue,3,4),"TR":$E(pValue,9,10),"TS":$E(pValue,3,4),:"")
		Set tMin2 = $Case(pFormat,"DTS":$E(pValue,26,27),"RDT":$E(pValue,24,25),"RTM":$E(pValue,8,9),:"")
		If (""'=tMin) && ((tMin>60)||(tMin<0)) {
			Set tErrCode = $$$CodeAK4723InvalidTime
			Quit
		}
		If (""'=tMin2) && ((tMin2>60)||(tMin2<0)) {
			Set tErrCode = $$$CodeAK4723InvalidTime
			Quit
		}
		
		#; Seconds
		Set tSS = $Case(pFormat,"DTS":$E(pValue,13,14),"RTS":$E(pValue,13,14),"TS":$E(pValue,5,6),:"")
		If (""'=tSS) && ((tSS>60)||(tSS<0)) {
			Set tErrCode = $$$CodeAK4723InvalidTime
			Quit
		}
		If pFormat="DTS" {
			Set tSS2 = $E(pValue,28,29)
			If (tSS2>60)||(tSS2<0) {
				Set tErrCode = $$$CodeAK4723InvalidTime
				Quit
			}
		}
		
		#; If haven't already quit, then value matched the pattern
		Set tMatches = 1
	} While 0
	
	#; If value wasn't a match and haven't specifically ID'd the problem as a time format issue, set an appropriate error code
	If 'tErrCode && 'tMatches {
		Set tErrCode = $Case(pFormat,"RTM":$$$CodeAK4723InvalidTime,"TM":$$$CodeAK4723InvalidTime,"TS":$$$CodeAK4723InvalidTime,:$$$CodeAK4723InvalidDate)
	}
	Quit tErrCode
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document) As %Status
{
	Quit $$$EnsError($$$EnsEDIX12ErrGeneral, "Service does not support Reply; Document "_pReplyDocument)
}

/// Callbacks from Parser:
/// 
Method OnDocumentStart(pDocument As EnsLib.EDI.Document, pSource As %String, pStatus As %Status) As %Status
{
	#dim tSC As %Status = $$$OK
	#; top parent ; Interchange
	If ""=pDocument.ParentId {
		Set ..%ISARequestsTA1=("ISA"=pDocument.GetValueAt("1:0")&&pDocument.GetValueAt("1:14"))
		Set ..%TopReplyCode=$Case(..BatchReplyType,"All":"A","AllTA1":"A","AllI14TA1":"A","TA1":"A","I14":"A","Byte":"A",:"")
		$$$sysTRACE("New top document "_pDocument_" / "_pDocument.getId()_" received, setting %ISARequestsTA1="_..%ISARequestsTA1_", %TopReplyCode='"_..%TopReplyCode_"'")
		If $D(^IRIS.Temp.EnsX12(..%ConfigName))&&$D(^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete")) {
			Set tDocToDelete = ""
			For {
				Set tDocToDelete = $O(^IRIS.Temp.EnsX12(..%ConfigName,"MarkedForDelete",tDocToDelete))	Quit:tDocToDelete=""
				If ##class(EnsLib.EDI.X12.Document).%ExistsId(tDocToDelete) {
					Set tSC = $$$ADDSC(tSC,##class(EnsLib.EDI.X12.Document).%DeleteId(tDocToDelete))
				}
			}
		}

		Kill ^IRIS.Temp.EnsX12(..%ConfigName)
	} Else {
		$$$sysTRACE("New child document "_pDocument_" / "_pDocument.getId()_" received")
	}
	If $$$ISERR(tSC) {
		$$$LOGERROR(tSC)
	}
	Quit $$$OK
}

Method OnDocumentEnd(pDocument As EnsLib.EDI.Document, pSource As %String, pStatus As %Status) As %Status
{
	#; Ignore errors; we use the default Reply Document object not this return value
	Do:..%ForwardBatchWhole<=1 ..standardOnProcessInput(pDocument,.tDocOut,pStatus)
	#; Else (If ..%ForwardBatchWhole>1) do nothing; this value means don't let Service process the document; we're in ImportFrom...()
	Set ..%isNewBatch=(""=pDocument.ParentId)
	Quit $$$OK
}

/// Return the segment terminator string that the Parser and the document.ImportFromIOStream() method will use.
Method GetSegmentTerminator() As %String
{
	Quit $Select((""'=..DefSegTerm)&&($E(..DefSegTerm)'?1(1A,1N)):$E(..DefSegTerm),1:$$$X12DefSegTerminator)
}

ClassMethod GetRequestClassList() As %String [ CodeMode = objectgenerator, GenerateAfter = OnProcessInput ]
{
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"standardOnProcessInput",$$$cMETHformalspecparsed)
	Set tClass=$lg($lg(tSignature,1),2)
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"OnProcessInput",$$$cMETHformalspecparsed)
	Set tClass=tClass_""","""_$lg($lg(tSignature,1),2)
	Do %code.WriteLine(" Quit $lb("""_tClass_""")")
	Quit $$$OK
}

ClassMethod GetResponseClassList(pRequest As %String = "") As %String [ CodeMode = objectgenerator, GenerateAfter = OnProcessInput ]
{
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"standardOnProcessInput",$$$cMETHformalspecparsed)
	Set tRequest1=$lg($lg(tSignature,1),2)
	Set tClass1=$lg($lg(tSignature,2),2)
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"OnProcessInput",$$$cMETHformalspecparsed)
	Set tRequest2=$lg($lg(tSignature,1),2)
	Set tClass2=$lg($lg(tSignature,2),2)

	Set tClass12=tClass1_$S(tClass1=tClass2:"",1:""","""_tClass2)
	If tRequest1=tRequest2 {
		Set (tClass1,tClass2)=tClass12
	}
	Do %code.WriteLine(" Quit:pRequest="""" $lb("""_tClass12_""")")
	Do %code.WriteLine(" Quit:pRequest="""_tRequest1_""" $lb("""_tClass1_""")")
	Do %code.WriteLine(" Quit:pRequest="""_tRequest2_""" $lb("""_tClass2_""")")
	Do %code.WriteLine(" Quit $lb("""")")
	Quit $$$OK
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

/// Add discarded characters to IO Archive
Method IOLogDiscard(pSC As %Status, pNote As %String, pDiscard As %GlobalCharacterStream)
{
	Set tIOLogEntry = ..IOLogEntry, ..IOLogEntry=$$$NULLOREF ; Save a separate entry for the unexpected input
	$$$NEWINIOLOGENTRY(pSC,pNote,pDiscard)
	$$$CLOSEIOLOGENTRY($$$OK,"",$$$NULLOREF)
	Set ..IOLogEntry = tIOLogEntry
}

}
