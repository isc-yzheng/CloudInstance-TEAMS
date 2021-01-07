ROUTINE EnsRecordMap [Type=INC]
#Include Ensemble
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#Define RecordMapGenerated			"RECORDMAPGENERATED"

#; Locations for BatchOperation data
#Define RMBatchCount(%batchClass,%batchId)		$$$EnsStaticAppData(..%ConfigName,"BatchCount",%batchClass,%batchId)
#Define RMBatchTempFile(%batchClass,%batchId)	$$$EnsStaticAppData(..%ConfigName,"TempFile",%batchClass,%batchId)
#Define RMBatchWritten(%batchClass,%batchId)	$$$EnsStaticAppData(..%ConfigName,"BatchWritten",%batchClass,%batchId)
#Define RMDefaultBatch							$$$EnsStaticAppData(..%ConfigName,"DefaultBatch")
#Define RMNextRollover							$$$EnsStaticAppData(..%ConfigName,"DefaultBatch","NextRollover")
#Def1arg RMBatchPutError(%args)					$$$EnsStaticAppData(..%ConfigName,"Errored",%args)

#Define EnsRecordMapComplexBatchTemp		^||%ISC.Ens.ComplexBatchTemp

#Include EnsRecordMapErrors