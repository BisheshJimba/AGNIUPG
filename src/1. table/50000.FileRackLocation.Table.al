table 50000 "File Rack Location"
{
    // DrillDownPageID = 33020046;
    // LookupPageID = 33020046;

    fields
    {
        field(1; "Phy. Location"; Code[10])
        {
        }
        field(2; "File Location"; Code[10])
        {
        }
        field(3; "File Location Description"; Text[30])
        {
        }
        field(4; "Rack No."; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Phy. Location")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

