/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsLib.EDI.ASTM.Util.FormatHTMLZen Extends EnsLib.EDI.IOFormatInterface [ Abstract, System = 4 ]
{

/// Return 1 if we took care of the whole document or got an error. Returning 0 means the caller will continue doing component segments as usual.
ClassMethod OutputDocument(pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String) As %Boolean
{
	Set tSC=$$$OK
	Set tVDoc = $ZCVT($$$Text("ASTM","EDIDocumentView"),"O","HTML")
	Set tDoc = $ZCVT($$$Text("Document","EDIDocumentView"),"O","HTML")
	Set tId = $ZCVT($$$Text("Id","EDIDocumentView"),"O","HTML")
	Set tType = $ZCVT($$$Text("DocType","EDIDocumentView"),"O","HTML")
	Set tSeg = $ZCVT($$$Text("Segments","EDIDocumentView"),"O","HTML")
	Set tSegNo = $ZCVT($$$Text("No Segments","EDIDocumentView"),"O","HTML")
	Set tBMS = $ZCVT($$$Text("Build Map Status","EDIDocumentView"),"O","HTML")
	Set:""=pSeparators pSeparators=pDocObj.Separators  
	Set:""=pSeparators pSeparators=$$$ASTMDefSeparators
	Do pIOStream.WriteLine(
	"<table border=""0"" cellspacing=""0"" cellpadding=""0"" nowrap width=""1200px""><tr><td align=""left""><div style=""font-size:9pt; margin: 3px;"">",,.pStatus)  Quit:$$$ISERR(pStatus) 1
	If ""'=pDocObj.DocType {
		Do:""=pDocObj.BuildMapStatus||'$D($$$vaMobj(pDocObj,"runtimePath")) pDocObj.BuildMap()
		Set tDesc=##class(EnsLib.EDI.ASTM.Schema).GetDescription("DS:"_pDocObj.DocType)
		Do pIOStream.WriteLine(
			tVDoc_" <b>"_$ZCVT(pDocObj.Name,"O","HTML")_"</b> "_tDoc_" - "_tId_" <b>"_pDocObj.%Id()_"</b>, "_
			tType_" = '<a"_$S(""=tDesc:"",1:" title='"_$ZCVT(tDesc,"O","HTML")_"'")_
			..getDocLink(pDocObj.DocType)_"><b>"_$ZCVT(pDocObj.DocType,"O","HTML")_"</b></a>'"_
			"<br>"_
			$S(""=tDesc:"", 1:"'<b><i>"_$ZCVT(tDesc,"O","HTML")_"</i></b>', ")_
			"<b>"_pDocObj.SegCount_"</b> "_tSeg,,.pStatus)  Quit:$$$ISERR(pStatus) 1
		If $$$ISERR(pDocObj.BuildMapStatus) {
			Set tErr=$ZCVT($$GetOneErrorText^%apiOBJ(pDocObj.BuildMapStatus),"O","HTML")
			Do pIOStream.WriteLine("<br>"_tBMS_" = '<b>"_tErr_"</b>'",,.pStatus)  Quit:$$$ISERR(pStatus) 1
			For i=2:1 { Set tErr=$$GetOneErrorText^%apiOBJ(pDocObj.BuildMapStatus,i)  Quit:""=tErr
				Do pIOStream.WriteLine("<br>'"_$ZCVT(tErr,"O","HTML")_"'",,.pStatus)  Quit:$$$ISERR(pStatus)
			} Quit:$$$ISERR(pStatus) 1
		}
	} Else {
		Do pIOStream.WriteLine(
			tVDoc_" <b>"_$ZCVT(pDocObj.Name,"O","HTML")_"</b> "_tDoc_" - "_tId_" <b>"_pDocObj.%Id()_"</b>, "_
			tType_" = <b>''</b>, <b>"_pDocObj.SegCount_"</b> "_tSeg,,.pStatus)  Quit:$$$ISERR(pStatus) 1
	}
	Do pIOStream.WriteLine("</div></td></tr></table>",,.pStatus)  Quit:$$$ISERR(pStatus) 1
	Do:'$D($$$vaMobj(pDocObj,"runtimeIndex"))&&$D($$$vaMobj(pDocObj,"runtimePath")) pDocObj.buildRuntimeIndexFromPath()
	Set tCnt=$G($$$vaMobj(pDocObj,"runtimeIndex"))
	If tCnt<=0 { Do pIOStream.WriteLine("<center>"_tSegNo_"</center>",,.pStatus)  Quit:$$$ISERR(pStatus) 1 }
	Else {
		Do pIOStream.WriteLine("<table class=""EDIDocumentTable"" BORDER=""0"" CELLSPACING=""0"" CELLPADDING=""0"">",,.pStatus)  Quit:$$$ISERR(pStatus) 1
		For i=1:1:tCnt {
			If i>300&&(i<=(tCnt-100)) {
				If i=301 {
					Do pIOStream.WriteLine("<TR CLASS=""EDIDocumentTableRow""><TD CLASS=""EDIDocumentTableExpandor"">&nbsp;</TD>",,.pStatus)  Quit:$$$ISERR(pStatus)
					Do pIOStream.WriteLine("<td class='EDIDocumentTableSegnum'>....&nbsp;</td><td class='EDIDocumentTableSegid' SegID='....'> </td>",,.pStatus)  Quit:$$$ISERR(pStatus)
					Do pIOStream.WriteLine("<td class='EDIDocumentTableSegname'>&nbsp;</td>",,.pStatus)  Quit:$$$ISERR(pStatus)
					Set tCount = $ZCVT($$$FormatText($$$Text("Segments 301 to %1 not shown ...","EDIDocumentView"),tCnt-100),"O","HTML")
					Do pIOStream.WriteLine("<td>"_tCount_"</td></TR>",,.pStatus)  Quit:$$$ISERR(pStatus)
				}
				Continue
			}
			Set tPath=$G($$$vaMobja(pDocObj,"bidirectionalLink",i),i)
			Set seg=pDocObj.getSegmentByIndex(i)
			Do pIOStream.WriteLine("<TR CLASS=""EDIDocumentTableRow""><TD CLASS=""EDIDocumentTableExpandor"">&nbsp;</TD>",,.pStatus)  Quit:$$$ISERR(pStatus)
			Do ..OutputSegment(seg,.tSC,pIOStream,pSeparators,i,tPath,pDocObj)  Quit:$$$ISERR(tSC)
			Do pIOStream.WriteLine("</TR>",,.pStatus)  Quit:$$$ISERR(pStatus)
			Do pDocObj.commitSegmentByIndex(i)
		}
		Do pIOStream.WriteLine("</table>",,.pStatus)  Quit:$$$ISERR(pStatus) 1
	}
	If $$$ISERR(tSC) Do pIOStream.WriteLine($ZCVT($$$StatusDisplayString(tSC),"O","HTML"),,.pStatus)  Set pStatus=$$$ADDSC(tSC,pStatus)
	Quit 1
}

