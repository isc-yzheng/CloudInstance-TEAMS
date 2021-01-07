Class HS.FHIRMeta.Impl.CompartmentInfo Extends Base
{

/// This is a validation routine that is not used in production
Method CheckCompartment()
{
	Set compartmentName = ""
	for {
		$$$NextCompartment(.,compartmentName)
		Quit:(compartmentName="")

		Set resourceType = ""
		for {
			$$$NextTypeInCompartment(.,compartmentName,resourceType)
			Quit:(resourceType="")
			
			kill exprCache
			Set paramName = ""
			for {
				$$$NextParamNameInCompartment(.,compartmentName,resourceType,paramName)
				Quit:(paramName="")
				Set searchParam = ..FindSearchParam(resourceType, paramName)
				if searchParam = "" {
					w "No Search Parameter ",compartmentName,"|",resourceType,".",paramName, !	
				} else {
					//w "OK Search Parameter ",compartmentName,"|",resourceType,".",paramName, !	
					Set expr = $lts(searchParam.expression)
					if $D(exprCache(expr))=0 {
						Set exprCache(expr) = paramName	
					} else {
						w "Duplicate Search Parameter ",compartmentName,"|",resourceType,".",paramName, " = ", exprCache(expr), "|",expr, !	
					}
				}
			}
			
		}
	}
}

}
