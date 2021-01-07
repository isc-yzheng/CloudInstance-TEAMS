/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.IssueType when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.IssueType Extends HS.FHIR.Model.Base.Element [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "IssueType";

///  
Parameter XMLSEQUENCE = 1;

///  
Property value As %String(VALUELIST = ",invalid,structure,required,value,invariant,security,login,unknown,expired,forbidden,suppressed,processing,not-supported,duplicate,not-found,too-long,code-invalid,extension,too-costly,business-rule,conflict,incomplete,transient,lock-error,no-store,exception,timeout,throttled,informational", XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

///  
Method %OnNew(pValue As %String, pExtension As %RegisteredObject, pId As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pExtension)=0)&&($Data(pId)=0) Quit
		If $Get(pValue)'="" Set ..value = pValue
		If $Get(pId)'="" Set ..id = pId
		#; pExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pExtension)) {
			If (pExtension.%Extends("%Collection.ListOfObj")=0)&&(pExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..extension.Insert(pExtension) Quit:$$$ISERR(tSC)
			} Else {
				Set ..extension = pExtension
			}
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
