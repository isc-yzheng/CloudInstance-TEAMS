/// Transforms vSTU3 MedicationAdministration to SDA3 HS.SDA3.Medication
Class HS.FHIR.DTL.vSTU3.SDA3.MedicationAdministration.Medication Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.MedicationAdministration, HS.SDA3.Medication), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.MedicationAdministration' targetClass='HS.SDA3.Medication' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms MedicationAdministration (vSTU3) to HS.SDA3.Medication (SDA3) ]]>
  </annotation>
<if condition='source&apos;=""'> 
<true>
<assign value='target.Administrations.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.Administration).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.FHIR.DTL.vSTU3.SDA3.MedicationAdministration.Administration")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Administrations' action='set' key='index'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.medicationReference&apos;=""'> 
<true>
<assign value='target' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.medicationReference, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.prescription&apos;=""'> 
<true>
<assign value='target' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.prescription, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target' action='set' /></true> 
</if> 
</true>
</if>
</transform>
}

}
