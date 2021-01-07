/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7SM

Class EnsLib.HL7.SequenceManager Extends Ens.BusinessProcess [ System = 4 ]
{

/// If this property is checked, the message control Id is checked for duplication
Property EnableDuplicatedMessageCheck As %Boolean [ InitialExpression = 1 ];

/// The message type of duplicated message notice
Property DuplicatedMessageNoticeType As %String(VALUELIST = ",OriginalMessage,WorkflowRequest") [ InitialExpression = "WorkflowRequest", Required ];

/// ConfigItem name to where duplicated message notices are sent
Property DuplicatedMessageTarget As %String;

/// This property indicates which field or fields are used as the index base upon which the sequence number check is performed.
/// If the value is set to "SendingFacility", then the SendingFacility is used to do sequence number checks.<br>
/// If the value is set to "SendingApplication", then the SendingApplication is used to do sequence number checks.<br>
/// If the value is set to "ReceivingFacility", then the ReceivingFacility is used to do sequence number checks.<br>
/// If the value is set to "ReceivingApplication", then the ReceivingApplication is used to do sequence number checks.<br>
/// If the value is set to "Sender", then the SendingFacility, SendingApplication are used to do sequence number checks.<br>
/// If the value is set to "Receiver", then the ReceivingFacility, ReceivingApplication are used to do sequence number checks.<br>
/// If the value is set to "None", then no sequence number check is performed.<br>
Property PerformSequenceNumberCheckOn As %String(VALUELIST = ",Sender,Receiver,SendingFacility,SendingApplication,ReceivingFacility,ReceivingApplication,None") [ InitialExpression = "Sender", Required ];

/// Number of seconds to wait for each late message
Property MessageWaitTimeout As %Integer [ InitialExpression = 60 ];

/// This is a comma seperated list of message types of which the messages should be sent through without sequence check and without output transformation
/// If the value is set to "*", then all the messages are treated as pass-through
Property PassThroughMessageTypes As %String [ InitialExpression = "QBP_Q21,QBP_Q22,RSP_K21,RSP_K22,ACK" ];

/// The message type of out-of-sequence message notice
Property OutOfSequenceMessageNoticeType As %String(VALUELIST = ",OriginalMessage,WorkflowRequest") [ InitialExpression = "WorkflowRequest", Required ];

/// ConfigItem name to where out-of-sequence message notices are sent
Property OutOfSequenceMessageTarget As %String;

/// If this property is checked, the output transformation is performed.<p>
/// The output transformation includes setting the Facility, Application and SequenceNumber.
/// The new facility and application values are set in OutputFacilityApplication property.<p>
/// If the value is set to "Sender", then the SendingFacility, SendingApplication and SequenceNumber are modified.<br>
/// If the value is set to "Receiver", then the ReceivingFacility, ReceivingApplication and SequenceNumber are modified.<br>
/// If the value is set to "SequenceNumberOnly", then only the sequence number is changed.
Property PerformOutputTransformationOn As %String(VALUELIST = ",Sender,Receiver,SequenceNumberOnly,None") [ InitialExpression = "Sender", Required ];

/// This field determines based on what fields the output sequence number is incremented.
/// Value Sender means the index fields are SendingFacility and SendingApplication
/// Value is Receiver means index fields are ReceivingFacility and ReceivingApplication
/// If the Value is Auto, then it is determined from the <PROPERTY>PerformOutputTransformationOn</PROPERTY>.
/// For example, if <PROPERTY>PerformOutputTransformationOn</PROPERTY> is Sender, then <PROPERTY>OutputSequenceNumberIndexField</PROPERTY> will be Sender.
/// If <PROPERTY>PerformOutputTransformationOn</PROPERTY> is Receiver, then <PROPERTY>OutputSequenceNumberIndexField</PROPERTY> will be Receiver.
/// If <PROPERTY>PerformOutputTransformationOn</PROPERTY> is SequenceNumberOnly, then <PROPERTY>OutputSequenceNumberIndexField</PROPERTY> will be Sender.
Property OutputSequenceNumberIndexField As %String(VALUELIST = ",Sender,Receiver,SendingFacility,SendingApplication,ReceivingFacility,ReceivingApplication,Auto") [ InitialExpression = "Auto", Required ];

/// The format of this property is Facility : Application <p>
/// When PerformOutputTransformationOn is 'Sender', the output messages will be assigned new SendingFacility, SendingApplication using this property.<br>
/// When PerformOutputTransformationOn is 'Receiver', the output messages will be assigned new ReceivingFacility, ReceivingApplication using this property.<br>
/// When PerformOutputTransformationOn is 'SequenceNumberOnly', this property value is not used.
Property OutputFacilityApplication As %String;

/// Number of seconds outside of which messages can be resent
Property MessageResendableTimeWindow As %Integer [ InitialExpression = 300 ];

/// The comma seperated list of the target configuration names to which a successful output message should be sent
Property OutputTargetConfigNames As %String;

/// The gap size above which it is considered a 'large gap'.<br>
/// The behavior of a 'large gap' is different from a 'small gap'.<br>
/// When there is a small gap, we will wait 'MessageWaitTimeout' number of seconds for each missing sequence number inside the gap.<p>
/// When there is a large gap, after sending an alert, we will immediately jump forward to the larger number without any wait.
Property LargeGapSize As %Integer [ InitialExpression = 100 ];

/// If this property is false, we will by-pass internal resent messages
Property BypassCheckOnInternalResent As %Boolean [ InitialExpression = 1 ];

/// This is he first sequence number expected.
/// Default is empty and maintains prior behavior.
Property FirstSequenceNumber As %Integer;

/// If this parameter is TRUE, then arrays %MessagesSent and %MessagesReceived will not be populated.
Parameter SKIPMESSAGEHISTORY As BOOLEAN = 1;

Parameter SETTINGS = "EnableDuplicatedMessageCheck,PerformSequenceNumberCheckOn,PerformOutputTransformationOn,OutputSequenceNumberIndexField,OutputTargetConfigNames::selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},MessageWaitTimeout,PassThroughMessageTypes,OutOfSequenceMessageNoticeType,OutOfSequenceMessageTarget::selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},DuplicatedMessageNoticeType,DuplicatedMessageTarget::selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},OutputFacilityApplication,MessageResendableTimeWindow,LargeGapSize,BypassCheckOnInternalResent,FirstSequenceNumber";

Method OnRequest(request As %Library.Persistent, Output response As Ens.Response) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	do {
		#; check for Runtime Data version
		If $g(^EnsHL7.SM)<..CurrentRuntimeDataVersion() Set tSC=##class(EnsLib.HL7.SM.Version).Upgrade() If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
		#;
		$$$TRACE("Message #"_request.%Id()_"(CtrlId="_..MessageGetField(request,$$$eFieldControlId)_",SeqNum="_..MessageGetField(request,$$$eFieldSequenceNumber)_") is received.")
		#;
		if ..MessageIsValid(request) {
			#;
			#; keep track of total messages
			if $i(^EnsHL7.SM.metric("total"))
			#;
			#; check for duplicated message based on Facility,Application,MessageControlId
			set tSC = ..checkMessageDuplication(request,.tIsPassed)
			quit:$$$ISERR(tSC)
			quit:'tIsPassed
			#;
			#; check for sequence number based on Facility,Application,SequenceNumber
			set tSC = ..checkMessageSequenceNumber(request,.tIsPassed)
			quit:$$$ISERR(tSC)
			quit:'tIsPassed
		}
	} while (0)
	;
	#; check the waiting list
	set tSC2=..checkWaitingList() quit:$$$ISERR(tSC2) tSC2
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Handle a 'Response'
Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	do {
		#; check for Runtime Data version
		If $g(^EnsHL7.SM)<..CurrentRuntimeDataVersion() Set tSC=##class(EnsLib.HL7.SM.Version).Upgrade() If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
		#;
		if callresponse=$$$NULLOREF quit
		#;
		if $classname(callresponse)="EnsLib.Workflow.TaskResponse" {
			if callresponse.%Action="IgnoreDuplicatedMessageError" {
				$$$TRACE("Message #"_request.%Id()_"(CtrlId="_..MessageGetField(request,$$$eFieldControlId)_",SeqNum="_..MessageGetField(request,$$$eFieldSequenceNumber)_"): duplicated message error ignored by '"_callresponse.%UserName_"'.")
				set tSC = ..checkMessageSequenceNumber(request)
				quit
			}
			if callresponse.%Action="IgnoreOutOfSequenceError" {
				$$$TRACE("Message #"_request.%Id()_"(CtrlId="_..MessageGetField(request,$$$eFieldControlId)_",SeqNum="_..MessageGetField(request,$$$eFieldSequenceNumber)_"): out-of-sequence error ignored by '"_callresponse.%UserName_"'.")
				set tSC = ..sendOutputMessage(request)
				do ..recordIndexObj(request)
				quit
			}
			if callresponse.%Action="DiscardMessage" {
				$$$TRACE("Message #"_request.%Id()_"(CtrlId="_..MessageGetField(request,$$$eFieldControlId)_",SeqNum="_..MessageGetField(request,$$$eFieldSequenceNumber)_"), is discarded by '"_callresponse.%UserName_"'.")
				quit
			}
		}
	} while (0)
	;
	#; check the waiting list
	set tSC2=..checkWaitingList() quit:$$$ISERR(tSC2) tSC2
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method checkMessageDuplication(pMessage As %Library.Persistent, Output pIsPassed As %Boolean) As %Status
{
	set $ZT="Trap",tSC=$$$OK,tLocked=0,pIsPassed=1
	do {
		if '..EnableDuplicatedMessageCheck quit
		set tSendingFacility=..MessageGetField(pMessage,$$$eFieldSendingFacility)
		set tSendingApplication=..MessageGetField(pMessage,$$$eFieldSendingApplication)
		set tMessageId=pMessage.%Id()
		set tControlId=..MessageGetField(pMessage,$$$eFieldControlId)
		set tSeqNumber=..MessageGetField(pMessage,$$$eFieldSequenceNumber)
		#; Acquire lock
		lock +^EnsHL7.SM(..%ConfigName,"index","ct","Sender",tSendingFacility,tSendingApplication):10 set tLocked=$test
		if 'tLocked set tSC=$$$EnsError($$$EnsErrGeneral,"Can not acquire lock on ControlId index.") quit
		#; quit if it is a non-sequenced message
		if ..isBypassInternalResent() quit
		#; quit if ControlId is null
		if tControlId="" $$$LOGERROR("Message #"_tMessageId_"(SeqNum="_tSeqNumber_"), ControlId is missing") set pIsPassed=0 quit
		#; quit if the ControlId not found in the index table
		if $d(^EnsHL7.SM(..%ConfigName,"index","ct","Sender",tSendingFacility,tSendingApplication,tControlId))=0 quit
		#; ControlId found, check the timestamp on each duplicated one, construct the list of id's that are within the time window
		set tList="",mid="" for  {
			set mid=$o(^EnsHL7.SM(..%ConfigName,"index","ct","Sender",tSendingFacility,tSendingApplication,tControlId,mid)) quit:mid=""
			if $$$timeHDiff($$$timeUTCH,^EnsHL7.SM(..%ConfigName,"index","ct","Sender",tSendingFacility,tSendingApplication,tControlId,mid))>..MessageResendableTimeWindow continue
			if mid'=tMessageId set tList=$s(tList="":"",1:tList_",")_"#"_mid
		}
		#; none of the messages found are within the time window
		if tList="" quit
		#; there is duplication, log the error
		set pIsPassed=0
		$$$LOGERROR("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is duplicated. ControlId already exists in the following message"_$s(tList[",":"s",1:"")_": "_tList_".")
		#; increment the counter for total duplicated messages
		set ^EnsHL7.SM.metric("duplicated",$i(^EnsHL7.SM.metric("duplicated")))=$lb(..%PrimaryRequestHeader.%Id(),tMessageId,tControlId,tList)
		#; send to duplicated message workflow
		Set tSC=..sendDuplicated(pMessage,tList)
		;
	} while (0)
Exit
	if tLocked lock -^EnsHL7.SM(..%ConfigName,"index","ct","Sender",tSendingFacility,tSendingApplication)
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method checkMessageSequenceNumber(pMessage As %Library.Persistent, Output pIsPassed As %Boolean, pThread As %String = "main") As %Status
{
	set $ZT="Trap",tSC=$$$OK,tLocked=0,pIsPassed=1
	do {
		#; set type and basecode
		set tType=$s(..PerformSequenceNumberCheckOn["Sending":"Sender",..PerformSequenceNumberCheckOn["Receiving":"Receiver",1:..PerformSequenceNumberCheckOn)
		set tField=$s(..PerformSequenceNumberCheckOn["Application":"Application",..PerformSequenceNumberCheckOn["Facility":"Facility",1:"")
		set tFacilityCode=$s(tField="Application":0,tType="Sender":$$$eFieldSendingFacility,tType="Receiver":$$$eFieldReceivingFacility,1:0)
		set tApplicationCode=$s(tField="Facility":0,tType="Sender":$$$eFieldSendingApplication,tType="Receiver":$$$eFieldReceivingApplication,1:0)
		#; get information
		set tFacility=$s(tFacilityCode=0:"*",1:..MessageGetField(pMessage,tFacilityCode))
		set tApplication=$s(tApplicationCode=0:"*",1:..MessageGetField(pMessage,tApplicationCode))
		set tSendingFacility=$s(tFacilityCode=$$$eFieldSendingFacility:tFacility,1:..MessageGetField(pMessage,$$$eFieldSendingFacility))
		set tSendingApplication=$s(tApplicationCode=$$$eFieldSendingApplication:tApplication,1:..MessageGetField(pMessage,$$$eFieldSendingApplication))
		set tMessageId=pMessage.%Id()
		set tMessageClassName=$classname(pMessage)
		set tControlId=..MessageGetField(pMessage,$$$eFieldControlId)
		set tSeqNumber=..MessageGetField(pMessage,$$$eFieldSequenceNumber)
		#; Acquire lock
		lock +^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication):10 set tLocked=$test
		if 'tLocked set tSC=$$$EnsError($$$EnsErrGeneral,"Can not acquire lock on SequenceManager.") quit
		#; pass-through and non-sequence messages are thread independent, only check them in the main thread
		if pThread="main" {
			#; send the pMessage on without Output Action if it is a pass-through message
			if ..isPassThrough(..MessageGetField(pMessage,$$$eFieldName)) {
				set tSC=..sendOutputMessage(pMessage,1)
				do ..recordIndex(tType,tFacility,tApplication,tSeqNumber,1,tSendingFacility,tSendingApplication,tControlId,tMessageId)
				set pIsPassed=1
				quit
			}
			#; send the pMessage on immediately if it is a non-sequenced message
			if ..isBypassInternalResent() {
				$$$TRACE("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is skipped for sequencing because it is an internal resent.")
				set tSC=..sendOutputMessage(pMessage)
				do ..recordIndex(tType,tFacility,tApplication,tSeqNumber,1,tSendingFacility,tSendingApplication,tControlId,tMessageId)
				set pIsPassed=1
				quit
			}
		}
		#; if PerformSequenceNumberCheckOn is "None", then just send the message through
		if tType="None" {
		    set tSC=..sendOutputMessage(pMessage)
		    do ..recordIndex(tType,tFacility,tApplication,tSeqNumber,1,tSendingFacility,tSendingApplication,tControlId,tMessageId)
		    set pIsPassed=1
		    quit
		}
		#; bypass initialization if received known first sequence number
		if ($g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next"))=""),(tSeqNumber=..FirstSequenceNumber) {
			set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next")=tSeqNumber 
			$$$TRACE("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is initialized in the "_pThread_" thread as it matches the FirstSequenceNumber.")
		}
		#; received message during the initialization period, put on the waiting list
		if $g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next"))="" {
			$$$TRACE("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is put on the waiting list for initialization in the "_pThread_" thread.")
			set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"list",tSeqNumber)=$g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"list",tSeqNumber))_$lb($lb(tMessageId,..%SessionId,..%PrimaryRequestHeader.%Id(),tMessageClassName))
			set:'$d(^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication,pThread)) ^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication,pThread) = ""
			set pIsPassed=0
			quit
		}
		#; received the expected sequence number
		if tSeqNumber=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next") {
			$$$TRACE("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is expected in the "_pThread_" thread.")
			set tSC=..sendOutputMessage(pMessage)
			do ..recordIndex(tType,tFacility,tApplication,tSeqNumber,1,tSendingFacility,tSendingApplication,tControlId,tMessageId)
			set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next")=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next")+1
			kill ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"wait")
			if '$d(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"list")){
					kill ^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication,pThread)
			}
			set pIsPassed=1
			quit
		}
		#; received an message too early, put in the the waiting list
		if tSeqNumber>^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next") {
			$$$TRACE("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is too early, put on the waiting list in the "_pThread_" thread.")
			set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"list",tSeqNumber)=$g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"list",tSeqNumber))_$lb($lb(tMessageId,..%SessionId,..%PrimaryRequestHeader.%Id(),tMessageClassName))
			set:'$d(^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication,pThread)) ^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication,pThread) = ""
			set pIsPassed=0
			quit
		}
		#; error on out-of-sequence message: if this is not the main thread or the message is within the resent time window
		if (pThread'="main")||($$$timeHDiff($$$timeUTCH,$g(^EnsHL7.SM(..%ConfigName,"index","st",tType,tFacility,tApplication,tSeqNumber)))<=..MessageResendableTimeWindow) {
			$$$LOGERROR("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is out-of-sequence in the "_pThread_" thread.")
			#; increment the counter for total out-of-sequence messages
			set ^EnsHL7.SM.metric("outofsequence",$i(^EnsHL7.SM.metric("outofsequence")))=$lb(..%PrimaryRequestHeader.%Id(),tMessageId,tSeqNumber,^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,pThread,"next"))
			set tSC=..sendOutOfSequence(pMessage)
			set pIsPassed=0
			quit
		}
		#; received a resent message in the main thread,
		set tSC = ..checkMessageSequenceNumber(pMessage,.pIsPassed,"resend")
		quit
		;
	} while (0)
