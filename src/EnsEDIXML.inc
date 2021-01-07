ROUTINE EnsEDIXML [Type=INC]
#; EnsEDIXML.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#;
#; Make sure 2013.1 or above
#define VERSION31ORABOVE
#;
#define LOCALMAPS
#;
#Include EnsEDI

#; Calc Cache will either use internal memory (multidimensional array) or PPG.
#define	MAXCALCCACHE	1000
 
#; LVD array macros
#define vaSchemaGbl       ^EnsEDI.XML.Schema
#define vaSchemaDescGbl   ^EnsEDI.XML.Description
#define vaExtentGbl       ^EnsLib.EDI.XML.DocumentD
 
#; LVD data array macros
#define GVAL(%x,%def) $s(%x="":%def,1:%x)
#define DEFINED(%node,%value) 0
#define vaContentRef(%subs)  ($E(..%ContentRef,1,*-1)_","_%subs_")")
#define vaDOMGbl             $$$vaExtentGbl("domcache")
#define vaCalcGbl            $$$vaExtentGbl("calccache")
#define vaPropsGbl           $$$vaExtentGbl("propcache")
#define vaDOMRef(%subs)      $S(")"=$E(..%DOMCacheRef,*):$E(..%DOMCacheRef,1,*-1)_(%subs)_")", ""=(%subs):..%DOMCacheRef, 1:..%DOMCacheRef_"("_$E(%subs,2,*)_")")
#define vaPropsRef(%subs)    $S(")"=$E(..%PropCacheRef,*):$E(..%PropCacheRef,1,*-1)_(%subs)_")", ""=(%subs):..%PropCacheRef, 1:..%PropCacheRef_"("_$E(%subs,2,*)_")")
#define vaTempGbl            ^||ISC.XML.VDoc.Temp
#define vaCalcRef(%subs)     $S(")"=$E(..%CalcCacheRef,*):$E(..%CalcCacheRef,1,*-1)_(%subs)_")", ""=(%subs):..%CalcCacheRef, 1:..%CalcCacheRef_"("_$E(%subs,2,*)_")")
#define vaFindRef(%subs)     $S(")"=$E(..%FindCacheRef,*):$E(..%FindCacheRef,1,*-1)_(%subs)_")", ""=(%subs):..%FindCacheRef, 1:..%FindCacheRef_"("_$E(%subs,2,*)_")")
#define vaContentGbl         ^EnsEDI.XML.Content
#define vaContent(%cid)      $$$vaContentGbl($P(%cid,","),$P(%cid,",",2))
#define vaInitPropCache      If ..%PropCacheRef'="..%PropCache" { Merge ..%PropCache=$$$vaPropsGbl  Set i%%PropCacheRef="..%PropCache" }
#define vaInitDOMCache       If ..%DOMCacheRef'="..%DOMCache" { Merge ..%DOMCache=$$$vaDOMGbl  Set i%%DOMCacheRef="..%DOMCache" }
#define vaInitCalcCache      If ..%CalcCacheRef'="..%CalcCache" { Merge ..%CalcCache=$$$vaCalcGbl  Set i%%CalcCacheRef="..%CalcCache" }
#define vaInitFindCache      If ..%FindCacheRef'="..%CalcCache" { Merge ..%FindCache=$$$vaCalcGbl  Set i%%FindCacheRef="..%FindCache" }
#define vaInitCache          $$$vaInitPropCache  $$$vaInitDOMCache
#define vaKillCalcCache      Kill @..%CalcCacheRef
#define vaKillCalcCache1(%pDSubs) Set p0=i%%PurgeIndex if (%pDSubs'="")&&(%pDSubs'="_") { Kill:'p0 ..%CalcCache(%pDSubs) Kill:p0 ^||%XML.VDoc.CalcCache(p0,%pDSubs) } else { Kill:'p0 ..%CalcCache Kill:p0 ^||%XML.VDoc.CalcCache(p0) }
#;#define vaKillCalcCache2(%pDSubs,%pCSubs) if (%pDSubs'="")&&(%pDSubs'="_") { Kill @..%CalcCacheRef@(%pDSubs,$s(%pCSubs="":$$$quote("<>"),1:%pCSubs)) } else { Kill @..%CalcCacheRef }
#define vaKillCalcCache2(%pDSubs,%pCSubs) $$$vaKillCalcCache1(%pDSubs)

