table 99003607 "Key"
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
        field(4; "Table No."; Integer)
        {
        }
        field(5; "Key No."; Integer)
        {
        }
        field(6; Active; Boolean)
        {
        }
        field(7; "Field Name"; Text[50])
        {
        }
        field(8; "Property Reference No."; Integer)
        {
        }
        field(9; "Object Consecutive No."; Integer)
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
        key(Key2; "Reference No.", "Key No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; "Version No.", "Table No.", "Property Reference No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Version No.", "Table No.", "Entry No.", "Key No.", "Field Name")
        {
            MaintainSIFTIndex = false;
        }
        key(Key5; "Reference No.", "Entry No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }
}

