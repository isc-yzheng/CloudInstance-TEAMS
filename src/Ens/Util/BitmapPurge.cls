/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

IncludeGenerator Ensemble

/// Only applies to persistent classes using standard storage and bitmap indices.
Class Ens.Util.BitmapPurge [ Abstract, System = 4 ]
{

/// Utility method to allow empty bitmap indices to be purged after the associated 
/// data has been purged. <var>pChunkLimit</var> controls the maximum number of bitmap chunks 
/// that will be removed from the start of the extent before any populated nodes exist. 
/// Specifying -1 will clean up ALL such empty bitmaps, and specifying 0 will not clean up any 
/// such bitmaps. Note that bitmap chunks contain 64,000 bits, so the default value of 500 will
/// remove up to 500 x 64,000 bits = 32 million stale bitmap entries.
/// Also note that this limit ONLY applies to the main extent. Many more nodes may need to be removed
/// from other indices in the class, as these other indices maintain separate buckets for each possible
/// value. For example, a production with 100 business services would likely result in the SourceConfigName
/// index of the Ens.MessageHeader class having 100 distinct buckets. The bitmap purge process could then need
/// to remove as many as 5,000 bitmap nodes for this index alone.
ClassMethod PurgeBitmaps(pChunkLimit As %Integer = 500, Output pChunksKilled As %Integer, pNoJournal As %Boolean = 0) As %Status [ CodeMode = objectgenerator ]
{
	Set tBitmaps = ""
	Set tExtent = ""
	Set tIndexKey = ""
	For {
		Set tIndex = %compiledclass.Indices.GetNext(.tIndexKey)
		If (tIndexKey = "")||'$IsObject(tIndex) {
			Quit
		}
		If (tIndex.Type '= "bitmap") {
			Continue
		}
		If tIndex.Extent {
			If tExtent = "" { // only allow one extent
				Set tExtent = tIndex.Name
			}
		}
		ElseIf '$data(tBitmaps(tIndex.Name)) {
			Set tBitmaps(tIndex.Name) = ""
			Set tBitmaps = tBitmaps _ $lb($$$quote(tIndex.Name))
		}
	}
	// If we don't have an extent bitmap, there is nothing we can do.
	If (tExtent = "") {
		Do %code.WriteLine($char(9) _ "Set pChunksKilled = 0")
		Do %code.WriteLine($char(9) _ "Quit $$$OK")
		Quit $$$OK
	}
	// Check that we only have one storage defined. Return an error for the purge.
	If (%compiledclass.Storages.Count() > 1) {
		Quit $$$ERROR($$$EnsErrGeneral,"Multiple storages defined. Correct extent can't be determined for class " _ %compiledclass.Name)
	}
	Set tStorage = %compiledclass.Storages.GetNext("")
	If '$IsObject(tStorage) {
		Quit $$$ERROR($$$EnsErrGeneral,"Unable to load Compiled Storage for class " _ %compiledclass.Name)
	}
	Set tIndexLocation = tStorage.IndexLocation
	If (tIndexLocation = "") {
		Quit $$$ERROR($$$EnsErrGeneral,"Unable to determine index location for class " _ %compiledclass.Name)
	}
	Set tDataLocation = tStorage.DataLocation
	If (tDataLocation = "") {
		Quit $$$ERROR($$$EnsErrGeneral,"Unable to determine data location for class " _ %compiledclass.Name)
	}
	Set tExtentQuoted = $$$quote(tExtent)

	Do %code.WriteLine($char(9) _ "Set tStatus = $$$OK")
	Do %code.WriteLine($char(9) _ "Set tEnableJournal = 0")
	Do %code.WriteLine($char(9) _ "Kill pChunksKilled")
	Do %code.WriteLine($char(9) _ "Set pChunksKilled = 0")
	Do %code.WriteLine($char(9) _ "Try {")
	Do %code.WriteLine($char(9,9) _ "Set tFirstID = $order(" _ tDataLocation _ "(""""))")
	Do %code.WriteLine($char(9,9) _ "Set tMaxChunk = (tFirstID \ 64000)")
	Do %code.WriteLine($char(9,9) _ "Set tFirstChunk = $order(" _ tIndexLocation _ "(" _ tExtentQuoted _ ",""""))")
	Do %code.WriteLine($char(9,9) _ "If (pChunkLimit > 0) {")
	Do %code.WriteLine($char(9,9,9) _ "Set tMaxChunk = $select((tFirstChunk + pChunkLimit - 1) < tMaxChunk: (tFirstChunk + pChunkLimit - 1), 1: tMaxChunk)")
	Do %code.WriteLine($char(9,9) _ "}")
	// Quit early if no chunks will be removed
	Do %code.WriteLine($char(9,9) _ "If (tMaxChunk < tFirstChunk) Quit")
	Do %code.WriteLine($char(9,9) _ "If pNoJournal && $$CURRENT^%NOJRN() {")
	Do %code.WriteLine($char(9,9,9) _ "Set tEnableJournal = 1")
	Do %code.WriteLine($char(9,9,9) _ "Do DISABLE^%NOJRN")
	Do %code.WriteLine($char(9,9) _ "}")
	Do %code.WriteLine($char(9,9) _ "Set pChunksKilled(" _ tExtentQuoted _ ") = 0")
	Do %code.WriteLine($char(9,9) _ "Set tChunk = """"")
	Do %code.WriteLine($char(9,9) _ "For {")
	Do %code.WriteLine($char(9,9,9) _ "Set tChunk = $order(" _ tIndexLocation _ "(" _ tExtentQuoted _ ",tChunk))")
	Do %code.WriteLine($char(9,9,9) _ "Quit:(tChunk = """")||(tChunk > tMaxChunk)")
	Do %code.WriteLine($char(9,9,9) _ "Kill " _ tIndexLocation _ "(" _ tExtentQuoted _ ",tChunk)")
	Do %code.WriteLine($char(9,9,9) _ "Set pChunksKilled = pChunksKilled + 1")
	Do %code.WriteLine($char(9,9,9) _ "Set pChunksKilled(" _ tExtentQuoted _ ") = pChunksKilled(" _ tExtentQuoted _ ") + 1")
	Do %code.WriteLine($char(9,9) _ "}")
	// Only generate code for bitmap indices if we found them
	If $listlength(tBitmaps) {
		Do %code.WriteLine($char(9,9) _ "For tIndex = " _ $listtostring(tBitmaps) _ " {")
		Do %code.WriteLine($char(9,9,9) _ "Set pChunksKilled(tIndex) = 0")
		Do %code.WriteLine($char(9,9,9) _ "Set tBucket = """"")
		Do %code.WriteLine($char(9,9,9) _ "For {")
		Do %code.WriteLine($char(9,9,9,9) _ "Set tBucket = $order(" _ tIndexLocation _ "(tIndex,tBucket))")
		Do %code.WriteLine($char(9,9,9,9) _ "Quit:(tBucket = """")")
		Do %code.WriteLine($char(9,9,9,9) _ "Set tChunk = """"")
		Do %code.WriteLine($char(9,9,9,9) _ "For {")
		Do %code.WriteLine($char(9,9,9,9,9) _ "Set tChunk = $order(" _ tIndexLocation _ "(tIndex,tBucket,tChunk))")
		Do %code.WriteLine($char(9,9,9,9,9) _ "Quit:(tChunk = """")||(tChunk > tMaxChunk)")
		Do %code.WriteLine($char(9,9,9,9,9) _ "Kill " _ tIndexLocation _ "(tIndex,tBucket,tChunk)")
		Do %code.WriteLine($char(9,9,9,9,9) _ "Set pChunksKilled = pChunksKilled + 1")
		Do %code.WriteLine($char(9,9,9,9,9) _ "Set pChunksKilled(tIndex) = pChunksKilled(tIndex) + 1")
		Do %code.WriteLine($char(9,9,9,9) _ "}")
		Do %code.WriteLine($char(9,9,9) _ "}")
		Do %code.WriteLine($char(9,9) _ "}")
	}
	Do %code.WriteLine($char(9) _ "}")
	Do %code.WriteLine($char(9) _ "Catch {")
	Do %code.WriteLine($char(9,9) _ "Set tStatus = $$$SystemError")
	Do %code.WriteLine($char(9) _ "}")
	Do %code.WriteLine($char(9) _ "Try {")
	Do %code.WriteLine($char(9,9) _ "If tEnableJournal && '$$CURRENT^%NOJRN {")
	Do %code.WriteLine($char(9,9,9) _ "Do ENABLE^%NOJRN")
	Do %code.WriteLine($char(9,9) _ "}")
	Do %code.WriteLine($char(9) _ "}")
	Do %code.WriteLine($char(9) _ "Catch {")
	Do %code.WriteLine($char(9,9) _ "Set tEnableSC = $$$SystemError")
	Do %code.WriteLine($char(9,9) _ "Set tStatus = $$$ADDSC(tStatus,tEnableSC)")
	Do %code.WriteLine($char(9) _ "}")
	Do %code.WriteLine($char(9) _ "Quit tStatus")
	Quit $$$OK
}

}
