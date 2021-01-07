Include HS.FHIRServer

/// This class provides implementations of $everything and $validate (To be updated).  
/// This class may be extended to add implementations of other operations as desired.  To add support for an implementation,
/// create a subclass of this class and add one or more "gateway" methods for each supported operation.  A "gateway" method
/// is given a name that describes both the name of the operation and the scope that is valid.  The method name must be
/// in the form:
/// <br>FHIR<i>ScopeDescriptor</i>Op<i>OperationName</i>
/// <br> where ScopeDescriptor is one of: System, Type, or Instance reflecting the form of the request:
/// <br> System:  /$operation
/// <br> Type  /<i>ResourceType</i>/$operation
/// <br> Instance:  /<i>ResourceType</i>/<i>ResourceId</i>/$operation
/// <br> for example the $everything operation is implemented through a method named FHIRInstanceOpEverything
/// <br> The signature of a "gateway method is:"
/// <br> ClassMethod FHIRInstanceOpEverything(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
/// 
Class HS.FHIRServer.Storage.BuiltInOperations Extends (HS.FHIRServer.API.OperationHandler, HS.FHIRServer.Storage.BuiltIn.Everything, HS.FHIRServer.Storage.BuiltIn.Validate, HS.FHIRServer.Storage.BuiltIn.Lastn)
{

/// @API Enumerate the name and url of each Operation supported by this class
ClassMethod AddSupportedOperations(pMap As %DynamicObject)
{
	Do ##class(HS.FHIRServer.Storage.BuiltIn.Everything).AddSupportedOperations(pMap)
	Do ##class(HS.FHIRServer.Storage.BuiltIn.Validate).AddSupportedOperations(pMap)
	Do ##class(HS.FHIRServer.Storage.BuiltIn.Lastn).AddSupportedOperations(pMap)
}

}
