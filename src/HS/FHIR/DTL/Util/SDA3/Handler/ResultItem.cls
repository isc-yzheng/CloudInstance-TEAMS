Class HS.FHIR.DTL.Util.SDA3.Handler.ResultItem
{

/// Extract the numeric value from the source. If it is not numeric,
/// nothing will be returned.
ClassMethod ResultValue(source As %String) As %String
{
	if '##class(HS.FHIR.DTL.Utils).IsNumeric(source, 1) quit ""
	while '$isvalidnum(source) {
		if source = "" quit
		set source = $extract(source, 2, *)
	}
	quit source
}

/// Return the comparator, as long as it is one of <, >, <=, >=
ClassMethod ResultComparator(source As %String) As %String
{
	set comp = ""
	while '$isvalidnum(source) {
		if source = "" quit
		set comp = comp _ $extract(source, 1)
		set source = $extract(source, 2, *)
	}
	if (comp = "<") || (comp = "<=") || (comp = ">=") || (comp = ">") {
		quit comp
	}
	elseif (comp = "=>") {
		quit ">="
	}
	elseif (comp = "=<") {
		quit "<="
	}
	else {
		quit ""
	}
}

/// Extract the normal range for the result from a string and save
/// it in an Observation:referenceRange element.
ClassMethod ResultNormalRange(source As %String, ByRef aux) As %RegisteredObject
{
	if source = "" quit ""
	set packageModel = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageModelName(aux("transformer").fhirVersion)
	if (packageModel = "") quit
	set refRange = $classmethod(packageModel _ ".Element.Observation.referenceRange", "%New")
	
	//Everything below here has been adapted from the vDSTU2 transforms, and modified to use
	//the XF data model
	s colons = $l(source,":")-1
	s slashes = $l(source,"/")-1
	s dashes = $l(source,"-")-1
	
	s subString = $e(source,2,*)
	
	#; ltGtNumeric:
	#; 0 = both sides of delimiter are numeric
	#; 1 = starts with >=
	#; 2 = starts with =>
	#; 3 = starts with <=
	#; 4 = starts with =<
	#; 5 = values are not numeric
	
	i (colons>1)||(slashes>1) {
		s ltGtNumeric = 5
	} elseif colons=1 {
		s tLeft = $p(source,":",1)
		s tRight = $p(source,":",2)
		i (##class(HS.FHIR.DTL.Utils).IsNumeric(tLeft))&&(##class(HS.FHIR.DTL.Utils).IsNumeric(tRight)) {
			s ltGtNumeric = 0
		} else {
			s ltGtNumeric = 5
		}
	} elseif slashes=1 {
		s tLeft = $p(source,"/",1)
		s tRight = $p(source,"/",2)
		i (##class(HS.FHIR.DTL.Utils).IsNumeric(tLeft))&&(##class(HS.FHIR.DTL.Utils).IsNumeric(tRight)) {
			s ltGtNumeric = 0
		} else {
			s ltGtNumeric = 5
		}
	} elseif (source?1">="1e.e)&&(##class(HS.FHIR.DTL.Utils).IsNumeric($e(source,3,*))) {
		s ltGtNumeric = 1
	} elseif (source?1"=>"1e.e)&&(##class(HS.FHIR.DTL.Utils).IsNumeric($e(source,3,*))) {
		s ltGtNumeric = 2
	} elseif (source?1"<="1e.e)&&(##class(HS.FHIR.DTL.Utils).IsNumeric($e(source,3,*))) {
		s ltGtNumeric = 3
	} elseif (source?1"=<"1e.e)&&(##class(HS.FHIR.DTL.Utils).IsNumeric($e(source,3,*))) {
		s ltGtNumeric = 4
	} elseif dashes=1 {
		s tLeft = $p(source,"-",1)
		s tRight = $p(source,"-",2)
		i (##class(HS.FHIR.DTL.Utils).IsNumeric(tLeft))&&(##class(HS.FHIR.DTL.Utils).IsNumeric(tRight)) {
			s ltGtNumeric = 0
		} else {
			s ltGtNumeric = 5
		}
	} elseif (dashes>1)&&($e(source)'="-") {
		s ltGtNumeric = 5
	} elseif dashes=2 {
		s tRight = $p(source,"-",3)
		i ##class(HS.FHIR.DTL.Utils).IsNumeric(tRight) {
			set ltGtNumeric = 0
		} else {
			set ltGtNumeric = 5
		}
	} elseif dashes=3 {
		s tLeft = $p(source,"-",2)
		s tRight = $p(source,"-",4)
		i (##class(HS.FHIR.DTL.Utils).IsNumeric(tLeft))&&(##class(HS.FHIR.DTL.Utils).IsNumeric(tRight)) {
			s ltGtNumeric = 0
		} else {
			s ltGtNumeric = 5
		}
	} elseif ##class(HS.FHIR.DTL.Utils).IsNumeric(source) {
		s ltGtNumeric = 5
	} else {
		s ltGtNumeric = 0
	}
	
	s low = ""
	i (ltGtNumeric=1)||(ltGtNumeric=2) {
		s low = $e(source,3,*)
	} elseif $e(source)="-" {
		i (subString["-")&&(subString'[":")&&(subString'["/") {
			s low = "-"_$p(source,"-",2)
		} elseif subString[":" {
			s low = $p(source,":",1)
		} elseif subString["/" {
			s low = $p(source,"/",1)
		}
	} elseif source["-" {
		s low = $p(source,"-",1)
	} elseif source[":" {
		s low = $p(source,":",1)
	} elseif source["/" {
		s low = $p(source,"/",1)
	} else {
		s low = source
	}
	
	s high = ""
	i (ltGtNumeric=3)||(ltGtNumeric=4) {
		s high = $e(source,3,*)
	} elseif $e(source)="-" {
		i (subString["-")&&(subString'[":")&&(subString'["/") {
			i dashes=2 {
				s high = $p(source,"-",3)
			} elseif dashes=3 {
				s high = "-"_$p(source,"-",4)
			}
		} elseif subString[":" {
			s high = $p(source,":",2)
		} elseif subString["/" {
			s high = $p(source,"/",2)
		}
	} elseif source["-" {
		s high = $p(source,"-",2)
	} elseif source[":" {
		s high = $p(source,":",2)
	} elseif source["/" {
		s high = $p(source,"/",2)
	} else {
		s high = source
	}
	
	if ##class(HS.FHIR.DTL.Utils).IsNumeric(low) {
		set lowQuant = $classmethod(packageModel _ ".Datatype.SimpleQuantity", "%New")
		set lowQuant.value = low
		set refRange.low = lowQuant
	}
	if ##class(HS.FHIR.DTL.Utils).IsNumeric(high) {
		set highQuant = $classmethod(packageModel _ ".Datatype.SimpleQuantity", "%New")
		set highQuant.value = high
		set refRange.high = highQuant
	}
	set refRange.text = source
	
	quit refRange
}

}
