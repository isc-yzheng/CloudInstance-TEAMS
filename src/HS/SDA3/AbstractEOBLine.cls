Class HS.SDA3.AbstractEOBLine [ Abstract, NoExtent ]
{

/// The number of repetitions of a service or product.
Property Quantity As HS.SDA3.Numeric;

/// A code supporting the understanding of the adjudication result and explaining variance from expected amount.
Property DeniedReasonCode As HS.SDA3.CodeTableDetail.DeniedReasonCode;

/// Indicates the in network or out of network payment status of the Explanation Of Benefit item.
Property InOutNetwork As HS.SDA3.CodeTableDetail.BenefitPaymentStatus;

/// The line number for this service on the claim.
Property LineCounter As HS.SDA3.Numeric;

}
