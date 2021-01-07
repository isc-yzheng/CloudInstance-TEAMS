/// HS.HC.Util contains common utility methods for Health Connect.
Class HS.HC.Util
{

/// API
/// IsOID returns 1 if the specified string is an OID, returns 0 if not. The Regex
/// for OID is "urn:oid:[0-2](\.(0|[1-9][0-9]*))+". Requirement for the presence of the "urn:oid:"
/// prefix is determined by the pPrefixRequired input parameter. Once prefix is
/// verified per the requirement, the remainder of validation takes place with the
/// prefix stripped.
ClassMethod IsOID(pString As %String, pPrefixRequired As %Boolean = 0) As %Boolean
{
	// The Regex for OID is "urn:oid:[0-2](\.(0|[1-9][0-9]*))+", but the algorithm used
	// here is faster than using $Match with the Regex.
	Set tString = pString
	If $Extract(tString,1,8)="urn:oid:" {
		Set tString = $Extract(tString,9,*)
	} Else {
		If pPrefixRequired=1 Quit 0
	}
	Set t12 = $Extract(tString,1,2)
	If ((t12="1.")||(t12="2.")||(t12="0.")) {
		Set tReturn = (($Translate(tString,"0123456789.")="")&&(tString'["..")&&(tString'?.E1".0"1N.E)&&($Extract(tString,*)'="."))
	} Else {
		Set tReturn = 0
	}
	Quit tReturn
}

/// API
/// IsUUID returns 1 if the specified string is a UUID, returns 0 if not. Requirement for the
/// presence of the "urn:uuid:" prefix is determined by the pPrefixRequired input parameter.
/// Once prefix is verified per the requirement, the remainder of validation takes place
/// with the prefix stripped.
ClassMethod IsUUID(pString As %String, pPrefixRequired As %Boolean = 0) As %Boolean
{
	Set tString = pString
	If $Extract(tString,1,9)="urn:uuid:" {
		Set tString = $Extract(tString,10,*)
	} Else {
		If pPrefixRequired=1 Quit 0
	}
	Quit $Match(tString,"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")
}

/// API
/// IsURL returns 1 if the specified string is a URL, returns 0 if not. The pAllowPathOnly
/// input parameter toggles the allowing of a path-only URL string to be specified.
ClassMethod IsURL(pString As %String, pAllowPathOnly As %Boolean = 0) As %Boolean
{
	If pString="" {
		Quit 0
	}
	
	// Example:
	// https://user1@example.com:8080/one/two?param1=value1#fragment
	//
	// scheme    = https
	// authority = user1@example.com:8080
	// userinfo  = user1
	// host      = example.com
	// port      = 8080
	// path      = /one/two
	// query     = ?param1=value1
	// fragment  = #fragment
	
	// RFC 3986: Scheme names consist of a sequence of characters beginning
	// with a letter and followed by any combination of letters, digits,
	// plus ("+"), period ("."), or hyphen ("-").
	If pString["://" {
		// :// implies a scheme is present. If present, it needs to be valid.
		// If the URL is malformed like "http:/example.org/path", or
		// "http//example.org/path", then it will be caught in path validation.
		If pString?1A.(1AN,1"+",1"-",1".")1"://".ANP {
			Set tScheme = $Piece(pString, "://", 1)
		} Else {
			Quit 0
		}
	} Else {
		Set tScheme = ""
	}
	
	If tScheme="" {
		// No scheme implies both scheme and authority not present.
		If 'pAllowPathOnly {
			Quit 0
		}
		Set tAuthStart = 0
		Set tAuthEnd = 0
		Set tHost = ""
		
	} ElseIf tScheme'="" {
		// RFC3986: The authority component is preceded by a double slash ("//")
		// and is terminated by the next slash ("/"), question mark ("?"), or
		// number sign ("#") character, or by the end of the URI.
		Set tAuthStart = $Find(pString, "://")
		Set tAuthEnd = 0
		For i = tAuthStart:1 {
			Set tChar = $Extract(pString, i)
			If (tChar="/")||(tChar="")||(tChar="?")||(tChar="#") {
				Set tAuthEnd = i-1
				Quit
			}
		}
		
		Set tAuthority = $Extract(pString, tAuthStart, tAuthEnd)
		
		// If authority is present, then it must be reasonably sensical.
		If tAuthority["@" {
			// If @ present, then that indicates user info that should precede it.
			If $Piece(tAuthority, "@", 1)="" {
				Quit 0
			}
			Set tHostAndPort = $Piece(tAuthority, "@", 2)
			If $Extract(tHostAndPort, *)=":" {
				// RFC3986 says colon SHOULD (not MUST) be omitted when no
				// explicit port. Considering it malformed here anyway.
				Quit 0
			}
			Set tHost = $Piece($Piece(tAuthority, "@", 2), ":", 1)
			Set tPort = $Piece($Piece(tAuthority, "@", 2), ":", 2)
		} Else {
			If $Extract(tAuthority, *)=":" {
				// RFC3986 says colon SHOULD (not MUST) be omitted when no
				// explicit port. Considering it malformed here anyway.
				Quit 0
			}
			Set tHost = $Piece(tAuthority, ":", 1)
			Set tPort = $Piece(tAuthority, ":", 2)
		}
		
		If tHost'="" {
			// Host, if present, must be an IP address or registered name or an
			// IP literal. The latter is enclosed in square brackets.
			If '((tHost?1AN.ANP)||(tHost?1"["1AN.ANP1"]")) {
				Quit 0
			}
		} ElseIf tScheme'="file" {
			// If non-file scheme then URL must have an authority, and authority must have host.
			Quit 0
		}
		
		If tPort'="" {
			// Port, when present, must be all numeric.
			If tPort'?1N.N {
				Quit 0
			}
		}
	}
	
	// Path starts immediately after scheme+authority.
	Set tPath = ""
	For i = (tAuthEnd+1):1 {
		Set tChar = $Extract(pString, i)
		If (tChar="")||(tChar="?")||(tChar="#") {
			Quit
		}
		Set tPath = tPath_tChar
	}
	
	If tPath="" {
		If tHost'="" {
			// path-empty is valid as long was we have a scheme AND authority.
			Quit 1
		} Else {
			Quit 0
		}
		
	} Else {
		
		If tPath="/" {
			If (tScheme'="")&&(tHost="") {
				// Examples: "file:///" or "file://" - not valid.
				Quit 0
			} Else {
				Quit 1
			}
			
		} ElseIf tPath["//" {
			// Technically, leading // can be considered valid sometimes, but is troublesome.
			// Also, considering // anywhere in path to be invalid, so that we can catch
			// malformed URL such as "http//example.org/path".
			Quit 0
			
		} ElseIf tPath["..." {
			// Relative path can have . or .. but not ...
			Quit 0
			
		} ElseIf (tPath?1"."."."1"/"."."."/".ANP)&&(tScheme'="") {
			// Relative path (e.g., "../mypath") in the middle of an absolute is invalid.
			Quit 0
			
		} ElseIf ($Extract(tPath)'="/")&&($Piece(tPath, "/", 1)[":") {
			// Relative path first segment cannot contain colon. This check here will
			// also catch malformed URL such as "http:/example.org/path".
			Quit 0
			
		} Else {
			// All that is left here is valid relative path and valid absolute path.
			Quit 1
		}
	}
	
	Quit 1
}

/// API
/// IsURI returns 1 if the specified string is a URI, returns 0 if not.
/// This method is intended to validate URIs that will be used within various
/// payloads such as SOAP requests and responses and FHIR resources. Therefore
/// URI prefixes are required to be all lowercase.
ClassMethod IsURI(pString As %String, pParameterNoLongerUsed) As %Boolean
{
	// Using $Translate instead of $Match on "\S*" is 4x faster.
	
	#define noWhitespace(%val) $Translate(%val,$Char(9,10,11,12,13,32,133,160))=%val
	#define genericURI(%val) ($$$noWhitespace(%val))&&(%val'?.e1c.e)
	
	If pString="" Quit 0
	
	// Passing pString by reference to other methods for performance gain.
	If $Extract(pString,1,8)="urn:oid:" Quit ..IsOID(.pString)
	If $Extract(pString,1,9)="urn:uuid:" Quit ..IsUUID(.pString)
	If $Extract(pString,1,7)="http://" Quit ..IsURL(.pString)
	If $Extract(pString,1,8)="https://" Quit ..IsURL(.pString)
	If $Extract(pString,1,8)="file:///" Quit ..IsURL(.pString)
	If $Extract(pString,1,6)="ftp://" Quit ..IsURL(.pString)
	If $Extract(pString,1,7)="ftps://" Quit ..IsURL(.pString)
	If $Extract(pString,1,4)="urn:" Quit (($Extract(pString,5,*)'="") && ($$$genericURI(pString)))
	If $Extract(pString,1,7)="mailto:" Quit (($Extract(pString,8,*)'="") && ($$$genericURI(pString)))
	
	// Mixed case prefix is considered invalid by this method.
	Set stringL = $ZConvert(pString, "L")
	If $Extract(stringL,1,8)="urn:oid:" Quit 0
	If $Extract(stringL,1,9)="urn:uuid:" Quit 0
	If $Extract(stringL,1,7)="http://" Quit 0
	If $Extract(stringL,1,8)="https://" Quit 0
	If $Extract(stringL,1,8)="file:///" Quit 0
	If $Extract(stringL,1,6)="ftp://" Quit 0
	If $Extract(stringL,1,7)="ftps://" Quit 0
	If $Extract(stringL,1,4)="urn:" Quit 0
	If $Extract(stringL,1,7)="mailto:" Quit 0
	
	// Aside from the above, URI is pretty indeterministic.
	Quit ($$$genericURI(pString))
}

/// API
/// GetFormatFromData derives a JSON-or-XML format designation for the specified
/// string or stream data, and returns it in the pFormat parameter. If the first
/// non-whitespace character found is left curly brace ("{"), then pFormat is
/// returned as "json". If the first non-whitespace character found is left
/// angle bracket ("<") then pFormat is returned as "xml". Otherwise pFormat is
/// returned as blank string, and an error status is returned.<br>
/// <br>
/// Note that this method does NOT verify that the specified data is well-formed
/// JSON or XML.
ClassMethod GetFormatFromData(pStreamOrString = "", ByRef pFormat As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pFormat = ""
	
	Try {
		Set tReturn = ""
		
		If pStreamOrString="" {
			Set tSC = $$$ERROR($$$GeneralError, "Input not specified")
		} ElseIf '$IsObject(pStreamOrString) {
			// It's a string.
			Do FindStart(.pStreamOrString, .tReturn)
		} ElseIf pStreamOrString.%IsA("%Stream.Object") {
			// It's a stream object.
			Do pStreamOrString.Rewind()
			For {
				// Use a shorter-than-default read length to avoid taking up too much memory.
				Set tString = pStreamOrString.Read(2000, .tSC)
				If $$$ISERR(tSC) Quit
				Do FindStart(.tString, .tReturn)
				If tReturn'="" Quit
				If pStreamOrString.AtEnd Quit
			}
			If $$$ISOK(tSC) Do pStreamOrString.Rewind()
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Input must be a String or a %Stream.Object")
		}
		If $$$ISERR(tSC) Quit
		
		If (tReturn="json")||(tReturn="xml") {
			Set pFormat = tReturn
		} ElseIf tReturn="" {
			Set tSC = $$$ERROR($$$GeneralError, "Format not detected - input is all whitespace")
		} Else {
			Set tSC = tReturn
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
	
FindStart(string, return)
	For j = 1:1:$Length(string) {
		Set char = $Extract(string, j)
		// Once we hit a non-whitespace char, it's either left curly brace,
		// left angle bracket, or we return an error.
		If '((char=$Char(9))||(char=$Char(32))||(char=$Char(10))||(char=$Char(11))||(char=$Char(13))) {
			If char="{" {
				Set return = "json"
			} ElseIf char="<" {
				Set return = "xml"
			} Else {
				Set return = $$$ERROR($$$GeneralError, "Neither JSON nor XML detected – first non-whitespace character is ASCII "_$A(char))
			}
			Quit
		}
	}
	Quit
}

}
