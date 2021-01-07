/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Annotation.ExportServer Extends %CSP.Page [ System = 4 ]
{

Parameter SECURITYRESOURCE = "%Ens_EDISchemaAnnotations:READ";

ClassMethod OnPage() As %Status
{
	Set version=$G(%request.Data("version",1),"2.5")
	Write "<?xml version=""1.0"" ?>",!
	DO ##Class(EnsLib.HL7.Annotation.Data).GetExportXML(version,.xml)
	FOR i=1:1:xml { Write xml(i),! }
	Quit $$$OK
}

Parameter CONTENTTYPE = "text/xml";

}
