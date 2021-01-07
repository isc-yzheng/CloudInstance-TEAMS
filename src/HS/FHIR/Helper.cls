Include HS.FHIR.Errors

IncludeGenerator HS.FHIR.Errors

/// FHIR REST Helper class
Class HS.FHIR.Helper [ DependsOn = HS.FHIR.Utils ]
{

/// Local version of %ClassName(1) because we have no superclass to provide this
ClassMethod ClassName() As %String [ CodeMode = generator ]
{
	$$$GENERATE("	Quit """_%classname_"""")
}

/// Metadata capturing the allowed FHIR-REST interactions
XData HTTPMetadata
{
<Metadata>
<Status code="100">Continue</Status>
<Status code="101">Switching Protocols</Status>
<Status code="102">Processing</Status>
<Status code="200">OK</Status>
<Status code="201">Created</Status>
<Status code="202">Accepted</Status>
<Status code="203">Non-Authoritative Information</Status>
<Status code="204">No Content</Status>
<Status code="205">Reset Content</Status>
<Status code="206">Partial Content</Status>
<Status code="207">Multi-Statu</Status>
<Status code="208">Already Reporte</Status>
<Status code="226">IM Used</Status>
<Status code="300">Multiple Choices</Status>
<Status code="301">Moved Permanently</Status>
<Status code="302">Found</Status>
<Status code="303">See Other</Status>
<Status code="304">Not Modified</Status>
<Status code="305">Use Proxy</Status>
<Status code="307">Temporary Redirect</Status>
<Status code="308">Permanent Redirect</Status>
<Status code="400">Bad Request</Status>
<Status code="401">Unauthorized</Status>
<Status code="402">Payment Required</Status>
<Status code="403">Forbidden</Status>
<Status code="404">Not Found</Status>
<Status code="405">Method Not Allowed</Status>
<Status code="406">Not Acceptable</Status>
<Status code="407">Proxy Authentication Required</Status>
<Status code="408">Request Timeout</Status>
<Status code="409">Conflict</Status>
<Status code="410">Gone</Status>
<Status code="411">Length Required</Status>
<Status code="412">Precondition Failed</Status>
<Status code="413">Payload Too Large</Status>
<Status code="414">URI Too Long</Status>
<Status code="415">Unsupported Media Type</Status>
<Status code="416">Range Not Satisfiable</Status>
<Status code="417">Expectation Failed</Status>
<Status code="422">Unprocessable Entity</Status>
<Status code="423">Locked</Status>
<Status code="424">Failed Dependency</Status>
<Status code="426">Upgrade Required</Status>
<Status code="428">Precondition Require</Status>
<Status code="429">Too Many Requests</Status>
<Status code="431">Request Header Fields Too Large</Status>
<Status code="500">Internal Server Error</Status>
<Status code="501">Not Implemented</Status>
<Status code="502">Bad Gateway</Status>
<Status code="503">Service Unavailable</Status>
<Status code="504">Gateway Timeout</Status>
<Status code="505">HTTP Version Not Supported</Status>
<Status code="506">Variant Also Negotiated</Status>
<Status code="507">Insufficient Storage</Status>
<Status code="508">Loop Detected</Status>
<Status code="509">Unassigned</Status>
<Status code="510">Not Extended</Status>
<Status code="511">Network Authentication Required</Status>
</Metadata>
}

/// This is the Schema which defines the form of the metadata
XData HTTPMetadataSchema [ Internal ]
{
<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" >

<xs:element name="Metadata">
<xs:complexType>
<xs:choice  minOccurs="0" maxOccurs="unbounded">
<xs:element name="Status">
<xs:complexType>
<xs:simpleContent>
<xs:extension base="string">
<xs:attribute name="code" type="string" use="required"/>
</xs:extension>
</xs:simpleContent>
</xs:complexType>
</xs:element>
</xs:choice>
</xs:complexType>
</xs:element>

<xs:simpleType name="string">
<xs:restriction base="xs:string">
<xs:minLength value="1"/>
</xs:restriction>
</xs:simpleType>

</xs:schema>
}

/// Given an HTTP code, generate a proper HTTP Status string.
ClassMethod LookupHTTPStatusText(pHTTPCode As %String, ByRef pHTTPStatus As %String) As %Status [ CodeMode = generator ]
{
    #dim tStatus As %Status = $$$OK
    Try {
        
	    #dim tXDATA As %String = "HTTPMetadata"        
	    #dim tChild As %String
        #dim tCode As %String
        #dim tText As %String
        #dim tSubChild As %String
	    #dim tMap
	    
        
	    Set tStatus = ##class(HS.FHIR.Utils).GetMetadataFromXDATA(%classname,tXDATA,.tMap)
	    Quit:$$$ISERR(tStatus)

        $$$GENERATE("	Set pHTTPStatus = $CASE(+pHTTPCode,")
        
        // Walk the XML metadata and generate
        Set tChild=""
        For {
            Set tChild=$Order(tMap(1,"c",tChild))
            Quit:tChild=""
            
            If tMap(tChild)="Status" {
                	                
                Set tCode = tMap(tChild,"a","code")
                Set tText = ""
                
                Set tSubChild = ""
                For {
	                Set tSubChild = $ORDER(tMap(tChild,"c",tSubChild))
	                Quit:tSubChild=""
	             
	             	Set:tText'="" tText = tText_" "
	             	Set tText = tText_$GET(tMap(tSubChild))
                }

                $$$GENERATE("		"_+tCode_":"""_tText_""",")
                
            } Else {
                
                Set tStatus=$$$ERROR($$$HSFHIRXErrInvalidMetadata,tXDATA)
                Quit
            }
        }
        $$$GENERATE("		:"""")")
        $$$GENERATE("	Quit $SELECT(pHTTPStatus="""":$$$ERROR($$$HSFHIRXErrHTTPStatus,pHTTPCode),1:$$$OK)")
        
    } Catch (tEx) {
        Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// 
/// Helper to parse a HTTP status code in order to determine "success"
/// 
ClassMethod HttpSuccess(pStatus As %String) As %Boolean [ CodeMode = expression ]
{
(+pStatus'<200) && (+pStatus'>299)
}

}
