/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.StrategyManager Extends %RegisteredObject [ Final ]
{

Property BestSchemaName As %String [ Private ];

Property BestSchemaSource As %String [ Private ];

Property Outcomes As OutcomeBase [ MultiDimensional, Private ];

Property MachineCollection As MachineCollection [ Private ];

Property Logger As Logger [ Private ];

Parameter MessageEndStrategies As %List;

Parameter SchemaEndStrategies As %List = {$ListBuild("Strategies.AppendZSegments")};

Parameter MismatchStrategies As %List;

Parameter ControlStrategies As %List;

Parameter UniversalStrategies As %List = {$ListBuild("Strategies.Scan")};

Method %OnNew(pBestSchemaName As %String, pBestSchemaSource As %String, ByRef pOutcomes, pMachineCollection As MachineCollection, pLogger As Logger) As %Status
{
	Set ..BestSchemaName=pBestSchemaName
	Set ..BestSchemaSource=pBestSchemaSource
	Merge ..Outcomes=pOutcomes
	Set ..MachineCollection=pMachineCollection
	Set ..Logger=pLogger
	
	Quit $$$OK
}

/// Given pOutcomes(1..#)=Outcome
/// <br>Return pExtensions(1..#)=Extension
Method Extend(Output pExtensions, pConfig As Config, pRigSchemas As RigSchemaCollection)
{
	#Dim tStrategyTable
	
	$$$SHOULDBEUNDEF(pExtensions)
	
	If $Data(..Outcomes)#10=0 {$$$FATAL("Extend: no outcomes given")}
	
	Do ..MakeStrategies(.tStrategyTable)
	
	Do ..PerformStrategies(.tStrategyTable,.pExtensions,pConfig,pRigSchemas)
}

/// Set extension options (called at shell startup)
ClassMethod SetExtensionOptions(pConfig As Config)
{
	Do pConfig.SetExtensionOption("NOSCANZ",$Get($$$GLOBALSETTING("NOSCANZ")))
}

Method GetBestSchemaName() As %String [ CodeMode = expression ]
{
..BestSchemaName
}

/// Given pOutcomes(1..pOutcomes)=Outcome
/// <br>Return:
/// <ul>
///  <li> pStrategyTable(FailureOutcomeType,0)=$LB(StrategyName,..)
///  <li> pStrategyTable(FailureOutcomeType,1..#)=Outcome
Method MakeStrategies(Output pStrategyTable) [ Private ]
{
	#Dim tI,tFailureOutcomeType,tStrategyNames
	
	$$$SHOULDBEUNDEF(pStrategyTable)
	
	For tI=1:1:$Get(..Outcomes) {

		Set tFailureOutcomeType=..Outcomes(tI).FailureOutcomeType()

		If '$Data(pStrategyTable(tFailureOutcomeType)) {
		
			Set tStrategyNames=$Case(tFailureOutcomeType,
				$$$FOMEND:..#MessageEndStrategies,
				$$$FOSEND:..#SchemaEndStrategies,
				$$$FOMISM:..#MismatchStrategies,
				$$$FOCONT:..#ControlStrategies,
				:""
			) _ ..#UniversalStrategies
			
			Set pStrategyTable(tFailureOutcomeType,0)=tStrategyNames
		}
		
		Set pStrategyTable(tFailureOutcomeType,$I(pStrategyTable(tFailureOutcomeType)))=..Outcomes(tI)
	}
}

Method PerformStrategies(ByRef pStrategyTable, Output pExtensions, pConfig As Config, pRigSchemas As RigSchemaCollection) [ Private ]
{
	
	$$$SHOULDBEUNDEF(pExtensions)
	
	Set tPrefix=$Piece(..%ClassName(1),..%ClassName(0))
	
	Set tFailureOutcomeType="" While 1 {
		Set tFailureOutcomeType=$Order(pStrategyTable(tFailureOutcomeType)) If tFailureOutcomeType="" {Quit}
		Set tStrategyNames=pStrategyTable(tFailureOutcomeType,0)
		Merge tOutcomes=pStrategyTable(tFailureOutcomeType)
		Kill tOutcomes(0)
		Set tPtrI=0 While $ListNext(tStrategyNames,tPtrI,tElemI) {
			Do $ClassMethod(tPrefix_tElemI,"Extend",..BestSchemaName,..BestSchemaSource,.tOutcomes,.pExtensions,..MachineCollection,pConfig,..Logger,pRigSchemas)
		}
	}
}

}
