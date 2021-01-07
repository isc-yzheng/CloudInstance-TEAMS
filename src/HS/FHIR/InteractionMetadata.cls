Include HS.FHIR.Errors

IncludeGenerator HS.FHIR.Errors

/// FHIR REST Helper class
Class HS.FHIR.InteractionMetadata Extends %RegisteredObject [ DependsOn = HS.FHIR.Utils ]
{

/// Interaction name
Property Interaction As %String [ Required ];

/// HTTP Method
Property Method As %String [ Required ];

/// URL Specification/pattern
Property UrlSpec As %String(MAXLEN = 1024) [ Required ];

/// Metadata capturing the allowed FHIR-REST interactions
XData RESTMetadata
{
<Metadata>
	<Interaction name="history-all"
				 method="GET"
				 url="/_history"/>
	<Interaction name="capabilities"
				 method="GET"
				 url="/metadata"/>
	<Interaction name="conformance"
				 method="GET"
				 url="/metadata"/>
	<Interaction name="mailbox"
			 	 method="POST"
			 	 url="/Mailbox"/>
	<Interaction name="document"
				 method="POST"
				 url="/Document"/>
	<Interaction name="search-all"
	 	 		 method="GET"
	 	 		 url="/"/>
	<Interaction name="capabilities"
				 method="OPTIONS"
				 url="/"/>
	<Interaction name="conformance"
				 method="OPTIONS"
				 url="/"/>
	<Interaction name="transaction"
				 method="POST"
				 url="/"/>
	<Interaction name="search"
		 		 method="GET"
		 		 url="/:Type"/>
	<Interaction name="search"
		 		 method="POST"
		 		 url="/:Type/_search"/>
	<Interaction name="search-compartment"
		 		 method="GET"
		 		 url="/:Compartment/:Id/:Type"/>
	<Interaction name="history-type"
				 method="GET"
				 url="/:Type/_history"/>
	<Interaction name="validate"
				 method="POST"
				 url="/:Type/_validate/:Id"/>
	<Interaction name="validate"
			 	 method="POST"
			 	 url="/:Type/_validate"/>
	<Interaction name="vread"
				 method="GET"
				 url="/:Type/:Id/_history/:VId"/>
	<Interaction name="history"
				 method="GET"
				 url="/:Type/:Id/_history"/>
	<Interaction name="read"
				 method="GET"
				 url="/:Type/:Id"/>
	<Interaction name="update"
				 method="PUT"
				 url="/:Type/:Id"/>
	<Interaction name="delete"
				 method="DELETE"
				 url="/:Type/:Id"/>
	<Interaction name="create"
				 method="POST"
				 url="/:Type"/>
	<Interaction name="$validate"
				 method="POST"
				 url="/:Type"/>
	<Interaction name="$validate"
				 method="POST"
				 url="/:Type/:Id"/>
	<Interaction name="$ihe-pix"
				 method="GET"
				 url="/:Type"/>
	<Interaction name="$everything"
				 method="POST"
				 url="/:Type/:Id"/>
	<Interaction name="patch"
				 method="PATCH"
				 url="/:Type/:Id"/>
	<Interaction name="$patient-resource-count"
				 method="POST"
				 url="/:Type/:Id"/>
	<Interaction name="$parameter-session-start"
				 method="POST"
				 url="/"/>
	<Interaction name="$parameter-session-end"
				 method="POST"
				 url="/"/>
	<Interaction name="$lastn"
				 method="POST"
				 url="/:Type"/>
	<Interaction name="$stats"
				 method="POST"
				 url="/:Type"/>
	<Interaction name="$process-message"
				 method="POST"
				 url="/"/>
	<Interaction name="$match"
				 method="POST"
				 url="/:Type"/>
	<Interaction name="$document"
				 method="POST"
				 url="/:Type/:Id"/>
</Metadata>
}

/// This is the Schema which defines the form of the metadata.
/// status-codes, content-types and location are now unused by
/// HS.FHIR.InteractionMetdata.  They are retained in this
/// Schema only to allow compiling of any sub-classes and
/// XData overrides of RESTMetadata that may have been done
/// using an earlier release of this class.
XData RESTMetadataSchema [ Internal ]
{
<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" >

<xs:element name="Metadata">
<xs:complexType>
<xs:choice  minOccurs="0" maxOccurs="unbounded">
<xs:element name="Interaction">
<xs:complexType>
<xs:attribute name="name"    type="string" use="required"/>
<xs:attribute name="method" type="string" use="required"/>
<xs:attribute name="url" type="string" use="required"/>
<xs:attribute name="status-codes" type="string" use="optional"/>
<xs:attribute name="content-types" type="string" use="optional"/>
<xs:attribute name="location" type="location" use="optional"/>
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

<xs:simpleType name="location">
<xs:restriction base="xs:string">
<xs:enumeration value="yes" />
<xs:enumeration value="no" />
<xs:enumeration value="version" />
<xs:enumeration value="maybe" />
</xs:restriction>
</xs:simpleType>

</xs:schema>
}

/// 
/// Fetch metadata for the specified interaction.
/// 
ClassMethod InteractionByName(pInteraction As %String, ByRef pMetadata As HS.FHIR.InteractionMetadata) As %Status
{
    #dim tStatus As %Status = $$$OK
    Try {
	    #dim tMap
	    #dim tIndex As %String
	    #dim tRawMetadata As %List
	    
	    Set pMetadata = $$$NULLOREF
	    
	    Set tStatus = ..metadataMap(.tMap)
	    Quit:$$$ISERR(tStatus)

		Set tIndex = $ORDER(tMap("name",pInteraction,""))
		
		If tIndex'="" {
			Set tRawMetadata = $GET(tMap(tIndex))
			If tRawMetadata '= "" {
				Set pMetadata = ..createFromMetadata(tRawMetadata)
			}
		} 
		
		If '$IsObject($GET(pMetadata)) {
			// Wasn't able to match the interaction
			Set tStatus = $$$ERROR($$$HSFHIRXErrInteractionNotSupported,pInteraction)
			Quit
		}
		
	} Catch (tEx) {
        Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// 
/// Find an interaction using an inbound URL and method.  The HTTP method and actual URL is matched to an interaction
/// based on a URL pattern spec.  Optionally, if a Request object is passed in, it is populated with any arguments that
/// are extracted from the URL (driven by the URL pattern spec).
/// 
ClassMethod InteractionByUrlAndMethod(pUrl As %String, pMethod As %String, ByRef pMetadata As HS.FHIR.InteractionMetadata, pRequest As HS.Message.FHIR.Request) As %Status
{
    #dim tStatus As %Status = $$$OK
    Try {
	    #dim tMap
	    #dim tMatcher As %Regex.Matcher
	    #dim tPattern As %String
	    #dim tArgs As %String
	    #dim tIndex As %Integer
	    #dim tMetadata As %List
	    
	    Set pMetadata = $$$NULLOREF
	    
	    Set tStatus = ..metadataMap(.tMap)
	    Quit:$$$ISERR(tStatus)
	    
		Set tPattern = ""
		For {
			// Iterate over the patterns available for this method
			Set tPattern = $ORDER(tMap("url",pMethod,tPattern))
			Quit:tPattern=""

			// Match the pattern with the regular expression
            Set tMatcher = ##class(%Regex.Matcher).%New(tPattern)
            
            If tMatcher.Match(pUrl) {
	            // Got a match.  Construct a interaction metadata instance
	            Set tIndex = $LG(tMap("url",pMethod,tPattern),1)
	            Set tArgs = $LG(tMap("url",pMethod,tPattern),2)
	            
	            Set pMetadata = ..createFromMetadata(tMap(tIndex))	            

	            If $IsObject($GET(pRequest)) {
		            // Populate the request using the interaction and parameters
		            Set pRequest.Interaction = pMetadata.Interaction
		            Set pRequest.BaseURL = pUrl
		            
                    For tIndex = 1:1:tMatcher.GroupCount {
	                    Set $PROPERTY(pRequest,$LI(tArgs,tIndex)) = tMatcher.Group(tIndex)
                    }
	            }
	        
	        	// Done!    
	            Quit
            } 
		}
		
		If '$IsObject($GET(pMetadata)) {
			// Wasn't able to match the URL to an interaction
			Set tStatus = $$$ERROR($$$HSFHIRXErrUrlNotMatchedToInteraction,pMethod_" "_pUrl)
			Quit
		}
	    
    } Catch (tEx) {
        Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// 
/// Metadata fetcher.  This method generator generates code that produces a map of the
/// interaction metadata indexed by name and also by method/url.
/// 
ClassMethod metadataMap(ByRef pMap) As %Status [ CodeMode = generator ]
{
    #dim tStatus As %Status = $$$OK
    Try {

		#dim tXDATA As %String = "RESTMetadata"
	    #dim tChild As %String
        #dim tName As %String
        #dim tMethod As %String
        #dim tUrl As %String
        #dim tStatusCodes As %String
        #dim tContentTypes As %String
        #dim tLocation As %String
        #dim tPattern As %String
        #dim tArgs As %List
        #dim tMap
	    
	    
	    // Parse the XML metadata
	    Set tStatus = ##class(HS.FHIR.Utils).GetMetadataFromXDATA(%classname,tXDATA,.tMap)
	    Quit:$$$ISERR(tStatus)
	    
	    $$$GENERATE(" 	Kill pMap")
            
        // Walk the XML metadata and generate
        Set tChild=""
        For {
            Set tChild=$Order(tMap(1,"c",tChild))
            Quit:tChild=""
            
            If tMap(tChild)="Interaction" {
                
                Set tName = tMap(tChild,"a","name")
                Set tMethod = tMap(tChild,"a","method")
                Set tUrl = tMap(tChild,"a","url")

				// Break the URL spec into a regex pattern and argument name list
				Set tStatus = ##class(HS.FHIR.Utils).ParseUrlSpec(tUrl,.tPattern,.tArgs,"""")
				Quit:$$$ISERR(tStatus)
                
                // Generate the raw metadata
                $$$GENERATE("	Set pMap($I(pMap))=$LB("""_tName_""","""_tMethod_""","""_tUrl_""")")
                
                // Generate the name index
                $$$GENERATE("	Set pMap(""name"","""_tName_""",pMap)=""""")
                
                // Generate a Method/URL index
                $$$GENERATE("	Set pMap(""url"","""_tMethod_""","""_tPattern_""")=$LB(pMap,$LB("_$LISTTOSTRING(tArgs)_"))")
            }Else {
                // The XML is not right.
                Set tStatus = $$$ERROR($$$HSFHIRXErrInvalidMetadata,tXDATA)
                Quit
            }
		}

        $$$GENERATE(" 	Quit $$$OK")
        
    } Catch (tEx) {
        Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// 
/// Helper to convert $LIST metadata into an instance of this class
/// 
ClassMethod createFromMetadata(pRawMetadata As %List) As HS.FHIR.InteractionMetadata
{
	#dim tMetadata As HS.FHIR.InteractionMetadata
	
	Set tMetadata = ..%New()
	Set tMetadata.Interaction = $LG(pRawMetadata,1)
	Set tMetadata.Method = $LG(pRawMetadata,2)
	Set tMetadata.UrlSpec = $LG(pRawMetadata,3)
	
	Quit tMetadata
}

/// 
/// Given a Url spec, and a FHIR message object, build the actual URL for this resource
/// 
Method BuildUrlFromMessage(pMessage As HS.Message.FHIR.Base, pDefaultUrl As %String, ByRef pUrl As %String) As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tI As %Integer
		#dim tPart As %String

		// Start with the base URL
		Set pUrl = pMessage.BaseURL
		Set:pUrl="" pUrl = pDefaultUrl
		
		// Remove any trailing '/'
		Set:$EXTRACT(pUrl,*)="/" pUrl=$EXTRACT(pUrl,1,*-1)
		
		// For each "part" of the Url spec, inject any :property values
		For tI = 2:1:$L(..UrlSpec,"/") {
			Set tPart = $PIECE(..UrlSpec,"/",tI)
			
			// Transmogrify the URL using the pMessage properties as substitutions
			If $EXTRACT(tPart,1)=":" {
				Set pUrl = pUrl_"/"_$PROPERTY(pMessage,$E(tPart,2,*))
			} Else {
				Set pUrl = pUrl_"/"_tPart
			}
		}
		
		If $Extract(pMessage.Interaction)="$" {
			If $Extract(pUrl,*)'="/" Set pUrl = pUrl_"/"
			Set pUrl = pUrl_pMessage.Interaction
		}
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	Quit tStatus
}

}
