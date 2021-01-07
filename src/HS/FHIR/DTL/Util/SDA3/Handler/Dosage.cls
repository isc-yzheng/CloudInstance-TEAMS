Class HS.FHIR.DTL.Util.SDA3.Handler.Dosage
{

/// Convert a Dosage CodeTable into a Timing datatype within FHIR.
ClassMethod Frequency(source As %RegisteredObject) As %RegisteredObject
{
	set timing = ""
	
	set frequency = ##class(HS.FHIR.DTL.Utils).GetFrequency(source.Code, source.Description)
	
	set packageModel = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageModelName("FHIR3")
	if (packageModel = "") quit
	
	if frequency '= "" {
		set timing = $classmethod(packageModel _ ".Datatype.Timing", "%New")
		if $piece(frequency, "|", 1) '= "" {
			set code = $classmethod(packageModel _ ".Datatype.CodeableConcept", "%New")
			set coding = $classmethod(packageModel _ ".Datatype.Coding", "%New")
			
			set coding.code = $piece(frequency, "|", 1)
			set coding.display = $piece(frequency, "|", 2)
			set coding.system = $piece(frequency, "|", 3)
			do code.coding.Insert(coding)
			set code.text = $piece(frequency, "|", 2)
			
			set timing.code = code
		}
		if $piece(frequency, "|", 4) '= "" {
			set repeat = $classmethod(packageModel _ ".Element.Timing.repeat", "%New")
			
			set repeat.frequency = $piece(frequency, "|", 4)
			set repeat.period = $piece(frequency, "|", 5)
			set repeat.periodUnit = $piece(frequency, "|", 6)
			if $piece(frequency, "|", 7) '= "" {
				do repeat.when.Insert($piece(frequency, "|", 7))
			}
			
			set timing.repeat = repeat
		}
	}
	quit timing
}

}