#define vaIsPropRef(%ref)    ("..%"=$E(%ref,1,3))
#define vaIsLocalRef(%ref)   $Case($E(%ref),"%":1,"^":("^||"=$E(%ref,1,3)),:0)

#ifndef LOCALMAPS
#define vaTempInstanceGbl ^IRIS.Temp.EnsEDI.XML
#endif

#; DOMCache array subscript macros

#;  Element node subscript macros (value = total count of DOMCache (DC) and ContentRef (CR) nodes of this type)
#;    Sequence indicator
#define domESeq    ">S"

#;  Element instance node subscript macros  (value = Number of total DOMCache (DC) and ContentRef (CR) child nodes of this one)
#;    First Text value of this DOMCache node (can have more numeric subscripts for large values)
#;    note: if present and empty, use full close element not /> abbreviation
#define domIValue  ">V"
#;    Remove corresponding ContentRef node (=R) or blank out its value (=B)
#define domIRemove ">R"
#;    Node ID of corresponding ContentRef node
#define domICRid   ">I"
#;    Force CData
#define domICData  ">D"

#;  Node instance type macros : key=node index, value=type > (1st 500 of node content) if not Element node.
#;  Element node is element name > element number
#;    Comment node
#define domTComment     ">C"
#;    Processing Instruction node
#define domTInstruction ">P"
#;    Text node
#define domTText        ">T"

