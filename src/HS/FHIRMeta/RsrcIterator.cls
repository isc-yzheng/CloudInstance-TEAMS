/// The RsrcIterator provides an API for accessing resources of a specific type
/// that have been loaded by an HS.FHIRMeta.Load.NpmLoader instance.  You acquire an instance
/// of a RsrcIterator using the getRsrcIterator method of HS.FHIRMeta.API
Class HS.FHIRMeta.RsrcIterator Extends %RegisteredObject
{

Property packageIdList As %List [ Private ];

Property resourceType As %String [ Private ];

Property urlArray [ MultiDimensional, Private ];

Property index [ Private ];

Method %OnNew(packageIdList As %List, resourceType As %String) As %Status
{
	set ..packageIdList = packageIdList
	set ..resourceType = resourceType
	set ..index = 0
	do ..getRsrcUrlArray(resourceType, .array)
	Merge ..urlArray = array
	return $$$OK
}

/// Get the next resource in the iteration.  
/// <br> @Return true if a resource was returned, false if the end of the iteration
/// <br> @Output The resource as a %DynamicObject is set into the Output parameter
Method Next(Output json As %DynamicObject) As %Boolean
{
	if ..index = ..urlArray {
		// Done
		set json = ""
		return 0
	} 
	set ..index = ..index+1
	Set url = ..urlArray(..index)
	set json = ##class(HS.FHIRMeta.Storage.Rsrc).GetRsrcByUrl(..packageIdList, url)
	return 1
}

Method getRsrcUrlArray(resourceType As %String, Output urlArray) [ Private ]
{
	// Returns a multidimensional array enumerating all URL values in the iteration.
	Set urlArray = 0	
	Set SQL = "SELECT url FROM HS_FHIRMeta_Storage.Rsrc where (packageId %INLIST ?) AND resourceType = ?"
	if resourceType = "StructureDefinition" {
		Set SQL = SQL _ " AND kind <> 'logical'"
	}
	Set statement = ##class(%SQL.Statement).%New()
	Set tSC = statement.%Prepare(SQL)
	$$$ThrowOnError(tSC)
	Set resultSet = statement.%Execute(..packageIdList, resourceType)
	While resultSet.%Next() {
		Set urlArray($I(urlArray)) =  resultSet.%GetData(1)
	}
}

}
