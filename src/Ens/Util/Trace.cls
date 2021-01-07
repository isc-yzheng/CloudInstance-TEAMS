/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (%occInclude, Ensemble)

Class Ens.Util.Trace [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

ClassMethod SetTraceDevice(pDevice As %String = "") As %Status
{
	If $Data($$$EnsJobStatus($$$SystemName,$Job))=0 Quit $$$ERROR($$$EnsErrGeneral,"Can not set trace device in a non-Interoperability job.")
	Set tTraceDevice=$S($ZCVT(pDevice,"L")["nul":"", 1:pDevice), $$$JobTraceDevice=tTraceDevice
	Set tJobConfigName=$$$JobConfigName  Set tLogTrace=$S(""=tJobConfigName:0, 1:$G($$$ConfigTrace(tJobConfigName),0))
	Set $$$EnsJobLocal("DoTrace") = (tLogTrace || (""'=tTraceDevice))
	Set x=$$$EnsMirrorIndexInc ; force new call to SetTraceOptimizer()
	$$$catTRACE("mirror","Updated mirror index to #"_$$$EnsMirrorIndex_" to trigger Trace device optimizer")
	Quit $$$OK
}

ClassMethod SetTraceOptimizer(pConfigName As %String)
{
	Set tJobConfigName=$S(""'=$G(pConfigName):pConfigName,1:$$$JobConfigName), tLogTrace=$G($$$ConfigTrace(tJobConfigName),0)
	Set $$$EnsJobLocal("LogSystemTrace")=tLogTrace
	Set tTraceDevice=$G($$$JobTraceDevice,0)
	Set $$$EnsJobLocal("DoTrace") = $S(tLogTrace:1, (0'=tTraceDevice):(""'=tTraceDevice), 1:$$$IsTerminalDevice($IO))
	Set nBankCfg=$$$EnsMsgBankIndex  If nBankCfg'=$G($$$EnsJobLocal("ArchiveFlags",tJobConfigName,"iCfg")) {
		#; init archive flags once per job and active host after each config change
		$$$catTRACE("BankCfg","Setting update #"_nBankCfg_" of local MsgBank config archive flags for host '"_tJobConfigName_"'")
		Set $$$EnsJobLocal("ArchiveFlags",tJobConfigName,"iCfg")=nBankCfg
		Do ##class(Ens.Enterprise.MsgBankOperation).InitArchiveFlags(tJobConfigName)
		Set:$D($$$EnsJobLocal("ArchiveFlags"),tFlags)#2 $$$EnsJobLocal("ArchiveFlags",tJobConfigName)=tFlags
	} Else  {
		Set:$D($$$EnsJobLocal("ArchiveFlags",tJobConfigName),tFlags)#2 $$$EnsJobLocal("ArchiveFlags")=tFlags
	}
}

ClassMethod DoTrace()
{
	Set tJobConfigName=$$$JobConfigName
	Quit $G($$$ConfigTrace(tJobConfigName),0)||(""'=$G($$$JobTraceDevice))||$$$IsTerminalDevice($IO)
}

ClassMethod WriteTrace(pTraceCategory As %String, pSourceClass, pSourceMethod, pMessage)
{
	#; we are never called for non-user messages unless they are getting displayed or logged.
	Set tJobConfigName=$$$JobConfigName  Set:""=tJobConfigName tJobConfigName="%Production"

	If $D($$$EnsJobLocal("Debug")) {
		Set tShowCat=$G($$$EnsDebug("TraceCat",tJobConfigName,pTraceCategory)
					,$G($$$EnsDebug("TraceCat",tJobConfigName)
					,$G($$$EnsDebug("TraceCat",pTraceCategory)
					,$G($$$EnsDebug("TraceCat")
					,$Case(pTraceCategory,"user":1,"nolog":1,:0)))))
	} Else {
		Set tShowCat=$G(^Ens.Debug("TraceCat",tJobConfigName,pTraceCategory)
					,$G(^Ens.Debug("TraceCat",tJobConfigName)
					,$G(^Ens.Debug("TraceCat",pTraceCategory)
					,$G(^Ens.Debug("TraceCat")
					,$Case(pTraceCategory,"user":1,"nolog":1,:0)))))
	}
	Set tLog=(tShowCat && ("nolog"'=pTraceCategory) && $G($$$EnsJobLocal("LogSystemTrace"),$G($$$ConfigTrace(tJobConfigName),0)))
	Set:pTraceCategory="system" pTraceCategory=""
	Do:tLog ##class(Ens.Util.Log).LogTrace(pSourceClass,pSourceMethod,$G(pMessage),pTraceCategory)

	Quit:'tShowCat
	Quit:$g(%QUIET)
	
	Set tIO=$IO, tTraceDevice=$G($$$JobTraceDevice,0)
	Quit:$S((0'=tTraceDevice):(""=tTraceDevice), 1:'$$$IsTerminalDevice($IO))
	
	#;  format a $$$TRACE() message
	Use:""'=tTraceDevice tTraceDevice
	Set str=$P($$$timeLocal," ",2)
	Set str=$P(str,".",1)_"."_$e($p(str,".",2)_"000",1,3)
	Set str=$TR($Justify(str,12)," ","0")
	Set str=str_":"_..trail(pSourceClass,20)_": "_$G(pMessage)
	If '$$$IsdefObject(%response) { Write !,str }
	Else { Write !,$ZCVT(str,"O","HTML")  Do %response.Flush() }
	Use:""'=tTraceDevice tIO
}

/// Get the stack trace at the point of the last error
ClassMethod GetErrorTrace(pIgnoreTop As %Integer = 0) As %List
{
	#dim tStack, tRef, tCode As %String = ""
	#dim tLevel As %Integer

	#dim tFoundECODE As %Boolean = ($ECODE="")
	#;If there is a $ECODE then we ignore pIgnoreTop 
	#dim tIgnored As %Integer = $S(tFoundECODE:-1,1:pIgnoreTop)

	For tLevel=$STACK(-1):-1:1 {
		If tFoundECODE {
			If tIgnored < pIgnoreTop {
				// Ignore topmost elements
				Set tIgnored = tIgnored + 1
				Continue
			}
		} Else {
			If $STACK(tLevel,"ECODE")'="",$ECODE[$STACK(tLevel,"ECODE") {
				Set tFoundECODE = 1
			} Else {
				Continue
			}
		}
		Set tRef = $STACK(tLevel)_"^"_$STACK(tLevel,"PLACE")
		Set tCode = $STACK(tLevel,"MCODE")

		// Note: tCode is nice, but really too long ...
		Set tStack = tStack _ $LB(tRef_":")
	}
	
	Quit tStack
}

/// Retrieve the current stack trace
ClassMethod GetStackTrace(pIgnoreTop As %Integer = 0) As %List
{
	Set tStack = ""
	Set tIgnored = -1
	
	For tLevel=$ZU(41):-1:1 {
		Set tInfo = $ZU(41,tLevel)
		Set tType = $P(tInfo,"^")
		Set tFlag = $P(tInfo,"^",4)
		If tFlag > 0 {
			If tIgnored < pIgnoreTop {
				// Ignore topmost elements
				Set tIgnored = tIgnored + 1
				Continue
			}
			Set tRef = $P(tInfo,"^",2,3)
			Set tCode = $ZSTRIP($P(tInfo,"^",5,$L(tInfo,"^")),"<>W")
			
			// Note: tCode is nice, but really too long ...
			Set tStack = tStack _ $LB(tRef_":")
		}
	}
	
	Quit tStack
}

ClassMethod trail(string, width)
{
	Set len=$l(string)
	If len'>width Quit string
	Quit "..."_$e(string,len-width+4,len)
}

}
