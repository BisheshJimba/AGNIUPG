table 33020244 "Service Satisfaction Questions"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Question; Text[250])
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

