/// Test script patients
Class HS.Test.Data.Patients [ Abstract ]
{

/*
 *		Generic testing patients
 */
XData Patient1
{
<Patient>
<Name first="Jimmy" last="Dean" />
<MRN id="EXT001" copy="FacilityEXT"/>
<Gender code="M"/>
<DOB value="19570323"/>
<Addresses>
<Address>
<Street value="3443 S Beach Ave"/>
<City code="Some City"/>
<State code="IL"/>
<Zip code="12345"/>
</Address>
</Addresses>
<Identifiers>
<Identifier id="EXT002" copy="FacilityEXT"/>
</Identifiers>
</Patient>
}

XData Patient2
{
<Patient>
<Name first="Jimmy" last="Dean" />
<MRN id="EXT010" copy="FacilityEXT"/>
<Gender code="M"/>
<DOB value="19570323"/>
<Addresses>
<Address>
<Street value="3443 S Beach Ave"/>
<City code="Some City"/>
<State code="IL"/>
<Zip code="12345"/>
</Address>
</Addresses>
<Identifiers>
<Identifier id="EXT020" copy="FacilityEXT"/>
</Identifiers>
</Patient>
}

XData Patient3
{
<Patient>
<Name first="Jimmy" last="Dean" />
<MRN id="EXT030" copy="FacilityEXT"/>
<Gender code="M"/>
<DOB value="19570323"/>
<Addresses>
<Address>
<Street value="3443 S Beach Ave"/>
<City code="Some City"/>
<State code="IL"/>
<Zip code="12345"/>
</Address>
</Addresses>
</Patient>
}

/*
 *		Patients from the HL7/SDA test files
 */
XData JohnSmith
{
<Patient>
<Name first="John" last="Smith" />
<MRN id="LD572046" copy="FacilityHC6"/>
<Gender code="M"/>
<DOB value="19301019"/>
<Addresses>
<Address>
<Street value="1 Memorial Drive"/>
<City code="Cambridge"/>
<State code="MA"/>
<Zip code="02142"/>
</Address>
</Addresses>
<Identifiers>
<Identifier id="S2345" copy="FacilityPHLS"/>
<Identifier id="LAB572046" copy="FacilityPHLS"/>
<Identifier id="LN572046" copy="FacilityCGH"/>
</Identifiers>
</Patient>
}

XData HaroldSimpson
{
<Patient>
<Name first="Harold" last="Simpson" />
<MRN id="Ab443" copy="FacilityEMERGENCY"/>
<Gender code="M"/>
<DOB value="19220203"/>
<Addresses>
<Address>
<Street value="14 Tangier Lane"/>
<City code="Eton"/>
<State code="Berks"/>
<Zip code="SL4 6BB"/>
</Address>
</Addresses>
</Patient>
}

XData EricJohnson
{
<Patient>
<Name first="Steve" last="Burns" />
<MRN id="K4567" copy="FacilityCGH"/>
<Gender code="M"/>
<DOB value="19521001"/>
<Addresses>
<Address>
<Street value="15 Trocadero"/>
<City code="Edinburgh"/>
<State code="Lothian"/>
<Zip code="EH2"/>
</Address>
</Addresses>
<Identifiers>
<Identifier id="S2345" copy="FacilityCGH"/>
<Identifier id="S2345" copy="FacilityEMERGENCY"/>
<Identifier id="DMRN45" copy="FacilityCGH"/>
</Identifiers>
</Patient>
}

XData MarlaGonzolez
{
<Patient>
<Name first="Marla" last="Gonzolez" />
<MRN id="S215134" copy="FacilityUMC"/>
<Gender code="F"/>
<DOB value="19850415"/>
<Addresses>
<Address>
<Street value="5206 Elm Drive"/>
<City code="ROSALES"/>
<State code="PANGASINAN"/>
<Zip code="2441"/>
</Address>
</Addresses>
<Identifiers>
<Identifier id="6621224" copy="FacilityMGH"/>
</Identifiers>
</Patient>
}

XData SteveBurns
{
<Patient>
<Name first="Steve" last="Burns" />
<MRN id="53-17-66" copy="FacilitySDA"/>
<Gender code="M"/>
<DOB value="20050213"/>
<Addresses>
<Address>
<Street value="4752 Elm Street"/>
<City code="ANTIPOLO"/>
<State code="RIZAL PROVINCE"/>
<Zip code="1870"/>
</Address>
</Addresses>
</Patient>
}

/*
 * Patients used by test scripts
 */
XData CarlyColson
{
<Patient>
<Name first="Carly" last="Colson" />
<MRN id="CC001" copy="FacilityEXT"/>
<Gender code="F"/>
<DOB value="19850723"/>
<Addresses>
<Address>
<Street value="117 Division St"/>
<City code="Springfield"/>
<State code="IL"/>
<Zip code="62701"/>
</Address>
</Addresses>
</Patient>
}

/// Data used for PIXv3.Consumer to do the merge / split MergeSource becomes SplitTarget
XData MergeSource
{
<Patient>
<Name first="Jane" last="Smith"/>
<MRN id="999.888.111" copy="FacilityEXT"/>
<Gender code="F"/>
<DOB value="19630522"/>
<Addresses>
<Address>
<Street value="3443 N Beach Street"/>
<City code="Beach City"/>
<State code="IL"/>
<Zip code="54321"/>
</Address>
</Addresses>
</Patient>
}

/// Data used for PIXv3.Consumer to do the merge / split MergeTarget becomes SplitSource
XData MergeTarget
{
<Patient>
<Name first="Jane" last="Smyth"/>
<MRN id="888.999.111" copy="FacilityEXT"/>
<Gender code="F"/>
<DOB value="19630522"/>
<Addresses>
<Address>
<Street value="33 N Beach Street"/>
<City code="Beach City"/>
<State code="IL"/>
<Zip code="54321"/>
</Address>
</Addresses>
</Patient>
}

/// A patient that should never exist in the MPI and has no data but a MRN and MPI ID with valid assigning authority
XData InvalidPatient
{
<Patient>
<Name first="Invalid" last="Patient" />
<MRN id="INVALIDMRN" copy="FacilityEXT"/>
<MPI id="INVALIDMPI" copy="LocalHomeCommunity"/>
</Patient>
}

XData NFPatient1
{
<Patient>
<FirstName>Jimmy</FirstName>
<LastName>Dean</LastName>
<MRN>EXT001</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>M</Sex>
<DOB>1957-03-23</DOB>
<Street>3443 S Beach Ave</Street>
<City>Some City</City>
<State>IL</State>
<Zip>12345</Zip>
<Identifiers>
<Identifier><Root>EXTERNAL</Root><Extension>EXT002</Extension></Identifier>
</Identifiers>
</Patient>
}

XData NFPatient2
{
<Patient>
<FirstName>Jimmy</FirstName>
<LastName>Dean</LastName>
<MRN>EXT010</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>M</Sex>
<DOB>1957-03-23</DOB>
<Street>3443 S Beach Ave</Street>
<City>Some City</City>
<State>IL</State>
<Zip>12345</Zip>
<Identifiers>
<Identifier><Root>EXTERNAL</Root><Extension>EXT020</Extension></Identifier>
</Identifiers>
</Patient>
}

XData NFPatient3
{
<Patient>
<FirstName>Jimmy</FirstName>
<LastName>Dean</LastName>
<MRN>EXT030</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>M</Sex>
<DOB>1957-03-23</DOB>
<Street>3443 S Beach Ave</Street>
<City>Some City</City>
<State>IL</State>
<Zip>12345</Zip>
</Patient>
}

/*
 *		Patients from the HL7/SDA test files
 */
XData NFJohnSmith
{
<Patient>
<FirstName>John</FirstName>
<LastName>Smith</LastName>
<MRN>LD572046</MRN>
<AssigningAuthority>HC6</AssigningAuthority>
<Facility>HC6</Facility>
<Sex>M</Sex>
<DOB>1930-10-19</DOB>
<Street>1 Memorial Drive</Street>
<City>Cambridge</City>
<State>MA</State>
<Zip>02142</Zip>
<Identifiers>
<Identifier><Root>PHLS</Root><Extension>S2345</Extension></Identifier>
<Identifier><Root>PHLS</Root><Extension>LAB572046</Extension></Identifier>
<Identifier><Root>CGH</Root><Extension>LN572046</Extension></Identifier>
</Identifiers>
</Patient>
}

XData NFHaroldSimpson
{
<Patient>
<FirstName>Harold</FirstName>
<LastName>Simpson</LastName>
<MRN>Ab443</MRN>
<AssigningAuthority>EMERGENCY</AssigningAuthority>
<Facility>EMERGENCY</Facility>
<Sex>M</Sex>
<DOB>1922-02-03</DOB>
<Street>14 Tangier Lane</Street>
<City>Eton</City>
<State>Berks</State>
<Zip>SL4 6BB</Zip>
</Patient>
}

XData NFEricJohnson
{
<Patient>
<FirstName>Steve</FirstName>
<LastName>Burns</LastName>
<MRN>K4567</MRN>
<AssigningAuthority>CGH</AssigningAuthority>
<Facility>CGH</Facility>
<Sex>M</Sex>
<DOB>1952-10-01</DOB>
<Street>15 Trocadero</Street>
<City>Edinburgh</City>
<State>Lothian</State>
<Zip>EH2</Zip>
<Identifiers>
<Identifier><Root>CGH</Root><Extension>S2345</Extension></Identifier>
<Identifier><Root>EMERGENCY</Root><Extension>S2345</Extension></Identifier>
<Identifier><Root>CGH</Root><Extension>DMRN45</Extension></Identifier>
</Identifiers>
</Patient>
}

XData NFMarlaGonzolez
{
<Patient>
<FirstName>Marla</FirstName>
<LastName>Gonzolez</LastName>
<MRN>S215134</MRN>
<AssigningAuthority>UMC</AssigningAuthority>
<Facility>UMC</Facility>
<Sex>F</Sex>
<DOB>1985-04-15</DOB>
<Street>5206 Elm Drive</Street>
<City>ROSALES</City>
<State>PANGASINAN</State>
<Zip>2441</Zip>
<Identifiers>
<Identifier><Root>MGH</Root><Extension>6621224</Extension></Identifier>
</Identifiers>
</Patient>
}

XData NFSteveBurns
{
<Patient>
<FirstName>Jimmy</FirstName>
<LastName>Dean</LastName>
<MRN>EXT001</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>M</Sex>
<DOB>1957-03-23</DOB>
<Street>3443 S Beach Ave</Street>
<City>Some City</City>
<State>IL</State>
<Zip>12345</Zip>
<Identifiers>
<Identifier><Root>EXTERNAL</Root><Extension>EXT002</Extension></Identifier>
</Identifiers>

<Name first="Steve" last="Burns" />
<MRN id="53-17-66" copy="FacilitySDA"/>
<Gender code="M"/>
<DOB value="20050213"/>
<Addresses>
<Address>
<Street value="4752 Elm Street"/>
<City code="ANTIPOLO"/>
<State code="RIZAL PROVINCE"/>
<Zip code="1870"/>
</Address>
</Addresses>
</Patient>
}

/*
 * Patients used by test scripts
 */
XData NFCarlyColson
{
<Patient>
<FirstName>Jimmy</FirstName>
<LastName>Dean</LastName>
<MRN>EXT001</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>M</Sex>
<DOB>1957-03-23</DOB>
<Street>3443 S Beach Ave</Street>
<City>Some City</City>
<State>IL</State>
<Zip>12345</Zip>
<Identifiers>
<Identifier><Root>EXTERNAL</Root><Extension>EXT002</Extension></Identifier>
</Identifiers>

<Name first="Carly" last="Colson" />
<MRN id="CC001" copy="FacilityEXT"/>
<Gender code="F"/>
<DOB value="19850723"/>
<Addresses>
<Address>
<Street value="117 Division St"/>
<City code="Springfield"/>
<State code="IL"/>
<Zip code="62701"/>
</Address>
</Addresses>
</Patient>
}

/// Data used for PIXv3.Consumer to do the merge / split MergeSource becomes SplitTarget
XData NFMergeSource
{
<Patient>
<FirstName>Jane</FirstName>
<LastName>Smith</LastName>
<MRN>999.888.111</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>F</Sex>
<DOB>1963-05-22</DOB>
<Street>3443 N Beach Street</Street>
<City>Beach City</City>
<State>IL</State>
<Zip>54321</Zip>
</Patient>
}

/// Data used for PIXv3.Consumer to do the merge / split MergeTarget becomes SplitSource
XData NFMergeTarget
{
<Patient>
<FirstName>Jane</FirstName>
<LastName>Smyth</LastName>
<MRN>888.999.111</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>F</Sex>
<DOB>1963-05-22</DOB>
<Street>33 N Beach Street</Street>
<City>Beach City</City>
<State>IL</State>
<Zip>54321</Zip>
</Patient>
}

/// A patient that should never exist in the MPI and has no data but a MRN and MPI ID with valid assigning authority
XData NFInvalidPatient
{
<Patient>
<FirstName>Invalid</FirstName>
<LastName>Patient</LastName>
<MRN>INVALIDMRN</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<MPIID>INVALIDMPI</MPIID>
</Patient>
}

XData NFDSUB
{
<Patient>
<FirstName>Johnny</FirstName>
<LastName>DSUB</LastName>
<MRN>DSUB.1111</MRN>
<AssigningAuthority>EXTERNAL</AssigningAuthority>
<Facility>EXTERNAL</Facility>
<Sex>M</Sex>
<DOB>1975-03-22</DOB>
<Street>435 Peach Drive</Street>
<City>Anytown</City>
<State>IL</State>
<Zip>54331</Zip>
</Patient>
}

}
