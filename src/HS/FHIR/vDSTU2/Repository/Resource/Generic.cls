Class HS.FHIR.vDSTU2.Repository.Resource.Generic Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

/// This is empty, but needs to be here so that the SearchParams from Abstract
/// will not be inherited, which would cause the params in Abstract to be
/// indexed twice
XData SearchParams
{
<root/>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
