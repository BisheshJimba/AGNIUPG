table 14125609 "Port Master"
{

    fields
    {
        field(1; "Port Code"; Code[20])
        {
        }
        field(2; "Port Name"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Port Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

