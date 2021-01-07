ROUTINE EnsCompiler [Type=INC]
#; Definitions for the BPL/DTL compilers
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#define  GC(%c)	Do pCompiler.CurrentMethod.Implementation.WriteLine(%c)
#define  PC(%c) Do pCompiler.Implementation.WriteLine(%c)
#define  EA(%c) ..NormalizeAttribute(%c)
#define  PCIndent(%i,%c) $$$PC(%i_%c)
 
#define  Push(%state,%stack) Set %stack=%stack_$ListBuild(%state)
#define  Pop(%stack)         Set %stack=$List(%stack,1,$ListLength(%stack)-1)
#define  Top(%stack)         $ListGet(%stack,$ListLength(%stack))
 
#if 0 // Reserved for future use
#define EnterActivity(%act,%sub) If pCompiler.Language=$$$objectscript { ##continue
			$$$GC(" Do ..EnterActivity(%act,%sub,"_..ActivityID_") // "_..activityName()) ##continue
		} else { ##continue
			$$$GC(" Me.EnterActivity(%act,%sub,"_..ActivityID_") ' "_..activityName()) ##continue
		} 
 
#define LeaveActivity(%act,%sub) If pCompiler.Language=$$$objectscript { ##continue
			$$$GC(" Do ..LeaveActivity(%act,%sub,"_..ActivityID_") // "_..activityName()) ##continue
		} else { ##continue
			$$$GC(" Me.LeaveActivity(%act,%sub,"_..ActivityID_") ' "_..activityName()) ##continue
		}
#else
#define EnterActivity(%acct,%sub)
#define LeaveActivity(%acct,%sub)
#endif
	
#; Activities
#define ActivityNone                000
#define ActivityAlert               010
#define ActivityAssign              020
#define ActivityBranch				030
#define	ActivityBreak               040
#define ActivityCall                050
#define ActivityCatch               060
#define ActivityCatchAll            070
#define ActivityCode                080
#define ActivityCompensate          090
#define ActivityCompensationHandler 100
#define ActivityContinue            110
#define ActivityDelay               120
#define ActivityEmpty               130
#define ActivityFlow                140
#define ActivityForEach             150
#define ActivityIf                  160
#define ActivityLabel               170
#define ActivityMilestone			175
#define ActivityReceive             180
#define ActivityReply               190
#define ActivityRule                200
#define ActivitySQL                 210
#define ActivityScope               220
#define ActivitySequence            230
#define ActivitySwitch              240
#define ActivitySync                250
#define ActivityThrow               260
#define ActivityTrace               270
#define ActivityTransform           280
#define ActivityUntil               290
#define ActivityWhile               300
#define ActivityXSLT				310
#define ActivityXPATH				320
 
#; Sub Activities
#define SubActivityMain             1
#define SubActivityCondition        2
#define SubActivityBody             3
#define SubActivityTrueBranch       4
#define SubActivityFalseBranch      5