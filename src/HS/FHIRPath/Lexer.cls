Include HS.FHIRPath.Parser

Class HS.FHIRPath.Lexer Extends %RegisteredObject
{

Property fpmeta [ MultiDimensional ];

Method %OnNew() As %Status
{
	Do ..initMeta()
	
	if 0 {
		for type = "kwd","ops" {
			set name = ""
			for {
				Set name = $order(..fpmeta(type, name), 1, obj)
				Quit:name=""
				w type,"|", obj.asString(),!
			}
		}
	}
	return $$$OK
}

Method lex(expr As %String, Output tokens)
{
	Set tokens = 0
	Set start = 1
	Set cur = 1
	Set end = $length(expr)
	
	// Loop through the entire String
	for {
		// Before each token, eliminate whitespace
		while $E(expr, start) = " " {
			Do $I(start)
		}
		quit:start>end
		
		// Now extract a single token
		Set cur = start
		
		Set token = $E(expr, cur)
		Set cur = cur+1
		if $D(..fpmeta("delim", token), info) {
			// This is a punctuation character
			Set token2 = token _ $E(expr, cur)
			if $D(..fpmeta("ops", token2), info2) {
				// First check for a 2-character delimiter
				Set cur = cur+1
				$$$PushToken(info2)
			} else {
				if token = "'" {
					// This is a string literal
					while (cur <= end) && ($E(expr, cur) '= "'") {
						if $E(expr,cur) = "\" {
							Set cur = cur + 1
						}
						Set cur = cur + 1 
					}
					if cur <= end {
						Set token = $E(expr, start+1,cur-1)
						Set cur = cur+1
						$$$PushToken($$$NewLiteral(token,"string"))
					} else {
						Set token = $E(expr, start,*)
						$$$LexError("Error: Unclosed String literal: " _token)
					}
				} elseif $D(..fpmeta("ops", token), info) {
					$$$PushToken(info)
				} else {
					// This is a valid one-character operator (some delimiters (like !) are not
					// valid as single character operators
					$$$LexError( "Error: Character '" _ token _ "' is not a valid single-character delimiter")
				}
			}
		} elseif $D(..fpmeta("digit",token)) {
			// Numeric Literal
			Set dots = 0
			Set nonDigit = 0
			while (cur <= end) {
				Set token = $E(expr, cur)
				if '$D(..fpmeta("digit", token)) {
					if token = "." 	{
						Set dots = dots + 1
					} elseif $D(..fpmeta("delim", token)) {
						quit
					} else {
						Set nonDigit = nonDigit + 1
					}
				}
				Set cur = cur + 1
			}
			Set token = $E(expr, start, cur-1)
			if (dots > 1) || (nonDigit > 0) {
				$$$LexError( "Error: Invalid Number: " _ token)
			} else {
				//w "Valid Number: ", token,!	
				$$$PushToken($$$NewLiteral(token,$Select(dots=1:"decimal",1:"integer")))
			}
		} else {
			while (cur <= end) && '$D(..fpmeta("delim", $E(expr,cur)))
			{
				 Set cur = cur + 1 
			}
			Set token = $E(expr, start, cur-1)
			if $D(..fpmeta("kwd", token), info) {
				$$$PushToken(info)
			} else {
				$$$PushToken($$$NewIdentifier(token))
			}
		}
		set start = cur
	}
	// Add an EOL marker
	$$$PushToken($$$NewOperator("EOT", 0,"  p"))
}

Method initMeta()
{
	Do addChars("delim", " .,[]()'+-*/&|=~<>", 1)
	Do addChars("delim", "!{", 0)
	Do addChars("digit", "0123456789", 0)
	Do addChars("hexdigit", "0123456789abcdefABCDEF", 1)
	// Operators in precedence order (high to low)
	Do addList("ops", $LB("."), $LB("OP", 90))
	Do addList("ops", $LB("*", "/"), $LB("OP",60))
	Do addList("kwd", $LB("mod"), $LB("OP",60))
	Do addList("kwd", $LB("div"), $LB("IdOp",60))
	Do addList("ops", $LB("&"), $LB("OP",50))
	Do addList("ops", $LB("+", "-"), $LB("OP",50, "bu"))
	Do addList("kwd", $LB("is", "as"), $LB("IdOp", 45))
	Do addList("ops", $LB("|"), $LB("OP", 40))
	Do addList("ops", $LB("<=",">=","<", ">"), $LB("OP",35))
	Do addList("ops", $LB("!=","!~","=", "~"), $LB("OP",30))
	Do addList("kwd", $LB("in", "contains"), $LB("IdOp", 25))
	Do addList("kwd", $LB("and"), $LB("OP", 20))
	Do addList("kwd", $LB("or", "xor"), $LB("OP", 15))
	Do addList("kwd", $LB("implies"), $LB("OP", 10))
	Do addList("ops", $LB(")", "]", ","), $LB("OP", 0))
	// Other Punctuation
	Do addList("ops", $LB("["), $LB("Punc", "]"))
	Do addList("ops", $LB("("), $LB("Punc", ")"))
	// Literals
	Do addList("ops", $LB("{}"), $LB("Lit", "null"))
	Do addList("kwd", $LB("true", "false"), $LB("Lit", "boolean"))
	Do addList("kwd", $LB("millisecond", "milliseconds", "minute", "minutes", "week", "weeks","year",  "years", "month", "months", "day", "days", "second", "seconds", "hour", "hours"), $LB("OP", 90, "  p"))
	Do addList("kwd", $LB("$index","$this", "$total"), $LB("Lit", "inv"))
	
	return
	
addChars(key, str, value)
	Set len = $Length(str)
	for ord=1:1:len {
		Set ..fpmeta(key, $E(str,ord)) = value
	}
	Quit
	
addList(key, nameList, configList)
	set lix = 0
	while $ListNext(nameList, lix, name) {
		Set type = $LG(configList, 1)
		if type = "OP" {
			Set precedence = $LG(configList,2)
			set usage = $Select($LG(configList,3)="":"b", 1:$LG(configList,3))
			Set token = $$$NewOperator(name,precedence,usage)
		} elseif type = "IdOp" {
			Set precedence = $LG(configList,2)
			set usage = $Select($LG(configList,3)="":"b", 1:$LG(configList,3))
			Set token = $$$NewIdOp(name,precedence,usage)
		} elseif type = "Lit" {
			Set datatype = $LG(configList,2)
			Set token = $$$NewLiteral(name,datatype)
		} elseif type = "Punc" {
			Set close = $LG(configList, 2)
			Set token = $$$NewMarker(name,close)
		} else {
			$$$LexError( "Internal Error: Unknown Token type during initMeta")
		}
		Set ..fpmeta(key, name) = token
	}
	Quit
}

}
