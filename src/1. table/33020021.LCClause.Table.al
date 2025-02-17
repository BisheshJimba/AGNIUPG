table 33020021 "LC Clause"
{
    DrillDownPageID = 33020023;
    LookupPageID = 33020023;

    fields
    {
        field(1; "Clause No."; Code[10])
        {
        }
        field(2; "Clause Description"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Clause No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

