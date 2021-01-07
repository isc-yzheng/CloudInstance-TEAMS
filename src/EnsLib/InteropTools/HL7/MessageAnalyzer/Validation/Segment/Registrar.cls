/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Validation

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.Registrar
{

ClassMethod RegisterThisPackage()
{
	// this class's package
	Set tPackage=$Piece($ClassName(),".",1,*-1)
	
	// for each class in this package ..
	Set tPackageScanner=##class(PackageScanner).%New(tPackage)
	While tPackageScanner.NextClass(.tClass) {
	
		// if the class has a RegisterPatterns method ..
		If $$$comMemberDefined(tClass,"m","RegisterPatterns") {
		
			// register it
			Kill tRecords
			Do $ClassMethod(tClass,"RegisterPatterns",.tRecords)
			Merge $$$VSMROOT=tRecords
		}
	}
}

}
