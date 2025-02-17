table 99003605 "Function"
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
        field(7; "Function No."; Integer)
        {
        }
        field(8; Name; Text[50])
        {
        }
        field(9; "Variable Reference No."; Integer)
        {
        }
        field(10; "Code Reference No."; Integer)
        {
        }
        field(11; "Object Consecutive No."; Integer)
        {
        }
        field(12; DeletedFunction; Integer)
        {
        }
        field(13; CodeChecksum; Integer)
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
        key(Key2; "Reference No.", SubType, "Function No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Version No.", "Object Type", "Object ID", SubType, "Variable Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Version No.", "Code Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key5; "Version No.", "Object Type", "Object ID", SubType, "Function No.", Name)
        {
            MaintainSIFTIndex = false;
        }
        key(Key6; "Reference No.", "Entry No.", DeletedFunction)
        {
            MaintainSIFTIndex = false;
        }
        key(Key7; "Version No.", "Reference No.", "Object Type", "Object ID", SubType, "Function No.", Name)
        {
            MaintainSIFTIndex = false;
        }
        key(Key8; "Reference No.", "Function No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

