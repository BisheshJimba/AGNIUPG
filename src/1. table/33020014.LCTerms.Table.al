table 33020014 "LC Terms"
{

    fields
    {
        field(1; "LC No."; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Attachment No."; Integer)
        {
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; Date; Date)
        {
        }
        field(6; Released; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "LC No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

