table 61000 "Update Posted Cr. Memo"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Original Invoice No."; Code[20])
        {
        }
        field(4; Returned; Boolean)
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

