Include HS.Test

/// Utility methods for TestCases/Scripts
Class HS.Test.Util [ Abstract ]
{

/// Domain used for localization.
Parameter DOMAIN = "HS";

/// Merge results from one list into another
ClassMethod MergeErrors(ByRef pTarget As HS.Types.IHE.Errors, pSource As HS.Types.IHE.Errors)
{
	If '$IsObject($G(pTarget)) Set pTarget = ##class(HS.Types.IHE.Errors).%New()
	Set i="" For { Set tError = pSource.Errors.GetNext(.i) Quit:i=""
		Do pTarget.logError(tError.Code, tError.Severity, tError.Description, tError.Location)
	}
}

/// Get the XSLT transformer for this session
ClassMethod Transformer() As HS.Util.XSLTTransformer
{
	If '$D($$$HSTestSession("_Transformer")) {
		Set $$$HSTestSession("_Transformer") = ##class(HS.Util.XSLTTransformer).%New()
	}
	Quit $$$HSTestSession("_Transformer")
}

/// Get a resolved script object
ClassMethod GetScript(pScriptKey, Output pScriptObject As HS.Test.Types.Base) As %Status
{
	#; If the script is already an object, return it
	If $IsObject(pScriptKey) Set pScriptObject = pScriptKey Quit $$$OK
	Set pScriptObject = ..GetObject(pScriptKey,.tSC)
	Quit tSC
}

/// Get a resolved object - macro GetObject
ClassMethod GetObject(pKey, Output pSC As %Status = {$$$OK}) As HS.Test.Types.Base
{
	Set tResolved = $$$NULLOREF
	Try {
		$$$ThrowOnError(..LoadObject(pKey, .tUnresolved))
		$$$ThrowOnError(..ResolveObject(tUnresolved, .tResolved))
	} Catch ex { Set pSC = ex.AsStatus() }
	Quit tResolved
}

/// Get a clone of a resolved object - macro GetClone
ClassMethod GetClone(pKey, Output pSC As %Status = {$$$OK}) As HS.Test.Types.Base
{
	Set tObject = ..GetObject(pKey,.pSC) Quit:$$$ISERR(pSC) $$$NULLOREF
	Quit tObject.%ConstructClone(1)
}

