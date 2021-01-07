Include (HS.HC, HS.Test)

/// HealthShare aware %UnitTest framework that is class driven instead of file driven.
/// <p>
/// Differences from the <class>%UnitTest.Manager</class>:
/// <ul>
/// <li>Test cases extend <class>HS.Test.TestCase</class>
/// <li>Test cases are not loaded or deleted. They exist as classes under the <class>HS.Test</class> package.
/// <li>Test case methods are executed in the order defined in the class, not alphabetically.
/// <li>Instead of a directory, the first piece of <var>testspec</var> is a package name.
/// <li>In addition to a full class name, the second piece of <var>testspec</var> can be a simple class name that will assume the package from the first piece.
/// <li>Test case classes are able to be run independently from the framework for debugging during development.
/// <li>Test case classes can maintain state between test methods.
/// <li>Test case classes are intended to call eachother. See <class>HS.Test.TestCase</class> for more details.
/// <li>Changes the report to a new URL that is aware of method invocation sequencing change.
/// </ul>
/// 
/// A test suite (a collection of all <class>HS.Test.TestCase</class> descendants of a package) can be run from the command line:
/// <example>
/// Do ##class(HS.Test.Manager).RunTest("HS.Test.IHE.PIXv3")
/// </example>
/// 
/// To run only the direct descendants (siblings) of a package:
/// <example>
/// Do ##class(HS.Test.Manager).RunTest("HS.Test.IHE.PIXv3","/norecursive")
/// </example>
/// 
/// Or, with debugging, which will <code>break</code> on the first error:
/// <example>
/// Do ##class(HS.Test.Manager).RunTest("HS.Test.IHE.PIXv3","/debug")
/// </example>
/// 
/// A test case (a single <class>HS.Test.TestCase</class> class) can be run in two different ways:
/// <example>
/// Do ##class(HS.Test.Manager).RunTest("HS.Test.IHE.PIXv3:Consumer")
/// Do ##class(HS.Test.IHE.PIXv3.Consumer).Run()
/// </example>
/// 
/// A test method can be run in two differnt ways as well:
/// <example>
/// Do ##class(HS.Test.Manager).RunTest("HS.Test.IHE.PIXv3:Consumer:TestRevisePatient")
/// Do ##class(HS.Test.IHE.PIXv3.Consumer).Run("TestRevisePatient")
/// </example>
/// 
/// To run a single method without the overhead/output of the framework, call the corresponding classmethod directly:
/// <example>
/// Do ##class(HS.Test.IHE.PIXv3.Consumer).RevisePatient("Patient1")
/// </example>
/// 
/// Methods can belong to "core", "errors" or "external" groups and selectively run as a group:
/// <example>
/// Method TestWidget() { 
///  If '..Manager.UserFields.GetAt("core") Quit
///  //do the normal test here
/// }
/// Method TestInvalidWidget() {
///  If '..Manager.UserFields.GetAt("errors") Quit
///  //do the error condition test here
/// }
/// Method TestExternalWidget() {
///  If '..Manager.UserFields.GetAt("external") Quit
///  //do the external condition test here
/// }
/// 
/// Do ##class(HS.Test.Manager).RunTest("HS.Test.IHE",,"/errors=0")
/// </example>
Class HS.Test.Manager Extends %UnitTest.Manager
{

/// Alias for RunTest method
ClassMethod Run(testspec As %String, qspec As %String, userparam) As %Status
{
	Quit ..RunTest(.testspec,.qspec,.userparam)
}

/// Override : Force manditory /noload and /nodelete flags
/// <p>testspec : Now <package>:<class>:<method>
/// <p>userparam: Top node looks like qspec and will be parsed and added to UserFields
/// <pre>
/// /package=<package name>: overrides the data package. Default is HS.Test.Data
/// /core=[0|1]: indicates if normal tests should be run. Default is 1
/// /errors=[0|1]: indicates if tests for error conditions should be run. Default is 1
/// /external=[0|1]: indicates if external (such as NIST) tests should be run. Default is 0 since 3rd party tools may be required
/// </pre>
/// 
ClassMethod RunTest(testspec As %String, qspec As %String, userparam) As %Status
{
	#; Add userparam defaults
	Set userparam("core")=1
	Set userparam("errors")=1
	Set userparam("external")=0
	Set userparam("package")="HS.Test.Data"
	If $G(userparam)["/" {
		For i=1:1:$L(userparam,"/") {
			Set tPiece=$P(userparam,"/",i) Continue:tPiece=""
			Set tKey=$p(tPiece,"=",1)
			Set tVal=$p(tPiece,"=",2)
			If tKey]"" Set userparam(tKey)=tVal
		}
	}

	#; Initialize the session
	$$$HSTestSessionKill
	Set $$$HSTestSession("package") = userparam("package")
	
	#; Run the test
	Set sc=..RunTestSuites($g(testspec),$G(qspec)_"/noload/nodelete",.userparam)
	If $$$ISERR(sc) Do $system.Status.DisplayError(sc)

	#; clear the session	
	$$$HSTestSessionKill
	Quit sc
}

/// Override: Not supported - files are not loaded
ClassMethod DebugLoadTestSuite(testsuite As %String = "", qspec As %String = "") As %Status
{
	Quit $$$ERROR($$$FeatureNotSupported)
}

/// Override: Not needed - use Run() from a HS.Test.TestCase subclass instead
ClassMethod DebugRunTestCase(testsuite As %String = "", testcase As %String = "", qspec As %String = "", testmethod As %String = "") As %Status
{
	Quit $$$ERROR($$$FeatureNotSupported)
}

/// Override: Loop over class heirarchy rather than directories.
ClassMethod RunTestSuites(testspec As %String, qspec, userparam) As %Status
{
	Set manager = ..%New()
	If manager=$$$NULLOREF Quit %objlasterror
	;
	Set sc=$$$qualifierParse("UnitTest",.qspec,.qstruct) q:$$$ISERR(sc) sc
	;
	Set manager.Debug=$$$qualifierGetValue(qstruct,"debug")
	Set manager.Display=$s($$$qualifierGetValue(qstruct,"displaylog"):"log",1:"")_","_$s($$$qualifierGetValue(qstruct,"displayerror"):"error",1:"")
	Set manager.UserParam=$g(userparam)
	Set key="" For  Set key=$o(userparam(key)) Quit:key=""  do manager.UserFields.SetAt($g(userparam(key)),key)
	;
	Set package = $p(testspec,":") If package="" Quit $$$ERROR(5001,"Package required")
	Set getspec= $S($$$qualifierGetValue(qstruct,"recursive"):"/includesubpackages",1:"/noincludesubpackages")
	Do $SYSTEM.OBJ.GetPackageList(.classes, package, getspec) 
	Set class="" For { Set class=$o(classes(class)) Quit:class=""  
		If '$$issubclassof^%occCompile(class,"HS.HC.Test.TestCase") Continue
		If $$$comClassKeyGet(class,$$$cCLASSabstract) {
			Kill classes(class)
			Continue
		}
		Set tDepends = $parameter(class,"RunAfter")
		For i=1:1:$L(tDepends,",") {
			Set tAfter = $P(tDepends,",",i)
			If tAfter]"", $D(classes(tAfter)) {  
				Set classes(class,tAfter)=""
			}	
		}
	}
	Set sc = ..Resolve(.classes,.sorted) Quit:$$$ISERR(sc) sc
	;
	Set zhBegin=$zh
	;
	Set sort="" For { Set sort=$O(sorted(sort)) Quit:sort=""
		Set class="" For { Set class=$O(sorted(sort,class)) Quit:class=""
			Do manager.RunOneTestSuite(class,class,testspec,.qstruct)
		}
	}
	;
	Do manager.SaveResult($zh-zhBegin)
	;
	Set manager.Display="log,error"
	If $$$qualifierGetValue(qstruct,"run") Do manager.PrintURL()
	;
	Quit $$$OK
}