ClassMethod OutputDocumentEnd(pDocObj As EnsLib.EDI.Document, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String)
{
	Set pStatus=$$$OK
	Quit ; no return value
}

/// Return 1 if we took care of the segment or got an error. Returning 0 means the caller will output the segment as usual.
ClassMethod OutputSegment(pSegObj As EnsLib.EDI.Segment, Output pStatus As %Status, pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document) As %Boolean
{
	Set:""=$G(pSeparators) pSeparators=pSegObj.Separators
	Set tFullLen=pSegObj.FullSize
	Do pSegObj.decompose()
	Set tName=pSegObj.Name, tFS=$ZCVT($$$FLDSEP(pSeparators),"O","HTML"), tRS=$ZCVT($$$REPSEP(pSeparators),"O","HTML"), tCS=$ZCVT($$$COMSEP(pSeparators),"O","HTML")
	Set:""=tName tName="x"
	Set tDocType=pSegObj.DocType
	Set pStatus=..outputHTMLStart(pIOStream,pSegNum,pSegPath,pSegObj.ID,tName,tDocType,tFullLen,$S($IsObject(pParentDoc):pParentDoc.DocType,1:""))  Quit:$$$ISERR(pStatus) 1
	Set tReplaceSpec(" ")="&nbsp;"
	Set tReplaceSpec($C(9))="\t"
	Set tReplaceSpec($C(13))="\r"
	Set tReplaceSpec($C(10))="\n"
	Set iCat=$P(tDocType,":"), iSeg=$P(tDocType,":",2)
	If ""=iCat||(""=iSeg) {
		Set iList=""
	} Else {
		Set iList=$G($$$vaSchemaGbl(iCat,"SS",iSeg))
		Set pStatus=##class(EnsLib.EDI.ASTM.Schema).getFieldsContentArray(.tContents,"source",iCat,iSeg,0)
	}
	Set iCnt=pSegObj.GetValueAt("*",pSeparators)
	If iCnt<1 { Do pIOStream.WriteLine("<td class='EDISegmentsTableEmptyfield'>&nbsp</td>",,.pStatus)  Quit:$$$ISERR(pStatus) 1 }
	Else { For i=1:1:iCnt {
		Set iN=$ZCVT($P($E($G(tContents(i,"name"),":"_i),2,*),"("),"O","HTML")
		Set iAttrs=$LG(iList,i), iDT=$LG(iAttrs,1), iSym=$LG(iAttrs,2), iRep=$LG(iAttrs,3), iLen=$LG(iAttrs,4), isRep=$LG(iAttrs,6)
		Set:'iRep&&isRep iRep=1
		Set tAttr=$S(iRep>1:iRep,1:"")_iSym_$S(iLen:"("_iLen_")",1:"")
		If ""'=iDT {
			Set cCat=$P(iDT,":"),cTyp=$P(iDT,":",2)
			Set cList=$G($$$vaSchemaGbl(cCat,"DS",cTyp))
		}		
		If $Case(tName,"H":1,:0) && (i<=2) {
			Do pIOStream.WriteLine("<td nowrap class='EDISegmentsTableValue'><a title='"_i_" / "_iN_$S(""=tAttr:"",1:" / "_tAttr)_"'"_..getSegLink(tDocType,i)_">"_$ZCVT(pSegObj.GetValueAt(i,pSeparators),"O","HTML")_"</a></td>",,.pStatus)  Quit:$$$ISERR(pStatus)
			Continue
		} Else { Do pIOStream.WriteLine("<td class='EDISegmentsTableSeparator'>"_tFS_"</td>",,.pStatus)  Quit:$$$ISERR(pStatus) }
		If ""=pSegObj.GetValueAt(i) Do pIOStream.WriteLine("<td class='EDISegmentsTableEmptyfield'><a title='"_i_" / "_iN_$S(""=tAttr:"",1:" / "_tAttr)_"'"_..getSegLink(tDocType,i)_">&nbsp;&middot;</a></td>",,.pStatus)  Quit:$$$ISERR(pStatus)  Continue
		Set rCnt=pSegObj.GetValueAt(i_"(*)")
		Set rF=1  For r=1:1:rCnt {
			Set rN=iN,rpN=iN,rAlias=i,rpAlias=i
			If rCnt>1||iRep { Set rp=r_$S(rCnt>iRep&&(iRep'=1):"*",1:"")
				Set rN=rN_"("_r_")", rpN=rN_"("_rp_")"
				Set rAlias=rAlias_"("_r_")", rpAlias=rAlias_"("_rp_")"
			}
			If rF { Set rF=0 } Else { Do pIOStream.WriteLine("<td class='EDISegmentsTableSeparator'>"_tRS_"</td>",,.pStatus)  Quit:$$$ISERR(pStatus) }
			
			Set cCnt=pSegObj.GetValueAt(i_"("_r_").*")
			Set cF=1  For c=1:1:cCnt {
				Set cN=rN,cpN=rpN,cAlias=rAlias,cpAlias=rpAlias  If ""'=iDT||(cCnt>1) {
					Set cN=cN_"."_$ZCVT($P($G(tContents(i,c,"name"),c),"("),"O","HTML")
					Set cpN=cpN_"."_$ZCVT($P($G(tContents(i,c,"name"),c),"("),"O","HTML")
					Set cAlias=cAlias_"."_c
					Set cpAlias=cpAlias_"."_c
				}
				Set cDT=$S(""=iDT:"",1:$LG(cList,i))
				If cF { Set cF=0 } Else { Do pIOStream.WriteLine("<td class='EDISegmentsTableSeparator'>"_tCS_"</td>",,.pStatus)  Quit:$$$ISERR(pStatus) }
				
				Set tVal=pSegObj.GetValueAt(cAlias,pSeparators)
				If ""=tVal Do pIOStream.WriteLine("<td class='EDISegmentsTableEmptyfield'><a title='"_$S(cpAlias=cpN:"",1:cpAlias_" / ")_cpN_$S(""=tAttr:"",1:" / "_tAttr)_"'"_..getSegLink(tDocType,i)_">&nbsp;&middot;</a></td>",,.pStatus)  Quit:$$$ISERR(pStatus)  Continue
				Do pIOStream.Write("<td nowrap class='EDISegmentsTableValue'><a title='"_$S(cpAlias=cpN:"",1:cpAlias_" / ")_cpN_$S(""=tAttr:"",1:" / "_tAttr)_"'"_..getSegLink(tDocType,i)_">",,.pStatus)  Quit:$$$ISERR(pStatus)
				Set:$L(tVal)>2000 tVal=$E(tVal,1,2000)_" ..."
				While ""'=tVal { Set tPiece=$E(tVal,1,1000), tVal=$E(tVal,1001,*) Do pIOStream.Write($$replaceArray^EnsUtil($ZCVT(tPiece,"O","HTML"),.tReplaceSpec),,.pStatus)  Quit:$$$ISERR(pStatus) }
				Do pIOStream.WriteLine("</a></td>",,.pStatus)  Quit:$$$ISERR(pStatus)
			} Quit:$$$ISERR(pStatus)
		} Quit:$$$ISERR(pStatus)
	} Quit:$$$ISERR(pStatus) 1 }
	Set pStatus=..outputHTMLEnd(pIOStream)
	Quit 1
}