/// Get an object from the session or XML import
ClassMethod LoadObject(pKey, Output pObject As HS.Test.Types.Base) As %Status
{
	Set tSC = $$$OK
	Try {
		#; Check the session cache for the key
		If $D($$$HSTestSession(pKey),pObject) Quit
		
		#; Allow key to be a xdata: URI
		Set tInputKey = pKey
		If $zcvt($e(pKey,1,8),"l")="xdata://" Set pKey=$p(pKey,":",3)

		If $D($$$HSTestSession("_data",pKey)) {
			Set tURL = "xdata://"_$$$HSTestSession("_data",pKey)_":"_pKey
		} Else {
			Set tClasses = ""
			
			#; Build a list of all XDatas from root package if not already done
			If '$D($$$HSTestSession("_data")) {
				Set tRoot = $G($$$HSTestSession("package"),"HS.Test.Data")
				Set tSC = $SYSTEM.OBJ.GetPackageList(.tClasses, tRoot, "/includesubpackages") $$$ThrowOnError(tSC)
			}
							
			;# Add the class if the input key is a xdata: URI
			Set:tInputKey'=pKey tClasses($p($p(tInputKey,"//",2),":"))=""
			
			#; Add classes included with DataClass parameter of the script being run
			Set tDataClass = $Parameter(..%ClassName(1),"DataClass")
			For tIdx = 1:1:$l(tDataClass,",") {
				Set tClass = $p(tDataClass,",",tIdx)
				Set:tClass]"" tClasses(tClass)=""
			}
			
			#; Add all XData found to the session _data list
			Set tClass = "" For { Set tClass=$O(tClasses(tClass)) Quit:tClass=""
				Set tRS = ##class(%Library.ResultSet).%New("%Dictionary.XDataDefinitionQuery:Summary")
				Set tSC = tRS.Execute(tClass) $$$ThrowOnError(tSC)
				//break:tClass["PatientDiscovery"
				While tRS.Next(.tSC) { $$$ThrowOnError(tSC)
					Set tKey = tRS.Data("Name")
					If $G($$$HSTestSession("_data", tKey),tClass)'=tClass $$$ThrowStatus($$$ERROR($$$GeneralError,"Duplicate key found: "_tKey_" First: "_$$$HSTestSession("_data", tKey)_" This:"_tClass))
					Set $$$HSTestSession("_data", tKey) = tClass
					If tKey=pKey Set tURL = "xdata://"_tClass_":"_tKey
				}
				Do tRS.Close()
			}
		}
		If $G(tURL)="" $$$ThrowStatus($$$ERROR($$$GeneralError, "No class found with XData name: "_pKey))
		
		#; XML import the object
		$$$HSTestDebug("Getting URL: "_tURL)
		Set tSC = ##class(Ens.Util.URLStream).GetURLStream(tURL, .tStream) 
		If $$$ISERR(tSC) Write "Failed to get stream:"_tURL $$$ThrowOnError(tSC)
		If '$D($$$HSTestSession("_reader"),tReader) {
			Set tReader = ##class(%XML.Reader).%New()
			Set tRS = ##class(%Library.ResultSet).%New("%Dictionary.ClassDefinitionQuery:SubclassOf")
			Set tSC = tRS.Execute("HS.Test.Types.Base") $$$ThrowOnError(tSC)
			While tRS.Next(.tSC) { $$$ThrowOnError(tSC)
				Set tClass = tRS.Data("Name")
				Set tTagName = $parameter(tClass,"XMLNAME")
				Set:tTagName="" tTagName = $parameter(tClass,"XMLTYPE")
				Set:tTagName="" tTagName = $classmethod(tClass,"%ClassName")
				Do tReader.Correlate(tTagName,tClass)
			}
			Do tRS.Close()
			Set $$$HSTestSession("_reader") = tReader
		}
		Set tSC = tReader.OpenStream(tStream) $$$ThrowOnError(tSC)
		Set tOK = tReader.Next(.pObject, .tSC) $$$ThrowOnError(tSC)
		If 'tOK $$$ThrowStatus($$$ERROR($$$GeneralError, "Object not found for key "_pKey))
		
		#; Set the key to the XData name unless already set
		Set:pObject.Key="" pObject.Key = pKey
	
		$$$HSTestDebug("Loaded "_pKey_" into object "_pObject) Set %=$i(%session("_loaded",pObject.Key))
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Resolve references from an object
ClassMethod ResolveObject(pObject As HS.Test.Types.Base, pResolved As HS.Test.Types.Base) As %Status
{
	$$$HSTestDebugIn(pObject) Do ..xmlDump(pObject)
	Set tSC = $$$OK	
	Try {

		#; Resolve parent if there is one 
		Set tParentKey = pObject.Ref
		If tParentKey="" Set tParentKey = pObject.Copy
		If tParentKey = "" {
			Set tSC = ..ResolveObjectProperties(.pObject) $$$ThrowOnError(tSC)
			Set pResolved = pObject
		} Else {
			Set tSC = ..LoadObject(tParentKey, .tParent) $$$ThrowOnError(tSC)	
			Set tSC = ..ResolveObject(tParent, .tResolvedParent) $$$ThrowOnError(tSC)
			If pObject.Ref]"",pObject.%ClassName(1)=tResolvedParent.%ClassName(1) {
				#; A reference is actually a copy unless the types are the same
				#; Note: a reference will not resolve or override -- use copy for that
				Set pResolved = tResolvedParent	
			} Else {
				#; Create a true deep copy of the parent:				
				#; - Use %ConstructClone one the parent object to get new object references
				#; - Use %New to get the right type for resolved object (since parent may be a different type)
				#; - Setup the resolved object properties by coping (the just cloned) parent values
				Set tClone = tResolvedParent.%ConstructClone(1)
				Set pResolved = $classmethod(pObject.%ClassName(1),"%New")
				Set tSC = ..OverrideObject(.pResolved, tClone) $$$ThrowOnError(tSC)
				
				#; Do not parent key for caching (the true key will be copied below on Override)
				Set pResolved.Key = ""
				
				#; Override the copy from resolved object properties
				Set tSC = ..ResolveObjectProperties(.pObject) $$$ThrowOnError(tSC)
				Set tSC = ..OverrideObject(.pResolved, pObject) $$$ThrowOnError(tSC)
			}
			Set pResolved.Ref="",pResolved.Copy=""
		}
			
		#; Cache it if there is a key
		If pResolved.Key]"",$G(%session(pResolved.Key))'=pResolved {	
			$$$HSTestDebug("Caching object "_pResolved.Key) s %=$i(%session("_cached",pResolved.Key))
			Set %session(pResolved.Key) = pResolved
		}
		$$$HSTestDebug("After resolving object:") Do ..xmlDump(pResolved)
	} Catch ex { Set tSC = ex.AsStatus() }

	$$$HSTestDebugOut
	Quit tSC
}

