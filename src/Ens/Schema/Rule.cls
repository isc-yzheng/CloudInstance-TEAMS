/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class Ens.Schema.Rule Extends %RegisteredObject [ ClassType = "", ProcedureBlock, System = 4 ]
{

XData Schema
{
<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified">

<xs:element name="ruleDefinition">
<xs:complexType>
<xs:sequence>
<xs:element name="ruleSet" minOccurs="1" maxOccurs="unbounded">
<xs:complexType>
<xs:sequence>
<xs:element name="effectiveBeginDateTime" type="xs:string" minOccurs="0"/>
<xs:element name="effectiveEndDateTime" type="xs:string" minOccurs="0"/>
<xs:element name="description" type="xs:string" minOccurs="0"/>
<xs:element name="reportGroup" type="xs:string" minOccurs="0"/>
<xs:element name="reportName" type="xs:string" minOccurs="0"/>
<xs:element name="shortDescription" type="xs:string" minOccurs="0"/>
<xs:element name="rule" minOccurs="0" maxOccurs="unbounded">
<xs:complexType>
<xs:sequence>
<xs:element ref="activities" minOccurs="1" maxOccurs="1"/>
</xs:sequence>
<xs:attribute name="disabled" type="xs:boolean" use="optional"/>
</xs:complexType>
</xs:element>
</xs:sequence>
<xs:attribute name="context" type="xs:string" use="optional"/>
<xs:attribute name="default" type="xs:string" use="optional"/>
</xs:complexType>
</xs:element>
</xs:sequence>
<xs:attribute name="name" type="non_empty_string" use="required"/>
</xs:complexType>
</xs:element>

<xs:complexType name="activities">
<xs:complexContent>
<xs:choice minOccurs="0" maxOccurs="unbounded">
<xs:element ref="condition"/>
<xs:element ref="action"/>
<xs:element ref="return"/>
<xs:element ref="foreach"/>
</xs:choice>
</xs:complexContent>
</xs:complexType>

<xs:complexType name="condition">
<xs:sequence>
<xs:element name="if" minOccurs="1" maxOccurs="1">
<xs:complexType>
<xs:sequence>
<xs:element ref="activities"/>
</xs:sequence>
<xs:attribute name="condition" type="xs:string" use="required"/>
</xs:complexType>
</xs:element>
</xs:sequence>
</xs:complexType>

<xs:complexType name="foreach">
<xs:element name="propertypath" type="xs:string" minOccurs="1" maxOccurs="1"/>
<xs:complexType>
<xs:sequence>
<xs:element ref="activities" minOccurs="1" maxOccurs="1"/>
</xs:sequence>
</xs:complexType>
</xs:complexType>

<xs:element name="action">
<xs:complexType>
<xs:attribute name="type" use="required">
<xs:simpleType>
<xs:restriction base="xs:string">
<xs:enumeration value="append"/>
<xs:enumeration value="assign"/>
</xs:restriction> 
</xs:simpleType>
</xs:attribute>
<xs:attribute name="property" type="xs:string" use="required"/>
<xs:attribute name="value" type="xs:string" use="required"/>
</xs:complexType>
</xs:element>

<xs:element name="return" type="xs:string"/>

\<xs:simpleType name="non_empty_string">
<xs:restriction base="xs:string">
<xs:minLength value="1"/>
</xs:restriction>
</xs:simpleType>

</xs:schema>
}

}
