/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIX12

/// Utility functions for creating X12 Documents
Class Ens.X12.FunctionSet Extends Ens.Rule.FunctionSet [ System = 4 ]
{

/// Make and return an X12 FuntionalGroup Document without GE segment<br>
/// The separators will be taken from the <PARAMETER>InterchangeParent</PARAMETER>. <br>
/// The Document Category will be taken from <PARAMETER>InterchangeParent</PARAMETER> unless specified in
/// optional <PARAMETER>Doctype</PARAMETER> <br>
/// The Document Name will be taken from <PARAMETER>Doctype</PARAMETER> if given
/// otherwise it will be FunctionalGroup <br>
/// The optional <PARAMETER>Doctype</PARAMETER> may specify just a document name and does not
/// need to include the Document category as that can be taken from the InterchangeParent. <br>
/// The new document will be set as a batch child of <PARAMETER>InterchangeParent</PARAMETER><br>
/// The document will have a TransactionSet place holder segment.<br>
/// If <PARAMETER>ForceNewPlaceHolderInParent</PARAMETER> is true (the default is false) then
/// a new GroupDocsRef place holder segment will be made in the <PARAMETER>InterchangeParent</PARAMETER><br>
/// If an Error is encountered it will be thrown.<br>
ClassMethod X12NewFunctionalGroup(InterchangeParent As EnsLib.EDI.X12.Document, DocType As %String = "", ForceNewPlaceHolderInParent As %Boolean = 0) As EnsLib.EDI.X12.Document [ Final ]
{
	#dim X12FunctionalGroup = ##class(EnsLib.EDI.X12.Document).%New()

	Set X12FunctionalGroup.Separators = InterchangeParent.Separators

	#dim docCategory, docName

	If $Length(DocType,":") < 2 {
		Set docCategory = InterchangeParent.DocTypeCategory
		Set docName = $Piece(DocType,":")
		If docName = "" {
			#; Find whether Group or FunctionalGroup
			#dim tSC = $$$OK
			Set docName = $Piece(##class(EnsLib.EDI.X12.Schema).ResolveSchemaTypeToDocType(docCategory,"Group",.tSC),":",2)
			$$$ThrowOnError(tSC)
		}
	} Else {
		Set docCategory = $Piece(DocType,":")
		Set docName = $Piece(DocType,":",2)
	}
	Do X12FunctionalGroup.PokeDocType(docCategory_":"_docName)

	/* Get parent id - this sets it in InterchangeParent if InterchangeParent not saved yet */
	Set X12FunctionalGroup.ParentId = InterchangeParent.getId()

	#dim tDataElementSeparator=$$$ELESEP(X12FunctionalGroup.Separators)

	/* Create blank GS segment */
	Set tGS=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(X12FunctionalGroup.Separators,1,3)_"GS"))
	$$$ThrowOnError(X12FunctionalGroup.AppendSegment(tGS))

	/* Initialize transaction set place holder segment. Set SegIndex to 2.*/
	#dim tTransactionSetsPlaceholder=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(X12FunctionalGroup.Separators,1,3)_"TransactionSetDocsRef"_tDataElementSeparator_2))
	$$$ThrowOnError(X12FunctionalGroup.AppendSegment(tTransactionSetsPlaceholder))

	/* Find InterchangeParent GroupDocsRef placeholder or create and add Functional Group*/
	#dim groupPlaceHolderIndex = ""
	#dim groupDocsRefPlaceHolderSegment As EnsLib.EDI.X12.Segment = $$$NULLOREF
	If 'ForceNewPlaceHolderInParent {
		Set groupDocsRefPlaceHolderSegment = InterchangeParent.FindSegment("GroupDocsRef", .groupPlaceHolderIndex)
	}

	/* If creating place holder segment add at end if no IEA or else insert before IEA */
	If (groupDocsRefPlaceHolderSegment = $$$NULLOREF) {
		#dim ieaSegmentId
		#dim ieaSegment = InterchangeParent.FindSegment("IEA",.ieaSegmentId)
		If ieaSegment '= $$$NULLOREF {
			/* will replace iea Segment with place holder then add back iea segment.  */
			Set groupPlaceHolderIndex = InterchangeParent.SegCount
		} Else {
			Set groupPlaceHolderIndex = InterchangeParent.SegCount+1
		}

		Set groupDocsRefPlaceHolderSegment=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(InterchangeParent.Separators,1,3)_"GroupDocsRef"_tDataElementSeparator_groupPlaceHolderIndex))

		If ieaSegment '= $$$NULLOREF {
			/* replace iea Segment with place holder then add back iea segment */
			$$$ThrowOnError(InterchangeParent.SetSegmentAt(groupDocsRefPlaceHolderSegment, ieaSegmentId))
			$$$ThrowOnError(InterchangeParent.AppendSegment(ieaSegment))
		} Else {
			$$$ThrowOnError(InterchangeParent.AppendSegment(groupDocsRefPlaceHolderSegment))
		}
	}

	Do InterchangeParent.AddChild(groupPlaceHolderIndex, X12FunctionalGroup)

	Return X12FunctionalGroup
}

