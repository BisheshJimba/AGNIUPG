table 33020523 "Showroom Vehicle Detail"
{

    fields
    {
        field(1; "Vehicle Serial No."; Code[20])
        {
        }
        field(2; VIN; Code[20])
        {
        }
        field(3; "Engine No."; Code[20])
        {
        }
        field(4; "Registration No."; Code[20])
        {
        }
        field(51; "Location Code"; Code[20])
        {
        }
        field(52; "Document No."; Code[20])
        {
        }
        field(53; "System Allocated"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

