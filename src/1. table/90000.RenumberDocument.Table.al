table 90000 "Renumber Document"
{

    fields
    {
        field(1; "SN."; Integer)
        {
        }
        field(2; "Old Invoice No."; Code[20])
        {
        }
        field(3; "New Invoice No."; Code[20])
        {
        }
        field(4; "Old Posting Date"; Date)
        {
        }
        field(5; "New Posting Date"; Date)
        {
        }
        field(6; Updated; Boolean)
        {
        }
        field(7; Merge; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "SN.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

