Include HS.FHIRServer

Class HS.FHIRServer.Storage.Json.SearchColumn Extends %Persistent [ StorageStrategy = "" ]
{

Property ResourceType As %String;

Property ServiceKey As %String;

Property ParamName As %String;

Property RepoKey As %String;

Property TableName As %String;

Property ColumnName As %String;

Property DataType As %String;

Property FHIRPath As %String(MAXLEN = 500);

Property isMultiValue As %Boolean;

Property Type As %String;

Property Target As %String(MAXLEN = "");

Property Added As %Boolean;

Property IndexType As %Integer;

Parameter NoIndex As %Integer = 1;

Parameter PlainIndex As %Integer = 0;

Parameter BitmapIndex As %Integer = 2;

// true means not yet handled by TableBuilder/Indexer

ClassMethod testAdd(id As %String = "7", metaKey = "USCore40")
{
	d ##Class(HS.FHIRServer.Installer).AddInstanceToRepo(id, metaKey)
}

ClassMethod test(id As %String = "4||4", generateOnly As %Boolean = 1)
{
	//do ..%DeleteExtent()
	Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).getInstance(id)
	do ..GenerateFromStrategy(strategy)
	if 'generateOnly {
		set obj = ##class(HS.FHIRServer.Storage.SearchTableBuilder).%New(strategy)
		d obj.GenResourceTables(1)
		d obj.GenSearchTablesFromSchema(,1,0)
	}
}

ClassMethod testMerge(id As %String = "3||3", generateOnly As %Boolean = 1)
{
	//do ..%DeleteExtent()
	Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).getInstance(id)
	set obj = ##class(HS.FHIRServer.Storage.SearchTableBuilder).%New(strategy)
		
	d obj.GenSearchTablesFromSchema(,1,0)
}

ClassMethod getParamIdListForType(resourceType As %String, serviceKey As %String) As %List
{
	set ret = ""
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "SELECT %ID FROM HS_FHIRServer_Storage_Json.SearchColumn where ServiceKey=? and ResourceType = ?"
	set sc = st.%Prepare(.sql)
	set rs = st.%Execute(serviceKey, resourceType)
	while(rs.%Next()) {
		set $List(ret, *+1) = rs.%GetData(1)
	}
	quit ret
}

/// Returns a %List of SearchColumn id's for a specified table.
ClassMethod getColumnIdsForRepoTable(repoId As %String, tableName As %String) As %List
{
	set ret = ""
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "SELECT %ID FROM HS_FHIRServer_Storage_Json.SearchColumn where ((TableName = ?) or (ResourceType = 'Resource')) and repoKey=? "
	set sc = st.%Prepare(.sql)
	set rs = st.%Execute(tableName, repoId)
	while(rs.%Next()) {
		set $List(ret, *+1) = rs.%GetData(1)
	}
	quit ret
}

/// Returns a %List of table names used by the specified Repo.
ClassMethod getTableListForRepoId(repoId As %String) As %List
{
	set ret = ""
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "SELECT distinct %exact( TableName) FROM HS_FHIRServer_Storage_Json.SearchColumn where repoKey=?"
	set sc = st.%Prepare(.sql)
	$$$ThrowOnError(sc)
	set rs = st.%Execute(repoId)
	set list = ""
	while(rs.%Next()) {
		set $List(ret, *+1) = rs.%GetData(1)
	}
	quit ret
}

ClassMethod getChangedTableListForRepoId(repoId As %String) As %List
{
	set ret = ""
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "SELECT distinct %exact( TableName) FROM HS_FHIRServer_Storage_Json.SearchColumn where repoKey=? and Added <> 0 "
	set sc = st.%Prepare(.sql)
	$$$ThrowOnError(sc)
	set rs = st.%Execute(repoId)
	set list = ""
	while(rs.%Next()) {
		set $List(ret, *+1) = rs.%GetData(1)
	}
	quit ret
}

ClassMethod getAddedParametersForServiceId(serviceId As %String) As %List
{
	set ret = ""
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "SELECT ResourceType, ParamName FROM HS_FHIRServer_Storage_Json.SearchColumn where ServiceKey=? and Added <> 0 "
	set sc = st.%Prepare(.sql)
	$$$ThrowOnError(sc)
	set rs = st.%Execute(serviceId)
	set list = ""
	while(rs.%Next()) {
		set $List(ret, *+1) = rs.%GetData(1) _ "." _ rs.%GetData(2)
	}
	quit ret
}

