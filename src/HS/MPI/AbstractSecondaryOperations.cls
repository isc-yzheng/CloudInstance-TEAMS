/// Used for invoking a secondard MPI search after getting the results from the primary search,
/// for DSPs such as SureScripts, and for invoking secondary hubs
Class HS.MPI.AbstractSecondaryOperations Extends Ens.BusinessOperation [ Abstract, ProcedureBlock ]
{

Parameter INVOCATION = "InProc";

/// This determines which search criteria to use.
///  True means to use the search criteria that the user entered for the primary search.
///  False means to use the results of the primary seach (if present) as the search criteria.
Property UsePrimaryCriteria As %Boolean [ InitialExpression = 1 ];

/// Deprecated - this must always be false, which means
/// Do Not Search if we have not first identifed the patient in our registry
Property SearchIfNoPrimaryResult As %Boolean [ InitialExpression = 0 ];

/// Multiple Result mode.  This determines what to do if the
///  primary MPI search returns more than one result. Select one of:
///   Do Not Search,
///   Search only Top MPIID (i.e. use only the first result),
///   Search using Each MPIID (i.e. perform a search for each primary result)
Property MultipleResultMode As %String(DISPLAYLIST = ",Do Not Search,Search only Top MPIID,Search using Each MPIID", VALUELIST = ",None,Top,Each") [ InitialExpression = "None" ];

/// Settings for this Business Process
Parameter SETTINGS As %String = "UsePrimaryCriteria,SearchIfNoPrimaryResult,MultipleResultMode";

Method PatientSearch(pRequest As HS.Message.PatientSecondarySearchRequest, Output pResponse As HS.Message.PatientSearchResponse) As %Status
{

	Quit $$$ERROR($$$NotImplemented)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.PatientSearchRequest"> 
		<Method>PatientSearch</Method>
	</MapItem>

</MapItems>
}

}
