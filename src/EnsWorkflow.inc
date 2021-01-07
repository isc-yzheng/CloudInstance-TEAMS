ROUTINE EnsWorkflow [Type=INC]
#include EnsWfErrors
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
 
#; Task Status codes
#define WfTaskAssigned				"Assigned"
#define WfTaskUnassigned			"Unassigned"
#define WfTaskCompleted				"Completed"
#define WfTaskCancelled				"Cancelled"
#define WfTaskDiscarded				"Discarded"
 
#; Task OnRoleChange Reasons
#define WfRoleDeleted				"RoleDeleted"
#define WfUserDeleted				"UserDeleted"
#define WfUserInactivated			"UserInactivated"
#define WfUserActivated				"UserActivated"
#define WfUserAddedToRole			"UserAddedToRole"
#define WfUserRemovedFromRole		"UserRemovedFromRole"