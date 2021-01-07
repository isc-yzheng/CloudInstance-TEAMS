ROUTINE HS.Test [Type=INC]
#include HS.HC
#; Session
#def1arg HSTestSession(%key)	 	 %session(%key)
#define	 HSTestSessionKill			 Kill %session
#define  HSTestSessionNext(%key) $O(%session(%key))

#; get patient MPI id that we will use to query
#define HSDefaultPatientID(%tScript,%tErrors) If '$isObject(%tScript.Patient.MPI) { Do ##class(HS.Test.IHE.PIXv3.Manager.QueryPatient).Run("QueryPatient1",.%tResults) If %tResults.Errors.Count() {Do:$isObject(%tErrors) %tErrors.logError("HSTest","Error","Unable to locate patient")} Else {Set %tScript.Patient.MPI = $$$HSTestSession("QueryPatient1").Patient.MPI}}

#; Enable debugging messages when run from terminal session
#; =1 for trace, =2 for debugging
#define HSTestDebugGlobal			^CacheTemp.HSTestDebug
#define HSTestDebugLocal			%HSTestDebug
#define HSTestDebugging				$s($d($$$HSTestDebugLocal):$$$HSTestDebugLocal,$d($$$HSTestDebugGlobal,$$$HSTestDebugLocal)#2=1:$$$HSTestDebugLocal,1:0)

#; Tracing, intended for test scripts and less verbosity
#def1arg HSTestWrite(%args) 	Write !,$J("",$G($$$HSTestSession("_indent"))),$$$FormatText(%args)
#def1arg HSTestTrace(%args)     If $$$HSTestDebugging $$$HSTestWrite(%args)
#def1arg HSTestTraceIn(%args)   If $$$HSTestDebugging $$$HSTestWrite("**"_$$$CurrentClass_":"_$$$CurrentMethod_" - "_%args) Set %=$i($$$HSTestSession("_indent"),2) 
#def1arg HSTestTraceOut         If $$$HSTestDebugging Set %=$i($$$HSTestSession("_indent"),-2)
#define  HSTestTraceObject(%o)  If $$$HSTestDebugging $$$HSTestWrite(##quote(%o)) Do ##class(HS.Test.Util).xmlDump($g(%o))
#define  HSTestTraceStream(%s)  If $$$HSTestDebugging $$$HSTestWrite(##quote(%s)) Do ##class(HS.Test.Util).xmlDumpStream($g(%s))
#def1arg HSTestTraceVars(%args) If $$$HSTestDebugging zw %args

#; Debugging, intented for framework and more verbosity
#def1arg HSTestDebug(%args)     If $$$HSTestDebugging=2 $$$HSTestWrite(%args)
#def1arg HSTestDebugIn(%args)   If $$$HSTestDebugging=2 $$$HSTestWrite("**"_$$$CurrentClass_":"_$$$CurrentMethod_" - "_%args) Set %=$i($$$HSTestSession("_indent"),2) 
#def1arg HSTestDebugOut         If $$$HSTestDebugging=2 Set %=$i($$$HSTestSession("_indent"),-2)
#define  HSTestDebugObject(%o)  If $$$HSTestDebugging=2 $$$HSTestWrite(##quote(%o)) Do ##class(HS.Test.Util).xmlDump($g(%o))
#define  HSTestDebugStream(%s)  If $$$HSTestDebugging=2 $$$HSTestWrite(##quote(%s)) Do ##class(HS.Test.Util).xmlDumpStream($g(%s))
#def1arg HSTestDebugVars(%args) If $$$HSTestDebugging=2 zw %args

#; Allow some tests to be skipped (like those depending on 3rd party tools)
#define	HSTestSkipUnless(%type) If '..Manager.UserFields.GetAt(%type) Do $$$LogMessage("Test type '"_%type_"' skipped") Quit
#define LogResults(%sc,%results) ..LogResults($g(%sc,$$$OK),$g(%results))
#define LogResultsWithExceptions(%sc,%results,%exceptions) ..LogResults($g(%sc,$$$OK),$g(%results),$g(%exceptions))
#define AssertSuccess(%sc,%script,%errors) $$$AssertStatusOK(..LogResults($g(%sc,$$$OK),$g(%errors),%script.ExpectedErrors),%script.Key)

#; Shortcuts
#define HSTestXData(%key) "xdata://"_..%ClassName(1)_":"_%key
#define	GetClone(%obj,%key)  Set %obj = ..GetClone(%key, .tSC) If $$$ISERR(tSC) Quit:'$$$AssertStatusOK(tSC,"Clone: "_%key)
#define GetObject(%obj,%key) Set %obj = ..GetObject(%key, .tSC) If $$$ISERR(tSC) Quit:'$$$AssertStatusOK(tSC,"Object: "_%key)
#define HSTestFail(%msg) Quit:$$$AssertTrue(0,%msg)
#;
#define	HSTestBailout If ..Manager.UserFields.GetAt("BailOut") Do $$$LogMessage("BailOut set, test skipped") Quit
#def1arg HSTestAssertTrueOrBail(%args)	$$$HSLogSessionID If '$$$AssertTrue(%args) {Do ..Manager.UserFields.SetAt(1,"BailOut") Quit}
#define HSLogSessionID Do $$$LogMessage("Session: "_##class(HS.HC.Test.TestCase).GetLastEnsembleSessionID())