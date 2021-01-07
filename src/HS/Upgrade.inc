ROUTINE HS.Upgrade [Type=INC]
	#include EnsUtil

	#Define LayoutVersion(%DB) ^[%DB]HS.Layout("CurrentVersion")
	#Define LayoutVersionStep(%Version,%Step) ^HS.Layout("LayoutVersionSteps",%Version##function($s("%Step"="*":"",1:",%Step"))##lit()) 
	#Define HSCoreVersion ##Class(HS.Util.Installer.Upgrade.Loader).GetCurrentVersion("HSLIB",1)
	#;
	#Define ProductCurrentVersion(%Product,%DB) ^[%DB]HS.Upgrade("Product",%Product,"CurrentVersion")
	#Define ProductVersion(%Product,%DB,%Version) ^[%DB]HS.Upgrade("Product",%Product,"UpgradeVersionSteps",%Version) 
	#Define ProductVersionStep(%Product,%DB,%Version,%Step) ^[%DB]HS.Upgrade("Product",%Product,"UpgradeVersionSteps",%Version##function($s("%Step"="*":"",1:",%Step"))##lit()) 
	#Define OnStartStep(%class,%method) Set ^HS.Upgrade("OnStart",$i(^HS.Upgrade("OnStart")))=$lb(%class,%method)
	