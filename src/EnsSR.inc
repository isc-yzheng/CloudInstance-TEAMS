ROUTINE EnsSR [Type=INC]
#; Settings Report macros & errors
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#Include EnsSRErrors
#;
#;	Report location by setting
#def1arg EnsSRCentralNamespaceRoot(%args)			^%SYS("Ensemble","SettingsReport",%args)
#define EnsGetSRCentralNamespace			$Get($$$EnsSRCentralNamespaceRoot($Classname()))
#define EnsSetSRCentralNamespace(%nsp)		Set ($$$EnsSRCentralNamespaceRoot($Classname())) = %nsp
#define EnsClearSRCentralNamespace			ZKill $$$EnsSRCentralNamespaceRoot($Classname())
#define EnsGetSRWebServer			$Get($$$EnsSRCentralNamespaceRoot($Classname(),"WebServer"))
#define EnsSetSRWebServer(%val)		Set $$$EnsSRCentralNamespaceRoot($Classname(),"WebServer") = %val
#define EnsGetSRWebPort			$Get($$$EnsSRCentralNamespaceRoot($Classname(),"WebPort"))
#define EnsSetSRWebPort(%val)		Set $$$EnsSRCentralNamespaceRoot($Classname(),"WebPort") = %val
#define EnsGetSRWebPath			$Get($$$EnsSRCentralNamespaceRoot($Classname(),"WebPath"))
#define EnsSetSRWebPath(%val)		Set $$$EnsSRCentralNamespaceRoot($Classname(),"WebPath") = %val
#define EnsGetSRWebSSL			$Get($$$EnsSRCentralNamespaceRoot($Classname(),"WebSSL",1))
#define EnsSetSRWebSSL(%val)		Set $$$EnsSRCentralNamespaceRoot($Classname(),"WebSSL") = ++%val
#;	Protection for all settings
#define EnsSRCentralNamespaceConfigResource		"%Ens_SettingsReportConfig"
#define EnsSRCentralNamespaceAccessResource		"%Ens_PortSettingsReport"
#define	EnsAllowedSRCentralNamepaceConfig(%priv)	$system.Security.Check($$$EnsSRCentralNamespaceConfigResource,%priv)
#define	EnsAllowedSRCentralNamepaceAccess(%priv)	$system.Security.Check($$$EnsSRCentralNamespaceAccessResource,%priv)