Include (%occInclude, %systemInclude, %xmlMap, %callout, HS.HC, HS.HC.TraceHelper)

IncludeGenerator (%occInclude, %systemInclude, %xmlMap)

Class HS.SDA3.QuickXML [ Abstract ]
{

Parameter HSDEPLOY = 1;

/// This should be set to 1 only in HS.SDA3.CodeTableTranslated (and thus inherited from its subclasses)
/// to tell the code generator to add in code for performing translation during export.
Parameter TRANSLATED = 0;

/// A comma separated list of properties where the calling streamlet can override the behavior of that property in the
/// generated UpdateSDA method
Parameter CANOVERRIDEPROPLIST;

/// Pass in a reference to a stream.  If none is passed in, this will
/// return a new %FileCharacterStream.  If a stream is passed in, this will
/// concatenate the XML onto the end of that stream.<br>
/// See HS.SDA3.Blob for info on control variable %HSStreamletBlobs and %HSBlobMode
Method ToQuickXMLStream(ByRef pStream, pTag As %String = "") As %Status
{
	#dim tChunk As %String
	Set tSC=$$$OK
	Set tIo=$io,tXDEV="|XDEV|"_$JOB Close tXDEV //just in case
    Open tXDEV:($ZF(-6,$$$XSLTLibrary,12):25:"S":/HOSTNAME="XSLT":/IOT=$S($$$IsUnicode:"UTF8",1:"RAW"):/IBU=16384:/OBU=16384)
	Use tXDEV
	Do ..ToQuickXML(pTag)
	// Flush any remaining output
	Write *-3

	If $get(pStream)="" {
		Set pStream=##class(%FileCharacterStream).%New()
		If $$$IsUnicode Set pStream.TranslateTable="UTF8"
	}
	// As of IRIS 2019.2, reading past the end of an XDEV incurs an
	// ENDOFFILE error, but should be considered the same as what
	// was previously detected by Read tChunk:0 returning a blank
	// string - it's just the end of data and it's now time to quit.
	Try {
		IF $zobjclass(pStream)="%Library.FileCharacterStream" {
			Set tSC=pStream.Write("") ; force stream's file to open
			Quit:$$$ISERR(tSC)
			Set tFile=pStream.Filename ; get filename and make current device
		    For  {
				Use tXDEV Read tChunk:0
				Quit:'$L(tChunk)
				Use tFile Write tChunk
		    }
		} Else {
		    For  {
				Use tXDEV Read tChunk:0
				Quit:'$L(tChunk)
				Do pStream.Write(tChunk)
		    }
	    }
	} Catch e {
		If e.Name="<ENDOFFILE>" {
			Set tSC = $$$OK
		} Else {
			Set tSC = e.AsStatus()
		}
	}
		    
    Close tXDEV
	Use tIo

	// Need to ensure that LineTerminator is correct for the platform
	Set pStream.LineTerminator=$select($$$isUNIX:$char(10),1:$char(13,10))
	Quit tSC
}

/// This will either return a new string, or concatenate the XML onto the end of the existing string.
/// This method will not output blobs to the string, since they won't fit into a string.
/// See ToQuickXML on HS.SDA3.Blob for details.
Method ToQuickXMLString(ByRef pString As %String = "", pTag As %String = "") As %Status
{
	#dim tChunk As %String
	Set tSC=$$$OK,tBlobControlDefined=$D(%HSBlobMode)
	If 'tBlobControlDefined Set %HSBlobMode="ID"
	Set tIo=$io,tXDEV="|XDEV|"_$JOB Close tXDEV //just in case
    Open tXDEV:($ZF(-6,$$$XSLTLibrary,12):"":"S":/HOSTNAME="XSLT":/IOT=$S($$$IsUnicode:"UTF8",1:"RAW"):/IBU=16384:/OBU=16384)
	Use tXDEV
	Do ..ToQuickXML(pTag)
	If 'tBlobControlDefined Kill %HSBlobMode
	// Flush any remaining output
	Write *-3

	// As of IRIS 2019.2, reading past the end of an XDEV incurs an
	// ENDOFFILE error, but should be considered the same as what
	// was previously detected by Read tChunk:0 returning a blank
	// string - it's just the end of data and it's now time to quit.
	Try {
	    For  {
			Use tXDEV Read tChunk:0
			Quit:'$L(tChunk)
			Set pString=pString_tChunk
	    }
	} Catch e {
		If e.Name="<ENDOFFILE>" {
			Set tSC = $$$OK
		} Else {
			Set tSC = e.AsStatus()
		}
	}
		    
    Close tXDEV
	Use tIo

	Quit tSC
}

/// This will write the XML to the current device<br>
/// Input tag for top, data type from calling class (if called for an embedded object)<br>
/// Overridden on HS.SDA3.Blob
Method ToQuickXML(pTag As %String = "", pType As %String = "", pGroup = 0) [ CodeMode = generator, GenerateAfter = %XMLGenerate ]
{
	If $$$comClassKeyGet(%class,$$$cCLASSabstract) $$$GENERATE("	Quit $$$NULLOREF") Quit $$$OK
	#Define QT(%thing) """"_%thing_""""
	Set tSC=$$$OK
	Set q=$C(34),qq=q_q
	Set lt=$$$QT("<"), gt=$$$QT(">"), ltend=$$$QT("</")
	Set tClass=$P(%class,".",$L(%class,"."))
	IF $G(%parameter("ISCODETABLE")) {
		//check for and remove all-punctuation Code or Desc
		//for UoM ONLY, a percent sign is allowed
		IF tClass'="UoM" {
			$$$GENERATE("		If ..Code?1.P Set ..Code="_qq)
			$$$GENERATE("		If ..Description?1.P Set ..Description="_qq)
		}
		Else {
			$$$GENERATE("		If ..Code?1.P&&(..Code'=""%"") Set ..Code="_qq)
			$$$GENERATE("		If ..Description?1.P&&(..Description'=""%"") Set ..Description="_qq)
		}
		//generate code to check for null values
		$$$GENERATE("		If ..Code_..Description="_qq_" Quit")
	}
	$$$GENERATE("		Set:pTag="_qq_" pTag="_$$$QT(tClass))
	Set l(1)="		IF pType="_qq_"||(pType="_$$$QT(tClass)_") {Write "_q_"<"_q_" ,pTag,"_q_">"_q_"}"
	Set l(2)="		ElseIf pGroup {Set pTag="_$$$QT(tClass)_" Write "_q_"<"_tClass_">"_q_"}"
	Set l(3)="		Else {Write "_q_"<"_q_",pTag,"_q_" d5p1:type="_q_$$$QT(tClass_qq_" xmlns:d5p1="_q_$$$QT("http://www.w3.org/2001/XMLSchema-instance")_q_">")_"}"
	$$$GENERATE(l(1)) $$$GENERATE(l(2)) $$$GENERATE(l(3))
	//can't check %Extends, because the class being compiled might not yet exist
	if $G(%parameter("TRANSLATED")) {
		$$$GENERATE("		Do:$D(%HSTranslate("_$$$QT(tClass)_"),toSys) ..Translate(toSys)")
	}
	IF $G(%parameter("ISCODETABLE")) {
		$$$GENERATE("		Set:..Description="_qq_" ..Description=..Code")
		//generate code to compact data for streamlet storage
		$$$GENERATE("		If $D(%HSStreamlet) {")
		$$$GENERATE("			Set val="_qq_" Set:..Description'=..Code&&(..Description'="_qq_") val="_$$$QT("^")_"_..Description Set val=..SDACodingStandard_"_$$$QT("^")_"_..Code_val")
		Do NonObject($C(3),$C(3),"","	")
		$$$GENERATE("		} Else {")
		Do NonObject("Code","Code","..Code","	")
		Do NonObject("Description","Description","..Description","	")
		Do NonObject("SDACodingStandard","SDACodingStandard","..SDACodingStandard","	")
		$$$GENERATE("		}")
	}
	For tIndex=1:1:$G($$$xmlpropertycount(%class)) {
		Set item=$$$xmlgetitem(%class,tIndex)
	    Set membercat=$select(($$$xmlio(item)'="IN")&&($$$xmlio(item)'="SKIP"):$$$xmlmembercat(item),1:"")
	    Set property=$$$xmlproperty(item)
	    IF $$$xmlio(item)="IN"||($$$xmlio(item)="SKIP") CONTINUE
	    IF $G(%parameter("ISCODETABLE")),property="Code"||(property="Description")||(property="SDACodingStandard") Continue
	    Set xmlname=$$$xmlname(item)
	    Set xmlprojection=$$$xmlprojection(item)
	    Set xsdtype=$$$xmlxsdtype(item)
	    Set literaltype=$$$xmlliteraltype(item)
	    Set xmlelementref=$$$xmlelementref(item)
	    Set xmlitemname=$$$xmlitemname(item)
	    Set group=((xmlprojection["choice") || (xmlprojection["substitutiongroup"))
	    IF membercat["List" {
		    $$$GENERATE("		If r%"_property_" {")
		    $$$GENERATE("		Set aval=.."_property_",c=aval.Count()")
		    $$$GENERATE("		If c {")
		    $$$GENERATE("			Write "_$$$QT("<"_xmlname_">"))
		    $$$GENERATE("			F k=1:1:c {")
		    $$$GENERATE("				Set val=aval.GetAt(k)")
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			Set runtimeclasstype=$$$getClassType(runtimetype)
			If runtimetype["ListOfObj" {
				$$$GENERATE("				Do:$IsObject(val) val.ToQuickXML("_$$$QT(xmlitemname)_","_$$$QT(xmlitemname)_","_group_")")
			} ElseIf runtimetype["ListOfStream" {
				Do Bstream(xmlname_"Item","","		")
			} Else {
				Do NonObject(xmlname_"Item",property,"","		")
			} 
		    $$$GENERATE("			}")
		    $$$GENERATE("			Write "_$$$QT("</"_xmlname_">"))
		    $$$GENERATE("		}")
		    $$$GENERATE("		}")
	    } ElseIf membercat["Array" {
		    //array collections aren't supported.
		    /*
		    $$$GENERATE("		Set aval=.."_property_",got=0, k="_qq)
		    $$$GENERATE("		For {")
		    $$$GENERATE("			Set val=aval.GetNext(.k)")
		    $$$GENERATE("			If k="_qq_" {Write:got "_$$$QT("</"_xmlname_">")_" Quit}")
		    //***to do - does this swizzle null objects?
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			Set runtimeclasstype=$$$getClassType(runtimetype)
		    $$$GENERATE("			If 'got {Set got=1 Write "_$$$QT("<"_xmlname_">")_"}")
			If runtimetype["ListOfObj" {
				$$$GENERATE("		Do:$IsObject(val) val.ToQuickXML("_$$$QT($P(xsdtype,"+",2))_","_$$$QT($P(xsdtype,"+",2))_","_group_")")
			} ElseIf runtimetype["ListOfStream" {
				Do Bstream(xmlname_"Item","","	",xmlname_"Key")
			} Else {
				Do NonObject(xmlname_"Item",property,"","	",xmlname_"Key")
			} 
		    $$$GENERATE("		}")
		    */
	    } Else {
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			Set runtimeclasstype=$$$getClassType(runtimetype)
			If runtimeclasstype=$$$cCLASSCLASSTYPESERIAL||(runtimeclasstype=$$$cCLASSCLASSTYPEPERSISTENT) {
				//avoid swizzle for empty serial properties
				$$$GENERATE("		Do:r%"_property_" .."_property_".ToQuickXML("_$$$QT(xmlname)_","_$$$QT($P(runtimetype,".",$L(runtimetype,".")))_")")
			} ElseIf membercat["BSTREAM" {
				Do Bstream(xmlname,property,"")
			//***to do - character streams
			} Else {
				Do NonObject(xmlname,property,".."_property,"")
			} 
	    }
	}
	$$$GENERATE("	Write "_ltend_",pTag,"_gt_" Quit")
	$$$GENERATE("ToQuickXMLCdata(qval) Quit $Replace(qval,""]]>"",""]]]]><![CDATA[>"")")
	Quit tSC
	
Bstream(pXMLname,pProperty,tabs,key="")
		Set expr="" If pProperty'="" Set expr="val=.."_pProperty_","
		$$$GENERATE(tabs_"		Set "_expr_"len=120000 If val'="_qq_"&&'val.IsNull() {")
		If key="" {
			$$$GENERATE(tabs_"			Write "_$$$QT("<"_pXMLname_">")_" Do val.Rewind()")
		} Else {
			$$$GENERATE(tabs_"			Write "_$$$QT("<"_pXMLname_" "_key_"=")_$$$QT($$$QT(",k,"))_$$$QT(">")_" Do val.Rewind()")
		}
		$$$GENERATE(tabs_"			While 'val.AtEnd { Write $system.Encryption.Base64Encode(val.Read(.len)) }")
		$$$GENERATE(tabs_"			Write "_$$$QT("</"_pXMLname_">")_"}")
		Quit

NonObject(pXMLname,pProperty,pGetval,tabs,key="")
		Set expr="" If pGetval'="" Set expr="Set val="_pGetval
		$$$GENERATE(tabs_"		"_expr_" If val'="_qq_",val'="_qq_qq_qq_" {")
		//escape or toxsd
		If $$$comSubMemberDefined(%class,$$$cCLASSproperty,pProperty,$$$cPROPmethod,"LogicalToXSD") {
			Set expr=".."_pProperty_"LogicalToXSD(val)"
		} Else {
			Set expr="$select((val[""<"")||(val["">"")||(val[""&""):""<![CDATA[""_$select(val[""]]>"":$$ToQuickXMLCdata(val),1:val)_""]]>"",1:val)"
		}
		IF key="" {
			$$$GENERATE(tabs_"			Write "_$$$QT("<"_pXMLname_">")_","_expr_","_$$$QT("</"_pXMLname_">"))
		} Else {
			$$$GENERATE(tabs_"			Write "_$$$QT("<"_pXMLname_" "_key_"=")_$$$QT($$$QT(",k,"))_$$$QT(">")_","_expr_","_$$$QT("</"_pXMLname_">"))
		}
		$$$GENERATE(tabs_"		}")
}

Method Translate(pToCS)
{
	IF $D(%HSTranslate("*")) {
		//API hook for custom translation class
		Set toCode=..Code, toDesc=..Description
		Quit:'$ClassMethod(%HSTranslate("*"),"Map",..%ClassName(), ..SDACodingStandard, ..Code, ..Description, .pToCS,  .toCode,  .toDesc)
		Set:pToCS="" pToCS=..SDACodingStandard
	} Else {
		Quit:..SDACodingStandard=""  Quit:..Code=""  /* Quit:..SDACodingStandard=pToCS */
		Quit:'$D(^HS.Registry.TranslationMapD($ZCVT(..SDACodingStandard,"U"),pToCS,$ZCVT(..Code,"U")),map)
		If ..Description'=""&&$D(^HS.Registry.TranslationMapD($ZCVT(..SDACodingStandard,"U"),pToCS,$ZCVT(..Code,"U"),"DescriptionExceptions",$ZCVT(..Description,"U")),tExcept) {
			Set toCode=$P(tExcept,"||"),toDesc=$P(tExcept,"||",2)
		} Else {
			Set toCode=$LI(map,5),toDesc=$LI(map,6) Quit:toCode=""
		}
	}
	Set prior=##Class(HS.SDA3.PriorCode).%New(),prior.CodeSystem=..SDACodingStandard,prior.Code=..Code,prior.Description=..Description
	Set:..Description="" prior.Description=..Code
	Set type="O",c=..PriorCodes.Count() Set:c&&(..PriorCodes.GetAt(c).Type="O") type="N"
	Set prior.Type=type Do ..PriorCodes.Insert(prior)
	Set:..Description=..Code ..Description=toCode
	Set ..SDACodingStandard=pToCS,..Code=toCode Set:toDesc'="" ..Description=toDesc
}

/// Utility method to detect if a serial property is populated
/// without instantiating (swizzling) it
Method IsDefined(Property As %String) As %Boolean [ CodeMode = expression ]
{
@("r%"_Property)'=""
}

/// Generated update-from type of method.  Called by UpdateSDA method on streamlet.
/// pOmitProperties is an optional comma delimitted (starts with comma) list of
/// properties for which a streamlet class wants to override the usual behavior
/// and do its own thing, and therefore the generated code will omit them.
/// If pIsDeleted is true, then the streamlet containing this SDA has been marked as
/// deleted, and we need to clear out ALL SDA properties before updating.
/// Note that pIsDeleted does not override pOmitProperties - if pOmitProperties
/// is set, we will avoid clearing that property and rely on the property-specific
/// code to handle deleting the old values.
Method UpdateSDA(pFromObject, pOmitProperties As %String = "", pIsDeleted As %Boolean = 0) [ CodeMode = generator, GenerateAfter = %XMLGenerate ]
{
	If $$$comClassKeyGet(%class,$$$cCLASSabstract) $$$GENERATE("	Quit $$$NULLOREF") Quit $$$OK
	#Define QT(%thing) """"_%thing_""""
	Set tSC=$$$OK
	Set q=$C(34),qq=q_q
	Set tClass=$P(%class,".",$L(%class,"."))
	IF $G(%parameter("ISCODETABLE")) {
		//generate code to check for delete instructions
		$$$GENERATE("	If ..Code'="_qq_",..Code'=pFromObject.Code||(..SDACodingStandard'=pFromObject.SDACodingStandard) {")
		$$$GENERATE("		//clear all code table properties")
		For tIndex=1:1:$G($$$xmlpropertycount(%class)) {
			Set item=$$$xmlgetitem(%class,tIndex)
		    Set membercat=$select(($$$xmlio(item)'="IN")&&($$$xmlio(item)'="SKIP"):$$$xmlmembercat(item),1:"")
		    Set property=$$$xmlproperty(item),chkprop=","_property_","
		    IF $$$xmlio(item)="IN"||($$$xmlio(item)="SKIP") CONTINUE
		    IF membercat["List" {$$$GENERATE("		Do .."_property_".Clear()")}
		    ELSE {$$$GENERATE("		Set .."_property_"="_qq)}
		}
		$$$GENERATE("	}")
	}
	$$$GENERATE("	If (pIsDeleted){")
		For tIndex=1:1:$G($$$xmlpropertycount(%class)) {
			Set item=$$$xmlgetitem(%class,tIndex)
		    Set membercat=$select(($$$xmlio(item)'="IN")&&($$$xmlio(item)'="SKIP"):$$$xmlmembercat(item),1:"")
		    Set property=$$$xmlproperty(item),chkprop=","_property_","
		    Set cond=""
		    If (","_%parameter("CANOVERRIDEPROPLIST")_",")[chkprop Set cond=":(pOmitProperties'["_$$$QT(chkprop)_")"
		    If $$$xmlio(item)="IN"||($$$xmlio(item)="SKIP") CONTINUE
		    If membercat["List" {$$$GENERATE("		Do"_cond_" .."_property_".Clear()")}
		    Else {$$$GENERATE("		Set"_cond_" .."_property_"="_qq)}
		}
	$$$GENERATE("	}")
	For tIndex=1:1:$G($$$xmlpropertycount(%class)) {
		Set item=$$$xmlgetitem(%class,tIndex)
	    Set membercat=$select(($$$xmlio(item)'="IN")&&($$$xmlio(item)'="SKIP"):$$$xmlmembercat(item),1:"")
	    Set property=$$$xmlproperty(item),chkprop=","_property_","
	    Set cond="", condc="", condif=""
	    If (","_%parameter("CANOVERRIDEPROPLIST")_",")[chkprop Set cond="pOmitProperties'["_$$$QT(chkprop),condc=":"_cond,condif=cond_","
	    IF $$$xmlio(item)="IN"||($$$xmlio(item)="SKIP") CONTINUE
	    IF membercat["List" {
		    Set cond=cond_$S(cond'="":",",1:"")_"pFromObject.IsDefined("_$$$QT(property)_")"
		    If cond'="" {$$$GENERATE("	If "_cond_" {")}
		    Set tab=$S(cond="":"",1:$C(9))
		    $$$GENERATE(tab_"	Set aval=pFromObject."_property_",c=aval.Count(),j=0")
		    $$$GENERATE(tab_"	If c {")
		    $$$GENERATE(tab_"		Do .."_property_".Clear()")
		    $$$GENERATE(tab_"		F k=1:1:c {")
		    $$$GENERATE(tab_"			Set val=aval.GetAt(k)")
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			Set runtimeclasstype=$$$getClassType(runtimetype)
			If runtimetype["ListOfObj" {
				Set xmltype=$$$xmltype(item)
				$$$GENERATE(tab_"			Do:$IsObject(val) .."_property_".Insert(##Class("_xmltype_").%New()),.."_property_".GetAt($I(j)).UpdateSDA(pFromObject."_property_".GetAt(k),,pIsDeleted)")
			} ElseIf runtimetype["ListOfStream" {
				//we don't do lists of streams
			} Else {
				$$$GENERATE(tab_"			If val'="_qq_qq_qq_",val'="_qq_" Do .."_property_".Insert(val)")
			} 
		    $$$GENERATE(tab_"		}")
		    $$$GENERATE(tab_"	}")
		    If cond'="" {$$$GENERATE("	}")}
	    } ElseIf membercat["Array" {
		    //we don't do array collections in SDA3, only lists
	    } Else {
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			Set runtimeclasstype=$$$getClassType(runtimetype)
			If runtimeclasstype=$$$cCLASSCLASSTYPESERIAL||(runtimeclasstype=$$$cCLASSCLASSTYPEPERSISTENT) {
				//avoid swizzle for empty serial properties
				$$$GENERATE("	If "_condif_"pFromObject.IsDefined("_$$$QT(property)_") {Set:.."_property_"="_qq_" .."_property_"=##class("_runtimetype_").%New() Do .."_property_".UpdateSDA(pFromObject."_property_",,pIsDeleted)}")
			} ElseIf membercat["BSTREAM" {
				$$$GENERATE("	If "_condif_"pFromObject.IsDefined("_$$$QT(property)_") Do .."_property_".Clear(1),.."_property_".CopyFrom(pFromObject."_property_")")
				//$$$GENERATE("	Do"_condc_" .."_property_".CopyFrom(pFromObject."_property_")")
			//*** we don't do character streams either
			} Else {
				$$$GENERATE("	Set val=pFromObject."_property_" If "_condif_"val'="_qq_" Set .."_property_"=$S(val="_qq_qq_qq_":"_qq_",1:val)")
			} 
	    }
	}
	$$$GENERATE("	Quit")
	Quit tSC
}

/// If pTag is input, it will use that as the opening tag, assuming that it has been stripped out.
/// Otherwise, it will grab the opening tag as the first tag in the string.<br>
/// Assumes SDAString as stored in streamlet - no white space, only streams are binary, single instance, no arrays<br>
/// Need to "new" the initial object.<br>
/// pPos is internal, for nesting<br>
/// pStreamlet is an optional argument indicating that we're invoking this from a streamlet where we've just done
/// a %OpenId. Code tables are handled differently when we have a pStreamlet.<br>
/// For instantiating data from a full stream, we can default in the coding system (from the profile and the description from the code registry,
/// to support external feeds). For streamlet instantiation, we can deal with the more concise manner of storing code, code system, and description.<br>
/// pContainer is an optional argument used only by the GetNextSDA method on HS.SDA3.Container - it has the container's ORef,
/// to enable it to treat the SDA String as a moving window on the stream being processed by the container.<br>
/// This method is overridden in HS.SDA3.Blob.
Method XMLImportSDAString(ByRef pSDAString, pTag = "", ByRef pPos = 1, pStreamlet = "", pContainer = "") As %Status [ CodeMode = generator, GenerateAfter = %XMLGenerate ]
{
	If $$$comClassKeyGet(%class,$$$cCLASSabstract) $$$GENERATE("	Quit $$$NULLOREF") Quit $$$OK
	#Define QT(%thing) """"_%thing_""""
	#Define QT2(%thing,%thing2) """"_%thing_""""_":"_""""_%thing2_""""
	Set tSC=$$$OK
	Set q=$C(34),qq=q_q
	Set lt=$$$QT("<"), gt=$$$QT(">"), ltend=$$$QT("</")
	Set tClass=$P(%class,".",$L(%class,"."))
	$$$GENERATE("	Set tSC=$$$OK")
	$$$GENERATE("	IF pTag="_qq_" Do PopTag Set pTag=tTag")
	$$$GENERATE("	Set tMyEnd="_q_"/"_q_"_pTag")
	$$$GENERATE("	For {")
	$$$GENERATE("		Quit:$$$ISERR(tSC)  Do PopTag Quit:tTag=tMyEnd")
	IF $G(%parameter("ISCODETABLE")) {
		$$$GENERATE("		If tTag=$C(3) {Do GetVal Set ..SDACodingStandard=$P(val,"_$$$QT("^")_"),..Code=$P(val,"_$$$QT("^")_",2),..Description=$P(val,"_$$$QT("^")_",3,99) Set:..Description="_qq_" ..Description=..Code CONTINUE}")
	}
	$$$GENERATE("		If tTag'?1A.AN Continue:$E(tTag,*)="_q_"/"_q_"  Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("Bad Tag: ")_"_tTag) Quit")
	For tIndex=1:1:$G($$$xmlpropertycount(%class)) {
		Set item=$$$xmlgetitem(%class,tIndex)
	    Set membercat=$select(($$$xmlio(item)'="OUT")&&($$$xmlio(item)'="SKIP"):$$$xmlmembercat(item),1:"")
	    Set property=$$$xmlproperty(item),tTag=property
	    IF $$$xmlio(item)="OUT"||($$$xmlio(item)="SKIP") CONTINUE
	    Set xmlname=$$$xmlname(item)
	    Set xmlprojection=$$$xmlprojection(item)
	    Set xsdtype=$$$xmlxsdtype(item)
	    Set literaltype=$$$xmlliteraltype(item)
	    Set xmlelementref=$$$xmlelementref(item)
	    Set group=((xmlprojection["choice") || (xmlprojection["substitutiongroup"))
   	    $$$GENERATE("		If tTag="_$$$QT(property)_" {")
	    IF membercat["List" {
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			If runtimetype["ListOfObj" {
				Set xmltype=$$$xmltype(item)
				$$$GENERATE("			For { Do PopTag Quit:tTag="_q_"/"_tTag_q)
				$$$GENERATE("				If tTag'="_$$$QT($P(xmltype,".",$L(xmltype,".")))_" Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("Bad Tag: ")_"_tTag) Quit")
				$$$GENERATE("				Set tObj=##class("_xmltype_").%New(),tSC=tObj.XMLImportSDAString(.pSDAString,tTag,.pPos,pStreamlet,.pContainer) Quit:$$$ISERR(tSC)  Do .."_property_".Insert(tObj)")
				$$$GENERATE("			} Quit:$$$ISERR(tSC)  CONTINUE}")
			} Else {
				If $$$comSubMemberDefined(%class,$$$cCLASSproperty,property,$$$cPROPmethod,"XSDToLogical") {
					Set expr=".."_property_"XSDToLogical(val)"
				} Else {Set expr="val"}
				$$$GENERATE("			For { Do PopTag Quit:tTag="_q_"/"_tTag_q)
				$$$GENERATE("				If tTag'="_$$$QT(xmlname_"Item")_" Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("Bad Tag: ")_"_tTag) Quit")
				$$$GENERATE("				Do GetVal,.."_property_".Insert("_expr_")")
				$$$GENERATE("			} Quit:$$$ISERR(tSC)  CONTINUE}")
			} 
	    } Else {
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			Set runtimeclasstype=$$$getClassType(runtimetype)
			If runtimeclasstype=$$$cCLASSCLASSTYPESERIAL||(runtimeclasstype=$$$cCLASSCLASSTYPEPERSISTENT) {
				$$$GENERATE("			Set .."_property_"=##class("_runtimetype_").%New(),tSC=.."_property_".XMLImportSDAString(.pSDAString,tTag,.pPos,pStreamlet,.pContainer) CONTINUE}")
			} ElseIf membercat["BSTREAM" {
				$$$GENERATE("			Do GetVal Set .."_property_"=##Class(%GlobalBinaryStream).%New() Do .."_property_".Write($system.Encryption.Base64Decode(val)) CONTINUE}")
			} Else {
				If $$$comSubMemberDefined(%class,$$$cCLASSproperty,property,$$$cPROPmethod,"XSDToLogical") {
					Set expr=".."_property_"XSDToLogical(val)"
				} Else {Set expr="val"}
				If $G(%parameter("ISCODETABLE"))&&((property="Code")||(property="Description")) {
					// Normally a CodeTableDetail may not be only punctuation, but UoM is a special case,
					// it may be a percent sign (%). There is a similar exception in ToQuickXML().
					If %class="HS.SDA3.CodeTableDetail.UoM" {
						$$$GENERATE("			Do GetVal Set:$ZSTRIP(val,""*PW"",,""%"")'=""""||(val=$C(34,34)) .."_property_"="_expr_" CONTINUE}")
					}
					Else {
						$$$GENERATE("			Do GetVal Set:$ZSTRIP(val,""*PW"")'=""""||(val=$C(34,34)) .."_property_"="_expr_" CONTINUE}")
					}
				}
				Else {	$$$GENERATE("			Do GetVal Set .."_property_"="_expr_" CONTINUE}") }
			}
	    }
	}
	//handle bad non-object tag
	$$$GENERATE("		Do ..LogIgnoredTag(tTag)")
	$$$GENERATE("		If $E(pSDAString,pPos,pPos+8)=""<![CDATA[""||($E(pSDAString,pPos)'=""<"") Do GetVal CONTINUE")
	//handle bad object tag
	$$$GENERATE("			Set tSC=..XMLImportSDAStringUnknown(.pSDAString,tTag,.pPos) CONTINUE")
	$$$GENERATE("	}")
	IF $G(%parameter("ISCODETABLE")) {
		$$$GENERATE("	If 'pStreamlet {")
		$$$GENERATE("		If ..SDACodingStandard="_qq_" Set ..SDACodingStandard=$G(%HSCodeSystem("_q_$P(%class,".",$L(%class,"."))_q_"))")
		$$$GENERATE("		If ..Description="_qq_"||(..Description=..Code),..SDACodingStandard'="_qq_",..Code'="_qq_",$D(^HS.Registry.CodesD($ZCVT(..SDACodingStandard,""U""),$ZCVT(..Code,""U"")),tList) {Set ..Description=$LI(tList,4)}")
		$$$GENERATE("	} ")
	}
	$$$GENERATE("	QUIT tSC")
	$$$GENERATE("GetVal IF $E(pSDAString,pPos,pPos+8)="_q_"<![CDATA["_q_" {")
	$$$GENERATE("		Set val="_qq_" For {")
	$$$GENERATE(" 			Set pPos=pPos+9,f=$F(pSDAString,"_q_"]]>"_q_",pPos)")
	$$$GENERATE(" 			If (f=0) { Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("SDA XML Import error: unterminated CDATA section in ")_"_tTag) }")
	$$$GENERATE("    		If ($E(pSDAString,f-5,f+9)="_q_"]]]]><![CDATA[>"_q_") { Set val=val_$E(pSDAString,pPos,f-6),pPos=f+10  }")
 	$$$GENERATE("			Else { Set val=val_$E(pSDAString,pPos,f-4),pPos=f }")
	$$$GENERATE("    		Quit:$E(pSDAString,pPos,pPos+8)'="_q_"<![CDATA["_q)
	$$$GENERATE("		}")
	$$$GENERATE("		Quit:'tSC")
	$$$GENERATE("	} Else {Set f=$F(pSDAString,"_lt_",pPos),val=$E(pSDAString,pPos,f-2),pPos=f-1")
	$$$GENERATE("		If (f=0) {Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("SDA XML Import Error: Unterminated Tag caused by exceeding streamlet size - Tag: ")_"_tTag) } ")	
	$$$GENERATE("		Set:val["_$$$QT("&")_" val=$ZCVT(val,"_$$$QT("I")_","_$$$QT("XML")_")")
	$$$GENERATE("	}")
	$$$GENERATE("PopTag Set f=$F(pSDAString,"_gt_",pPos),tTag=$E(pSDAString,pPos+1,f-2),pPos=f G PopTag:$E(tTag,*)="_$$$QT("/")_" Quit")
	Quit tSC
}

Method XMLImportSDAStringUnknown(ByRef pSDAString, pTag = "", ByRef pPos) As %Status
{
	Set tSC=1
	IF pTag="" Do PopTagX Set pTag=tTag
	Set tMyEnd="/"_pTag
	For {
		Quit:('tSC)  Do PopTagX Quit:tTag=tMyEnd
		If tTag'?1A.AN Continue:$E(tTag,*)="/"  Set tSC = $$Error^%apiOBJ(5001,"Bad Tag: "_tTag) Quit
		If $E(pSDAString,pPos,pPos+8)="<![CDATA["||($E(pSDAString,pPos)'="<") Do SkipVal CONTINUE
			Set tSC=..XMLImportSDAStringUnknown(.pSDAString,tTag,.pPos) CONTINUE
	}
	QUIT tSC
	
SkipVal IF $E(pSDAString,pPos,pPos+8)="<![CDATA[" {
		For {
 			Set pPos=pPos+9,f=$F(pSDAString,"]]>",pPos)
 			If (f=0) { Set tSC = $$Error^%apiOBJ(5001,"SDA XML Import error: unterminated CDATA section in "_tTag) }
    		If ($E(pSDAString,f-5,f+9)="]]]]><![CDATA[>") { Set pPos=f+10  }
			Else { Set pPos=f }
    		Quit:$E(pSDAString,pPos,pPos+8)'="<![CDATA["
		}
		Quit:'tSC
	} Else {Set f=$F(pSDAString,"<",pPos),pPos=f-1
	}
PopTagX Set f=$F(pSDAString,">",pPos),tTag=$E(pSDAString,pPos+1,f-2),pPos=f G PopTagX:$E(tTag,*)="/" Quit
}

ClassMethod LogIgnoredTag(pTag)
{
	If $$$HSTRACINGCALLED {$$$LOGWARNING("Ignored Tag: "_pTag)}
}

ClassMethod SDAStringToArray(ByRef pArray, pSDAString, pTag = "", ByRef pPos = 1) As %Status [ CodeMode = generator, GenerateAfter = %XMLGenerate, Internal ]
{
	If $$$comClassKeyGet(%class,$$$cCLASSabstract) $$$GENERATE("	Quit $$$NULLOREF") Quit $$$OK
	#Define QT(%thing) """"_%thing_""""
	#Define QT2(%thing,%thing2) """"_%thing_""""_":"_""""_%thing2_""""
	Set tSC=$$$OK
	Set q=$C(34),qq=q_q
	Set lt=$$$QT("<"), gt=$$$QT(">"), ltend=$$$QT("</")
	Set tClass=$P(%class,".",$L(%class,"."))
	$$$GENERATE("	Set tSC=$$$OK")
	$$$GENERATE("	IF pTag="_qq_" Do PopTagA Set pTag=tTag")
	$$$GENERATE("	Set tMyEnd="_q_"/"_q_"_pTag")
	$$$GENERATE("	For {")
	$$$GENERATE("		Quit:$$$ISERR(tSC)  Do PopTagA Quit:tTag=tMyEnd")
	$$$GENERATE("		If tTag'?1A.AN Continue:$E(tTag,*)="_q_"/"_q_"  Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("Bad Tag: ")_"_tTag) Quit")
	For tIndex=1:1:$G($$$xmlpropertycount(%class)) {
		Set item=$$$xmlgetitem(%class,tIndex)
	    Set membercat=$select(($$$xmlio(item)'="OUT")&&($$$xmlio(item)'="SKIP"):$$$xmlmembercat(item),1:"")
	    Set property=$$$xmlproperty(item),tTag=property
	    IF $$$xmlio(item)="OUT"||($$$xmlio(item)="SKIP") CONTINUE
	    Set xmlname=$$$xmlname(item)
	    Set xmlprojection=$$$xmlprojection(item)
	    Set xsdtype=$$$xmlxsdtype(item)
	    Set literaltype=$$$xmlliteraltype(item)
	    Set xmlelementref=$$$xmlelementref(item)
	    Set group=((xmlprojection["choice") || (xmlprojection["substitutiongroup"))
   	    $$$GENERATE("		If tTag="_$$$QT(property)_" {")
	    IF membercat["List" {
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			If runtimetype["ListOfObj" {
				Set xmltype=$$$xmltype(item)
				$$$GENERATE("			For { Do PopTagA Quit:tTag="_q_"/"_tTag_q)
				$$$GENERATE("				If tTag'="_$$$QT($P(xmltype,".",$L(xmltype,".")))_" Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("Bad Tag: ")_"_tTag) Quit")
				//$$$GENERATE("				Set tObj=##class("_xmltype_").%New(),tSC=tObj.XMLImportSDAString(.pSDAString,tTag,.pPos,pStreamlet) Quit:$$$ISERR(tSC)  Do .."_property_".Insert(tObj)")
				$$$GENERATE("				Set tCnt=$I(@pArray@("_$$$QT(property)_",0))")
				$$$GENERATE("				Do ##class("_xmltype_").SDAStringToArray($Name(@pArray@("_$$$QT(property)_",tCnt)),.pSDAString,tTag,.pPos)")
				$$$GENERATE("			} Quit:$$$ISERR(tSC)  CONTINUE}")
			} Else {
				If $$$comSubMemberDefined(%class,$$$cCLASSproperty,property,$$$cPROPmethod,"XSDToLogical") {
					Set expr=".."_property_"XSDToLogical(val)"
				} Else {Set expr="val"}
				$$$GENERATE("			For { Do PopTagA Quit:tTag="_q_"/"_tTag_q)
				$$$GENERATE("				If tTag'="_$$$QT(xmlname_"Item")_" Set tSC = $$Error^%apiOBJ(5001,"_$$$QT("Bad Tag: ")_"_tTag) Quit")
				$$$GENERATE("				Set tCnt=$I(@pArray@("_$$$QT(property)_",0))")
				$$$GENERATE("				Do GetValA Set @pArray@("_$$$QT(property)_",tCnt)="_expr)
				$$$GENERATE("			} Quit:$$$ISERR(tSC)  CONTINUE}")
			} 
	    } Else {
	   		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,property,$$$cPROPruntimetype)
			Set runtimeclasstype=$$$getClassType(runtimetype)
			If runtimeclasstype=$$$cCLASSCLASSTYPESERIAL||(runtimeclasstype=$$$cCLASSCLASSTYPEPERSISTENT) {
				$$$GENERATE("			Do ##class("_runtimetype_").SDAStringToArray($Name(@pArray@("_$$$QT(property)_")),.pSDAString,tTag,.pPos) CONTINUE}")
			} ElseIf membercat["BSTREAM" {
				$$$GENERATE("			Do GetValA Set @pArray@("_$$$QT(property)_")=val CONTINUE}")
			} Else {
				If $$$comSubMemberDefined(%class,$$$cCLASSproperty,property,$$$cPROPmethod,"XSDToLogical") {
					Set expr=".."_property_"XSDToLogical(val)"
				} Else {Set expr="val"}
				$$$GENERATE("			Do GetValA Set @pArray@("_$$$QT(property)_")="_expr_" CONTINUE}")
			}
	    }
	}
	$$$GENERATE("	}")
	$$$GENERATE("	QUIT tSC")
	$$$GENERATE("GetValA IF $E(pSDAString,pPos,pPos+8)="_q_"<![CDATA["_q_" {")
	$$$GENERATE("		Set val="_qq_" For {")
	$$$GENERATE(" 		Set pPos=pPos+9,f=$F(pSDAString,"_q_"]]>"_q_",pPos)")
	$$$GENERATE("			Set val=val_$E(pSDAString,pPos,f-4),pPos=f Quit:$E(pSDAString,pPos,pPos+8)'="_q_"<![CDATA["_q)
	$$$GENERATE("		}")
	$$$GENERATE("	} Else {Set f=$F(pSDAString,"_lt_",pPos),val=$E(pSDAString,pPos,f-2),pPos=f-1")
	$$$GENERATE("		Set:val["_$$$QT("&")_" val=$ZCVT(val,"_$$$QT("I")_","_$$$QT("XML")_")")
	$$$GENERATE("	}")
	$$$GENERATE("PopTagA Set f=$F(pSDAString,"_gt_",pPos),tTag=$E(pSDAString,pPos+1,f-2),pPos=f G PopTagA:$E(tTag,*)="_$$$QT("/")_" Quit")
	Quit tSC
}

}
