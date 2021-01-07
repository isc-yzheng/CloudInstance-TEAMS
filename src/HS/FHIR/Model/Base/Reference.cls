/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.Reference when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.Reference Extends HS.FHIR.Model.Base.Element [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Reference";

///  
Parameter XMLSEQUENCE = 1;

///  
Property reference As HS.FHIR.Model.Datatype.String(XMLNAME = "reference");

///  
Property display As HS.FHIR.Model.Datatype.String(XMLNAME = "display");

///  
Method SetReference(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..reference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetDisplay(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..display = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method %OnNew(pReference As %String, pDisplay As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		// %references is set and used by HS.FHIR.Operation.Process:Everything() (the $everything operation)
		If ($G(%references)=1) Set %references(+##this) = ##this
		If ($Data(pReference)=0)&&($Data(pDisplay)=0)&&($Data(pExtension)=0) Quit
		If $Get(pReference)'="" Set tSC = ..SetReference(pReference) Quit:$$$ISERR(tSC)
		If $Get(pDisplay)'="" Set tSC = ..SetDisplay(pDisplay) Quit:$$$ISERR(tSC)
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
