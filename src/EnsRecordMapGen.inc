ROUTINE EnsRecordMapGen [Type=INC]
#Define ComplexMap									%complexMap
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#Define ComplexMapIdentIndex(%recordMap)			$$$ComplexMap("identifiers",%recordMap)
#Define ComplexMapNameIndex(%name)					$$$ComplexMap("names",%name)
#Define ComplexMapCheckName(%oref,%status)			If (%oref.name '= "") { If $data($$$ComplexMapNameIndex(%oref.name)) { Set %status = $$$ERROR($$$EnsRecordMapErrRecNameCollision,%oref.name) } Else { Set $$$ComplexMapNameIndex(%oref.name) = "" } }
#Define ComplexMapAdd(%array,%node,%spec,%batchEl)	Set %array(%node) = %spec, %array(%node,"oref") = %batchEl
#Define ComplexMapAddRoot(%array,%spec,%batchEl)	Set %array = %spec, %array("oref") = %batchEl
#Def1arg ComplexMapGet(%path)						$get(%map(%path))
#Def1arg ComplexMapGetOref(%path)					$get(%map(%path,"oref"))

#Define WriteCode(%methodDef,%data)					Do %methodDef.Implementation.WriteLine(%data)

#Define nextSequenceNumber(%seqVar) %seqVar, %seqVar=%seqVar+1
#Define addGeneratedClass(%array,%class)	If '$data(%array(%class)) { Set %array(%class)="",%array=%array+1 }
#Define addCompiledClass(%array,%class)		If '$data(%array(%class)) { Set %array=%array+1 } Set %array(%class)=1

#Define localStructure				%structure
#Define localParseTree				%parseTree
#Define parseRecordProp(%propName)	$$$localParseTree(%propName)
#Define RepeatData					%EnsRecMapRepeatData
#Define LoopVar						("tLoop" _ $increment($$$RepeatData("loop")))

#Define GetRecordProp(%propName) 			$get($$$localStructure("parse",%propName))
#Define GetTopFieldProp(%colKey,%propName)	$get($$$localStructure("parse","struc",%colKey,%propName))

#Define NextField(%col)		$order($$$localStructure("parse","struc",%col))
#Define PrevField(%col)		$order($$$localStructure("parse","struc",%col), -1)

