Include HS.FHIRMeta

/// This class implements the interpreter runtime processing for
/// built-in operator and functions.  Dispatch is based on the name of the
/// function or operator so it is possible to implement support for a new function
/// by simply adding a method to this class.  Because operators are typically special characters,
/// the initializeOperatorToMethodMap method sets up a mapping from the operator name to a
/// valid identifier.  The final method name is prefixed by "IOP" or "IUOP" (for binary or unary)
/// handlers.  Handlers for built-in functions are prefixed by "IFN"
/// <p>
/// Internally, a collection is represented as a multi-dimensional array.  In the method
/// signatures, collections are named in ALL-UPPER-CASE for clarity.
/// <p> Signature for a Built-in Function handler<br>
/// <pre>Method IFN<functionName>(ByRef CONTEXT, args As %ListOfObjects, Output OUTPUT) 
///    CONTEXT      is the context collection for that the function is applied to.
///    arg          is a list of Node object representing the arguments to the function.
///                 The handler can evaluate these arguments by calling processNode with
///                 an appropriate context collection (typically the single input).
///    OUTPUT       is the result collection
///    
/// </pre>
/// <p>
/// During the evaluation of a function, the interpreter calls the handler once per value in
/// the context collection for the function.  The handler will accumulate the result into the 
/// OUTPUT collection.  
/// <p>
/// <p> Signature for a Binary Operator handler 
/// <pre>Method IOP<operatorBaseName>(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
///    LEFT   is the left-side input operand collection
///    RIGHT  is the right-side input operand collection
///    OUTPUT is the result collection
/// </pre>
/// <p> Signature for a Binary Operator handler 
/// <pre>Method IOP<operatorBaseName>(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
///    LEFT   is the left-side input operand collection
///    RIGHT  is the right-side input operand collection
///    OUTPUT is the result collection
/// </pre>
Class HS.FHIRPath.Runtime Extends HS.FHIRPath.Engine
{

/* Operators */
/// Initializes a mapping from an operator name to a base method name.
/// The implementation of the operator must prefix the base method name with
/// either IOP (for binary operators) or IUOP (for unary operators).  Note that
/// some operators have both implementations (e.g. '+' and '-')
Method initRuntime() [ Internal ]
{
	Set ..opMap("+") = "plus"
	Set ..opMap("-") = "minus"
	Set ..opMap("=") = "equals"
	Set ..opMap("!=") = "ne"
	Set ..opMap("|") = "union"
	Set ..opMap("Index") = "subscript"
	Set ..opMap("and") = "and"
	for n="as","is" {
		Set ..opMap(n) = n	
	}
}

Method IOPas(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
{
	Set OUTPUT = 0
	Set targetType = RIGHT(1)
	for ix=1:1:LEFT {
		if ..schema.IsA(LEFT(ix,"t"), targetType) {
			$$$CollPushFromColl(OUTPUT, LEFT, ix)
		}
	}
}

Method IOPis(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
{
	Set OUTPUT = 0
	Set targetType = RIGHT(1)
	if LEFT > 1 {
		$$$ThrowError($$$GeneralError, "is() context must be a single element")	
	}
	// False if empty input collection, otherwise type must match the target
	$$$CollPushBoolean(OUTPUT, (LEFT=1) && ..schema.IsA(LEFT(1,"t"), targetType))
}

Method IOPand(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
{
	if (LEFT=0) || (RIGHT=0) {
		return 0
	}
	if (LEFT>1) || (RIGHT>1) {
		$$$ThrowError($$$GeneralError, "Math operation requires single element for input")	
	}
	Set OUTPUT = 0
	if (LEFT=0) || (RIGHT=0) {
		$$$CollPushBoolean(OUTPUT, 0)
	}
	$$$CollPushBoolean(OUTPUT, (LEFT(1)="true") && (RIGHT(1)="true"))
}

Method IOPunion(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
{
	Set OUTPUT = 0

	Merge OUTPUT = LEFT
	for ix=1:1:RIGHT {
		if '..collectionContains(.OUTPUT, RIGHT(ix), RIGHT(ix, "t")) {
			$$$CollPushFromColl(OUTPUT, RIGHT, ix)
		}
	}
}

Method collectionContains(ByRef COLL, value, type) As %Boolean
{
	for ix=1:1:COLL {
		if COLL(ix,"t") = type {
			if type="boolean" {
				if value {
					Set COLL(ix) = value
				}
				return 1
			} else {
				if COLL(ix) = value {
					return 1
				}
			}
		}
	}	
	return 0
}

Method IOPplus(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
{
	if '..mathCheck(.LEFT, .RIGHT, .leftValue, .leftType, .rightValue, .rightType) {
		Quit
	}
	if leftType="s" {
		$$$CollPushValue(OUTPUT, leftValue _ rightValue, "string")
		Quit
	}
	if leftType="n" {
		$$$CollPushValue(OUTPUT, leftValue + rightValue, LEFT(1,"t"))
		Quit
	}
	$$$ThrowError($$$GeneralError, "Cannot add types " _ leftType _ " and " _ rightType )
}

Method IOPequals(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
{
	Set OUTPUT = 0
	if (LEFT=0) || (RIGHT=0) {
		// If either input is an empty collection, output is an empty collection
	} elseif (LEFT '= RIGHT) {
		// Return false if array lengths are unequal
		$$$CollPushBoolean(OUTPUT, 0)
		
	} else {
		// All values must be equal
		set result = 1
		for ord=1:1:LEFT {
			if LEFT(ord) '= RIGHT(ord) {
				Set result = 0
				Quit
			}
		}
		$$$CollPushBoolean(OUTPUT, result)
	}
}

Method IOPne(ByRef LEFT, ByRef RIGHT, Output OUTPUT)
{
	Do ..IOPequals(.LEFT, .RIGHT, .OUTPUT)
	if OUTPUT = 1 {
		Set OUTPUT(1) = $Select(OUTPUT(1)="true":"false", 1:"true")	
	}
}

Method mathCheck(ByRef LEFT, ByRef RIGHT, Output leftValue, Output leftType, Output rightValue, Output rightType) As %Boolean [ Private ]
{
	if (LEFT=0) || (RIGHT=0) {
		return 0
	}
	if (LEFT>1) || (RIGHT>1) {
		$$$ThrowError($$$GeneralError, "Math operation requires single element for input")	
	}
	Set leftValue = $$$CollGetValueAt(LEFT, 1)
	Set leftType = ..fhirTypeToJsonType($$$CollGetTypeAt(LEFT, 1))
	Set rightValue = $$$CollGetValueAt(RIGHT, 1)
	Set rightType = ..fhirTypeToJsonType($$$CollGetTypeAt(RIGHT, 1))
	return 1
}

/* Built-in Functions */
Method IFNunion(CONTEXT, args As %ListOfObjects, Output OUTPUT)
{
	Set OUTPUT = 0
	if (args.Count() '= 1) {
		$$$ThrowError($$$HSFHIRPathErrOneArgRequired, "where")	
	}
}

/* Built-in Functions */
Method IFNwhere(CONTEXT, args As %ListOfObjects, Output OUTPUT)
{
	Set OUTPUT = 0
	if (args.Count() '= 1) {
		$$$ThrowError($$$HSFHIRPathErrOneArgRequired, "where")	
	}

	// Loop through the context values filtering against the argument expression
	set ix=""	
	for {
		Set ix = $Order(CONTEXT(ix))
		Quit:ix=""
		
		// Check for a "resolve() is <type>" clause, handle separately
		#dim whereFnNode as Node = args.GetAt(1)
		if (whereFnNode.type = "OP") && (whereFnNode.name = "is") {
			#dim isOpLeftNode as Node = whereFnNode.children.GetAt(1)
			if (isOpLeftNode.type = "FN") && (isOpLeftNode.name = "resolve") {
				#dim isOpRightNode as Node = whereFnNode.children.GetAt(2)
				if (isOpRightNode.type = "ID") {
					Set matchType = isOpRightNode.name
					
					set inputType = $Case(CONTEXT(ix,"t"), "Reference":CONTEXT(ix).reference,"canonical":CONTEXT(ix), :"-")
					Set inputType = $Piece(inputType,"/",1)
					if ..schema.IsA(inputType, matchType) {
						$$$CollPushFromColl(OUTPUT, CONTEXT, ix)
					}
					return
				}
				
			}
		}
		
		kill FNCTX
		kill MATCHES
		$$$CollPushFromColl(FNCTX, CONTEXT, ix)
		// Evaluate the boolean expression that is the first argument, using
		// the provided value as the 1-element context
		Do ..processNode(whereFnNode, .FNCTX, .MATCHES)
		if MATCHES && MATCHES(1) {
			$$$CollPushFromColl(OUTPUT, CONTEXT, ix)
		}
	}
}

Method IFNofType(CONTEXT, args As %ListOfObjects, Output OUTPUT)
{
	Set OUTPUT = 0
	if (args.Count() '= 1) {
		$$$ThrowError($$$HSFHIRPathErrOneArgRequired, "extension")	
	}
	Set targetType = args.GetAt(1).name
	for ix=1:1:CONTEXT {
		if ..schema.IsA(CONTEXT(ix,"t"), targetType) {
			$$$CollPushFromColl(OUTPUT, CONTEXT, ix)
		}
	}
}

/// extension(<url>) === extension.where(url is <url>)
Method IFNextension(CONTEXT, args As %ListOfObjects, Output OUTPUT)
{
	Set OUTPUT = 0
	if (args.Count() '= 1) {
		$$$ThrowError($$$HSFHIRPathErrOneArgRequired, "extension")	
	}
	Set urlValue = args.GetAt(1).name

	// Loop through the context values filtering against the argument expression
	set ix=""	
	for {
		Set ix = $Order(CONTEXT(ix))
		Quit:ix=""
		
		Set extn = CONTEXT(ix).extension
		Continue:extn=""
		Set iter = extn.%GetIterator()
		while iter.%GetNext(.subsc, .extensionObj) {
			if extensionObj.url = urlValue {
				$$$CollPushValue(OUTPUT, extensionObj, "Extension")
			}
		}
	}
}

/// extension(<url>) === extension.where(url is <url>)
Method IFNhasExtension(CONTEXT, args As %ListOfObjects, Output OUTPUT)
{
	Do ..IFNextension(CONTEXT,args,.TOUTPUT)
	$$$CollPushBoolean(OUTPUT,TOUTPUT>0)
}

Method IFNempty(CONTEXT, args As %ListOfObjects, Output OUTPUT)
{
	Set OUTPUT = 0
	if (args.Count()) {
		$$$ThrowError($$$HSFHIRPathErrNoArgsAllowed, "empty")	
	}
	$$$CollPushBoolean(OUTPUT,$Get(CONTEXT,0)=0)
	return 1
}

Method IFNexists(CONTEXT, args As %ListOfObjects, Output OUTPUT)
{
	if (args.Count() > 1) {
		$$$ThrowError($$$HSFHIRPathErrTooManyArgs1, "exists")	
	}

	if $Get(CONTEXT,0) = 0 {
		// Return false for an empty context collection
		$$$CollPushBoolean(OUTPUT,0)
		return
	} elseif args.Count() =0 {
		// Return true for a non-empty context and an empty filter
		$$$CollPushBoolean(OUTPUT,1)
		return
	}
	
	// Loop through the context values filtering against the argument expression
	// If any value matches the filter, return true.
	Set OUTPUT = 0
	Set exists = 0
	Set filterNode = args.GetAt(1)
	for ix=1:1:CONTEXT {
		
		Set FNCTX = 0
		kill MATCHES
		$$$CollPushFromColl(FNCTX, CONTEXT, ix)
		// Evaluate the boolean filter expression against the CONTEXT element
		Do ..processNode(filterNode, .FNCTX, .MATCHES)
		if MATCHES(1) {
			set exists = 1
			Quit
		}
	}
	$$$CollPushBoolean(OUTPUT, exists)
}

}
