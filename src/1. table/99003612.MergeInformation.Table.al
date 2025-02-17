table 99003612 "Merge Information"
{

    fields
    {
        field(1; "Table No."; Integer)
        {
        }
        field(2; "Old Base Entry No."; Integer)
        {
        }
        field(3; "Current Custom Entry No."; Integer)
        {
        }
        field(4; "New Base Entry No."; Integer)
        {
        }
        field(5; "New Custom Entry No."; Integer)
        {
        }
        field(6; Status; Option)
        {
            BlankZero = false;
            NotBlank = false;
            OptionMembers = "None",Info,Err,Solved,SolvedErr,SolvedInfo,Color;
        }
        field(7; "Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite;
        }
        field(8; "Object ID"; Integer)
        {
        }
        field(9; "Field No."; Integer)
        {
        }
        field(10; "Rule No."; Integer)
        {
        }
        field(11; "Status 2"; Option)
        {
            BlankZero = false;
            OptionMembers = "None",CodeInfo,CodeErr,Warn,CodeErrSolved;
        }
        field(12; "Object Color"; Text[4])
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Old Base Entry No.", "Current Custom Entry No.", "New Base Entry No.", "Field No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2; "Object Type", "Object ID")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

