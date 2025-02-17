table 99003608 "Relation to Table"
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
        field(5; "Object Name"; Text[30])
        {
        }
        field(6; "Field Name"; Text[50])
        {
        }
        field(7; "To Table No."; Integer)
        {
        }
        field(8; "To Table Name"; Text[30])
        {
        }
        field(9; "To Table Field Name"; Text[50])
        {
        }
        field(10; MultiRelation; Boolean)
        {
        }
        field(11; "Property Reference No."; Integer)
        {
        }
        field(12; "Line No."; Integer)
        {
        }
        field(13; "To Object Reference No."; Integer)
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
        key(Key2; "Version No.", "Object Type", "Object ID", "To Table Name")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Version No.", "To Table No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