/// Resolve references from an object's properties
ClassMethod ResolveObjectProperties(ByRef pObject As HS.Test.Types.Base) As %Status
{
	Set tSC = $$$OK	
	Try {

		Set tClass = pObject.%ClassName(1)
		Set tSC = ..GetPropertyList(pObject, .tProperties) $$$ThrowOnError(tSC)
		Set tProp = "" For { Set tProp = $O(tProperties(tProp),1,tValue) Quit:tProp=""
			If $IsObject(tValue) {
				If $d(tProperties(tProp,"collection")) {
					#; Collection properties cannot be referenced/copied, but thier items can
					Set tList = $property(pObject, tProp)
					For i=1:1:tList.Count() {
						Set tItem=tList.GetAt(i)
						If $IsObject(tItem),tItem.%Extends("HS.Test.Types.Base") {
							Set tSC = ..ResolveObject(tItem, .tResolvedItem) $$$ThrowOnError(tSC)
							Set tSC = tList.SetAt(tResolvedItem,i) $$$ThrowOnError(tSC)
						}
					}					
				}
				ElseIf tValue.%Extends("HS.Test.Types.Base") {
					Set tSC = ..ResolveObject($property(pObject,tProp), .tResolvedProperty) $$$ThrowOnError(tSC)
					Set $property(pObject, tProp) = tResolvedProperty
				}
			}
		}

	} Catch ex { Set tSC = ex.AsStatus() }

	$$$HSTestDebugOut
	Quit tSC
}