/// Make and return an X12 Transaction Set Document without SE segment<br>
/// The separators will be taken from the <PARAMETER>GroupParent</PARAMETER>. <br>
/// The Document Category will be taken from <PARAMETER>GroupParent</PARAMETER> unless specified in
/// <PARAMETER>Doctype</PARAMETER> <br>
/// The Document Name will be taken from <PARAMETER>Doctype</PARAMETER><br>
/// The <PARAMETER>Doctype</PARAMETER> may specify just a document name and does not
/// need to include the Document category as that can be taken from the GroupParent. <br>
/// The new document will be set as a batch child of <PARAMETER>GroupParent</PARAMETER><br>
/// If <PARAMETER>ForceNewPlaceHolderInParent</PARAMETER> is true (the default is false) then
/// a new TransactionSetDocsRef place holder segment will be made in the <PARAMETER>GroupParent</PARAMETER><br>
/// If an Error is encountered it will be thrown.<br>
ClassMethod X12NewTransactionSet(GroupParent As EnsLib.EDI.X12.Document, DocType As %String = "", ForceNewPlaceHolderInParent As %Boolean = 0) As EnsLib.EDI.X12.Document [ Final ]
{
	#dim X12TransactionSet = ##class(EnsLib.EDI.X12.Document).%New()

	Set X12TransactionSet.Separators = GroupParent.Separators

	#dim docCategory, docName

	If $Length(DocType,":") < 2 {
		Set docCategory = GroupParent.DocTypeCategory
		Set docName = $Piece(DocType,":")
	} Else {
		Set docCategory = $Piece(DocType,":")
		Set docName = $Piece(DocType,":",2)
	}
	Do X12TransactionSet.PokeDocType(docCategory_":"_docName)

	/* Get parent id - this sets it in target if target not saved yet */
	Set X12TransactionSet.ParentId = GroupParent.getId()

	#dim tDataElementSeparator=$$$ELESEP(X12TransactionSet.Separators)

	/* Find target TransactionSetDocsRef placeholder or create and add TransactionSet */
	#dim transactionSetPlaceHolderIndex = ""
	#dim transactionSetDocsRefPlaceHolderSegment As EnsLib.EDI.X12.Segment = $$$NULLOREF
	If 'ForceNewPlaceHolderInParent {
		Set transactionSetDocsRefPlaceHolderSegment = GroupParent.FindSegment("TransactionSetDocsRef", .transactionSetPlaceHolderIndex)
	}
	/* If creating place holder segment add at end if no GE or else insert before GE */
	If (transactionSetDocsRefPlaceHolderSegment = $$$NULLOREF) {
		#dim geSegmentId
		#dim geSegment = GroupParent.FindSegment("GE",.geSegmentId)
		Set transactionSetDocsRefPlaceHolderSegment=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(GroupParent.Separators,1,3)_"TransactionSetDocsRef"_tDataElementSeparator_2))
		If geSegment '= $$$NULLOREF {
			/* replace ge Segment with place holder then add back ge segment */
			$$$ThrowOnError(GroupParent.SetSegmentAt(transactionSetDocsRefPlaceHolderSegment, geSegmentId))
			Set transactionSetPlaceHolderIndex = GroupParent.SegCount
			$$$ThrowOnError(GroupParent.AppendSegment(geSegment))
		} Else {
			$$$ThrowOnError(GroupParent.AppendSegment(transactionSetDocsRefPlaceHolderSegment))
			Set transactionSetPlaceHolderIndex = GroupParent.SegCount
		}
	}

	Do GroupParent.AddChild(transactionSetPlaceHolderIndex, X12TransactionSet)

	Return X12TransactionSet
}

