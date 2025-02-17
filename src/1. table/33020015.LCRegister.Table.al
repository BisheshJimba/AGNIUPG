table 33020015 "LC Register"
{

    fields
    {
        field(1; "LC No."; Code[20])
        {
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; "From Entry No."; Integer)
        {
        }
        field(6; "To Entry No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "LC No.", "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

