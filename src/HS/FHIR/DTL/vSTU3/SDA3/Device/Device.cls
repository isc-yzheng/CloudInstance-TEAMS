/// Transforms vSTU3 Device to SDA3 HS.SDA3.Device
Class HS.FHIR.DTL.vSTU3.SDA3.Device.Device Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Device, HS.SDA3.Device), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Device' targetClass='HS.SDA3.Device' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Device (vSTU3) to HS.SDA3.Device (SDA3) ]]>
  </annotation>
<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Device).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.type, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableDetail")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.type, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Device' action='set'  >
<annotation>
<![CDATA[ Coded value for device type (e.g. implantable pacemaker)
 --- In this case, any FHIR3 code may be used; device-kind shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.udi&apos;=""'> 
<true>
<if condition='source.udi.deviceIdentifier&apos;=""'> 
<true>
<if condition='source.udi.deviceIdentifier&apos;=""'> 
<true> 
<assign value='source.udi.deviceIdentifier' property='target.UDIRoot' action='set' >
<annotation>
<![CDATA[ Root of Unique Device Identifier, typically FDA OID
 --- SDA3 HS.SDA3.Device:UDIRoot is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.udi&apos;=""'> 
<true>
<if condition='source.udi.jurisdiction&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetCodeForURI(source.udi.jurisdiction)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.UDIAssigningAuthority' action='set' >
<annotation>
<![CDATA[ Assigning Authority for Unique Device Identifier, typically FDA
 --- SDA3 HS.SDA3.Device:UDIAssigningAuthority is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</transform>
}

}
