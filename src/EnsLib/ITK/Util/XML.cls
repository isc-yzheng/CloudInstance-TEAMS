/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsITK, %soap)

Class EnsLib.ITK.Util.XML Extends %RegisteredObject [ System = 4 ]
{

Property Document As %XML.Document;

Property %nsouter [ MultiDimensional ];

Property %child;

Method PercolateNamespaces(pTagname As %String, pNamespace As %String)
{
	set pTagname=$ZCVT(pTagname,"L")
	Set pNamespace=$ZCVT(pNamespace,"L")
	
	Set tree=..Document.DocumentId
	
	set nsList = ##class(%ArrayOfDataTypes).%New()
	
	Set node=$$$xmlGetDocumentElement(tree)
	
	set nsouter="",nsundefined=""
	
	do ..captureNamespaces(tree,node,.nsouter,.nsexternal,.child,pTagname,pNamespace)

	merge ..%nsouter=nsouter
	
	set ..%child=child
}

Method Next(ByRef out As %CharacterStream) As %Boolean
{
	Set tree=..Document.DocumentId
	
	if (..%child="") Quit 0
	set save =..%child
	
	$$$xmlFirstChildElement(tree,..%child,child)
	if $$$xmlGetNodeType(tree,child) '= $$$xmlELEMENTNODE quit 0

	set nsInner="",nsUndefined=""

	do ..captureNamespaces(tree,child,.nsInner,.nsUndefined,.none,"","")
	
	set nspace=$O(nsUndefined(""))
	set iXMLNS=$$$xmlNamespaceToIndex(tree,$$$XMLNSns)
	while (nspace'="")
	{
		if $g(..%nsouter(nspace))'=""
		{
			 $$$xmlSetAttribute(tree,child,"xmlns:"_nspace,..%nsouter(nspace))
			 //$$$xmlSetAttrNamespaceIndex(tree,child,nspace,iXMLNS)
			; "promoting namespace"
		}

		s nspace=$O(nsUndefined(nspace))
	}
	s:$g(out)="" out=##class(%GlobalCharacterStream).%New()
	do ##class(%XML.ImportHandler).SerializeNode(tree,child,1,1,.out,1)
	
	set ..%child = $$$xmlGetNextSibling(tree, save)
	
	quit 1
}

Method NextTag(ByRef out As %CharacterStream) As %Boolean
{
	Set tree=..Document.DocumentId
	
	if (..%child="") Quit 0
	set save = $$$xmlGetNextSibling(tree,..%child)
	
	set child=..%child
	set nsInner="",nsUndefined=""

	do ..captureNamespaces(tree,child,.nsInner,.nsUndefined,.none,"","")
	
	set nspace=$O(nsUndefined(""))
	set iXMLNS=$$$xmlNamespaceToIndex(tree,$$$XMLNSns)
	while (nspace'="")
	{
		if $g(..%nsouter(nspace))'=""
		{
			 $$$xmlSetAttribute(tree,child,"xmlns:"_nspace,..%nsouter(nspace))
		}

		s nspace=$O(nsUndefined(nspace))
	}
	s:$g(out)="" out=##class(%GlobalCharacterStream).%New()
	do ##class(%XML.ImportHandler).SerializeNode(tree,child,1,1,.out,1)
	
	set ..%child = save
	
	Quit 1
}

ClassMethod captureNamespaces(tree, node, ByRef ns, ByRef nsExternal, ByRef child, tag, tagns)
{
	merge nssave = ns

	set att=$$$xmlFirstAttributeName(tree,node)
	for
	{
		Quit:att=""
		
		if $$$xmlGetAttrNamespaceURI(tree,node,att) = $$$XMLNSns
		{
			set nspace = $$$xmlGetAttribute(tree,node,att)
			set i = $$$xmlNamespaceToIndex(tree,nspace)
			set ns(att)=nspace
		}
		
		set att = $$$xmlNextAttributeName(tree,node,att)
	}
	
	set att=$$$xmlFirstAttributeName(tree,node)
	for
	{
		Quit:att=""
		
		if $$$xmlGetAttrNamespaceURI(tree,node,att) '= $$$XMLNSns
		{
			s attqname = $$$xmlGetAttrQName(tree,node,att)
			if $L(attqname,":")>1
			{
				set prefix = $P($$$xmlGetAttrQName(tree,node,att),":",1)	
				set:(($g(ns(prefix))="") && ($g(nsExternal(prefix))="")) nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
				if (($g(ns(prefix))="") && ($g(nsExternal(prefix))="")) 
				{
					set nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
				}
			}
			
			if $$$xmlGetAttrValueNsURI(tree,node,att)'=""
			{
				set prefix = $P($$$xmlGetAttribute(tree,node,att),":",1)	
				if (($g(ns(prefix))="") && ($g(nsExternal(prefix))="")) 
				{
					set nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
				}
			}
			
		}
		
		set att = $$$xmlNextAttributeName(tree,node,att)
	}
	
	if $L($$$xmlGetQName(tree,node),":")>1
	{
		set prefix = $P($$$xmlGetQName(tree,node),":",1)
		if (($g(ns(prefix))="") && ($g(nsExternal(prefix))="")) 
		{
			set nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
		}
	}
	
	if (tag '="") && ($ZCVT($$$xmlGetLocalName(tree,node),"L")=tag) && ($ZCVT($$$xmlGetNamespaceURI(tree,node),"L") =tagns)
	{
		set child=node
		quit	
	}

	
	$$$xmlFirstChildElement(tree,node,el)
	for
	{
		quit:el=""
		if $$$xmlGetNodeType(tree,el) = $$$xmlELEMENTNODE
		{
			do ..captureNamespaces(tree,el,.ns,.nsExternal,.child,tag,tagns)
			quit:$g(child)'=""
		}
	
		$$$xmlNextChildElement(tree,node,el)
	}
		
	 merge ns = nssave
}

}
