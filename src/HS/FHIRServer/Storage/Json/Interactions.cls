Include HS.FHIRServer

Class HS.FHIRServer.Storage.Json.Interactions Extends HS.FHIRServer.Storage.Search
{

Parameter OperationHandlerClass As %String = "HS.FHIRServer.Storage.BuiltInOperations";

Parameter OAuth2TokenHandlerClass As %String = "HS.FHIRServer.Util.OAuth2Token";

Property metadata As %DynamicObject;

Property metadataTime As %String;

Property strategy As HS.FHIRServer.Storage.Json.InteractionsStrategy;

Property %oauth2TokenHandler As HS.FHIRServer.API.OAuth2Token [ Private ];

Property spcache [ MultiDimensional, Private ];

Method %OnNew(pStrategy As HS.FHIRServer.Storage.Json.InteractionsStrategy) As %Status
{
	Set ..strategy = pStrategy
	Set ..%oauth2TokenHandler = $ClassMethod(..#OAuth2TokenHandlerClass, "%New", pStrategy.schema)
	return $$$OK
}

Method oauth2TokenHandlerGet() As HS.FHIRServer.API.OAuth2Token [ CodeMode = expression ]
{
..%oauth2TokenHandler
}

// Method IndexResource(pStorageObject As HS.FHIRServer.Storage.Json.Resource) As HS.FHIRServer.Storage.Indexer [ Internal ]

// {

// 	#dim indexer as HS.FHIRServer.Storage.Indexer = ##class(HS.FHIRServer.Storage.Indexer).%New(pStorageObject, ..strategy)

// 	Do indexer.IndexValues()

// }

/// // Factory method for instantiating an Indexer.  This method may be overridden by the concrete Resource class
/// // if it requires a version-specific implementation
/// Factory method for instantiating an Indexer.  This method may be overridden by the concrete Resource class
/// if it requires a version-specific implementation
Method IndexResource(pStorageObject As HS.FHIRServer.Storage.Json.Resource) As HS.FHIRServer.Storage.Indexer [ Internal ]
{
	Do ..IndexFromJson(pStorageObject.ResourceObject)
}

/// Factory method for instantiating an Indexer.  This method may be overridden by the concrete Resource class
/// if it requires a version-specific implementation
Method IndexFromJson(json As %DynamicObject) [ Internal ]
{
	set columns = ..getSearchColumnsForType(json.resourceType)
	#dim indexer as HS.FHIRServer.Storage.Indexer = ##class(HS.FHIRServer.Storage.Indexer).%New(json, $this)
	Do indexer.IndexValues()
}

Method SetMetadata(metadata As %DynamicObject)
{
	// First Validate the metadata
	// Validate the bundle and throw on error
	Set schema = ..strategy.schema
	set validator = $classmethod(..#ResourceValidatorClass, "%New", schema)
	Do validator.ValidateResource(metadata)
	
	
	
	// Update the resource's 'meta' object
	Set GLOBAL = ..strategy.GetGlobalRoot()
	Set newVersion = 1
	if $D(	@GLOBAL@("capability"), oldMetadata) {
		set newVersion = 1 + ##class(%DynamicObject).%FromJSON(oldMetadata).meta.versionId	
	}

	// Update the 'meta' property of the CapabilityStatement
	set metaObj = $$$NewJSONObject
	Set metaObj.lastUpdated = $ZDT($H,3,7)
	Do metaObj.%Set("versionId", newVersion, "string")
	Set metadata.meta = metaObj
	
	// Now store it under our assigned Global node
	Set GLOBAL = ..strategy.GetGlobalRoot()
	Set @GLOBAL@("capability") = metadata.%ToJSON()
	Set @GLOBAL@("capability", "time") = metaObj.lastUpdated
	
	// Invalidate Instances cached by %ZHSLIB.Context.Manager.  This causes the change
	// to take immediate effect
	Do ##class(HS.FHIRServer.Service).InvalidateInstances(..strategy.InstanceKey)
}

Method LoadMetadata() As %DynamicObject
{
	Set GLOBAL = ..strategy.GetGlobalRoot()
	if $D(@GLOBAL@("capability"), metadata) < 10 {
		$$$ThrowFHIR($$$HSFHIRErrMetadataNotConfigured,$$$OutcomeIs(503, "fatal", "transient"))
	}
	if @GLOBAL@("capability", "time") '= ..metadataTime {
		Set ..metadata = ##class(%DynamicObject).%FromJSON(metadata)
		Set ..metadataTime = @GLOBAL@("capability", "time")
	}
	return ..metadata
}

Method FindResourceMeta(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %List
{
	Set metaList = ""
	Set rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId)
	// If pVersionId is null, use the version ID of the current version
	Set tSQL = "Select VersionId, Deleted, LastModified, Verb from " _ ..strategy.GetResourceTable(pResourceType) _ " where Key=?"
	Set tSQLParams = 0
	Set tSQLParams($I(tSQLParams)) = rsrcKey
	Set result = ..runQuery(tSQL, .tSQLParams)
	Set isCurrentVersion = 1
	Set found = 0
	if result.%Next() {
		// We have at least one version of the resource, assume we've found the requested version (or current if no Version specified)
		Set found = 1
		if (pVersionId '= "") && (result.%Get("VersionId") '= pVersionId) {
			Set tSQL = "Select VersionId, Deleted, LastModified, Verb from " _ ..strategy.GetResourceVersionTable(pResourceType)
			Set tSQL = tSQL _ " where ResourceType=? AND ResourceId=? AND VersionId=?"
			Set tSQLParams = 0
			Set tSQLParams($I(tSQLParams)) = pResourceType
			Set tSQLParams($I(tSQLParams)) = pResourceId
			Set tSQLParams($I(tSQLParams)) = pVersionId
			
			Set result = ..runQuery(tSQL, .tSQLParams)
			Set isCurrentVersion = 0
			Set found = result.%Next()
		}
		
	}
	if found {
		Set metaList = $LB(rsrcKey, result.%Get("VersionId"), result.%Get("Deleted"), isCurrentVersion, result.%Get("LastModified"), result.%Get("Verb"))
	}
	return metaList
}

Method FindStorageObject(pResourceType As %String, pResourceId As %String, pVersionId As %String = "", Output tSC As %Status = "") As HS.FHIRServer.Storage.Json.Resource
{
#def1arg callStorageMethod(%arglist) $classmethod(storageClass,%arglist)
	Set resourceClass = ..strategy.GetResourceClass(pResourceType)
	Set resourceVerClass = ..strategy.GetResourceVersionClass(pResourceType)
	Set rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId)
	Set obj = ""
	if $classmethod(resourceClass, "KeyIdxExists", rsrcKey) {
		// We have at least one version.  Get it first ..
		Set obj = $classmethod(resourceClass, "KeyIdxOpen", $$$BuildRsrcKey(pResourceType, pResourceId), , .tSC )
		// There is a current object, is this the one that was asked for?
		if (pVersionId '= "") && (obj.VersionId '= pVersionId) {
			// If not, go get the requested version
			Set obj = $classmethod(resourceVerClass, "TypeIdVerIdxOpen", pResourceType, pResourceId, pVersionId)
		}
	}
	return obj
}

Method GetStorageObject(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As HS.FHIRServer.Storage.Json.Resource [ Internal ]
{
	#dim storageObject As HS.FHIRServer.Storage.Json.Resource = ..FindStorageObject(pResourceType, pResourceId, pVersionId, .tSC)
	if (storageObject = "") {
		if (pVersionId = "") {
			$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
		} else {
			$$$ThrowFHIR($$$HSFHIRErrResourceVersionNotFound, pResourceType , pResourceId , pVersionId, $$$HttpOnlyResponse(404))
		}
	}
	return storageObject
}

Method FindResourceObject(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
	#dim storageObject As HS.FHIRServer.Storage.Json.Resource = ..FindStorageObject(pResourceType, pResourceId, pVersionId)
	return $Select(storageObject="":storageObject, 1:storageObject.ResourceObject)
}

Method GetVersionList(pResourceType As %String, pResourceId As %String, Output pCurrentVersionId) As %List
{
	Set list = ""
	Set pCurrentVersionId = ""
	#dim currentObj as HS.FHIRServer.Storage.Json.Resource = ..FindStorageObject(pResourceType, pResourceId) 
	if currentObj {
		Set pCurrentVersionId = currentObj.VersionId
		Set list = $LB(pCurrentVersionId)
	}
	// Now get entries in the RsrcVersion table
	Set metaList = ""
	Set rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId)
	// If pVersionId is null, use the version ID of the current version
	Set tSQL = "Select VersionId from " _ ..strategy.GetResourceVersionTable(pResourceType) _ " where ResourceType=? and ResourceId=? order by VersionId DESC"
	Set tSQLParams = 0
	Set tSQLParams($I(tSQLParams)) = pResourceType
	Set tSQLParams($I(tSQLParams)) = pResourceId
	Set result = ..runQuery(tSQL, .tSQLParams)

	Set isCurrentVersion = 1
	Set found = 0
	while result.%Next() {
		Set $List(list,*+1) = result.%GetData(1)
	}
	return list
}

Method RawRead(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
	#dim storageObject As HS.FHIRServer.Storage.Json.Resource = ..GetStorageObject(pResourceType, pResourceId, pVersionId)
	if (storageObject.Deleted) {
		$$$ThrowFHIR($$$HSFHIRErrResourceWasDeleted, pResourceType , pResourceId , pVersionId, $$$HttpOnlyResponse(410))
	}
	return storageObject.ResourceObject
}

Method Read(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
	
	
	return ..RawRead(pResourceType , pResourceId , pVersionId )
}

Method Add(pResourceObj As %DynamicObject, pResourceIdToAssign As %String = "", pHttpMethod = "POST") As %String
{
	// Set the id into the resource.  It may be empty in which case, AddVersion will assign one.
	set pResourceObj.id = pResourceIdToAssign
	TSTART
	try {
		Set pStorageObject = ..AddVersion("", pHttpMethod, pResourceObj)
		Do ..IndexResource(pStorageObject)
		kill pStorageObject
		TCOMMIT
	} catch ex {
		TROLLBACK 1
		throw ex
	}
	return pResourceObj.id
}

/// Returns VersionId for the "deleted" version
Method Delete(pResourceType As %String, pResourceId As %String) As %String
{
#def1arg callStorageMethod(%arglist) $classmethod(storageClass,%arglist)
	#dim storageToDelete as HS.FHIRServer.Storage.Json.Resource = ..FindStorageObject(pResourceType, pResourceId)
	if (storageToDelete = "") {
		Return ""
	}
	
	// If the resource is already marked as deleted, do nothing (silently).
	If (storageToDelete.Deleted) {
		Return ""
	}
	
	// Deprecate the last version of the resource and save the new, "deleted" version.
	// Do this in a transaction so an error in either step does not leave the database in some
	// unpredictable state.
	TSTART
	try {
		Set pStorageObject = ..AddVersion(storageToDelete, "DELETE", "")
		kill pStorageObject
		TCOMMIT
	} catch tEx {
		TROLLBACK 1
		throw tEx
	}
	return storageToDelete.VersionId
}

/// @API
/// This method will remove the resource and all versions from the database
/// @Input pResourceType  The 'resourceType' of the resource to be deleted.
/// @Input pResourceId The ID of the resource to be deleted.
/// @Input pVersions Specification of which versions to delete as follows:
/// <br> "" - The current version only
/// <br> "*" - All Versions
/// <br> $LB(vid, ...) - A list of version Id's to delete
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method HardDelete(pResourceType As %String, pResourceId As %String, pVersions As %String)
{
	Set currentOnly = pVersions = ""
	Set deleteAll = pVersions = "*"
	Set deleteList = $ListValid(pVersions)
	if '(currentOnly || deleteAll || deleteList ) {
		$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "pVersions must be """""", "*", or a valid %List")	
	}
	TSTART
	try {
		Set rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId)
		// If pVersionId is null, use the version ID of the current version
		Set tSQLParams = 0
		Set tSQL = "Delete from " _ ..strategy.GetResourceTable(pResourceType) _ " where Key=?"
		Set tSQLParams($I(tSQLParams)) = rsrcKey
		if deleteList {
			// Delete the current unconditionally UNLESS a list of versions is specified.
			// In this case, we add the matching criterion
			Set tSQL = tSQL _ " AND VersionId %INLIST ?"	
			Set tSQLParams($I(tSQLParams)) = pVersions
		}
		Set result = ..runQuery(tSQL, .tSQLParams)
		
		
		if 'currentOnly {
			// Don't touch version table if just deleting the current version
			Set tSQL = "Delete from " _ ..strategy.GetResourceVersionTable(pResourceType)
			Set tSQLParams = 0
			Set tSQL = tSQL _ " where ResourceType=? AND ResourceId=?"
			Set tSQLParams($I(tSQLParams)) = pResourceType
			Set tSQLParams($I(tSQLParams)) = pResourceId
			if deleteList {
				// Specify the specific versions to delete
				Set tSQL = tSQL _ " AND VersionId %INLIST ?"	
				Set tSQLParams($I(tSQLParams)) = pVersions
			}
			Set result = ..runQuery(tSQL, .tSQLParams)
		}
		TCOMMIT
	} catch ex {
		TROLLBACK 1
		throw ex	
	}
}

Method Update(pResourceObj As %DynamicObject) As %String
{
#def1arg callStorageMethod(%arglist) $classmethod(storageClass,%arglist)

	Set storageClass = ..strategy.GetResourceClass(pResourceObj.resourceType)
	#dim currentStorage as HS.FHIRServer.Storage.Json.Resource = ..GetStorageObject(pResourceObj.resourceType, pResourceObj.id)

	#dim updatedStorage As HS.FHIRServer.Storage.Json.Resource = $$$callStorageMethod("%New")
	set updatedStorage.Verb = "PUT"


	// TODO: Is this ever used ... and what is it for?
	// $$$ThrowOnError( tRepoResource.OnBeforeMatch() )
	
	// Check if the resource already exists, and if so, deprecate the current version.
	// The deprecation of the existing resource and the save of the new one need to
	//  happen inside a transaction so that an error while saving the new one does not
	//  leave the original resource as deprecated.
	// The initial transaction level might not be 0, if this is part of a TRANSACTION interaction
	TSTART
	try {
		Set pStorageObject = ..AddVersion(currentStorage, "PUT", pResourceObj)
		Do ..IndexResource(pStorageObject)
		kill pStorageObject
		TCOMMIT
	} catch tEx {
		TROLLBACK 1
		throw tEx
	}
	return pResourceObj.id
}

/// @API
/// This method will apply the specified JSON Patch operations to the specified resource object.
/// It does NOT apply the updated FHIR content to the repo.<br>
/// @Input pPatchOperations %DynamicArray of JSON Patch operations.<br>
/// @Input pResourceObj %DynamicObject representation of the resource to be patched.<br>
/// @Return Boolean value indicating whether the resource object content was updated by the patch.<br>
/// @Throws The implementation must report errors via $$$ThrowStatus.
Method JSONPatch(pPatchOperations As %DynamicArray, pResourceObj As %DynamicObject) As %Boolean
{
	Set updated = 0
	
	If ('$IsObject(pPatchOperations)) || ('pPatchOperations.%IsA("%Library.DynamicArray")) {
		$$$ThrowFHIR($$$HSFHIRErrInvalidJSONPatchNotArray, $$$OutcomeInvalid(400))
	}
	
	If pResourceObj.text.div '= "" {
		$$$ThrowFHIR($$$HSFHIRErrInvalidPatchWithNarrative, $$$OutcomeInvalid(400))
	}
	
	Set patchOperationsIter = pPatchOperations.%GetIterator()
	
	While patchOperationsIter.%GetNext(.arrayKey, .arrayValue) {
		Set op = arrayValue.op
		Set path = arrayValue.path
		Set from = arrayValue.from
		Set value = arrayValue.value
		If value '= "" {
			Set valueTypeOf = arrayValue.%GetTypeOf("value")
		} Else {
			Set valueTypeOf = ""
		}
		
		// Primary validation of current Patch operation. Other operation- and
		// path-specific validation will be done later.
		Do ..JSONPatchValidateInput(op, path, from, value, arrayKey)
		
		// Attempts to patch versionId and/or lastUpdated are ignored.
		If (path="/meta/versionId") || (path="/meta/lastUpdated") Continue
		
		Set pathLen = $Length(path, "/")
		
		For i = 2:1:pathLen {
			Set pathPieces(i) = $Piece(path, "/", i)
			// Only the last piece of the path can be "-".
			If (pathPieces(i)="-") && (i<pathLen) {
				$$$ThrowFHIR($$$HSFHIRErrInvalidPatchPathSpecified, op, arrayKey, path, $$$OutcomeInvalid(400))
			} ElseIf (pathPieces(i)'="-") && ((pathPieces(i)?1"-".N.1".".N) || (pathPieces(i)?.N1".".N)) {
				// Negative number or decimal number is never valid.
				$$$ThrowFHIR($$$HSFHIRErrInvalidPatchPathSpecified, op, arrayKey, path, $$$OutcomeInvalid(400))
			}
		}
		
		Set fromLen = $Length(from, "/")
		
		For i = 2:1:fromLen {
			Set fromPieces(i) = $Piece(from, "/", i)
			// From cannot have array pointer of "-".
			If fromPieces(i) = "-" {
				$$$ThrowFHIR($$$HSFHIRErrPatchInvalidFromSpecified, op, arrayKey, from, $$$OutcomeInvalid(400))
			} ElseIf (fromPieces(i)?1"-".N.1".".N) || (fromPieces(i)?.N1".".N) {
				// Negative number or decimal number is never valid.
				$$$ThrowFHIR($$$HSFHIRErrInvalidPatchPathSpecified, op, arrayKey, from, $$$OutcomeInvalid(400))
			}
		}
		
		Set targetIsArray = ( (pathPieces(pathLen)?1N.N) || (pathPieces(pathLen)="-") )
		
		If op="add" {
			Do ..JSONPatchAdd(op, path, value, arrayKey, valueTypeOf, pathLen, .pathPieces, pResourceObj, targetIsArray)
			Set updated = 1
			
		} ElseIf op="remove" {
			Do ..JSONPatchRemove(op, path, arrayKey, pResourceObj, pathLen, .pathPieces)
			Set updated = 1
			
		} ElseIf op="replace" {
			Do ..JSONPatchReplace(op, path, value, arrayKey, pResourceObj, pathLen, .pathPieces, valueTypeOf)
			Set updated = 1
			
		} ElseIf op="copy" {
			Do ..JSONPatchCopy(op, path, value, arrayKey, pResourceObj, pathLen, .pathPieces, valueTypeOf, from, fromLen, .fromPieces)
			Set updated = 1
			
		} ElseIf op="move" {
			Do ..JSONPatchMove(op, path, value, arrayKey, pResourceObj, pathLen, .pathPieces, valueTypeOf, from, fromLen, .fromPieces)
			Set updated = 1
			
		} ElseIf op="test" {
			Do ..JSONPatchTest(op, path, value, arrayKey, pResourceObj, pathLen, .pathPieces, valueTypeOf)
		}
	}
	
	Return updated
}

/// Primary validation of a given JSON Patch operation.
ClassMethod JSONPatchValidateInput(op As %String, path As %String, from As %String, value As %String, arrayKey As %Integer) [ Internal ]
{
	If op = "" {
		// op is required.
		$$$ThrowFHIR($$$HSFHIRErrPatchOpNotSpecified, arrayKey, $$$OutcomeInvalid(400))
		
	} ElseIf (",add,remove,replace,copy,move,test," '[ (","_op_",")) {
		// op must be valid.
		$$$ThrowFHIR($$$HSFHIRErrInvalidPatchOpSpecified, op, arrayKey, $$$OutcomeInvalid(400))
		
	} ElseIf path = "" {
		// path is required.
		$$$ThrowFHIR($$$HSFHIRErrPatchPathNotSpecified, op, arrayKey, $$$OutcomeInvalid(400))
		
	} ElseIf (path="/") || (path'["/") || (($Extract(path,*-1,*)="/-")&&('((op="add")||(op="move")||(op="copy")))) {
		// Root path is not allowed, path must start with slash, trailing slash-dash is allowed only for add, move and copy.
		$$$ThrowFHIR($$$HSFHIRErrInvalidPatchPathSpecified, op, arrayKey, path, $$$OutcomeInvalid(400))
		
	} ElseIf (value="") && ('((op="remove")||(op="move")||(op="copy"))) {
		// value is required for operations that are not remove, move and copy.
		$$$ThrowFHIR($$$HSFHIRErrPatchValueNotSpecified, op, arrayKey, $$$OutcomeInvalid(400))
		
	} ElseIf ((op="copy")||(op="move")) && (from="") {
		// from is required for copy and move.
		$$$ThrowFHIR($$$HSFHIRErrPatchFromNotSpecified, op, arrayKey, $$$OutcomeInvalid(400))
		
	} ElseIf (from'="") && ((from="/")||(from'["/")) {
		// from cannot specify the root node and must start with slash.
		$$$ThrowFHIR($$$HSFHIRErrPatchInvalidFromSpecified, op, arrayKey, from, $$$OutcomeInvalid(400))
		
	} ElseIf (op="move") && ($Piece(path,"/",1,$Length(from,"/"))=from) {
		// Move cannot move to same or child node.
		$$$ThrowFHIR($$$HSFHIRErrPatchInvalidMoveFromSpecified, op, arrayKey, from, $$$OutcomeInvalid(400))
		
	} ElseIf path="/id" {
		// Patching resource id is not allowed.
		$$$ThrowFHIR($$$HSFHIRErrPatchInvalidPatchResourceId, op, arrayKey, $$$OutcomeInvalid(400))
	}
	Quit
}

ClassMethod JSONPatchAdd(op As %String, path As %String, value, arrayKey As %Integer, valueTypeOf As %String, pathLen As %Integer, ByRef pathPieces, pResourceObj As %DynamicObject, targetIsArray As %Boolean)
{
	Set prevPathData=""
	Set pathData = pResourceObj
	
	// Turn pathData into the target property. The target property
	// does not have to already exist, but its parents need to exist.
	For j = 2:1:(pathLen-1) {
		Set prevPathData = pathData
		Set pathData = pathData.%Get(pathPieces(j))
		If pathData = "" {
			If (j=(pathLen-1)) && (targetIsArray) {
				// If the target is an array but there is no array
				// object there, go ahead and initialize one now.
				Set dynArray = []
				Do prevPathData.%Set(pathPieces(j), dynArray)
				Set pathData = prevPathData.%Get(pathPieces(j))
			} Else {
				$$$ThrowFHIR($$$HSFHIRErrPatchPathNotInResource, op, arrayKey, path, $$$OutcomeInvalid(400))
			}
		}
	}
	
	// %DynamicObject %Set() and %DynamicArray %Push() do not accept
	// 'object' or 'array' as Type values.
	If (valueTypeOf = "object") || (valueTypeOf = "array") {
		Set valueTypeOf = ""
	}
	
	If pathPieces(pathLen)?1N.N {
		// If the target array element is within the current array
		// bound then shuffle out the array elements that are after
		// the target array index.
		Do ..JSONPatchShuffleOut(.pathPieces, .pathLen, .pathData, .path, .op, .arrayKey)
		Do pathData.%Set(pathPieces(pathLen), value, valueTypeOf)
	} ElseIf pathPieces(pathLen)="-" {
		// Insert at the end of the array.
		Do pathData.%Push(value, valueTypeOf)
	} Else {
		// Path is not for an array element, just set the primitive or object.
		Do pathData.%Set(pathPieces(pathLen), value, valueTypeOf)
	}
	
	Quit
}

ClassMethod JSONPatchRemove(op, path, arrayKey, pResourceObj, pathLen, pathPieces)
{
	Set pathData = pResourceObj
	
	// Turn pathData into the data at the target location. The target location must already exist.
	Do ..JSONPatchGetLocationData(.pathPieces, .pathLen, .pathData, .pathDataTypeOf, .prevPathData, .path, .op, .arrayKey)
	
	Set pathData = prevPathData
	Do pathData.%Remove(pathPieces(pathLen))
	
	Quit
}

ClassMethod JSONPatchReplace(op, path, value, arrayKey, pResourceObj, pathLen, pathPieces, valueTypeOf)
{
	Set pathData = pResourceObj
	
	// Turn pathData into the data at the target location. The target location must already exist.
	Do ..JSONPatchGetLocationData(.pathPieces, .pathLen, .pathData, .pathDataTypeOf, .prevPathData, .path, .op, .arrayKey)
	
	// %DynamicObject %Set() and %DynamicArray %Push() do not accept
	// 'object' or 'array' as Type values.
	If (valueTypeOf = "object") || (valueTypeOf = "array") {
		Set valueTypeOf = ""
	}
	
	Set pathData = prevPathData
	Do pathData.%Set(pathPieces(pathLen), value, valueTypeOf)
	
	Quit
}

ClassMethod JSONPatchCopy(op, path, value, arrayKey, pResourceObj, pathLen, pathPieces, valueTypeOf, from, fromLen, fromPieces)
{
	Set fromData = pResourceObj
	
	// Turn fromData into the data at the from location. The from location must already exist.
	Do ..JSONPatchGetLocationData(.fromPieces, .fromLen, .fromData, .fromDataTypeOf, .prevFromData, .from, .op, .arrayKey)
	
	Set pathData = pResourceObj
	
	// Turn pathData into the data at the parent of the target location data.
	// The parent of the target location must already exist.
	Do ..JSONPatchGetLocationData(.pathPieces, pathLen-1, .pathData, .pathDataTypeOf, .prevPathData, .path, .op, .arrayKey)
	
	// %DynamicObject and %DynamicArray have no %ConstructClone(), use this.
	// Also, %DynamicObject %Set() and %DynamicArray %Push() do not accept
	// 'object' or 'array' as Type values, so blank out fromDataTypeOf in
	// those cases.
	If (fromDataTypeOf = "object") || (fromDataTypeOf = "array") {
		Set fromDataClone = ##class(%Library.DynamicObject).%FromJSON(fromData.%ToJSON())
		Set fromDataTypeOf = ""
	} Else {
		Set fromDataClone = fromData
	}
	
	If pathPieces(pathLen)?1N.N {
		// If the target array element is within the current array
		// bound then shuffle out the array elements that are after
		// the target array index.
		Do ..JSONPatchShuffleOut(.pathPieces, .pathLen, .pathData, .path, .op, .arrayKey)
		Do pathData.%Set(pathPieces(pathLen), fromDataClone, fromDataTypeOf)
	} ElseIf pathPieces(pathLen)="-" {
		// Insert at the end of the array.
		Do pathData.%Push(fromDataClone, fromDataTypeOf)
	} Else {
		Do pathData.%Set(pathPieces(pathLen), fromDataClone, fromDataTypeOf)
	}
	
	Quit
}

ClassMethod JSONPatchMove(op, path, value, arrayKey, pResourceObj, pathLen, pathPieces, valueTypeOf, from, fromLen, fromPieces)
{
	Set fromData = pResourceObj
	
	// Turn fromData into the data at the from location. The from location must already exist.
	Do ..JSONPatchGetLocationData(.fromPieces, .fromLen, .fromData, .fromDataTypeOf, .prevFromData, .from, .op, .arrayKey)
	
	Set pathData = pResourceObj
	
	// Turn pathData into the data at the parent of the target location data.
	// The parent of the target location must already exist.
	Do ..JSONPatchGetLocationData(.pathPieces, pathLen-1, .pathData, .pathDataTypeOf, .prevPathData, .path, .op, .arrayKey)
	
	// Save and remove the from data.
	Set saveFromData = fromData
	Do prevFromData.%Remove(fromPieces(fromLen))
	
	// %DynamicObject %Set() and %DynamicArray %Push() do not accept
	// 'object' or 'array' as Type values.
	If (fromDataTypeOf = "object") || (fromDataTypeOf = "array") {
		Set fromDataTypeOf = ""
	}
	
	If pathPieces(pathLen)?1N.N {
		// If the target array element is within the current array
		// bound then shuffle out the array elements that are after
		// the target array index.
		Do ..JSONPatchShuffleOut(.pathPieces, .pathLen, .pathData, .path, .op, .arrayKey)
		Do pathData.%Set(pathPieces(pathLen), saveFromData, fromDataTypeOf)
	} ElseIf pathPieces(pathLen)="-" {
		// Insert at the end of the array.
		Do pathData.%Push(saveFromData, fromDataTypeOf)
	} Else {
		Do pathData.%Set(pathPieces(pathLen), saveFromData, fromDataTypeOf)
	}
	
	Quit
}

ClassMethod JSONPatchTest(op, path, value, arrayKey, pResourceObj, pathLen, pathPieces, valueTypeOf)
{
	Set pathData = pResourceObj
	
	// Turn pathData into the data at the target location. The target location must already exist.
	Do ..JSONPatchGetLocationData(.pathPieces, pathLen, .pathData, .pathDataTypeOf, .prevPathData, .path, .op, .arrayKey)
	
	// %GetTypeOf is part of comparing primitives (e.g., "true" does not match true).
	Set pathTypeOf = prevPathData.%GetTypeOf(pathPieces(pathLen))
	
	If '$IsObject(pathData) {
		Set pathDataJSONStr = pathData
	} Else {
		Set pathDataJSONStr = pathData.%ToJSON()
	}
	If '$IsObject(value) {
		Set valueJSONStr = value
	} Else {
		Set valueJSONStr = value.%ToJSON()
	}
	
	If (pathDataJSONStr'=valueJSONStr) || (pathTypeOf'=valueTypeOf) {
		$$$ThrowFHIR($$$HSFHIRErrPatchTestFailed, op, arrayKey, path, valueJSONStr, $$$OutcomeInvalid(400))
	}
	
	Quit
}

/// Get various info about the data found at the specified path.<br>
/// pieces: Array containing the input object data at each level of the current Patch path.<br>
/// len: The length (depth) of the current Patch path.<br>
/// data: As input, is the object being referenced by the current Patch path.
///       As output, is the item at the end of the path.<br>
/// typeOf: output - %DynamicObject typeOf of the item at the end of the path.<br>
/// prevData: output - The containing object of the item at the end of the path.<br>
/// path, op, arrayKey: Passed in only for use in error reporting.<br>
ClassMethod JSONPatchGetLocationData(ByRef pieces, len, ByRef data, Output typeof, Output prevData, path, op, arrayKey) [ Internal, ProcedureBlock = 0 ]
{
	New j
	Set prevData = ""
	For j = 2:1:len {
		Set prevData = data
		If ($IsObject(data)) && (data.%IsA("%Library.DynamicArray")) && (pieces(j)'?1N.N) {
			$$$ThrowFHIR($$$HSFHIRErrPatchPathInvalidArrayIndex, op, arrayKey, path, pieces(j), $$$OutcomeInvalid(400))
		}
		Set typeof = data.%GetTypeOf(pieces(j))
		Set data = data.%Get(pieces(j))
		If data="" {
			$$$ThrowFHIR($$$HSFHIRErrPatchPathNotInResource, op, arrayKey, path, $$$OutcomeInvalid(400))
		}
	}
	Quit
}

/// %DynamicArray does not appear to have an "insert" function. We use this to shuffle array
/// items out before doing our own Set at the desired array position.<br>
/// pieces: Array containing the input object data at each level of the current Patch path.<br>
/// len: The length (depth) of the current Patch path.<br>
/// data: The object being referenced by the current Patch path.<br>
/// path, op, arrayKey: Passed in only for use in error reporting.<br>
ClassMethod JSONPatchShuffleOut(ByRef pieces, len, data, path, op, arrayKey) [ Internal, ProcedureBlock = 0 ]
{
	New j,size
	Set size = data.%Size()
	If pieces(len)'>(size-1) {
		For j = (size-1):-1:pieces(len) {
			Do data.%Set(j+1,data.%Get(j))
		}
	} ElseIf pieces(len)>size {
		// Path cannot be beyond the end of the existing array.
		$$$ThrowFHIR($$$HSFHIRErrPatchPathExceedsArray, op, arrayKey, path, $$$OutcomeInvalid(400))
	}
	Quit
}

Method History(pResourceType As %String, pResourceId As %String, pSince As %String, pAt As %String) As HS.FHIRServer.Util.SearchResult
{
	Set resourceVerClass = ..strategy.GetResourceVersionClass(pResourceType)

	#dim tResultSet as HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()
	// if the resource doesn't exist (not even deleted), return status 404 Not Found
	#dim storageObj as HS.FHIRServer.Storage.Json.ResourceVer

	Set storageObj = ..GetStorageObject(pResourceType, pResourceId)
	Set versionId = storageObj.VersionId
	
	while versionId >= 1  {
		// Handle "_since" parameter
		// We are processing the versions in reverse chronological order, so once we find one with
		//  LastModified earlier than "_since", quit.
		// Note this correctly handles the case where pSince="".
		If (pSince ] storageObj.LastModified) { 
			Quit 
		}
		
		Do tResultSet.AddRow(storageObj.Key, storageObj.ResourceType, storageObj.ResourceId, storageObj.VersionId, "match", storageObj.Verb)
		
		// Get Info on the next version present in the Version table
		for {
			Set versionId = versionId - 1
			Quit:(versionId<1)
			Set storageObj = $classmethod(resourceVerClass, "TypeIdVerIdxOpen", pResourceType, pResourceId, versionId)
			Quit:$IsObject(storageObj)
		}
	}
	Do tResultSet.%SetIterator(0)
	return tResultSet
}

/// Adds a new version to the repository 
/// if pCurrentStorageObj is empty, this is a new resource to be added
/// if pNewResource is empty, this is a delete of pCurrentStorageObj
/// Otherwise it is an update
Method AddVersion(pCurrentStorageObj As HS.FHIRServer.Storage.Json.Resource, pChangeVerb As %String, pNewResource As %DynamicObject) As HS.FHIRServer.Storage.Json.Resource [ Internal ]
{
	#dim currentStorage as HS.FHIRServer.Storage.Json.Resource = pCurrentStorageObj
	Set tLastVersion = 0
	if (currentStorage = "" ) {
		// This is a new resource
		Set currentStorage = $classmethod(..strategy.GetResourceClass(pNewResource.resourceType), "%New")
		Set currentStorage.VersionId = 0
		Set currentStorage.ResourceType = pNewResource.resourceType
		Set currentStorage.Format = $$$FHIRContentCodeJSON
		if pNewResource.id = "" {
			// We have to assign an ID to the resource
			// First assign a transient id so that the key field is non-null
			Set currentStorage.ResourceId = "Adding"_$J
			Set currentStorage.Key = $$$BuildRsrcKey(pNewResource.resourceType, currentStorage.ResourceId)
			$$$ThrowOnError( currentStorage.%Save()) 
			Set pNewResource.id = currentStorage.%Id()
			$$$FSLog("Assigned new ResourceId = "_$$$BuildRsrcKey(pNewResource.resourceType, pNewResource.id))
		}
		Set currentStorage.ResourceId = pNewResource.id
		Set currentStorage.Key = $$$BuildRsrcKey(pNewResource.resourceType, currentStorage.ResourceId)

	} else {
		Set versionStorage = $classmethod(..strategy.GetResourceVersionClass(currentStorage.ResourceType), "%New")

		// Populate the new Storage object's key fields
		Set versionStorage.Key = currentStorage.Key
		Set versionStorage.ResourceType = currentStorage.ResourceType
		Set versionStorage.ResourceId = currentStorage.ResourceId
		Set versionStorage.VersionId = currentStorage.VersionId
		Set versionStorage.LastModified = currentStorage.LastModified
		Set versionStorage.Verb = currentStorage.Verb
		Set versionStorage.Format = currentStorage.Format
		If ('$IsObject(currentStorage.ResourceStream))||(currentStorage.ResourceStream.Size=0) {
			Set versionStorage.ResourceString = currentStorage.ResourceString
		} Else {
			Do versionStorage.ResourceStream.CopyFrom(currentStorage.ResourceStream)			
		}
		$$$ThrowOnError( versionStorage.%Save()) 

		
		// Remove entries from search tables.
		// First check for the existence of the search table, then a row corresponding to this resource in that table
		Set searchClass = ..strategy.GetSearchClass(currentStorage.ResourceType)
		Set allSearchClass = ..strategy.GetSearchClass("")
		
		for tClassname = searchClass,allSearchClass {
			if ($$$comClassDefined(tClassname)) && ($CLASSMETHOD(tClassname, "KeyIdxExists", currentStorage.Key, .rowObjectId)) {
				$$$ThrowOnError( $CLASSMETHOD(tClassname, "%DeleteId", rowObjectId)) 
			}
		}
	}
	
		// Bump the Version Number
	Set currentStorage.VersionId = currentStorage.VersionId+1
	Set currentStorage.LastModified =  $ZDT($H,3,7) // $ZDT($ZTS,3,7,2)
	Set currentStorage.Verb = pChangeVerb
	if (pNewResource = "") {
		// No JSON means the new storage object is flagged as deleted
		Set currentStorage.Deleted = 1
	} else {
		// This could be a new resource or an update of a deleted resource
		Set currentStorage.Deleted = 0
		
		// Get the JSON rendering, we will need to update it
		if (pNewResource.meta = "") {
			Set pNewResource.meta = $$$NewJSONObject
		}
		Set pNewResource.meta.lastUpdated = currentStorage.LastModified
		Do pNewResource.meta.%Set("versionId", currentStorage.VersionId, "string")
		Set compartmentList = ..strategy.schema.BuildCompartmentList(pNewResource)
		// Add Compartment metadata
		// Manually clear Compartments and CompartmentsIdx
		do currentStorage.Compartments.Clear()
		for cix=1:1:$LL(compartmentList) {
			Do currentStorage.Compartments.Insert($LG(compartmentList, cix))	
		}
		
		set tTempStream = ##class(%Stream.TmpCharacter).%New()
		// Write the JSON to a stream (so we can see its size)
		Do pNewResource.%ToJSON(tTempStream)
		Do tTempStream.Rewind()

		set %maxlocallength = $Get(%maxlocallength,$$$MaxLocalLength)
		set currentStorage.ResourceString = ""
		do currentStorage.ResourceStream.Clear()
		if tTempStream.Size'>%maxlocallength {
			while 'tTempStream.AtEnd {
				// Reading the stream in 32767 chunks (which is the default) is faster
				// than reading it all at once, when dealing with very long streams.
				Set currentStorage.ResourceString = currentStorage.ResourceString _ tTempStream.Read()
			}
		} else {
			$$$ThrowOnError( currentStorage.ResourceStream.CopyFrom(tTempStream)) 
		}
	}
	Set currentStorage.ServiceId = ..strategy.InstanceKey
	$$$ThrowOnError( currentStorage.%Save())
	return currentStorage
}

Method getSearchColumnsForType(resourceType As %String)
{
	if '$D(..spcache(resourceType), columns) {
		Set idList = ##class(HS.FHIRServer.Storage.Json.SearchColumn).getParamIdListForType(resourceType, ..strategy.InstanceKey)
		Set columns = ##class(%ListOfObjects).%New()
		set ix=0
		while $ListNext(idList, ix, id) {
			Set column = ##class(HS.FHIRServer.Storage.Json.SearchColumn).getById(id)
			Do columns.Insert(column)
			Set ..spcache(resourceType, column.ParamName) = columns.Count()
		}
		Set ..spcache(resourceType) = columns
	}
	return columns
}

Method getTableForResourceType(resourceType As %String) As %String
{
	Set list = ..getSearchColumnsForType(resourceType)
	if $IsObject(list) && list.Count() {
		return ..strategy.GetSearchTable(list.GetAt(1).TableName)
	}
	$$$ThrowFHIR($$$HSFHIRErrResourceTypeUnknown, resourceType)
}

Method findSearchColumn(resourceType As %String, paramName As %String) As HS.FHIRServer.Storage.Json.SearchColumn
{
	Set list = ..getSearchColumnsForType(resourceType)
	if $IsObject(list) && $D(..spcache(resourceType, paramName), index) {
		return list.GetAt(index)
	}
	return ""
}

Method getSearchColumn(resourceType As %String, paramName As %String) As HS.FHIRServer.Storage.Json.SearchColumn
{
	Set list = ..getSearchColumnsForType(resourceType)
	if $IsObject(list) && $D(..spcache(resourceType, paramName), index) {
		return list.GetAt(index)
	}
	$$$ThrowFHIR($$$HSFHIRErrInvalidQueryParameter, resourceType, paramName, $$$OutcomeInvalid(400))
}

}