/// Returns list of property values without swizzling
/// The following properties will be omitted:
/// <li>Calculated
/// <li>System (beginning with a %)
/// <li>Private
/// <li>Multidimensional
/// Returns list as a multidimensional array of property values
ClassMethod GetPropertyList(pObject As %RegisteredObject, Output pProperties) As %Status
{
	Kill pProperties
	Set pProperties = ""

	Set tClass = pObject.%ClassName(1)
	Set tContext = $system.CLS.DumpContext(pObject)
	Set tCount=$piece(tContext,"^",10)
	#; this code came from $system.OBJ.DumpObject
	For supcls=0:1:tCount-1 {
		Set inst=$piece($system.CLS.DumpContext(pObject,supcls),"^",8)
		For j=1:1:inst {
			Set tInfo=$system.CLS.Property(j,pObject,supcls)
			Set tName=$piece(tInfo,"^",1)
			Set tSlot=$piece(tInfo,"^",2)
			Set tMode=+$piece(tInfo,"^",3)
			Set tRefProp=($zb(tMode,16,1)=16)
			If $E(tName,1)="%" Continue       //skip system
			If ($zb(tMode,8,1)=8) Continue    //skip private
			If ($zb(tMode,3,1)'=0) Continue   //skip multidimensional
			If $E(tName,*-1,*)="%S" Continue  //skip the serial part
			
			If tRefProp {
				If '$method(pObject,tName_"IsSwizzled") Continue
				Set tValue = $property(pObject,tName)
			} Else {
				If '$D($zobjval(pObject,tSlot,0,3,tSlot)) Continue
				Set post=""
				If ($zb(tMode,32,1)=32) Set post=post_"Get"
				If ($zb(tMode,64,1)=64) Set post=post_",Set"
				If post'="" Set post="  <"_$zstrip(post,"<",",")_">"
				Set tValue = $zobjval(pObject,tSlot,0,3,tSlot)
			}

			If tValue = "" Continue           //skip null

			Set pProperties(tName) = tValue
			$$$comMemberKeyGetLvar(tPropType,tClass,$$$cCLASSproperty,tName,$$$cPROPruntimetype)
			Set pProperties(tName,"type") = tPropType
			If $$issubclassof^%occCompile(tPropType,"%Collection.AbstractIterator") Set pProperties(tName,"collection") = ""  //TODO: this probably won't catch %ListOfObj definitions...

		}
	}

	Quit $$$OK
}

/// Deep copy values skipping empty ones -- skips "", but not $C(0)
ClassMethod OverrideObject(pTarget As %RegisteredObject, pOverride As %RegisteredObject) As %Status
{
	$$$HSTestDebugIn(pTarget_" "_pOverride)
	Set tSC = $$$OK
	Try {
		Set tTargetClass = pTarget.%ClassName(1)
		Set tOverrideClass = pOverride.%ClassName(1)
				
		#; For every non-calculated property in the override class
		Set tSC = ..GetPropertyList(pOverride, .tOverrideProperties) $$$ThrowOnError(tSC)	
		Set tSC = ..GetPropertyList(pTarget, .tTargetProperties) $$$ThrowOnError(tSC)
		Set tProp = "" For { Set tProp=$O(tOverrideProperties(tProp),1,tValue) Quit:tProp=""
			#; Skip if this is not a property of the target or has a different type
			Continue:'$$$comMemberDefined(tTargetClass,$$$cCLASSproperty,tProp)
			$$$comMemberKeyGetLvar(tTargetPropClass,tTargetClass,$$$cCLASSproperty,tProp,$$$cPROPruntimetype)
			$$$comMemberKeyGetLvar(tOverridePropClass,tOverrideClass,$$$cCLASSproperty,tProp,$$$cPROPruntimetype)
			Continue:tTargetPropClass'=tOverridePropClass
			
			If '$IsObject(tValue) || ($G(tTargetProperties(tProp))="") {  
				#; Copy if override is datatype or target is null 
				Set $property(pTarget,tProp) = $property(pOverride,tProp) 
				$$$HSTestDebug("Copying override for property "_tProp)
			}
			ElseIf $d(tOverrideProperties(tProp,"collection")) {
				#dim tTargetList,tOverrideList As %ListOfObjects
				Set tTargetList = $property(pTarget, tProp)
				Set tOverrideList = $property(pOverride, tProp)
				If tTargetList.Count() = 0 {
					Set $property(pTarget, tProp) = $property(pOverride, tProp)
					$$$HSTestDebug("Copying override collection for property "_tProp)
				}
				Else {
					For i=1:1:tOverrideList.Count() {
						Set tOverrideItem = tOverrideList.GetAt(i)
						If i>tTargetList.Count() {
							Set tSC = tTargetList.Insert(tOverrideItem) $$$ThrowOnError(tSC)
							$$$HSTestDebug("Inserting collection item from override for property "_tProp)
						}
						Else {
							Set tTargetItem = tTargetList.GetAt(i)
							$$$HSTestDebug("Overriding collection item at "_i_" for property "_tProp)
							Set tSC = ..OverrideObject(tTargetItem, tOverrideItem)
						}
					}
				}
			}
			Else {
				#; Recurse if both properties are objects
				$$$HSTestDebug("Overriding property "_tProp)
				Set tSC = ..OverrideObject($property(pTarget,tProp),$property(pOverride,tProp)) $$$ThrowOnError(tSC)
			}
		}
	} Catch ex { Set tSC = ex.AsStatus() }
	$$$HSTestDebugOut
	Quit tSC
}

