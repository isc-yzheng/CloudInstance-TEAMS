Class HS.Sync.BaseClass [ Abstract ]
{

/// If this parameter is set to 1 then a GUID will be assigned (to the %GUID property) to each new object.
/// When the object is saved for the first time this GUID value will be recorded in a namespace
/// index which will allow GUID to be resolved to OIDs.
Parameter GUIDENABLED [ Final ] = 1;

/// if OBJJOURNAL is TRUE then inserts, updates and deletes will be logged in ^OBJ.JournalT
/// if OBJJOURNAL = 2 then the entire object will also be journaled in ^OBJ.Journal
Parameter OBJJOURNAL As INTEGER [ Constraint = "0,1,2", Flags = ENUM ] = 2;

Parameter SYNCORDER As %Integer = 99999;

/// need to get the SQL TABLENAME
ClassMethod GetSQLTableName() As %String [ ForceGenerate ]
{
	If '$classMethod($classname(),"%Extends","%Persistent") Quit ""
	Quit $$$EXTschema($$$pEXT,$classname())_"."_$$$EXTtablename($$$pEXT,$classname())
}

ClassMethod SyncTables(Output pTables) As %Status
{
	Kill pTables
	Set tRS=##class(%ResultSet).%New("%ClassDefinition:SubclassOf") 
	Do tRS.%Execute("HS.Sync.BaseClass")
	While tRS.%Next() {
		Set tClassName = tRS.%GetData(1)
		Set tOrder = $parameter(tClassName,"SYNCORDER")
		Set tSQLTableName = $classmethod(tClassName,"GetSQLTableName")
		Set tGlobalInfo= $classmethod(tClassName,"GetGlobalInfo")
		Set tClass(tClassName)=tGlobalInfo
		Set tArray(tOrder,tClassName)=$lb(tClassName,tSQLTableName,tGlobalInfo,tOrder)
	}
	Set pTables=0,(tOrder,tClassName)=""
	For {
		Set tOrder=$o(tArray(tOrder)) Quit:tOrder=""
		For {
			Set tClassName=$O(tArray(tOrder,tClassName),1,data) Quit:tClassName=""
			#; want to exclude child classes (HS.Registry.Service.SOAP because Abstract already has the data)
			Set tDef = ##class(%ClassDefinition).%OpenId(tClassName),tSkip=0
			For tIdx = 1:1:$l(tDef.Super,",") {
				Set tName = $p(tDef.Super,",",tIdx)
				#; if the super class is in list and it has the same data storage
				If tName]"",$G(tClass(tName))=tClass(tClassName) Set tSkip=1 Quit  
			}
			Continue:tSkip
			Set pTables($i(pTables))=data
		}
	}
		
	Quit $$$OK
}

ClassMethod GetGlobalInfo() As %String [ CodeMode = objectgenerator ]
{
	Quit:%classname="HS.Sync.BaseClass" $$$OK
	Do %code.WriteLine(" Set tResult=""""")
	Set tStorageNode=""
	For {
		Set tStorage=%compiledclass.Storages.GetNext(.tStorageNode) Quit:tStorageNode=""
		Quit:'$IsObject(tStorage)
		For tProperty = "DataLocation","IdLocation","IndexLocation","StreamLocation" {
			Set tValue = $property(tStorage,tProperty)
			If tValue["{" continue
			Set tValue = $p($p(tValue,"("),"^",2)
			Continue:tValue=""
			Continue:$D(tArray(tValue))
			Do %code.WriteLine(" Set tResult=tResult_$lb("""_tValue_""")")
			Set tArray(tValue)=""
		}
	}
	Do %code.WriteLine(" Quit tResult")
	Quit $$$OK
}

ClassMethod MappingData(Output pMapLines, Output pGlobals) As %Status
{
	Kill pMapLines,pGlobals

	#; Build a distinct list of globals into pGlobals(<global>)=""
	Do ..SyncTables(.tTables)
	For tIdx=1:1:tTables {
		Set tList = $li(tTables(tIdx),3)
		Set tPtr=0
    While $LISTNEXT(tList,tPtr,tValue) {
	    Set:$D(tValue) pGlobals(tValue)=""
    }
	}
	
	#; Add synchronization globals
	Set pGlobals("Cache.SyncTimeD")=""
	Set pGlobals("Cache.SyncTimeI")=""
	Set pGlobals("OBJ.GUID")=""
	Set pGlobals("OBJ.JournalT")=""
	Set pGlobals("OBJ.Journal")=""

	#; Populate the pMapLines array in <2048 byte chunks pMapLines(#)=<comma sep list>
	Set tString = ""
	Set tValue="" For { Set tValue=$O(pGlobals(tValue)) Quit:tValue=""
		If $L(tString)+$L(tValue)<2048 {
			If tString="" {
				Set tString = tValue
			} Else {
				Set tString = tString_","_tValue
			}
		}
		Else {
			Set pMapLines($i(pMapLines)) = tString
			Set tString = tValue
		}
	}
	Set pMapLines($i(pMapLines)) = tString

	Quit $$$OK
}

}
