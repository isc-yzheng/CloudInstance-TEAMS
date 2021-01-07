Class HS.AU.PCEHR.WebRequest Extends %SOAP.WebRequest
{

XData NewXData1
{
<parameters xmlns="http://www.intersystems.com/configuration">
   <response>
      <header name="signature" class="HS.AU.PCEHR.SignatureContainerType"/> 
   </response>
</parameters>
}

}
