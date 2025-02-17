table 50013 "Modify Posted Document Date"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Posting Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

