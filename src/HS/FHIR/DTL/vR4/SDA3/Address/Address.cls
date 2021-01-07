/// Transforms vR4 Address to SDA3 HS.SDA3.Address
Class HS.FHIR.DTL.vR4.SDA3.Address.Address Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Datatype.Address, HS.SDA3.Address), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Datatype.Address' targetClass='HS.SDA3.Address' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Address (vR4) to HS.SDA3.Address (SDA3) ]]>
  </annotation>
<if condition='source.city&apos;=""'> 
<true>
<if condition='source.city&apos;=""'> 
<true> 
<assign value='source.city' property='target.City.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.country&apos;=""'> 
<true>
<if condition='source.country&apos;=""'> 
<true> 
<assign value='source.country' property='target.Country.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.district&apos;=""'> 
<true>
<if condition='source.district&apos;=""'> 
<true> 
<assign value='source.district' property='target.County.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<foreach property='source.line()' key='ls1' >
<if condition='ls1=1' >
<true>
<assign value='source.line.(ls1)' property='target.Street' action='set' >
<annotation>
<![CDATA[ Everything in the address before city
 --- SDA3 HS.SDA3.Address:Street is type %String with a maximum string length of *220*. 
 --- FHIR4 Address:line is a *List*, and SDA3 HS.SDA3.Address:Street is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true>
<false>
<assign value='target.Street _ "; " _ source.line.(ls1)' property='target.Street' action='set' />
</false>
</if>
</foreach>
<if condition='source.period&apos;=""'> 
<true>
<if condition='source.period.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.period.end)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ Effective end date for this address ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.period&apos;=""'> 
<true>
<if condition='source.period.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.period.start)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Effective start date for this address ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.postalCode&apos;=""'> 
<true>
<if condition='source.postalCode&apos;=""'> 
<true> 
<assign value='source.postalCode' property='target.Zip.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.state&apos;=""'> 
<true>
<if condition='source.state&apos;=""'> 
<true> 
<assign value='source.state' property='target.State.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</transform>
}

}
