table 99003601 "Object Reference"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Version No."; Integer)
        {
        }
        field(3; "Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite;
        }
        field(4; "Object ID"; Integer)
        {
        }
        field(5; SubType; Option)
        {
            OptionMembers = "Object-Properties",Properties,"Fields",Controls,"Keys",Dataitem,Requestform,"Code",Elements,Attributes,Events,MenuNodes,"XML-Events";
        }
        field(6; "SubType No."; Integer)
        {
        }
        field(7; SubType2; Option)
        {
            OptionMembers = "None",Properties,Sections,Controls,"Fields";
        }
        field(8; "SubType2 No."; Integer)
        {
        }
        field(9; SubType3; Option)
        {
            OptionMembers = "None",Properties,Controls;
        }
        field(10; "Field/Control Reference No."; Integer)
        {
        }
        field(11; "Property Reference No."; Integer)
        {
        }
        field(12; "Function Reference No."; Integer)
        {
        }
        field(13; "Var Reference No."; Integer)
        {
        }
        field(14; "Key Reference No."; Integer)
        {
        }
        field(21; "Basic Object"; Boolean)
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
        key(Key2; "Version No.", "Object Type", "Object ID", SubType, "SubType No.", SubType2, "SubType2 No.", SubType3)
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Version No.", "Property Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Version No.", "Field/Control Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key5; "Version No.", "Function Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key6; "Version No.", "Var Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key7; "Version No.", "Object Type", "Object ID", SubType, "SubType No.", SubType2, "SubType2 No.", "Entry No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key8; "Version No.", "Key Reference No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

