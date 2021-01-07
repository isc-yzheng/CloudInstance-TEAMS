Class HS.Doc.Utility Extends %RegisteredObject
{

/// Adds source directories for a given pCDAType and root directory.
/// At the moment the directories are the same for import and export.
ClassMethod PopulateSourceDirs(pCDAType, pInputRoot, ByRef pSourceDirs) As %Status
{
	D ##class(HS.Doc.Utility).GetCDATypes(.tCDATypes)
	Set tSC = $$$OK
	if (pCDAType = "") {		
		Set tSC = $$$ERROR($$$GeneralError,"CDA type not specified" )
	} elseif (pInputRoot = "") {
		Set tSC = $$$ERROR($$$GeneralError,"Input directory not specified" )		
	} elseif $d(tCDATypes(pCDAType, "Directories")) {
		Set tDirs = tCDATypes(pCDAType, "Directories")
		For i=1:1:$ll(tDirs) {
			Do pSourceDirs.Insert(pInputRoot _ $lg(tDirs,i))
		}
	} else {
		Set tSC = $$$ERROR($$$GeneralError,"Invalid CDA type specified: '" _ pCDAType _ "'" )
	}
	Quit tSC
}

ClassMethod GetCDATypes(ByRef pCDATypes)
{
	Set pCDATypes("C32", "Directories") =  $lb("/Common", "/Entry-Modules", "/Section-Modules")
	Set pCDATypes("CCDA1", "Directories") =  $lb("/Common/CCDA", "/Entry-Modules/CCDA", "/Section-Modules/CCDA")
	Set pCDATypes("CCDA2", "Directories") =  $lb("/Common/CCDAv21", "/Entry-Modules/CCDAv21", "/Section-Modules/CCDAv21")
	Set pCDATypes("XDLAB", "Directories") =  $lb("/Common", "/Entry-Modules/XDLAB", "/Section-Modules/XDLAB")
	quit $$$OK
}

ClassMethod PrintCDATypes()
{
	Do ..GetCDATypes(.tSC)
	Set tPos = $o(tSC(""))
	While (tPos '= "") {
		Set tDirs = tSC(tPos, "Directories")
		W tPos _ " Directories " _ tDirs,!
		For i=1:1:$ll(tDirs) {
			W " -" _ $lg(tDirs,i),!
		}
		Set tPos = $o(tSC(tPos))
	}
}

}