/// Converts a service name beginning with a colon by matching on gateway name
ClassMethod LookupGatewayService(pName As %String, Output pSC As %Status = {$$$OK}) As %String
{
	If $E(pName,1)'=":" Quit pName
	&SQL(SELECT Name INTO :tName FROM HS_Gateway.Config WHERE Name[:pName)
	If SQLCODE {
		Set tName = pName
		Set pSC = $S(SQLCODE=100:$$$ERROR($$$GeneralError,"Gateway not found matching name "_pName),1:$$$ERROR($$$SQLError,$G(SQLCODE),$G(%msg)))
	}
	If $G(%ROWCOUNT)>1 Set pSC = $$$ERROR($$$GeneralError,"More than one gateway found matching name "_pName)
	Quit tName
}

/// Examples and tests for object resolution
ClassMethod UnitTest(pTestNum As %Integer = 0)
{
	Try {
		#;t=counter
		#;t(i)=description
		#;t(i,0)=expected result
		#;t(i,1)=input patient xml
		#;t(i,j)=references
		#;t(i,-1)=$lb(key,equal) if the session key should equal the result
		
		s t($i(t))="No action"
		s t(t,0)="<Patient><MRN id='111'/></Patient>"
		s t(t,1)=t(t,0)
	
		s t($i(t))="Get property attribute from reference"
		s t(t,0)="<Patient><MRN key='MRN222' id='222'/></Patient>"
		s t(t,1)="<Patient><MRN ref='MRN222'/></Patient>"
		s t(t,2)="<Identifier key='MRN222' id='222'/>"
		
		s t($i(t))="Get object from a reference"
		s t(t,0)="<Patient key='pat'><MRN id='222'/></Patient>"
		s t(t,1)="<Patient ref='pat'/>"
		s t(t,2)="<Patient key='pat'><MRN id='222'/></Patient>"

		s t($i(t))="Override property attribute w/session check"
		s t(t,0)="<Patient key='pat'><MRN id='222'/></Patient>"
		s t(t,1)="<Patient ref='pat'><MRN id='222'/></Patient>"
		s t(t,2)="<Patient key='pat'><MRN id='111'/></Patient>"
		s t(t,-1)=$LB("pat",1)

		s t($i(t))="Override property attribute w/copy and session check"
		s t(t,0)="<Patient><MRN id='222'/></Patient>"
		s t(t,1)="<Patient copy='pat'><MRN id='222'/></Patient>"
		s t(t,2)="<Patient key='pat'><MRN id='111'/></Patient>"
		s t(t,-1)=$LB("pat",0)
		
		s t($i(t))="Add property attribute"
		s t(t,0)="<Patient key='pat'><MRN id='222' aa='222'/></Patient>"
		s t(t,1)="<Patient ref='pat'><MRN id='222'/></Patient>"
		s t(t,2)="<Patient key='pat'><MRN aa='222'/></Patient>"

		s t($i(t))="Add property attribute"
		s t(t,0)="<Patient key='pat'><MRN id='222' aa='222'/></Patient>"
		s t(t,1)="<Patient ref='pat'><MRN id='222'/></Patient>"
		s t(t,2)="<Patient key='pat'><MRN aa='222'/></Patient>"

		s t($i(t))="Add element"
		s t(t,0)="<Patient key='pat'><MRN id='222'/><MPI id='333'/></Patient>"
		s t(t,1)="<Patient ref='pat'><MRN id='222'/></Patient>"
		s t(t,2)="<Patient key='pat'><MPI id='333'/></Patient>"
		
		s t($i(t))="Add collection"
		s t(t,0)="<Patient key='pat'><Telecoms><Telecom phone='111-111-111'/></Telecoms></Patient>"
		s t(t,1)="<Patient ref='pat'></Patient>"
		s t(t,2)="<Patient key='pat'><Telecoms><Telecom phone='111-111-111'/></Telecoms></Patient>"
		
		s t($i(t))="Override collection element"
		s t(t,0)="<Patient key='pat'><Telecoms><Telecom phone='111-111-111'/></Telecoms></Patient>"
		s t(t,1)="<Patient ref='pat'><Telecoms><Telecom phone='111-111-111'/></Telecoms></Patient>"
		s t(t,2)="<Patient key='pat'><Telecoms><Telecom phone='xxx-xxx-xxxx'/></Telecoms></Patient>"

		s t($i(t))="Insert collection element"
		s t(t,0)="<Patient key='pat'><MRN id='222'/><Telecoms><Telecom phone='111-111-1111'/><Telecom phone='222-222-2222'/></Telecoms></Patient>"
		s t(t,1)="<Patient ref='pat'><MRN id='222'/><Telecoms><Telecom/><Telecom phone='222-222-2222'/></Telecoms></Patient>"
		s t(t,2)="<Patient key='pat'><Telecoms><Telecom phone='111-111-1111'/></Telecoms></Patient>"
		
		s t($i(t))="Override collection element from reference"
		s t(t,0)="<Patient key='pat'><Telecoms><Telecom key='phone' phone='222-222-2222'/></Telecoms></Patient>"
		s t(t,1)="<Patient ref='pat'><Telecoms><Telecom ref='phone'/></Telecoms></Patient>"
		s t(t,2)="<Patient key='pat'><Telecoms><Telecom phone='111-111-1111'/></Telecoms></Patient>"
		s t(t,3)="<Telecom key='phone' phone='222-222-2222'/>"

		Set r=##class(%XML.Reader).%New()
		For i=1:1:t {
			i pTestNum'=0,i'=pTestNum Continue
			w !,"Test ",i,": ",t(i)
			Do GetObject(0,.tExpected)	
			Do GetObject(1,.tPatient)

			k %session
			Set j=1 For { Set j=$o(t(i,j)) q:j=""
				Do GetObject(j,.tObj)
				If tObj.Key]"" Set %session(tObj.Key)=tObj
			}
			
			Set sc=..ResolveObject(tPatient,.tResolved) $$$ThrowOnError(sc)
			Set sc=..xmlExportCanonical(tResolved,.tResultXML,0,1,0) $$$ThrowOnError(sc)
			Set sc=..xmlExportCanonical(tExpected,.tExpectedXML,0,1,0) $$$ThrowOnError(sc)
			If tResultXML=tExpectedXML {
				If $G(t(i,-1))]"" {
					s key=$LG(t(i,-1),1)
					s eq=$LG(t(i,-1),2)
					If key="" $$$ThrowStatus($$$ERROR(5001,"Missing key"))
					If '$IsObject($G(%session(key))) {
						w ?73,"[FAIL]"
						w !,"Session key ",key," is null"
						break
					} Else {
						Set sc=..xmlExportCanonical(%session(key),.tSessionXML,0,1,0) $$$ThrowOnError(sc)
						If eq=(tSessionXML=tResultXML) {
							#;assuming for copy that if XML is <> it hasn't touched the session
							w ?73,"[ OK ]"
						} Else {
							w ?73,"[FAIL]"
							w !,"Invalid session"
							w !,"Result" Do ..xmlDump(tResolved)
							w !,"Session" Do ..xmlDump(%session(key))
							break
						}
					}					
				} Else {
					w ?73,"[ OK ]"
					//w !,"Result" Do ..xmlDump(tResolved)
				}
			} Else {
				w ?73,"[FAIL]"
				s %session=2
				zw %session
				w !,"Expected" Do ..xmlDump(tExpected)
				w !,"Result" Do ..xmlDump(tResolved)
				break
			}
		}
		Quit
	
