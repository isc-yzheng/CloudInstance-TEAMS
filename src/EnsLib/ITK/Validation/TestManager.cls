/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Validation.TestManager Extends %RegisteredObject [ System = 4 ]
{

/// Method to run suite of validation tests over a complete test run of the ITK
ClassMethod ValidateTests(pRootDir As %String, pUnitTestDir As %String) As %Status
{
	Set tSC = $$$OK

	try {
		// Check to see if the params were supplied
		if '$D(RootDir) Set pRootDir = ^ISC.ITK.Test("ResultsRootDir")
		if '$D(pUnitTestDir) Set pUnitTestDir = ^ISC.ITK.Test("UnitTestDir")
		// Validate that the RootDir exists
		throw:'##class(%File).DirectoryExists(pRootDir) ##class(%Exception.StatusException).%New(,$$$ERRORCODE($$$DirectoryNotExist),,$lb(pRootDir))
		// Validate that the RootDir exists
		throw:'##class(%File).DirectoryExists(pUnitTestDir) ##class(%Exception.StatusException).%New(,$$$ERRORCODE($$$DirectoryNotExist),,$lb(pUnitTestDir))

		// Collect a list of sub directories
		Set RootFile = ##class(%ResultSet).%New("%File:FileSet")
		Set tSC = RootFile.%Execute(pRootDir, "*", "Name", 1)
		Set n = 0
		While RootFile.Next(), RootFile.Get("Type") = "D"
		{
			Set TestName = RootFile.Get("ItemName")
			//w !,RootFile.GetData(1)," ",RootFile.GetData(2)," ",RootFile.GetData(3)," ",RootFile.GetData(4)," 5:",RootFile.Get("ItemName")
			// Check against ^ISC.ITK.Test("Validation",<Name>) to get the 'spec' for the tests
			if $Data(^ISC.ITK.Test("Validation",TestName))
			{
				Set SubDir(TestName)=^ISC.ITK.Test("Validation",RootFile.Get("ItemName"))
			}
		}

		// Export the generic suite of unit tests for each test package so they can be run as a suite.
		// We put each in its own directory so that it can use ..Manager.CurrentDir to find out its config
		// Copy this class into "UnitTestsRunTime" because the %UnitTest.Manager will import it, compile it, then delete it.
		// First see if it exists (maybe unit test manager failed to clean up)
		set runtimeClass = ##class(%Dictionary.ClassDefinition).%OpenId("EnsLib.ITK.Validation.UnitTestsRuntime")
		if runtimeClass '= $$$NULLOREF {
			// delete it
			Set tSC = ##class(%Dictionary.ClassDefinition).%Delete(runtimeClass.%Oid())
			throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		set classDef = ##class(%Dictionary.ClassDefinition).%OpenId("EnsLib.ITK.Validation.UnitTests")
		set runtimeClass = classDef.%ConstructClone(1)
		set runtimeClass.Name = "EnsLib.ITK.Validation.UnitTestsRuntime"
		set tSC = runtimeClass.%Save()
		throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)

		Set TestName = ""
		Set ^UnitTestRoot = pUnitTestDir
		Set SubDirArray = ##class(%ArrayOfDataTypes).%New()
		For {
			Set TestName = $Order(SubDir(TestName))
			Quit:TestName=""
			w !,"Exporting for Test "_TestName,!
			Set TestDirName = ..fixPath(pUnitTestDir)_TestName
			if ##class(%File).DirectoryExists(TestDirName) {
				// Delete existing directory
				throw:'##class(%File).RemoveDirectoryTree(TestDirName) ##class(%Exception.StatusException).%New(,$$$ERRORCODE($$$GeneralError),,$lb("Failed to remove directory "_TestDirName))
			}
			throw:'##class(%File).CreateDirectory(TestDirName) ##class(%Exception.StatusException).%New(,$$$ERRORCODE(DirectoryCannotCreate),,$lb(TestDirName))
			Set tSC = ##class(%SYSTEM.OBJ).Export("EnsLib.ITK.Validation.UnitTestsRuntime.CLS",..fixPath(TestDirName)_"UnitTests.xml")
			throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			do SubDirArray.SetAt(SubDir(TestName), TestName)
		}

		// Finally, run the tests
		//Set SubDir = SubDirCount
		Do SubDirArray.SetAt(..fixPath(pRootDir), "RootDir")
		Set tSC = ##class(%UnitTest.Manager).RunTest(,,SubDirArray)
		throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)	


	} catch Error {
		Set tSC = Error.AsStatus()
		w Error.DisplayString()
	}

	Quit tSC
}

/// Append '/' to <var>pPath</var> if it is missing and we are not running on VMS.
ClassMethod fixPath(pPath As %String) As %String [ Internal ]
{
	If ""'=pPath {
		If $$$isVMS {
			Quit ##Class(%Library.File).NormalizeDirectory(pPath)
		} ElseIf $$$isUNIX {
			Set pPath = $Translate(pPath,"\","/")
			Quit:("/" '= $E(pPath,*)) pPath_"/"
		} Else {
			Set pPath = $Translate(pPath,"/","\")
			Quit:("\" '= $E(pPath,*)) pPath_"\"
		}
	}
	Quit pPath
}

}
