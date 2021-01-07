/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Utilities to interact with the HL7 Annotation global
/// To use, first invoke %New(HL7 schema version), and on the created object,
/// call Loadxx and Savexx methods.
/// Contains methods to load and save annotations for various components
/// The load methods return (byref) a multi-dimensional array, with a top subscript
/// referencing the instance being annotated, and underneath that at least the
/// following:  <li>"Name" - a description for the instance
/// <li>"U" - annotated usage indicator: X not supported, S supported, P planned support
/// <li>"Note" - a plain text comment field.
/// <br> The U and Note nodes may be edited by calling apps, which would then
/// call the corresponding Save method to update the global.
/// Some load methods return additional nodes for display purposes.
/// Except for LoadMG, the load methods also return a "UC" node indicating the actual computed usage,
/// which is calculated by walking the HL7 tree structure.  It would never be higher than the annotated usage,
/// but gets determined by the best possible parent annotated usage path.
/// There are also Get**XML methods to output parts of the schema in XML format
/// These all take an argument pPlanned, and a byref argument to return a multidimensional variable,
/// which will contain an array of strings.  They will not include unsupported message
/// types and segments, and will only include planned ones if this argument is true
Class EnsLib.HL7.Annotation.Data Extends %RegisteredObject [ System = 4 ]
{

/// Export the entire set of annotation in compact format for packaging.
/// Not used anywhere, because we're using ExportXMLList^%apiOBJ instead
ClassMethod GetExportXML(pVersion, ByRef pData)
{
	Kill pData Set pData=1, pData(1)="<annotations version='"_pVersion_"'>"
	Set g="^EnsHL7.Annotation("""_pVersion_""")"
	Do onelev("MG"),onelev("MT"),twolev("MS"),twolev("SS"),twolev("DS")
	Set pData($I(pData))="</annotations>" QUIT

onelev(type)
	Set s=""
	FOR  {
		Set s=$O(@g@(type,s)) QUIT:s=""
		Set pData($I(pData))="<annotation type='"_type_"' subtype='' subscript='"_s_"' usage='"_$G(@g@(type,s,"U"),"S")_"'>"
		IF $G(@g@(type,s,"Note"))'="" {Set pData($I(pData))="<note><![CDATA["_@g@(type,s,"Note")_"]]></note>"}
		Set pData($I(pData))="</annotation>"
	}
	QUIT
twolev(type,subtype)
	Set subtype=""
	FOR {
		Set subtype=$o(@g@(type,subtype)) Q:subtype=""
		Set s=""
		FOR  {
			Set s=$O(@g@(type,subtype,s)) QUIT:s=""
			Set HSPRI=$G(@g@(type,subtype,s,"HSPRI"))
			Set:HSPRI'="" HSPRI=$ZCVT(HSPRI,"O","XML")
			Set pData($I(pData))="<annotation type='"_type_"' subtype='"_subtype_"' subscript='"_s_"' usage='"_$G(@g@(type,subtype,s,"U"),"S")_$S(HSPRI'="":"' HSPRI='"_HSPRI,1:"")_"'>"
			IF $G(@g@(type,subtype,s,"Note"))'="" {Set pData($I(pData))="<note><![CDATA["_@g@(type,subtype,s,"Note")_"]]></note>"} ///*** todo - is there a way to check this?
			Set pData($I(pData))="</annotation>"

		}
	}
	QUIT
}

/// logic to retrieve the printable name of an item.
Method GetName(pType, pItem) As %String
{
	IF ((pType="DS") && ($D(..Names("DT",pItem)))) QUIT $G(..Names("DT",pItem))
	IF pType'="MS" QUIT $G(..Names(pType,pItem))
	QUIT $G(..Names("MG",$P(pItem,"_")))_$S(pItem["_":" -"_$P($G(..Names("ME",$P(pItem,"_",2,999))),"-",2,99),1:"")
}

/// return base version (if this version doesn't inherit, returns this version)
Method GetBase() As %String
{
 Quit ..BaseVer
}

/// This retrieves a list of all supported and/or planned items, of  specified type
/// (where type is MS, MT, SS, etc.)
Method GetType(pPlanned, pType, ByRef pData)
{
	Kill pData s i="",psup="S" S:pPlanned psup="SP"
	F  {
		s i=$O(^EnsHL7.Annotation(..Version,"Index",pType,i),1,usage) Q:i=""
		IF psup[usage {S pData(i)=usage}
	}
}

/// The Get**XML methods are used to product an XML version of the annotation
/// report, by class ReportServerXML, for use with DocBook
Method GetMGXML(pPlanned, ByRef pData)
{
	DO ..LoadMG(.mgs)
	Kill pData Set pData=1, pData(1)="<MessageGroups>"
	Set mg="",psup="S" S:pPlanned psup="SP"
	FOR  {
		Set mg=$O(mgs(mg)) Q:mg=""
		IF psup'[mgs(mg,"U") Continue
		Set pData($I(pData))="<MessageGroup name='"_mg_"' description='"_mgs(mg,"Name")_$S(pPlanned:"' usage='"_mgs(mg,"U"),1:"")_"'>"
		Set:$G(mgs(mg,"Note"))'="" pData($i(pData))="<note><![CDATA["_$ZCVT(mgs(mg,"Note"),"O","XML")_"]]></note>"
		DO ..LoadMT(mg,.mts) Set mt=""
		FOR {
			Set mt=$O(mts(mt)) Q:mt=""
			IF psup'[mts(mt,"UC") Continue
			Set pData($I(pData))="<MessageEvent name='"_mt_"' structure='"_mts(mt,"MS")_"' description='"_mts(mt,"Name")_$S(pPlanned:"' usage='"_mts(mt,"UC"),1:"")_"'>"
			Set:$G(mts(mt,"Note"))'="" pData($i(pData))="<note><![CDATA["_$ZCVT(mts(mt,"Note"),"O","XML")_"]]></note>"
			Set pData($I(pData))="</MessageEvent>"
		}
		Set pData($I(pData))="</MessageGroup>"
	}
	Set pData($I(pData))="</MessageGroups>"
}

Method GetMSXML(pPlanned, ByRef pData)
{
	Kill pData Set pData=1,pData(1)="<MessageStructures>"
	Set ms="",psup="S" S:pPlanned psup="SP"
	DO ..GetType(pPlanned,"MS",.items)
	FOR  {
		Set ms=$O(items(ms),1,usage) Q:ms=""
		//Set pData($I(pData))="<MessageStructure name='"_ms_"' description='"_$G(..Names("ME",$P(ms,"_",2)))_$S(pPlanned:"' usage='"_usage,1:"")_"'>"
		Set pData($I(pData))="<MessageStructure name='"_ms_"' description='"_..GetName("MS",ms)_$S(pPlanned:"' usage='"_usage,1:"")_"'>"
		Do ..LoadMS(ms,.segs)
		FOR i=1:1:segs {
			IF psup'[segs(i,"UC") CONTINUE
			Set pData($I(pData))="<MessageComponent name='"_$ZCVT($TR($J("",($L(segs(i,"Path"),",")-1)*2)_segs(i,"Code")," ",$C(160)),"O","XML")
			Set pData(pData)=pData(pData)_"' description='"_$S(segs(i,"Type")'="SEG":"--- ",1:"")_segs(i,"Name")_$S(segs(i,"Type")="GRP":" begin",segs(i,"Type")="END":" end",1:"")
			Set pData(pData)=pData(pData)_$S(pPlanned:"' usage='"_segs(i,"UC"),1:"")_"'>"
			Set:$G(segs(i,"Note"))'="" pData($i(pData))="<note><![CDATA["_$ZCVT(segs(i,"Note"),"O","XML")_"]]></note>"
			s pData($I(pData))="</MessageComponent>"
		}
		Set pData($I(pData))="</MessageStructure>"
	}
	Set pData($I(pData))="</MessageStructures>"
}

Method GetSSXML(pPlanned, ByRef pData)
{
	Kill pData Set pData=1, pData(1)="<SegmentStructures>"
	Set ss="",psup="S" S:pPlanned psup="SP"
	DO ..GetType(pPlanned,"SS",.items)
	FOR  {
		Set ss=$O(items(ss),1,usage) Q:ss=""
		Set pData($I(pData))="<SegmentStructure name='"_ss_"' description='"_$G(..Names("SS",ss))_$S(pPlanned:"' usage='"_usage,1:"")_"'>"
		Do ..LoadSS(ss,.flds)
		For i=1:1:flds {
			Set u=flds(i,"U") Set:(usage="P")&(u="S") u="P" //field usage can't be better than segment usage
			IF psup'[u CONTINUE
			Set pData($I(pData))="<Field seq='"_i_"' description='"_$ZCVT(flds(i,"Name"),"O","XML")_$S(pPlanned:"' usage='"_u,1:"")
			Set:$G(flds(i,"HSPRI"))'="" pData(pData)=pData(pData)_"' HSPRI='"_$ZCVT(flds(i,"HSPRI"),"O","XML")
			Set pData(pData)=pData(pData)_"' codetable='"_flds(i,"CT")_"' datastruct='"_flds(i,"DS")_"' length='"_flds(i,"Len")_"' required='"_flds(i,"Req")_"' repeat='"_flds(i,"Rpt")_"'>"
			Set:$G(flds(i,"Note"))'="" pData($i(pData))="<note><![CDATA["_$ZCVT(flds(i,"Note"),"O","XML")_"]]></note>"
			Set pData($I(pData))="</Field>"
		}
		Set pData($I(pData))="</SegmentStructure>"
	}
	Set pData($I(pData))="</SegmentStructures>"
}

Method GetDSXML(pPlanned, ByRef pData)
{
	Kill pData Set pData=1, pData(1)="<DataStructures>"
	Set ds="",psup="S" S:pPlanned psup="SP"
	DO ..GetType(pPlanned,"DS",.items)
	FOR  {
		Set ds=$O(items(ds),1,usage) Q:ds=""
		Set pData($I(pData))="<DataStructure name='"_..BaseVer_":"_ds_"' description='"_$ZCVT($G(..Names("DT",ds),$G(..Names("DS",ds))),"O","XML")_$S(pPlanned:"' usage='"_usage,1:"")_"'>"
		Do ..LoadDS(ds,.flds)
		For i=1:1:flds {
			Set u=flds(i,"U") Set:(usage="P")&(u="S") u="P" //field usage can't be better than segment usage
			IF psup'[u CONTINUE
			Set pData($I(pData))="<Field seq='"_i_"' description='"_$ZCVT(flds(i,"Name"),"O","XML")_$S(pPlanned:"' usage='"_u,1:"")
			Set pData(pData)=pData(pData)_"' codetable='"_flds(i,"CT")_"' datastruct='"_flds(i,"DS")_"'>"
			Set:$G(flds(i,"Note"))'="" pData($i(pData))="<note><![CDATA["_$ZCVT(flds(i,"Note"),"O","XML")_"]]></note>"
			Set pData($I(pData))="</Field>"
		}
		Set pData($I(pData))="</DataStructure>"
	}
	Set pData($I(pData))="</DataStructures>"
}

Method GetCTXML(pPlanned, ByRef pData)
{
	Kill pData Set pData=1, pData(1)="<CodeTables>"
	Do ..LoadCT(.cts)
	Set ct="",psup="S" S:pPlanned psup="SP"
	FOR  {
		Set ct=$O(cts(ct)) QUIT:ct=""
		Set usage=cts(ct,"UC")
		IF psup'[usage Continue
		Set pData($I(pData))="<CodeTable name='"_..BaseVer_":"_ct_"' description='"_$ZCVT($G(..Names("CT",ct)),"O","XML")_$S(pPlanned:"' usage='"_usage,1:"")_"'/>"
	}
	Set pData($I(pData))="</CodeTables>"
}

/// Load a multidimensional variable with annotation data for all message groups.
/// Instance subscript is a message group
Method LoadMG(ByRef pData)
{
	KILL pData
	s s=""
	s g="^EnsHL7.Annotation("""_..Version_""",""MG"")"
	F  {
		s s=$o(..Names("MG",s)) Q:s=""
		s pData(s,"U")=$G(@g@(s,"U"),"S")
		s pData(s,"Note")=$G(@g@(s,"Note"))
		s pData(s,"Name")=$G(..Names("MG",s))
	}
	QUIT
}

/// Save Message Groups - pass in HL7 version, reference to modified multi-dim data
Method SaveMG(pData, doindex = 1)
{
	s g="^EnsHL7.Annotation("""_..Version_""",""MG"")"
	DO ..Saves(g,.pData,doindex)
}

/// Load a multi-dimensional variable with annotation data for all message types for an input message group.
/// Instance subscript is a message type.
/// Also returns MS node (message structure)
Method LoadMT(pMG, ByRef pData)
{
	KILL pData
	s s=pMG
	s g="^EnsHL7.Annotation("""_..Version_""",""MT"")"
	//This loop is a bit different - although most message types are format grp_evn,
	//there's also the message type "QRY"
	WHILE $P(s,"_")=pMG  {
		IF $D(..Schema("MT",s)) {
			s pData(s,"U")=$G(@g@(s,"U"),"S")
			s pData(s,"UC")=$G(..Lindex("MT",s),"X")
			s pData(s,"Note")=$G(@g@(s,"Note"))
			s pData(s,"Name")=$S(s["_":$G(..Names("ME",$P(s,"_",2,9))),1:"")
			s pData(s,"MS")=$P($G(..Schema("MT",s)),":",2)
		}
		s s=$o(..Schema("MT",s))
	}
	QUIT
}

/// Save all of the message types for a specific message group.
/// Pass in the HL7 version, the message group,, and a reference to the local
/// variable that contains the edited message types.
Method SaveMT(pData, doindex = 1)
{
	s g="^EnsHL7.Annotation("""_..Version_""",""MT"")"
	DO ..Saves(g,.pData,doindex)
}

/// Load a multi-dimensional variable with annotation data for a message structure.
/// Instance subscript is a sequential number.
/// Also returns the following nodes for display:
/// <li> Type: SEG (a segment), GRP a group begin, END, a group end
/// <li> Code: a coded display value - some combination of segment ID and/or punctuation
/// <li> SS: segment ID (3 letters, for type SEG)
/// <li> Path: tree path to get to this one, for nested segments
Method LoadMS(pMS, ByRef pData)
{
	K pData
	s g="^EnsHL7.Annotation("""_..Version_""",""MS"","""_pMS_""")"
	S ar="..Schema(""MS"","""_pMS_""",""array"")"
	s pData=0 Q:'$D(@ar)
	DO ..ArrayWalk(ar,.pData,"")
	FOR i=1:1:pData {
		Set pData(i,"U")=$G(@g@(i,"U"),"S"),pData(i,"Note")=$G(@g@(i,"Note"))
		//IF pData(i,"Type")'="END" {
			Set pData(i,"UC")=$G(..Lindex("MS",pMS,i),"X")
		//}
	}
	QUIT
}

Method ArrayWalk(pGref, ByRef pRet, pPath, pUnion = 0) [ Private ]
{
	For i=1:1:@pGref {
		Set pRet=pRet+1,n=@pGref@(i,"name"), seg=$E(n,1,3)
		s pRet(pRet,"Path")=pPath
		IF $G(@pGref@(i))>0 {
			Set code="",name=""
			Set:$G(@pGref@(i,"opt"))=1 code="["
			Set:n["()" code=code_"{"
			Set union=n?3U1"union"
			Set:union code=code_"<", name="Choices"
			Set:$L(n,"grp")>2 name="Super"
			Set:n["grp" name=name_"group"
			Set name=seg_" "_name
			Set pRet(pRet,"Name")=name, pRet(pRet,"Code")=code,pRet(pRet,"Type")="GRP"
			//w !,pRet,?pPath*3," ",code," Begin ",name
			DO ..ArrayWalk($Name(@pGref@(i)),.pRet,pPath_","_pRet,union)
			Set pRet=pRet+1
			Set x=code, code=""
			FOR j=$L(x):-1:1 Set c=$E(x,j), code=code_$S(c="{":"}",c="[":"]",c="<":">",1:"")
			Set pRet(pRet,"Name")=name, pRet(pRet,"Code")=code,pRet(pRet,"Type")="END",pRet(pRet,"Path")=pPath
			//W !,pRet,?pPath*3," ",code," End ",name
		}
		Else {
			Set name=$G(..Names("SS",seg))
			Set opt=$G(@pGref@(i,"opt"))=1
			Set code=$S(opt:"[",1:" ")_$S(n["(":"{",1:" ")_" "_seg_$S(pUnion:"|",1:" ")_$S(n["(":"}",1:" ")_$S(opt:"]",1:" ")
			s pRet(pRet,"Name")=name, pRet(pRet,"Code")=code,pRet(pRet,"Type")="SEG",pRet(pRet,"SS")=seg
			//w !,pRet,?pPath*3," ",code," ",name
		}
	}
	Q
}

/// Save all of the message segment annotations for a specific message structure
/// Pass in the HL7 version, the message structure, and a reference to the local
/// variable that contains the edited message annotations
Method SaveMS(pMS, pData, doindex = 1)
{
	s g="^EnsHL7.Annotation("""_..Version_""",""MS"","""_pMS_""")"
	DO ..Saves(g,.pData,doindex)
}

/// Load a multi-dimensional variable with annotation data for all fieds for an input segment.
/// Instance subscript is field #.
/// Also returns
/// <li> DS - Data Structure
/// <li> Rpt - repeat n..m
/// <li> Len - length
/// <li> CT - Code Table
/// <li> Req - required flag
Method LoadSS(pSS, ByRef pData)
{
	KILL pData
	Set g="^EnsHL7.Annotation("""_..Version_""",""SS"","""_pSS_""")"
	s ss=$G(..Schema("SS",pSS))
	Set pData=$LL(ss)
	FOR s=1:1:pData {
		Set fld=$LG(ss,s), pData(s,"DS")=$LG(fld,1), pData(s,"Len")=$LG(fld,4),pData(s,"Req")=$LG(fld,5)
		Set pData(s,"CT")=$G(..Schema("SS",pSS,"tables",s))
		Set pData(s,"Rpt")=$S($LG(fld,6):$S($LG(fld,2)="+":1,1:0)_".."_$LG(fld,3)_$S($LG(fld,3)="":"*",1:""),1:"")
		Set pData(s,"Name")=..Names("SS",pSS,s)
		Set pData(s,"U")=$G(@g@(s,"U"),"S")
		Set pData(s,"UC")=$G(..Lindex("SS",pSS,s),"X")
		Set pData(s,"Note")=$G(@g@(s,"Note"))
		IF ..Version="HealthShare_2.5" {
			Set pData(s,"HSPRI")=$G(@g@(s,"HSPRI"))
		}
	}
}

/// Save all of the segment field annotations for a specific segment
/// Pass in the HL7 version, the segment, and a reference to the local
/// variable that contains the edited message annotations
Method SaveSS(pSS, pData, doindex = 1)
{
	Set g="^EnsHL7.Annotation("""_..Version_""",""SS"","""_pSS_""")"
	DO ..Saves(g,.pData,doindex)
}

/// Load a multi-dimensional variable with annotation data for all fields for an input segment.
/// Instance subscript is field #.
/// Also returns
/// <li> DS - Data Structure
/// <li> CT - Code Table
Method LoadDS(pDS, ByRef pData)
{
	KILL pData
	Set g="^EnsHL7.Annotation("""_..Version_""",""DS"","""_pDS_""")"
	s ss=$G(..Schema("DS",pDS))
	Set pData=$LL(ss)
	FOR s=1:1:pData {
		Set pData(s,"DS")=$LG(ss,s)
		Set pData(s,"CT")=$G(..Schema("DS",pDS,"tables",s))
		Set pData(s,"Name")=..Names("DS",pDS,s)
		Set pData(s,"U")=$G(@g@(s,"U"),"S")
		Set pData(s,"UC")=$G(..Lindex("DS",pDS,s),"X")
		Set pData(s,"Note")=$G(@g@(s,"Note"))
	}
	s ss=$G(..Schema("DT",pDS))
	Set pData=$LL(ss)
	FOR s=1:1:pData {
		Set pData(s,"DS")=$LG($LG(ss,s))
		Set pData(s,"CT")=$G(..Schema("DT",pDS,"tables",s))
		Set pData(s,"Name")=..Names("DT",pDS,s)
		Set pData(s,"U")=$G(@g@(s,"U"),"S")
		Set pData(s,"UC")=$G(..Lindex("DS",pDS,s),"X")
		Set pData(s,"Note")=$G(@g@(s,"Note"))
	}
}

/// Save all of the segment field annotations for a specific data structure
/// Pass in the HL7 version, the structure, and a reference to the local
/// variable that contains the edited message annotations
Method SaveDS(pDS, pData, doindex = 1)
{
	Set g="^EnsHL7.Annotation("""_..Version_""",""DS"","""_pDS_""")"
	DO ..Saves(g,.pData,doindex)
}

/// Load code tables.  Subscripts is code table number.
/// Code tables have no annotations of their own - their usage is just computed from
/// segments and data structure fields that refer to them
Method LoadCT(ByRef pData)
{
	Kill pData Set ct=""
	FOR  {
		Set ct=$O(..Lindex("CT",ct),1,u) QUIT:ct=""
		Set pData(ct,"UC")=u,pData(ct,"Note")=""
		Set pData(ct,"Name")=$G(..Names("CT",ct))
	}
}

/// Load one code table.  Subscript is code
/// Code table has no annotation - this is just loaded for browsing
/// top level is code table name
Method LoadOneCT(pCT, ByRef pData)
{
	Kill pData Merge pData=..Names("CT",pCT)
}

Method Saves(g, pData, doindex) [ Private ]
{
	set s="", chg=0
	F  {
		set s=$o(pData(s)) Q:s=""
		IF $G(@g@(s,"U"),"S")'=pData(s,"U") {set chg=1,@g@(s,"U")=pData(s,"U")}
		s @g@(s,"Note")=pData(s,"Note")
		IF ..Version="HealthShare_2.5" {
			IF $D(pData(s,"HSPRI")) {
				IF pData(s,"HSPRI")=""{Kill @g@(s,"HSPRI")}
				ELSE  {Set @g@(s,"HSPRI")=pData(s,"HSPRI")}
			}
		}
	}
	IF chg {
		IF doindex {
			DO ..ReIndex(1)
			Kill ..Lindex Merge ..Lindex=^EnsHL7.Annotation(..Version,"Index")
		}

		ELSE {Set ^EnsHL7.Annotation(..Version,"reindex")=1 }
	}
}

/// Call to create/re-create the index for a version
Method ReIndex(force = 0)
{
	//Creating index when unsupported ("X") means undefined, supported is "S", planned is "P"
	//S is better than P, which is better than X. For any item, it can have no better support than its parent.
	//If it has multiple parents, it can have no better support than its best supported parent.
	IF 'force QUIT:'$D(^EnsHL7.Annotation(..Version,"reindex"))
	Set ^EnsHL7.Annotation(..Version,"reindex")=2
	Set gi="^EnsHL7.Annotation("""_..Version_""",""Index"")"
	Kill @gi
	// W !,"Indexing Message Groups"
	DO ..LoadMG(.mGroups)
	Set mg=""
	FOR  {
		Set mg=$O(mGroups(mg)) Q:mg=""
		Set gsup=mGroups(mg,"U") IF gsup="X" Continue
		DO ..LoadMT(mg,.mTypes)
		Set mt=""
		FOR {
			Set mt=$O(mTypes(mt)) Q:mt=""
			Set tsup=mTypes(mt,"U") IF tsup="X" Continue
			Set tsup=$$MinSup(gsup,tsup)
			Set @gi@("MT",mt)=tsup
			Set ms=$P(..Schema("MT",mt),":",2)
			Set:ms'="" @gi@("MS",ms)=$$MaxSup($G(@gi@("MS",ms)),tsup)
			// to do - think about return message
		}
	}
	// W !,"Indexing Message Structures "
	Set ms=""
	FOR {
		Set ms=$O(@gi@("MS",ms),1,msup) Q:ms=""
		//This will create the index of segment usage, for further drilldown
		DO ..LoadMS(ms,.mSegs) Set path=""
		FOR i=1:1:mSegs {
			Set lastpath=path, path=mSegs(i,"Path")
			Set mssup=$$MinSup(mSegs(i,"U"),msup) IF mssup="X" Continue
			FOR j=2:1:$L(path,",") {
				Set mssup=$$MinSup(mSegs($P(path,",",j),"U"),mssup) Q:mssup="X"
			}
			IF (mSegs(i,"Type")="END") & ($L(lastpath,",")>1) {
				//For an end of a group, gotta find the annotation for the beginning of the group
				s mssup=$$MinSup(mSegs($P(lastpath,",",$L(lastpath,",")),"U"),mssup)
			}
			IF mssup="X" Continue
			Set @gi@("MS",ms,i)=mssup
			Set:mSegs(i,"Type")="SEG" seg=mSegs(i,"SS"),@gi@("SS",seg)=$$MaxSup($G(@gi@("SS",seg)),mssup)
			Set lastpath=path
		}
	}
	// W !,"Indexing Segments: "
	Set ss="" //look at all supported or planned segments
	FOR  {
		Set ss=$O(@gi@("SS",ss),1,ssup) Q:ss=""
		DO ..LoadSS(ss,.fields)
		FOR i=1:1:fields {
			IF fields(i,"U")="X" Continue
			Set fsup=$$MinSup(ssup,fields(i,"U"))
			Set @gi@("SS",ss,i)=fsup
			Set ds=$P(fields(i,"DS"),":",2)
			Set:ds'="" dsq($$MaxSup($G(@gi@("DS",ds)),fsup),ds)=""
			Set ct=$P(fields(i,"CT"),":",2)
			Set:ct'="" @gi@("CT",ct)=$$MaxSup($G(@gi@("CT",ct)),fsup)
		}
	}
	//look at all data structures
	// W !,"Indexing Data Structures: "
	FOR ssup="S","P" {
		// First, go thru supported ones.  Then, go thru planned supported ones
		WHILE $D(dsq(ssup)) {
			Set dsx=$O(dsq(ssup,"")) Kill dsq(ssup,dsx)
			IF $D(@gi@("DS",dsx)) Continue // we've already processed it
			Set @gi@("DS",dsx)=ssup
			DO ..LoadDS(dsx,.fields)
			FOR i=1:1:fields {
				IF fields(i,"U")="X" Continue
				Set fsup=$$MinSup(ssup,fields(i,"U"))
				Set @gi@("DS",dsx,i)=fsup
				Set ds=$P(fields(i,"DS"),":",2)
				Set:ds'="" dsq($$MaxSup($G(@gi@("DS",ds)),fsup),ds)=""
				Set ct=$P(fields(i,"CT"),":",2)
				Set:ct'="" @gi@("CT",ct)=$$MaxSup($G(@gi@("CT",ct)),fsup)
			}
		}
	}
	K ^EnsHL7.Annotation(..Version,"reindex")
	QUIT
	
MinSup(s1,s2)
	IF (s1="X") ! (s2="X") QUIT "X"
	IF (s1="P") !(s2="P") QUIT "P"
	QUIT "S"
	
MaxSup(s1,s2)
	IF (s1="S") ! (s2="S") QUIT "S"
	IF (s1="P") ! (s2="P") QUIT "P"
	QUIT "X"
}

Method %OnNew(pVersion) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..Version=pVersion
	Set ..BaseVer=$G(^EnsHL7.Schema(..Version,"base"),..Version)
	IF ..BaseVer'=..Version {
		Merge ..Schema=^EnsHL7.Schema(..BaseVer),..Names=^EnsHL7.Description(..BaseVer)
	}
	Merge ..Schema=^EnsHL7.Schema(..Version),..Names=^EnsHL7.Description(..Version)
	DO ..ReIndex(1)
	Merge ..Lindex=^EnsHL7.Annotation(..Version,"Index")
	Quit $$$OK
}

Property Version As %String [ Private ];

Property BaseVer As %String [ Private ];

Property Schema [ MultiDimensional, Private ];

Property Names [ MultiDimensional, Private ];

Property Lindex [ MultiDimensional, Private ];

}
