Class HS.FHIRServer.Tools.ValueReader Extends %RegisteredObject [ Abstract ]
{

ClassMethod readString(pName As %String, pCurValue As %String, pIsRequired As %Boolean = 0) As %String
{
	SeT tCurValue = $Select(pCurValue'="":pCurValue, 1:"-")
	set prompt = pName _ "[" _ tCurValue _ "]"
	for {
		w prompt
		Read "", ": ", value
		if value="-" {
			// We are being asked to clear the value
			Set value = ""
		} elseif value="" {
			// Default value was accepted
			Set value = pCurValue
			w value
		}
		w !
		if ((value '= "") || 'pIsRequired) {
			Quit
		}
	}
	return value
}

ClassMethod readNumber(pName As %String, pCurValue As %String, range = "", getList As %Boolean = 0) As %String
{
	SeT tCurValue = $Select(pCurValue'="":pCurValue, 1:0)
	set prompt = pName _ "[" _ pCurValue _ "]"
	if range '= "" {
		Set prompt = prompt _ " (" _ $lg(range,1) _ "-" _ $lg(range,2) _ ")"
	}
	for {
		w prompt
		Read "", ": ", value
		if value="" {
			if getList {
				w !
				return ""
			}
			// Default value was accepted
			Set value = tCurValue
			w value
		}
		w !
		Set values = $ListFromString(value, ",")
		if 'getList && ($LL(values) > 1) {
			w !, "*** Only One value allowed ***",!
			Continue
		}
		set lix = 0
		set ok = 1
		kill VALUES
		while $ListNext(values, lix, value) {
			Set numVal = +value
			if (numVal = value) {
				Set value = numVal
				if range '="" {
					if (value < $lg(range,1)) || (value > $lg(range,2)) {
						w !, "*** Enter a number from ",$lg(range,1), " to ",$lg(range,2), "***",!
						set ok = 0
						Quit
					}
				}
				Set VALUES(value) = ""
			} else {
				w !, "*** Invalid Numeric Input ***",!
				set ok = 0
				Quit
			}
		}
		Continue:'ok
		if 'getList {
			return $O(VALUES(""))
		} else {
			Set result = ""
			set value = ""
			for {
				Set value = $O(VALUES(value))
				Quit:value=""
				Set $List(result,*+1) = value
			}	
		}
		return result
	}
}

ClassMethod readBoolean(pName As %String, pCurValue As %Boolean, isRequired As %Boolean = 0, choices As %String = "") As %Boolean
{
	if choices = "" {
		Set tTrue = "true"
		Set tFalse = "false"
	} else {
		Set tTrue = $LG(choices,1)	
		Set tFalse = $LG(choices,2)	
	}
	Set tTrueChar = $E(tTrue)
	Set tFalseChar = $E(tFalse)
	
	Set tCurValue = $Select(pCurValue:tTrue, 1:tFalse)
	set prompt = pName
	if 'isRequired {
		Set prompt = prompt _ "[" _ tCurValue _ "]"
	}
	for {
		w prompt _  " (" _ $E(tTrue)_"/"_$E(tFalse)_")"
		Read "", ": ", value
		Set start = 2
		if (value="") {
			Set:('isRequired) value = $E(tCurValue)
			Set start = 1
		}
		if value=tTrueChar {
			Set value = 1
		} elseif value=tFalseChar {
			Set value = 0
		} else {
			w value,!,"Please enter '"_tTrueChar_"' or '"_tFalseChar_"'",!
			Continue
		}
		w $E($Select(value:tTrue, 1:tFalse),start,*), !
		Quit
	}
	return value
}

ClassMethod readYesNo(pName As %String, pCurValue As %Boolean, isRequired As %Boolean = 0) As %Boolean
{
	return ..readBoolean(pName, pCurValue, isRequired, $LB("yes", "no"))
}

}
