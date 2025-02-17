table 99003609 "Relation from Object"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Version No."; Integer)
        {
        }
        field(4; "Table No."; Integer)
        {
        }
        field(5; "Table Name"; Text[30])
        {
        }
        field(6; "Field Name"; Text[50])
        {
        }
        field(7; "From Object Type"; Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite;
        }
        field(8; "From Object ID"; Integer)
        {
        }
        field(9; "From Object Name"; Text[30])
        {
        }
        field(10; "From Field Name"; Text[50])
        {
        }
        field(11; MultiRelation; Boolean)
        {
        }
        field(12; "Property Reference No."; Integer)
        {
        }
        field(13; "Line No."; Integer)
        {
        }
        field(14; "From Object Reference No."; Integer)
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
        key(Key2; "Version No.", "Table No.", "From Object Name")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Version No.", "Table No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Version No.", "From Object Type", "From Object ID")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

