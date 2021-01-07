/// This class inherits from EnsLib.TCP.TextLineOutboundAdapter and forces the Ensemble GetReply setting to be FALSE.
/// Without doing this, implementation teams could accidentally set GetReply to TRUE, which would lead to timeout problems due to ATNA Repositories not ever sending a reply.
Class HS.IHE.ATNA.SecureApplication.TCP.TextLineOutboundAdapter Extends EnsLib.TCP.TextLineOutboundAdapter [ StorageStrategy = StorageSQL ]
{

Parameter SETTINGS = "-IPAddress,-Port,-SSLConfig,-GetReply";

Property GetReply As %Boolean [ InitialExpression = 0 ];

/// Mike: According to IBM, should not terminate with $c(10)
Property Terminators As %String;

Storage StorageSQL
{
<Type>%Storage.SQL</Type>
}

}
