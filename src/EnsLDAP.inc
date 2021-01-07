ROUTINE EnsLDAP [Type=INC]
#Include EnsLDAPErrors
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.

#; Corresponds to Ens.DataType.LDAP.StatusCategory
#define EnsLDAPStatusSuccess		0
#define EnsLDAPStatusReferral		1
#define EnsLDAPStatusAuthorization	2
#define EnsLDAPStatusUnavailable	4
#define EnsLDAPStatusOperation		8
#define EnsLDAPStatusSystem			16
#define EnsLDAPStatusUnknown		32

#define EnsLDAPCategoryandStatus(%arg1)	##class(EnsLib.LDAP.Util.General).getCategoryandEnsStatusFromLDAP(%arg1)
#define EnsLDAPCategory(%arg)			$LG(%arg,1,$$$EnsLDAPStatusUnknown)
#define EnsLDAPEnsStatus(%arg)			$LG(%arg,2,$$$EnsLDAPErrGeneral)

#define EnsLDAPStatusGBL			^||ISC.Ens.LDAPStatus