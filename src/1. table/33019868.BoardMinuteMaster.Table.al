table 33019868 "Board Minute Master"
{
    DrillDownPageID = 33019868;
    LookupPageID = 33019868;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
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

