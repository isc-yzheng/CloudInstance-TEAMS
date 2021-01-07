/// Utility class for wrapping a list of JSON-enabled classes into a collection.
Class HS.JSON.Container Extends (%RegisteredObject, HS.JSON.Adaptor) [ System = 3 ]
{

/// List of JSON-ready objects.
Property list As list Of %RegisteredObject;

/// Add a JSON-enabled object to the list.
Method %AddItem(pItem As %RegisteredObject) As %Status
{
	Quit ..list.Insert(pItem)
}

}
