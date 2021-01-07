Class HS.FHIR.DTL.Util.SDA3.Handler.Quantity
{

/// Strip off any non-numeric characters and return
/// the numeric value of a string passed in.
ClassMethod Value(source As %String) As %Numeric
{
	set returnString = ""
	for i=1:1:$length(source) {
		for j=$length(source):-1:1 {
			set substring = $extract(source, i, j)
			if $isvalidnum(substring) {
				if (returnString [ substring) continue
				if (returnString '= "") return ""
				
				set returnString = substring
			}
		}
	}
	quit returnString
}

/// Return the units for the string passed in.
ClassMethod Unit(source As %String) As %String
{
	if ..Value(source) = "" quit ""
	
	set returnString = $replace(source, ..Value(source), "")
	while $extract(returnString, 1) = " " {
		set returnString = $extract(returnString, 2, *)
	}
	while $extract(returnString, *) = " " {
		set returnString = $extract(returnString, 1, *-1)
	}
	quit returnString
}

}
