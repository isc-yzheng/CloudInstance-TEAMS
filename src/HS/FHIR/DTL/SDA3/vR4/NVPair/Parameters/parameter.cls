/// Transforms SDA3 HS.SDA3.NVPair to vR4 Parameters:parameter
Class HS.FHIR.DTL.SDA3.vR4.NVPair.Parameters.parameter Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.NVPair, HS.FHIR.DTL.vR4.Model.Element.Parameters.parameter), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.NVPair' targetClass='HS.FHIR.DTL.vR4.Model.Element.Parameters.parameter' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.NVPair (SDA3) to Parameters:parameter (vR4) ]]>
  </annotation>
<if condition='source.Name&apos;=""'> 
<true> 
<assign value='source.Name' property='target.name' action='set' >
<annotation>
<![CDATA[ Name from the definition
Note: This is outside the scope of the use for the Parameters resource, but it serves the purpose of having a name-value component that we can map CustomPairs to ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.Value&apos;=""'> 
<true> 
<assign value='source.Value' property='target.valueString' action='set' >
<annotation>
<![CDATA[ If parameter is a data type ]]>
</annotation>
</assign></true> 
</if> 

<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.NVPair.Parameters.parameter")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.NVPair.Parameters.parameter") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.NVPair.Parameters.parameter).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.NVPair.Parameters.parameter") ]]></code>
</true>
</if>
</transform>
}

}
