/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsLib.HL7.Util.Validator [ Abstract, System = 4 ]
{

/// <var>pDoc</var> is the HL7 message document to validate.
/// <var>pValSpec</var> is a string specifying types of Validation to perform <p>
/// Set to 1 to block documents that don't pass default validation. Default validation requires a DocType, allows messages 
/// with unmapped Z-segments, and blocks messages with any other error encountered while mapping the document's 
/// sequence of segments using the HL7 schema structure specified by the document's DocType. This is equivalent to 'dm-z'. <p/>
/// (The '-z' means 'the opposite of z', i.e. do tolerate unrecognized trailing Z-segments, which is the customary HL7 behavior.) <p/>
/// 'd' - require DocType <br/>
/// 'm' - don't tolerate BuildMap segment mapping errors (includes 'z' by default; specify '-z' to tolerate unrecognized trailing Z-segments) <br/>
/// 'z' - don't tolerate unrecognized trailing Z-segments <br/>
/// 'n' - enforce segment structures <br/>
/// 'r' - enforce required fields being present <br/>
/// 'l' - enforce field size restrictions <br/>
/// 'a' - enforce field array repetition limits <br/>
/// 't' - enforce code tables <br/>
/// 'b' - permit values not explicitly listed in a code table to pass validation when the code table uses "..." to indicate that any other values are also allowed. <br/>
/// 'u' - ignore code tables that do not list any permissible values; permit any value in fields that use such a code table. <br/>
/// 'y' - enforce data types <br/>
/// 'p' - enforce component data structures <br/>
/// 'j' - enforce optionality at the subcomponent level <br/>
/// 'w' - enforce subcomponent size restrictions <br/>
/// 's' - perform all available subcomponent-level validations.  Equivalent to 'pjw'. <br/>
/// 'g' - enforce field data structures <br/>
/// 'o' - enforce optionality at the component level <br/>
/// 'i' - enforce component size restrictions <br/>
/// 'c' - perform all available component - level validations.  Equivalent to 'gois'. <br/>
/// 'f' - perform all validations available within an individual segment.  Equivalent to 'nrlatbuyc'. <br/>
/// 'e' - perform every available validation.  Equivalent to 'dmf'. <br/>
/// 'x' - stop validating when an error is encountered. This is the default behavior.  Specify '-x' to scan the entire document and report all errors. <br/>
ClassMethod Validate(pDoc As EnsLib.HL7.Message, pValSpec As %String = 1) As %Status
{
	#; do validation - by default validate DocType, BuildMapStatus but allow trailing Z-Segs
	Set tSC=$$$OK
	Set:pValSpec["e" pValSpec=$REPLACE(pValSpec,"e","dmf")
	Set:pValSpec=1 pValSpec="dm-z"  Set pValSpec=##class(EnsLib.MsgRouter.RoutingEngine).normalizeValSpec(pValSpec)
	Set:((pValSpec'["X") && (pValSpec'["x")) pValSpec = pValSpec_"x"
	If ((pDoc.DocType="") && (pValSpec["d") && (pValSpec'["D")) {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"Message has no DocType set")
		Quit:pValSpec["x" tSC
	}
	If (($TR(pValSpec,"DdXx")'="") && $$$ISOK(tSC)) {
		Do:""=pDoc.BuildMapStatus pDoc.BuildMap(pValSpec'["x")
		Set tSC=pDoc.BuildMapStatus, tSC1 = tSC  Set:""=tSC tSC=$$$OK
		If $$$ISERR(tSC) {
			If ((pValSpec["Z") && $$$StatusEquals(tSC,$$$EnsEDIErrMapWildSegUnrecog, $$$EnsEDIErrMapWildSegUnrecogAfterWild)) { Set tSC=$$$OK }
			ElseIf ((pValSpec'["m") || (pValSpec["M")) { Set tSC=$$$OK }
		}
		Quit:((pValSpec["x")&&$$$ISERR(tSC)) tSC
	}
	If $TR(pValSpec, "dDmMZzXx")'="" {
		If pDoc.DocType="" || $$$StatusEquals(tSC1,$$$EnsEDIErrMapDocType) {
			Set tSC=$$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Unable to validate segments because message has no DocType set to validate against."))
			Quit tSC
		}
		Set pValSpec = ..simplifyValSpec(pValSpec)
		For i=1:1:pDoc.SegCount {
			Set tSeg=pDoc.GetSegmentAt(i,.tSC1)
			Set:$$$ISOK(tSC1) tSC1=..valSeg(tSeg,pValSpec,i)
			If $$$ISERR(tSC1) { Set tSC=$$$ADDSC(tSC,tSC1)  Quit:pValSpec["x" }
		}
	}
	Quit tSC
}

/// <var>pSeg</var> is the HL7 message segment to validate.
/// <var>pValSpec</var> is a string specifying types of Validation to perform <p>
/// Set to 1 to block documents that don't pass default validation. Default validation...
/// 'n' - enforce segment structures <br/>
/// 'r' - enforce required fields being present <br/>
/// 'l' - enforce field size restrictions <br/>
/// 'a' - enforce field array repetition limits <br/>
/// 't' - enforce code tables <br/>
/// 'b' - permit values not explicitly listed in a code table to pass validation when the code table uses "..." to indicate that any other values are also allowed. <br/>
/// 'u' - ignore code tables that do not list any permissible values; permit any value in fields that use such a code table. <br/>
/// 'y' - enforce data types <br/>
/// 'p' - enforce component data structures <br/>
/// 'j' - enforce optionality at the subcomponent level <br/>
/// 'w' - enforce subcomponent size restrictions <br/>
/// 's' - perform all available subcomponent-level validations.  Equivalent to 'pjw'. <br/>
/// 'g' - enforce field data structures <br/>
/// 'o' - enforce optionality at the component level <br/>
/// 'i' - enforce component size restrictions <br/>
/// 'c' - perform all available component - level validations.  Equivalent to 'gois'. <br/>
/// 'f' - perform all validations available within an individual segment.  Equivalent to 'nrlatbuyc'. <br/>
/// 'x' - stop validating when an error is encountered. This is the default behavior.  Specify '-x' to scan the entire document and report all errors. <br/>
ClassMethod ValidateSeg(pSeg As EnsLib.HL7.Segment, pValSpec As %String = 1) As %Status
{
	Set:pValSpec=1 pValSpec="f"  Set pValSpec=##class(EnsLib.MsgRouter.RoutingEngine).normalizeValSpec(pValSpec)
	Set pValSpec = ..simplifyValSpec(pValSpec)
	Quit ..valSeg(pSeg,pValSpec)
}

/// Simplify so that ValSpec contains only those specifications which we want
ClassMethod simplifyValSpec(pValSpec As %String) As %String
{
	Set pValSpec=$REPLACE(pValSpec,"f","nrlatbuyc")
	Set pValSpec=$REPLACE(pValSpec,"c","gois")
	Set pValSpec=$REPLACE(pValSpec,"s","pjw")
	Set pValSpec=$REPLACE(pValSpec,"F","NRLATBUYC")
	Set pValSpec=$REPLACE(pValSpec,"C","GOIS")
	Set pValSpec=$REPLACE(pValSpec,"S","PJW")
	Set tAllowZ = pValSpec["Z"
	Set tNewSpec = ""
	Set tRemove = ""
	For i = 1:1:$length(pValSpec)
	{
		Set char = $E(pValSpec, i)
		If ($ZCVT(char,"L") = char) {
			Set tNewSpec = tNewSpec_char
		} Else {
			Set tRemove = tRemove_$ZCVT(char,"L")
		}
	}
	Set tNewSpec = $TR(tNewSpec, tRemove)
	Quit $TR(tNewSpec, "dmz")_$S(tAllowZ:"Z",1:"")
}

ClassMethod valSeg(pSeg As EnsLib.HL7.Segment, pValSpec As %String, pSegNum As %Integer) As %Status [ Internal ]
{
	#dim tSC, tSC1, tSC2 As %Status = $$$OK
	#dim hasSegNum, data, exit As %Boolean
	#dim dat, fieldDat, compDat, dataStruct, repDat As %String
	#dim len, num, fieldNum, rep, repeats As %Integer
	#dim fieldSchema As list of %String
	#dim info As array of %String

	Do {
		If (pSeg.Name = "") {
			Set tSC = $$$ERROR($$$EnsErrGeneral, "Cannot validate segment schemas without a segment name.  Unable to validate segment "_$get(pSegNum)_".")
			Quit
		}
		set hasSegNum = 1 - ($get(pSegNum)="")
		If (pSeg.DocTypeCategory = "") {
			#; No error if this is a trailing Z segment and we are permitting unrecognized trailing z segments
			Set:(($ZCVT($E(pSeg.Name),"U")'="Z")||(pValSpec'["Z")) tSC = $$$ERROR($$$EnsErrGeneral, "Cannot validate segment schemas without a category.  Unable to validate segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".") 
			Quit
		}
		Set schema = $G($$$vaSchemaGbl(pSeg.DocTypeCategory, "SS", pSeg.Name))
		If (schema = "") {
			Set tSC = $$$ERROR($$$EnsErrGeneral, "Unable to retrieve the schema to validate segment against.  Unable to validate segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".")
			Quit
		}

		#; Avoid repeated calls to CountGet()
		#dim tSegCount As %Integer = pSeg.Count

		If ((tSegCount > $listlength(schema)) && (pValSpec["n")) {
			Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Segment structure not obeyed in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Segment has more fields than permitted by segment structure "_pSeg.Name_"."))
			Quit:(pValSpec["x") ; stop looking at the segment if not continuing after error
		}

		/*
			Need to decide if could contain streams. pSeg.FullSize>$$$HL7MaxSegLen a possible indication but overhead
			$L(fieldDat)>$$$MaxLocalLength-50[used elsewhere in the code or say -60)
			E.G. 1|2|3|4|5|6|7|8| and 5 is stream then remainder is
				tStreamRemainder="|6|7|8|"
				tUsingStreamRemainderAfterFieldNum = 5
				when fieldNum is 6 $P(tStreamRemainder,$$$FSSEP(pSeg.Separators),((fieldNum-tUsingStreamRemainderAfterFieldNum)+1)
			If field contains a stream we will not any validation on the field containing the stream beyond max length and required.
		*/

		#dim tFieldIsAStream As %Boolean = 0

		#dim tUsingStreamRemainderAfterFieldNum As %Integer = 0
		#; Following will be initialized if tUsingStreamRemainderAfterFieldNum is set to true
		#dim tFieldAsStream As %Stream.Object
		#dim tStreamRemainder as %String
		#dim tRemainderCount As %Integer
		#dim FS As %String


		For fieldNum=1:1:$listlength(schema) {

			#; tSegCount might be modified from pSeg.Count  below if a stream in the segment
			Quit:(fieldNum > tSegCount)

			Set tFieldIsAStream = 0
			If 'tUsingStreamRemainderAfterFieldNum {
				Set fieldDat = pSeg.GetValueAt(fieldNum, pSeg.Separators, .tSC2)
				If ($$$ISERR(tSC2)) {
					Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Unable to retrieve field "_fieldNum_" from segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_"."))
					Quit ; can only continue with this field if no error in getting it
				}
			} Else {
				Set fieldDat = $Piece(tStreamRemainder,FS,((fieldNum-tUsingStreamRemainderAfterFieldNum)+1))
			}

			#; Check to see if we need retrieve a stream and handle remainder - we only support one stream per segment
			If 'tUsingStreamRemainderAfterFieldNum && ($Length(fieldDat)>($$$MaxLocalLength-60)) {
				Set tFieldIsAStream = 1
				Set tUsingStreamRemainderAfterFieldNum = fieldNum
				Set tSC2 = pSeg.GetFieldStreamRaw(.tFieldAsStream,fieldNum,.tStreamRemainder)
				If ($$$ISERR(tSC2)) {
					Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Unable to retrieve stream field "_fieldNum_" from segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_"."))
					Quit ; can only continue with this field if no error in getting it
				}
				Set FS = $$$FSSEP(pSeg.Separators)
				Set tRemainderCount = $l(tStreamRemainder,FS)
				#; If a stream is in the segment then the count could be wrong so check if same.
				Set:(tSegCount = fieldNum) tSegCount = tSegCount + tRemainderCount
				Set len = tFieldAsStream.Size
			}

			If 'tFieldIsAStream && '(((pSeg.Name = "MSH") || (pSeg.Name = "BHS") || (pSeg.Name = "FHS")) && ((fieldNum = 1) || (fieldNum = 2))) {
				Set dat = $tr(fieldDat, pSeg.Separators, "") ; remove separators from field
			} Else {
				#; If is a stream then fieldDat is not actual stream but result of GetValueAt. 
				Set dat = fieldDat
			}

			Set fieldSchema = $listget(schema, fieldNum)

			Set data = (dat '= "") ; is anything left?
			If (('data) && ($listget(fieldSchema, 5) = "R") && (pValSpec["r")) {
				#; required field missing
				Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Required field missing in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Missing field "_fieldNum_", which is required in segment structure "_pSeg.DocType_"."))
				Quit:(pValSpec["x") ; stop looking for errors if not continuing after error
			} ElseIf (data) {
				#; len already populated with stream size
				If 'tFieldIsAStream set len = $length(fieldDat)
				If (($listget(fieldSchema, 4) '= "") && (len > $listget(fieldSchema, 4)) && (pValSpec["l")) {
					#; Over length restriction
					If '(((pSeg.Name = "MSH") || (pSeg.Name = "BHS") || (pSeg.Name = "FHS")) && (fieldNum = 2)) {
						For rep=1:1:($length(fieldDat, pSeg.RS)) {
							If ($length($p(fieldDat, pSeg.RS, rep)) > $listget(fieldSchema, 4)) { 
								Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Field size restriction exceeded in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Field "_fieldNum_", repetition "_rep_" is larger than segment structure "_pSeg.DocType_" permits it to be."))
								Quit:(pValSpec["x") ; stop looking for errors if not continuing after error
							}
						}
						Quit:(($$$ISERR(tSC)) && (pValSpec["x"))
					} Else {
						Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Field size restriction exceeded in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Field "_fieldNum_" is larger than segment structure "_pSeg.DocType_" permits it to be."))
						Quit:(pValSpec["x") ; stop looking for errors if not continuing after error
					}
				} ElseIf ((len < +$listget(fieldSchema, 7)) && (pValSpec["l")) {
					#; under min length
					Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Field size minimum not met in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Field "_fieldNum_" is smaller than segment structure "_pSeg.DocType_" permits it to be."))
					Quit:(pValSpec["x") ; stop looking for errors if not continuing after error
				} ElseIf (pValSpec["l" && 'tFieldIsAStream && '(((pSeg.Name = "MSH") || (pSeg.Name = "BHS") || (pSeg.Name = "FHS")) && (fieldNum = 2))) {
					For rep=1:1:($length(fieldDat, pSeg.RS)) {
						If ($length($p(fieldDat, pSeg.RS, rep)) < +$listget(fieldSchema,7)) {
							Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Field size minimum not met in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Field "_fieldNum_", repetition "_rep_" is smaller than segment structure "_pSeg.DocType_" permits it to be."))
							Quit:(pValSpec["x") ; stop looking for errors if not continuing after error
						}		
					}
					Quit:(($$$ISERR(tSC)) && (pValSpec["x"))
				}
				If ('($listget(fieldSchema, 6)) && (pValSpec["a") && 'tFieldIsAStream) {
					#; not allowed to repeat
					If fieldDat '= $tr(fieldDat, pSeg.RS) ; then there is a repeat
					{
						If '(((pSeg.Name = "MSH") || (pSeg.Name = "BHS") || (pSeg.Name = "FHS")) && (fieldNum = 2)) {
							Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Forbidden repetition in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Field "_fieldNum_" repeats although segment structure "_pSeg.DocType_" does not permit it to."))
							Quit:(pValSpec["x") ; stop looking for errors if not continuing after error
						}
					}
				}
				If ((($listget(fieldSchema, 3)) '= "") && (pValSpec["a") && 'tFieldIsAStream) {
					#; restricted repetion
					Set repeats = $listget(fieldSchema, 3) ; allowed repeat count
					If $length(fieldDat, pSeg.RS) > repeats {
						#; more repeats than allowed
						If '(((pSeg.Name = "MSH") || (pSeg.Name = "BHS") || (pSeg.Name = "FHS")) && (fieldNum = 2)) {
							Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Forbidden repetition in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Field "_fieldNum_" repeats more often than segment structure "_pSeg.DocType_" permits it to."))
							Quit:(pValSpec["x")  ; stop looking for errors if not continuing after error
						}
					}
				}
				If (($TR(pValSpec,"goipjwty") '= pValSpec) && 'tFieldIsAStream) {
					#; we care about data structures, components, subcomponents, datatypes, and/or code tables
					Kill info
					Set info("SegName") = pSeg.Name , info("fieldNum") = fieldNum, info("valSpec") = pValSpec, info("sep") = pSeg.Separators
					Set (info("rep"), info("comp"), info("subComp")) = 1 
					Set:(hasSegNum) info("SegNum") = pSegNum
					Set info("hasSegNum") = hasSegNum
					If (($data($$$vaSchemaGbl(pSeg.DocTypeCategory, "SS", pSeg.Name, "tables", info("fieldNum")))= 1) && (pValSpec["t")) {
						#; there is a code table for the field and we care about code tables
						Set info("fTable") = $$$vaSchemaGbl(pSeg.DocTypeCategory, "SS", pSeg.Name, "tables", fieldNum)
					}
					If ($listget(fieldSchema, 1) '= "")  {
						#; there is a data structure for the field
						Set dataStruct = $listget(fieldSchema, 1)
						Set tSC1 = ..ValidateFieldDataStructure(fieldDat, dataStruct, .info)
						If $$$ISERR(tSC1) {
							Set tSC=$$$ADDSC(tSC,tSC1)
							Quit:(pValSpec["x")  ; stop looking for errors if error and not continuing after error
						}
					} ElseIf (($data(info("fTable")) = 1) && (pValSpec["t")) {
						Set info("table") = info("fTable")
						If '(((pSeg.Name = "MSH") || (pSeg.Name = "BHS") || (pSeg.Name = "FHS")) && ((fieldNum = 1) || (fieldNum = 2))) {
							#; don't want to remove encoding characters from fields defining the encoding characters
							Set exit = 0
							For info("rep") = 1:1:$length(fieldDat, pSeg.RS) {
								Set repDat = $piece(fieldDat, pSeg.RS, info("rep"))
								For info("comp") = 1:1:$length(repDat, pSeg.CS) {
									Set compDat = $piece(repDat, pSeg.CS, info("comp"))
									For info("subComp") = 1:1:$length(compDat, pSeg.SS) {
										If ($piece(compDat, pSeg.SS, info("subComp")) '= ""){
											Set tSC1 = ..ValidateAgainstCodeTable($piece(compDat, pSeg.SS, info("subComp")), .info)	
											If $$$ISERR(tSC1) {
												Set tSC=$$$ADDSC(tSC,tSC1)
												Set:(pValSpec["x") exit = 1  ; so can quit if error and not continuing after error
											}
											Quit:(exit)
										}
									}
									Quit:(exit)
								}
								Quit:(exit)
							}
							Quit:(exit)
						} ElseIf (fieldDat '= "") {
							Set tSC1 = ..ValidateAgainstCodeTable(fieldDat, .info)
							If $$$ISERR(tSC1) { Set tSC=$$$ADDSC(tSC,tSC1) }  ; add returned error to tSC
						}
					}
				}
			}
		}
		Quit:(((pValSpec["x") && ($$$ISERR(tSC))) || ($$$ISERR(tSC2))) ; quit with error if there is one and not continuing after error
		If ((fieldNum < $listlength(schema)) && (pValSpec["r")) {
			#; fewer fields in message than in schema and we care about required fields
			For num=fieldNum:1:$listlength(schema) {
				If ($listget($listget(schema,num),5) = "R") {
					Set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Required field missing in segment "_$S(hasSegNum:pSegNum_":",1:"")_pSeg.Name_".  Missing field "_num_" which is required in segment structure "_pSeg.DocType_"."))
					Quit:(pValSpec["x")  ; stop looking for errors if not continuing after error
				}
			}
		}
	} While 0

	Quit tSC
}

ClassMethod ValidateFieldDataStructure(field As %String, struct As %String, ByRef info) As %Status [ Internal ]
{
	set tSC = $$$OK, error = 0
	set category = $p(struct, ":", 1)
	set dataStruct = $p(struct, ":", 2) 
	quit:((category = "") || (dataStruct = "")) $$$ERROR($$$EnsErrGeneral, "Cannot find schema for data structure "_struct_".  Unable to validate segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_" field "_info("fieldNum")_" against this structure.")
	set structure = $get($$$vaSchemaGbl(category, "DT", dataStruct))
	quit:('$data(structure)) $$$ERROR($$$EnsErrGeneral, "Cannot find schema for data structure "_struct_".  Unable to validate segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_" field "_info("fieldNum")_" against this structure.")
	if ((info("valSpec")["y")&&($LL($$$vaSchemaGbl(category,"DT",dataStruct))=1)&&(""=$LG($LG($$$vaSchemaGbl(category,"DT",dataStruct),1),1)))
	{
		set tSC =  ..ValidateElementaryDT(dataStruct, field, .info)
		quit:((info("valSpec")["x") && ($$$ISERR(tSC))) tSC
	}
	if '(((info("SegName") = "MSH") || (info("SegName") = "BHS") || (info("SegName") = "FHS")) && (info("fieldNum") = 2)) {
		for info("rep") = 1:1:$length(field, $$$RSSEP(info("sep"))) {
			set repeat = $piece(field, $$$RSSEP(info("sep")), info("rep"))
			if (($length(repeat, $$$CSSEP(info("sep"))) > $listlength(structure)) && (info("valSpec")["g")) ; more components than we should have and we care about data structure
			{
				set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Field data structure not obeyed in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_" has more components than permitted by data structure "_struct_"."))
				quit:(info("valSpec")["x")   ; stop looking for errors if not continuing after error
			}
			for info("comp")=1:1:$length(repeat, $$$CSSEP(info("sep"))) {
				quit:(info("comp") > $listlength(structure))
				set component = $piece(repeat, $$$CSSEP(info("sep")), info("comp"))
				set dat = $tr(component, $$$SSSEP(info("sep"))) ; remove separators from field
				set data = (dat '= "") ; is anything left?
				if (('data) && ($listget($listget(structure, info("comp")),4) = "R") && (info("valSpec")["o"))  ; required component missing
				{
					set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Required component missing in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_" is missing component "_info("comp")_", which is required in data structure "_struct_"."))
					set:(info("valSpec")["x") error = 1
					quit:(info("valSpec")["x") ; stop looking for errors if not continuing after error
				}
				elseif (data) {
					set len = $length(component)
					if (($listget($listget(structure, info("comp")),3)'="") && (len > $listget($listget(structure, info("comp")),3)) && (info("valSpec")["i")) ; over length restriction
					{ 
							set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Component size restriction exceeded in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_" is larger than data structure "_struct_" permits it to be."))
							set:(info("valSpec")["x") error = 1
							quit:(info("valSpec")["x") ; stop looking for errors if not continuing after error
					}
					if ((len < +$listget($listget(structure, info("comp")),2)) && (info("valSpec")["i")) ; under min length
					{
						set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Component size minimum not met in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_" is smaller than data structure "_struct_" permits it to be."))
						set:(info("valSpec")["x") error = 1
						quit:(info("valSpec")["x") ; stop looking for errors if not continuing after error
					}
					k info("cTable")
					if (($data($$$vaSchemaGbl(category, "DT", dataStruct, "tables", info("comp")))= 1) && (info("valSpec")["t")) ; there is a code table for the component and we care about code tables
					{
						set info("cTable") = $$$vaSchemaGbl(category, "DT", dataStruct, "tables", info("comp"))
					}
					if ($data(info("fTable")) && (((info("comp") = 1) && (dataStruct '= "CQ") && (dataStruct '= "DIN")) || ((info("comp") = 2) &&((dataStruct = "CQ") || (dataStruct = "DIN")) ) ) ) ; need to check to see of parent table will apply to component
					{
						set applies = 1
						for compNum = (info("comp") + 1):1:$listlength(structure)  ; the parent table doesn't apply to the first component when the datatype already uses the same table for a diffent component
						{
							if ($data($$$vaSchemaGbl(category, "DT", dataStruct, "tables", compNum))) {
								set compare = $$$vaSchemaGbl(category, "DT", dataStruct, "tables", compNum)
								if (compare = info("fTable")) {
									set applies = 0
									quit
								}
							}
						}
						set:(applies) info("cTable") = info("fTable")	; apply parent table to component
					}
					if (($listget($listget(structure, info("comp")),1) '= "") && ($TR(info("valSpec"),"pjwty") '= info("valSpec"))) ; there are component data structures and we care about component data structures, substructures, data types, or about code tables
					{
						set compDataStruct = $listget($listget(structure, info("comp")), 1)
						set tSC1 = ..ValidateComponentDataStructure(component, compDataStruct, .info)
						If $$$ISERR(tSC1) { Set tSC=$$$ADDSC(tSC,tSC1)  set:info("valSpec")["x" error = 1 }  ; so can stop looking if error and not continuing after error
					}
					elseif (($data(info("cTable")) = 1)&&(info("valSpec")["t")) {
						set info("table") = info("cTable")
						for info("subComp") = 1:1:$length(component, $$$SSSEP(info("sep"))) {
							if ($piece(component, $$$SSSEP(info("sep")), info("subComp")) '= "" ) {
								set tSC1 = ..ValidateAgainstCodeTable($piece(component, $$$SSSEP(info("sep")), info("subComp")), .info)
								If $$$ISERR(tSC1) { Set tSC=$$$ADDSC(tSC,tSC1)  set:(info("valSpec")["x") error = 1 }  ; stop looking if error and not continuing after error
							}
							quit:(error)
						}
					}
				}
				quit:(error)
			}
			quit:(error)
			if ((info("valSpec")["o") && (info("comp") < $listlength(structure))) {
				for comp=(info("comp")+1):1:($listlength(structure)) {
					if $listget($listget(structure, comp),4) = "R" {
						set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Required component missing in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_" is missing component "_comp_", which is required in data structure "_struct_"."))
						set:(info("valSpec")["x") error = 1
						quit:(info("valSpec")["x") ; stop looking for errors if not continuing after error
					}
				}
			}
		}
	}
	quit tSC
}

ClassMethod ValidateComponentDataStructure(component As %String, struct As %String, ByRef info) As %Status [ Internal ]
{
	set tSC = $$$OK
	set category = $p(struct, ":", 1)
	set dataStruct = $p(struct, ":", 2)
	quit:((category = "") || (dataStruct = "")) $$$ERROR($$$EnsErrGeneral, "Cannot find schema for data structure "_struct_".  Unable to validate segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_$S($get(info("rep"))'="":", repetition "_info("rep"),1:"")_", component "_info("comp")_" against this data structure.") 
	set structure = $get($$$vaSchemaGbl(category, "DT", dataStruct))
	quit:(structure = "") $$$ERROR($$$EnsErrGeneral, "Cannot find schema for data structure "_struct_".  Unable to validate segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_$S($get(info("rep"))'="":", repetition "_info("rep"),1:"")_", component "_info("comp")_" against this data structure.") 

	if ((info("valSpec")["y")&&($LL($$$vaSchemaGbl(category,"DT",dataStruct))=1)&&(""=$LG($LG($$$vaSchemaGbl(category,"DT",dataStruct),1),1)))
	{
		set tSC =  ..ValidateElementaryDT(dataStruct, component, .info)
		quit:((info("valSpec")["x") && ($$$ISERR(tSC))) tSC
	}

	if (($length(component, $$$SSSEP(info("sep"))) > $listlength(structure)) && (info("valSpec")["p")) ; more subcomponents than we should have and we care about component data structures
	{
		set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Component data structure not obeyed in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_" has more subcomponents than permitted by data structure "_struct_"."))
		quit:(info("valSpec")["x") tSC  ; stop looking for errors if not continuing after error
	}
	if ((info("valSpec")["j") || (info("valSpec")["w")) || (info("valSpec")["y") {
		set error = 0
		for info("subComp")=1:1:$length(component,$$$SSSEP(info("sep"))) {
			quit:(info("subComp") > $listlength(structure))
			set sub = $piece(component, $$$SSSEP(info("sep")), info("subComp"))
			if ((sub = "") && ($listget($listget(structure, info("subComp")),4) = "R") && (info("valSpec")["j"))  ; required subcomponent missing
			{
					set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Required subcomponent missing in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_" is missing subcomponent "_info("subComp")_", which is required in data structure "_struct_"."))
					if (info("valSpec")["x") {
						set error = 1
						quit ; stop looking for errors if not continuing after error
					}
			}
			elseif (sub '= "") {
				if (info("valSpec")["y") {
					set dt = $listget($listget(structure, info("subComp")),1)
					set category2 = $p(dt, ":", 1)
					set dataStruct2 = $p(dt, ":", 2)
					if '((category2 = "") || (dataStruct2 = "")) {
					//set structure = $get($$$vaSchemaGbl(category, "DT", dataStruct))
						if '($D($$$vaSchemaGbl(category2, "DT", dataStruct2))) {
							set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Cannot find schema for data type "_dt_".  Unable to validate segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_$S($get(info("rep"))'="":", repetition "_info("rep"),1:"")_", component "_info("comp")_", subcomponent "_info("subComp")_" against this type."))
							if (info("valSpec")["x") {
								set error = 1
								quit
							}
						}
						if (($LL($$$vaSchemaGbl(category2,"DT",dataStruct2))=1)&&(""=$LG($LG($$$vaSchemaGbl(category2,"DT",dataStruct2),1),1)))
						{
							set tSC =  ..ValidateElementaryDT(dataStruct2, sub, .info)
							if ((info("valSpec")["x") && ($$$ISERR(tSC))) {
								set error = 1
								quit 
							}
						}
					}
				}
				set len = $length(sub)
				if (($listget($listget(structure, info("subComp")),3)'="") && (len > $listget($listget(structure, info("subComp")),3)) && (info("valSpec")["w")) ; over length restriction
				{ 
						set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Subcomponent size restriction exceeded in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_" is larger than data structure "_struct_" permits it to be."))
						if (info("valSpec")["x") {
							set error = 1
							quit ; stop looking for errors if not continuing after error
						}
				}
				if ((len < +$listget($listget(structure, info("subComp")),2)) && (info("valSpec")["w")) ; under min length
				{
					set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Subcomponent size minimum not met in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_" is smaller than data structure "_struct_" permits it to be."))
					if (info("valSpec")["x") {
						set error = 1
						quit ; stop looking for errors if not continuing after error
					}
				}
			}
		}
		quit:(error) tSC
		if ((info("valSpec")["j") && (info("subComp") < $listlength(structure))) {
			for subCom=(info("subComp")+1):1:($listlength(structure)) {
				if $listget($listget(structure, subCom),4) = "R" {
					set tSC = $$$ADDSC(tSC, $$$ERROR($$$EnsErrGeneral, "Required subcomponent missing in segment "_$S(info("hasSegNum"):info("SegNum")_":",1:"")_info("SegName")_".  Field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_" is missing subcomponent "_subCom_", which is required in data structure "_struct_"."))
					quit:(info("valSpec")["x") ; stop looking for errors if not continuing after error
				}
			}
		}
	}
	if (info("valSpec")["t") ; we care about code tables
	{
		for info("subComp")=1:1:$length(component, $$$SSSEP(info("sep"))) {
			k info("table")
			if (($piece(component, $$$SSSEP(info("sep")), info("subComp")) '= "") && (($data($$$vaSchemaGbl(category, "DT", dataStruct, "tables", info("subComp")))= 1) || ($data(info("cTable"))))) ; there is a code table for the subcomponent or for the component
			{
				if $data($$$vaSchemaGbl(category, "DT", dataStruct, "tables", info("subComp"))) {
					set info("table") = $$$vaSchemaGbl(category, "DT", dataStruct, "tables", info("subComp")) 
				}
				if ($data(info("cTable")) && (((info("subComp") = 1) && (dataStruct '= "CQ") && (dataStruct '= "DIN")) || ((info("comp") = 2) &&((dataStruct = "CQ") || (dataStruct = "DIN")) ) ) ) ; need to check to see if parent table will apply to subcomponent
				{
					set applies = 1
					for subNum = (info("subComp") + 1):1:$listlength(structure)  ; the parent table doesn't apply to the first subcomponent when the datatype already uses the same table for a diffent subcomponent
					{
						if ($data($$$vaSchemaGbl(category, "DT", dataStruct, "tables", subNum))) {
							set compare = $$$vaSchemaGbl(category, "DT", dataStruct, "tables", subNum)
							if (compare = info("cTable")) {
								set applies = 0
								quit
							}
						}
					}
					set:(applies) info("table") = info("cTable")	; apply parent table to subcomponent
				}
				if ($data(info("table"))){
					set tSC1 = ..ValidateAgainstCodeTable($piece(component, $$$SSSEP(info("sep")), info("subComp")), .info)
					If $$$ISERR(tSC1) { Set tSC=$$$ADDSC(tSC,tSC1)  quit:(info("valSpec")["x") }  ; stop looking for errors if error and not continuing after error
				}
			}
		}
	}
	quit tSC
}

ClassMethod ValidateAgainstCodeTable(value As %String, ByRef info) As %Status [ Internal ]
{
	set tSC = $$$OK
	set category = $p(info("table"), ":", 1)
	set tableNum = $p(info("table"), ":", 2)
	merge codes = $$$vaSchemaGbl(category, "CT", tableNum)
	quit:($get(codes(value))'= "") tSC  ; value is present in code table 
	quit:((($o(codes("")) = "") || (($o(codes("")) = "...") && ($o(codes("...")) = ""))) && (info("valSpec")["u")) tSC ; no permissible value
	quit:((($o(codes("")) = "") || (($o(codes("")) = "...") && ($o(codes("...")) = ""))) && (info("valSpec")'["u")) $$$ERROR($$$EnsErrGeneral, "Invalid value '"_value_"' appears in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_", but no value is permitted by code table "_info("table")_".")
	if (($get(codes("...")) '= "") && (info("valSpec")["b"))  ; '...' is a value in the table and we are ignoring unrestrictive
	{
		set position = codes("...")
		set val = "", final = 1
		for {
			set val = $o(codes(val))
			quit:((val = "") || (final = 0))
			set:(codes(val) > position) final = 0	
		}
		quit:(final = 1) tSC ; '...' is last value in code table - taking on meaning like 'and so on'
	}
	set val= "", found = 0
	for {
		set val = $o(codes(val))
		quit:(val = "")
		if (($replace(val, "...", "") '= val) && (val '= "...")) {
			set p1 = $piece($replace(val, " ", ""), "...", 1)
			set p2 = $piece($replace(val, " ", ""), "...", 2)
			if (p2 = "") ; something like "2 ..." - meaning "2 and higher"
			{
				if ((value?1.N.1".") && (p1?1.N.1".") && ($tr(value,".") >= $tr(p1,"."))) {
					set found = 1
					quit
				} 
				for i=1:1:$length(p1) {
					quit:($E(value, 1, i) '= $E(p1, 1, i))
					if (($E(p1, i+1, *)?1.N) && ($E(value, i+1, *)?1.N) &&($E(value, i+1, *) >= $E(p1, i+1, *)) ) {
						set found = 1
						quit
					}
				}
			}
			else ; range - "X1 ... X2"
			{
				if ((value?1.N) && (p1?1.N) && (p2?1.N)) {
					set:((value >= p1) && (value <= p2)) found = 1
				}
				else {
					for i=1:1:$length(p2) {
						if ((($E(p1, 1, i) = $E(p2, 1, i))) && ($E(p1, i+1, *)?1.N) && ($E(p2, i+1, *)?1.N)) {
							quit:(($E(value, 1, i) '= $E(p1, 1, i)) || '($E(value, i+1, *)?1.N))
							if (($E(value, i+1, *) >= $E(p1, i+1, *)) && ($E(value, i+1, *) <= $E(p2, i+1, *))) {
								set found = 1
								quit
							}
						}
					}
				}
			}
		}
		//elseif ($replace(val, "zzz","") '= val)
		//{
		//}
	}
	quit:(found = 1) tSC
	quit $$$ERROR($$$EnsErrGeneral, "Invalid value '"_value_"' appears in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_", but does not appear in code table "_info("table")_".")
}

ClassMethod ValidateElementaryDT(pDT As %String, pVal As %String, ByRef info) As %Status
{
	Quit:""=pVal $$$ERROR($$$EnsErrGeneral,"Empty value found for required '"_pDT_"' field "_info("fieldNum"))
	If '(((info("SegName") = "MSH") || (info("SegName") = "BHS") || (info("SegName") = "FHS")) && ((info("fieldNum") = 1) || (info("fieldNum") = 2))) {
		Quit:"TX"'=pDT&&($TR(pVal,$$$ESCSEP(info("sep")))'=$TR(pVal,info("sep"))) $$$ERROR($$$EnsErrGeneral,"Unescaped separator(s) ("_$TR(info("sep"),$$$ESCSEP(info("sep")))_") found in value '"_pVal_"' for elementary data type '"_pDT_"' at segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_".")
	}
	Set:$Case(pDT,"DTM":1,"TM":1,:0) tZ=$P($P(pVal,"+"),"-"), tZ=$E(pVal,$L(tZ)+1,*), pVal=$E(pVal,1,*-$L(tZ))
	Quit $Case(pDT
				, "DT":$S(pVal?1(4N,6N,8N)
							&&($E(pVal,1,4)>=0)&&(""=$E(pVal,5,6)||($E(pVal,5,6)>0&&($E(pVal,5,6)<=12)))&&(""=$E(pVal,7,8)||($E(pVal,7,8)>0&&($E(pVal,7,8)<=$Case($E(pVal,5,6),2:29,4:30,6:30,9:30,11:30,:31)))):$$$OK
							, 1:$$$ERROR($$$EnsErrGeneral,"Invalid date value '"_pVal_"' found for type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_"."))
				, "DTM":$S(pVal?1(4N,6N,8N,10N,12N,14N,14N1".".4N)&&(tZ?.1(1(1"+",1"-")4N))
							&&($E(pVal,1,4)>=0)&&(""=$E(pVal,5,6)||($E(pVal,5,6)>0&&($E(pVal,5,6)<=12)))&&(""=$E(pVal,7,8)||($E(pVal,7,8)>0&&($E(pVal,7,8)<=$Case($E(pVal,5,6),2:29,4:30,6:30,9:30,11:30,:31))))
							&&(""=$E(pVal,9,10)||($E(pVal,9,10)>=0&&($E(pVal,9,10)<24)))&&(""=$E(pVal,11,12)||($E(pVal,11,12)>=0&&($E(pVal,11,12)<60)))&&(""=$E(pVal,13,14)||($E(pVal,13,14)>=0&&($E(pVal,13,14)<60))):$$$OK
							, 1:$$$ERROR($$$EnsErrGeneral,"Invalid date/time value '"_pVal_"' found for type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_"."))
				, "FT":$$stVal()
				, "GTS":$$stVal()
				, "ID":$$stVal()
				, "IS":$$stVal()
				, "NM":$S(pVal?.1(1"+",1"-").N.1".".N:$$$OK, 1:$$$ERROR($$$EnsErrGeneral,"Invalid numeric value '"_pVal_"' found for type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_"."))
				, "SI":$$stVal()
				, "SNM":$S(pVal?1.(1N,1"+"):$$$OK, 1:$$$ERROR($$$EnsErrGeneral,"Invalid characters found in value '"_pVal_"' for phone type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_"."))
				, "ST":$$stVal()
				, "TM":$S(pVal?1(2N,4N,6N,6N1".".4N)&&(tZ?.1(1(1"+",1"-")4N))
							&&($E(pVal,1,2)>=0&&($E(pVal,1,2)<24))&&(""=$E(pVal,3,4)||($E(pVal,3,4)>=0&&($E(pVal,3,4)<60)))&&(""=$E(pVal,4,5)||($E(pVal,4,5)>=0&&($E(pVal,4,5)<60))):$$$OK
							, 1:$$$ERROR($$$EnsErrGeneral,"Invalid time value '"_pVal_"' found for type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_"."))
				, "TN":$S(pVal?.1(2N." ")1.(1N,1"(",1")",1"-").1(1"X"1.9(1N,1".",1" ")).1(1"B"1.9(1N,1".",1" ")).1(1"C"1.(1ANP,1" ")):$$$OK, 1:$$$ERROR($$$EnsErrGeneral,"Invalid phone value '"_pVal_"' found for type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_".")) ; [NN] [(999)]999-9999[X99999][B99999][C any text]
				, "TX":$S(pVal'=$ZStrip(pVal,">W"):$$$ERROR($$$EnsErrGeneral,"Trailing whitespace found in value '"_pVal_"' for elementary text type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_".")
						, $TR(pVal,$$$ESCSEP(info("sep"))_$$$RSSEP(info("sep")))'=$TR(pVal,info("sep")):$$$ERROR($$$EnsErrGeneral,"Unescaped non-repeat separator(s) ("_$TR(info("sep"),$$$ESCSEP(info("sep"))_$$$RSSEP(info("sep")))_") found in value '"_pVal_"' for data type '"_pDT_"' at segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_".")
						, 1:$$$OK)
				, :1)
stVal()
	Quit $S(pVal'=$ZStrip(pVal,"<W"):$$$ERROR($$$EnsErrGeneral,"Leading whitespace found in value '"_pVal_"' for elementary ST type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_".")
		, pVal'=$TR(pVal,$C(0,1,2,3,4,5,6,7,8, 10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)):$$$ERROR($$$EnsErrGeneral,"Control characters found in value '"_pVal_"' for elementary string type '"_pDT_"' in segment "_$S($get(info("SegNum"))'="":info("SegNum")_":",1:"")_info("SegName")_", field "_info("fieldNum")_", repetition "_info("rep")_", component "_info("comp")_", subcomponent "_info("subComp")_".")
		, 1:$$$OK)
}

}
