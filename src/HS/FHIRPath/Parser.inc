ROUTINE HS.FHIRPath.Parser [Type=INC]
#include HS.FHIRPath.Errors

#define TokenTypeLiteral  "Lit"
#define TokenTypeOperator  "OP"
#define TokenTypePunctuation  "Punc"
#define TokenTypeOpOrFunc  "IdOp"

#define PushToken(%t) Set tokens($I(tokens)) = %t

#define NewIdentifier(%name) ##class(Token).NewIdentifier(%name)
#define NewLiteral(%value,%type) ##class(Token).NewIdentifier(%value,%type)
#define NewMarker(%open,%close) ##class(Token).NewMarker(%open,%close)
#define NewOperator(%name,%prec,%usage) ##class(Token).NewOperator(%name,%prec,%usage)
#define NewIdOp(%name,%prec,%usage) ##class(Token).NewIdOp(%name,%prec,%usage)

#define TokenIsMarker(%t) (%t.markerName '= "")
#define TokenCanBeOp(%t) (%t.opName '= "")
#define TokenCanBeUnary(%t) ($E(%t.opUsage,2) = "u")
#define TokenCanBePostUnary(%t) ($E(%t.opUsage,3) = "p")
#define TokenCanBeBinary(%t) ($E(%t.opUsage,1) = "b")
#define TokenCanBeId(%t) (%t.idName '= "")
#define TokenIsLiteral(%t) (%t.literalType '= "")
#define TokenIsIdOp(%t) ((%t.idName '= "") && (%t.opName '= ""))



#define MarkPos $E(expr,1,start-1) _ "^" _ $E(expr,start,cur) _ "^" _ $E(expr,cur+1,*)
#define LexError(%s) $$$ThrowStatus($$$ERROR($$$GeneralError,%s _ ": " _ $$$MarkPos))
#def1arg ThrowParseError(%args) $$$ThrowStatus($$$ERROR(%args))

#define GnIdentifier "i"
#define GnBinaryOp   "o"
#define GnUnaryOp    "u"
#define GnFunction   "f"
#define GnInvoke     "d"

