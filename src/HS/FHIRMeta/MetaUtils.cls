Class HS.FHIRMeta.MetaUtils [ Abstract ]
{

/// For every instance of "-" in the given string, convert the following character
/// to uppercase, then strip out the "-". Ex: "address-city" becomes "addressCity".
ClassMethod NormalizeParamName(pParamName As %String) As %String
{
	set normalizedName = pParamName
	set tIdx=0
	for {
		set tIdx = $FIND(normalizedName, "-", tIdx) quit:tIdx=0
		set $E(normalizedName, tIdx-1, tIdx) = $ZCVT($E(normalizedName, tIdx), "U")
	}
	quit normalizedName
}

}
