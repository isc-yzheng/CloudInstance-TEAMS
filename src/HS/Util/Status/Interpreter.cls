Include %occErrors

Class HS.Util.Status.Interpreter
{

Parameter DOMAIN = "HS";

Parameter DefaultErrorText As COSEXPRESSION = "$$$Text(""An internal error occurred."",""HS"")";

Parameter DefaultErrorTextDetailed As COSEXPRESSION = "$$$Text(""An internal error occurred: %1"",""HS"")";

Parameter ShowInternalErrorDetails As BOOLEAN = 1;

/// Interprets an SQL error as a more user-friendly error message based on foreign/unique key metadata. (See <class>HS.Util.Status.PersistentHelper</class>.)
/// @API.Method
/// @Modifier Availability InterSystems
ClassMethod GetErrorTextSQL(pSQLCode As %Integer, pMessage As %String, pSuppressInternalErrorDetails As %Boolean = 1) As %String
{
}

/// Interprets an error status into a more user-friendly error message based on foreign/unique key metadata. (See <class>HS.Util.Status.PersistentHelper</class>.)
/// @API.Method
/// @Modifier Availability InterSystems
ClassMethod GetErrorText(pStatus As %Status, pSuppressInternalErrorDetails As %Boolean = {..#ShowInternalErrorDetails}) As %String
{
}

ClassMethod GetDefaultErrorText(pStatus As %Status, pSuppressInternalErrorDetails As %Boolean = 1) As %String [ Internal, Private ]
{
}

ClassMethod GetViolationMessageFromMetadata(pClassName As %Dictionary.Classname, pConstraintType As %String, pConstraintName As %Dictionary.Identifier, pActionType As %String) As %String [ Internal, Private ]
{
}

/// Utility method to take a string formatting template <var>pTemplate</var>, an input string <var>pInput</var> that may or may not match it.
/// Returns false if <var>pInput</var> does not match <var>pTemplate</var>.
/// If <var>pInput</var> does match <var>pTemplate</var>, returns an array of input string values subscripted by the position of the substituted string.
/// For example, the value substituted in for %2 is in subscript 2.
/// The key purpose of this is to extract formatting inputs to a known formatted, localized string independent of the
/// order the inputs are listed in once localized.
ClassMethod UnFormatString(pTemplate As %String, pInput As %String, Output pArguments) As %Boolean [ Internal ]
{
}

}
