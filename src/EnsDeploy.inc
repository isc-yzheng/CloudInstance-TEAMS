ROUTINE EnsDeploy [Type=INC]
#Include Ensemble
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#; Deployment logging
#define DeployLog ^IRIS.Temp.EnsDeployment
#define SetDeployLogWhere(%val) Set $$$DeployLog("Log",$Job,"Where")=%val
#define SetDeployLogFile(%val) Set $$$DeployLog("Log",$Job,"File")=%val
#define ClearDeployLog Kill $$$DeployLog("Log",$Job)
#def1arg OutputDeployLog(%args) Set:($$$GetDeployLogWhere'="") tSCW = ##class(Ens.Deployment.Utils).WriteDeployLog(%args)
#define GetDeployLogFile $G($$$DeployLog("Log",$Job,"File"))
#define GetDeployLogWhere $G($$$DeployLog("Log",$Job,"Where"))
