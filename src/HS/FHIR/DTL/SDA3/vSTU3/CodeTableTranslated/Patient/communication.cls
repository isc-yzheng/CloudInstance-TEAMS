/// Transforms SDA3 HS.SDA3.CodeTableTranslated to vSTU3 Patient:communication
Class HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.Patient.communication Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableTranslated, HS.FHIR.DTL.vSTU3.Model.Element.Patient.communication), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableTranslated' targetClass='HS.FHIR.DTL.vSTU3.Model.Element.Patient.communication' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.CodeTableTranslated (SDA3) to Patient:communication (vSTU3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.CodeTableDetail.Language","languages",source)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.language.coding.(1).code' action='set' >
<annotation>
<![CDATA[ The language which can be used to communicate with the patient about his or her health
Note: No SDA codes could be found, so there is no entry in the lookup table. It will always map to an extension, until codes are added
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.CodeTableDetail.Language","languages",source) &apos;= "")'> 
<true>
<assign value='"urn:ietf:bcp:47"' property='target.language.coding.(1).system' action='set' >
<annotation>
<![CDATA[ Identity of the terminology system
 --- This target is one field within a CodeableConcept object assigned to the target Patient:communication[n].language.    ]]>
</annotation>
</assign>
</true>
</if>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.CodeTableDetail.Language","languages",source) = "")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.language&apos;=""'> 
<true> 
<assign value='target.language.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/code-table-translated"' property='tmp.url' action='set' />
<assign value='tmp' property='target.language.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
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
<assign value='source.Description' property='target.language.text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.Patient.communication")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.Patient.communication") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.Patient.communication).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.Patient.communication") ]]></code>
</true>
</if>
</transform>
}

}
