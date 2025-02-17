table 33020182 "Vehicle Stock Movement Header"
{

    fields
    {
        field(1; VIN; Code[20])
        {
        }
        field(12; "Make Code"; Code[20])
        {
        }
        field(13; "Model Code"; Code[20])
        {
        }
        field(14; "Model Version"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; VIN)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

