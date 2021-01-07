Include HS.HC

Class HS.Util.SystemAPI Extends HS.Util.SystemAPIMethods
{

/// Needed to check results of SYS.Mirror:MemberStatusList query, which uses $$$TEXT
Parameter DOMAIN = "%Utility";

/// Internal API to create the database here as well as on any other running non-primary mirror members
/// All mirror-aware HealthShare database creation should use this method.
/// For all mirror members currently running, it will wait for them to also create the database.
/// This will also activate the CPF file.
ClassMethod CreateDatabase(pDatabaseName, pDoMirror As %Boolean = 1, pLocation As %String = "") As %Status [ Internal ]
{
	Set tSC=$$$OK
	try {
		Set pDatabaseName=$ZCVT(pDatabaseName,"U")
		If pDatabaseName'="HSSYS",pDatabaseName'="HSCUSTOM" Lock +(^%SYS("HealthShare","CreateDB"),^%SYS("HealthShare","SystemAPI",pDatabaseName))
		If pDatabaseName'?1.UN Set tSC=$$$ERROR($$$GeneralError,"Database Name must only contain letters and numbers") Quit
		Set:pDatabaseName="HSSYS" pDatabaseName="hssys" // the one exception
		If pLocation="" {
			set tMgrDir=$system.Util.ManagerDirectory()
			set tDataDir=##class(%File).NormalizeDirectory(tMgrDir_"/"_pDatabaseName_"/")
			set tDataDirLower=##class(%File).NormalizeDirectory(tMgrDir_"/"_$zcvt(pDatabaseName,"L")_"/")
		} Else {
			Set tDataDir = ##class(%File).NormalizeDirectory(pLocation_"/"_pDatabaseName_"/")
			set tDataDirLower=##class(%File).NormalizeDirectory(pLocation_"/"_$zcvt(pDatabaseName,"L")_"/")
		}
		//quit if the database already exists
		Quit:##class(%File).Exists(tDataDir_$$$DatabaseFilename)
		//handle cases where an existing database, such as ensdemo, has already been created in lower case in a *IX system
		Quit:##class(%File).Exists(tDataDirLower_$$$DatabaseFilename)
		If pDatabaseName="hssys"||(pDatabaseName="HSCUSTOM") Set pDoMirror=0
		//If mirror but not primary, it's an error
		If $system.Mirror.IsMember(),pDoMirror {
			If '$system.Mirror.IsPrimary() Set tSC=$$$ERROR($$$GeneralError,"Create Database Cannot Run on non-primary mirror member") Quit
			If '..MirrorAllUp(.tMemb) Set tSC=$$$ERROR($$$GeneralError,"Mirror Member "_tMemb_" not up.  Create Database Cannot Run") Quit
			If $G(^%SYS("HealthShare","NetworkHostName"))="" Set tSC=$$$ERROR($$$GeneralError,"Network Host Name not configured.  Create Database Cannot Run") Quit
		}
		//create it
		Set tSC=..DoCreateDatabase(pDatabaseName,tDataDir,,pDoMirror) Quit:$$$ISERR(tSC)
		Quit:'pDoMirror
		//record it for logging only
		Set tStep=$G(^%SYS("HealthShare","SystemAPI",pDatabaseName))+1
		Set ^%SYS("HealthShareLocal","SystemAPI",pDatabaseName)=tStep //to locally track what has been done
		Set ^%SYS("HealthShare","SystemAPILogStep",pDatabaseName,##class(%SYS.System).GetUniqueInstanceName(1))=tStep
		Kill ^%SYS("HealthShare","CreateDB")
		Set ^%SYS("HealthShare","SystemAPI",pDatabaseName,tStep,"Args",0)=0
		Set ^%SYS("HealthShare","SystemAPI",pDatabaseName,tStep)=$H_"^CreateDB^"_##class(%SYS.System).GetUniqueInstanceName(1)
		//last logging step - we update the counter
		Set ^%SYS("HealthShare","SystemAPI",pDatabaseName)=tStep
		//get list of other mirror members
		Set tSC=..GetOtherMirroredMembers(.tMembers) Quit:$$$ISERR(tSC)
		Quit:'$D(tMembers)  //no others exist
		Quit:'$system.Mirror.IsMember()
		Do ..SetupPhoneHome()
		//queue up all other members
		Set ^%SYS("HealthShare","CreateDB")=pDatabaseName_"^"_tStep_"^"_pLocation
		For {
			//poll for mirror status
			Set tMemb=""
			For {
				Set tMemb=$O(tMembers(tMemb)) Quit:tMemb=""
				Set tMemberNumber=tMembers(tMemb)
				If ..GetMirrorDBStatus(tMemberNumber,pDatabaseName) Kill tMembers(tMemb)
			}
			IF '$D(tMembers) Kill ^%SYS("HealthShare","CreateDB") Quit
			Set tDBErr=$O(^%SYS("HealthShare","CreateDB","Errors",""),1,tMessage)
			If tDBErr'="" Set tSC=$$$ERROR($$$GeneralError,tMessage) Quit
			Hang 5
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Lock:pDatabaseName'="hssys"&&(pDatabaseName'="HSCUSTOM") -(^%SYS("HealthShare","CreateDB"),^%SYS("HealthShare","SystemAPI",pDatabaseName))
	Quit tSC
}

/// Utiliy API to call in case CreateDatabase is stuck waiting for a mirror member to respond but the member isn't responding
/// If this is used, then the database will need to be created on other mirror members by using the management portal,
/// prior to resuming namespace activation
ClassMethod AbortDatabaseCreation(pMessage As %String)
{
	Set ^%SYS("HealthShare","CreateDB","Errors",0)=pMessage
}

/// Internal API to perform system functions both here, on the primary, as well as on any other
/// mirror members.  All mirror-aware HealthShare calls (except CreateDatabase) should use this method,
/// and not directly call other methods here or system methods.  The calls here are asynchronously
/// queued for other mirror members.
/// CPF file activation will need to be its own call.
/// The method names will all be in a superclass of this class - HS.Util.SystemAPIMethods.
ClassMethod Invoke(pMethodName, pApplicableDatabase = "%", pArgs...) As %Status [ Internal ]
{
	//can't set into or lock ^%SYS("HealthShare") on non primary mirror member - will cause protect error
	Set tMirrorOK=1
	If $system.Mirror.IsMember(),'$system.Mirror.IsPrimary() Set tMirrorOK=0
	Set tSC=$$$OK
	//this shouldn't run while there's a CreateDatabase in progress
	If tMirrorOK Lock +^%SYS("HealthShare","CreateDB") Kill ^%SYS("HealthShare","CreateDB") Lock -^%SYS("HealthShare","CreateDB")
	If pApplicableDatabase'="%" Set pApplicableDatabase=$TR(pApplicableDatabase,"%-_","pdu")
	Set pApplicableDatabase=$ZCVT(pApplicableDatabase,"U")
	Lock:tMirrorOK +^%SYS("HealthShare","SystemAPI",pApplicableDatabase)
	try {
		Do:tMirrorOK ..SetupPhoneHome()
		For tI=1:1:+$G(pArgs) {
			Continue:'$D(pArgs(tI))  //allow for missing argument
			Set tVal=pArgs(tI)
			If $IsObject(tVal),tVal.%Extends("%Stream.Object") {
				Set tArgsLog(tI)="stream"
				Do tVal.Rewind()
				Set tArgsLog(tI,"Value")=tVal.Read(999999999)
			} Else {
				Set tArgsLog(tI)=""
				Set tArgsLog(tI,"Value")=tVal
			}
		}
		//next, invoke the method here,  If this fails, we won't store it
		Try {
			Set tResponse=$ClassMethod(,pMethodName,pArgs...)
			Set tSC=tResponse Quit:$$$ISERR(tSC)
		} Catch ex {
			Set tSC = ex.AsStatus() Quit
		}

		// The Invoke API should still work on a non-primary mirror member, but it should not
		// queue up changes for other mirror members
		If $system.Mirror.IsMember(),'$system.Mirror.IsPrimary() Quit
		
		Set tStep=$G(^%SYS("HealthShare","SystemAPI",pApplicableDatabase))+1
		Set ^%SYS("HealthShareLocal","SystemAPI",pApplicableDatabase)=tStep //to locally track what has been done
		Set ^%SYS("HealthShare","SystemAPILogStep",pApplicableDatabase,##class(%SYS.System).GetUniqueInstanceName(1))=tStep
		//Now, store this in the log queue for other mirror members
		Merge ^%SYS("HealthShare","SystemAPI",pApplicableDatabase,tStep,"Args")=tArgsLog
		Set ^%SYS("HealthShare","SystemAPI",pApplicableDatabase,tStep,"Args",0)=+$G(pArgs)
		Set ^%SYS("HealthShare","SystemAPI",pApplicableDatabase,tStep)=$H_"^"_pMethodName_"^"_##class(%SYS.System).GetUniqueInstanceName(1)
		//at the end, we update the counter
		Set ^%SYS("HealthShare","SystemAPI",pApplicableDatabase)=tStep
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Lock:tMirrorOK -^%SYS("HealthShare","SystemAPI",pApplicableDatabase)
	Quit tSC
}

ClassMethod DoCreateDatabase(pDatabaseName, pDir = "", pResource = "", pDoMirror As %Boolean = 1) As %Status [ Internal ]
{
	Set tSC=$$$OK
	New $Namespace Set $Namespace="%SYS"
	try {
		Set tDBName = pDatabaseName
		set:pResource="" pResource="%DB_"_$ZCVT(tDBName,"U")
		If pDir="" {
			set tMgrDir=$system.Util.ManagerDirectory()
			set pDir=##class(%File).NormalizeDirectory(tMgrDir_"/"_pDatabaseName)
		}
		Quit:##class(%File).Exists(pDir_$$$DatabaseFilename)
		if '##class(%File).DirectoryExists(pDir) {
			if '##class(%File).CreateDirectoryChain(pDir,.tErr) Set tSC=$$$ERROR($$$GeneralError,"Error "_$G(tErr)_" Creating Directory "_pDir) Quit
		}
		Set tMirrorName=$LG($SYSTEM.Mirror.GetMirrorNames())
		Set tMirrorDB=$S(tMirrorName="":"",1:pDatabaseName)
		If 'pDoMirror Set tMirrorName="",tMirrorDB=""
		Set tSC=##class(SYS.Database).CreateDatabase(pDir,/*size*/,/*blocksize*/,/*encrypted*/,pResource,"",tMirrorDB,tMirrorName)
		Quit:$$$ISERR(tSC)
		if '##class(%File).Exists(pDir_$$$DatabaseFilename) throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$DatabaseNotThere))
	 	if '##Class(Config.Databases).Exists(pDatabaseName) {
			kill p set p("Directory")=pDir
			set tSC=##Class(Config.Databases).Create(pDatabaseName,.p) Quit:$$$ISERR(tSC)
			// Create the database resource, which will also create the role
			If ##class(Security.Resources).Exists(pResource,.tObjResource,.tSC) || '$IsObject($G(tObjResource)) {
				Set tDescription = "The "_$P(pResource,"%DB_",2)_" database"
				Set tSC = ##class(Security.Resources).Create(pResource,tDescription,"",3)
			}
			//set tSC = ##class(%EnsembleMgr).assignResourceToDB(pResource,pDir,"") Quit:$$$ISERR(tSC)
	 	}
		Set tSC=..ActivateConfiguration("HSSYS")
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// If we're mirrored, and any other member is down, return 0
/// Otherwise, return 1
ClassMethod MirrorAllUp(Output pMember) As %Boolean [ Internal ]
{
	Set tUp=1
	New $Namespace Set $Namespace="%SYS"
	Set tAsyncText=$$$Text("Async"),tActiveText=$$$Text("Active")
	Try {
		Quit:'$system.Mirror.IsMember()
		Set tMirrorName=$LG($SYSTEM.Mirror.GetMirrorNames())
		Set tMe=$LG($G(^SYS("MIRRORSET",tMirrorName,"Member",0)))
		Set tRS = ##class(%ResultSet).%New("SYS.Mirror:MemberStatusList")
		Do tRS.Execute(tMirrorName)
		While tRS.Next() {
			Continue:tRS.Data("MemberName")=tMe
			//workaround bug in MemberStatusList query - it is supposed to return 'Async' or 'Active'
			//but for now returns $$$Text(the status)
			Continue:tRS.Data("CurrentStatus")=tActiveText||(tRS.Data("CurrentStatus")="Active")
			Continue:tRS.Data("CurrentStatus")=tAsyncText||(tRS.Data("CurrentStatus")="Async")
			Set tUp=0,pMember=tRS.Data("MemberName") Quit
		}
	} Catch ex {
		Set tUp=0
	}
	Quit tUp
}

/// Returns an array of active mirror members (other than this one),
/// as pMemberArray(membername)=currentMember#
ClassMethod GetOtherMirroredMembers(Output pMemberArray) As %Status [ Internal ]
{
	Kill pMemberArray
	Set tSC=$$$OK
	New $Namespace Set $Namespace="%SYS"
	Try {
		Quit:'$system.Mirror.IsMember()
		Set tMirrorName=$LG($SYSTEM.Mirror.GetMirrorNames())
		Set tMe=$LG($G(^SYS("MIRRORSET",tMirrorName,"Member",0)))
		Set tRS = ##class(%ResultSet).%New("SYS.Mirror:MemberStatusList")
		Do tRS.Execute(tMirrorName)
		While tRS.Next() {
			Set tMembName=tRS.Data("MemberName")
			Continue:tMembName=tMe
			Set tID="",tI=""
			For {Set tI=$O(^SYS("MIRRORSET",tMirrorName,"Member",tI)) Quit:tI=""
				If $LG(^SYS("MIRRORSET",tMirrorName,"Member",tI))=tMembName Set tID=tI Quit
			}
			Set pMemberArray(tMembName)=tID
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Returns true if pDatabase exists on pMemberNum
ClassMethod GetMirrorDBStatus(pMemberNum, pDatabase) As %Boolean [ Internal ]
{
	Set tUp=0
	New $Namespace Set $Namespace="%SYS"
	Try {
		Set tMirrorName=$LG($SYSTEM.Mirror.GetMirrorNames())
		Set tDBStatus=$$GetDBList^MIRRORCTL(tMirrorName,pMemberNum)
		Quit:$LG(tDBStatus)'="OK"
		For tI=2:1:$LL(tDBStatus) {
			Set tDBStuff=$LG(tDBStatus,tI),tDBStuff=$P(tDBStuff,"^",2)
			Continue:$P(tDBStuff,":",$L(tDBStuff,":"))'=pDatabase
			Set tUp=1 Quit
		}
	} Catch ex {
		//
	}
	Quit tUp
}

ClassMethod SetupPhoneHome() [ Internal ]
{
	Try {
		Do ##class(%RoutineMgr).GetWebServerPort(.tPort,,.tUrlPrefix)
		New $Namespace
		Set $Namespace="HSSYS"
		Set ^%SYS("HealthShare","MirrorPrimaryPort")=tPort,^("MirrorPrimaryUrlPrefix")=tUrlPrefix
	} Catch ex {
		//During initial install, HSSYS won't be there, and this isn't needed
	}
}

}
