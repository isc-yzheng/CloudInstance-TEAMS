Class HS.FHIR.DTL.Util.API.FHIR
{

ClassMethod FHIRToFHIR(sourceFHIRVersion As %String, targetFHIRVersion As %String, resourceStreamIn As %Stream.TmpCharacter = "", resourceObjectIn As %RegisteredObject = "", Output resourceStreamOut As %Stream.TmpCharacter, Output resourceObjectOut As %RegisteredObject) As %Status
{
	set tSC = $$$OK
	try {
		if ($get(resourceObjectIn) = "") {
			if ($get(resourceStreamIn) = "") {
				set tSC = $$$ERROR($$$GeneralError, "No resource provided")
				quit
			}
			else {
				set tSC = ##class(HS.FHIR.DTL.Util.JSON.Adapter).FromJSON(resourceStreamIn.Read(), .resourceObjectIn, $extract(sourceFHIRVersion, *))
				quit:$$$ISERR(tSC)
			}
		}
		if '$isobject(resourceObjectIn) {
			set tSC = $$$ERROR($$$GeneralError, "Could not create source object")
		}
		
		set DTL = $order(^HS.XF.Transform(sourceFHIRVersion,targetFHIRVersion,resourceObjectIn.resourceType, ""))
		if DTL = "" {
			set tSC = $$$ERROR($$$GeneralError, "Cannot find transform for " _ resourceObjectIn.resourceType)
			quit
		}
		while DTL '= "" {
			set tSC = $classmethod(DTL, "Transform", resourceObjectIn, .resourceObjectOut, .aux)
			quit:$$$ISERR(tSC)
			
			set resourceStreamOut = resourceObjectOut.ToJSON()
			
			set DTL = $order(^HS.XF.Transform("SDA3","vSTU3",resourceObjectIn.resourceType, DTL))
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod DSTU2ToSTU3(resourceStreamIn As %Stream.TmpCharacter = "", resourceObjectIn As %RegisteredObject = "", Output resourceStreamOut As %Stream.TmpCharacter, Output resourceObjectOut As %RegisteredObject) As %Status
{
	quit ..FHIRToFHIR("vDSTU2", "vSTU3", resourceStreamIn, resourceObjectIn, .resourceStreamOut, .resourceObjectOut)
}

ClassMethod STU3ToDSTU2(resourceStreamIn As %Stream.TmpCharacter = "", resourceObjectIn As %RegisteredObject = "", Output resourceStreamOut As %Stream.TmpCharacter, Output resourceObjectOut As %RegisteredObject) As %Status
{
	quit ..FHIRToFHIR("vSTU3", "vDSTU2", resourceStreamIn, resourceObjectIn, .resourceStreamOut, .resourceObjectOut)
}

}
