/// Transforms SDA3 HS.SDA3.Device to vSTU3 Device
Class HS.FHIR.DTL.SDA3.vSTU3.Device.Device Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Device, HS.FHIR.DTL.vSTU3.Model.Resource.Device), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Device' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.Device' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Device (SDA3) to Device (vSTU3) ]]>
  </annotation>
<assign value='aux("transformer").GetPatientReference()' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.patient' action='set' >
<annotation>
<![CDATA[ Patient to whom Device is affixed ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Device")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Device, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Device, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ What kind of device this is
 --- In this case, any FHIR3 code may be used; device-kind shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='source.UDIAssigningAuthority&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.UDIAssigningAuthority)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.udi.jurisdiction' action='set' >
<annotation>
<![CDATA[ Regional UDI authority ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.UDIAssigningAuthority&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.UDIAssigningAuthority) = ""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.udi&apos;=""'> 
<true> 
<assign value='target.udi.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.UDIAssigningAuthority, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.UDIAssigningAuthority, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/device-u-d-i-assigning-authority"' property='tmp.url' action='set' />
<assign value='tmp' property='target.udi.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='source.UDIExtension&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.UDIExtension, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.UDIExtension, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/device-u-d-i-extension"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.UDIRoot&apos;=""'> 
<true>
<if condition='source.UDIRoot&apos;=""'> 
<true> 
<assign value='source.UDIRoot' property='target.udi.deviceIdentifier' action='set' >
<annotation>
<![CDATA[ Mandatory fixed portion of UDI ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Device.Device")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Device.Device") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Device.Device).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Device.Device") ]]></code>
</true>
</if>
</transform>
}

}
