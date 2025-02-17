table 60005 "VF Registration - Temp"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; "Registration No."; Code[20])
        {
        }
        field(3; VIN; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