ClassMethod getById(id As %String) As HS.FHIRServer.Storage.Json.SearchColumn [ CodeMode = expression ]
{
..%OpenId(id)
}

ClassMethod deleteColumnsForService(serviceKey As %String)
{
	set sql = "DELETE FROM HS_FHIRServer_Storage_Json.SearchColumn where ServiceKey=?"
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sc = st.%Prepare(.sql)
	$$$ThrowOnError(sc)
	Do st.%Execute(serviceKey)
}

ClassMethod RegenerateFromStrategy(strategy As HS.FHIRServer.API.InteractionsStrategy)
{
	Set transaction = ##class(HS.Util.Scoped.Transaction).Start()

	// First delete the old data
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "DELETE FROM HS_FHIRServer_Storage_Json.SearchColumn where ServiceKey=?"
	set sc = st.%Prepare(.sql)
	$$$ThrowOnError(sc)
	set rs = st.%Execute(strategy.RepoInstance.serviceId)

	// Then Generate the new
	Do ..GenerateFromStrategy(strategy)	
	
	do transaction.Commit()
}

ClassMethod merge(repoKey As %String, serviceKey As %String, newServiceKey As %String = "")
{
	Set transaction = ##class(HS.Util.Scoped.Transaction).Start()

	//rows belonging to serviceKey will be placed under repo (repoKey)
	// no concurrency control, we should not allow two instances of setup to run simultaneously
	//how to handle table/resource renaming?
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "select %ID FROM HS_FHIRServer_Storage_Json.SearchColumn where ServiceKey=?"
	set sc = st.%Prepare(.sql)
	set rs = st.%Execute(strategy.RepoInstance.serviceId)
	while (rs.%Next()) {
		set id = rs.%GetData(1)
		set obj = ..%OpenId(id)
		set obj.RepoKey = repoKey
		set obj.Added = 1
		if newServiceKey '= "" {
			set obj.ServiceKey = newServiceKey
		}
		set sc = obj.%Save()
		$$$ThrowOnError(sc)
	}
	do transaction.Commit()
}

ClassMethod GenerateFromStrategy(strategy As HS.FHIRServer.API.InteractionsStrategy)
{
	do ..GenerateFromMeta(strategy.schema, strategy.RepoInstance.repo.%Id(), strategy.RepoInstance.serviceId)
}

ClassMethod resetAdded(repoKey As %String)
{
	&sql(update HS_FHIRServer_Storage_Json.SearchColumn set Added = 0 where RepoKey = :repoKey)
}

ClassMethod GenerateFromMeta(meta As HS.FHIRMeta.API, repoKey As %String, serviceKey As %String)
{
	#dim  repoMgr as HS.FHIRServer.API.RepoManager = ##class(HS.FHIRServer.API.RepoManager).getInstance(repoKey)
	#dim st as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql = "select count(*) FROM HS_FHIRServer_Storage_Json.SearchColumn where ServiceKey=? and ResourceType=? and ParamName=?"
	set sc = st.%Prepare(.sql)
	$$$ThrowOnError(sc)
	#dim st1 as %SQL.Statement = ##class(%SQL.Statement).%New()
	set sql1 = "select count(*) FROM HS_FHIRServer_Storage_Json.SearchColumn where repoKey=? and ResourceType=? and ParamName=?"
	set sc = st1.%Prepare(.sql)
	$$$ThrowOnError(sc)

	Set transaction = ##class(HS.Util.Scoped.Transaction).Start()
	w "Meta: ",meta,", repo: ", repoKey, ", svc: ",serviceKey,!
	Set rn=meta.NextSearchParamResourceType("")
	while(rn '= "") {
		
		
		#dim  param as HS.FHIRMeta.SearchParam = meta.NextSearchParamForResourceType(rn, "")
		while (param '= "") {
			set rs = st.%Execute(serviceKey, param.resourceType, param.code)
			do rs.%Next()
			if rs.%GetData(1) { 
				Set param=meta.NextSearchParamForResourceType(rn, param)
				continue 
			}
			set rs1 = st1.%Execute(repoKey, param.resourceType, param.code)
			do rs1.%Next()
			set new= '(rs1.%GetData(1))  //do not count multiple column definition as new
				

			
			
			if param.type="composite" {
				Set param=meta.NextSearchParamForResourceType(rn, param)
				continue //??
				//set o = ll.GetAt(ord) w o.resourceType,"?",o.name," composite of (", $lts(o.target), ")",!
			} else {
				#dim obj as HS.FHIRServer.Storage.Json.SearchColumn
				Set obj = ..CreateColumn(repoMgr, serviceKey, param, new)
				// We do not create "Range" search entries at this time
				$$$ThrowOnError(obj.%Save())
				//w param.resourceType," ",param.code, " ",sc,!
			}
			
			Set param=meta.NextSearchParamForResourceType(rn, param)

		}
		Set rn = meta.NextSearchParamResourceType(rn)
		
	}
	Do transaction.Commit()
}