Exit
	#; Release lock
	if tLocked lock -^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication)
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method isPassThrough(pMessageType As %String) As %Boolean
{
	if ..PassThroughMessageTypes="*" quit 1
	set tQuit=0
	for i=1:1:$l(..PassThroughMessageTypes,",") {
		set tOne=$p(..PassThroughMessageTypes,",",i)
		if tOne=$p(pMessageType,"_",1,$l(tOne,"_")) set tQuit=1 quit
	}
	quit tQuit
}

Method isBypassInternalResent() As %Boolean
{
	If '..BypassCheckOnInternalResent Quit 0
	if $e(..%PrimaryRequestHeader.Description,1,7)="Resent " quit 1
	if $e(..%PrimaryRequestHeader.Description,1,11)="BankResent " quit 1
	quit 0
}

Method sendOutputMessage(pMessage As %Library.Persistent, pSkipTransformation As %Boolean = 0) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	do {
		if ('pSkipTransformation)&&(..PerformOutputTransformationOn'="None") {
			set tMessageId=pMessage.%Id()
			set tControlId=..MessageGetField(pMessage,$$$eFieldControlId)
			set tOldSequenceNumber=..MessageGetField(pMessage,$$$eFieldSequenceNumber)
			set tOutputSequenceNumberIndexField=..OutputSequenceNumberIndexField
			if tOutputSequenceNumberIndexField="Auto" set tOutputSequenceNumberIndexField=$s(..PerformOutputTransformationOn="Receiver":"Receiver",1:"Sender")
			set tIndexFacilityCode=$case(tOutputSequenceNumberIndexField,"Sender":$$$eFieldSendingFacility,"Receiver":$$$eFieldReceivingFacility,"SendingFacility":$$$eFieldSendingFacility,"SendingApplication":0,"ReceivingFacility":$$$eFieldReceivingFacility,"ReceivingApplication":0,1:0)
			set tIndexApplicationCode=$case(tOutputSequenceNumberIndexField,"Sender":$$$eFieldSendingApplication,"Receiver":$$$eFieldReceivingApplication,"SendingFacility":0,"SendingApplication":$$$eFieldSendingApplication,"ReceivingFacility":0,"ReceivingApplication":$$$eFieldReceivingApplication,1:0)
			set tIndexFacility=$s(tIndexFacilityCode:..MessageGetField(pMessage,tIndexFacilityCode),1:"*")
			set tIndexApplication=$s(tIndexApplicationCode:..MessageGetField(pMessage,tIndexApplicationCode),1:"*")
			set tType=$s(tOutputSequenceNumberIndexField["Send":"Sender",1:"Receiver")
			set tNewSequenceNumber=$i(^EnsHL7.SM(..%ConfigName,"output",tType,tIndexFacility,tIndexApplication))
			set pNewMessage=pMessage.%ConstructClone()
			do ..MessageSetField(pNewMessage,$$$eFieldSequenceNumber,tNewSequenceNumber)
			if ..PerformOutputTransformationOn'="SequenceNumberOnly" {
				set tFacilityCode=$s(..PerformOutputTransformationOn="Sender":$$$eFieldSendingFacility,..PerformOutputTransformationOn="Receiver":$$$eFieldReceivingFacility,1:0)
				set tApplicationCode=$s(..PerformOutputTransformationOn="Sender":$$$eFieldSendingApplication,..PerformOutputTransformationOn="Receiver":$$$eFieldReceivingApplication,1:0)
				set tOldFacility=..MessageGetField(pMessage,tFacilityCode)
				set tOldApplication=..MessageGetField(pMessage,tApplicationCode)
				set tNewFacility=$p(..OutputFacilityApplication,":",1)
				set tNewApplication=$p(..OutputFacilityApplication,":",2)
				do ..MessageSetField(pNewMessage,tFacilityCode,tNewFacility)
				do ..MessageSetField(pNewMessage,tApplicationCode,tNewApplication)
				do pNewMessage.%Save()
				$$$TRACE("Message #"_tMessageId_"("_tOldFacility_":"_tOldApplication_":"_tControlId_":"_tOldSequenceNumber_") is converted to #"_pNewMessage.%Id()_"("_tNewFacility_":"_tNewApplication_":"_tControlId_":"_tNewSequenceNumber_")")
			} else {
				do pNewMessage.%Save()
				$$$TRACE("Message #"_tMessageId_"("_tControlId_":"_tOldSequenceNumber_") is converted to #"_pNewMessage.%Id()_"("_tControlId_":"_tNewSequenceNumber_")")
			}
		} else {
			set tControlId=..MessageGetField(pMessage,$$$eFieldControlId)
			set pNewMessage=pMessage
			set tNewSequenceNumber=..MessageGetField(pMessage,$$$eFieldSequenceNumber)
		}
		#;
		for i=1:1:$l(..OutputTargetConfigNames,",") {
			set tOneTarget=$p(..OutputTargetConfigNames,",",i) continue:tOneTarget=""
			set tSC=..SendRequestAsync(tOneTarget,pNewMessage,0) quit:$$$ISERR(tSC)
			$$$TRACE("Message #"_pNewMessage.%Id()_"(CtrlId="_tControlId_",SeqNum="_tNewSequenceNumber_") is sent to output target '"_tOneTarget_"'.")
		}
	} while (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method sendOutOfSequence(pMessage As %Library.Persistent) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	do {
		#; check the flag
		if ..OutOfSequenceMessageTarget'="" {
			set tMessageId=pMessage.%Id()
			set tControlId=..MessageGetField(pMessage,$$$eFieldControlId)
			set tSeqNumber=..MessageGetField(pMessage,$$$eFieldSequenceNumber)
			If ..OutOfSequenceMessageNoticeType = "WorkflowRequest" {
				set tWorkflowRequest = ##class(EnsLib.Workflow.TaskRequest).%New()
				set tWorkflowRequest.%Actions = "IgnoreOutOfSequenceError,DiscardMessage"
				set tWorkflowRequest.%Subject = "Out of Sequence Messages ("_tMessageId_") received."
				set tWorkflowRequest.%Message = "Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is out-of-sequence."
				set tSC = ..SendRequestAsync(..OutOfSequenceMessageTarget,tWorkflowRequest,1)
				$$$TRACE("Workflow request for out-of-sequence message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is sent to the OutOfSequenceMessageTarget '"_..OutOfSequenceMessageTarget_"'.")
			} Elseif ..OutOfSequenceMessageNoticeType = "OriginalMessage" {
				set tSC = ..SendRequestAsync(..OutOfSequenceMessageTarget,pMessage,1)
				$$$TRACE("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is sent to the OutOfSequenceMessageTarget '"_..OutOfSequenceMessageTarget_"'.")
			} Else {
				$$$LOGERROR("OutOfSequenceMessageNoticeType value is invalid.")
			}
		}
	} while (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method sendDuplicated(pMessage As %Library.Persistent, pList As %String) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	do {
		#; check the flag
		if ..DuplicatedMessageTarget'="" {
			set tMessageId=pMessage.%Id()
			set tControlId=..MessageGetField(pMessage,$$$eFieldControlId)
			set tSeqNumber=..MessageGetField(pMessage,$$$eFieldSequenceNumber)
			If ..DuplicatedMessageNoticeType="WorkflowRequest" {
				set tWorkflowRequest = ##class(EnsLib.Workflow.TaskRequest).%New()
				set tWorkflowRequest.%Actions = "IgnoreDuplicatedMessageError,DiscardMessage"
				set tWorkflowRequest.%Subject = "Duplicated Messages ("_tMessageId_") received."
				set tWorkflowRequest.%Message = "Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is duplicated. ControlId already exists in the following message"_$s(pList[",":"s",1:"")_": "_pList_"."
				set tSC=..SendRequestAsync(..DuplicatedMessageTarget,tWorkflowRequest,1)
				$$$TRACE("Workflow request for duplicated message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is sent to the DuplicatedMessageTarget '"_..DuplicatedMessageTarget_"'.")
			} Elseif ..DuplicatedMessageNoticeType="OriginalMessage" {
				set tSC = ..SendRequestAsync(..DuplicatedMessageTarget,pMessage,0)
				$$$TRACE("Message #"_tMessageId_"(CtrlId="_tControlId_",SeqNum="_tSeqNumber_") is sent to the DuplicatedMessageTarget '"_..DuplicatedMessageTarget_"'.")
			} Else {
				$$$LOGERROR("DuplicatedMessageNoticeType value is invalid.")
			}
		}
	} while (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method checkWaitingList() As %Status
{
	Set $ZT="Trap",tSC=$$$OK,tLocked=0
	do {
		#; set type
		set tType=$s(..PerformSequenceNumberCheckOn["Sending":"Sender",..PerformSequenceNumberCheckOn["Receiving":"Receiver",1:..PerformSequenceNumberCheckOn)
		if tType="None" quit
		kill ^EnsHL7.SM(..%ConfigName,"timer",..%Id())
		set tGlobalDuration=""
		set tFacility="" for  {
			set tFacility=$o(^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility)) quit:tFacility=""
			set tApplication="" for  {
				set tApplication=$o(^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication)) quit:tApplication=""
				#; try to acquire lock without timeout.  if one stream is busy, move on to the next one immediately.
				lock +^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication):0 set tLocked=$test if 'tLocked quit
				set tThread="" for  {
					set tThread=$o(^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication,tThread)) quit:tThread=""
					#; time has expired on the current sequence number or time has expired on the for initialization
					if ($g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait"))'="")&&($$$timeHDiff($$$timeUTCH,^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait"))>=..MessageWaitTimeout) {
						if $g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next"))'="" {
							if (tThread="main")||$d(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list")) {
								set tNext=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")
								#; time has expired on waiting for a particular message
								#; try to set session id to next in the list if it exists as we do not have a session id for missing.
								set tCurrentSessionId=..%SessionId
								set tSeqNumber=$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))
								If tSeqNumber'="" {	
									set tMessageEntry=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",tSeqNumber)
									set tSessionId=$li($li(tMessageEntry,1),2)
									set (..%SessionId,$$$JobSessionId)=tSessionId
								}
								$$$LOGERROR("Waiting time for SeqNum="_tNext_" has expired in the "_tThread_" thread.")
								do ..SendAlert(##class(Ens.AlertRequest).%New($LB(..%ConfigName,"Waiting time for SeqNum="_tNext_" has expired in the "_tThread_" thread.")))
								set (..%SessionId,$$$JobSessionId)=tCurrentSessionId
								#; increment the counter for total expired messages
								set ^EnsHL7.SM.metric("expired",$i(^EnsHL7.SM.metric("expired")))=$lb(tNext,$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list","")))
								do ..recordIndex(tType,tFacility,tApplication,tNext,0)
								set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")=tNext+1
							}
							if $o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))-^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")>=..LargeGapSize {
								#; try to set session id to next in the list if it exists as we do not have a session id for missing.
								set tCurrentSessionId=..%SessionId
								set tSeqNumber=$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))
								If tSeqNumber'="" {	
									set tMessageEntry=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",tSeqNumber)
									set tSessionId=$li($li(tMessageEntry,1),2)
									set (..%SessionId,$$$JobSessionId)=tSessionId
								}
								$$$TRACE("Large gap in sequence number ("_tNext_" to "_$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))_") detected.")
								$$$TRACE("Re-initialize sequence number in the "_tThread_" thread.")
								do ..SendAlert(##class(Ens.AlertRequest).%New($LB(..%ConfigName,"Large gap in sequence number ("_tNext_" to "_$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))_") detected.")))
								set (..%SessionId,$$$JobSessionId)=tCurrentSessionId
								set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")=""
							}
						} else {
							#; time has expired on the initialization, establish the waiting message to be the first one in the list
							set tNext=$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))
							set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")=tNext
							#; try to set session id to next in the list if it exists as we do not have a session id for missing.
							set tCurrentSessionId=..%SessionId
							set tSeqNumber=$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))
							If tSeqNumber'="" {	
								set tMessageEntry=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",tSeqNumber)
								set tSessionId=$li($li(tMessageEntry,1),2)
								set (..%SessionId,$$$JobSessionId)=tSessionId
							}
							$$$TRACE("Initialization phase complete in the "_tThread_" thread, first sequence number set to '"_tNext_"'.")
							set (..%SessionId,$$$JobSessionId)=tCurrentSessionId
						}
						kill ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait")
					}
					#; check to see if waiting messages can be sent right away
					set tJustProcessedMessages=0
					for {
						set tSeqNumber=$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))
						#; nothing in the waiting list
						quit:tSeqNumber=""
						#; this indicates it is still in the initialization phase
						quit:$g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next"))=""
						#; the next one in the waiting list is not up yet
						quit:tSeqNumber'=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")
						set tMessageEntry=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",tSeqNumber)
						#; tJustProcessedMessage is used to make resend time out
						set tJustProcessedMessages=1
						#dim tMessageLoaded
						for i=1:1:$ll(tMessageEntry) {
							set tMessageId=$li($li(tMessageEntry,i),1)
							set tSessionId=$li($li(tMessageEntry,i),2)
							set tHeaderId=$li($li(tMessageEntry,i),3)
							set tMessageClassName=$lg($li(tMessageEntry,i),4,"EnsLib.HL7.Message")
							set tCurrentSessionId=..%SessionId
							set (..%SessionId,$$$JobSessionId)=tSessionId
							set tMessage=$classmethod(tMessageClassName,"%OpenId",tMessageId,,.tSC)
							if $$$ISOK(tSC)&&$IsObject(tMessage) {
								Set tMessageLoaded = 1
								$$$TRACE("Message #"_tMessageId_"(CtrlId="_..MessageGetField(tMessage,$$$eFieldControlId)_",SeqNum="_tSeqNumber_") is found in waiting list of the "_tThread_" thread.")
								set tSC=..checkMessageDuplication(tMessage,.tIsPassed)
								if $$$ISOK(tSC)&&tIsPassed {
									if i=1 {
										set tSC=..sendOutputMessage(tMessage)
									} else {
										$$$LOGERROR("Message #"_tMessageId_"(CtrlId="_..MessageGetField(tMessage,$$$eFieldControlId)_",SeqNum="_tSeqNumber_") is out-of-sequence in the "_tThread_" thread.")
										#; increment the counter for total out-of-sequence messages
										set ^EnsHL7.SM.metric("outofsequence",$i(^EnsHL7.SM.metric("outofsequence")))=$lb(tHeaderId,tMessageId,tSeqNumber,tSeqNumber+1)
										set tSC=..sendOutOfSequence(tMessage)
									}
								}
								do ..recordIndexObj(tMessage)
							} Else {
								Set tMessageLoaded = 0
								/* tMessage is not an object but no error so ensure exit with an error */
								If $$$ISOK(tSC) {Set tSC = $$$ERROR($$$LoadObjectNotFound)}
								$$$LOGERROR("Unable to load Message #"_tMessageId_"(SeqNum="_tSeqNumber_") in the "_tThread_" thread."_$SYSTEM.Status.GetErrorText(tSC))
							}
							set (..%SessionId,$$$JobSessionId)=tCurrentSessionId
							quit:$$$ISERR(tSC)
						}
						/* 
							If message loaded keep prior behaviour with thread update.
							If message not loaded we only want to update the thread if message object gone.
							Error such as $$$LockFailedToAcquireExclusive transitory.
						*/
						If tMessageLoaded || ($$$StatusEquals(tSC,$$$LoadObjectNotFound)) {
							kill ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",tSeqNumber)
							set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")=^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")+1
							kill ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait")
						}
					}
					#; set timer if there are messages waiting
					if ($d(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list")))||((tThread'="main")&&tJustProcessedMessages) {
						if $g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait"))="" set ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait")=$$$timeUTCH $$$TRACE("Set wait time-stamp in the "_tThread_" thread.")
						set tDuration=..MessageWaitTimeout-$$$timeHDiff($$$timeUTCH,^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait"))
						if ((tGlobalDuration="")||(tDuration<tGlobalDuration)) set tGlobalDuration=tDuration
						if ($d(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list"))) {
							set tSeqNumber=$o(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",""))
							set tGlobalDurationSessionId=$s(tSeqNumber="":"",1:$li($li(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list",tSeqNumber),1),2))
						} else {
							set tGlobalDurationSessionId=""
						}
					}
					#; wait time for resend thread is over, clear the thread completely
					if (tThread'="main")&&($d(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread)))&&($g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait"))="") {
						kill ^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"next")
						$$$TRACE("Resend thread timed out.")
					}
					#; check if still need to be included in wait index
					if '$d(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"list")),($g(^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication,tThread,"wait"))="") {
						kill ^EnsHL7.SM(..%ConfigName,"wait index","thread",tType,tFacility,tApplication,tThread)
					}
				}
				if tLocked lock -^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication) set tLocked=0
			}
		}
		if ($d(^EnsHL7.SM(..%ConfigName,"timer"))=0) && (tGlobalDuration'="") {
			$$$TRACE("Set timer to wake up in "_(+tGlobalDuration)_" seconds.")
			set:$g(tGlobalDurationSessionId)'="" tCurrentSessionId=..%SessionId
			set:$g(tGlobalDurationSessionId) ..%SessionId=tGlobalDurationSessionId
			do ..SetTimer(+tGlobalDuration)
			set:$g(tGlobalDurationSessionId) ..%SessionId=tCurrentSessionId
			set ^EnsHL7.SM(..%ConfigName,"timer",..%Id())=""
		}
	} while (0)
	#;Call purge even if tType="None"
	do ..purgeIndex()
