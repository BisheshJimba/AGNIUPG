table 33020155 "Test Drive Line"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
        }
        field(2; Date; Date)
        {
        }
        field(3; "Rating Factor"; Code[10])
        {
        }
        field(4; "Rating Factor Description"; Text[150])
        {
        }
        field(5; "Excellent (5)"; Decimal)
        {
        }
        field(6; "V. Good (4)"; Decimal)
        {
        }
        field(7; "Average (3)"; Decimal)
        {
        }
        field(8; "Below Average (2)"; Decimal)
        {
        }
        field(9; "Bad (1)"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Prospect No.", Date, "Rating Factor")
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
        key(Key3; "Rating Factor")
        {
        }
    }

    fieldgroups
    {
    }
}

