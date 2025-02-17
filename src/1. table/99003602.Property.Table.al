table 99003602 Property
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
        field(6; Property; Text[30])
        {
        }
        field(7; ShortValue; Text[50])
        {
        }
        field(8; "Line No."; Integer)
        {
        }
        field(9; Value; Text[250])
        {
        }
        field(10; "Reference Area"; Option)
        {
            OptionMembers = "None",ObjectReference,FldCntrl,"Key",Variable;
        }
        field(11; "Property No."; Integer)
        {
        }
        field(12; "Object Consecutive No."; Integer)
        {
        }
        field(13; "Ref.Prop."; Boolean)
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
        key(Key2; "Reference No.", Property, "Line No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Object ID", "Object Type", "Version No.", Property, "Entry No.", ShortValue)
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = true;
        }
        key(Key4; Property, "Entry No.", "Version No.", ShortValue)
        {
            MaintainSIFTIndex = false;
        }
        key(Key5; "Reference No.", "Version No.", "Property No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key6; "Reference No.", "Entry No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key7; "Object ID", "Version No.", "Object Type", Property, "Line No.", "Reference Area")
        {
            MaintainSIFTIndex = false;
        }
        key(Key8; "Reference No.", "Object ID", "Object Type", "Version No.", Property, "Line No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

