/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsUtil, Ensemble)

/// Generate an HL7 v2 schema based on the .MDB MS Access database from the HL7 committee
/// Use the Regenerate() method to add a new schema version. Some handholding and manual cleanup afterwards will probably be required
Class EnsLib.HL7.Util.Generator Extends %RegisteredObject [ ClassType = "", ProcedureBlock, System = 3 ]
{

/// These 3 properties enable this class to be a parent of EnsLib.SQL.GatewayResultSet objects
Property IsUnicodeDLL As %Boolean [ InitialExpression = 1 ];

Property StayConnected As %Boolean [ InitialExpression = 1 ];

Property %Connection As %SQLGatewayConnection;

Property BusinessHost As EnsLib.HL7.Util.Generator;

Property %ConfigName As %String;

/// Get ResultSet from SQL query
Method GetRS(pSQL As %String) As EnsLib.SQL.GatewayResultSet
{
	Set tSC=..%Connection.AllocateStatement(.tHS)
	Write !,"Alloc: "_$$$StatusDisplayString(tSC)
	 Quit:$$$ISERR(tSC) ""
	Set tSC=..%Connection.Prepare(tHS,pSQL)
	Write !,"Prepare: "_$$$StatusDisplayString(tSC)
	 Quit:$$$ISERR(tSC) ""
	Set tSC=..%Connection.Execute(tHS)
	Write !,"Execute: "_$$$StatusDisplayString(tSC)
	 Quit:$$$ISERR(tSC) ""
	Set tRS=##class(EnsLib.SQL.GatewayResultSet).%New() $$$ASSERTNOLOG($IsObject(tRS))
	Set tSC=tRS.Initialize(pSQL,$this,tHS,0,"")
	Write !,"RS.Initialize: "_$$$StatusDisplayString(tSC)
	Quit tRS
}

ClassMethod componentDescToName(pDesc As %String, pCurrDS As %String, pIComp As %String) As %String
{
	Set tName=$P(pDesc,"(e.g.")
	Set:tName["Second Alternate" tName=$P(tName,"Second Alternate")_"SecAlt"_$P(tName,"Second Alternate",2) ; These names are not unique in the first 31-3 characters
	Set:"OSD"=pCurrDS&&(tName["order number") tName=$P(tName,"order number")_"order num"_$P(tName,"order number",2) ; These names are not unique in the first 31-3 characters
	Set:("CNS"=pCurrDS||("CNN"=pCurrDS))&&(tName["assigning authority") tName=$P(tName,"assigning authority")_"assig auth"_$P(tName,"assigning authority",2) ; These names are not unique in the first 31-3 characters
	Set:"CNN"=pCurrDS&&(tName["Assigning Authority") tName=$P(tName,"Assigning Authority")_"Assig Auth"_$P(tName,"Assigning Authority",2) ; These names are not unique in the first 31-3 characters
	Set:"OSD"=pCurrDS&&(tName["Order Number: Universal") tName=$P(tName,"Order Number: Universal")_"Order Num Univ"_$P(tName,"Order Number: Universal",2) ; These names are not unique in the first 31-3 characters
	Set:"CSU"=pCurrDS&&(tName["Unit Of Measure") tName=$P(tName,"Unit Of Measure")_"Unit"_$P(tName,"Unit Of Measure",2) ; These names are not unique in the first 31-3 characters
	Set:"CSU"=pCurrDS&&(tName["Alternate Unit") tName=$P(tName,"Alternate Unit")_"AltUnit"_$P(tName,"Alternate Unit",2) ; These names are not unique in the first 31-3 characters
	Set:"CSU"=pCurrDS&&(tName["Version ID") tName=$P(tName,"Version ID")_"VerID"_$P(tName,"Version ID",2) ; These names are not unique in the first 31-3 characters
	Set tName=$e($tr(tName," /-'_?&.()+#*,':;<>[]"""_$c(146,147,148,150,180)),1,31-3)  Set:""=tName tName="UnnamedPiece"_pIComp
	Set:"XTN"=pCurrDS&&(tName?10"9".E) tName="phonenumber"_pIComp
	Set:"data"=tName tName=tName_pIComp
	Set:"undefined"=tName tName=tName_pIComp
	Quit tName
}

ClassMethod fieldDescToName(pDesc As %String, pCurrSeg As %String, pIField As %String) As %String
{
	Set tName=$P(pDesc,"(e.g.")
	Set:("MSH"=pCurrSeg||("MSA"=pCurrSeg))&&(""'=$P(tName,"cknowledgement",2)) tName=$P(tName,"cknowledgement")_"cknowledgment"_$P(tName,"cknowledgement",2) ; Use uniform spelling across versions
	Set:"PSH"=pCurrSeg&&("number of product experience reports"=$ZCVT($E(tName,1,$L("number of product experience reports")),"L")) tName="Num of Exp Rpts"_$E(tName,$L("number of product experience reports")+1,$L(tName)) ; These names are not unique in the first 31-3 characters
	Set:"MSH"=pCurrSeg&&("alternate character set"=$ZCVT($E(tName,1,$L("alternate character set")),"L")) tName="Alt Charset"_$E(tName,$L("alternate character set")+1,$L(tName)) ; This name is not unique in the first 31-3 characters
	Set:"RXA"=pCurrSeg&&("administered drug strength volume units"=$ZCVT(tName,"L")) tName="Administered Drug Strength Units" ; This name is not unique in the first 31-3 characters
	Set:"PSL"=pCurrSeg&&("product/service clarification code"=$ZCVT($E(tName,1,$L("product/service clarification code")),"L")) tName="Prod/Service Clarif Code"_$E(tName,$L("product/service clarification code")+1,$L(tName)) ; This name is not unique in the first 31-3 characters
	Set:"UAC"=pCurrSeg&&("user authentication credential type code"=$ZCVT($E(tName,1,$L("user authentication credential type code")),"L")) tName="User Auth Credential Type Code"_$E(tName,$L("user authentication credential type code")+1,$L(tName)) ; This name is not unique in the first 31-3 characters
	Set:"OBX"=pCurrSeg&&("reserved for harmonization with"=$ZCVT($E(tName,1,$L("reserved for harmonization with")),"L")) tName="Resv For Harmon With"_$E(tName,$L("reserved for harmonization with")+1,$L(tName))_pIField ; shorten and add the field number
	Set:"NK"=$E(pCurrSeg,1,2)&&("next of kin / associated parties"=$ZCVT($E(tName,1,$L("next of kin / associated parties")),"L")) tName="Next of Kin / Assoc"_$E(tName,$L("next of kin / associated parties")+1,$L(tName)) ; This name is not unique in the first 31-3 characters
	Set tName=$e($tr(tName," /-'_?&.()+#*,':;<>[]"""_$c(146,147,148,150,180)),1,31-3)  Set:""=tName tName="UnnamedPiece"_pIField
	Set:"UNUSED"=tName tName=tName_pIField
	Set:"undefined"=tName tName=tName_pIField
	Quit tName
}

ClassMethod cleanDesc(pDesc As %String) As %String [ CodeMode = expression ]
{
$Replace($ZStrip($TR(pDesc,$C(0,8217,8211,8220,8221),"_'-"""""),"<>W"),"  "," ")
}

ClassMethod cleanType(pType As %String) As %String
{
	Quit $TR($Case($ZCVT($ZSTRIP(pType,"<>W"),"U"),
			"CM_CD_ELECTRODE":"",
			"CM_UNDEFINED":"",
			"COMP_ID_DIGIT":"",
			"CQ_COMP_QUANT":"",
			:pType),"-_+")
}

ClassMethod stripType(pType As %String) As %String
{
	Quit $TR($Case($ZCVT($ZSTRIP(pType,"<>W"),"U"),
			"CM_CD_ELECTRODE":"",
			"CM_UNDEFINED":"",
			"COMP_ID_DIGIT":"",
			"CQ_COMP_QUANT":"",
			"DT":"",
			"DTM":"",
			"FT":"",
			"GTS":"",
			"ID":"",
			"IS":"",
			"NM":"",
			"NUL":"",
			"SI":"",
			"ST":"",
			"TM":"",
			"TN":"",
			"TX":"",
			"VARIES":"",
			:pType),"-_+")
}

Method addErrorList(pSC, pHS, ByRef pNetErr) As %Status
{
	Set tSC=..%Connection.GetErrorList(pHS, .tErrorList)
	If $$$ISERR(tSC) { Set:'pNetErr pNetErr=##class(EnsLib.SQL.CommonJ).isNetErr($$$StatusText(tSC)) }
	ElseIf ""'=$G(tErrorList) {
		For i=1:1:$LL(tErrorList) { Set tErrorText=$LG(tErrorList,i)
			If ""'=$ZStrip(tErrorText,"<>WC")&&($$$StatusText(pSC)'[tErrorText) {
				Set pSC=$$$ADDSC(pSC, $$$ERROR($$$GeneralError,tErrorText))
				Set:'pNetErr pNetErr=##class(EnsLib.SQL.CommonJ).isNetErr(tErrorText)
			}
		}
	}
	Quit pSC
}

/// Import schema from HL7 database via Gateway
ClassMethod ImportSchema(pVersion = "2.6", pDSN = "HL7 2.6 MDB")
{
	Set tGW=##class(%SQLGatewayConnection).%New()
	Set tMe=..%New(), tMe.%Connection=tGW, tMe.BusinessHost=tMe, tMe.%ConfigName="x"
	Set tGW.DSN=pDSN
	Set tSC=tGW.Connect(tGW.DSN,"","",1)
	If $$$ISERR(tSC) {
		Set tNetErr=0, tSC=tMe.addErrorList(tSC,"",.tNetErr)
		Write !,"Connect to "_tGW.DSN_" failed: "_$$$StatusDisplayString(tSC)
		Quit
	}
	Write !,"Connected to "_tGW.DSN
	
	
	// -----------------------------------------
	Write !,!,"Getting Versions list"
	Set tSQL="SELECT * FROM HL7Versions;"
	Set tRS=tMe.GetRS(tSQL)
	Write !,"Versions"
	While tRS.Next() {
		Set ver=tRS.Get("hl7_version")
		Set:ver tVersions(ver)=tRS.Get("version_id")
		Write " : "_ver_" ('"_tRS.Get("description")_"')"
	}
	Kill tRS
	Set tVersionId=$G(tVersions(pVersion))  If ""=tVersionId Write !,"Unsupported version "_pVersion Goto shut
	// -----------------------------------------
	Write !,!,"Building ^EnsHL71.Schema.DataTypes and ^EnsHL71.Schema.DataStructures components schema for HL7 "_pVersion
	Kill ^EnsHL71.Schema.DataStructures(pVersion)
	Kill ^EnsHL71.Schema.DataTypes(pVersion)
	Kill ^EnsHL71.Schema.Descriptions("DataStructure",pVersion)
	Kill ^EnsHL71.Schema.Descriptions("DataType",pVersion)
	Set tSQL="SELECT HL7DataStructureComponents.*,HL7Components.*"_
			" FROM HL7DataStructureComponents INNER JOIN HL7Components ON (HL7Components.comp_no = HL7DataStructureComponents.comp_no) AND (HL7Components.version_id = HL7DataStructureComponents.version_id)"_
			" WHERE HL7Components.version_id="_tVersionId_""_
			" ORDER BY HL7DataStructureComponents.data_structure, HL7DataStructureComponents.seq_no;"
	Set tRS=tMe.GetRS(tSQL)
	Write !,"DataTypes:"
	Set (tPrevDS,tPrevDSName)="" While tRS.Next() {
		Set tCurrDSName=tRS.Get("data_structure")  $$$ASSERTNOLOG(tCurrDSName'="")
		Set tCurrDS=":"_..cleanType(tCurrDSName)
		Continue:":"=tCurrDS
		If tCurrDSName'=tPrevDSName {
			#; Wrap up previous DataType
			#;  specially handle CE table structures
			If "CE_"=$E(tPrevDSName,1,3)
			 && (^EnsHL71.Schema.DataTypes(pVersion,tPrevDS)=^EnsHL71.Schema.DataTypes(pVersion,":CE"))
			 && (+$P(^EnsHL71.Schema.DataTypes(pVersion,tPrevDS,"tables",1),":",3)=+$E(tPrevDS,5,$L(tPrevDS)))
			  {
				Set ^EnsHL71.Schema.DataTypes(pVersion,":CE","tablelist")=^EnsHL71.Schema.DataTypes(pVersion,":CE","tablelist")_^EnsHL71.Schema.DataTypes(pVersion,tPrevDS,"tables",1)_"~"
				Kill ^EnsHL71.Schema.DataTypes(pVersion,tPrevDS)
				Kill ^EnsHL71.Schema.Descriptions("DataType",pVersion,tPrevDS)
			} Elseif "CE"=tCurrDSName { Set ^EnsHL71.Schema.DataTypes(pVersion,":CE","tablelist")="" }
			Set iComp=1
			Kill tUpperNames

			#; Start new DataType
			Write " "_tCurrDS
			$$$ASSERTNOLOG(tCurrDS=":CE"||'+$D(^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)))
			Set ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)=""
			Set tPrevDS=tCurrDS, tPrevDSName=tCurrDSName
		}
		Set tIndex=tRS.Get("seq_no")
		$$$ASSERTNOLOG(iComp<=tIndex)
		While iComp<tIndex {
			Set ^EnsHL71.Schema.Descriptions("DataType",pVersion,tCurrDS,iComp)="<undefined>"
			Set ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)=^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)_$LB($LB("","","",""))
			Set tName=..componentDescToName("<undefined>",$E(tCurrDS,2,$L(tCurrDS)),iComp)
			$$$ASSERTNOLOG(0=$D(^EnsHL71.Schema.DataTypes(pVersion,tCurrDS,"names",tName)))
			$$$ASSERTNOLOG(0=$D(tUpperNames($ZCVT(tName,"U"))))
			Set tUpperNames($ZCVT(tName,"U"))=""
			Set ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS,"names",tName)=iComp
			Set iComp=iComp+1
		}
		Set tDesc=..cleanDesc(tRS.Get("description"))
		Set:":MA"=tCurrDS&&(6=iComp)&&("sample 2 from channel 1"=tDesc) tDesc="sample 2 from channel 3" ; fix this typo in 2.3.1

		Set tName=..componentDescToName(tDesc,$E(tCurrDS,2,$L(tCurrDS)),iComp)

		Set:""=tDesc tDesc="<no description (component "_iComp_")>"
		
	
		Set tType = ..cleanType(tRS.Get("data_type_code")) 
		Set:""'=tType tType=pVersion_":"_tType

		; component min and max lengths
		Set tMaxLen=+tRS.Get("length")
		Set:(tMaxLen=0) tMaxLen=+tRS.Get("max_length")
		Set tMinLen=+tRS.Get("min_length")
		If ((tMinLen=0) && (tMaxLen=0)) {
			Set tLengths = tRS.Get("length_old")
			Set tMaxLen = +$P(tLengths,".",*)
			If (tLengths[".") {
				Set tMinLen= +$P(tLengths,".")
			}
		}
		Set:(tMaxLen = 0) tMaxLen = ""
		Set:(tMinLen = 0) tMinLen = ""
		
		; component optionality
		Set tOpt = tRS.Get("req_opt")
		Set option = 0
		Set:((tOpt '= "") && (tOpt '= $c(0))) option = 1
		
		set tList = $LB(tType, tMinLen, tMaxLen ,$S(option:tOpt,1:""))
		
		Set ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)=^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)_$LB(tList)
		Set:""'=tDesc ^EnsHL71.Schema.Descriptions("DataType",pVersion,tCurrDS,iComp)=tDesc
		Set tTableId=+tRS.Get("table_id")
		; If the data struct does not override the table, look through to the default table associated with the component type
		Set:0=tTableId tTableId=tRS.Get("table_id_2") ;_"d"

		$$$ASSERTNOLOG(0=$D(^EnsHL71.Schema.DataTypes(pVersion,tCurrDS,"names",tName)))
		$$$ASSERTNOLOG(0=$D(tUpperNames($ZCVT(tName,"U"))))
		Set tUpperNames($ZCVT(tName,"U"))=""
		Set ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS,"names",tName)=iComp
		Set:0'=+tTableId ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS,"tables",iComp)=pVersion_":"_tTableId
		
		//!Set ^EnsHL71.Schema.Descriptions("DataStructure",pVersion,tCurrDS,"IDs",iComp)=tRS.Get("comp_no")
		Set iComp=iComp+1
	}
	If $D(^EnsHL71.Schema.DataTypes(pVersion,":CE","tablelist")) {
		Set $E(^EnsHL71.Schema.DataTypes(pVersion,":CE","tablelist"),*)="" ; remove trailing "~"
	}
	Kill tRS,iComp,tUpperNames
	// -----------------------------------------
	// build the elementary data structures for HL7 versions 2.1 - 2.4
	If tVersionId <= 5 {
		Set tSQL="SELECT *"_
			" FROM HL7DataStructures"_
			" WHERE version_id="_tVersionId_""_
			" AND elementary = 1;"
		Set tRS=tMe.GetRS(tSQL)
		While tRS.Next() {
			Set tCurrDS=":"_$ZCVT(tRS.Get("data_type_code"),"U")
			s ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS) = $lb($lb("",0,"",""))
			Set tDesc=..cleanDesc(tRS.Get("description"))
			Set tName=..componentDescToName(tDesc,$E(tCurrDS,2,$L(tCurrDS)),1)
			Set ^EnsHL71.Schema.Descriptions("DataType",pVersion,tCurrDS,1)=tDesc
			Set ^EnsHL71.Schema.Descriptions("DataType",pVersion,tCurrDS)=tDesc
			Set ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS,"names",tName)=1
		}
		Kill tRS
	}
	// -----------------------------------------
	Write !,!,"Building ^EnsHL71.Schema.SegmentStructures fields schema for HL7 "_pVersion
	Kill ^EnsHL71.Schema.SegmentStructures(pVersion)
	Kill ^EnsHL71.Schema.Descriptions("SegmentStructure",pVersion)
	Set tSQL="SELECT HL7SegmentDataElements.*, HL7DataElements.* "_
			" FROM HL7SegmentDataElements INNER JOIN HL7DataElements ON (HL7SegmentDataElements.data_item = HL7DataElements.data_item) AND (HL7SegmentDataElements.version_id = HL7DataElements.version_id)"_
			" WHERE HL7SegmentDataElements.version_id="_tVersionId_""_
			" ORDER BY HL7SegmentDataElements.seg_code, HL7SegmentDataElements.seq_no;"
	Set tRS=tMe.GetRS(tSQL)
	//req_opt, repetitions, repetitional, seg_code, seq_no, description, data_item, length, table_id, data_structure, version_id, usage
	Write !,"SegmentStructures:"
	Set tPrevSeg="" While tRS.Next() {
		Set tCurrSeg=":"_tRS.Get("seg_code")  $$$ASSERTNOLOG(tCurrSeg'=":")
		If tCurrSeg'=tPrevSeg {
			#; Wrap up previous Segment
			Set iField=1
			Kill tUpperNames

			#; Start new Segment
			Write " "_tCurrSeg
			$$$ASSERTNOLOG('+$D(^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg)))
			Set ^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg)=""
			Set tPrevSeg=tCurrSeg
		}
		Set tIndex=tRS.Get("seq_no")

		Set tTableId=+tRS.Get("table_id")
		Set tType=tRS.Get("data_structure")
		If "CE_"=$E(tType,1,3)   { Set tNum=$E(tType,4,$L(tType)) If ""=$P(tNum,"+",2)&&+tNum {
			If 0=+tTableId { Set tTableId=tNum }
			ElseIf +tTableId'=+tNum { Set tNum=tTableId  Write !,"*** WARNING - CE type "_tType_" uses table '"_tTableId_"' that doesn't match",! }
			Set:+tTableId=+tNum tType="CE"
		} }
		Set tType=":"_..cleanType(tType)
		If ":"'=tType&&'+$D(^EnsHL71.Schema.DataTypes(pVersion,tType)) {
			Write !," *** WARNING - Segment '"_tCurrSeg_"' uses undefined Data Type "_tType_" in field "_iField_".",!
			Set tFieldVer=pVersion //"00"
		} Else { Set tFieldVer=pVersion }
		
		; field min and max lengths
		Set tMaxLength=+tRS.Get("length")
		Set:(tMaxLength=0) tMaxLength=+tRS.Get("max_length")
		Set tMinLength=+tRS.Get("min_length")
		If ((tMinLength=0) && (tMaxLength=0)) {
			Set tLengths = tRS.Get("length_old")
			Set tMaxLength = +$P(tLengths,".",*)
			If (tLengths[".") {
				Set tMinLength = +$P(tLengths,".")
			}
		}
		Set:(tMaxLength = 0) tMaxLength = ""
		Set:(tMinLength = 0) tMinLength = ""
		
		Set tRepeats=$Case(tRS.Get("repetitional"),"Y":1,"1":1,:0)
		Set tReq=tRS.Get("req_opt")
		Set tSymbol=$Case(tReq,
						"O":"",  	; optional
						"R":    	$S(tRepeats:"+",1:"!"), ; Required
						"B":"",  	; Back-compatibility only
						"(B) R":"", ; Required Back-compatible?
						"C":    	$S(tRepeats:"&",1:"?"),  ; conditional
						"X":"",  	; ?? eXtended optional?
						:"")
		Set:""=tSymbol&&tRepeats tSymbol="*"

		Set tRepeatCount=tRS.Get("repetitions")  Set:0=tRepeatCount||'tRepeats tRepeatCount="" 
		//!Set:0'=tLength tRepeatCount=tRepeatCount_":"_tLength
		//!Set tSymbol=tRepeatCount_tSymbol

		//!Set:""'=tSymbol tType=tType_"_"_tSymbol
		Set tDesc=..cleanDesc(tRS.Get("description"))
		//!Set:":"'=tType tDesc=tDesc_"~"_tType

		Set tName=..fieldDescToName(tDesc,$E(tCurrSeg,2,$L(tCurrSeg)),iField)

		Set tList=$LB($S(":"=tType:"",1:tFieldVer_":"_tType),tSymbol,tRepeatCount,tMaxLength,tReq,tRepeats, tMinLength) //!

		$$$ASSERTNOLOG(iField<=tIndex)
		While iField<tIndex { Set iField=iField+1 Set ^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg)=^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg)_$LB("") }

		Set tiField=iField //$S(":MSH"=tCurrSeg:iField-1,1:iField)
		If tiField>0 {
			Set ^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg)=^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg)_$LB(tList)
			Set:""'=tDesc ^EnsHL71.Schema.Descriptions("SegmentStructure",pVersion,tCurrSeg,tiField)=tDesc
	
			$$$ASSERTNOLOG(0=$D(^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg,"names",tName)))
			$$$ASSERTNOLOG(0=$D(tUpperNames($ZCVT(tName,"U"))))
			Set tUpperNames($ZCVT(tName,"U"))=""
			Set ^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg,"names",tName)=tiField
			Set:0'=tTableId ^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg,"tables",tiField)=pVersion_"::"_tTableId
			//!Set ^EnsHL71.Schema.Descriptions("SegmentStructure",pVersion,tCurrSeg,"IDs",tiField)=tRS.Get("data_item")
		}
		Set iField=iField+1
	}
	Kill tRS,iField,tUpperNames
	
	// -----------------------------------------
	Write !,!,"Building ^EnsHL71.Schema.MessageStructures segments schema for HL7 "_pVersion
	Kill ^EnsHL71.Schema.MessageStructures(pVersion)
	Kill ^EnsHL71.Schema.Descriptions("MessageStructure",pVersion)
	Set tSQL="SELECT *"_
			" FROM HL7MsgStructIDSegments"_
			" WHERE version_id="_tVersionId_""_
			" ORDER BY message_structure,seq_no;"
 	Set tRS1=tMe.GetRS(tSQL)
	Set tSQL="SELECT *"_
			" FROM HL7EventMessageTypeSegments "_
			" WHERE version_id="_tVersionId_""_
			" ORDER BY message_type,event_code,seq_no;"
 	Set tRS2=tMe.GetRS(tSQL)
  // message_structure,        seq_no, seg_code, repetitional, optional, version_id
  // event_code, message_type, seq_no, seg_code, repetitional, optional, version_id
	Write !,"MessageStructures:"
	Set tRS=tRS1, (tPrevMsg,tPrevMsgWarning,tDupMsg)="" While 1 {
		If 'tRS.Next() Quit:tRS=tRS2  Write !  Set tRS=tRS2  Quit:'tRS.Next()
		Set tCurrMsg=":"_$S(tRS=tRS2:tRS.Get("message_type")_"_"_tRS.Get("event_code"),1:tRS.Get("message_structure"))  $$$ASSERTNOLOG(tCurrMsg'="")
		// Fix typo in tables
		Set:tCurrMsg=":R0R_R0R" tCurrMsg=":ROR_ROR"
		If tCurrMsg'=tPrevMsg {
			#; Wrap up previous Message
			Set:""'=tDupMsg $E(^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg),$L(^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg)))="" ; remove trailing "~"
			#;  specially handle ACK messages
			If ":ACK_"=$E(tDupMsg,1,5) {
				If '$D(^EnsHL71.Schema.MessageStructures(pVersion,":ACK")) {
					Set ^EnsHL71.Schema.MessageStructures(pVersion,":ACK")=pVersion_"::MSH~"_pVersion_"::MSA~[~"_pVersion_"::ERR~]"
					Write !,"*** WARNING - Added base ACK structure "_^EnsHL71.Schema.MessageStructures(pVersion,":ACK"),!
				}
				If ^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg)=^EnsHL71.Schema.MessageStructures(pVersion,":ACK") {
					Kill ^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg)
				}
			}
			Set iSeg=1
	
			#; Start new Message
			If +$D(^EnsHL71.Schema.MessageStructures(pVersion,tCurrMsg)) {
				Set tDup=$I(^EnsHL71.Schema.MessageStructures(pVersion,tCurrMsg,"dups"))
				Set tDupMsg = tCurrMsg_"."_tDup
				Set ^EnsHL71.Schema.MessageStructures(pVersion,tCurrMsg,"dups",tDup)=tDupMsg
				Write !,"*** WARNING - overloading duplicate definition of segment structure "_tCurrMsg_" As "_tDupMsg,!
			} Else { Set tDupMsg=tCurrMsg }
			Write " "_tDupMsg
			Kill tSegs  Set tSegLevel=0
			Set ^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg)=""
			Set tPrevMsg=tCurrMsg
		}
		Set tSeg=tRS.Get("seg_code")
		Set tSeg=$Case(tSeg,"[{":"[~{","}]":"}~]",:tSeg)
		#; Annotate duplicate segments within a given scope level.
		Set tPrevSegLevel=tSegLevel, tSegType=$Case(tSeg,"[~{":2,"}~]":-2,"[":1,"{":1,"<":1, "]":-1,"}":-1,">":-1, :0), tSegLevel=tSegLevel+tSegType
		Kill:tSegLevel<tPrevSegLevel tSegs(tPrevSegLevel) Set tPrevSegLevel=tSegLevel
		If (0=tSegType) && (tSeg'="|") {
			Set iDupSeg=$I(tSegs(tSegLevel,tSeg))
			If iDupSeg>1 {
				//Set tSeg=tSeg_"i"_iDupSeg
				Write:tDupMsg'=tPrevMsgWarning !
				Write " ** WARNING - Duplicate segment "_tSeg_" in Message Structure '"_tDupMsg_"' position "_iSeg_" at level "_tSegLevel_".",!
				Set tPrevMsgWarning=tDupMsg
			}
		}
		If '($Case(tSeg,"Z..":1,"Zxx":1,"Hxx":1,"[~{":1,"}~]":1,"[~{":1,"}~]":1,"{":1,"}":1,"[":1,"]":1,"<":1,">":1,"|":1,"?":1,:0) || +$D(^EnsHL71.Schema.SegmentStructures(pVersion,":"_$P(tSeg,"i")))) {
			Write !," *** WARNING - Message Structure '"_tDupMsg_"' uses undefined segment "_tSeg_" at position "_iSeg_" at level "_tSegLevel_".",!
			Set tSegVer=pVersion //"00"
		} Else { Set tSegVer=pVersion }
		Write:$Case(tSeg,"Z..":1,"Zxx":1,"Hxx":1,"|":1,"?":1,:0) !,"seg("_tSeg_")"
 //! for type ADT_A37 ; Fix proper 2.3 MFK_M01(.1) 
		If tSeg'=$E(tSeg)&&'$Case(tSeg,"[~{":1,"}~]":1,:0) {
			Set tSeg=tSegVer_"::"_tSeg
		
			Set tRepeats=''tRS.Get("repetitional")
			Set tOptional=''tRS.Get("optional")
	
			Set:tRepeats tSeg="{~"_tSeg_"~}"
			Set:tOptional tSeg="[~"_tSeg_"~]"
		}
		Set tIndex=tRS.Get("seq_no")
		$$$ASSERTNOLOG(iSeg<=tIndex)

		Set ^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg)=^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg)_tSeg_"~"

		Set:0'=tTableId ^EnsHL71.Schema.MessageStructures(pVersion,tDupMsg,"tables",iSeg)=pVersion_"::"_tTableId
		//!Set ^EnsHL71.Schema.Descriptions("MessageStructure",pVersion,tDupMsg,"specid",iSeg)=tIndex
		Set iSeg=iSeg+1
	}
	Set:""'=tPrevMsg $E(^EnsHL71.Schema.MessageStructures(pVersion,tPrevMsg),$L(^EnsHL71.Schema.MessageStructures(pVersion,tPrevMsg)))="" ; remove trailing "~"
	Kill tRS,tRS1,tRS2, iSeg

	#; Build a signatures map
	Do ..buildSigMap(pVersion,.tSignatures)
	
	// -----------------------------------------
	Write !,!,"Building ^EnsHL71.Schema.MessageTypes relations schema for HL7 "_pVersion
	Kill ^EnsHL71.Schema.MessageTypes(pVersion)
	Kill ^EnsHL71.Schema.Descriptions("MessageType",pVersion)
	Set tSQL="SELECT *"_
			" FROM HL7EventMessageTypes"_
			" WHERE version_id="_tVersionId_""_
			" ORDER BY message_typ_snd,event_code,seq_no;"
 	Set tRS=tMe.GetRS(tSQL)
  // event_code, message_typ_snd, seq_no, message_typ_return, message_structure_snd, message_structure_return, version_id
	Write !,"MessageTypes:"
	Set tPrevMsg="" While tRS.Next() {
		Set tCurrMsg=":"_tRS.Get("message_typ_snd")_"_"_tRS.Get("event_code")  $$$ASSERTNOLOG(tCurrMsg'=":")
		// Fix typo in tables
		Set:tCurrMsg=":ROR_R0R" tCurrMsg=":ROR_ROR"
		Set tIndex=tRS.Get("seq_no")
		Set:+tIndex>1 tCurrMsg=tCurrMsg_"_"_tIndex
		$$$ASSERTNOLOG(tCurrMsg'=tPrevMsg)
		#; Start new Message
		Write " "_tCurrMsg
		$$$ASSERTNOLOG('+$D(^EnsHL71.Schema.MessageTypes(pVersion,tCurrMsg)))
		Set tPrevMsg=tCurrMsg

		Set tStructure=":"_tRS.Get("message_structure_snd")
		Set:tStructure=":?" tStructure=tCurrMsg
		
		#; Warnings (not Asserts)
		If '($Case(tStructure,":NUL":1,":?":1,:0)||+$D(^EnsHL71.Schema.MessageStructures(pVersion,tStructure))) {	//,":MFN_M07":1,":ROR_ROR":1,":QRY_R04":1
			Write !,!," ** WARNING - Structure '"_tStructure_"' of Message '"_tCurrMsg_"' not found in MessageStructures list"
			If +$D(^EnsHL71.Schema.MessageStructures(pVersion,tCurrMsg)) {
				Write " (but base Message '"_tCurrMsg_"' is.)"
				Set tVerStruct=pVersion_":"_tCurrMsg
			} Else {
				Set tVerStruct=pVersion_":"_tStructure //"00:"_tStructure
			}
			Write !,!
		} Else { Set tVerStruct=$Case(tStructure,":NUL":"",":?":"",:pVersion_":"_tStructure) }
		Set ^EnsHL71.Schema.MessageTypes(pVersion,tCurrMsg)=tVerStruct

		Set tRetType=":"_tRS.Get("message_typ_return")
		Set:":NUL"'=tRetType tRetType=tRetType_"_"_tRS.Get("event_code")
		Set tRetTypeOut=$S(":NUL"'=tRetType:pVersion_":"_tRetType,1:"")
		Set:""'=tRetTypeOut ^EnsHL71.Schema.MessageTypes(pVersion,tCurrMsg,"rettype")=tRetTypeOut

		Set tRetStructure=":"_tRS.Get("message_structure_return")
		Set:tRetStructure=":?"&&(":NUL"'=tRetType) tRetStructure=tRetType

		If +$D(^EnsHL71.Schema.MessageStructures(pVersion,tRetType)) {
			Write:tRetStructure'=tRetType !,"*** WARNING - Using structure of return type '"_tRetType_"' that exists and does not match declared return structure '"_tRetStructure_"'."
			Set tRetStructure=tRetType
		}
		If '($Case(tRetStructure,":NUL":1,":?":1,:0)||+$D(^EnsHL71.Schema.MessageStructures(pVersion,tRetStructure))) { //,":ORF_R02":1
			Write !,!," ** WARNING - Return structure '"_tRetStructure_"' of Message '"_tCurrMsg_"' not found in MessageStructures list"
			If ($Case(tRetType,":NUL":1,":?":1,:0)||+$D(^EnsHL71.Schema.MessageStructures(pVersion,tRetType))) {
				Write " (but base Message return type '"_tRetType_"' is.)"
				Set tVerRetStruct=pVersion_":"_tRetType
			} Else {
				Set tVerRetStruct=pVersion_":"_tRetStructure // "00:"_tRetStructure
			}
			Write !,!
		} Else { Set tVerRetStruct=$S(":NUL"'=tRetStructure:pVersion_":"_tRetStructure,1:"") }
		Set:""'=tVerRetStruct ^EnsHL71.Schema.MessageTypes(pVersion,tCurrMsg,"retstruct")=tVerRetStruct

		Set tStructUsed(tStructure)=tCurrMsg
		Set tStructUsed(tRetStructure)=tRetType
		$$$ASSERTNOLOG((":NUL"=tStructure||'$D(tMsgStructs(tCurrMsg)))&&(":NUL"=tRetStructure||'$D(tMsgStructs(tRetType))))
		Set tMsgStructs(tCurrMsg)=tStructure
		Set tMsgStructs(tRetType)=tRetStructure

		#; Add Return Types to the list
		If ":NUL"'=tRetType&&(":ACK"'=$E(tRetType,1,4))&&'$D(^EnsHL71.Schema.MessageTypes(pVersion,tRetType))  {
			Set tRetTypes("<"_tRetType)=$S(":NUL"'=tRetStructure:pVersion_":"_tRetStructure,1:"")
		}
		#; Add Return Structures to the list
		If ":NUL"'=tRetStructure&&'$D(^EnsHL71.Schema.MessageTypes(pVersion,tRetStructure))  {
			Set tRetTypes("-"_tRetStructure)=pVersion_":"_tRetStructure
		}
	}
	Kill tRS, iSubType

	#; Really add Return types now
	Set tType="" For { Set tType=$O(tRetTypes(tType)) Quit:""=tType
		Set tRetType=$E(tType,2,$L(tType))
		If '$D(^EnsHL71.Schema.MessageTypes(pVersion,tRetType))&&(tRetType'="") {
			Set ^EnsHL71.Schema.MessageTypes(pVersion,tRetType)=tRetTypes(tType)
			Write " "_tType
		}
	}
	#; Pass over types and get rid of "retstruct" nodes
	Set tType="" For { Set tType=$O(^EnsHL71.Schema.MessageTypes(pVersion,tType)) Quit:""=tType
		Set tRetType=$G(^EnsHL71.Schema.MessageTypes(pVersion,tType,"rettype"))
		Set tRetStruct=$G(^EnsHL71.Schema.MessageTypes(pVersion,tType,"retstruct"))
		Kill ^EnsHL71.Schema.MessageTypes(pVersion,tType,"retstruct")
		//If tRetStruct'=$G(^EnsHL71.Schema.MessageTypes(pVersion,tRetType)) && ("ACK_"'=$E($P(tRetType,":",3),1,4)) {
			If 0 { // !!!
				Set ^EnsHL71.Schema.MessageTypes(pVersion,tRetType)=tRetTypes(tType)
			}
		//}
	}
	Kill tRetTypes

	// -----------------------------------------
	#; Add structures from the Message Structures list into the types list
	#; - unless they duplicate another structure; then kill them
	Set tType="" For  { Set tType=$O(^EnsHL71.Schema.MessageStructures(pVersion,tType)) Quit:""=tType
		If '$D(tStructUsed(tType)) {
			Set tDeclStruct=$G(^EnsHL71.Schema.MessageTypes(pVersion,tType)), tDeclStruct=$P(tDeclStruct,":",2,$L(tDeclStruct,":"))

			#; Remove unused duplicate types from the Message Structures list
			Set tSig=^EnsHL71.Schema.MessageStructures(pVersion,tType)
			Set tList=..getSigTypes(.tSignatures,tSig) For i=1:1:$L(tList,"/") { Set tStruct=$P(tList,"/",i) Continue:""=tStruct
				If ""=tDeclStruct { Quit:tStruct'=tType&&$D(tStructUsed(tStruct)) }
				Else { Quit:tStruct=tDeclStruct }
			}
			If ""'=tStruct { ; found a duplicate signature for an unused Structures entry
				// Kill it from the structures list; use the equivalent structure we found.
				If ""'=tDeclStruct  {
					$$$ASSERTNOLOG(tDeclStruct=tStruct)
					Write !,"*** WARNING - Ignoring structure '"_tType_"' because the corresponding message type declares the equivalent structure '"_tDeclStruct_"'."
				} Else {
					Write !,"** WARNING - Ignoring unused structure '"_tType_"' because an equivalent "_$S($D(tStructUsed(tStruct)):"used ",1:"")_"structure '"_tStruct_"' exists."
					Set:'$D(tStructUsed(tStruct)) tStructUsed(tStruct)=tType
				}
				Write " "_tType_">"_tStruct
				Kill ^EnsHL71.Schema.MessageStructures(pVersion,tType)
				Set tType=tStruct ; add the duplicate struct as a type if it's not there already
			} Else { ; no duplicate signature
				If ""'=tDeclStruct  {
					Write !,"*** WARNING - Ignoring declared structure '"_tDeclStruct_"' for type '"_tType_"' because its signature does not match that of its same-named structure '"_tType_"'."
					Set ^EnsHL71.Schema.MessageTypes(pVersion,tType)=pVersion_":"_tType
				}
				If 0 { //!!! find type that declares this as return struct
					Write !,"*** WARNING - Ignoring declared return structure '"_tDeclRetStruct_"' for type '"_tRetDeclType_"' because its signature does not match that of its same-named structure."
					Set ^EnsHL71.Schema.MessageTypes(pVersion,tRetDeclType,"retstruct")=pVersion_":"_tType
				}
				; Add unused structure to types list
				Set tStruct=tType
			}
			If '$D(^EnsHL71.Schema.MessageTypes(pVersion,tType))  {
				#; Add the type to the MessageTypes table
				Write " +"_tType
				Set ^EnsHL71.Schema.MessageTypes(pVersion,tType)=pVersion_":"_tStruct
				//Set ^EnsHL71.Schema.MessageTypes(pVersion,tType,"retstruct")="?"
				Set ^EnsHL71.Schema.MessageTypes(pVersion,tType,"rettype")="?"
	
				$$$ASSERTNOLOG(("NUL"=tStruct||'$D(tMsgStructs(tType))))
				Set tStructUsed(tStruct)=tType
				Set tMsgStructs(tType)=tStruct
			}
		} Elseif ":NUL"'=tType&&'$D(^EnsHL71.Schema.MessageTypes(pVersion,tType))  {
			#; Structure is used but is not a primary type - add it to the types list anyway.
			Set ^EnsHL71.Schema.MessageTypes(pVersion,tType)=pVersion_":"_tType
			Write " &"_tType
		}
	}
	// -----------------------------------------
	Write !,!,"Building ^EnsHL71.Schema.Descriptions(""MessageGroup"") table for HL7 "_pVersion
	Kill ^EnsHL71.Schema.Descriptions("MessageGroup",pVersion)
	Set tSQL="SELECT *"_
			" FROM HL7MessageTypes"_
			" WHERE version_id="_tVersionId_";"
 	Set tRS=tMe.GetRS(tSQL)
  // message_type, description, version_id
	Write !,"MessageType Descriptions:"
	While tRS.Next() {
		Set tCurrMsg=":"_tRS.Get("message_type") $$$ASSERTNOLOG(tCurrMsg'=":")
		Set tDesc=..cleanDesc(tRS.Get("description"))
		Set:""'=tDesc ^EnsHL71.Schema.Descriptions("MessageGroup",pVersion,tCurrMsg)=tDesc
		Write " "_tCurrMsg
	}
	Kill tRS

	// -----------------------------------------
	Write !,!,"Building ^EnsHL71.Schema.Descriptions(""MessageEvent"") table for HL7 "_pVersion
	Kill ^EnsHL71.Schema.Descriptions("MessageEvent",pVersion)
	Set tSQL="SELECT *"_
			" FROM HL7Events"_
			" WHERE version_id="_tVersionId_";"
 	Set tRS=tMe.GetRS(tSQL)
  // event_code, description, version_id
	Write !,"MessageType Descriptions:"
	While tRS.Next() {
		Set tCurrMsg=":"_tRS.Get("event_code") $$$ASSERTNOLOG(tCurrMsg'=":")
		Set tDesc=..cleanDesc(tRS.Get("description"))
		Set:""'=tDesc ^EnsHL71.Schema.Descriptions("MessageEvent",pVersion,tCurrMsg)=tDesc
		Write " "_tCurrMsg
	}
	Kill tRS

	// -----------------------------------------
	Write !,!,"Adding Descriptions to ^EnsHL71.Schema.Descriptions(""DataType"") table for HL7 "_pVersion
	Set tSQL="SELECT *"_
			" FROM HL7DataStructures"_
			" WHERE version_id="_tVersionId_";"
 	Set tRS=tMe.GetRS(tSQL)
  // data_structure, description, version_id
	Write !,"Segment Descriptions:"
	While tRS.Next() {
		Set tCurrDS=":"_tRS.Get("data_structure") $$$ASSERTNOLOG(tCurrDS'=":")
		Set tDesc=..cleanDesc(tRS.Get("description"))
		Set:""'=tDesc&&$D(^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)) ^EnsHL71.Schema.Descriptions("DataType",pVersion,tCurrDS)=tDesc
		Write " "_tCurrDS
	}
	Kill tRS
	
	// -----------------------------------------
	Write !,!,"Adding Descriptions to ^EnsHL71.Schema.Descriptions(""SegmentStructure"") table for HL7 "_pVersion
	Set tSQL="SELECT *"_
			" FROM HL7Segments"_
			" WHERE version_id="_tVersionId_";"
 	Set tRS=tMe.GetRS(tSQL)
  // seg_code, description, version_id
	Write !,"Segment Descriptions:"
	While tRS.Next() {
		Set tCurrSeg=":"_tRS.Get("seg_code") $$$ASSERTNOLOG(tCurrSeg'=":")
		Set tDesc=..cleanDesc(tRS.Get("description"))
		Set:tCurrSeg_" - "=(":"_$E(tDesc,1,6)) tDesc=$ZStrip($E(tDesc,7,$L(tDesc)),"<W")
		Set:""'=tDesc&&$D(^EnsHL71.Schema.SegmentStructures(pVersion,tCurrSeg)) ^EnsHL71.Schema.Descriptions("SegmentStructure",pVersion,tCurrSeg)=tDesc
		Write " "_tCurrSeg
	}
	Kill tRS
	
	// -----------------------------------------

	Write !,!,"Building ^EnsHL71.Schema.CodeTables for HL7 "_pVersion
	Kill ^EnsHL71.Schema.CodeTables(pVersion)
	Kill ^EnsHL71.Schema.Descriptions("CodeTable",pVersion)
	// Table Type Codes
	// 0	undefined
	// 1	User
	// 2	HL7
	// 3	HL7 and User
	// 4	no longer used
	// 5	replaced
	// 6	User Group /National Defined
	// 7	Imported
	// 8	Externally defined
	// -----------------------------------------
	Write !,!,"Adding Descriptions to ^EnsHL71.Schema.Descriptions(""CodeTable"") for HL7 "_pVersion
	Set tSQL="SELECT *"_
			" FROM HL7Tables"_
			" WHERE version_id="_tVersionId_";"
 	Set tRS=tMe.GetRS(tSQL)
  // table_id, description, table_typ, version_id
	Write !,"Table Descriptions:",!
	While tRS.Next() {
		Set tCurrTable=":"_tRS.Get("table_id") $$$ASSERTNOLOG(tCurrTable'=":")
		Set:":0"'=tCurrTable ^EnsHL71.Schema.CodeTables(pVersion,tCurrTable)=tRS.Get("table_type")
		Set tDesc = tRS.Get("description")
		Set:tDesc="" tDesc = tRS.Get("description_as_pub")
		Set tDesc=..cleanDesc(tDesc)
		Set:""'=tDesc&&(":0"'=tCurrTable) ^EnsHL71.Schema.Descriptions("CodeTable",pVersion,tCurrTable)=tDesc
		Write " "_tCurrTable
	}
	Kill tRS
	
	// -----------------------------------------
	Set tSQL="SELECT *"_
			" FROM HL7TableValues"_
			" WHERE version_id="_tVersionId_""_
			" ORDER BY table_id, sort_no;"
	Set tRS=tMe.GetRS(tSQL)
	Write !,"Tables:",!
	Set tPrevTable="" While tRS.Next() {
		Set tCurrTable=":"_tRS.Get("table_id")  $$$ASSERTNOLOG(tCurrTable'=":")
		If tCurrTable'=tPrevTable {
			Set iValue=1, tPrevIndex=0
			Write " "_tCurrTable
			Set tPrevTable=tCurrTable
			$$$ASSERTNOLOG($D(^EnsHL71.Schema.CodeTables(pVersion,tCurrTable)))
		}
		Set tIndex=+tRS.Get("sort_no")
		Set tNewIndex = $S(tIndex<(tPrevIndex+1):tPrevIndex+1,1:tIndex)
		Write:tNewIndex'=tIndex " Warning- adding offset "_(tNewIndex-tIndex)_" to index "_tIndex,!
		$$$ASSERTNOLOG(tNewIndex>=iValue)

		Set tVal=tRS.Get("table_value")  $$$ASSERTNOLOG(""'=tVal)
		$$$ASSERTNOLOG(0=+$D(^EnsHL71.Schema.CodeTables(pVersion,tCurrTable,tVal)))
		Set ^EnsHL71.Schema.CodeTables(pVersion,tCurrTable,tVal)=tNewIndex
		Set tDesc = tRS.Get("description")
		Set:(tDesc="") tDesc = tRS.Get("description_as_pub")
		Set tDesc=..cleanDesc(tDesc)
		Set:""'=tDesc ^EnsHL71.Schema.Descriptions("CodeTable",pVersion,tCurrTable,tVal)=tDesc

		Set iValue=iValue+1, tPrevIndex=tNewIndex
	}
	Kill tRS,iValue
	// -----------------------------------------
	Set tSQL="SELECT *"_
		" FROM HL7DataStructures"_
		" WHERE version_id="_tVersionId_""_
		" AND elementary = 1;"
	Set tRS=tMe.GetRS(tSQL)
	While tRS.Next() {
		Set tCurrDS=":"_$ZCVT(tRS.Get("data_type_code"),"U")
		Set data = $g(^EnsHL71.Schema.DataTypes(pVersion,tCurrDS))
		If data '= ""  {
			w !, "Removing component data type from elementary data type ",tCurrDS
			set comp = $lg(data,1)
			set min = $lg(comp,2)
			set max = $lg(comp,3)
			set opt = $lg(comp,4)
			set type = $lb("",min,max,opt)
			s ^EnsHL71.Schema.DataTypes(pVersion,tCurrDS)=$lb(type)
		}
	}
	Kill tRS
	w !,"Done!"
	// -----------------------------------------
shut
	Write !,"Disconnect: ",tGW.Disconnect()
	Quit
}

/// Build map of signatures to their respective structure names in a "/"-separated list
ClassMethod buildSigMap(pVersion, ByRef tSignatures)
{
	Set tType="" For  { Set tType=$O(^EnsHL71.Schema.MessageStructures(pVersion,tType)) Quit:""=tType
		Set tSig=^EnsHL71.Schema.MessageStructures(pVersion,tType)
		Set tSig200=$E(tSig,1,200), tSigI=$G(tSignatures(tSig200),0), tSigX=$E(tSig,201,$L(tSig))
		Set tDone=0  For i=1:1:tSigI { If tSigX=tSignatures(tSig200,i) Set tDone=1, tSignatures(tSig200,i,"types") = tSignatures(tSig200,i,"types")_tType_"/"  Quit }
		If 'tDone Set tSigI=tSigI+1, tSignatures(tSig200)=tSigI, tSignatures(tSig200,tSigI)=tSigX, tSignatures(tSig200,tSigI,"types")=tType_"/"
	}
	Quit
}

ClassMethod getSigTypes(ByRef tSignatures, tSig)
{
	Set tSig200=$E(tSig,1,200), tSigI=$G(tSignatures(tSig200),0), tSigX=$E(tSig,201,$L(tSig))
	Set tTypes=""  For i=1:1:tSigI { If tSigX=tSignatures(tSig200,i) Set tTypes=tSignatures(tSig200,i,"types")  Quit }
	Quit tTypes
}

ClassMethod Legend()
{
	Write !,"Legend for Segment Required/Repeating symbols :"
	Write !," symbol * - repeat 0 or more"
	Write !," symbol + - repeat 1 or more"
	Write !," symbol ! - required - 1 must be present"
	Write !," symbol ? - conditional; 1 must be present if condition is met"
	Write !," symbol & - conditional; 1 or more must be present if condition is met"
	Write !,"  1 <desc> = description,"
	Write !,"  2 <type> = datatype (if not string)"
	Write !,"  3 <sym>  = one of the above req/rep symbols (*+!?&)"
	Write !,"  4 <repc> = repeat count if any"
	Write !,"  5 <len>  = length if any"
	Write !,"  6 <req>  = raw HL7 DB 'required' field"
	Write !,"  7 <rep>  = repeating?"
	Write !
	Write !,"Legend for Table-Type Codes :"
	Write !," 0= undefined"
	Write !," 1= User"
	Write !," 2= HL7"
	Write !," 3= HL7 and User"
	Write !," 4= no longer used"
	Write !," 5= replaced"
	Write !," 6= User Group /National Defined"
	Write !," 7= Imported"
	Write !," 8= Externally defined"
	Quit
}

ClassMethod tableType(pType = "")
{
	Quit $Case($ZCVT(pType,"L"),
				"datastructurecomponents":1,
				"datastructcomponents":1,
				"datastructures":1,
				"datastructure":1,
				"datastructs":1,
				"datastruct":1,
				"datastrucs":1,
				"datastruc":1,
				"data":1,
				"datatype":1,
				"dt":1,
				"fieldcomponents":1,
				"fieldcomponent":1,
				"fieldtypes":1,
				"fieldtype":1,
				"field":1,
				"fld":1,
				"components":1,
				"component":1,
				"comp":1,
				"cmp":1,			

				"segment":2,
				"seg":2,
				"segments":2,
				"segs":2,
				"segmentfields":2,
				"segfields":2,
				"segflds":2,
				"fields":2,
				"flds":2,
				
				"messagestructures":3,
				"messagestructure":3,
				"msgstructures":3,
				"msgstructure":3,
				"msgstructs":3,
				"msgstruct":3,
				"msgstrucs":3,
				"msgstruc":3,
				"structs":3,
				"struct":3,
				"strucs":3,
				"struc":3,
				"messagestructuresegments":3,
				"messagesegments":3,
				"msgsegments":3,
				"messagesegs":3,
				"msgsegs":3,
				
				"messagetypes":4,
				"msgtypes":4,
				"msgtype":4,
				"msgtyp":4,
				"messages":4,
				"message":4,
				"msgs":4,
				"msg":4,
				"messagetypemessagestructures":4,
				"msgtypemsgstructures":4,
				
				"codetables":5,
				"codetable":5,
				"tables":5,
				"table":5,
				"codes":5,
				"code":5,

				:0)
}

ClassMethod List(pType = "", pVersion = "")
{
	If ""=pType {
		Write !  Do ..List("DataTypeComponents",pVersion)
		Write !  Do ..List("SegmentFields",pVersion)
		Write !  Do ..List("MessageStructureSegments",pVersion)
		Write !  Do ..List("MessageTypeMessageStructures",pVersion)
		Write !  Do ..List("CodeTables",pVersion)
		Quit
	}
	Set tTable=..tableType(pType)
	If tTable=0 Write "Unrecognized table type '"_pType_"'."  Quit
				
	Set tGbl=$Case(tTable,
					1:"^EnsHL71.Schema.DataTypes",
					2:"^EnsHL71.Schema.SegmentStructures",
					3:"^EnsHL71.Schema.MessageStructures",
					4:"^EnsHL71.Schema.MessageTypes",
					5:"^EnsHL71.Schema.CodeTables")
	Write !,$Name(@tGbl@(pVersion))_" ="  Write:tTable=5 !
	Set k="" For  { Set k=$O(@tGbl@(pVersion,k))  Quit:""=k
		Write " "_k
		Write:tTable=5 " "_@tGbl@(pVersion,k),!
	}
	Quit
}

ClassMethod Dump(pType = "", pNames = "", pVersion = "", pLevel = 1)
{
	If ""=pVersion {
		If pType="1"&&(pNames="") Do ..Legend() Quit
		Set k="" For  Set k=$O(^EnsHL7.Schema(k))  Quit:""=k  Write !  Do ..Dump(pType,pNames,k,pLevel+1) Set tDid1=1
		If '$G(tDid1) Write "No schema data loaded for any HL7 version"
		Quit
	}
	If pVersion'[":" Set pVersion=pVersion_":"
	If '+$D(^EnsHL7.Schema(pVersion)) Write "No schema data loaded for HL7 version "_pVersion  Quit
	If ""=pType {
		If ""=pNames { Do ..List(pType,pVersion) Quit }
		Else {
			Write !  Do ..Dump("DataStructureComponents",pNames,pVersion,pLevel+1)
			Write !  Do ..Dump("SegmentFields",pNames,pVersion,pLevel+1)
			Write !  Do ..Dump("MessageStructureSegments",pNames,pVersion,pLevel+1)
			Write !  Do ..Dump("MessageTypeMessageStructures",pNames,pVersion,pLevel+1)
			Write !  Do ..Dump("Code Tables",pNames,pVersion,pLevel+1)
			Quit
		}
	} 
	Set tTable=..tableType(pType)
	If tTable=0 Write "Unrecognized table type '"_pType_"'."  Quit
				
	Set tTableType=$Case(tTable,
					1:"DT",
					6:"DS",
					2:"SS",
					3:"MS",
					4:"MT",
					5:"CT")
	If ""=pNames { Do ..List(pType,pVersion) Quit }
	For i=1:1:$L(pNames,",") { For j=1:1:$L($P(pNames,",",i)," ")  {
		Set pName=$P($P(pNames,",",i)," ",j)
		Set tDescKey=$Case(tTable,1:"DS:",2:"SS:",3:"MS:",4:"MT:",5:"CT:",:"xx:")_pVersion_":"_pName
		Set tDesc=##class(EnsLib.HL7.Schema).GetDescription(tDescKey)
		Write !," Description("""_tDescKey_""")="_""""_tDesc_""""
		Set tList=$Case(tTable,
						1:$G(^EnsHL7.Schema(pVersion,tTableType,pName)),
						2:$G(^EnsHL7.Schema(pVersion,tTableType,pName)),
						3:"-"_$G(^EnsHL7.Schema(pVersion,tTableType,pName)),
						4:"-"_$G(^EnsHL7.Schema(pVersion,tTableType,pName)),
						5:"-"_$G(^EnsHL7.Schema(pVersion,tTableType,pName)))
		If "-"=$E(tList) {
			If "-"'=tList {
				Write !,"  "_$Name(^EnsHL7.Schema(pVersion,tTableType,pName))_"="_$E(tList,2,$L(tList))
				Do:pLevel<3 ..dumpSubnodes(pVersion,tTableType,pName,tTable)
			}
			Else { Write !,"  No schema information defined for defined for ^EnsHL7.Schema("""_pVersion_""","""_tTableType_""","""_pName_""")" }
		}
		Else { 
			If ""'=tList {
				Write !,"  ^EnsHL7.Schema("""_pVersion_""","""_tTableType_""","""_pName_""")="
				For iItem=1:1:$LL(tList) {
					Write !,"   "_iItem_": "_##class(EnsLib.HL7.Schema).GetDescription(tDescKey,iItem)
					If tTable=1 {
						Set tType=$LI(tList,iItem)
						Write $S(""=tType:"",1:" <type='"_tType_"'>")
					} Else {
						Set tAttrList=$LI(tList,iItem)
						For iPos=1:1:4 {
							Set tVal=$LI(tAttrList,iPos)
							Write:""'=tVal "  <"_$Case(iPos,1:"type",2:"sym",3:"repc",4:"len",5:"req",6:"rep",:"?")_"="_tVal_">"
						}
					}
				}
				Do:pLevel<3 ..dumpSubnodes(pVersion,tTableType,pName,tTable)
			}
			Else { Write !,"  No schema information defined for defined for ^EnsHL7.Schema("""_pVersion_""","""_tTableType_""","""_pName_""")" }
		}
		Write !
	}}
	Quit
}

ClassMethod dumpSubnodes(pVersion, ptableType, pName, pTable)
{
	Write !
	Set tBase=$Name(^EnsHL7.Schema(pVersion,pTableType,pName)), $E(tBase,$L(tBase))=""
	Set tNode = $Query(^EnsHL7.Schema(pVersion,pTableType,pName))
	While (tBase=$E(tNode,1,$L(tBase))) {
		Write !,"  "_tNode_"="_@tNode
		If pTable=5 && (@tNode=+@tNode) {
			Write " """_##class(EnsLib.HL7.Schema).GetDescription("CT:"_pVersion_":"_pName,$QS(tNode,3))_""""
		}
		// get next tNode
		Set tNode = $Query(@tNode)
	}
}

/// Export the HL7 globals used by the HL7 class generator / compiler
ClassMethod ExportSchemaGlobals(pFile As %String = {$$$envEnsembleDir_"packages\HL72\gbl\hl7tables.xml"})
{
	Set ary("^EnsHL71.Schema.DataTypes.GBL")=""
	Set ary("^EnsHL71.Schema.SegmentStructures.GBL")=""
	Set ary("^EnsHL71.Schema.MessageStructures.GBL")=""
	Set ary("^EnsHL71.Schema.MessageTypes.GBL")=""
	Set ary("^EnsHL71.Schema.CodeTables.GBL")=""
	Set ary("^EnsHL71.Schema.Descriptions.GBL")=""
	Write "'"_pFile_"'"
	Do $system.OBJ.Export(.ary,pFile)
}

ClassMethod KillVersion(pVersion As %String)
{
	If "all"=$ZCVT(pVersion,"L") {
		$$$KillRootNode(^EnsHL71.Schema.DataTypes)
		$$$KillRootNode(^EnsHL71.Schema.SegmentStructures)
		$$$KillRootNode(^EnsHL71.Schema.MessageStructures)
		$$$KillRootNode(^EnsHL71.Schema.MessageTypes)
		$$$KillRootNode(^EnsHL71.Schema.CodeTables)
		$$$KillRootNode(^EnsHL71.Schema.Descriptions)
		Quit
	}
	If '$D(^EnsHL71.Schema.MessageTypes(pVersion)) W "Version not found"  Quit
	Kill ^EnsHL71.Schema.DataTypes(pVersion)
	Kill ^EnsHL71.Schema.SegmentStructures(pVersion)
	Kill ^EnsHL71.Schema.MessageStructures(pVersion)
	Kill ^EnsHL71.Schema.MessageTypes(pVersion)
	Kill ^EnsHL71.Schema.CodeTables(pVersion)
	Kill ^EnsHL71.Schema.Descriptions("DataType",pVersion)
	Kill ^EnsHL71.Schema.Descriptions("SegmentStructure",pVersion)
	Kill ^EnsHL71.Schema.Descriptions("MessageStructure",pVersion)
	Kill ^EnsHL71.Schema.Descriptions("MessageType",pVersion)
	Kill ^EnsHL71.Schema.Descriptions("MessageGroup",pVersion)
	Kill ^EnsHL71.Schema.Descriptions("MessageEvent",pVersion)
	Kill ^EnsHL71.Schema.Descriptions("CodeTable",pVersion)
}

ClassMethod Regenerate(pVersions As %String = "2.1,2.2,2.3,2.3.1,2.4,2.5,2.5.1,2.6,2.7", pExport As %Boolean = 1, pExportDir As %String = {$$$envEnsembleDir_"packages\HL7\gbl\"}, pOneBigFile As %Boolean = 1, pDSN As %String)
{
	Set:pOneBigFile pExport=0
	Do:pExport ..KillVersion("All")
	Set tVersion=""  For i=1:1:$L(pVersions,",") {
		Do:""'=tVersion&&pExport ..KillVersion(tVersion)
		Set tVersion=$P(pVersions,",",i)
		Do ..ImportSchema(tVersion, pDSN)
		Do:pExport ..ExportSchemaGlobals(pExportDir_"hl7tables_"_$TR(tVersion,".:")_".xml")
	}
	Do:pOneBigFile ..UpgradeSchemaGlobal()
	//Do:pOneBigFile ..ExportSchemaGlobals(pExportDir_"hl7tables_all6.xml")
	Do ..KillVersion("All")
	If pOneBigFile {
		Do ..ExportNewSchemaGlobals(pExportDir_"hl7tables.xml")
		Do ..ExportXML(pVersions,"c:\temp\") ; override dir 
	}
}

ClassMethod ExportXML(pVersions As %String = "2.1,2.2,2.3,2.3.1,2.4,2.5", pExportDir As %String = {$$$envEnsembleDir_"packages\HL7\schema\"})
{
	Set tVersion=""  For i=1:1:$L(pVersions,",") {
		Set tVersion=$P(pVersions,",",i)
		Set tFile=pExportDir_"..\schema\hl7_"_$TR(tVersion,".:")_".xml"
		w "Exporting version "_tVersion_" to "_tFile,!
		Do ##class(EnsLib.HL7.SchemaXML).Export(tVersion,tFile)
	}
}

ClassMethod ImportXML(pVersions As %String = "2.1,2.2,2.3,2.3.1,2.4,2.5", pImportDir As %String = {$$$envEnsembleDir_"packages\HL7\schema\"})
{
	Set tVersion=""  For i=1:1:$L(pVersions,",") {
		Set tVersion=$P(pVersions,",",i)
		Set tFile=pImportDir_"..\schema\hl7_"_$TR(tVersion,".:")_".xml"
		w "Importing version "_tVersion_" from "_tFile,!
		Do ##class(EnsLib.HL7.SchemaXML).Import(tFile)
	}
}

/// convert to new global structures
ClassMethod UpgradeSchemaGlobal()
{
	for name="CodeTable","DataType","MessageStructure","MessageType","SegmentStructure" {
		set globals("^EnsHL71.Schema."_name_"s")="^EnsHL72.Schema."_name_"s"
		set globals("^EnsHL71.Schema.Descriptions("""_name_""")")="^EnsHL72.Schema.Descriptions("""_name_""")"
	}
	set globals("^EnsHL71.Schema.Descriptions(""MessageGroup"")")="^EnsHL72.Schema.Descriptions(""MessageGroup"")"
	set globals("^EnsHL71.Schema.Descriptions(""MessageEvent"")")="^EnsHL72.Schema.Descriptions(""MessageEvent"")"
	;
	set oldname="" for {
		set oldname=$o(globals(oldname)) quit:oldname=""
		set newname=globals(oldname)
		kill @newname
		set sub1="" for {
			set sub1=$o(@oldname@(sub1)) quit:sub1=""
			set sub23="" for {
				set sub23=$o(@oldname@(sub1,sub23)) quit:sub23=""
				set sub12=sub1_":"_$p(sub23,":",1)
				set sub3=$p(sub23,":",2)
				merge @newname@(sub12,sub3)=@oldname@(sub1,sub23)
			}
		}
		kill @oldname
	}
	do ..UpgradeSchemaGlobal2()
	do ..UpgradeSchemaGlobal3()
	do ..UpgradeSchemaGlobal4()
	quit
}

ClassMethod UpgradeSchemaGlobal2()
{
	set convert("CodeTable")="CT"
	set convert("DataType")="DT"
	set convert("MessageStructure")="MS"
	set convert("MessageType")="MT"
	set convert("SegmentStructure")="SS"
	set convert("MessageGroup")="MG"
	set convert("MessageEvent")="ME"
	;
	$$$KillRootNode(^EnsHL7.Schema)
	$$$KillRootNode(^EnsHL7.Description)
	;
	set name="" for {
		set name=$o(convert(name)) quit:name=""
		xecute "merge ^EnsHL73.Schema("""_convert(name)_""")=^EnsHL72.Schema."_name_"s"
		xecute "merge ^EnsHL73.Description("""_convert(name)_""")=^EnsHL72.Schema.Descriptions("""_name_""")"
		xecute "kill ^EnsHL72.Schema."_name_"s"
	}
	$$$KillRootNode(^EnsHL72.Schema.Descriptions)
	;
	quit
}

ClassMethod UpgradeSchemaGlobal3()
{
	$$$KillRootNode(^EnsHL7.Schema)
	$$$KillRootNode(^EnsHL7.Description)
	;
	set type="" for  {
		set type=$o(^EnsHL73.Schema(type)) quit:type=""
		set cat="" for  {
			set cat=$o(^EnsHL73.Schema(type,cat)) quit:cat=""
			merge ^EnsHL7.Schema(cat,type)=^EnsHL73.Schema(type,cat)
		}
	}
	set type="" for  {
		set type=$o(^EnsHL73.Description(type)) quit:type=""
		set cat="" for  {
			set cat=$o(^EnsHL73.Description(type,cat)) quit:cat=""
			merge ^EnsHL7.Description(cat,type)=^EnsHL73.Description(type,cat)
		}
	}
	$$$KillRootNode(^EnsHL73.Schema)
	$$$KillRootNode(^EnsHL73.Description)
	;
	quit
}

ClassMethod UpgradeSchemaGlobal4()
{
	$$$KillRootNode(^EnsHL74.Schema)
	$$$KillRootNode(^EnsHL74.Description)
	merge ^EnsHL74.Schema=^EnsHL7.Schema
	merge ^EnsHL74.Description=^EnsHL7.Description
	$$$KillRootNode(^EnsHL7.Schema)
	$$$KillRootNode(^EnsHL7.Description)

	set cat="" for  {
		set cat=$o(^EnsHL74.Schema(cat)) quit:cat=""
		set newcat=$p(..convert(cat_":"_"ABC"),":",1)
		merge ^EnsHL7.Schema(newcat)=^EnsHL74.Schema(cat)
		merge ^EnsHL7.Description(newcat)=^EnsHL74.Description(cat)
	}
	set cat="" for  {
		set cat=$o(^EnsHL7.Schema(cat)) quit:cat=""
		;
		set ms="" for  {
			set ms=$o(^EnsHL7.Schema(cat,"MS",ms)) quit:ms=""
			set struct=^EnsHL7.Schema(cat,"MS",ms)
			for i=1:1:$l(struct,"~") {
				set one=$p(struct,"~",i)
				if one[":" set one=..convert(one)
				set $p(struct,"~",i)=one
			}
			set ^EnsHL7.Schema(cat,"MS",ms)=struct
		}
		set mt="" for  {
			set mt=$o(^EnsHL7.Schema(cat,"MT",mt)) quit:mt=""
			set ^EnsHL7.Schema(cat,"MT",mt)=..convert(^EnsHL7.Schema(cat,"MT",mt))
			if $data(^EnsHL7.Schema(cat,"MT",mt,"rettype")) set ^EnsHL7.Schema(cat,"MT",mt,"rettype")=..convert(^EnsHL7.Schema(cat,"MT",mt,"rettype"))
		}
		set ss="" for  {
			set ss=$o(^EnsHL7.Schema(cat,"SS",ss)) quit:ss=""
			set struct=^EnsHL7.Schema(cat,"SS",ss)
			for i=1:1:$ll(struct) {
				set one=$li(struct,i)
				set $li(one,1)=..convert($li(one,1))
				set:$li(one,5)[$C(0) $li(one,5)=$TR($li(one,5),$C(0)_"_")
				set $li(struct,i)=one
			}
			set ^EnsHL7.Schema(cat,"SS",ss)=struct
			set tb="" for  {
				set tb=$o(^EnsHL7.Schema(cat,"SS",ss,"tables",tb)) quit:tb=""
				set ^EnsHL7.Schema(cat,"SS",ss,"tables",tb)=..convert(^EnsHL7.Schema(cat,"SS",ss,"tables",tb))
			}
		}
	}
	;
	$$$KillRootNode(^EnsHL74.Schema)
	$$$KillRootNode(^EnsHL74.Description)
	;
	quit
}

ClassMethod convert(pSchemaName) As %String
{
	if $l(pSchemaName,":")<3 quit pSchemaName
	set cat=$p(pSchemaName,":",1,2),name=$p(pSchemaName,":",3)
	set newcat=$tr(cat,":","_")
	if $e(newcat,$l(newcat))="_" set newcat=$e(newcat,1,$l(newcat)-1)
	quit newcat_":"_name
}

/// Export the HL7 new globals used by the HL7 class generator / compiler
ClassMethod ExportNewSchemaGlobals(pFile As %String = {$$$envEnsembleDir_"packages\HL7\gbl\hl7tables.xml"})
{
	Set ary("^EnsHL7.Schema.GBL")=""
	Set ary("^EnsHL7.Description.GBL")=""
	Write "'"_pFile_"'"
	Do $system.OBJ.Export(.ary,pFile)
}

/// Remove the data structure from the component of elementary data structures
ClassMethod elimType(pVersion = "2.7", pDSN = "HL7 2.7 MDB")
{
	Set tGW=##class(%SQLGatewayConnection).%New()
	Set tMe=..%New(), tMe.%Connection=tGW, tMe.BusinessHost=tMe, tMe.%ConfigName="x"
	Set tGW.DSN=pDSN
	Set tSC=tGW.Connect(tGW.DSN,"","",1)
	If $$$ISERR(tSC) {
		Set tNetErr=0, tSC=tMe.addErrorList(tSC,"",.tNetErr)
		Write !,"Connect to "_tGW.DSN_" failed: "_$$$StatusDisplayString(tSC)
		Quit
	}
	Write !,"Connected to "_tGW.DSN
	
	
	Write !,!,"Getting Versions list"
	Set tSQL="SELECT * FROM HL7Versions;"
	Set tRS=tMe.GetRS(tSQL)
	Write !,"Versions"
	While tRS.Next() {
		Set ver=tRS.Get("hl7_version")
		Set:ver tVersions(ver)=tRS.Get("version_id")
		Write " : "_ver_" ('"_tRS.Get("description")_"')"
	}
	Kill tRS
	Set tVersionId=$G(tVersions(pVersion))  If ""=tVersionId Write !,"Unsupported version "_pVersion
	
	
	
	Set tSQL="SELECT data_type_code"_
		" FROM HL7DataStructures"_
		" WHERE version_id="_tVersionId_""_
		" AND elementary = 1 ;"
	Set tRS=tMe.GetRS(tSQL)
	While tRS.Next() {
		Set dt=tRS.Get("data_type_code")
		Set data = $g(^EnsHL7.Schema(2.7,"DT",dt))
		If data '= "" {
			w !, "Removing component data structure from elementary data structure ",dt
			set comp = $lg(data,1)
			set min = $lg(comp,2)
			set max = $lg(comp,3)
			set opt = $lg(comp,4)
			set type = $lb("",min,max,opt)
			s ^EnsHL7.Schema(2.7,"DT",dt)=$lb(type)
		}
	}
}

ClassMethod diff(pVersion = "2.6", pDSN = "HL7 2.6 MDB")
{
	Set tGW=##class(%SQLGatewayConnection).%New()
	Set tMe=..%New(), tMe.%Connection=tGW, tMe.BusinessHost=tMe, tMe.%ConfigName="x"
	Set tGW.DSN=pDSN
	Set tSC=tGW.Connect(tGW.DSN,"","",1)
	If $$$ISERR(tSC) {
		Set tNetErr=0, tSC=tMe.addErrorList(tSC,"",.tNetErr)
		Write !,"Connect to "_tGW.DSN_" failed: "_$$$StatusDisplayString(tSC)
		Quit
	}
	Write !,"Connected to "_tGW.DSN
	
	
	Write !,!,"Getting Versions list"
	Set tSQL="SELECT * FROM HL7Versions;"
	Set tRS=tMe.GetRS(tSQL)
	Write !,"Versions"
	While tRS.Next() {
		Set ver=tRS.Get("hl7_version")
		Set:ver tVersions(ver)=tRS.Get("version_id")
		Write " : "_ver_" ('"_tRS.Get("description")_"')"
	}
	Kill tRS
	Set tVersionId=$G(tVersions(pVersion))  If ""=tVersionId Write !,"Unsupported version "_pVersion
	
	
	Set tSQL="SELECT *"_
			" FROM HL7MsgStructIDSegments"_
			" WHERE version_id="_tVersionId_""_
			" ORDER BY message_structure,seq_no;"
 	Set tRS1=tMe.GetRS(tSQL)
 	set structs = ""
 	While tRS1.Next() 
 	{ 
 		set structs(tRS1.Get("message_structure")) = 1 
 	}
 	
 	Set tSQL="SELECT *"_
			" FROM HL7EventMessageTypeSegments "_
			" WHERE version_id="_tVersionId_""_
			" ORDER BY message_type,event_code,seq_no;"
 	Set tRS2=tMe.GetRS(tSQL)
    While tRS2.Next() {
		set check = tRS2.Get("message_type")_"_"_tRS2.Get("event_code")
		if $d(structs(check))'=0 { w ! , check_" is in both tables!", ! }
    }
}

}
