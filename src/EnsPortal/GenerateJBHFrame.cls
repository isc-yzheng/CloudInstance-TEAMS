/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsJBH)

Class EnsPortal.GenerateJBHFrame Extends EnsPortal.Template.standardPage [ System = 4 ]
{

Parameter DOMAIN = "Ensemble";

Parameter PRIVATE = 1;

/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
	Set tJarFile = $get(%request.Data("JARFILE",1))
	Set tJavaClass = $get(%request.Data("JAVACLASS",1))
	Set tCOSName = $get(%request.Data("COSNAME",1))
	Set tFormat = $get(%request.Data("FORMAT",1))
	Set tCredentials = $get(%request.Data("CREDENTIALS",1))

	Set tPermitted = ..CheckPermissions()
	&html<<html>
<head>
<style type="text/css">
body {
	font-family: "courier new";
	font-size: 0.8em;
}
.compilerOutput {
	background: white;
	margin: 0px;
	padding: 4px;
	white-space: pre-wrap;
}
	
</style>
<body>>
	If 'tPermitted {
		&html<<span class="notPermittedErr">#($$$TextHTML("You are not permitted to perform this action.")_"&nbsp;"_$$$TextHTML("Contact your system administrator for access."))#</span>>
	}
	Else {
			&html<<div class="compilerOutput">>
			Set tSC = ..GenerateBusinessHost(tJarFile,tJavaClass,tCOSName,tFormat,tCredentials)
			Write !
			
			Write ..%StartScript()
			
			If $$$ISERR(tSC) {
				&js<
				setTimeout(function() {
					try {
						parent.document.getElementById('msgFailed').hidden = false;
						parent.document.getElementById('msgWait').hidden = true;
						parent.document.getElementById('btnOK').getElementsByTagName('input')[0].focus();
						
					} catch (err) {}
				}, 100); 
				>
			} Else {
				&js<
				setTimeout(function() {
					try {
						parent.document.getElementById('msgSuccess').hidden = false;
						parent.document.getElementById('msgWait').hidden = true;
						parent.document.getElementById('btnOK').getElementsByTagName('input')[0].focus();
						
					} catch (err) {}
				}, 100); 
				>
			}
			Write ..%EndScript()
			&html<</div>>
	}
	&html<</body>>
	Quit $$$OK
}