ClassMethod CreateColumn(repoMgr As HS.FHIRServer.API.RepoManager, serviceKey As %String, param As HS.FHIRMeta.SearchParam, isNew As %Boolean)
{
	set obj = ..%New()
	set obj.RepoKey = repoMgr.repo.%Id()
	set obj.ServiceKey = serviceKey
	set obj.ResourceType = param.resourceType
	set obj.ParamName = param.code
	set obj.Target = param.target
	set obj.TableName = param.resourceType //??
	set obj.ColumnName = ##class(HS.FHIRMeta.MetaUtils).NormalizeParamName(param.code)
	set obj.FHIRPath = param.fhirPath
	set obj.Type = param.type
	set obj.IndexType = repoMgr.GetIndexType(param.resourceType, param.code)
	set obj.Added = isNew
	set obj.DataType = ..GetStorageType(param)
	set obj.isMultiValue = (param.isMultiValue || (obj.DataType = "CodeableConcept") || (obj.DataType = "Coding"))
	return obj
}

/// Calculates the datatype that we will use to store the values
/// for this search parameter.
ClassMethod GetStorageType(param As HS.FHIRMeta.SearchParam) As %String
{
	Set typeList = param.datatypes
	if $LG(typeList) = "variant" {
		Set typeList = param.variantTypes
	}
	if $ll(typeList) = 1 {
		return $lg(typeList)
	}
	if param.type = "quantity" {
		if $listfind(typeList, "Range") return "Range"
		return "Quantity"
	} elseif param.type = "date" {
		if $listfind(typeList, "Timing") || $listfind(typeList, "Period") {
			return "Period"
		}
	}
	elseif $listfind(typeList, "CodeableConcept") {
		return "CodeableConcept"
	}
	return $lg(typeList)
}

Index TableIdx On (RepoKey, TableName);

Index TypeIdx On (ServiceKey, ResourceType);

Index NameIdx On (ServiceKey, ParamName);

Storage Default
{
<Data name="SearchColumnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResourceType</Value>
</Value>
<Value name="3">
<Value>ServiceKey</Value>
</Value>
<Value name="4">
<Value>ParamName</Value>
</Value>
<Value name="5">
<Value>RepoKey</Value>
</Value>
<Value name="6">
<Value>TableName</Value>
</Value>
<Value name="7">
<Value>ColumnName</Value>
</Value>
<Value name="8">
<Value>DataType</Value>
</Value>
<Value name="9">
<Value>FHIRPath</Value>
</Value>
<Value name="10">
<Value>isMultiValue</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>Target</Value>
</Value>
<Value name="13">
<Value>Added</Value>
</Value>
<Value name="14">
<Value>IndexType</Value>
</Value>
</Data>
<DataLocation>^HS.FHIRServer7AAF.SearchColumnD</DataLocation>
<DefaultData>SearchColumnDefaultData</DefaultData>
<IdLocation>^HS.FHIRServer7AAF.SearchColumnD</IdLocation>
<IndexLocation>^HS.FHIRServer7AAF.SearchColumnI</IndexLocation>
<StreamLocation>^HS.FHIRServer7AAF.SearchColumnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
