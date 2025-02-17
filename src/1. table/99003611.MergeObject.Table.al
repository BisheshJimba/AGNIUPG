table 99003611 "Merge Object"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite;
        }
        field(3; "Object ID"; Integer)
        {
        }
        field(4; "Current Custom Name"; Text[30])
        {
        }
        field(5; "Old Base Name"; Text[30])
        {
        }
        field(6; "New Base Name"; Text[30])
        {
        }
        field(7; "New Custom Name"; Text[30])
        {
        }
        field(8; "Action"; Option)
        {
            OptionMembers = Merge,"Copy Base","Copy New Base","Copy Custom",Delete,Skip;
        }
        field(9; Status; Option)
        {
            OptionMembers = Merged,"Copied Base","Copied New Base","Copied Custom",Deleted,Skipped,"Manual Merge Required",Remerge,Compared," ";
        }
        field(10; "Old Base Version No."; Integer)
        {
        }
        field(11; "Old Base CRC"; Integer)
        {
        }
        field(12; "New Base Version No."; Integer)
        {
        }
        field(13; "New Base CRC"; Integer)
        {
        }
        field(14; "Current Custom Version No."; Integer)
        {
        }
        field(15; "Current Custom CRC"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2; "Object Type", "Object ID")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; Status, "Object Type")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

