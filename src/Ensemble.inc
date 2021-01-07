ROUTINE Ensemble [Type=INC]
#include %occInclude
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#include %occErrors
#;Include %sySystem for KillRootNode
#include %sySystem
#;
#; The default is now to handle Global Kill Disabled using the macro definition copied from %sySystem
#ifdef EnsDoNotHandleGlobalKillDisabled
#define KillRootNode(%Global)	Kill %Global
#else
#;use definition from %sySystem
#endif
#;
#define EnsMajorVersion $system.Version.GetMajor()
#define EnsMinorVersion $system.Version.GetMinor()
#;
#define DEBUG
#;
#; Global value lookups
#define GblConfigName           $G($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$G($$$EnsJobStatus($$$SystemName,$Job,$$$eJobStartConfigName)))
#;
#; Job-Local values
#define staticCachedObject(%name)   $$$EnsJobLocal("CachedObject",$$$EnsRuntime("CheckSum"),%name)
#define staticCachedChecksum(%name) $$$EnsJobLocal("CachedChecksum",$$$EnsRuntime("CheckSum"),%name)
#;
#define ConfigTypeName(%t)      $Case(%t, $$$eHostTypeUnknown:"Unknown", $$$eHostTypeService:"BusinessService", $$$eHostTypeProcess:"BusinessProcess", $$$eHostTypeOperation:"BusinessOperation", $$$eHostTypeActor:"Actor", :"Unknown")
#;
#define JobConfigName           $S($D($$$EnsJobLocal("ConfigName")):$G($$$EnsJobLocal("GuestConfigName"),$$$EnsJobLocal("ConfigName")),1:$$$GblConfigName)
#define JobKey                  $S($D($$$EnsJobLocal("JobKey"),xJK):xJK,1:$ZStrip($Job,"*E'N"))
#define JobSessionId            $$$EnsJobLocal("SessionId")
#define JobCurrentHeaderId      $$$EnsJobLocal("CurrentHeaderId")
#define JobTraceDevice          $$$EnsJobLocal("TraceDevice")
#define JobSuperSession 		$$$EnsJobLocal("SuperSession")
#;
#define DoArchive               $G($$$EnsJobLocal("ArchiveFlags"))
#;
#define DoTrace                 $S($D($$$EnsJobLocal("DoTrace")):$$$EnsJobLocal("DoTrace"),1:##class(Ens.Util.Trace).DoTrace())
#;
#ifdef DEBUG
#define ASSERT(%condition)      If '(%condition) { $$$LOGASSERT("Assert Condition Failed: "_##quote(%condition)_$char(13,10)) BREAK }
#define TRACE(%arg)             $$$catTRACE("user",%arg)
#define sysTRACE(%arg)          $$$catTRACE("system",%arg)
#define catTRACE(%cat,%arg)     Do:$$$DoTrace ##class(Ens.Util.Trace).WriteTrace(%cat,$$$CurrentClass,$$$CurrentMethod,%arg)
#else
#define NODEBUG
#define ASSERT(%condition)
#define TRACE(%arg)
#define sysTRACE(%arg)
#define catTRACE(%arg)
#endif
#;
#define newlogLevelFatal        1
#define newlogLevelError        2
#define newlogLevelWarning      3
#define newlogLevelConfig       4
#define newlogLevelInfo         5
#define newlogLevelUserTrace    6
#define newlogLevelSysTrace     7
#define newLOG(%level,%cat,%msg) Do:(%level'>$g(^Ens.Debug("log"))) ##class(Ens.Util.Log).newLog($$$CurrentClass,$$$CurrentMethod,%level,%cat,%msg)
#;
#define LOGSTATUS(%status)      Do ##class(Ens.Util.Log).LogStatus($$$CurrentClass,$$$CurrentMethod,%status)
#define LOGASSERT(%arg)         Do ##class(Ens.Util.Log).LogAssert($$$CurrentClass,$$$CurrentMethod,%arg)
#define LOGERROR(%arg)          Do ##class(Ens.Util.Log).LogError($$$CurrentClass,$$$CurrentMethod,%arg)
#define LOGWARNING(%arg)        Do ##class(Ens.Util.Log).LogWarning($$$CurrentClass,$$$CurrentMethod,%arg)
#define LOGALERT(%arg)          Do ##class(Ens.Util.Log).LogAlert($$$CurrentClass,$$$CurrentMethod,%arg)
#define LOGINFO(%arg)           Do ##class(Ens.Util.Log).LogInfo($$$CurrentClass,$$$CurrentMethod,%arg)
#;
#def1arg EnsError(%args)        ##class(Ens.Util.Error).EnsError($$$CurrentClass,$$$CurrentMethod,##safeexpression($$macroERRORArgList^%occMsgXML(%literalargs,1)))
#define  EnsSystemError         ##class(Ens.Util.Error).EnsSystemError($$$CurrentClass,$$$CurrentMethod)
#define  SystemError            ##class(Ens.Util.Error).ExceptionStatus()
#def1arg SystemErrorType(%t)    ##class(Ens.Util.Error).ExceptionStatus(%t)
#;
#; Abstract Base IO Log macros
#define abNEWIOLOGENTRY(%base,%isin,%sc,%txt,%meth,%obj) Do:%base.ArchiveIO %base.NewIOLogEntry(%isin,%sc,%txt,%meth,%base.%SessionId,%obj)
#define abSAVEIOLOGENTRY(%base,%sc,%txt,%obj)   Do:$IsObject(%base.IOLogEntry) %base.SaveIOLogEntry(%sc,%txt,%obj)
#define abCLOSEIOLOGENTRY(%base,%sc,%txt,%obj)  Do:$IsObject(%base.IOLogEntry) %base.CloseIOLogEntry(%sc,%txt,%obj)
#;
#; IO Log macros for Business Operation & Business Service
#define NEWINIOLOGENTRY(%sc,%txt,%obj)        $$$abNEWIOLOGENTRY(.,1,%sc,%txt,$$$CurrentMethod,%obj)
#define NEWOUTIOLOGENTRY(%sc,%txt,%meth,%obj) $$$abNEWIOLOGENTRY(.,0,%sc,%txt,%meth,%obj)
#define SAVEIOLOGENTRY(%sc,%txt,%obj)         Do:$IsObject(..IOLogEntry) ..SaveIOLogEntry(%sc,%txt,%obj)
#define CLOSEIOLOGENTRY(%sc,%txt,%obj)        Do:$IsObject(..IOLogEntry) ..CloseIOLogEntry(%sc,%txt,%obj)
#;define SAVEIOLOGENTRY(%sc,%txt,%obj)        $$$abSAVEIOLOGENTRY(.,%sc,%txt,%obj}
#;define CLOSEIOLOGENTRY(%sc,%txt,%obj)       $$$abCLOSEIOLOGENTRY(.,%sc,%txt,%obj)
#;
#; IO Log macros for Inbound & Outbound Adapters
#define ANEWINIOLOGENTRY(%sc,%txt,%obj)  $$$abNEWIOLOGENTRY(..BusinessHost,1,%sc,%txt,$$$CurrentMethod,%obj)
#define ANEWOUTIOLOGENTRY(%sc,%txt,%obj) $$$abNEWIOLOGENTRY(..BusinessHost,0,%sc,%txt,$$$CurrentMethod,%obj)
#define ASAVEIOLOGENTRY(%sc,%txt,%obj)   Do:$IsObject(..BusinessHost.IOLogEntry) ..BusinessHost.SaveIOLogEntry(%sc,%txt,%obj)
#define ACLOSEIOLOGENTRY(%sc,%txt,%obj)  Do:$IsObject(..BusinessHost.IOLogEntry) ..BusinessHost.CloseIOLogEntry(%sc,%txt,%obj)
#;
#define WEBTRACE(%msg)     If ($IsObject($G(%response))) { Write %msg,! Do %response.Flush() }
#define SysWebTrace(%s)    $$$sysTRACE(%s)
#;
#define SystemName         "sys"
#;
#def1arg EnsConfig(%subs)     $$$EnsJobLocal("Config",%subs)
#def1arg EnsDebug(%subs)      $$$EnsJobLocal("Debug",%subs)
#define EnsRuntime            ^Ens.Runtime
#define EnsQueue              ^Ens.Queue
#define EnsJobLock            ^Ens.JobLock
#define EnsJobStatusStarted   ^Ens.JobStatus
#define EnsJobStatusRoot      ^IRIS.Temp.EnsJobStatus
#define KillAllEnsJobStatus   Kill $$$EnsJobStatusRoot($namespace)
#def1arg EnsJobStatus(%args)  $$$EnsJobStatusRoot($namespace,%args)
#define EnsActiveMessage    ^Ens.ActiveMessage
#define EnsJobRequest       ^Ens.JobRequest
#define EnsSuspended        ^Ens.Suspended
#define EnsSuspendedAppData ^Ens.SuspendedAppData
#define EnsJobLocal         %Ensemble
#;
#define EnsCrashedMessage(%msgid) $$$EnsRuntime("CrashedMessage",%msgid)
#;
#define EnsRuntimeAppDataRoot     ^IRIS.Temp.EnsRuntimeAppData
#define KillAllEnsRuntimeAppData  Kill $$$EnsRuntimeAppDataRoot($namespace)
#def1arg EnsRuntimeAppData(%args) $$$EnsRuntimeAppDataRoot($namespace,%args)
#define EnsStaticAppData          ^Ens.AppData
#;
#define EnsAlarm                  ^Ens.Alarm
#;
#define DispatchNameToConfigName(%dispatchname)        $$$EnsRuntime("DispatchName",%dispatchname)
#;
#define ConfigRoot(%configname)                        $$$EnsRuntime("ConfigItem",%configname)
#define ConfigClassName(%configname)                   $$$EnsRuntime("ConfigItem",%configname,"ClassName")
#define ConfigOnTaskClassName(%configname)             $$$EnsRuntime("ConfigItem",%configname,"OnTaskClassName")
#define ConfigQueueName(%configname)                   $$$EnsRuntime("ConfigItem",%configname,"QueueName")
#define ConfigIsEnabled(%configname)                   $$$EnsRuntime("ConfigItem",%configname,"IsEnabled")
#define ConfigChecksum(%configname)                    $$$EnsRuntime("ConfigItem",%configname,"Checksum")
#define ConfigRunAsJob(%configname)                    $$$EnsRuntime("ConfigItem",%configname,"Job")
#define ConfigTempStop(%configname)                    $$$EnsRuntime("ConfigItem",%configname,"TemporarilyStop")
#define ConfigId(%configname)                          $$$EnsRuntime("ConfigItem",%configname,"%Id")
#define ConfigBusinessType(%configname)                $$$EnsRuntime("ConfigItem",%configname,"BusinessType")
#define ConfigInactivityTimeout(%configname)           $$$EnsRuntime("ConfigItem",%configname,"InactivityTimeout")
#define ConfigPoolSize(%configname)                    $$$EnsRuntime("ConfigItem",%configname,"PoolSize")
#define ConfigSchedule(%configname)                    $$$EnsRuntime("ConfigItem",%configname,"Schedule")
#define ConfigTrace(%configname)                       $$$EnsRuntime("ConfigItem",$S(""=%configname:"%Production",1:%configname),"Trace")
#define ConfigSettingRoot(%configname)                 $$$EnsRuntime("ConfigItem",%configname,"Setting")
#define ConfigSetting(%configname,%target,%name)       $$$EnsRuntime("ConfigItem",%configname,"Setting",%target,%name)
#define ConfigProdSetting(%name)                       $$$EnsRuntime("ConfigItem","%Production","Setting",%name)
#define ConfigSessionQueueName(%configname,%sessionid) $$$EnsRuntime("ConfigItem",%configname,"QueueName",%sessionid)
#define getConfigQueueName(%configname,%sessionid)     $get($$$EnsRuntime("ConfigItem",%configname,"QueueName",$s(%sessionid'="":%sessionid,1:"*")),$get($$$EnsRuntime("ConfigItem",%configname,"QueueName")))
#;
#include EnsConstants
#include EnsErrors
#include EnsUtil
#;
#; Status & Counter macros
#;
#; Global used to hold monitor status and counters
#; Do not use these macros except in the macro definitions in this file
#define EnsHostMonitorRoot     ^IRIS.Temp.EnsHostMonitor
#define EnsHostCounterRoot     ^IRIS.Temp.EnsHostCounter
#define EnsJobMonitorRoot      ^IRIS.Temp.EnsJobMonitor
#define EnsLogMonitorRoot      ^IRIS.Temp.EnsLogMonitor
#;
#; Host Monitor macros
#def1arg OrderHostMonitor(%arg)               $order($$$EnsHostMonitorRoot($namespace,%arg))
#define  KillAllHostMonitor                   Kill $$$EnsHostMonitorRoot($namespace)
#def1arg KillHostMonitor(%host)               Kill $$$EnsHostMonitorRoot($namespace,%host)
#define  SetHostMonitor(%host,%prop,%val)     Set $$$EnsHostMonitorRoot($namespace,%host,%prop)=%val,$$$EnsHostMonitorRoot($namespace,%host,$$$eMonitorLastActivity)=$$$timeUTC
#define  RegisterHostMonitorJob(%host,%job)   Set $$$EnsHostMonitorRoot($namespace,%host,$$$eMonitorJob,%job)="",$$$EnsHostMonitorRoot($namespace,%host,$$$eMonitorLastActivity)=$$$timeUTC
#define  GetHostMonitor(%host,%prop)          $G($$$EnsHostMonitorRoot($namespace,%host,%prop))
#;
#; Counter macros
#def1arg OrderHostCounter(%args)              $order($$$EnsHostCounterRoot($namespace,%args))
#define  KillAllHostCounter                   Kill $$$EnsHostCounterRoot($namespace)
#define  KillHostCounter(%host,%day,%slot)    Kill $$$EnsHostCounterRoot($namespace,%host,%day,%slot)
#; count of host actions over time split into intervals
#define  IncHostCounterTime(%host)            Set tUTCH=$$$timeUTCH If $I($$$EnsHostMonitorRoot($namespace,%host,$$$eMonitorCount)),$I($$$EnsHostCounterRoot($namespace,%host,+tUTCH,$P(tUTCH,",",2)\$$$EnsCounterInterval)) {} $$$SetHostMonitor(%host,$$$eMonitorStatus,"OK")
#define  GetHostCounter(%host,%day,%slot)     $G($$$EnsHostCounterRoot($namespace,%host,%day,%slot))
#;
#; Total Host counter
#define EnsHostCounterTotalsRoot		     	^IRIS.Temp.EnsHostTotals
#def1arg EnsHostCounterTotals(%args)		     $$$EnsHostCounterTotalsRoot($namespace,%args)
#;
#; Job Monitor macros
#def1arg OrderJobMonitor(%arg)                $order($$$EnsJobMonitorRoot($namespace,%arg))
#define  EnsJobMonitorNode(%job)              $$$EnsJobMonitorRoot($namespace,%job)
#define  KillAllJobMonitor                    Kill $$$EnsJobMonitorRoot($namespace)
#define  KillJobMonitor(%job)                 Kill $$$EnsJobMonitorRoot($namespace,%job)
#define  SetJobMonitor(%host,%job,%prop,%val) Set $$$EnsJobMonitorRoot($namespace,%job,%host,%prop)=%val,$$$EnsJobMonitorRoot($namespace,%job,%host,$$$eMonitorLastActivity)=$$$timeUTC
#define  GetJobMonitor(%host,%job,%prop)      $G($$$EnsJobMonitorRoot($namespace,%job,%host,%prop))
#; count of total actions since job was started
#define  IncJobCounterTime(%host,%job)        If $I($$$EnsJobMonitorRoot($namespace,%job,%host,$$$eMonitorCount)) {} $$$SetJobMonitor(%host,%job,$$$eMonitorStatus,"OK")
#;
#; Log Monitor macros
#def1arg OrderLogMonitor(%arg)                $order($$$EnsLogMonitor($namespace,%arg))
#define  KillAllLogMonitor                    Kill $$$EnsLogMonitorRoot($namespace)
#define  KillLogMonitor(%type)                Kill $$$EnsLogMonitorRoot($namespace,%type)
#define  SetLogMonitor(%type,%prop,%val)      Set $$$EnsLogMonitorRoot($namespace,%type,%prop)=%val,$$$EnsLogMonitorRoot($namespace,%type,$$$eMonitorLastActivity)=$$$timeUTC
#define  GetLogMonitor(%type,%prop)           $G($$$EnsLogMonitorRoot($namespace,%type,%prop))
#define  IncLogCounter(%host)                 If $I($$$EnsLogMonitorRoot($namespace,%host,$$$eMonitorCount)) {} $$$SetLogMonitor(%host,$$$eMonitorStatus,"OK")
#;
#; Size (in seconds) of the interval used by host activity counter
#define EnsCounterInterval           10
#;
#; Queue Name macros
#define queueIsPrivateQueue(%name)   ($e(%name,1)="_")
#define queueIsNotSyncQueue(%name)   ($e(%name,1,10)'="_SyncCall:")
#define queueSyncCallQueueName       ("_SyncCall:"_$job)
#define queueSystemSignalQueueName   ("_SystemSignal:"_$job)
#define queueBusinessDuplexQueueName ("_BusinessDuplex:"_$job_":"_..%PrivateSessionId)
#;
#; local mirror config var change-index macros
#define EnsMirrorIndex               $ZU(35,1)
#define EnsMirrorIndexInc            $ZU(35,1,1)
#define EnsMirrorIndexReset          Do $ZU(35,1,1-$ZU(35,1))
#;
#; MsgBank config change index macros
#define EnsMsgBankIndex              $ZU(35,2)
#define EnsMsgBankIndexInc           $ZU(35,2,1)
#define EnsMsgBankIndexReset         Do $ZU(35,2,1-$ZU(35,2))
#;
#; Synchronous Commit Set/Clear macros - sync on outermost nested SyncCommitClear() (nesting not to be coded within a single method / stack frame)
#define SyncCommitSet(%t)            Set:$G($$$EnsConfig("SyncCommit",$G($$$EnsJobLocal("ConfigName"),"%Production")),$G($$$EnsConfig("SyncCommit"),0)) %t=$I($$$EnsJobLocal("SyncCommitDepth"))
#define SyncCommitClear(%t)          If $G(%t)>0 { Set $$$EnsJobLocal("SyncCommitDepth")=%t-1  Do:%t=1 ##class(%SYS.Journal.System).Sync() }
#define SyncCommitNow                Do:$G($$$EnsConfig("SyncCommit",$G($$$EnsJobLocal("ConfigName"),"%Production")),$G($$$EnsConfig("SyncCommit"),0)) ##class(%SYS.Journal.System).Sync()
#;
#; Auditing
#;
#define AuditModifyProductionConfig(%prod,%item,%actions)       ##class(Ens.Util.Auditing).AuditModifyProductionConfig(%prod,%item,%actions)
#define AuditModifySchema(%schema,%actions)                     ##class(Ens.Util.Auditing).AuditModifySchema(%schema,%actions)
#define AuditStartStopProduction(%prod,%action)                 ##class(Ens.Util.Auditing).AuditStartStopProduction(%prod,%action)
#define AuditViewMessage(%source,%headerId,%bodyClass,%bodyId)  ##class(Ens.Util.Auditing).AuditViewMessage(%source,%headerId,%bodyClass,%bodyId)
#;
#; BPL Helpers
#define ThrowFault(%s)  Set ..%Context.%LastFault=%s,status=$$$ERROR($$$EnsErrBPLThrownFault,%s) ZT "THRO"
#;
#; Production Modification checks and flags
#define EnsProdSettings                    %EnsProdSettings
#define EnsProdSettingsProperty(%prop)     $$$EnsProdSettings(%prop)
#define EnsProdSettingsOref(%oref)         $$$EnsProdSettings("orefs",+(%oref))
#define EnsProdSettingsModified            +$get($$$EnsProdSettings)
#define	EnsProdSettingsSetModified(%flag)  Set $$$EnsProdSettings = ''(%flag)
#;
#; Core counter macros
#define EnsProdModCounterRoot        ^IRIS.Temp.EnsProdModCounter
#define EnsProdModCounter             $$$EnsProdModCounterRoot($namespace)
#define EnsProdModCounterGet         $get($$$EnsProdModCounter)
#define EnsProdModCounterInc         $increment($$$EnsProdModCounter)
#define EnsProdModCounterIncAndGet   ($increment($$$EnsProdModCounter)-1)
#define EnsProdModCounterKill        Kill $$$EnsProdModCounter
#;
#; Active location macros
#define EnsProdModActiveRoot   ^IRIS.Temp.EnsProdModActive
#define EnsProdModActive       $$$EnsProdModActiveRoot($namespace)
#define EnsProdModActiveGet    $get($$$EnsProdModActive)
#define EnsProdModActiveInc    $increment($$$EnsProdModActive)
#define EnsProdModActiveKill   Kill $$$EnsProdModActive
#;
#; Active/Counter comparison macros
#define EnsProdModNoChanges    ($get($$$EnsProdModActive,-1) = $get($$$EnsProdModCounter,-2))
#define EnsProdModChanged      ('$$$EnsProdModNoChanges)
#;
#; Metrics macros
#define EnsMetricsRoot		^IRIS.Temp.EnsMetrics
#def1arg EnsMetrics(%args)	$$$EnsMetricsRoot($namespace,%args)
#define KillAllEnsMetrics	Kill $$$EnsMetricsRoot($namespace)
#;
#; Used to control if inProc request persisted.
#define EnsInProcPersist	$$$EnsJobLocal("InProc","Persist")
#;
#; Maintaining EnsJobLocal Cached in CSP Gateway job
#define EnsLocalCacheRoot		%EnsembleCached
#def1arg EnsLocalCache(%args)	$$$EnsLocalCacheRoot(%args)
#;Statistics recording
#; See Ens.Util.Statistics.cls
#; 3 types of metrics counter and aggregate duration will be stored in:
#;Count of messages within time slot:  $$$StatsPersistCountersRoot($namespace~$job,day,timeslot,configtype: bs/bo/bp,configname,user dimension e.g. enterpriseid <value>,count)
#;Total duration for messages within time slot:  $$$StatsPersistCountersRoot($namespace~$job,day,timeslot,configtype: bs/bo/bp,configname,user dimension e.g. enterpriseid <value>,duration)
#;Total queuing time for messages within time slot:  $$$StatsPersistCountersRoot($namespace~$job,day,timeslot,configtype: bs/bo/bp,configname,user dimension e.g. enterpriseid <value>,queue)
#def1arg StatsPersistCountersRoot(%args)	^IRIS.Temp.EnsStatsCounters(%args)
#def1arg StatsPersistCounters(%args)		$$$StatsPersistCountersRoot($namespace_"~"_$Job,%args)
#;Stats held in memory at:
#def1arg StatsRootData(%args) 				$$$EnsJobLocal("Stats","Host",%args)
#;Used to indicate we have started collecting and as the basis for duration calc.
#define StatsStart(%configname)				$$$StatsRootData(%configname,0)
#;Used to store the QueueTime.
#define StatsQueueDuration(%configname)		$$$StatsRootData(%configname,"QueueDuration")
#;User dimension name/value:
#define StatsUserDimension(%configname)		$$$StatsRootData(%configname,"UserDimension")
#;Cannot be null since used as a subscript.
#define StatsDefaultDimension				"-"
#;
#;MsgBank TCP Service counters.
#define EnsMsgBankRoot							^IRIS.Temp.EnsMsgBank
#define EnsMsgBankHandShake						$$$EnsMsgBankRoot($namespace,"HandShake")
#def1arg EnsMsgBankConnections(%args)			$$$EnsMsgBankRoot($namespace,%args)
#;
#;event-device Socket Select Interrupt Identification. Must unique and of the form | 3 characters |
#define EnsSelectInterruptRoot	"|SIJ|"
#define EnsSelectInterruptID	$$$EnsSelectInterruptRoot_$Job
#;
#; Local job pointers to Gateway orefs
#def1arg EnsJobGatewaysRoot(%args)			$$$EnsJobLocal("Gateways",%args)
#define EnsJobGatewayXSLT2					$$$EnsJobGatewaysRoot("XSLT2")
#;
#; Local Job pointers to CompiledStyleSheets
#def1arg EnsJobXSLT2Root(%args) 			$$$EnsJobLocal("XSLT2",%args)
#def1arg EnsJobXSLT2CompiledXSL(%args) 		$$$EnsJobXSLT2Root("Compiled",%args)
#;
#; MFT macros
#define EnsMFTIDsSeen					^||EnsEnsMFTIDsSeen
#define EnsMFTDoneFileTable(%tk)		$$$EnsStaticAppData(..BusinessHost.%ConfigName,"mft","done",%tk)
#def1arg EnsMFTErrorFileTable(%args)	$$$EnsRuntimeAppData(..BusinessHost.%ConfigName,"mft","errored",%args)
#define EnsMFTFailedMatchTable(%tk)		$$$EnsRuntimeAppData(..BusinessHost.%ConfigName,"mft","failedmatch",%tk)
#define EnsCoreMFTAPIClass				"%MFT.API"
#;
#; Ens Configuration
#define EnsConfigurationGbl				^Ens.Configuration
#define EnsProdShutdownGroup(%prod)		$$$EnsConfigurationGbl("ShutdownGroup",%prod)
#define EnsPurgeRoot					$$$EnsConfigurationGbl("PurgeSettings")
#define EnsPurgeDefaults(%setting)		$$$EnsConfigurationGbl("PurgeSettings",%setting)
#define EnsPurgeDescriptions			$$$EnsConfigurationGbl("PurgeSettings","Desc")
#;
#; Temporary global stream - not journaled
#define EnsTempGlobalStream				^IRIS.Temp.EnsTempStream($namespace)
#;
#; SubClassOf query init value
#define EnsStartAfterSysPercent				"%YZ"
#define EnsSubClassOfInitOverride(%cls)		$$$EnsConfigurationGbl("SubClassOfInit",%cls)
#define EnsSubClassOfInit(%cls)				$Get($$$EnsSubClassOfInitOverride(%cls),$$$EnsStartAfterSysPercent)
#;
#; Settings warning macros
#define EnsCheckSSLConfig(%sslconfig)		Try {If $Piece($ZSTRIP(%sslconfig,"<>WC"),"|",2) '="" $$$LOGWARNING("SSLConfig Setting includes Private key password in production class - move to protected SSL/TLS Configuration definition.") } Catch {}
#;
#;Enterprise Monitor soap cookie
#define EnsMonSOAPCookie(%id)			$$$EnsJobLocal("EntMonClient",%id)
#;
#;Alert persist macros
#define EnsAlertedCountRoot				$$$EnsStaticAppData(..%ConfigName,"Count")
#define EnsAlertedDelayRoot				$$$EnsStaticAppData(..%ConfigName,"Delay")
#define EnsAlertedCount(%host)			$$$EnsStaticAppData(..%ConfigName,"Count",%host)
#define EnsAlertedDelay(%host)			$$$EnsStaticAppData(..%ConfigName,"Delay",%host)