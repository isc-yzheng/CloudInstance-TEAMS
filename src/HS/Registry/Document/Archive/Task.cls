/// This is the task definition that can be used to build a list of documents to be archived.<br>
/// This task should be called once a year or so (ideally based 
/// on the minimum value of PurgeDefaultDays so that new documents don't need to be added
/// to the list until the next run), and whenever the Rules are changed for a given 
/// Facility/SourceId
Class HS.Registry.Document.Archive.Task Extends %SYS.Task.Definition [ System = 4 ]
{

Property DefaultPurgeDays As %Integer [ InitialExpression = {365.25*3\1} ];

/// OID code for current repository 
Property CurrentRepository As %String [ InitialExpression = {##class(HS.Data.OIDMap).GetOIDForCode("HSREPOSITORY")} ];

Property SourceIDS As list Of %String;

/// use CreationTimeInternal (effective registration time) instead of CreationTime <br/>
/// (time provided in registration message)
Property UseCreationTimeInternal As %Boolean [ InitialExpression = 0 ];

/// if RefreshList is true then the purge date will be recomputed for existing records
Property RefreshList As %Boolean [ InitialExpression = 0 ];

Method OnTask() As %Status
{
	Try {
		Set tSC=$$$OK
		If ..RefreshList {
			Set tSC= ..RecalculateAfterRuleChange()
		} Else {
			Set tSC= ..BuildList()
		}
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

Method BuildList() As %Status
{
	Try {
		#define LastID ^ISC.HS.Reg.Doc.Archive("Last")
		Set tSC=$$$OK
		Set tLastLogical=""
		/// Could be a long running job, restart where we were
		Set tLastID=$G($$$LastID)
		/// can't just query for the items in the current repository because the older metadata items will report the current repository
		Set tSQL="Select ID,LogicalIID,SourceIdentifier_Value SourceID,Version,RepositoryUniqueID from HS_Registry.Document" 
		Set:tLastID]"" tSQL=tSQL_" WHERE ID>?",tParam($i(tParam))=tLastID
		//Set tSQL=tSQL_" Order By LogicalIID,Version Desc"
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,tParam...)
		Set tCount1=0
		If tRS.SQLCODE {
			Write !,"SQLCODE ERROR:"_tRS.SQLCODE Set tSC = $$$ERROR($$$SQLError,tRS.SQLCODE) Quit
		}
		While tRS.%Next() {
			Set tSQL="Select ID,LogicalIID,SourceIdentifier_Value SourceID,Version,RepositoryUniqueID from HS_Registry.Document WHERE LogicalIID=? Order By Version Desc " 
			Set tRS1 = ##class(%SQL.Statement).%ExecDirect(,tSQL,tRS.LogicalIID)
			Set tSC=..OneRow(.tLastLogical,tRS1)
			Quit:$$$ISERR(tSC)
			// for long running job keep track of where we were, for a possible restart
			Set $$$LastID=tRS.ID
		}
		If $$$ISOK(tSC) Set $$$LastID=""
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

Method OneRow(pLastLogical, pRS) As %Status
{
	try {
		Set tSC=$$$OK
		If pLastLogical=pRS.LogicalIID Quit
		Set pLastLogical=pRS.LogicalIID  /// multiple versions for the same document - only take the highest version
		Quit:pRS.RepositoryUniqueID'=..CurrentRepository  // already moved
		Set tPurgeDate = ..DeterminePurgeDate(pRS.ID,.tSC)
		Quit:$$$ISERR(tSC)
		Set tSC = ..UpdatePurgeDate(pRS.LogicalIID,pRS.SourceID,pRS.Version,tPurgeDate)
		Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

Method RecalculateAfterRuleChange() As %Status
{
	Try {
		Set tSC=$$$OK
		Set tLastLogical=""
		/// recompute for all sources
		If '..SourceIDS.Count() {
			Set tSQL="Select ID,LogicalIID,SourceIdentifier_Value SourceID,Version,RepositoryUniqueID from HS_Registry.Document Where LogicalIID in (Select LogicalIID from HS_Registry_Document_Archive.Queue) Order By LogicalIID,Version Desc"
			Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL)
			If tRS.SQLCODE {
				Write !,"SQLCODE ERROR:"_tRS.SQLCODE Set tSC = $$$ERROR($$$SQLError,tRS.SQLCODE) Quit
			}	
			While tRS.%Next() {
				Do ..OneRow(.tLastLogical,tRS)
			}
		} Else {
			For tIdx=1:1:..SourceIDS.Count() {
				Set tSourceID=..SourceIDS.GetAt(tIdx) 
				Continue:tSourceID=""
				Set tSQL="Select ID,LogicalIID,SourceIdentifier_Value SourceID,Version,RepositoryUniqueID from HS_Registry.Document Where LogicalIID in (Select LogicalIID from HS_Registry_Document_Archive.Queue where SourceID=?) Order By LogicalIID,Version Desc"
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,tSourceID)
				If tRS.SQLCODE {
					Write !,"SQLCODE ERROR:"_tRS.SQLCODE Set tSC = $$$ERROR($$$SQLError,tRS.SQLCODE) Quit
				}	
				While tRS.%Next() {
					Do ..OneRow(.tLastLogical,tRS)
				}
			}
		}
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

Method GetRules(pSourceID, pSC) As %ListOfObjects
{
	Set pSC=$$$OK
	Set tSQL="select Rule from HS_Registry_Document_Archive.Rule_sourceIDS where sourceids=?"
	Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,pSourceID)
	If tRS.SQLCODE {
		Set pSC = $$$ERROR($$$SQLError,tRS.SQLCODE) Quit
	}
	Set tList = ##class(%ListOfObjects).%New()
	While tRS.%Next() {
		Set tObject=##class(HS.Registry.Document.Archive.Rule).%OpenId(tRS.Rule)
		Do tList.Insert(tObject)
	}
	// if no rules for source create default rule
	If 'tList.Count() {
		Set tRule=##class(HS.Registry.Document.Archive.Rule).%New()
		Set tRule.PurgeDefaultDays=..DefaultPurgeDays
		Do tList.Insert(tRule)
	}
	Quit tList
}

Method DeterminePurgeDate(pID, Output pSC) As %Date
{
	Set pSC=$$$OK,tDate=""
	try {
		Set tObject=##class(HS.Registry.Document).%OpenId(pID,0,.pSC)
		If '$IsObject(tObject) {
			Quit:$$$ISERR(tSC)
			Set tSC=$$$ERROR($$$GeneralError,"Object to load not found")
			Quit
		}
		Set tRules = ..GetRules(tObject.SourceIdentifier.Value,.tSC)
		Quit:$$$ISERR(tSC)
		Set tPurgeDays = 0
		For tRuleIdx=1:1:tRules.Count() {
			Set tRule=tRules.GetAt(tRuleIdx)
			Set tExtension=0
			For tItemIdx = 1:1:tRule.Items.Count() {
				Set tItem=tRule.Items.GetAt(tItemIdx)
				Set tNextName=""
				For  {
					Set tValue = tItem.MetaDataNameValue.GetNext(.tNextName) Quit:tNextName=""
					If ..HasReferenceValue(tObject,tNextName,tValue) Set:tItem.ExtensionDays>tExtension tExtension=tItem.ExtensionDays
				}
				Set tNextName=""
				For  {
					Set tValue = tItem.SlotNameValue.GetNext(.tNextName) Quit:tNextName=""
					For tIdxSlot=1:1:tObject.Slots.Count() {
						Set tSlot=tObject.Slots.GetAt(tIdxSlot)
						Continue:tSlot.Name'=tNextName
						For tIdxValues=1:1:tSlot.ValueList.Count() {
							Set tValueListValue=tSlot.ValueList.GetAt(tIdxValues)
							If tValue=tValueListValue Set:tItem.ExtensionDays>tExtension tExtension=tItem.ExtensionDays
						}
					}
				}
			}
			Set tThisPurgeDays = tRule.PurgeDefaultDays+tExtension
			Set:tThisPurgeDays>tPurgeDays tPurgeDays=tThisPurgeDays
		}
		if ..UseCreationTimeInternal {
			Set tCreationDate = $zdh($e(tObject.CreationTimeInternal_"0101",1,8),8)
		} else {
			Set tCreationDate = $zdh($e(tObject.CreationTime_"0101",1,8),8)
		}	
		Set tDate=tCreationDate+tPurgeDays
	} catch ex {
		Set pSC=ex.AsStatus()
	}
	Quit tDate\1
}

/// ex tObject.Property[].Code
/// tObject.Property[]  value=@Code="foo"@CodingScheme="bar"
Method HasReferenceValue(pRef, pNextName, pValue) As %Boolean
{
	Set tHasValue=0,tIsCollection=0
	Set tProperty=$p(pNextName,".")
	If tProperty["[]" {
		Set tProperty = $p(tProperty,"[]")
		Set tIsCollection=1
	}
	Set tNext=$p(pNextName,".",2,*)
	Set tRef=$property(pRef,tProperty)
	// if objectref versus a value
	If $isObject(tRef) {
		If tIsCollection {
			Set tNextItem=""
			For  {
				Set tValue=tRef.GetNext(.tNextItem) Quit:tNextItem=""
				If tNext]"" Set tHasValue=..HasReferenceValue(tValue,tNext,pValue) Return:tHasValue tHasValue
			}
		} Else {
			If tNext]"" Return ..HasReferenceValue(tRef,tNext,pValue)
		}
	}
	Return ..CheckValue(pRef,tProperty,pValue)
}

Method CheckValue(pRef, pProperty, pValue) As %Boolean
{
	Set tHasValue=0
	Set tProperty = $property(pRef,pProperty)
	If $e(pValue)="@" {
		Set tPos=2,tMatch=1
		For {
			Set tItem=$p(pValue,"@",tPos)
			Quit:tItem=""
			If $property(tProperty,$p(tItem,"="))'=$p(tItem,"=",2) Set tMatch=0
			Quit:'tMatch
			Set tPos=tPos+1
		}
		Return tMatch
	}
	Return tProperty=pValue
}

Method UpdatePurgeDate(pLogicalIID, pSourceID, pVersion, pDate) As %Status
{
	Set tSC=$$$OK
	try {
		Set tObject = ##class(HS.Registry.Document.Archive.Queue).LogicalIIDIndexOpen(pLogicalIID,4,.tSC)
		If '$IsObject(tObject) {
			Set tObject = ##class(HS.Registry.Document.Archive.Queue).%New()
		}
		Set tObject.LogicalIID=pLogicalIID
		Set tObject.SourceID=pSourceID
		Set tObject.PlanPurgeDate=pDate
		Set tObject.Version=pVersion
		Set tSC=tObject.%Save()
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

}
