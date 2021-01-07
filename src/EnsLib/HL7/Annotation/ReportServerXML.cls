/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Annotation.ReportServerXML Extends %CSP.Page [ System = 4 ]
{

Parameter SECURITYRESOURCE = "%Ens_EDISchemaAnnotations:READ";

ClassMethod OnPage() As %Status
{
	Set version=$G(%request.Data("version",1),"2.5")
	Set planned=$G(%request.Data("planned",1),1)
	S annot=##Class(EnsLib.HL7.Annotation.Data).%New(version)
	Write "<?xml version=""1.0"" ?>",!
	Write "<?xml-stylesheet href=""ensemble/Ensemble_XMLDisplay.xsl"" type=""text/xsl"" ?>",!
	W !,"<!DOCTYPE AnnotatedSchema ["
	W !,"<!ELEMENT AnnotatedSchema ( MessageGroups, MessageStructures, SegmentStructures, DataStructures, CodeTables ) >"
	W !,"<!ATTLIST AnnotatedSchema version CDATA #REQUIRED >"
	W !!,"<!ELEMENT DataStructure ( Field* ) >"
	W !,"<!ATTLIST DataStructure description CDATA #REQUIRED >"
	W !,"<!ATTLIST DataStructure name CDATA #REQUIRED >"
	W !,"<!ATTLIST DataStructure usage (P|S|X) 'S' >"
	W !!,"<!ELEMENT DataStructures ( DataStructure* ) >"
	W !!,"<!ELEMENT Field (note?) >"
	W !,"<!ATTLIST Field codetable CDATA #REQUIRED >"
	W !,"<!ATTLIST Field datastruct CDATA #REQUIRED >"
	W !,"<!ATTLIST Field description CDATA #REQUIRED >"
	W !,"<!ATTLIST Field length CDATA #IMPLIED >"
	W !,"<!ATTLIST Field repeat CDATA #IMPLIED >"
	W !,"<!ATTLIST Field required CDATA #IMPLIED >"
	W !,"<!ATTLIST Field seq CDATA #REQUIRED >"
	W !,"<!ATTLIST Field usage (P|S|X) 'S' >"
	W !,"<!ATTLIST Field HSPRI CDATA #IMPLIED>"
	W !!,"<!ELEMENT MessageComponent (note?) >"
	W !,"<!ATTLIST MessageComponent description CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageComponent name CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageComponent usage (P|S|X) 'S' >"
	W !!,"<!ELEMENT MessageEvent (note?) >"
	W !,"<!ATTLIST MessageEvent description CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageEvent name CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageEvent structure CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageEvent usage (P|S|X) 'S' >"
	W !!,"<!ELEMENT MessageGroup (note?,MessageEvent*) >"
	W !,"<!ATTLIST MessageGroup description CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageGroup name CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageGroup usage (P|S|X) 'S' >"
	W !!,"<!ELEMENT MessageGroups ( MessageGroup* ) >"
	W !!,"<!ELEMENT MessageStructure ( MessageComponent* ) >"
	W !,"<!ATTLIST MessageStructure description CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageStructure name CDATA #REQUIRED >"
	W !,"<!ATTLIST MessageStructure usage (P|S|X) 'S' >"
	W !!,"<!ELEMENT MessageStructures ( MessageStructure* ) >"
	W !!,"<!ELEMENT SegmentStructure ( Field* ) >"
	W !,"<!ATTLIST SegmentStructure description CDATA #REQUIRED >"
	W !,"<!ATTLIST SegmentStructure name CDATA #REQUIRED >"
	W !,"<!ATTLIST SegmentStructure usage (P|S|X) 'S' >"
	W !!,"<!ELEMENT SegmentStructures ( SegmentStructure* ) >"
	W !!,"<!ELEMENT note (#PCDATA)>"
	W !!,"<!ELEMENT CodeTables ( CodeTable* ) >"
	W !!,"<!ELEMENT CodeTable EMPTY >"
	W !,"<!ATTLIST CodeTable description CDATA #REQUIRED >"
	W !,"<!ATTLIST CodeTable name CDATA #REQUIRED >"
	W !,"<!ATTLIST CodeTable usage (P|S|X) 'S' >"
	W !,"]>"
	Write "<AnnotatedSchema version='"_version_"'>",!
	DO annot.GetMGXML(planned,.xml)
	FOR i=1:1:xml { Write xml(i),! }
	DO annot.GetMSXML(planned,.xml)
	FOR i=1:1:xml { Write xml(i),! }
	DO annot.GetSSXML(planned,.xml)
	FOR i=1:1:xml { Write xml(i),! }
	DO annot.GetDSXML(planned,.xml)
	FOR i=1:1:xml { Write xml(i),! }
	DO annot.GetCTXML(planned,.xml)
	FOR i=1:1:xml { Write xml(i),! }
	Write "</AnnotatedSchema>"
	Quit $$$OK
}

Parameter CONTENTTYPE = "text/xml";

}
