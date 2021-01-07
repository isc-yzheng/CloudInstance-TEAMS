/// 
/// Implements a composable interface for writing complex JSON
/// 
Class HS.JSON.Composable Extends (%RegisteredObject, %Collection.AbstractIterator)
{

/// Sub-components to compose
Property Components As list Of %RegisteredObject;

Method GetNext(ByRef pKey As %CacheString) As %CacheString [ CodeMode = expression ]
{
..Components.GetNext(.pKey)
}

Method Next(pKey As %CacheString = "") As %CacheString [ CodeMode = expression ]
{
..Components.Next(pKey)
}

Method GetAt(pKey As %CacheString = "") As %CacheString [ CodeMode = expression ]
{
..Components.GetAt(pKey)
}

}
