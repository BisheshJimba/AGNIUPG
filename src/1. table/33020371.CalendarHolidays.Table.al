table 33020371 "Calendar Holidays"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Nepali Year"; Integer)
        {
        }
        field(3; Date; Date)
        {
        }
        field(4; "Nepali Date"; Code[10])
        {
        }
        field(7; "Day Type"; Option)
        {
            OptionMembers = " ","Paid Holiday","Floating Holiday";
        }
        field(8; Remarks; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

