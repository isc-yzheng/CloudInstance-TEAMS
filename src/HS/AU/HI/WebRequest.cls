Class HS.AU.HI.WebRequest Extends %SOAP.WebRequest
{

XData NewXData1
{
<parameters xmlns="http://www.intersystems.com/configuration">
   <response>
      <header name="signature" class="HS.AU.HI.SignatureContainerType"/> 
      <header name="product" class="HS.AU.HI.ProductType"/> 
      <header name="user" class="HS.AU.HI.UserType"/> 
      <header name="timestamp" class="HS.AU.HI.TimestampType"/> 
   </response>
</parameters>
}

}
