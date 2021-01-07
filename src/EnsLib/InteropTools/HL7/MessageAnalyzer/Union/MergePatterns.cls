/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Node)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.MergePatterns Extends %RegisteredObject
{

/// Standard format
Property SchemaPattern As %String [ Private ];

/// Standard format
Property UnionPattern As %String [ Private ];

ClassMethod Test()
{
	Set s="MSH,SCH,[{TQ1}],[{NTE}],[{PID,[PD1],[PV1],[PV2],[{OBX}],[{DG1}]}],{RGS,[{AIS,[{NTE}]}],[{AIG,[{NTE}]}],[{AIL,[{NTE}]}],[{AIP,[{NTE}]}]}"
	Set u="MSH,SCH,[{NTE}],{ZBX},PID,PV1,RGS,[{AIG}],[{AIS}],[{AIG}],[NTE],AIL,[AIP]"
	d ##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Union.MergePatterns).%New(s,u).Merge()
}

/// Patterns can be given in either format (standard/simplified)
Method %OnNew(pSchemaPattern As %String, pUnionPattern As %String) As %Status
{
	Set ..SchemaPattern=##class(Common).AsCSF(pSchemaPattern)
	Set ..UnionPattern=##class(Common).AsCSF(pUnionPattern)
	Quit $$$OK
}

/// Returns either a merged pattern or "" if none can be found
/// <p>The result is in simplified format
Method Merge() As %String
{
	Set tSchemaNode=##class(Common).CompileSchema(..SchemaPattern)
	Set tUnionNode=##class(Common).CompileSchema(..UnionPattern)
	
	Set tESchemaNodeCollection=##class(ENodeCollection).%New(tSchemaNode)
	Set tEUnionNodeCollection=##class(ENodeCollection).%New(tUnionNode)
	
	Do tESchemaNodeCollection.Dump()
	Do tEUnionNodeCollection.Dump()
	
	Set tESchemaRoot=tESchemaNodeCollection.Root()
	Set tEUnionRoot=tEUnionNodeCollection.Root()
	
	Kill tSchemaLeaves
	Do tESchemaRoot.GetDescendantLeaves(tESchemaNodeCollection,.tSchemaLeaves)
	
	Kill tUnionLeaves
	Do tEUnionRoot.GetDescendantLeaves(tEUnionNodeCollection,.tUnionLeaves)
	
	Kill tSchemaOnce
	Kill tUnionOnce
	Kill tSchemaUnionOnce
	Do ..FindSingletons(.tSchemaLeaves,.tUnionLeaves,.tSchemaOnce,.tUnionOnce,.tSchemaUnionOnce)
	Do dump("schema",.tSchemaOnce)
	Do dump("union",.tUnionOnce)
	Do dump2("schemaunion",.tSchemaUnionOnce)
	
	If '..CheckOrder(.tSchemaUnionOnce) {
		Write "Out of order!",!
		BREAK
		ZTRAP
	}
	
	Do upchains("schema",tESchemaNodeCollection,.tSchemaOnce)
	Do upchains("union",tEUnionNodeCollection,.tUnionOnce)
	Do upchains2("schemaunion",tESchemaNodeCollection,tEUnionNodeCollection,.tSchemaUnionOnce)
	
	BREAK
	
	Quit
	
dump(label,once)
	Write !
	Write label,!
	Set leaf="" While 1 {
		Set leaf=$Order(once(leaf),+1,enode) If leaf="" {Quit}
		Write " ",leaf," - ",enode.Repr,!
	}
	Quit
	
dump2(label,both)
	Write !
	Write label,!
	Set leaf="" While 1 {
		Set leaf=$Order(both(leaf)) If leaf="" {Quit}
		Write " ",leaf," - ",both(leaf,1).Repr," - ",both(leaf,2).Repr,!
	}
	Quit
	
upchains(label,coll,once)
	Write !
	Write label,!
	Set leaf="" While 1 {
		Set leaf=$Order(once(leaf),+1,enode) If leaf="" {Quit}
		Write " ",leaf," - ",enode.Repr,!
		Do upchainsone(coll,enode)
	}
	Quit
	
upchains2(label,coll1,coll2,both)
	Write !
	Write label,!
	Set leaf="" While 1 {
		Set leaf=$Order(both(leaf)) If leaf="" {Quit}
		Write " ",leaf," - ",both(leaf,1).Repr," - ",both(leaf,2).Repr,!
		Do upchainsone(coll1,both(leaf,1))
		Do upchainsone(coll2,both(leaf,2))
	}
	Quit
	
upchainsone(coll,enode)
	Write "+",!
	Set e=enode
	Do {
		Write " - ",e.Repr,!
		Set e=e.GetParent(coll)
	} While e'=""
	Quit
}

