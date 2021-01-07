Include HS.HC

Class HS.Sync.Utils Extends %RegisteredObject
{

/// Domain used for localization.
Parameter DOMAIN = "HS";

/// To be used when something has gone drastically wrong 
/// Once the production starts up, the required records will be recovered
ClassMethod Reset() As %Status [ Internal ]
{
	If '..IsSyncSlave() Quit $$$ERROR($$$GeneralError,"Cannot run rebuild on the Hub")
	Quit ..DeleteSyncData()
}

/// Basically a hidden method to prevent people from accidentally deleting their sync data
/// This code is moved into a method so that it can be called from the registry reset.
ClassMethod DeleteSyncData() As %Status [ Internal ]
{
	Do ##class(HS.Sync.BaseClass).SyncTables(.tTables)
	For tIdx=1:1:tTables If $li(tTables(tIdx),2)]"" {Set tClass=$li(tTables(tIdx)) Do $classMethod(tClass,"%KillExtent")}
	Kill ^OBJ.GUID,^Cache.SyncTimeD,^Cache.SyncTimeI,^OBJ.JournalT,^OBJ.Journal,^OBJ.SYNC.1,^OBJ.SYNC.ERR
	Quit $$$OK
}

ClassMethod IsMapped(pNamespace = {$namespace}) As %Boolean [ Internal ]
{
	New $namespace
	// Run in %SYS
 	Set $namespace="%SYS"
	Quit ##Class(Config.MapGlobals).Exists(pNamespace,"HS.Registry.ConfigD")
}

ClassMethod Mapping(pNamespace = {$Namespace}, pActivate = 1) As %Status [ Internal ]
{
	Set tSC = ##class(HS.Sync.BaseClass).MappingData(.tMapLines) Quit:$$$ISERR(tSC)
	For tIdx = 1:1:tMapLines {
		Do ##class(HS.HC.Util.Installer).AddGlobalMappings("",pNamespace,tMapLines(tIdx),"HSSYS")
	}
	
	Do:pActivate ##class(HS.HC.Util.Installer).ActivateConfiguration("",pNamespace)
	Quit $$$OK
}

/// Because this must be able to run on non primary mirror members, it can't use %Open to access data
/// and must do things like direct global references and internal methods like HubEndpointGetStored
ClassMethod IsSyncSlave() As %Boolean [ Internal ]
{
	try {
		Set tIsSyncSlave=0,tHubURL = "", tHaveNonHub=0
		If $G(^["HSSYS"]ISC.HS.SyncSlave)'="" Set tIsSyncSlave=^["HSSYS"]ISC.HS.SyncSlave Quit
		#; HSSYS is not in the ConfigItem table
		If ##class(HS.Util.Installer.ConfigItem).%ExistsId($namespace) {
			set tClass=$LG($G(^%SYS("HealthShare","Instances",$namespace)))
			Set tClass=$piece(tClass,$extract(tClass),*-1)
			Quit:tClass="HS.Util.Installer.Foundation"
			
			try { 
				Set tHubURL = $CLASSMETHOD(tClass,"HubEndpointGetStored",$NAMESPACE)
			} catch {}

		}
		Set tNS = "",tHaveHub=0
		For  {
			Set tNS=$O(^%SYS("HealthShare","Instances",tNS),1,tInfo) Quit:tNS=""
			Set tType=$g(^%SYS("HealthShare","Instances",tNS,"Type"))
			If tType="Hub" {
				Set tHaveHub=1 Continue
			}
			//Special logic to handle being called from HSSYS, to determine if any other non-Foundation
			//namespace exists.  Used to set up HSSYS tasks on sync slaves
			Continue:$namespace'="HSSYS"||tHaveNonHub
			//This will handle edge ge, bus, access gw
			If tType'="Foundation" Set tHaveNonHub=1 Continue
			//Handle "foundation type" such as Health Insight & Patient Index
			If $LG(tInfo)["HS.Util.Installer.FoundationType" Set tHaveNonHub=1
		}
		//If there is no hub, and:
		// either 		this namespace has a hub url,
		// or we're in HSSYS and there's some other non-hub (but not pure foundation) namespace
		If 'tHaveHub,tHubURL'=""||tHaveNonHub Set tIsSyncSlave=1
	} catch ex {
	}
	Quit tIsSyncSlave
}

