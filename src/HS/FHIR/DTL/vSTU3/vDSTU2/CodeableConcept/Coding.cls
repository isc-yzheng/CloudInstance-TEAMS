/// Transforms vSTU3 CodeableConcept to vDSTU2 Coding
Class HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.Coding Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept, HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CodeableConcept (vSTU3) to Coding (vDSTU2) ]]>
  </annotation>
<if condition='source.coding&apos;=""'> 
<true>
<if condition='source.coding.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding' targetObj='tmp' sourceObj='source.coding.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ A Coding is a representation of a defined concept using a symbol from a defined "code system"
 --- FHIR STU3 CodeableConcept:coding is a *List*, and FHIR DSTU2 Coding is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.
 --- The source and target use different value sets. FHIR STU3 CodeableConcept:coding uses value set (*) and FHIR DSTU2 Coding uses value set . 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field.    ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.coding&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.coding()' key='k1' >
<if condition='source.coding.(k1).extension&apos;=""'> 
<true>
<foreach property='source.coding.(k1).extension()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.coding.(k1).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.coding.Count()>0'> 
<true>
<if condition='source.coding.(1).id&apos;=""'> 
<true>
<if condition='source.coding.(1).id&apos;=""'> 
<true> 
<assign value='source.coding.(1).id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.coding&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.coding()' key='k1' >
<if condition='source.coding.(k1).primitiveExtension&apos;=""'> 
<true>
<foreach property='source.coding.(k1).primitiveExtension()' key='st' >
<assign value='target.primitiveExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.coding.(k1).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</foreach>
</true>
</if>
</transform>
}

}
