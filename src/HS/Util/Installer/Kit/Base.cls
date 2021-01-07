Include HS.HC

Class HS.Util.Installer.Kit.Base Extends %RegisteredObject
{

/// The namespace types this kit is valid for (value of ^%SYS("HealthShare","Instances",pNS,"Type"))
/// The UI can use this parameter to determine what options are available for a namespace
/// When creating utility methods create AddHub, AddAccessGateway, AddEdgeGateway, AddBus
Parameter NamespaceTypes As %String;

/// find the first production which starts out with this namespace name
ClassMethod GetProduction(Output pProdRef As Ens.Config.Production, pProductionClass = "") As %Status
{
	Try {
		Set tSC=$$$OK
		Set:pProductionClass="" pProductionClass = ##class(HS.Util.Installer.ConfigItem).ProductionGetStored($namespace)
		If pProductionClass="" {
			Set tRS=##class(%ResultSet).%New("%Library.ClassDefinition:SubclassOf")     
			Set tSC=tRS.Execute("HS.Util.AbstractProduction")
			Quit:$$$ISERR(tSC)
			While tRS.%Next() {
				Set tItem=tRS.Get("Name")
				If $p(tItem,".")=$Namespace Set pProductionClass=tItem Quit
				If $p(tItem,".")=($Namespace_"PKG") Set pProductionClass=tItem Quit
			}
			If pProductionClass="" Do ##class(Ens.Director).ParseConfigItemName("",.pProductionClass)
		}
		If pProductionClass="" Set tSC=$$$ERROR($$$GeneralError,"Production Item not found") Quit
		Set pProdRef=##class(Ens.Config.Production).%OpenId(pProductionClass)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod ProductionMods(pNS As %String = {$namespace}, pItems As %String = "", pUpdate As %Boolean = 0, pProductionClass = "", pAddItemsString = "") As %Status
{
	try {
		Set tSC=$$$OK
		Set tWhere = $Namespace Set:pNS]"" $Namespace=pNS
		Set tSC=..GetProduction(.tProdRef,pProductionClass) Quit:$$$ISERR(tSC)
		If pAddItemsString="" {
			Set tSC	= ..getStream(pItems, .tProduction) Quit:$$$ISERR(tSC)
		} Else {
			Set tProduction = ##class(%Stream.GlobalCharacter).%New()
			Do tProduction.Write("<Items>"_pAddItemsString_"</Items>"),tProduction.Rewind()
		}
		set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tProduction,.tObject) Quit:$$$ISERR(tSC)
		Do tReader.Correlate("Item","Ens.Config.Item")
		While tReader.Next(.tItem, .tSC) {
			Set tSC=..AddUpdateConfigItem(tItem,tProdRef,pUpdate) 
			Quit:$$$ISERR(tSC)
		}
		Set tSC=##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProdRef)
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace=tWhere
	Quit tSC
}

ClassMethod RemoveProductionItems(pNS As %String = "", pItems As %String = "") As %Status
{
	try {
		Set tSC=$$$OK
		Set tWhere = $Namespace Set:pNS]"" $Namespace=pNS
		Set tSC=..GetProduction(.tProdRef) Quit:$$$ISERR(tSC)
		Set tSC	= ..getStream(pItems, .tProduction) Quit:$$$ISERR(tSC)
		set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tProduction,.tObject) Quit:$$$ISERR(tSC)
		Do tReader.Correlate("Item","Ens.Config.Item")
		While tReader.Next(.tItem, .tSC) {
			Set tSC=..RemoveConfigItem(tItem,tProdRef) 
			Quit:$$$ISERR(tSC)
		}
		Set tSC=tProdRef.%Save()
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace=tWhere
	Quit tSC
}

ClassMethod AddTraceAll(pSetting = "*FULL*") As %Status
{
	try {
		Set tSC=$$$OK
		Set tNS = ""
		For  {
			Set tNS=$o(^%SYS("HealthShare","Instances",tNS)) Quit:tNS=""
			Set tSC = ..AddTrace(tNS,pSetting) Quit:$$$ISERR(tSC)
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AddTrace(pNS As %String = "", pSetting = "*FULL*") As %Status
{
	try {
		Set tSC=$$$OK
		If pNS="" Set tSC=$$$ERROR($$$GeneralError,"Namespace not defined")
		Set tWhere = $Namespace Set:pNS]"" $Namespace=pNS
		Set tSC=..GetProduction(.tProd) Quit:$$$ISERR(tSC)
		Set tFoundTrace=0
		For tI=1:1:tProd.Items.Count() {
			Set tItem=tProd.Items.GetAt(tI)
			If tItem.ClassName="HS.Util.Trace.Operations" {Set tFoundTrace=1 Continue}
			If '..HasSetting(tItem,"TraceOperations") Continue
			Set tIdx="",tSettingFound=0
			For {
				Set tSetting = tItem.Settings.GetNext(.tIdx) Quit:tIdx=""
				If tSetting.Name = "TraceOperations" {
					If tSetting.Value = "" {
						Set tSetting.Value = pSetting
					}
					
					Set tSettingFound = 1
				}
			}
			If 'tSettingFound {
				Set tSetting=##class(Ens.Config.Setting).%New()
				Set tSetting.Name="TraceOperations"
				Set tSetting.Value=pSetting
				Set tSetting.Target="Host"
				Do tItem.Settings.Insert(tSetting)
			}
		}

		If 'tFoundTrace {
			Set tItem = ##class(Ens.Config.Item).%New()
			Set tItem.ClassName="HS.Util.Trace.Operations",tItem.Name="HS.Util.Trace.Operations"
			Set tItem.PoolSize="1"
			Set tItem.Enabled="1"
			Do tProd.Items.Insert(tItem)
		}
		Set tSC=tProd.%Save()
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace=tWhere
	Quit tSC
}

ClassMethod AddUpdateConfigItem(pItem As Ens.Config.Item, pToProd As Ens.Config.Production, pUpdate) As %Status
{
	#dim tItem As Ens.Config.Item
	#dim tFromItem As Ens.Config.Item
	try {
		Set tFound=0,tSC=$$$OK
		For tI=1:1:pToProd.Items.Count() {
			Set tItem=pToProd.Items.GetAt(tI)
			If tItem.ClassName=pItem.ClassName && (tItem.Name = pItem.Name) && (tItem.Comment = pItem.Comment) {Set tFound=1 Quit}
		}
		If tFound && 'pUpdate Quit   //already there, done if not updating it
		If 'tFound {
			Set tSC=pToProd.Items.Insert(pItem)
			Quit
		} Else {
			For tProperty = "Category","ClassName","PoolSize","Enabled","Foreground","DisableErrorTraps","InactivityTimeout","Comment","LogTraceEvents","Schedule" {
				Set $zobjProperty(tItem,tProperty)=$zobjProperty(pItem,tProperty)
			}
		}

		Set tIdx=""
		For {
			Set tSetting = pItem.Settings.GetNext(.tIdx) Quit:tIdx=""
			Set tIdx2="",tSettingFound=0
			For  {
				Set tSetting2 = tItem.Settings.GetNext(.tIdx2) Quit:tIdx2=""
				If tSetting2.Name = tSetting.Name {
					Set tSetting2.Value = tSetting.Value,tSetting2.Target = tSetting.Target,tSettingFound=1
				}
			}
			If 'tSettingFound Do tItem.Settings.Insert(tSetting)
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod RemoveConfigItem(pItem As Ens.Config.Item, pToProd As Ens.Config.Production) As %Status
{
	#dim tItem As Ens.Config.Item
	#dim tFromItem As Ens.Config.Item
	try {
		Set tFound=0,tSC=$$$OK
		For tI=1:1:pToProd.Items.Count() {
			Set tItem=pToProd.Items.GetAt(tI)
			If tItem.ClassName=pItem.ClassName && (tItem.Name = pItem.Name) {Set tFound=1 Quit}
		}
		Quit:'tFound
		Do pToProd.Items.RemoveAt(tI)
		Do tItem.%Delete(tItem.%Oid())
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Used to remove unused settings from production item
ClassMethod RemoveSettingFromConfigItem(pSettingName, pItemClass, pProd As Ens.Config.Production = "") As %Status
{
	try {
		Set tSC = $$$OK
		If '$isObject(pProd) Set tSC = ..GetProduction(.pProd) Quit:$$$ISERR(tSC)
		For tIdx = 1:1:pProd.Items.Count() {
			Set tItem = pProd.Items.GetAt(tIdx)
			If tItem.ClassName '= pItemClass Continue
			Set tIdx2=""
			For {
				Set tSetting = tItem.Settings.GetNext(.tIdx2) Quit:tIdx2=""
				If tSetting.Name = pSettingName Do tItem.Settings.RemoveAt(tIdx2) Quit
			}
		}
		Set tSC = pProd.%Save()
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod getStream(pLocation As %String, Output pStream) As %Status
{
	If pLocation '[ "://" Set pLocation = "xdata://"_..%ClassName(1)_":"_pLocation
	Quit ##class(HS.Util.XMLUtils).GetXDataAsStreamWithSubstitutions(pLocation,.pStream)
}

ClassMethod AddOIDEntries(pNS As %String = {$namespace}, pItems = "OIDEntries") As %Status
{
	#dim tItem As HS.Data.OIDMap
	try {
		Set tSC=$$$OK
		Set tWhere = $Namespace Set:pNS]"" $Namespace=pNS
		IF '$$$IsHub Set tSC=$$$ERROR($$$GeneralError,"Registry entries are only filed in registry namespace") Quit
		Set tSC	= ..getStream(pItems, .tItemsXData) Quit:$$$ISERR(tSC)

		set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tItemsXData,.tObjects) Quit:$$$ISERR(tSC)
		Do tReader.Correlate("Item","HS.Data.OIDMap")
		While tReader.Next(.tItem, .tSC) {
			 Do ##class(HS.Data.OIDMap).OIDRow(tItem.OID,.tID)
			 If tID {
				 Set tObj=##class(HS.Data.OIDMap).%OpenId(tID)
			 } Else {
				 Set tObj=##class(HS.Data.OIDMap).%New()
				 Set tObj.OID=tItem.OID
			 }
			 Set tObj.Description=tItem.Description
			 Set tObj.IdentityCode=tItem.IdentityCode
			 Do tObj.IdentityTypes.Clear()
			 For tI=1:1:tItem.IdentityTypes.Count() {
				 Set tTypeDes=tItem.IdentityTypes.GetAt(tI).Description
				 Set tType=##class(HS.Data.OIDType).%OpenId(tTypeDes)
				 Do:tType'="" tObj.IdentityTypes.Insert(tType)
			 }
			 Set tSC=tObj.%Save() Quit:$$$ISERR(tSC)
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace=tWhere
	Quit tSC
}

ClassMethod AddRegistryEntries(pNS As %String = "", pItems = "RegistryEntries", ByRef pSubstitutionValues) As %Status
{
	try {
		Set tSC=$$$OK
		Set tWhere = $Namespace Set:pNS]"" $Namespace=pNS 
		Set:pNS="" pNS=$Namespace
		IF '$$$IsHub Set tSC=$$$ERROR($$$GeneralError,"Registry entries are only filed in registry namespace") Quit
		Set tSC	= ..getStream(pItems, .tItemsXData) Quit:$$$ISERR(tSC)
		
		set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tItemsXData,.tObjects) Quit:$$$ISERR(tSC)
		
		// Initialize XPATH Document from tItemsXData
		Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(tItemsXData, .tDocument)
		Quit:$$$ISERR(tSC)
		
		#; web services
		Do tReader.Correlate("WebService","HS.Registry.Service.SOAP")
		Set tSC=##class(%RoutineMgr).GetWebServerPort(.tPort) Quit:'tSC
		Set tHostAndPort=$ZCVT($$$HSNetworkHostName,"L")_":"_tPort
		//
		// Initialize counter for SOAP items
		Set i=0
		//
		While tReader.Next(.tItem, .tSC) {
			
			/*
				Properties with Defaults
				
				Abstract:
				Status
				Push
				SystemGenerated
				
				HTTP:
				Abstract's properties
				ProxyHTTPS
				ProxyHTTPTunnel
				ProxyHTTPSSLConnect
				SSLCheckServerIdentity
				
				SOAP:
				HTTP's properties
				MTOM
				SendSAMLAssertion
			*/
			
			Set i=i+1 // Keep track of which item being processed to grab the corresponding item from the XDATA
			For tProp="Push","SystemGenerated","ProxyHTTPS","ProxyHTTPTunnel","ProxyHTTPSSLConnect","SSLCheckServerIdentity","MTOM","SendSAMLAssertion" {
				Set tSC=tDocument.EvaluateExpression("/Items/WebService[i]/"_tProp, "text()", .tResults)
				Quit:$$$ISERR(tSC)
				If $G(tResults.Data(1))="" { // No input property, so clear default from tItem
					Set $Property(tItem, tProp) = ""
				}
			}
			Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType(tItem.Name,"SOAP")
			If '$IsObject(tEP) Set tEP=tItem
			Set tEndPoint = tItem.EndPoint
			If tEndPoint ["{" {
				If tEndPoint[ "{HostAndPort}" {
					Set tEndPoint = $p(tEndPoint,"{HostAndPort}",1) _ tHostAndPort _ $p(tEndPoint,"{HostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomHostAndPort}" && ($D(pSubstitutionValues("CustomHostAndPort"))) {
					Set tEndPoint = $p(tEndPoint,"{CustomHostAndPort}",1) _ pSubstitutionValues("CustomHostAndPort") _ $p(tEndPoint,"{CustomHostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomURL}" && ($D(pSubstitutionValues("CustomURL"))) {
					Set tEndPoint = pSubstitutionValues("CustomURL")
				} Else {
					Set tSystemName = $p($p(tEndPoint,"{",2),"}")
					Set tHost = ..GetSystemItem(tSystemName,"Host")
					Set tPort = ..GetSystemItem(tSystemName,"WebPort")
					Set tEndPoint = $p(tEndPoint,"{"_tSystemName_"}",1) _ tHost_":"_tPort _ $p(tEndPoint,"{"_tSystemName_"}",2)
				}
				If tEndPoint["{Namespace}" {
					Set tEndPoint = $p(tEndPoint,"{Namespace}",1) _ $namespace _ $p(tEndPoint,"{Namespace}",2)
				}
			}				
			Set tSC = tItem.ParseURL(tEndPoint)
			Set tSC = tEP.UpdateFrom(tItem,tEP)
			Quit:$$$ISERR(tSC)
			Set tEP.Type="SOAP"
			Set tSC=tEP.%Save()
			Quit:$$$ISERR(tSC)
		}
		
		#; tcp services
		Do tReader.Rewind()
		Do tReader.Correlate("TCPService","HS.Registry.Service.TCP")
		// Initialize counter for TCP Items
		Set i=0
		While tReader.Next(.tItem, .tSC) {
			
			/*
				Properties with Defaults
				
				Abstract:
				Status
				Push
				SystemGenerated
				
			*/
			
			Set i=i+1 // Keep track of which item being processed to grab the corresponding item from the XDATA

			For tProp="Push","SystemGenerated" {
				Set tSC=tDocument.EvaluateExpression("/Items/WebService[i]/"_tProp, "text()", .tResults)
				Quit:$$$ISERR(tSC)
				If $G(tResults.Data(1))="" { // No input property, so clear default from tItem
					Set $Property(tItem, tProp) = ""
				}
			}

			Set tEP = ##class(HS.Registry.Service.TCP).EndPointForNameType(tItem.Name,"TCP")
			If '$IsObject(tEP) Set tEP=tItem
			Set tSC = tEP.UpdateFrom(tItem,tEP)
			Quit:$$$ISERR(tSC)
			Set tEP.Type="TCP"
			Set tSC=tEP.%Save()
			Quit:$$$ISERR(tSC)
		}
		
		#; http services
		Do tReader.Rewind()
		Do tReader.Correlate("HTTPService","HS.Registry.Service.HTTP")
		Set tSC=##class(%RoutineMgr).GetWebServerPort(.tPort) Quit:'tSC
		Set tHostAndPort=$ZCVT($$$HSNetworkHostName,"L")_":"_tPort
		// Initialize counter for HTTP Items
		Set i=0
		While tReader.Next(.tItem, .tSC) {
			
			/*
				Properties with Defaults
				
				Abstract:
				Status
				Push
				SystemGenerated
				
				HTTP:
				Abstract's properties
				ProxyHTTPS
				ProxyHTTPTunnel
				ProxyHTTPSSLConnect
				SSLCheckServerIdentity
				
			*/
			
			Set i=i+1 // Keep track of which item being processed to grab the corresponding item from the XDATA
			For tProp="Push","SystemGenerated","ProxyHTTPS","ProxyHTTPTunnel","ProxyHTTPSSLConnect","SSLCheckServerIdentity" {
				Set tSC=tDocument.EvaluateExpression("/Items/WebService[i]/"_tProp, "text()", .tResults)
				Quit:$$$ISERR(tSC)
				If $G(tResults.Data(1))="" { // No input property, so clear default from tItem
					Set $Property(tItem, tProp) = ""
				}
			}
			
			Set tEP = ##class(HS.Registry.Service.HTTP).EndPointForNameType(tItem.Name,"HTTP")
			If '$IsObject(tEP) Set tEP=tItem
			Set tEndPoint = tItem.EndPoint
			If tEndPoint ["{" {
				If tEndPoint[ "{HostAndPort}" {
					Set tEndPoint = $p(tEndPoint,"{HostAndPort}",1) _ tHostAndPort _ $p(tEndPoint,"{HostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomHostAndPort}" && ($D(pSubstitutionValues("CustomHostAndPort"))) {
					Set tEndPoint = $p(tEndPoint,"{CustomHostAndPort}",1) _ pSubstitutionValues("CustomHostAndPort") _ $p(tEndPoint,"{CustomHostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomURL}" && ($D(pSubstitutionValues("CustomURL"))) {
					Set tEndPoint = pSubstitutionValues("CustomURL")
				} Else {
					Set tSystemName = $p($p(tEndPoint,"{",2),"}")
					Set tHost = ..GetSystemItem(tSystemName,"Host")
					Set tPort = ..GetSystemItem(tSystemName,"WebPort")
					Set tEndPoint = $p(tEndPoint,"{"_tSystemName_"}",1) _ tHost_":"_tPort _ $p(tEndPoint,"{"_tSystemName_"}",2)
				}
				If tEndPoint["{Namespace}" {
					Set tEndPoint = $p(tEndPoint,"{Namespace}",1) _ $namespace _ $p(tEndPoint,"{Namespace}",2)
				}
				If tEndPoint["{CustomURL}" {
					Set tEndPoint = $p(tEndPoint,"{CustomURL}",1) _ pSubstitutionValues("CustomURL") _ $p(tEndPoint,"{CustomURL}",2)
				}
			}				
			Set tSC = tItem.ParseURL(tEndPoint)
			Quit:$$$ISERR(tSC)
			Set tSC = tEP.UpdateFrom(tItem,tEP)
			Quit:$$$ISERR(tSC)
			Set tEP.Type="HTTP"
			Set tSC=tEP.%Save()
			Quit:$$$ISERR(tSC)
		}
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace=tWhere
	Quit tSC
}

ClassMethod HasSetting(pItem, pSettingName) As %Boolean
{
	set tIndex="",tFound=0 
	for  {
		set tIndex = pItem.Settings.Next(tIndex)  quit:tIndex=""
		set tOneSetting = pItem.Settings.GetAt(tIndex)
		If tOneSetting.Name = pSettingName Set tFound=1 Quit
	}
	;
	set tTargetClassname("Host") = pItem.ClassName
	set tTargetClassname("Adapter") = pItem.AdapterClassName()
	set tTarget="" 
	for  {
		set tTarget=$o(tTargetClassname(tTarget),1,tClassname) quit:tTarget=""
		set rs = ##class(%ResultSet).%New()
		set rs.ClassName = tClassname
		set rs.QueryName = "EnumerateSettings"
		if ('rs.QueryIsValid()) continue
		set tSC = rs.Execute()
		while (rs.Next()) {
			set tName = $G(rs.Data("Name"))
			If tName = pSettingName Set tFound=1 Quit
		}
	}
	quit tFound
}

/// Given a value of a namespace type (^%SYS("HealthShare","Instances",pNS,"Type")) return the available kits that could be added
/// Valid types "Hub","Bus","AccessGateway","EdgeGateway"
ClassMethod AvailableKits(pType As %String) As %String
{
	Set tList=""
	Set tRS=##class(%ResultSet).%New("%ClassDefinition:SubclassOf") 
	Do tRS.Execute(..%ClassName(1))
	While tRS.Next() {
		Set tClassName = tRS.GetData(1)
		Set tParam = $classmethod(tClassName,"%GetParameter","NamespaceTypes")
		If (","_$zcvt(tParam,"U")_",")[$zcvt(pType,"U") Set tList=tList_$lb(tClassName)
	}
	Quit tList
}

/// available host/webport
ClassMethod GetSystemItem(pSystemName, pItem) As %String
{
	try {
		Set tString=""
		If pItem="Host" || (pItem="WebPort") {
			#; If there is only one environment use the current system and web server
			Set tDef=##class(%Dictionary.ClassDefinition).%OpenId(..%ClassName(1))
			If tDef.XDatas.Count()=1 {
	        	If pItem="Host" Set tString=$ZCVT($$$HSNetworkHostName,"L")
	        	If pItem="WebPort" Set tSC=##class(%RoutineMgr).GetWebServerPort(.tString)
				Quit
			}
		}
		Set tSC = ..getStream(pSystemName, .tData) 
		Quit:$$$ISERR(tSC) 
		Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(tData, .tDocument)
		Quit:$$$ISERR(tSC)
		Set tSC = tDocument.EvaluateExpression("/root/"_pItem, "text()", .tResults) 
		Quit:$$$ISERR(tSC)
		Set tString=$S(tResults.Count():tResults.GetAt(1).Value,1:"")
		If pSystemName="Registry" {
			If (pItem="Host") && (tString="") {Set tString=$ZCVT($$$HSNetworkHostName,"L")}
			ElseIf pItem="WebPort" && (tString="") {Set tSC=##class(%RoutineMgr).GetWebServerPort(.tString)}
		}

	} catch ex {
		$$$ThrowOnError(ex.AsStatus())
	}
	Quit tString
}

/// collection of items returned as list
ClassMethod GetSystemNamespaces(pSystemName) As HS.Util.Installer.Kit.Namespaces
{
	try {
		Set tReader=##class(%XML.Reader).%New()
 		Do tReader.Correlate("Namespaces","HS.Util.Installer.Kit.Namespaces") 
		Set tSC = ..getStream(pSystemName, .tStream) $$$ThrowOnError(tSC)
		Set tSC=tReader.OpenStream(tStream) $$$ThrowOnError(tSC)
		Do tReader.Next(.tNamespaces,.tSC) $$$ThrowOnError(tSC)
		For tIdx=tNamespaces.Namespace.Count():-1:1 {
			Set tNamespace = tNamespaces.Namespace.GetAt(tIdx)
			Continue:tNamespace.BaseNamespaceTemplate=""
			Set tReader=##class(%XML.Reader).%New()
	 		Do tReader.Correlate("nsdef","HS.Util.Installer.Kit.Namespace") 
			Set tSC = ..getStream(tNamespace.BaseNamespaceTemplate, .tStream)
			If $$$ISERR(tSC) Set tSC = ..getStream("xdata://HS.Util.Installer.Kit.SampleDefinition:"_tNamespace.BaseNamespaceTemplate, .tStream) Quit:$$$ISERR(tSC)
			Set tSC=tReader.OpenStream(tStream) $$$ThrowOnError(tSC)
			Do tReader.Next(.tNamespaceDef,.tSC) $$$ThrowOnError(tSC)
			
			If $IsObject(tNamespaceDef) {
				Do tNamespaces.Namespace.RemoveAt(tIdx)
				Set tNamespaceDef.Type=tNamespace.Type
				Set tNamespaceDef.Name=tNamespace.Name
				For tIdx2 = 1:1:tNamespace.Options.Count() {
					Do tNamespaceDef.Options.Insert(tNamespace.Options.GetAt(tIdx2))
				}
				Do tNamespaces.Namespace.InsertAt(tNamespaceDef,tIdx)
			}
			
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		 $$$ThrowOnError(tSC)
	}
	Quit $s($$$ISERR(tSC):"",1:tNamespaces)
}

ClassMethod FindSystem(pHost = {$ZCVT($$$HSNetworkHostName,"L")}, pPort = "") As %String
{
	If pPort="" {
		Set tSC=##class(%RoutineMgr).GetWebServerPort(.tPort) Quit:'tSC
		Set pPort=tPort
	}
	Set tDef=##class(%Dictionary.ClassDefinition).%OpenId(..%ClassName(1)),tFound=0
	If tDef.XDatas.Count()=1 {
		Set tName=tDef.XDatas.GetAt(1).Name,tFound=1
	} Else {
		Set tDefined=0,tRegistry=""
		For tIdx=1:1:tDef.XDatas.Count() {
			Set tName=tDef.XDatas.GetAt(tIdx).Name
			If tName="Registry" Set tRegistry=tName
			Set tHost = ..GetSystemItem(tName,"Host")
			If tHost]"" Set tDefined=1 If tHost'=pHost Continue
			Set tPort = ..GetSystemItem(tName,"WebPort")
			If tPort]"" Set tDefined=1 If tPort=pPort Set tFound=1 Quit
		}
		If 'tDefined Set tFound=1,tName=$S(tRegistry="":tName,1:tRegistry)
	}
	Quit $s(tFound:tName,1:"")
}

/// Using XData blocks in a defined class to define the environment 
ClassMethod Install(ByRef pOptions) As %Status
{
	try {
		Set tSC = $$$OK
		Set tNS = $Namespace
		If '##class(HS.HC.Util.Installer).CheckGetKey() {
			write !!,"License key not present, cannot install HealthShare"
			set tSC = $$$ERROR($$$OperationNotLicensed,$ZE)
			quit
		}
		Set tSC=##class(HS.Util.SystemAPI).Invoke("AddCSPXSLTapplication","%")

		Set tObj = ..%New()
	
		Set tSystem = tObj.FindSystem() If tSystem="" Set tSC=$$$ERROR($$$GeneralError,"Unable to find installation system") Quit
		
		If $data(pOptions("HubHost"),tHubHost) = 0 {
			Set tHubHost = tObj.GetSystemItem("Registry","Host")
		}
		If $data(pOptions("HubPort"),tHubPort) = 0 {
			Set tHubPort = tObj.GetSystemItem("Registry","WebPort")
		}
		If $data(pOptions("HubNamespace"),tHubNamespaceName) = 0 {
			Set tHubNamespaces = tObj.GetSystemNamespaces("Registry")
			Set tHubNamespace = tHubNamespaces.Namespace.GetAt(1)
			set tHubNamespaceName = tHubNamespace.Name
		}
		Set tHubURL = "http://"_tHubHost_":"_tHubPort_"/csp/healthshare/"_tHubNamespaceName_"/services/HS.Hub.HSWS.WebServices.cls"
		
		Set tNamespaces = tObj.GetSystemNamespaces(tSystem)

		#; core namespace setup (Template copy)
		For tIdx = 1:1:tNamespaces.Namespace.Count() {
			Set tNamespace = tNamespaces.Namespace.GetAt(tIdx)
			Kill tVars Set tVars("HubEndpoint")=tHubURL,tVars("Template")=tNamespace.Template
			If $D(pOptions) && tNamespace.Options.Count() {
				Set tOption="",tInclude=0
				For  { Set tOption=$o(pOptions(tOption)) Quit:tOption=""  If pOptions(tOption) && tNamespace.Options.Find(tOption) Set tInclude=1 Quit }
				If 'tInclude Continue
			}
			If $G(pOptions("Trace")) Do ..AddTraceAll()


			Set tNode=""
			For {
				Set tValue = tNamespace.Vars.GetNext(.tNode) Quit:tNode=""
				Set tVars(tNode)=tValue
			}
			Set:$D(pOptions("HubAuditProduction")) tVars("HubAuditProduction")=pOptions("HubAuditProduction")
			Set:$D(pOptions("EdgeAuditProduction")) tVars("EdgeAuditProduction")=pOptions("EdgeAuditProduction")
			
			Set tIsBaseNSType = (tNamespace.Type '[ ".")
			If (tIsBaseNSType) {
				Set tNamespaceTypeClass = "HS.Util.Installer." _ tNamespace.Type
				Set tRequiredInstallerSuperClass = "HS.Util.Installer.ConfigItem"
			}
			// If we get a full class name for the type, the class MUST extend HS.Util.Installer.FoundationType
			Else {
				Set tNamespaceTypeClass = tNamespace.Type
				Set tRequiredInstallerSuperClass = "HS.Util.Installer.FoundationType"
			}
			If '##class(%Dictionary.CompiledClass).%ExistsId(tNamespaceTypeClass) || '$classmethod(tNamespaceTypeClass,"%IsA",tRequiredInstallerSuperClass) {
				Set tSC = $$$ERROR($$$GeneralError,"Invalid namespace type: '" _ tNamespace.Type _ "'")
				Quit
			}
			Set tSC = $classmethod(tNamespaceTypeClass,"Install",tNamespace.Name,.tVars)
			Quit:$$$ISERR(tSC)
			//Namespace has now been created if it didn't exist already
			If tNamespace.Items]"" Set tSC= ..ProductionMods(tNamespace.Name,"",1,"",tNamespace.Items) Quit:$$$ISERR(tSC)				
			Set tSC = ..AddDefaultSetting(tNamespace.Name,"*",,,"RequireValidSAMLToken",0)
			Quit:$$$ISERR(tSC)
			#; apply additional Kits (copy segments of templates into production)
			For tIdx2 = 1:1:tNamespace.AdditionalKit.Count() {
				Set tKit = tNamespace.AdditionalKit.GetAt(tIdx2)
				If $D(pOptions) && tKit.Options.Count() {
					Set tOption="",tInclude=0
					For  { Set tOption=$o(pOptions(tOption)) Quit:tOption=""  If pOptions(tOption) && tKit.Options.Find(tOption) Set tInclude=1 Quit }
					If 'tInclude Continue
				}
				#; optional override on the namespace (allows doing routine mapping)
				Set $namespace = $S(tKit.Namespace]"":tKit.Namespace,1:tNamespace.Name)
				Set tArgs = tKit.Arguments.Count()
				For tIdx3=1:1:tArgs {
					Set tArgs(tIdx3)=tKit.Arguments.GetAt(tIdx3)
				}

				Set tMethod = ..GetMethodNameForKit(tKit,tNamespace,0)
				If $$$WriteProg Write !,"Running "_tKit.Class_":"_tMethod_"("_tNamespace.Name_") "
				try {
					Set tSC = $classmethod(tKit.Class,tMethod,tNamespaces,tArgs...) 
				} catch ex {
					Set tSC = ex.AsStatus()
				}
				If $$$WriteProg Write !,"Ran "_tKit.Class_":"_tMethod_"("_tNamespace.Name_") with status "_$S($$$ISOK(tSC):"OK",1:$system.Status.GetErrorText(tSC))
				Quit:$$$ISERR(tSC)
			}
			Quit:$$$ISERR(tSC)
		}
		Quit:$$$ISERR(tSC)
		#; loop through core namespaces again to see if there are post install items
		For tIdx = 1:1:tNamespaces.Namespace.Count() {
			Set tNamespace = tNamespaces.Namespace.GetAt(tIdx)
			#; if the core namespace was excluded continue
			If $D(pOptions) && tNamespace.Options.Count() {
				Set tOption="",tInclude=0
				For  { Set tOption=$o(pOptions(tOption)) Quit:tOption=""  If pOptions(tOption) && tNamespace.Options.Find(tOption) Set tInclude=1 Quit }
				If 'tInclude Continue
			}

			#; process post install items
			For tIdx2 = 1:1:tNamespace.PostInstallKit.Count() {
				Set tKit = tNamespace.PostInstallKit.GetAt(tIdx2)

				If $D(pOptions) && tKit.Options.Count() {
					Set tOption="",tInclude=0
					For  { Set tOption=$o(pOptions(tOption)) Quit:tOption=""  If pOptions(tOption) && tKit.Options.Find(tOption) Set tInclude=1 Quit }
					If 'tInclude Continue
				}
				
				#; optional override on the namespace (allows doing routine mapping)
				Set $namespace = $S(tKit.Namespace]"":tKit.Namespace,1:tNamespace.Name)
				Set tArgs = tKit.Arguments.Count()
				For tIdx3=1:1:tArgs {
					Set tArg = tKit.Arguments.GetAt(tIdx3)
					If $e(tArg)="{" {
						Set %val = $p($p(tArg,"{",2),"}",1) 
						X "Set @(""%val=""_%val)"
					} Else {
						Set %val = tArg
					}
					Set tArgs(tIdx3)=%val
				}
				If 'tArgs {
					Set tArgs(1)=tNamespaces,tArgs=1
				}
				Set tMethod = ..GetMethodNameForKit(tKit,tNamespace,1)
				If $$$WriteProg Write !,"Running "_tKit.Class_":"_tMethod_"("_tNamespace.Name_") "
				Try {
					Set tSC = $classmethod(tKit.Class,tMethod,tArgs...) 
				} Catch ex {
					Set tSC = ex.AsStatus()
				}
				If $$$WriteProg Write !,"Ran "_tKit.Class_":"_tMethod_" with status "_$S($$$ISOK(tSC):"OK",1:$system.Status.GetErrorText(tSC))

				Quit:$$$ISERR(tSC)
			}
			Quit:$$$ISERR(tSC)
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Set $Namespace=tNS
	Quit tSC
}

/// Helper method to return the method name that should be executed for a kit in a particular namespace.
/// Note that this method throws exceptions when an invalid configuration is supplied.
/// pMode refers to which context the kit is being run in:
/// <ul>
/// <li>0 - AdditionalKit</li>
/// <li>1 - PostInstallKit</li>
/// </ul>
ClassMethod GetMethodNameForKit(pKit As HS.Util.Installer.Kit.RunableClass, pNamespace As HS.Util.Installer.Kit.Namespace, pMode As %Integer = 0) As %String [ Internal, Private ]
{
	If (pKit.Method '= "") {
		Quit pKit.Method
	}
	// Check if we have a non-delegated namespace type (i.e. without a full class name specified)
	ElseIf (pNamespace.Type '[ ".") {
		Set tPrefix = $case(pMode,
			0:	"Add",
			1:	"Run",
			 :	"")
		If (tPrefix = "") {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Invalid mode for installable kit: " _ pMode))
		}
		Quit tPrefix _ pNamespace.Type
	}
	// We don't support type-specific methods for delegated namespace types
	Else {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"Namespace '" _ pNamespace.Name _ "' of type '" _ pNamespace.Type _ "' requires a Method to be defined for kit '" _ pKit.Class _ "'"))
	}
}

/// During Demo setup it is often important to find a gateway, this allows using the namespace name which will not 
/// necessarily work in production 
ClassMethod DemoFindGatewayByName(Name As %String, ByRef ID As %Integer, ByRef pActualName As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set tName = "%:"_Name
	&SQL(SELECT ID,Name,Count(*) INTO :ID,:pActualName,:tCount FROM HS_Gateway.Config WHERE Name LIKE :tName)
	If SQLCODE {
		Set ID="",pActualName=""
		Set tSC = $S(SQLCODE=100:$$$ERROR($$$KeyNotFound,"HS.Gateway.Config","Name",Name),1:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)))
	}
	IF tCount>1 Set tSC = $$$ERROR($$$KeyNotFound,"HS.Gateway.Config","Name",Name),ID="",pActualName=""
	Quit tSC
}

/// pType = "Hub", "AccessGateway", "EdgeGateway" etc 
/// pWhen = "New" or "Upgrade" so if attribute contains pWhen we run it "New" [ "New" or "NewOrUpgrade" [ "New" etc
ClassMethod PostInstallItems(pNamespace, pType, pWhen = "") As %Status
{
	new $namespace
	try {
		Set tSC=$$$OK
		Set $namespace=pNamespace
		#; apply Ensemble activity monitor to any production, if 2016.1+
		Do ##class(HS.Util.Installer.Kit.EnsembleActivityMonitor).AddOperation()
		//Because we have enabling Ensemble, this can make the linkage menu appear.  We don't want that in any HS namespace (except for Foundation)
		Set:pType'="Foundation" ^MPRL.Config("UI","suppressEnsembleLinkageMenu")=1
		Set tDef=##class(%Dictionary.ClassDefinition).%OpenId(..%ClassName(1))
		For tIdx = 1:1:tDef.XDatas.Count() {
			If tDef.XDatas.GetAt(tIdx).Name'=(pType_"PostInstall") Continue
			Set tReader=##class(%XML.Reader).%New()
	 		Do tReader.Correlate("PostInstallKit","HS.Util.Installer.Kit.RunableClass") 
			Set tSC1=tReader.OpenStream(tDef.XDatas.GetAt(tIdx).Data) $$$ThrowOnError(tSC1)
			For  {
				Quit:'tReader.Next(.tKit,.tSC1)  $$$ThrowOnError(tSC1)
				If tKit.When'[pWhen continue
				#; optional override on the namespace (allows doing routine mapping)
				Set tWhere=$namespace If tKit.Namespace]"" Set $namespace=tKit.Namespace
				Set tArgs = tKit.Arguments.Count()
				For tIdx3=1:1:tArgs {
					Set tArgs(tIdx3)=tKit.Arguments.GetAt(tIdx3)
				}
				Set tType=$s(pType="Foundation":"Hub",1:pType)
				Set tMethod = $S(tKit.Method="":"Run"_tType,1:tKit.Method)
				If $$$WriteProg Write !,"Running "_tKit.Class_":"_tMethod_"("_pNamespace_") "
				try {
					Set tSC1 = $classmethod(tKit.Class,tMethod,pNamespace,tArgs...) 
					Set tSC = $$$ADDSC(tSC,tSC1)
				} catch ex {
					Set tSC1 = ex.AsStatus()
					Set tSC = $$$ADDSC(tSC,tSC1)
				}
				If $$$WriteProg Write !,"Ran "_tKit.Class_":"_tMethod_" with status "_$S($$$ISOK(tSC1):"OK",1:$system.Status.GetErrorText(tSC1))
				Set $namespace=tWhere
			}
		}
	} Catch eException {
		Set tSC1=eException.AsStatus()
		Set tSC = $$$ADDSC(tSC,tSC1)
	}
	Quit tSC
}

ClassMethod SetupFacility(pCode, pName, pExternalOrGateway, pAssigningAuthority = 1, pHomeFacility = 0) As %Status
{
	try {
		Set tSC = $$$OK
		If ##class(HS.Facility.Config).%ExistsId(pCode) Quit

		If $$$WriteProg Write !,"Setup facility "_pCode
		Set tFacility=##class(HS.Facility.Config).%New()
		Set tFacility.FacilityCode=pCode
		Set tFacility.Name=pName
		Set tFacility.AssigningAuthority=pAssigningAuthority
		Set tFacility.HomeFacility=pHomeFacility
		If pExternalOrGateway = 1 {
			Set tFacility.ExternalHIE = 1
		} Else {
			Set tSC = ##class(HS.Util.Installer.Kit.Base).DemoFindGatewayByName(pExternalOrGateway, .tGWID) Quit:$$$ISERR(tSC)
			If tGWID="" Set tSC =  $$$ERROR($$$GeneralError,"Gateway not found: "_pExternalOrGateway) Quit
			Do tFacility.GatewaySetObjectId(tGWID)
		}
		Set tSC = tFacility.%Save()
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData HubPostInstall
{
<PostInstallKits>
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupConsent" When="New"/>  <!-- create the Data categories / sub categories -->
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupDomains" When="New"/>   <!-- create the healthshare domain %HS_Default -->
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.InfoTypes" When="NewOrUpgrade"/> 
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.PatientReports" When="NewOrUpgrade"/> 
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.ManagementReports" When="NewOrUpgrade"/> 
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupRegistryConfig" When="New"/> 
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.AssignAuthTypes" When="NewOrUpgrade"/> 
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.AssignAuths" When="NewOrUpgrade"></PostInstallKit>
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupOIDRegistry" When="NewOrUpgrade"/> 
	<!-- define user, push and provider system tables -->
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupCodes" When="NewOrUpgrade"></PostInstallKit>
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupUsers" When="NewOrUpgrade"></PostInstallKit>
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupPush" When="NewOrUpgrade"></PostInstallKit>
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupTerminology" When="NewOrUpgrade"></PostInstallKit>
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupDataVolumeReporting" When="NewOrUpgrade"></PostInstallKit>
	</PostInstallKits>
}

XData FoundationPostInstall
{
<PostInstallKits>
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupOIDRegistry" When="NewOrUpgrade"/> 
	<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.AssignAuthTypes" When="NewOrUpgrade"/> 
</PostInstallKits>
}

XData BusPostInstall
{
<PostInstallKits>
	</PostInstallKits>
}

XData AccessGatewayPostInstall
{
<PostInstallKits>
<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupDataVolumeReporting" When="NewOrUpgrade"></PostInstallKit>
<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupTerminology" When="NewOrUpgrade"></PostInstallKit>
</PostInstallKits>
}

XData EdgeGatewayPostInstall
{
<PostInstallKits>
<PostInstallKit Class="HS.Util.Installer.Kit.PostInstall.SetupDataVolumeReporting" When="NewOrUpgrade"></PostInstallKit>
</PostInstallKits>
}

/// Add a setting to pProd (oref)
ClassMethod AddProductionSetting(pProd As Ens.Config.Production = "", pSettingName As %String, pSettingValue As %String) As %Status
{
	#dim tSetting As Ens.Config.Setting
	If pProd="" Set tSC = ..GetProduction(.pProd)
	Set tFound=0
	For tI=1:1:pProd.Settings.Count() {
		Set tSetting=pProd.Settings.GetAt(tI)
		If tSetting.Name=pSettingName {
			Set pProd.Settings.GetAt(tI).Value=pSettingValue,tFound=1
			Quit
		}
	}
	If 'tFound {
		Set tSetting=##Class(Ens.Config.Setting).%New()
		Set tSetting.Target="Production"
		Set tSetting.Name=pSettingName
		Set tSetting.Value=pSettingValue
		Set tSC=pProd.Settings.Insert(tSetting)
	}
	Set tSC=##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(pProd)
	Quit tSC
}

/// Add a default setting to pProd (oref)
/// If a default setting already exists, override only if pOverrideExisting = 1
ClassMethod AddDefaultSetting(pNamespace As %String = "", pProd = "", pItemName As %String = "*", pHostClassName As %String = "*", pSettingName As %String, pSettingValue As %String, pOverrideExisting As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	If pProd="" Set tSC = ..GetProduction(.pProd)
	Quit:$$$ISERR(tSC) tSC
	New $namespace
	Set:(pNamespace'="") $namespace = pNamespace
	Set tSetting = ##class(Ens.Config.DefaultSettings).%New()
	If $IsObject(pProd){
		Set tProdName=pProd.Name
	}
	Else{
		Set tProdName=pProd
	}
	Set tExistingSetting = ##class(Ens.Config.DefaultSettings).%OpenId(tProdName_"||"_pItemName_"||"_pHostClassName_"||"_pSettingName)
	If $IsObject(tExistingSetting){
		Quit:'pOverrideExisting $$$OK
		Set tSetting = tExistingSetting
	}
	Set tSetting.ProductionName=tProdName
	Set tSetting.SettingName=pSettingName
	Set tSetting.SettingValue=pSettingValue	
	Set tSetting.ItemName = pItemName
	Set tSetting.HostClassName = pHostClassName
	Set tSC = tSetting.%Save()
	Quit tSC
}

}