GetObject(index,obj)
		Do r.CorrelateRoot("HS.Test.Types."_$P($P($P(t(i,index),">",1)," ",1),"<",2) )
		Set sc=r.OpenString(t(i,index)) $$$ThrowOnError(sc)
		Set ok=r.Next(.obj,.sc) $$$ThrowOnError(sc)
		If 'ok $$$ThrowStatus($$$ERROR(5001,"Correlation failed"))
		Quit
		
	} Catch ex {
		Write !!!,$SYSTEM.Status.GetErrorText(ex.AsStatus())	
	}
}

/// Utility method for dumping a trace of an object as pretty-printed XML
ClassMethod xmlDump(pObject, pIndent = 1, pNoDecl = 1)
{
	Try {
		If '$IsObject($G(pObject)) $$$HSTestTrace("Object is null") Quit
		If 'pObject.%Extends("%XML.Adaptor") $$$HSTestTrace("Object is not XML enabled") Quit
		Set tSC = ..xmlExportWriter(pObject,.tStream,pIndent,pNoDecl,1) $$$ThrowOnError(tSC)
		Do ..xmlDumpStream(tStream, pIndent, pNoDecl)
	} Catch ex { 
		$$$HSTestWrite($SYSTEM.Status.GetErrorText(ex.AsStatus()))
	}
	Quit
}

