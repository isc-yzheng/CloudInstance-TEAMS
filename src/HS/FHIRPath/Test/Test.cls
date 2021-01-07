Class HS.FHIRPath.Test.Test Extends %RegisteredObject
{

/// Test the parser on an input string
ClassMethod parse(text As %String, debug = 0)
{
	Set obj = ##class(HS.FHIRPath.Parser).%New()
	//w "In: ",text,!
	#dim expr as Node = obj.parse(text, debug)
	
	Do expr.showTree()
	return expr
}

ClassMethod lex(text As %String)
{
	#dim lexer as Lexer = ##class(HS.FHIRPath.Lexer).%New()
	do lexer.lex(text, .tokens)
	#dim token as Token
	set ix = ""
	for {
		Set ix = $Order(tokens(ix), 1, token)
		Quit:ix=""
		
		w ix,": ",token.asString(), !
	}
}

ClassMethod dt(resourceType As %String, str As %String, mdKey As %String = "HL7v40", trace As %Boolean = 0) As %DynamicObject
{
	Set fpAPI = ##class(HS.FHIRPath.API).getInstance(mdKey, trace)
	Set node = fpAPI.parse(str)
	Do fpAPI.getPathAndType(resourceType, node, .contextPath, .fhirType)
	Set resolveInfo = $S($D(fhirType("r"),resolveType):" (if type="_resolveType_")", 1:"")
	Set variantInfo = $S($D(fhirType("vt"),typeList):" ("_$LTS(typeList)_")", 1:"")
	Set targetInfo = $S($D(fhirType("tl"),targetList):" to ("_$LTS(targetList)_")", 1:"")
	w $S(fhirType("mv"):"MultiValue ",1:""),"Type: ",fhirType, $S(fhirType("ar"):"[]",1:""),$S(resolveInfo="":targetInfo, 1:resolveInfo),variantInfo,", Path: ",$LTS(contextPath),!
}

ClassMethod test(str As %String, resource As %String = "", mdKey As %String = "HL7v40", trace As %Boolean = 0) As %DynamicObject
{
	Set fpAPI = ##class(HS.FHIRPath.API).getInstance(mdKey, trace)
	Set node = fpAPI.parse(str)
	if resource="" {
		set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId($classname() _ "||Test1", .tSC)
		$$$ThrowOnError(tSC)
		// Copy the JSON Stream to the output
		Set resource = ##class(%DynamicObject).%FromJSON(tXDataObj.Data)
		//Set resource = ##class(HS.FHIRServer.Schema).LoadJSONFromXData($classname() _ "||Test1")
	}
	Do interpreter.evaluate(resource, node, .result)
	zw result
}

ClassMethod utest(trace As %Boolean = 0, text = "")
{
	#dim mdKey As %String = "HL7v40"
	#dim fpAPI as HS.FHIRPath.API = ##class(HS.FHIRPath.API).getInstance(mdKey, trace)
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId("HS.FHIRPath.Test.Test||Test1", .tSC)
	$$$ThrowOnError(tSC)
	Set resource = ##class(%DynamicObject).%FromJSON(tXDataObj.Data)
	if text '= "" {
		do oneTest(text)
	} else {
		do oneTest("Practitioner.qualification.issuer.where(resolve() is Organization)")
		do oneTest("Practitioner.qualification.issuer.where(resolve() is Patient)")
		do oneTest("Practitioner.notAField")
		do oneTest("Practitioner.name.where(family = 'Shaw')")
		do oneTest("Practitioner.name.given")
		do oneTest("Practitioner.name.family")
		do oneTest("Practitioner.name")
		do oneTest("Practitioner.name[0]")
		do oneTest("Practitioner.name[1]")
		do oneTest("Practitioner.name.where(family = 'Shaw')")
		do oneTest("Practitioner.name.where(family = 'Cooper').text")
		do oneTest("'string1' + ' and ' + 'string2'")
		do oneTest("5 + 3")
		do oneTest("Practitioner.name.given[0] + ' ' + Practitioner.name.family[0]")
		do oneTest("extension.where(url='http://intersystems.com/fhir/extn/sda3/lib/code-table-detail-care-provider-description').valueString")
		do oneTest("extension.where(url='http://intersystems.com/fhir/extn/sda3/lib/code-table-detail-care-provider-description').value as string")
		do oneTest("extension.where(url='http://intersystems.com/fhir/extn/sda3/lib/code-table-detail-care-provider-description').extension.where(url='type').valueString")
		do oneTest("photo.empty()")
		do oneTest("photo.exists()")
		do oneTest("name.empty()")
		do oneTest("name.exists()")
		do oneTest("name.exists(family = 'Shaw')")
		do oneTest("name.exists(family = 'Trump')")
		do oneTest("name is HumanName")
		
	}
	Quit
oneTest(str)	
	set %fpdepth = 0
	w "Path: ", str," ...",!
	set startParseTime = $ZH
	Set node = fpAPI.parse(str)
	Set endParseTime = $ZH
	do:trace node.showTree()
	Set ser = fpAPI.serializeParseTree(node)
	set startDsTime = $ZH
	Set node2 = fpAPI.deserializeParseTree(ser)
	set endDsTime = $ZH
	set startEvalTime = $ZH
	Set result = fpAPI.evaluateToJson(resource, node2)
	set endEvalTime = $ZH
	Set eval = (endEvalTime - startEvalTime)*1000000
	Set parse = (endParseTime - startParseTime)*1000000
	Set ds = (endDsTime - startDsTime)*1000000
	w "[t=",parse,"/",ds,"/",eval, " uSec.] -> ", result.%ToJSON(),!
}

XData Test1 [ MimeType = application/json ]
{
{
        "resourceType": "Practitioner",
        "extension": [
          {
            "url": "http://intersystems.com/fhir/extn/sda3/lib/code-table-detail-care-provider-description",
            "valueString": "Moore, James",
	        "extension": [
	          {
	            "url": "type",
	            "valueString": "Radiologist"
	          }
	          ]
          },
          {
            "url": "http://test-url",
            "valueString": "Test Value"
          }
        ],
        "identifier": [
          {
            "value": "ISCGP001"
          }
		],
        "name": [
          {
            "family": "Cooper",
            "given": [
              "James",
              "Fenimore"
            ],
            "text": "James Fenimore Cooper"
          },
          {
            "family": "Shaw",
            "given": [
              "George",
              "Bernard"
            ],
            "text": "G B Shaw"
          }],
        "qualification": {
	        "issuer": { "reference": "Organization/1234"}
        },
        "id": "5",
        "meta": {
          "lastUpdated": "2020-06-03T21:05:10Z",
          "versionId": "1"
        }
}
}

}