/// For the <PARAMETER>X12Document</PARAMETER> the appropriate Trailer segment will be
/// created if it does not exist and the count and control fields assigned based
/// on the contents of the <PARAMETER>X12Document</PARAMETER>.<br>
/// If the optional <PARAMETER>Save</PARAMETER> is true (the default is false) then 
/// the <PARAMETER>X12Document</PARAMETER> will be saved. <br>
/// The method returns the empty string allowing the unloading of an object via assignment. <br>
/// If an Error is encountered it will be thrown.<br>
ClassMethod X12CompleteTrailerAndReturnClear(X12Document As EnsLib.EDI.X12.Document, Save As %Boolean = 0) As %String
{
	#dim tDataElementSeparator=$$$ELESEP(X12Document.Separators)
	#dim i

	If "Interchange"=X12Document.Name {

		#dim tNumGroups=X12Document.ChildCount
		#dim ieaSegment = X12Document.FindSegment("IEA")
		If ieaSegment '= $$$NULLOREF {
			/* Ensure the IEA group count and control number correct - requires mutable*/
			If (ieaSegment.IsMutable) {
				$$$ThrowOnError(ieaSegment.SetValueAt(tNumGroups,1))
				$$$ThrowOnError(ieaSegment.SetValueAt(X12Document.GetValueAt("1:13"),2))
			}
		} Else {
			Set tIEA=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(X12Document.Separators,1,3)_"IEA"_tDataElementSeparator_tNumGroups_tDataElementSeparator_X12Document.GetValueAt("1:13")))
			$$$ThrowOnError(X12Document.AppendSegment(tIEA))
		}

	} ElseIf ("Group"=X12Document.Name) {

		#dim tNumSets=X12Document.ChildCount
		#dim geSegment = X12Document.FindSegment("GE")
		If geSegment '= $$$NULLOREF {
			/* Ensure the GE transaction count and control number correct - requires mutable*/
			If (geSegment.IsMutable) {
				$$$ThrowOnError(geSegment.SetValueAt(tNumSets,1))
				$$$ThrowOnError(geSegment.SetValueAt(X12Document.GetValueAt("1:6"),2))
			}
		} Else {
			Set tGE=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(X12Document.Separators,1,3)_"GE"_tDataElementSeparator_tNumSets_tDataElementSeparator_X12Document.GetValueAt("1:6")))
			$$$ThrowOnError(X12Document.AppendSegment(tGE))
		}

	} Else {

		#dim seSegment = X12Document.FindSegment("SE")
		If seSegment '= $$$NULLOREF {
			/* Ensure SE segment count and control number correct - requires segment to be mutable*/
			If (seSegment.IsMutable) {
				$$$ThrowOnError(seSegment.SetValueAt((X12Document.SegCount),1))
				$$$ThrowOnError(seSegment.SetValueAt(X12Document.GetValueAt("1:2"),2))
			}
		} Else {
			Set tSE=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(X12Document.Separators,1,3)_"SE"_tDataElementSeparator_(X12Document.SegCount+1)_tDataElementSeparator_X12Document.GetValueAt("1:2")))
			$$$ThrowOnError(X12Document.AppendSegment(tSE))
		}
	}

	If Save $$$ThrowOnError(X12Document.%Save())

	Return $$$NULLOREF
}

/// The <PARAMETER>X12Document</PARAMETER> will be saved<br>
/// The method returns the empty string allowing the unloading of an object via assignment. <br>
/// If an Error is encountered it will be thrown.<br>
ClassMethod X12SaveDocumentAndReturnClear(X12Document As EnsLib.EDI.X12.Document) As %String
{
	$$$ThrowOnError(X12Document.%Save())
	Return $$$NULLOREF
}

}