/// Generates a subclass of the 'tSuperClass' and then augments it with configuration settings
/// found in the specified Java service
ClassMethod GenerateBusinessHost(pJarFile As %String, pJavaClass As %String, pCOSName As %String, pFormat As %String, pCredentials As %String) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK

	Try {
	
		// check that user provided a valid class name
		If '$ZNAME(pCOSName,4) {
			Set tSC = $$$ERROR($$$ClassNameInvalid, pCOSName)
			Quit
		}

		// find an EnsLib.JavaGateway.Service
		#dim tGatewayConfigItem As Ens.Config.Item
		Set tSC = ##class(Ens.Java.Utils).FindConfigItem("EnsLib.JavaGateway.Service", .tGatewayConfigItem)
		Quit:$$$ISERR(tSC)
		#dim tGatewayConfigName As %String
		Set tGatewayConfigName = tGatewayConfigItem.Name
		
		// get Address
		#dim tAddress As %String = ""
		Set tSC = ##class(Ens.Java.Utils).GetSetting(tGatewayConfigName, "Address", .tAddress)
		Quit:$$$ISERR(tSC)
		
		// get Port
		#dim tPort As %String = ""
		Set tSC = ##class(Ens.Java.Utils).GetSetting(tGatewayConfigName, "Port", .tPort)
		Quit:$$$ISERR(tSC)
		
		// get JavaGateway
		#dim tEndpoint As %String = tAddress_";"_tPort_";"_$NAMESPACE
		#dim tJavaGateway As EnsLib.JavaGateway.JavaGateway
		Set tSC = ##class(EnsLib.JavaGateway.Service).ConnectGateway(tEndpoint, .tJavaGateway)
		Quit:$$$ISERR(tSC)

		// import custom implementations of Java Business Hosts
		// (expressly to look for settings candidates)
		//
		// verify JAR file exists
		Set tSC = ##class(Ens.Java.Utils).ValidateJar(tJavaGateway, pJarFile, pJavaClass)
		Quit:$$$ISERR(tSC)
		
		// add JAR file to class path
		#dim tClassPaths As %ListOfDataTypes = ##class(%ListOfDataTypes).%New()
		Set:$$$ISOK(tSC) tSC = tClassPaths.Insert(pJarFile)
		Quit:$$$ISERR(tSC)
		
		Set tSC = tJavaGateway.%AddToCurrentClassPath(tClassPaths)
		Quit:$$$ISERR(tSC)

		// do the import
		Write $$$FormatText($$$Text("Importing Java class '%1' from jar file '%2'"),pJavaClass,pJarFile), !
		Set tSC = tJavaGateway.%Import(pJavaClass, .tJavaClasses,,,1)
		Quit:$$$ISERR(tSC)
		
		// make sure to use correct proxy class name going forward
		Set tJavaClass = $Translate(pJavaClass,"_$","ud")  // first start with translating as in TypeMap.getCacheClassName()
		Set tJavaClass = $$$NormalizeClassname(tJavaClass) // then add package name if in default package
		If '##class(%Dictionary.ClassDefinition).%ExistsId(tJavaClass) {
			Set tSC = $$$ERROR($$$EnsErrGeneral,$$$FormatText("Unknown error on import of java class.  Proxy class '%1' not found."),tJavaClass)
			Quit
		}
		
		#dim tSuperClass,tDescription As %String
		If $$$IsJavaBS(tJavaClass) {
			Set tSuperClass = $$$JBHBS(pFormat)
			Set tDescription = $$$FormatText($$$Text("Java Business Service which runs Java class %1"),pJavaClass)
		} ElseIf $$$IsJavaBO(tJavaClass) {
			Set tSuperClass = $$$JBHBO
			Set tDescription = $$$FormatText($$$Text("Java Business Operation which runs Java class %1"),pJavaClass)
		} Else {
			Set tSC = $$$ERROR($$$EnsErrGeneral,$$$FormatText("Java class to import must implement either '%1' or '%2'",$$$JavaBS,$$$JavaBO))
			Quit
		}
		
		Write !,$$$FormatText($$$Text("Generating Business Host '%1' from Java class '%2'"),pCOSName,pJavaClass), !
		
		// create subclass of the ObjectScript Business Host
		#dim tCOSClass As %Dictionary.ClassDefinition = ##class(%Dictionary.ClassDefinition).%New()
		Set tCOSClass.Name = pCOSName
		Set tCOSClass.Super = tSuperClass
		Set tCOSClass.GeneratedBy = $CLASSNAME()
		Set tCOSClass.ClassVersion = 25
		Set tCOSClass.Description = tDescription
		
		// from here on out we use tCOSClass.Name instead of pCOSName because
		// %Dictionary.ClassDefinition may have altered it (e.g. prepended "User.")
			
		// add JavaClass parameter
		#dim tJavaClassParam As %Dictionary.ParameterDefinition = ##class(%Dictionary.ParameterDefinition).%New()
		Set tJavaClassParam.Name = "JavaClass"
		Set tJavaClassParam.Default = tJavaClass
		Do tCOSClass.Parameters.Insert(tJavaClassParam)
		
		// add JarFile property
		#dim tJarFile As %Dictionary.PropertyDefinition
		Set tJarFile = ##class(%Dictionary.PropertyDefinition).%New()
		Set tJarFile.Name = "JarFile"
		Set tJarFile.Type = "%String"
		Set tSC = tJarFile.Parameters.SetAt(255, "MAXLEN")
		Quit:$$$ISERR(tSC)
		Set tJarFile.InitialExpression = ##class(%ZEN.Auxiliary.abstractController).%QuoteValue(pJarFile)
		Set tJarFile.Description = $Select($$$IsJavaBS(tJavaClass):$$$Text("Path to JAR file containing Java-side implementation of this Business Service"),1:$$$Text("Path to JAR file containing Java-side implementation of this Business Operation"))
		Set tSC = tCOSClass.Properties.Insert(tJarFile)
		Quit:$$$ISERR(tSC)
		
		// add credentials property
		If (pCredentials '= "") {
			#dim tCredentials = ##class(%Dictionary.PropertyDefinition).%New()
			Set tCredentials.Name = "Credentials"
			Set tCredentials.Type = "%String"
			Set tCredentials.InitialExpression = ##class(%ZEN.Auxiliary.abstractController).%QuoteValue(pCredentials)
			Set tCredentials.Description = $$$Text("Credentials for Java to use when authenticating with IRIS")
			Set tSC = tCOSClass.Properties.Insert(tCredentials)
			Quit:$$$ISERR(tSC)
		}
		
		If $classmethod(tSuperClass,"%Extends",$$$JBHBOSuperClass) {
			#dim tPortProp As %Dictionary.PropertyDefinition
			Set tPortProp = ##class(%Dictionary.PropertyDefinition).%New()
			Set tPortProp.Name = "Port"
			Set tPortProp.Type = "%String"
			Set tPortProp.InitialExpression = ##class(%ZEN.Auxiliary.abstractController).%QuoteValue(tPort)
			Set tPortProp.Description = $$$Text("TCP port number for communication between the Java Gateway Server and the proxy classes in IRIS.")
			Set tSC = tCOSClass.Properties.Insert(tPortProp)
			Quit:$$$ISERR(tSC)
			
			#dim tAddressProp As %Dictionary.PropertyDefinition
			Set tAddressProp = ##class(%Dictionary.PropertyDefinition).%New()
			Set tAddressProp.Name = "Address"
			Set tAddressProp.Type = "%String"
			Set tAddressProp.InitialExpression = ##class(%ZEN.Auxiliary.abstractController).%QuoteValue(tAddress)
			Set tAddressProp.Description = $$$Text("IP address or name of the machine where the Java Gateway Server is located.")
			Set tSC = tCOSClass.Properties.Insert(tAddressProp)
			Quit:$$$ISERR(tSC)
			
			#dim tGatewayProp As %Dictionary.PropertyDefinition
			Set tGatewayProp = ##class(%Dictionary.PropertyDefinition).%New()
			Set tGatewayProp.Name = "JavaGatewayService"
			Set tGatewayProp.Type = "%String"
			Set tGatewayProp.InitialExpression = ##class(%ZEN.Auxiliary.abstractController).%QuoteValue(tGatewayConfigName)
			Set tGatewayProp.Description = $$$Text("Name of the Config Item for the Java Gateway Server.  If specified, the Address and Port of the selected Java Gateway Server override any values entered in the Address and Port settings.")
			Set tSC = tCOSClass.Properties.Insert(tGatewayProp)
		} Else {
			If (tGatewayConfigItem.ClassName="EnsLib.JavaGateway.Initiator"){
				#dim tInitiator = ##class(%Dictionary.PropertyDefinition).%New()
				Set tInitiator.Name = "InitiatorService"
				Set tInitiator.Type = "%String"
				Set tInitiator.InitialExpression = ##class(%ZEN.Auxiliary.abstractController).%QuoteValue(tGatewayConfigName)
				Set tInitiator.Description = $$$Text("Config Name of the EnsLib.JavaGateway.Initiator Service with which this Service connects")
				Set tSC = tCOSClass.Properties.Insert(tInitiator)
				Quit:$$$ISERR(tSC)
			}
			
		}
		
		// if we found settings candidates, add them here
		#dim tSettings As %String = $PARAMETER(tJavaClass, "SETTINGS")
		If tSettings '= "" {
		
	 		// add SETTINGS parameter
			#dim tParam As %Dictionary.ParameterDefinition = ##class(%Dictionary.ParameterDefinition).%New()
			Set tParam.Name = "SETTINGS"
			Set tParam.Default = tSettings
			Set tSC = tCOSClass.Parameters.Insert(tParam)
			Quit:$$$ISERR(tSC)
			
			// add a property for each member of SETTINGS
			For i = 1:1:$LENGTH(tSettings, ",") {
				#dim tSetting As %String = $PIECE($zstrip($PIECE(tSettings, ",", i),"<>W"),":")
				// check that user provided a valid property name
				If '$ZNAME(tSetting,6) {
					Set tSC = $$$ERROR($$$PropertyNameInvalid, tSetting)
					Quit
				}

				#dim tProp As %Dictionary.PropertyDefinition
				Set tProp = ##class(%Dictionary.PropertyDefinition).%New()
				Set tProp.Name = tSetting
				Set tProp.Type = "%String"
				Set tSC = tProp.Parameters.SetAt(255, "MAXLEN")
				Quit:$$$ISERR(tSC)
				Set tProp.Description = $$$FormatText($$$Text("%1 property used by the Java class"),tSetting)	
				Set tSC = tCOSClass.Properties.Insert(tProp)
				Quit:$$$ISERR(tSC)
			}
			Quit:$$$ISERR(tSC)
		}
		
		// can't save without deleting first
		If ##class(%Dictionary.ClassDefinition).%ExistsId(tCOSClass.Name) {
			
			// make sure we're deleting a class we previously generated
			#dim tExisting As %Dictionary.ClassDefinition
			Set tExisting = ##class(%Dictionary.ClassDefinition).%OpenId(tCOSClass.Name)
			If '$ISOBJECT(tExisting) {
				Set tSC = $$$ERROR($$$GeneralError, "Unable to find/open class "_tCOSClass.Name)
				Quit
			}
						
			If '(tCOSClass.Super=tExisting.Super)||'(tCOSClass.GeneratedBy=tExisting.GeneratedBy) {
				Set tSC = $$$ERROR($$$GeneralError, "Class "_tCOSClass.Name_" already exists; choose another name")
				Quit
			}

			Set tSC = tCOSClass.%DeleteId(tCOSClass.Name)
			Quit:$$$ISERR(tSC)
		}

		// save and compile
		Set tSC = tCOSClass.%Save()
		Quit:$$$ISERR(tSC)
		
		// HTML Escape the output from $System.OBJ.Load()
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		Set tSC = $System.OBJ.Compile(tCOSClass.Name)
		Kill EscapeObj // disable HTML Escaping
		Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = $$$SystemError
	}
	
	If $$$ISERR(tSC) {
		Write !, $zconvert($System.Status.GetErrorText(tSC),"O","HTML"), !
	}

	Quit tSC
}

ClassMethod CheckPermissions() As %Boolean
{
	Quit $system.Security.Check("%Ens_Code", "WRITE")||$system.Security.Check("%Ens_JBH","WRITE")
}

}