/// Purge object journal globals (^OBJ.Journal and ^OBJ.JournalT) respecting the sync slave tracker
ClassMethod PurgeObjectJournal() As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		#; Get hub version history where tHubVersion(<version>) = <high tx at upgrade to version>
		Quit:'$$$IsHub
		$$$ThrowOnError(##class(HS.Sync.Tracker.Hub).GetHubVersions(.tHubVersions,.tCurrentHubVersion))
		
		#; Abort if hub tracker not setup yet
		Quit:tCurrentHubVersion=""
		
		#; Default minimum version/tx to current
		#; Note all transactions purged until the first slave is registered by the sync mgmt service
		Set tMinVersion = tCurrentHubVersion
		Set tMinTx = $G(^OBJ.JournalT)
		
		#; Get minimum version and last sync'd transaction (via SyncTime) from included slaves
		Set tSQL = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(tSQL.%PrepareClassQuery("HS.Sync.Tracker.Slave","Summary"))
		Set tRS = tSQL.%Execute()
		If tRS.%SQLCODE,tRS.%SQLCODE'=100 $$$ThrowStatus($$$ERROR($$$SQLError,tRS.%SQLCODE,tRS.%Message))
		While tRS.%Next() {
			#; update low transaction based on SyncTime
			Set tSlaveTx = tRS.%Get("LastTx")
			If tSlaveTx<tMinTx Set tMinTx = tSlaveTx

			#; update minimum version based on tracker
			Set tSlaveVersion = +(tRS.%Get("Version"))  // ensure numeric
			Continue:tSlaveVersion<16                   // ignore slaves prior to HS2018.1 (v16)
			Continue:tSlaveVersion>tCurrentHubVersion   // ignore slaves on higher versions
			If tSlaveVersion<tMinVersion Set tMinVersion = tSlaveVersion
		}
		
		#; Try to use prior hub version if min version not found in hub tracker
		#; If there isn't one then purge based on the next available hub version
		#; since those slaves will need to do a full sync anyway
		If '$D(tHubVersions(tMinVersion)) {
			Set tMinVersion=$O(tHubVersions(tMinVersion),-1)
			If tMinVersion="" Set tMinVersion = $O(tHubVersions(""))
		}
		
		#; Use lesser between hub tracker and SyncTime unless all included slaves are on
		#; the same version as the hub (which then uses the lowest SyncTime transaction)
		If tMinVersion'=tCurrentHubVersion {
			If tMinVersion]"",tHubVersions(tMinVersion)<tMinTx Set tMinTx=tHubVersions(tMinVersion)
		}
				
		$$$ThrowOnError(..PurgeTransactions(tMinTx))
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Purge up to and including given transaction
ClassMethod PurgeTransactions(pLastTransaction As %Integer = 0) As %Status [ Internal ]
{
	Set tCurrTx = "" For { Set tCurrTx=$O(^OBJ.JournalT(tCurrTx)) Quit:tCurrTx=""
		Quit:tCurrTx>pLastTransaction
		Set tPtr = "" For { Set tPtr=$O(^OBJ.JournalT(tCurrTx,tPtr),1,tData) Quit:tPtr=""
			Set tGUID = $LG($G(tData),9)
			Kill:tGUID]"" ^OBJ.GUID(0,tGUID,tPtr)
		}
		Kill ^OBJ.JournalT(tCurrTx)
		Kill ^OBJ.Journal(tCurrTx)
	}
	Quit $$$OK
}

