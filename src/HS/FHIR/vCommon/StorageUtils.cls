Class HS.FHIR.vCommon.StorageUtils [ Abstract ]
{

ClassMethod GetStorageDef(pClassname As %String, pStorageName As %String = "Default") As %Dictionary.CompiledStorage
{
	Set tStgDef = ##class(%Dictionary.CompiledStorage).IDKEYOpen(pClassname, pStorageName,0,.tSC)
	$$$ThrowOnError(tSC)
	Quit tStgDef
}

ClassMethod GetIndexGlobal(pClassname As %String, pStorageName As %String = "Default") As %String
{
	Quit ..GetStorageDef(pClassname, pStorageName).IndexLocation
}

ClassMethod GetDataGlobal(pClassname As %String, pStorageName As %String = "Default") As %String
{
	Quit ..GetStorageDef(pClassname, pStorageName).DataLocation
}

ClassMethod GetStreamGlobal(pClassname As %String, pStorageName As %String = "Default") As %String
{
	Quit ..GetStorageDef(pClassname, pStorageName).StreamLocation
}

ClassMethod GetCounterGlobal(pClassname As %String, pStorageName As %String = "Default") As %String
{
	Quit $Extract(..GetStreamGlobal(pClassname, pStorageName), 1, *-1)_"C"
}

}
