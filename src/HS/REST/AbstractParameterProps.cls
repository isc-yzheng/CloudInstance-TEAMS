Class HS.REST.AbstractParameterProps
{

/// Inidcates where the property should be placed in the path of the request to be built.
Parameter InPath As BOOLEAN = 0;

/// Inidcates that the property should be placed in the query of the request to be built.
Parameter InQuery As BOOLEAN = 0;

/// Inidcates that the property should be placed in the header of the request to be built.
Parameter InHeader As BOOLEAN = 0;

/// Inidcates that the property should be placed in the form data of the request to be built.
Parameter InFormData As BOOLEAN = 0;

/// Inidcates that the property should be placed in the raw body of the request to be built.
Parameter InRawBody As BOOLEAN = 0;

}
