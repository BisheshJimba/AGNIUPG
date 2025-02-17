table 99003614 "Merge Wizard"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Current Custom Name"; Text[30])
        {
        }
        field(3; "Current Custom Version No."; Integer)
        {
        }
        field(4; "Old Base Name"; Text[30])
        {
        }
        field(5; "Old Base Version No."; Integer)
        {
        }
        field(6; "New Base Name"; Text[30])
        {
        }
        field(7; "New Base Version No."; Integer)
        {
        }
        field(8; "New Custom Name"; Text[30])
        {
        }
        field(9; "New Custom Version No."; Integer)
        {
        }
        field(10; "New Custom Version List"; Text[80])
        {
        }
        field(11; "New Date"; Date)
        {
        }
        field(12; "New Time"; Time)
        {
        }
        field(13; "Version List Option"; Option)
        {
            OptionMembers = Add,Merge,New;
        }
        field(14; "Action"; Option)
        {
            OptionMembers = Merge,"Compare Objects";
        }
        field(15; "Current Custom File Name"; Text[250])
        {
        }
        field(16; "Old Base File Name"; Text[250])
        {
        }
        field(17; "New Base File Name"; Text[250])
        {
        }
        field(18; "New Custom Description"; Text[50])
        {
        }
        field(19; "New Custom Description 2"; Text[50])
        {
        }
        field(20; "Merge Process Interrupted"; Boolean)
        {
        }
        field(21; "Focus on Objects"; Option)
        {
            OptionMembers = "all Versions","Current Custom Version","New Base Version";
        }
        field(22; "Import all Objects"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(23; "Changed CC Only"; Boolean)
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
    }

    fieldgroups
    {
    }
}

