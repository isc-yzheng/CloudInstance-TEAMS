ROUTINE EnsAgent [Type=INC]
#; EnsAgent.inc
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#; Skorp_Agent status codes
#define SkorpStatusSAStartError   1
#define SkorpStatusSATerminated  10

#; TCP_Listen status codes
#define SkorpStatusTLStarted    100
#define SkorpStatusTLStopped    101
#define SkorpStatusTLConnEvent  102
#define SkorpStatusTLConnLost   103
#define SkorpStatusTLConnClosed 104
#define SkorpStatusTLStartError 105

#; TCP_Connect status codes
#define SkorpStatusTCStarted    200
#define SkorpStatusTCStopped    201
#define SkorpStatusTCConnOpened 202
#define SkorpStatusTCConnLost   203
#define SkorpStatusTCConnClosed 204
#define SkorpStatusTCConnError  205
#define SkorpStatusTCDataSendOK 206

#; File_Pick status codes
#define SkorpStatusFPStarted    300
#define SkorpStatusFPStopped    301
#define SkorpStatusFPStartError 302
#define SkorpEStatusFPAcceptOK 1300
#define SkorpEStatusFPAcceptFailed 1301

#; File_Drop status codes
#define SkorpStatusFDStarted    400
#define SkorpStatusFDStopped    401
#define SkorpStatusFDStartError 402
#define SkorpStatusFDSuccess    410
#define SkorpStatusFDError      411
