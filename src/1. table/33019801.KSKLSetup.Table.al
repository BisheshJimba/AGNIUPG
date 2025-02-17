table 33019801 "KSKL Setup"
{
    DrillDownPageID = 80062;
    LookupPageID = 80062;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Segment Identifier HD"; Code[20])
        {
        }
        field(3; "Segment Identifier CF"; Code[20])
        {
        }
        field(4; "Segment Identifier CH"; Code[20])
        {
        }
        field(5; "Segment Identifier CS"; Code[20])
        {
        }
        field(6; "Segment Identifier RS"; Code[20])
        {
        }
        field(7; "Segment Identifier BR"; Code[20])
        {
        }
        field(8; "Segment Identifier SS"; Code[20])
        {
        }
        field(9; "Segment Identifier VS"; Code[20])
        {
        }
        field(10; "Segment Identifier VR"; Code[20])
        {
        }
        field(11; "Segment Identifier TL"; Code[20])
        {
        }
        field(12; "Identification Number"; Code[50])
        {
        }
        field(13; "IFF Version ID"; Integer)
        {
        }
        field(14; "Prev Identification Number"; Code[50])
        {
        }
        field(15; "Customer RE Number"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "IFF Version ID(Commercial)"; Code[10])
        {
        }
        field(17; "IFF Version ID(Consumer)"; Code[10])
        {
        }
        field(18; "Nature of Data(Commercial)"; Code[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Nature of Data));
        }
        field(19; "Nature of Data(Consumer)"; Code[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Nature of Data));
        }
        field(20; "Consumer Segment Identifier ES"; Code[20])
        {
        }
        field(21; "Consumer Segment Identifier HD"; Code[20])
        {
        }
        field(22; "Consumer Segment Identifier CF"; Code[20])
        {
        }
        field(23; "Consumer Segment Identifier CH"; Code[20])
        {
        }
        field(24; "Consumer Segment Identifier CS"; Code[20])
        {
        }
        field(25; "Consumer Segment Identifier RS"; Code[20])
        {
        }
        field(26; "Consumer Segment Identifier BR"; Code[20])
        {
        }
        field(27; "Consumer Segment Identifier SS"; Code[20])
        {
        }
        field(28; "Consumer Segment Identifier VS"; Code[20])
        {
        }
        field(29; "Consumer Segment Identifier VR"; Code[20])
        {
        }
        field(30; "Consumer Segment Identifier TL"; Code[20])
        {
        }
        field(31; "File Path"; Text[150])
        {
        }
        field(32; "Branch Id"; Text[30])
        {
        }
        field(33; "Previous Branch Id"; Text[30])
        {
        }
        field(34; "Skiping Payment Flag"; Code[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Payment Delay History Flag));
        }
        field(35; "Skip VR and VS"; Code[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Security Valuator Type));
        }
        field(36; "Closed Loan"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

