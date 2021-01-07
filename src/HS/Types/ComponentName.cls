Class HS.Types.ComponentName Extends %String
{

/// The maximum number of characters a component name can have. [maxlength of a namespace name]
Parameter MAXLEN As INTEGER = 255;

/// Truncates value <var>%val</var> to <a href="#MAXLEN">MAXLEN</a>, characters.
ClassMethod Normalize(%val As %Library.RawString) As %String [ CodeMode = expression, ServerOnly = 1 ]
{
$ZCVT(%val,"U")
}

}
