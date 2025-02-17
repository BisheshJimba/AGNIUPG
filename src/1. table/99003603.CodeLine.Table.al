table 99003603 "Code Line"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Version No."; Integer)
        {
        }
        field(3; "Reference No."; Integer)
        {
        }
        field(4; "Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite;
        }
        field(5; "Object ID"; Integer)
        {
        }
        field(6; SubType; Option)
        {
            OptionMembers = Documentation,"Procedure","Local Procedure","Trigger",FieldTrigger,ControlTrigger,"Event",ElementTrigger,AttributeTrigger,XMLEvent;
        }
        field(7; "Line No."; Integer)
        {
        }
        field(9; Line; Text[250])
        {
        }
        field(11; TransferFieldsExists; Boolean)
        {
        }
        field(12; AssignmentExists; Boolean)
        {
        }
        field(13; SetCurrentKeyExists; Boolean)
        {
        }
        field(14; RunExists; Boolean)
        {
        }
        field(15; "Custom Entry No."; Integer)
        {
        }
        field(16; "Base Entry No."; Integer)
        {
        }
        field(17; "NewBase Entry No."; Integer)
        {
        }
        field(18; "Custom Line Status"; Integer)
        {
        }
        field(19; "Base Line Status"; Integer)
        {
        }
        field(20; "New Base Line Status"; Integer)
        {
        }
        field(21; "New Custom Line Status"; Integer)
        {
        }
        field(22; "Use Line Status"; Integer)
        {
        }
        field(23; "Object Consecutive No."; Integer)
        {
        }
        field(24; NumberAccess; Boolean)
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
        key(Key2; "Reference No.", "Line No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Version No.", "Object Type", "Object ID", "Reference No.", "Line No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Version No.", "Object Type", "Object ID", RunExists)
        {
            MaintainSIFTIndex = false;
        }
        key(Key5; "Version No.", "Object Type", "Object ID", NumberAccess)
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

