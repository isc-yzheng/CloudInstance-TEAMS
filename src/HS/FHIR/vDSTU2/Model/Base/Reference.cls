Class HS.FHIR.vDSTU2.Model.Base.Reference Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Reference";

Parameter XMLSEQUENCE = 1;

/// A reference to a location at which the other resource is found. The reference may be a relative reference, in which case it is relative to the service base URL, or an absolute URL that resolves to the location where the resource is found. The reference may be version specific or not. If the reference is not to a FHIR RESTful server, then it should be assumed to be version specific. Internal fragment references (start with '#') refer to contained resources.
Property reference As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "reference");

/// Plain text narrative that identifies the resource in addition to the resource reference.
Property display As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "display");

/// Set method for the "reference" property.
Method SetReference(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..reference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "display" property.
Method SetDisplay(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..display = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
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
