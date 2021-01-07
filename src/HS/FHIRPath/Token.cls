Include HS.FHIRPath.Parser

Class HS.FHIRPath.Token Extends %RegisteredObject
{

/// Non-empty if the token can be an identifier
Property idName As %String;

/// If non-empty, then idName is a literal value and this field indicates the
/// datatype
Property literalType As %String;

/// If non-empty, this is a marker, and the value is the closing token
Property markerName As %String;

/// Non-empty if the token can be an operator
Property opName As %String;

/// Precedence value if an operator
Property opPrecedence As %Numeric;

/// opUsage: string describing the operator possible usages as a 3 character string
/// "bup" where each position is either the letter, blank or missing.  If present, it indicates
/// that the operator is valid as:  "b": a binary operator, "u": a unary operator, "p": a post-unary
/// operator (it appears after its operand)
Property opUsage As %String;

ClassMethod NewIdentifier(name As %String, literalType = "") As Token
{
	Set token = ..%New()
	Set token.idName = name
	Set token.literalType = literalType
	return token
}

ClassMethod NewOperator(name As %String, opPrecedence As %Numeric, opUsage As %String) As Token
{
	Set token = ..%New()
	Set token.opName = name
	Set token.opPrecedence = opPrecedence
	Set token.opUsage = opUsage
	return token
}

ClassMethod NewIdOp(name As %String, opPrecedence As %Numeric, opUsage As %String) As Token
{
	Set token = ..%New()
	Set token.opName = name
	Set token.opPrecedence = opPrecedence
	Set token.opUsage = opUsage
	// Or it could be an identifier
	Set token.idName = name
	Set token.literalType = ""
	return token
}

ClassMethod NewMarker(openName As %String, closeName As %String) As Token
{
	Set token = ..%New()
	Set token.idName = openName
	Set token.markerName = closeName
	return token
}

Method %OnNew() As %Status [ Private ]
{
	return $$$OK
}

Method asString() As %String
{
	Set str = ""
	if ..opName'="" {
		Set str = str _ $Select(..idName '= "":"IDOP '", 1:"OP   '")
		Set usage = ""
		Set:$E(..opUsage,1)="b" usage = usage _ "Binary|" 
		Set:$E(..opUsage,2)="u" usage = usage _ "Unary|" 
		Set:$E(..opUsage,3)="p" usage = usage _ "PostUnary|" 
		Set str = str _ ..opName _ "' " _ ..opPrecedence _ " usage: " _ $E(usage,1,*-1)
	} elseif ..idName'="" {
		if ..markerName'="" {
			Set str = "MARK '" _ ..idName _ "' close with "_ ..markerName
		} elseif ..literalType'="" {
			Set str = "LIT  '" _ ..idName _ "' as "_ ..literalType
		} else {
			Set str = "ID   '" _ ..idName _ "'"
		}
	} 
	return str
}

}
