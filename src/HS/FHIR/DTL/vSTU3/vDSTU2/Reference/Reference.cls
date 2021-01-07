/// Transforms vSTU3 Reference to vDSTU2 Reference
Class HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Base.Reference, HS.FHIR.DTL.vDSTU2.Model.Base.Reference), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Base.Reference' targetClass='HS.FHIR.DTL.vDSTU2.Model.Base.Reference' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Reference (vSTU3) to Reference (vDSTU2) ]]>
  </annotation>
<if condition='source.display&apos;=""'> 
<true> 
<assign value='source.display' property='target.display' action='set' >
<annotation>
<![CDATA[ Text alternative for the resource ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.extension&apos;=""'> 
<true>
<foreach property='source.extension()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.extension.(st)' aux='.aux' />
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
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.primitiveExtension()' key='st' >
<assign value='target.primitiveExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.primitiveExtension.(st)' aux='.aux' />
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
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Reference).ConvertResourceType("vSTU3", "vDSTU2", source.reference)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.reference' action='set' >
<annotation>
<![CDATA[ Literal reference, Relative, internal or absolute URL ]]>
</annotation>
</assign></true> 
</if> 
</transform>
}

}
