/// Transforms vR4 Patient:communication to SDA3 HS.SDA3.PatientLanguage
Class HS.FHIR.DTL.vR4.SDA3.Patient.communication.PatientLanguage Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Element.Patient.communication, HS.SDA3.PatientLanguage), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Element.Patient.communication' targetClass='HS.SDA3.PatientLanguage' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Patient:communication (vR4) to HS.SDA3.PatientLanguage (SDA3) ]]>
  </annotation>
<if condition='source.language&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Language).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.language, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.language, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.PreferredLanguage' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, languages is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in languages, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
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
