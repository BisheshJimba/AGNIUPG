table 33020352 District
{

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Name; Text[80])
        {
        }
        field(3; Zone; Text[50])
        {
        }
        field(4; Region; Text[30])
        {
        }
        field(5; Country; Text[30])
        {
        }
        field(6; Blocked; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

