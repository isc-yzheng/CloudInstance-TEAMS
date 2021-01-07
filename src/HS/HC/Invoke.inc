ROUTINE HS.HC.Invoke [Type=INC]
#;HS.HC.Invoke
#; actual invocation macro $$$HCInvoke(return variable, return variable defaultvalue, label, params...)  ie $$$HSInvoke(tSC,$$$OK,"AddCodeSystem",..IdentityCode,..Description) 
#def1arg HCInvoke(%args) ##safeexpression($S(##safeexpression('##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance()):##quote($$$HCGetEmptyReturn(%args)),$$$HCGetClassFromArgumentIsNull(%args):##quote($$$HCGetEmptyReturn(%args)),1:##quote($$$HCGetCodeFromArgument(%args))))
#;
#; 
#; Helper macros
#;
#; using the provided expression get the label from HS.Invoke routine and return the code to execute, adding the arguments
#def1arg HCGetCodeFromArgument(%args)	##safeexpression($S($li(%literalargs)="":"Do ",1:"Set ##safeexpression($li(%literalargs,1))="))##class($$$HCGetClassFromArgument(%args)).$$$HCGetMethodFromArgument(%args)(##safeexpression($listtostring($li(%literalargs,4,*),",")))
#;
#; determine whether there is an entry in HS.Invoke for item
#def1arg HCGetClassFromArgumentIsNull(%args)	##safeexpression($p(##safeexpression(""""_$TEXT($$$HCGetLabel(%args)^HS.Invoke)_""""),";",2)="")
#; get class for entry in HS.Invoke
#def1arg HCGetClassFromArgument(%args)	##safeexpression($p(##safeexpression(""""_$TEXT($$$HCGetLabel(%args)^HS.Invoke)_""""),";",2))
#; get method for entry in HS.Invoke
#def1arg HCGetMethodFromArgument(%args)	##safeexpression($p(##safeexpression(""""_$TEXT($$$HCGetLabel(%args)^HS.Invoke)_""""),";",3))

#;
#; Get the named expression from the inbound arguments
#def1arg HCGetLabel(%args)	##safeexpression($zstrip($lg(%literalargs,3),"<>",$C(34)))
#;
#;Set the return value arg2 into arg1 as long as arg1 is not missing
#def1arg HCGetEmptyReturn(%args) ##safeexpression($S($li(%literalargs)="":"",1:"Set "_$li(%literalargs)_"="_$li(%literalargs,2)))