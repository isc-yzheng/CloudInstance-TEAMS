ROUTINE EnsJBH [Type=INC]
#define JBHBSSuperClass			"Ens.Java.Service.Standard"
	; Copyright (c) 2020 by InterSystems Corporation.
	; Cambridge, Massachusetts, U.S.A.  All rights reserved.
	; Confidential property of InterSystems Corporation.
#define JBHBOSuperClass			"Ens.Java.Operation.Standard"
#define JBHBO					"Ens.Java.Operation.PassthroughOperation"
#define JBHBS(%protocol)		$Case(%protocol,"XML":"EnsLib.EDI.XML.Service.JavaService","HL7":"EnsLib.HL7.Service.JavaService","X12":"EnsLib.EDI.X12.Service.JavaService","ASTM":"EnsLib.EDI.ASTM.Service.JavaService","EDIFACT":"EnsLib.EDI.EDIFACT.Service.JavaService",:"Ens.Java.Service.PassthroughService")

#define JavaJBHPackage			"com.intersystems.gateway.bh"
#define JavaBS					($$$JavaJBHPackage_".BusinessService")
#define JavaBO					($$$JavaJBHPackage_".BusinessOperation")

#define COSNamePrefix			"JBH"

#define IsJavaBS(%cls)			##class(%Dictionary.ClassDefinition).%ExistsId(%cls)&&$classmethod(%cls,"%Extends",$$$JavaBS)
#define IsJavaBO(%cls)			##class(%Dictionary.ClassDefinition).%ExistsId(%cls)&&$classmethod(%cls,"%Extends",$$$JavaBO)