ClassMethod FindSingletons(ByRef pSchemaLeaves, ByRef pUnionLeaves, Output pSchemaOnce, Output pUnionOnce, Output pSchemaUnionOnce) [ Private ]
{
	$$$SHOULDBEUNDEF(pSchemaOnce)
	$$$SHOULDBEUNDEF(pUnionOnce)
	$$$SHOULDBEUNDEF(pSchemaUnionOnce)

	Set tSchemaLeaf=$Order(pSchemaLeaves(""),+1,tSchemaLeafCount)
	Set tUnionLeaf=$Order(pUnionLeaves(""),+1,tUnionLeafCount)

	// until either sequence is finished ..
	While tSchemaLeaf'="",tUnionLeaf'="" {
		
		// until the schema sequence is finished or reaches upto/past the union sequence ..
		While tSchemaLeaf'="",tUnionLeaf]]tSchemaLeaf {			
			If tSchemaLeafCount=1 {
				Set pSchemaOnce(tSchemaLeaf)=pSchemaLeaves(tSchemaLeaf,1)
			}
			Set tSchemaLeaf=$Order(pSchemaLeaves(tSchemaLeaf),+1,tSchemaLeafCount) If tSchemaLeaf="" {Quit} // quit inner While loop
		}
		If tSchemaLeaf="" {Quit} // quit outer While loop

		// until the union sequence is finished or reaches upto/past the schema sequence ..
		While tUnionLeaf'="",tSchemaLeaf]]tUnionLeaf {			
			If tUnionLeafCount=1 {
				Set pUnionOnce(tUnionLeaf)=pUnionLeaves(tUnionLeaf,1)
			}
			Set tUnionLeaf=$Order(pUnionLeaves(tUnionLeaf),+1,tUnionLeafCount) If tUnionLeaf="" {Quit} // quit inner While loop
		}
		If tUnionLeaf="" {Quit} // quit outer While loop
		
		// if the sequences match ..
		If tSchemaLeaf=tUnionLeaf {
			If tSchemaLeafCount=1, tUnionLeafCount=1 {
				Set pSchemaUnionOnce(tSchemaLeaf,1)=pSchemaLeaves(tSchemaLeaf,1)
				Set pSchemaUnionOnce(tUnionLeaf,2)=pUnionLeaves(tUnionLeaf,1)
			}
			Set tSchemaLeaf=$Order(pSchemaLeaves(tSchemaLeaf),+1,tSchemaLeafCount) If tSchemaLeaf="" {Quit} // quit outer While loop
			Set tUnionLeaf=$Order(pUnionLeaves(tUnionLeaf),+1,tUnionLeafCount) If tUnionLeaf="" {Quit} // quit inner While loop
		}
	}
	
	// finish off schema sequence
	If tSchemaLeaf'="" {
		While 1 {
			If tSchemaLeafCount=1 {
				Set pSchemaOnce(tSchemaLeaf)=pSchemaLeaves(tSchemaLeaf,1)
			}
			Set tSchemaLeaf=$Order(pSchemaLeaves(tSchemaLeaf),+1,tSchemaLeafCount) If tSchemaLeaf="" {Quit}
		}
	}
	
	// finish off schema sequence
	If tUnionLeaf'="" {
		While 1 {
			If tUnionLeafCount=1 {
				Set pUnionOnce(tUnionLeaf)=pUnionLeaves(tUnionLeaf,1)
			}
			Set tUnionLeaf=$Order(pUnionLeaves(tUnionLeaf),+1,tUnionLeafCount) If tUnionLeaf="" {Quit}
		}
	}
}

ClassMethod CheckOrder(ByRef pSchemaUnionOnce) As %Boolean [ Private ]
{
	Kill tByOffset
	Set tLeaf="" While 1 {

		Set tLeaf=$Order(pSchemaUnionOnce(tLeaf)) If tLeaf="" {Quit}

		Set tSchemaENode=pSchemaUnionOnce(tLeaf,1)
		Set tSSO=tSchemaENode.SourceStartOffset
		$$$ACASSERT('$Data(tByOffset(tSSO,1)),"CheckOrder: multiple entries at schema start offset "_tSSO)
		Set tByOffset(tSSO,1)=tSchemaENode

		Set tUnionENode=pSchemaUnionOnce(tLeaf,2)
		Set tUSO=tUnionENode.SourceStartOffset
		$$$ACASSERT('$Data(tByOffset(tUSO,2)),"CheckOrder: multiple entries at union start offset "_tUSO)
		Set tByOffset(tUSO,2)=tUnionENode
	}
	
	Set (tSchemaSequence,tUnionSequence)=""
	Set tSO="" While 1 {
		Set tSO=$Order(tByOffset(tSO)) If tSO="" {Quit}
		If $Data(tByOffset(tSO,1),tSchemaENode) {
			Set tSchemaSequence=tSchemaSequence_$ListBuild(tSchemaENode.Repr)
		} 
		If $Data(tByOffset(tSO,2),tUnionENode) {
			Set tUnionSequence=tUnionSequence_$ListBuild(tUnionENode.Repr)
		}
	}
	
	Quit tSchemaSequence=tUnionSequence
}

}