/// Override: Skip loading/deleting classes from files. Now there is a 1:1 correspondance between suite and test-case for sequencing
Method RunOneTestSuite(dir As %String, suite As %String, testspec As %String, qstruct)
{
	Set testcase=$p(testspec,":",2)
	If testcase="" Set testcase=dir i 1
	Else  If testcase'["." Set testcase=$tr($p(testspec,":",1,2),":",".")
	If dir'=testcase Quit
	If '$$issubclassof^%occCompile(testcase,"HS.HC.Test.TestCase") Quit
	Set testmethod=$P(testspec,":",3)
	;
	Do ..PrintLine("===============================================================================",0)
	Do ..PrintLine("Class: "_testcase,0)
	Do ..PrintLine("===============================================================================",0)
	;
	Do ..LogStateBegin(suite) Do  Do ..LogStateEnd($zh-zhsBegin)
	. ;
	. Set zhsBegin=$zh
	. Set flags="ck/nodisplay"
	. If ..Display["log" Set flags=flags_"/display=log"
	. If ..Display["error" Set flags=flags_"/display=error"
	. Set sc=$$$OK
	. ;
	. If $$$qualifierGetValue(qstruct,"run")=0 Do ..PrintLine("Skipping running testsuite "_suite,1)
	. Else  Do ..RunOneTestCase(suite,testcase,testmethod)
	. ;
	. Set sc=$$$OK
	;
	Do ..PrintLine("",0)
	Set ..CurrentDir=""
	;
	Quit
}

/// Override: Run methods in order of definition, not alphabetical
Method RunOneTestCase(suite As %String, class As %String, test As %String = "")
{
	New
	Do ..LogStateBegin(suite,class) Do  Do ..LogStateEnd(zhcDuration)
	. Set $$$EnsJobLocal("DoTrace") = 0 //turn off trace for the transformer
	. Set testcase=$classmethod(class,"%New",$this)
	. Set testcase.Debug=..Debug
	. Set sc=testcase.OnBeforeAllTests() If $$$ISERR(sc) Do ..LogStateStatus(sc,"OnBeforeAllTests") Set zhcDuration=0 Quit
	. Set zhcBegin=$zh
	. Set methods=""
	. Set method="" For  Set method=$$$comMemberNext(class,$$$cCLASSmethod,method) q:method=""  If $e(method,1,4)="Test" Do
	. . Set seq = $$$defMemberKeyGet(class,$$$cCLASSmethod,method,$$$cMETHsequencenumber)
	. . if seq>0 set methods(seq) = method
	. set tFoundMethod=0
	. Set seq="" For  Set seq=$o(methods(seq),1,method) q:seq=""  Do  
  . . if test]"",method'=test quit
	. . set tFoundMethod=1
	. . Do ..LogStateBegin(suite,class,method) Do  Do ..LogStateEnd(zhmDuration)
	. . . Set success=0
	. . . Set sc=testcase.OnBeforeOneTest(method) If $$$ISERR(sc) || (testcase.SkipTest) Do ..LogStateStatus(sc,"OnBeforeOneTest") Set zhmDuration=0 Quit
	. . . If '..Debug Set $zt="MethError"
	. . . Set zhmBegin=$zh Do $method(testcase,method) Set zhmDuration=$zh-zhmBegin
	. . . Do ..LogMessage("Duration of execution: "_zhmDuration_" sec.")
	. . . Set sc=testcase.OnAfterOneTest(method) If $$$ISERR(sc) Do ..LogStateStatus(sc,"OnAfterOneTest") Quit
	. . . If $$$HSTestDebugging=2 Do  ;dump the session
	. . . . $$$HSTestWrite("session() after "_testcase_"::"_method)
	. . . . Set tKey="" For  Set tKey=$$$HSTestSessionNext(tKey) Quit:tKey=""  Do  ;
	. . . . . Set tItem = $G($$$HSTestSession(tKey))
	. . . . . $$$HSTestWrite("session("_tKey_")="_tItem)
	. . . . . If $IsObject(tItem) Do  ;
	. . . . . . If tItem.%Extends("%XML.Adaptor") Do ##class(HS.Test.Util).xmlDump(tItem) If 1
	. . . . . . Else  If tItem.%Extends("%Stream.Object") Do ##class(HS.Test.Util).xmlDumpStream(tItem)
	. . . Quit
MethError . . . Set $ZT=""
	. . . Set zhmDuration=$zh-zhmBegin Do ..LogStateStatus($$$ERROR($$$ObjectScriptError,$ze),method)
	. . . Set testcase.SkipTest = 0 
	. . . Quit
	. If tFoundMethod=0,test'="" Do ..LogStateStatus($$$ERROR($$$GeneralError,"TestMethod '"_test_"' does not exist in TestCase '"_class_"'."),"RunOneTestCase")
	. Set zhcDuration=$zh-zhcBegin
	. Set sc=testcase.OnAfterAllTests() If $$$ISERR(sc) Do ..LogStateStatus(sc,"OnAfterAllTests") Quit
	. Kill testcase
	;
	Quit
}

/// Override: Use HS.Test aware report page
Method PrintURL()
{
	Set h=$ZCVT($$$HSNetworkHostName,"L")
	Set s = ##class(%RoutineMgr).GetWebServerPort(.p, .h, .up, .url)
	If ($$$ISERR(s)) || ($G(url)="") Set url = "http://127.0.0.1:57772/"
	Do ..PrintLine("Use the following URL to view the result:")
	Do ..PrintLine(url_"csp/sys/%25UnitTest.Portal.Indices.cls?$NAMESPACE="_$ZConvert($namespace,"O","URL")_"&Index="_i%LogIndex)
	Quit
}

/// Log a message as an error
Method LogError(message)
{
	Set testsuite=i%TheStack(i%TheStack,"suite")
	Set testcase=i%TheStack(i%TheStack,"case")
	Set testmethod=i%TheStack(i%TheStack,"method")
	If testmethod="" Quit
	Set next=$o(^||TempLog(i%TempLogIndex,testsuite,testcase,testmethod,""),-1)+1
	Set ^||TempLog(i%TempLogIndex,testsuite,testcase,testmethod,next)=$lb(0,"LogError",$g(message))
	Do ..PrintLine("LogError:"_$g(message),4)
	Quit
}

/// Given an input array of items, return a sorted list based on dependencies
/// tInput(<item>[,<dependency>])=""
/// tOutput(<sortkey>,<item>)=""
/// Returns an error if a circular dependency is found
ClassMethod Resolve(ByRef pInput, ByRef pOutput) As %Status
{
  Set tSC = $$$OK
  Try {
    #; Put all independant items at 0, others at 1
    Set tItem=""
    For { Set tItem=$O(pInput(tItem)) Quit:tItem=""
      Merge pOutput($D(pInput(tItem))\10,tItem)=pInput(tItem)
    }
    
    For tSort=1:1 {
      #; If there are no nodes at this sort level then resolution is complete
      If '$D(pOutput(tSort)) Quit

      Set tItem=""
      #; Loop over dependents, removing any resolved dependant items
      For { Set tItem=$O(pOutput(tSort,tItem)) Quit:tItem=""
        For i=0:1:(tSort-1) {
          Set tParent=""
          For { Set tParent=$o(pOutput(i,tParent)) Quit:tParent=""
            Kill pOutput(tSort,tItem,tParent)
          }
        }
        If $D(pOutput(tSort,tItem))\10 {
          #; if there are still dependants, move to the next sort level
          Merge pOutput(tSort+1,tItem)=pOutput(tSort,tItem)
          Kill pOutput(tSort,tItem)
        } Else {
          #; Else set the node incase caller didn't 
          Set pOutput(tSort,tItem)=""
        }
      }
      #; If there are no nodes at current sort level, then there is a circular dependency
      If '$D(pOutput(tSort)) {
        Set tItem="",tMsg="Circular dependency found:"
        For { Set tItem=$O(pOutput(tSort+1,tItem)) Quit:tItem=""
          Set tMsg=tMsg_" "_tItem
        }
        $$$ThrowStatus($$$ERROR($$$GeneralError,tMsg))
      }
    }
    
  } Catch ex { Set tSC = ex.AsStatus() }
  Quit tSC
}

}