#;  Node instance subscript macros (for non-Element nodes)
#;    Additional text value of node if longer than 500 (can have more numeric subscripts for large values)
#define domNValue  ">V"
#;    Remove corresponding ContentRef node (=R) or blank out its value (=B)
#define domNRemove ">R"
#;    Node ID of corresponding ContentRef node
#define domNCRid   ">I"
#;    Force CData
#define domNCData  ">D"
#;
#; compare nodes (used in tAfterCNode comparision - comparing node stored in ">I" with node in Content Array)
#; always invoke $$$domStripPlus1 on tAfterCNode argument BEFORE invoking $$$domGT
#define domGT(%c1,%c2) $s((%c1="")||(%c2=""):($$$domDiffNull(%c1,%c2))>0,1:($$$xmliChildOrder(..%ContentRef,$$$xmlParentNode(..%ContentRef,%c1),%c1,%c2))>0)
#define domGE(%c1,%c2) $s((%c1="")||(%c2=""):($$$domDiffNull(%c1,%c2))>=0,1:($$$xmliChildOrder(..%ContentRef,$$$xmlParentNode(..%ContentRef,%c1),%c1,%c2))>=0)
#define domLT(%c1,%c2) $s((%c1="")||(%c2=""):($$$domDiffNull(%c1,%c2))<0,1:($$$xmliChildOrder(..%ContentRef,$$$xmlParentNode(..%ContentRef,%c1),%c1,%c2))<0)
#define domLE(%c1,%c2) $s((%c1="")||(%c2=""):($$$domDiffNull(%c1,%c2))<=0,1:($$$xmliChildOrder(..%ContentRef,$$$xmlParentNode(..%ContentRef,%c1),%c1,%c2))<=0)
#define domEQ(%c1,%c2) (%c1)=(%c2)
#define domGetNextChild(%documentId,%nodeId,%childId) $s((%nodeId=0)&&(%childId'="")&&(%childId'=-1):"",1:$s((%nodeId=0)&&((%childId="")||(%childId=-1)):$$$xmlGetDocumentElement(..%ContentRef),1:$s(%childId=-1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetFirstChild(%documentId,%nodeId),1:""),1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetNextChild(%documentId,%nodeId,%childId),1:""),1:""),1:""),1:"")
#define domGetNextChild1(%documentId,%nodeId,%childId) $s(%childId=-1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetFirstChild(%documentId,%nodeId),1:""),1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetNextChild(%documentId,%nodeId,%childId),1:""),1:"")
#define domGetNextChild2(%documentId,%nodeId,%childId) $s((%nodeId=0)&&(%childId'=""):"",1:$s((%nodeId=0)&&(%childId=""):$$$xmlGetDocumentElement(..%ContentRef),1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetNextChild(%documentId,%nodeId,%childId),1:""),1:""),1:"")
#define domGetNextChild3(%documentId,%nodeId,%childId) ..domGetNextChild(%documentId,%nodeId,%childId)
#define domGetNextChild4(%documentId,%nodeId,%childId) $s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetNextChild(%documentId,%nodeId,%childId),1:"")
#define domGetPreviousChild(%documentId,%nodeId,%childId) $s((%childId)=">":$$$xmlGetLastChild(%documentId,%nodeId),1:$$$xmlGetPreviousChild(%documentId,%nodeId,%childId))
#define domStripPlus(%c1) if $e(%c1)="+" Set %c1=$e(%c1,2,*)
#define domStripPlus1(%c1) $s($e(%c1)="+":$e(%c1,2,*),1:%c1)
#define DEBUGC1C2(%msg,%c1,%c2) if (0) w !,%msg_" c1="_%c1_" c2="_%c2
#define DEBUGDIFF(%diff) if (0) w !,"diff="_(%diff)
#define domDiffNull(%c1,%c2) $s(%c1'="":1,1:$s(%c2'="":-1,1:0))
#; #define domGetQName(%documentId,%nodeId) $s($$$xmlELEMENTNODE'=$$$xmlGetNodeType(%documentId,%nodeId):"",1:$$$xmlGetQName(%documentId,%nodeId))
#define domGetQName(%documentId,%nodeId) $s('$D(@$$$vaContentRef(0)):"",1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetQName(%documentId,%nodeId),1:""))
#define domGetNamespaceURI(%documentId,%nodeId) $s('$D(@$$$vaContentRef(0)):"",1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetNamespaceURI(%documentId,%nodeId),1:""))
#define domGetLocalName(%documentId,%nodeId) $s('$D(@$$$vaContentRef(0)):"",1:$s($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetLocalName(%documentId,%nodeId),1:""))
#; dom macros to convert xmla attribute handling
#define domInitAttributeHandle(%handle) Set %handle=$$$xmliCLBase
#define domLoopAttributes(%contentref,%childlist,%handle) ((%childlist'="") && (%handle<$$$xmliCLelementOffset(%contentref,%childlist)))
#define domNextAttribute(%contentref,%childlist,%handle,%attr) Set %attr=$extract(%childlist,%handle,%handle+$$$xmliAttributeSize1)
#define domNextHandle(%contentref,%childlist,%attribute,%handle) Set %handle=%handle+$$$xmliAttributeSize
#define domGetAttributeQName(%documentId,%node,%attribute) $$$xmlaGetAttributeQName(%documentId,%attribute)
#define domGetAttributeValue(%documentId,%node,%attribute) $$$xmlaGetAttribute(%documentId,%attribute)
#define domAttributeValueIsDefined(%documentId,%node,%attribute) ($Get($$$xmlaGetAttributeName(%documentId,%attribute))'="")
#define domGetAttrNamespaceURI(%documentId,%node,%attribute) $$$xmlaGetAttrNamespaceURI(%documentId,%attribute)
#define domGetOffset(%subscript) $s(%subscript[",":$P(%subscript,",",2),1:%subscript)
#;
#; node size used in domGetSubtree as node size of process private global
#define ppgNODESIZE 32000
#;
#; flags for domGetSubtree (only new ones here)
#define OUTPUTUNESCAPED "o"
#; when doing GetValueAt include schema uri and schemaLocation
#define OUTPUTSCHEMAINFO "l"
#;
#; utility macros
#; conditionally xml escape value (this is %v), if the format string contains $$$OUTPUTUNESCAPED don't escape value otherwise XML escape value
#define CONDXMLESCAPE(%f,%v) $s(%f[$$$OUTPUTUNESCAPED:%v,1:$zcvt(%v,"O","XML"))

#;#define DEBUGPARSER(%x) w !,(%x)
#define DEBUGPARSER(%x)
