Class HS.Registry.Person.UserPassword Extends %Library.Binary [ ProcedureBlock ]
{

ClassMethod LogicalToDisplay(%val As %String) As %String [ Internal ]
{
	q $case(%val,"":"",:"*****")
}

ClassMethod LogicalToOdbc(%val As %String) As %String [ Internal ]
{
	q $case(%val,"":"",:"*****")
}

}
