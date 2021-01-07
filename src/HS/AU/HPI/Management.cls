Class HS.AU.HPI.Management Extends HS.AU.HI.Management
{

Parameter XMLTYPE = "HPIManagement";

Property History As list Of HS.AU.HPI.Management.History(CLASSNAME = 1, STORAGEDEFAULT = "array");

ClassMethod ObjectForNumber(pNumber) As HS.AU.HPI.Management
{
	&sql(select ID into :ID from Management where number=:pNumber)
	quit $S(SQLCODE:"",1:..%OpenId(ID))
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
