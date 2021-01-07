ROUTINE EnsEDIASTM [Type=INC]
#; EnsEDIASTM.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#;
#include EnsEDI

#; ASTM E1394 special TCP control character codes 
#define STX             $C(2)
#define ETX             $C(3)
#define EOT             $C(4)
#define ENQ             $C(5)
#define ACK             $C(6)
#define ETB             $C(23)

#define MapCtlChar(%c)  $Case(%c,$$$STX:"<STX>",$$$ETX:"<ETX>",$$$EOT:"<EOT>",$$$ENQ:"<ENQ>",$$$ACK:"<ACK>",$$$ETB:"<ETB>",$C(13):"<CR>",$C(10):"<LF>",:"<"_$A(%c)_">")
#define MapCtlChars(%s) ##class(EnsLib.EDI.ASTM.Parser).mapCtlChars(%s)
 
#; LVD array macros
#define vaSchemaGbl       ^EnsEDI.ASTM.Schema
#define vaSchemaDescGbl   ^EnsEDI.ASTM.Description
#define vaSegmentGbl      ^EnsEDI.ASTM.Segment
#define vaExtentGbl       ^EnsLib.EDI.ASTM.DocumentD
#define vaOpenSegmentPPG  ^||EnsEDI.ASTM.OpenSegment
#; Note: SchemaGbl macros are defined in EnsEDISEF
 
#ifndef LOCALMAPS
#define vaTempInstanceGbl ^IRIS.Temp.EnsEDI.ASTM
#endif
#;
#; 22 = Name MAXLEN
#define MAXSEGNAME 22
#define vaDataSegName(%segdata)        $P($E(%segdata,5,5+22-1),$$$FLDSEP(%segdata))
#define vaDataTypeName(%segdata)       $$$vaDataSegName(%segdata)_$S("M"=$$$vaDataSegName(%segdata):"-"_$$$SEGELEM(%segdata,2),1:"")
#define vaDataTypeVersion(%segdata)    $$$SEGELEM(%segdata,12)
#define vaDataDocIdentifier(%segdata)  $$$SEGELEM(%segdata,2)
 
#; return an 8 bit checksum value in 2 ascii hex chars
#define CHKSUM(%s)                $$$NUM($ZHex(+($ZCRC(%s,0)#256)),2)
 
#define FLDSEP(%s)                $E(%s,1)
#define REPSEP(%s)                $E(%s,2)
#define COMSEP(%s)                $E(%s,3)
#define ESCSEP(%s)                $E(%s,4)
 
#; Default Separator values
#define ASTMDefFS  "|"
#define ASTMDefRS "\"
#define ASTMDefCS "^"
#define ASTMDefESC "&"
#define ASTMDefSeparators  $$$ASTMDefFS_$$$ASTMDefRS_$$$ASTMDefCS_$$$ASTMDefESC
 
 
#; Get stuff directly out of segment global
#define SEGELEM(%seg,%el)         $P(%seg,$$$FLDSEP(%seg),2+%el)
#define SEGIDELEM(%id,%el)        $$$SEGELEM($G($$$vaSegmentGbl(+%id)),%el)
#define SEGIDNAME(%id)            $$$SEGIDELEM(%id,0)
 
#; Enable all validation levels
#define ValidationFull            2
 