Class HS.Types.IHE.Errors Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Errors As list Of HS.Types.IHE.Error(XMLNAME = "Error", XMLPROJECTION = "ELEMENT");

Property HighestError As %String;

Method logError(pCode, pSeverity, pDescription, pLocation)
{
	Set tError=##class(HS.Types.IHE.Error).%New()
	Set tError.Code=pCode
	Set tError.Description=pDescription
	Set tError.Severity=pSeverity
	Set tError.Location=$g(pLocation)
	Do ..Errors.Insert(tError)
	Do ..setHighest(tError)
}

/// Update highest error
Method setHighest(pError As HS.Types.IHE.Error)
{
	If pError.Severity="Error" {
		Set ..HighestError="Error"
	} else {
		Set:..HighestError="" ..HighestError=pError.Severity
	}
}

/// present errors as text for simple output in unit tests
Method getErrorText()
{
	Set tString=""
	For tIdx=1:1:..Errors.Count() {
		Set tString=tString_". "_..Errors.GetAt(tIdx).Description
	}
	Quit $e(tString,3,*)
}

Storage Default
{
<Data name="ErrorsState">
<Value name="1">
<Value>Errors</Value>
</Value>
<Value name="2">
<Value>HighestError</Value>
</Value>
</Data>
<State>ErrorsState</State>
<StreamLocation>^HS.Types.IHE.ErrorsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