Exit
	#; Release lock if it has not been unlocked.  This could happen is we encounter an hard error
	if tLocked,$g(tType)'="",$g(tFacility)'="",$g(tApplication)'="" lock -^EnsHL7.SM(..%ConfigName,"thread",tType,tFacility,tApplication)
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method recordIndexObj(pMessage As %Library.Persistent) As %Status
{
	set tMessageId=pMessage.%Id()
	set tType=$s(..PerformSequenceNumberCheckOn["Sending":"Sender",..PerformSequenceNumberCheckOn["Receiving":"Receiver",1:..PerformSequenceNumberCheckOn)
	set tField=$s(..PerformSequenceNumberCheckOn["Application":"Application",..PerformSequenceNumberCheckOn["Facility":"Facility",1:"")
	set tFacilityCode=$s(tField="Application":0,tType="Sender":$$$eFieldSendingFacility,tType="Receiver":$$$eFieldReceivingFacility,1:0)
	set tApplicationCode=$s(tField="Facility":0,tType="Sender":$$$eFieldSendingApplication,tType="Receiver":$$$eFieldReceivingApplication,1:0)
	set tFacility=$s(tFacilityCode=0:"*",1:..MessageGetField(pMessage,tFacilityCode))
	set tApplication=$s(tApplicationCode=0:"*",1:..MessageGetField(pMessage,tApplicationCode))
	set tSendingFacility=$s(tFacilityCode=$$$eFieldSendingFacility:tFacility,1:..MessageGetField(pMessage,$$$eFieldSendingFacility))
	set tSendingApplication=$s(tApplicationCode=$$$eFieldSendingApplication:tApplication,1:..MessageGetField(pMessage,$$$eFieldSendingApplication))
	set tControlId=..MessageGetField(pMessage,$$$eFieldControlId)
	set tSeqNumber=..MessageGetField(pMessage,$$$eFieldSequenceNumber)
	quit ..recordIndex(tType,tFacility,tApplication,tSeqNumber,1,tSendingFacility,tSendingApplication,tControlId,tMessageId)
}

Method recordIndex(pType, pFacility, pApplication, pSeqNumber, pSaveIndexCT = 0, pSendingFacility = "", pSendingApplication = "", pControlId = "", pMessageId = "") As %Status
{
	set tTimeUTCH=$$$timeUTCH
	set ^EnsHL7.SM(..%ConfigName,"index","st",pType,pFacility,pApplication,pSeqNumber)=tTimeUTCH
	Set ^EnsHL7.SMI("ResendIndex",..%ConfigName,tTimeUTCH,$I(^EnsHL7.SMI("ResendIndex",..%ConfigName,tTimeUTCH)))=$LB("ts",pType,pFacility,pApplication,pSeqNumber)
	if pSaveIndexCT {
		set ^EnsHL7.SM(..%ConfigName,"index","ct","Sender",pSendingFacility,pSendingApplication,pControlId,pMessageId)=tTimeUTCH
		Set ^EnsHL7.SMI("ResendIndex",..%ConfigName,tTimeUTCH,$I(^EnsHL7.SMI("ResendIndex",..%ConfigName,tTimeUTCH)))=$LB("tc","Sender",pSendingFacility,pSendingApplication,pControlId,pMessageId)
	}
	quit $$$OK
}

Method purgeIndex()
{
	set tTimeH=$$$timeUTCH,tTime1=$p(tTimeH,",",1),tTime2=$p(tTimeH,",",2)
	set tTime2=tTime2-..MessageResendableTimeWindow
	if tTime2<0 set tTime1=tTime1-1,tTime2=tTime2+86400
	set tTimeCutOff=tTime1_","_tTime2
	set tTime=tTimeCutOff for  {
				set tTime=$o(^EnsHL7.SMI("ResendIndex",..%ConfigName,tTime),-1) quit:tTime=""
				set tNum="" for  {
						set tNum=$o(^EnsHL7.SMI("ResendIndex",..%ConfigName,tTime,tNum)) quit:tNum=""
						set tInfo = ^EnsHL7.SMI("ResendIndex",..%ConfigName,tTime,tNum)
						set tKind = $li(tInfo,1)
						set tType = $li(tInfo,2)
						set tFacility = $li(tInfo,3)
						set tApplication = $li(tInfo,4)
						if tKind="tc" kill ^EnsHL7.SM(..%ConfigName,"index","ct",tType,tFacility,tApplication,$li(tInfo,5),$li(tInfo,6))
						if tKind="ts" kill ^EnsHL7.SM(..%ConfigName,"index","st",tType,tFacility,tApplication,$li(tInfo,5))
						kill ^EnsHL7.SM(..%ConfigName,"index",tKind,tType,tFacility,tApplication,tTime)
						kill ^EnsHL7.SMI("ResendIndex",..%ConfigName,tTime,tNum)
					}
				kill ^EnsHL7.SMI("ResendIndex",..%ConfigName,tTime)
	}
}

ClassMethod GetDuplicatedList(Output pArray As %String, Output pHandle As %String, pCount As %Integer) As %Status
{
	quit ..getMetricsDetailList("duplicated",.pArray,.pHandle,.pCount)
}

ClassMethod GetOutOfSequenceList(Output pArray As %String, Output pHandle As %String, pCount As %Integer) As %Status
{
	quit ..getMetricsDetailList("outofsequence",.pArray,.pHandle,.pCount)
}

ClassMethod GetExpiredList(Output pArray As %String, Output pHandle As %String, pCount As %Integer) As %Status
{
	quit ..getMetricsDetailList("expired",.pArray,.pHandle,.pCount)
}

ClassMethod getMetricsDetailList(pType As %String, Output pArray As %String, Output pHandle As %String, pCount As %Integer = 100) As %Status
{
	set pHandle=$g(pHandle) for pCount=pCount:-1:1 {
		set pHandle=$o(^EnsHL7.SM.metric(pType,pHandle),-1,tValue) quit:pHandle=""
		set pArray($i(pArray))=tValue
	}
	quit $$$OK
}

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	do ##super(.pArray,pItem)
	set tSetting("OutputTargetConfigNames")="m"
	set tSetting("OutOfSequenceMessageTarget")="s"
	set tSetting("DuplicatedMessageTarget")="s"
	Do pItem.PopulateModifiedSettings()
	Set tIndex="" For {
		Set tOneSetting = pItem.ModifiedSettings.GetNext(.tIndex) Quit:tIndex=""
		set tOneSettingName=tOneSetting.Name,tOneSettingValue=tOneSetting.Value
		if $g(tSetting(tOneSettingName))="s" set:tOneSettingValue'="" pArray(tOneSettingValue)=""
		if $g(tSetting(tOneSettingName))="m" for j=1:1:$l(tOneSettingValue,",") set tOneTarget=$p(tOneSettingValue,",",j) set:tOneTarget'="" pArray(tOneTarget)=""
	}
	set tProduction=pItem.Production
	for i=1:1:tProduction.Items.Count() {
		if tProduction.Items.GetAt(i).Name="Ens.Alert" set pArray("Ens.Alert")=""
	}
	quit
}

/// Override this method in the subclass for messages other than EnsLib.HL7.Message
/// Method requirements: 1) $$$eFieldSequenceNumber must return a numeric value
///                      2) Facility and Application fields (4 fields) must return non-null values
ClassMethod MessageGetField(pMessage As %Persistent, pFieldCode As %Integer) As %String
{
	if pFieldCode=$$$eFieldName quit pMessage.Name
	#; tCodeFormat format is $lb(tFieldCode,tForceNumeric,tForceNonEmpty)
	set tCodeFormat=$case(pFieldCode,
	$$$eFieldControlId:				$lb("1:10",0,0),
	$$$eFieldSequenceNumber:		$lb("1:13",1,0),
	$$$eFieldSendingApplication:	$lb("1:3", 0,1),
	$$$eFieldSendingFacility:		$lb("1:4", 0,1),
	$$$eFieldReceivingApplication:	$lb("1:5", 0,1),
	$$$eFieldReceivingFacility:		$lb("1:6", 0,1),
	:"")
	set tValue=pMessage.GetValueAt($li(tCodeFormat,1))
	if $li(tCodeFormat,2) set tValue=+tValue
	if $li(tCodeFormat,3),tValue="" set tValue="(null)"
	quit tValue
}

/// Override this method in the subclass for messages other than EnsLib.HL7.Message
ClassMethod MessageSetField(pMessage As %Persistent, pFieldCode As %Integer, pValue As %String) As %Status
{
	set tCode=$case(pFieldCode,
	$$$eFieldControlId:				"1:10",
	$$$eFieldSequenceNumber:		"1:13",
	$$$eFieldSendingApplication:	"1:3",
	$$$eFieldSendingFacility:		"1:4",
	$$$eFieldReceivingApplication:	"1:5",
	$$$eFieldReceivingFacility:		"1:6",
	:"")
	quit pMessage.SetValueAt(pValue,tCode)
}

/// Override this method in the subclass for messages other than EnsLib.HL7.Message
ClassMethod MessageIsValid(pMessage As %Persistent) As %Boolean
{
	quit pMessage.%IsA("EnsLib.HL7.Message")
}

ClassMethod CurrentRuntimeDataVersion() As %Integer
{
	quit 4
}

Storage Default
{
<Data name="SequenceManagerDefaultData">
<Subscript>"SequenceManager"</Subscript>
<Value name="1">
<Value>SendingFacility</Value>
</Value>
<Value name="2">
<Value>SendingApplication</Value>
</Value>
<Value name="3">
<Value>TargetConfigName</Value>
</Value>
<Value name="4">
<Value>NextSequenceNumber</Value>
</Value>
<Value name="5">
<Value>WaitTimeout</Value>
</Value>
<Value name="6">
<Value>WaitStarted</Value>
</Value>
<Value name="7">
<Value>LateMessageConfigName</Value>
</Value>
<Value name="8">
<Value>DuplicatedMessageConfigName</Value>
</Value>
<Value name="9">
<Value>SequenceCheckExemptionTypes</Value>
</Value>
<Value name="10">
<Value>OutputAction</Value>
</Value>
<Value name="11">
<Value>OutputSendingApplication</Value>
</Value>
<Value name="12">
<Value>OutputSendingFacility</Value>
</Value>
<Value name="13">
<Value>PassThroughMessageTypes</Value>
</Value>
<Value name="14">
<Value>OutOfSequenceMessageTarget</Value>
</Value>
<Value name="15">
<Value>DuplicatedMessageTarget</Value>
</Value>
<Value name="16">
<Value>OutputFacilityApplication</Value>
</Value>
<Value name="17">
<Value>OutputTargetConfigNames</Value>
</Value>
<Value name="18">
<Value>MessageWaitTimeout</Value>
</Value>
<Value name="19">
<Value>PerformOutputTransformation</Value>
</Value>
<Value name="20">
<Value>PerformControlIdCheck</Value>
</Value>
<Value name="21">
<Value>PerformSequenceNumberCheck</Value>
</Value>
<Value name="22">
<Value>EnableControlIdCheck</Value>
</Value>
<Value name="23">
<Value>EnableSequenceNumberCheck</Value>
</Value>
<Value name="24">
<Value>EnableOutputTransformation</Value>
</Value>
<Value name="25">
<Value>EnableControlIdDuplicationCheck</Value>
</Value>
<Value name="26">
<Value>EnableDuplicatedMessageCheck</Value>
</Value>
<Value name="27">
<Value>PerformSequenceNumberCheckOn</Value>
</Value>
<Value name="28">
<Value>PerformOutputTransformationOn</Value>
</Value>
<Value name="29">
<Value>PerformDuplicatedMessageCheckOn</Value>
</Value>
<Value name="30">
<Value>PerformDuplicatedMessageCheck</Value>
</Value>
<Value name="31">
<Value>MessageResendableTimeWindow</Value>
</Value>
<Value name="32">
<Value>LargeGapSize</Value>
</Value>
<Value name="33">
<Value>OutputSequenceNumberIndexField</Value>
</Value>
<Value name="34">
<Value>DuplicatedMessageNoticeType</Value>
</Value>
<Value name="35">
<Value>OutOfSequenceMessageNoticeType</Value>
</Value>
<Value name="36">
<Value>PerformSequenceCheckOnInternalResent</Value>
</Value>
<Value name="37">
<Value>SkipSequenceNumberCheckOnInternalResent</Value>
</Value>
<Value name="38">
<Value>BypassCheckOnInternalResent</Value>
</Value>
<Value name="39">
<Value>FirstSequenceNumber</Value>
</Value>
</Data>
<Data name="WaitingList">
<Attribute>WaitingList</Attribute>
<Structure>subnode</Structure>
<Subscript>"WaitingList"</Subscript>
</Data>
<DefaultData>SequenceManagerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
