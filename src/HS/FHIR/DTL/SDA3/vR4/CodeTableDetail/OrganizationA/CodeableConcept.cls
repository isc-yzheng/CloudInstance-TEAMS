/// Transforms SDA3 HS.SDA3.CodeTableDetail.OrganizationA to vR4 CodeableConcept
Class HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.OrganizationA.CodeableConcept Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableDetail.OrganizationA, HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableDetail.OrganizationA' targetClass='HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.CodeTableDetail.OrganizationA (SDA3) to CodeableConcept (vR4) ]]>
  </annotation>
<if condition='source.Code&apos;=""'> 
<true>
<if condition='source.Code&apos;=""'> 
<true> 
<assign value='source.Code' property='target.coding.(1).code' action='set' >
<annotation>
<![CDATA[ Code defined by a terminology system ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.CodeSystemVersionId&apos;=""'> 
<true>
<if condition='source.CodeSystemVersionId&apos;=""'> 
<true> 
<assign value='source.CodeSystemVersionId' property='target.coding.(1).version' action='set' >
<annotation>
<![CDATA[ Version of the system - if relevant ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "ContactInfo")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ContactInfo, "HS.FHIR.DTL.SDA3.vR4.ContactInfo.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ContactInfo, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/code-table-detail-organization-a-contact-info"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='source.Description&apos;=""'> 
<true>
<if condition='source.Description&apos;=""'> 
<true> 
<assign value='source.Description' property='target.coding.(1).display' action='set' >
<annotation>
<![CDATA[ Representation defined by the system ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.SDACodingStandard&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.SDACodingStandard)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.coding.(1).system' action='set' >
<annotation>
<![CDATA[ Identity of the terminology system ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.SDACodingStandard&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.SDACodingStandard) = ""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.coding&apos;="") &amp;&amp; (target.coding.Count() &gt; 0)'> 
<true> 
<if condition='target.coding.(1)&apos;=""'> 
<true> 
<assign value='target.coding.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.SDACodingStandard, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.StrippedString.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.SDACodingStandard, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/code-table-detail-organization-a-s-d-a-coding-standard"' property='tmp.url' action='set' />
<assign value='tmp' property='target.coding.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<foreach property='source.Trusts()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Trusts.(st), "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Trusts.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/code-table-detail-organization-a-trusts"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.OrganizationA.CodeableConcept")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.OrganizationA.CodeableConcept") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.OrganizationA.CodeableConcept).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.CodeTableDetail.OrganizationA.CodeableConcept") ]]></code>
</true>
</if>
</transform>
}

}
