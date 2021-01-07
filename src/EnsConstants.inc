ROUTINE EnsConstants [Type=INC]
#;
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#; constants for Production state
#;
#define eProductionStateUnknown        0
#define eProductionStateRunning        1
#define eProductionStateStopped        2
#define eProductionStateSuspended      3
#define eProductionStateTroubled       4
#define eProductionStateNetworkStopped 5
#; constants for Production state on non-primary mirror members
#define eProductionStateBackupUnknown        (-10)
#define eProductionStateBackupRunning        (-$$$eProductionStateRunning)
#define eProductionStateBackupStopped        (-$$$eProductionStateStopped)
#define eProductionStateBackupSuspended      (-$$$eProductionStateSuspended)
#define eProductionStateBackupTroubled       (-$$$eProductionStateTroubled)
#define eProductionStateBackupNetworkStopped (-$$$eProductionStateNetworkStopped)
#;
#; constants for EnsJobStatus
#;
#define eJobStatusStarting    "starting"
#define eJobStatusRegistered  "registered"
#define eJobStatusVisiting    "visiting"
#define eJobStatusRunning     "running"
#define eJobStatusDeQueuing   "dequeuing"
#define eJobStatusQuiescent   "quiescent"
#define eJobStatusError       "error"
#define eJobStatusHalted      "halted"
#define eJobStatusTerminated  "terminated"
#;
#; constants for Job Request
#;
#define eJobRequestQuiescent "quiescent"
#define eJobRequestTerminate "terminate"
#define eJobRequestAbort     "abort"
#define eJobRequestSuspend   "suspend"
#;
#; constants for Business Host Type
#;
#define eHostTypeUnknown   0
#define eHostTypeService   1
#define eHostTypeProcess   2
#define eHostTypeOperation 3
#define eHostTypeActor     4
#;
#; constants for Ens.MessageHeader:Priority
#;
#define eMessagePriorityHighSync 1
#define eMessagePrioritySync     2
#define eMessagePrioritySimSync  4
#define eMessagePriorityAsync    6
#;
#; -- old Ens.MessageHeader:Priority values - since renamed for clarity and renumbered in a back-compatible way --
#;define eMessagePriorityRealTime 1
#;define eMessagePriorityHigh     2
#;define eMessagePriorityNormal   3
#;define eMessagePriorityLow      4
#;
#; constants for Ens.MessageHeader:Status
#; 
#define eMessageStatusCreated   1
#define eMessageStatusQueued    2
#define eMessageStatusDelivered 3
#define eMessageStatusDiscarded 4
#define eMessageStatusSuspended 5
#define eMessageStatusDeferred  6
#define eMessageStatusAborted   7
#define eMessageStatusError     8
#define eMessageStatusCompleted 9
#;
#; constants for Ens.MessageHeader:Type
#;
#define eMessageTypeRequest   1
#define eMessageTypeResponse  2
#define eMessageTypeTerminate 3
#;
#; constants for Ens.MessageHeader:Invocation
#;
#define eMessageInvocationQueue  1
#define eMessageInvocationInProc 2
#;
#; constants used for Ens.BusinessProcess:RepliedStatus
#;
#define eRepliedStatusNotCalled    1
#define eRepliedStatusConstructed  2
#define eRepliedStatusSent         3
#define eRepliedStatusDeferred     4
#;
#; constants for Ens.Util.Log:Type
#;
#define eLogTypeAssert  1
#define eLogTypeError   2
#define eLogTypeWarning 3
#define eLogTypeInfo    4
#define eLogTypeTrace   5
#define eLogTypeAlert   6
#;
#; constants for Ens.BusinessProcess:RunStatus
#;
#define eRunStatusRunning   1
#define eRunStatusCompleted 2
#define eRunStatusWaiting   3
#define eRunStatusErrored   4
#;
#; constants used for Ens.BP.CodeContext
#;
#define eCodeContextNone      1
#define eCodeContextProcess   2
#define eCodeContextRequest   3
#define eCodeContextResponse  4
#;
#; constants used for BPL/DTL language specification
#; 
#define objectscript          "objectscript"
#define basic                 "basic"
#define sysLangFromBPL(%lang) $case(%lang,$$$objectscript:$$$cMETHLANGUAGEOBJECTSCRIPT,$$$basic:$$$cMETHLANGUAGEBASIC)
#;
#; Monitor properties (subscripts for HostMonitor and JobMonitor globals)
#;
#define eMonitorLastActivity              "%LastActivity"
#define eMonitorStatus                    "%Status"
#define eMonitorMethod                    "%Method"
#define eMonitorRetry                     "%Retry"
#define eMonitorCount                     "%Count"
#define eMonitorConnected                 "%Connected"
#define eMonitorJob                       "%Job"
#;
#; JobStatus properties (subscripts for EnsJobStatus global)
#;
#; Note: $$$EnsJobStatus values reflect the "identity" of the job, i.e. what the job was launched for.
#; $$$EnsJobMonitor values reflect the transient "use" of a job, i.e. what config item is running or
#;  has run in the job.
#; ConfigItems running "InProc" will use the calling job's context, but their $$$JobMonitor values
#;  will be logged under their ConfigName in the Monitor global and the hosting Job Id. For this reason
#;  it is possible to have several ConfigItems under the Monitor global containing JobStatus entries for
#;  the same Job Id.
#; Also, BP's log their instances to JobMonitor as if the instance ID were a Job Id. This will not
#;  collide with real Job Ids because of the $$$SystemName: prefix on the real ones.
#;
#define eJobStatus                    "%Status"
#define eJobDetail                    "%Detail"
#define eJobSessionId                 "%SessionId"
#define eJobStartConfigName           "%StartConfigName"
#define eJobGuestConfigName           "%GuestConfigName"
#define eJobIsTempJob                 "%IsTempJob"
#define eJobForeground                "%Foreground"
#define eJobIsDead                    "%IsDead"
#define eJobRegTime                   "%RegTime"
#;
#; Generic default SOAP fault code for SOAP service WebMethod errors
#;
#define EnsFAULTMethod                "SOAP-ENV:Method"
#;
#define eConfigSettingValueTypeReadOnly    0
#define eConfigSettingValueTypeProduction  1
#define eConfigSettingValueTypeSystem      2
#define eConfigSettingValueTypeProperty    3
#define eConfigSettingValueTypeRegistry    4
#;
#; constants for Archive Manager
#;
#define archiveArchiveData   1
#define archivePurgeHeader   2
#define archivePurgeBody     4
#;
#; constants for Auditing Events
#;
#define auditModifyProductionConfig  ##class(%EnsembleMgr).defineAuditModifyProductionConfiguration()
#define auditModifySchema            ##class(%EnsembleMgr).defineAuditModifySchema()
#define auditStartStopProduction     ##class(%EnsembleMgr).defineAuditStartStopProduction()
#define auditViewMessageContents     ##class(%EnsembleMgr).defineAuditViewMessageContents()
#;
#; constants for Ens.MessageHeader:Banked flags
#;
#define eMsgBankHeader			1
#define eMsgBankBody			2
#define eMsgBankSearchTable		4
#define eMsgBankFlagged			8
#;
#; constants for Managed Alert Actions (Ens.DataType.ManagedAlertAction)
#;
#define eAlertActionAssign				1
#define eAlertActionOpenChange			2
#define eAlertActionEscalationChange	4
#define eAlertActionNextActionChange	8
#define eAlertActionSendUpdate			16
#define eAlertActionReoccurrence		32
#;
#; constants for Managed Alert Notification types (Ens.DataType.AlertNotification)
#;
#define eAlertNotificationRequest			0
#define eAlertNotificationReminder			1
#define eAlertNotificationEscalationChange	2
#;
#; constants for Rule Log Type (Ens.DataType.RuleLogType)
#;
#define eRuleLogTypeError			"e"
#define eRuleLogTypeReturn			"r"
#define eRuleLogTypeUserDebug		"d"
#define eRuleLogTypeConditionDebug	"c"
#;
#;SuperSession HTTP Header identifier
#define EnsHTTPHeaderSuperSession				"VND.InterSystems.Ensemble.SuperSession"
#define EnsHTTPHeaderSuperSessionLC				"vnd.intersystems.ensemble.supersession"
#define EnsHTTPHeaderSuperSessionUC				"VND.INTERSYSTEMS.ENSEMBLE.SUPERSESSION"
#define EnsHTTPHeaderSuperSessionCgiEnvs		"HTTP_VND.INTERSYSTEMS.ENSEMBLE.SUPERSESSION"
#;
#; constants for XSLT2
#;
#define eXSLTWarning	1
#define eXSLTError		2
#define eXSLTFatalError	3
#;
#; constant for production shutdown group
#define ensDefaultShutdownGroup	2
#;
#; constant for de-serialization options
#define ensVDocAndXMLOnly		0
#define ensVDocAndXMLThenOther	1
#define ensVDocAndOther			2
#;
#; Message Header purge constants
#define ensPurgeMaxWarn		10
#define ensPurgeMaxStatus	10
#define ensPurgeHdr			1
#define ensPurgeBody		2
#define ensPurgeST			3

