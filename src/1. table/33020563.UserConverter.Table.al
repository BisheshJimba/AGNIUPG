table 33020563 "User Converter"
{

    fields
    {
        field(1; "Old UserName"; Code[50])
        {
        }
        field(2; "New UserName"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Old UserName")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

