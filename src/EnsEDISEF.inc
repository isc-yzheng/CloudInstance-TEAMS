ROUTINE EnsEDISEF [Type=INC]
#;EnsEDISEF.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#include EnsEDI
#include EnsEDISEFErrors
 
#; Standards
#define GENDOD      "GC"
#define TDCC        "T"
#define TRADACOMS   "TD"
#define UNEDIFACT   "UN"
#define ASCX12      "X"
 
#; SEF definitions
#;
#define StateStopped 0
#define StateRunning 1
#;
#define DeleteCode	 0
#define CreateCode   1
#; 
#; Tokens
#define tokUNKN     0
#define tokBOFL     1
#define tokEOFL     2
#define tokEOS      3
#define tokNEWLN    4
#define tokSPACE    5
#define tokRETURN   6
#define tokFORMFD   7
#define tokLETTER   8
#define tokDIGIT    9
#define tokDOT      10
#define tokARROW    11
#define tokATSIGN   12
#define tokDQUOTE   13
#define tokLPARN    14
#define tokDOLLAR   15
#define tokPERCENT  16
#define tokSQUOTE   17
#define tokMINUS    18
#define tokPLUS     19
#define tokRPARN    20
#define tokCOMMA    21
#define tokCRLF     22
#define tokSEMI     23
#define tokASTER    24
#define tokSLASH    25
#define tokPOUND    26
#define tokBSLASH   27
#define tokUSCORE   28
#define tokEQUAL    29
#define tokLESS     30
#define tokGREAT    31
#define tokLBRACK   32
#define tokRBRACK   33
#define tokAMPER    34
#define tokEXCLA    35
#define tokQUEST    36
#define tokCOLON    37
#define tokVBAR     38
#define tokLBRACE   39
#define tokRBRACE   40
#define tokBQUOTE   41
#define tokTILDE    42
#define tokTAB      43
 
#; Validation constants
#define StdSetRequirement  "|M|O|F|C|"
#define StdSegRequirement  "|M|O|X|C|"
#define UsrRequirement     "|.|!|$|-|&|"
#define MaskType           "|.|#|@|$|-|&|+|"
 
 