/// Utility method to dumping a trace of a stream as pretty-printed XML
ClassMethod xmlDumpStream(pStream, pIndent = 1, pNoDecl = 1) As %Status
{
	Try {
		If '$IsObject($G(pStream)) $$$HSTestWrite("Stream is null") Quit
		If 'pStream.%Extends("%Stream.Object") $$$HSTestWrite("Object is not a stream") Quit
		Do pStream.Rewind()
		Set tSC = ..xmlCanonical(pStream,.tStream,pIndent,pNoDecl) $$$ThrowOnError(tSC)
		While 'tStream.AtEnd { 
			Set tBuffer = tStream.ReadLine()
			For i=1:1:$L(tBuffer,$C(10)) {
				Set tLine = $ZSTRIP($P(tBuffer,$C(10),i),">W") 
				If $L(tLine)>0 $$$HSTestWrite(tLine)
			}
		}
		Do pStream.Rewind()
	} Catch ex { 
		$$$HSTestWrite("Failed to dump stream as canonical XML: "_$SYSTEM.Status.GetErrorText(ex.AsStatus()))
		$$$HSTestWrite("Raw stream: ") Do pStream.OutputToDevice(),pStream.Rewind()
	}
	Quit
}

/// Utility to get an XMLExport of an object using a %XML.Writer
ClassMethod xmlExportWriter(pObject, Output pOutput, pIndent = 1, pNoDecl = 1, pAsStream = 1) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.NoXMLDeclaration = pNoDecl
		Set tWriter.Indent = pIndent
		If pAsStream || $IsObject($G(pOutput)) {
			Set tSC = tWriter.OutputToStream(.pOutput) $$$ThrowOnError(tSC)
			Set tSC = tWriter.RootObject(pObject.%ConstructClone(1)) $$$ThrowOnError(tSC)
			Do pOutput.Rewind()
		} Else {
			Set tSC = tWriter.OutputToString() $$$ThrowOnError(tSC)
			Set tSC = tWriter.RootObject(pObject.%ConstructClone(1)) $$$ThrowOnError(tSC)
			Set pOutput = tWriter.GetXMLString(.tSC) $$$ThrowOnError(tSC)
		}
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Utility method to get Canonical form of an object XML export
ClassMethod xmlExportCanonical(pObject, Output pOutput, pIndent = 1, pNoDecl = 1, pAsStream = 1) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC = ..xmlExportWriter(pObject,.tOutput,pIndent,pNoDecl,pAsStream) $$$ThrowOnError(tSC)
		Set tSC = ..xmlCanonical(tOutput,.pOutput,pIndent,pNoDecl,pAsStream) $$$ThrowOnError(tSC)
	} Catch ex { Set sc=ex.AsStatus() }
	Quit tSC
}

/// Utility method to get canonical form of a XML stream
ClassMethod xmlCanonical(pInput, Output pOutput, pIndent = 1, pNoDecl = 1, pAsStream = 1) As %Status
{
	Set tSC = $$$OK
	Try {
		
		Set tReader = ##class(%XML.Reader).%New()
		If pAsStream {
			Set tSC = tReader.OpenStream(pInput) $$$ThrowOnError(tSC)
		} Else {
			Set tSC = tReader.OpenString(pInput) $$$ThrowOnError(tSC)	
		}
		Set tNode = tReader.Document.GetDocumentElement()

		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent=pIndent
		Set tWriter.NoXMLDeclaration=pNoDecl
		If pAsStream || $IsObject($G(pOutput)) {
			Set tSC = tWriter.OutputToStream(.pOutput) $$$ThrowOnError(tSC)
			Set tSC = tWriter.Canonicalize(tNode,,1) $$$ThrowOnError(tSC)
			Do pOutput.Rewind()
		} Else {
			Set tSC = tWriter.OutputToString() $$$ThrowOnError(tSC)
			Set tSC = tWriter.Canonicalize(tNode,,1) $$$ThrowOnError(tSC)
			Set pOutput = tWriter.GetXMLString(.tSC) $$$ThrowOnError(tSC)
		}
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Tests stream equality
ClassMethod StreamEquals(pStream1 As %Stream.Object, pStream2 As %Stream.Object) As %Status
{
	Set tSC = $$$OK
	Try {
		While 'pStream1.AtEnd {
			//set tLength=60
			Set tLine1=pStream1.Read(.tLength,.tSC) $$$ThrowOnError(tSC)
			Set tLine2=pStream2.Read(tLength,.tSC) $$$ThrowOnError(tSC)
			//w !,1,tLine1,!,2,tLine2
			If tLine1'=tLine2 $$$ThrowStatus($$$ERROR($$$GeneralError,"Streams are not equal"))	
		}
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

}