/// This is ASTM so we have no child documents.
ClassMethod outputChildLinks(pIOStream As %IO.I.CharacterStream, pSegObj As EnsLib.EDI.Segment, pDocsRefParent, tTypeName) As %Status
{
	Quit $$$OK
}

ClassMethod outputHTMLStart(pIOStream As %IO.I.CharacterStream, pSegNum, pSegPath, pID, pName, pDocType, pFullLen, pMsgStructure) As %Status [ Internal ]
{
	Set tDesc=$S(""=pDocType:"", 1:##class(EnsLib.EDI.ASTM.Schema).GetDescription("SS:"_pDocType))
	Set len=$S(pFullLen<=2000:"",1:" (len="_pFullLen_")")
	Do pIOStream.WriteLine(
	"<td class='EDIDocumentTableSegnum'>"_(pSegNum)_"&nbsp;</td><td class='EDIDocumentTableSegid' SegID='"_(pID)_"'>"_($S(""=pID:"*",1:"&nbsp;"))_"</td>"_
	"<td class='EDIDocumentTableSegname'>"_
		"<a title='"_$S(pSegNum=pSegPath&&(""'=pDocType):"SS:"_pDocType, 1:$ZCVT(pSegPath_$S(""=tDesc:"", 1:" - "_tDesc),"O","HTML"))_len_"'"_..getSegLink(pDocType,,$S(pSegNum=pSegPath&&(""'=pDocType):"", 1:$ZCVT(pSegPath,"O","HTML")),$ZCVT(pMsgStructure,"O","HTML"))_">"_pName_
	"</a></td><td><table class='EDISegmentsTable'><tr>",,.tSC)
	Quit tSC
}

/// This is ASTM so we have no parent documents.
ClassMethod linkParents(pDocObj) As %String [ Internal ]
{
	Quit ""
}

ClassMethod getSegLink(pDocType, pAnchor = "", pPath = "", pMsgStructure = "") As %String [ Internal ]
{
	Quit:""=pDocType||'##class(EnsLib.EDI.ASTM.Schema).ElementExists("SS:"_pDocType) ""
	Quit " href='"_##class(%CSP.Page).Link("EnsPortal.EDI.ASTM.SchemaSegmentStructure.zen?SS=SS:"_$$$URLENCODE(pDocType)_$S(""=pPath:"",1:"&PATH="_$$$URLENCODE(pPath))_$S(""=pMsgStructure:"",1:"&DS="_$$$URLENCODE(pMsgStructure))_$S(""=pAnchor:"",1:"#"_pAnchor))_"' target='_blank'"
}

ClassMethod getDocLink(pDocType) As %String [ Internal ]
{
	Quit:""=pDocType||'##class(EnsLib.EDI.ASTM.Schema).ElementExists("DS:"_pDocType) ""
	Quit " href='"_##class(%CSP.Page).Link("EnsPortal.EDI.ASTM.SchemaDocumentStructure.zen?DS=DS:"_$$$URLENCODE(pDocType))_"' target='_blank'"
}

ClassMethod outputHTMLEnd(pIOStream As %IO.I.CharacterStream) As %Status [ Internal ]
{
	Do pIOStream.WriteLine("</tr></table></td>",,.tSC)
	Quit tSC
}

}