ClassMethod SyncMessageFromStream(pInputStream As %Stream.Object, Output pSyncMessage As HS.Message.Sync = {$$$NULLOREF}) As %Status [ Internal ]
{
	#dim eException As %Exception.AbstractException
	
	If ('$IsObject(pInputStream) || (pInputStream.Size = 0)) Quit $$$OK
		
	Try {
		Do pInputStream.Rewind()
		
		Set tReader = ##class(%XML.Reader).%New()
		Set tStatus = tReader.OpenStream(pInputStream)
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)

		Do tReader.Correlate("pResponse", "HS.Message.Sync")
		
		If 'tReader.Next(.pSyncMessage, .tStatus) { Set tStatus = tReader.OpenStream(pInputStream) }
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

ClassMethod Rebuild() As %Status [ Internal, ZenMethod ]
{
	If '..IsSyncSlave() Quit $$$ERROR($$$GeneralError,"Cannot run rebuild on the Hub instance")
	Set tSC=##class(%ZHSLIB.Services.Client).SyncConfiguration(,,,1)
	Quit tSC
}

/// Called during system startup as %ZHSLIB.Client.SyncConfiguration and in HS.Sync.Services
ClassMethod LoadSyncSet(pRequest As HS.Message.Sync, Output pResponse As HS.Message.Sync, pQuiescentTimeout = 15) As %Status [ Internal ]
{
	#dim eException As %Exception.AbstractException
	Set tSC = $$$OK
	Try {
		If '..IsSyncSlave(){
			Set tSC = $$$ERROR($$$GeneralError,"Do not run LoadSyncSet on the hub instance")
			Quit
		}
		Set ^["HSSYS"]ISC.HS.SyncSlave=1
		Set tQuiescent=0
		Set pResponse = ##class(HS.Message.Sync).%New()
		Set pResponse.NetworkName = ##class(HS.Util.Installer.ConfigItem).GetThisComponentName()
		Set pResponse.GetAllTransactions=pRequest.GetAllTransactions
		If pRequest.GetAllTransactions = 1 {
			Set tQuiescent=1
			If pRequest.SyncFile.Size=0 $$$LOGERROR("SyncStream is empty") Set tSC = $$$ERROR($$$GeneralError,"SyncStream is empty") Quit 
			Set tSC = ..QuiesceProductions(1,pQuiescentTimeout)	Quit:$$$ISERR(tSC)
			Do ##class(HS.Sync.Utils).Reset()
		}
		If (pRequest.LastTransaction ] "") {
			Set tFile = ##class(%FileBinaryStream).%New()
			Set tFile.Filename = $ZUtil(12) _ "Temp/" _ pRequest.SystemGUID _ pRequest.SystemNamespace_$tr($ztimestamp,",.","__")
			Set tSC = tFile.CopyFrom(pRequest.SyncFile) Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Set tSC = tFile.%Save() Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			If tFile.Size=0 $$$LOGERROR("File is empty size is 0") Set tSC = $$$ERROR($$$GeneralError,"Sync File is empty, size is 0") Quit 
			Set tSyncSet = ##class(%SYNC.SyncSet).%New(1)
			Set tSC = tSyncSet.Import(tFile.Filename, , , "-d", .errorLog) 
			/*
				Set tDTTM=$tr($zdt($H,3),"- :")
				Do ##class(%File).Rename(tFile.Filename,tFile.Filename_tDTTM)
			*/
			Do ##class(%Library.File).Delete(tFile.Filename)
			/*
			If $$$ISERR(tSC) {
				Set tDTTM=$tr($zdt($H,3),"- :")
				Do ##class(%File).Rename(tFile.Filename,tFile.Filename_tDTTM)
			} Else {
				Do ##class(%Library.File).Delete(tFile.Filename)
			}
			*/
			$$$ThrowOnError(tSC)
			
			// Iterate through Unresolved Objects and keep count of errors
			Set tUnresolvedObject = tSyncSet.UnresolvedFirst() // First item to process
			Set tErrorCount = 0
			
			For {	
				//Set tUnresolvedObject = tUnresolved.GetNext(.tKey) Quit:tKey=""
				Quit:'$IsObject(tUnresolvedObject) // Quit if not a valid object
				
				// Try/Catch here to allow skipping specific errors
				try {
					If $ListGet(tUnresolvedObject.Error)]"" {
						Set tStatus = $ListGet(tUnresolvedObject.Error, 2) 
						If $system.Status.GetErrorText(tStatus)["CLASS DOES NOT EXIST" Quit
						If $system.Status.GetErrorText(tStatus)["METHOD DOES NOT EXIST" Quit
						// Keep tally of errors we are interested in
						Set tErrorCount=$i(tErrorCount)
					}
				} catch {}
				
				// Get next item for processing
				Set tUnresolvedObject = tSyncSet.UnresolvedNext()
			}
			
			// If errors found, throw the error as a status with the count
			If tErrorCount'=0 {
				$$$ThrowStatus($$$ERROR($$$GeneralError,"Unresolved objects count:"_tErrorCount))
			}

			#; Mark as completed on Hub
			Set pResponse.GetAllTransactions = 0
			Set pResponse.SetLastTransaction = 1
			Set pResponse.LastTransaction = pRequest.LastTransaction
			Set %syncGlobal = tSyncSet.GlobalName()
			Set tRemoteSystem = @%syncGlobal@(0)
			Do ##class(%SYNC.SyncTime).SetlTrn($List(tRemoteSystem, 1), $List(tRemoteSystem, 2), $Get(^OBJ.JournalT))
			Do tSyncSet.Clear()
		}
		
		Do ..PurgeTransactions($G(^OBJ.JournalT,0))
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	If $$$ISERR(tSC) && $IsObject(pResponse) Set pResponse.SendStatus=tSC
	#; in case we previously quiesced productions, mark not quiesced if an error, or we are finished
	If $$$ISERR(tSC) || pRequest.GetAllFinished Do ..QuiesceProductions(0)
	If $D(^OBJ.SYNC.1) Merge ^OBJ.SYNC.ERR($H)=^OBJ.SYNC.1
	Quit $$$OK
}

ClassMethod QuiesceProductions(pQuiesce, pQuiescentTimeout = 15) As %Status [ Internal ]
{
	#; a bug in ensemble prevents us from using this prior to 2015.2
	If $system.Version.GetMajor()<2015 || ($system.Version.GetMajor()=2015 && ($system.Version.GetMajor()<2)) Quit $$$OK
	New $namespace
	Set tSC = ##class(HS.Director).GetProductionList(##class(HS.Director).PRODUCTIONSTOPORDER(),.tList)
	If pQuiesce {
		Set tNS="",tAllQuiesed=1
		For {
			Set tNS=$O(tList("NS",tNS)) Quit:tNS=""
			Set $namespace=tNS
			Set tSC=##class(Ens.Job).MakeQuiescent(pQuiescentTimeout,.tQuiescent) 
			If $$$ISERR(tSC) || 'tQuiescent Set tAllQuiesed=0 Quit
		}
	} Else {
		Set tAllQuiesed=0
	}
	#; if there was any sort of problem quiescing or being told to mark not quiescent undo
	If 'tAllQuiesed {
		Set tNS=""
		For {
			Set tNS=$O(tList("NS",tNS)) Quit:tNS=""
			Set $namespace=tNS
			Do ##class(Ens.Job).MakeNotQuiescent()
		}
	}		
	Quit tSC
}

}
