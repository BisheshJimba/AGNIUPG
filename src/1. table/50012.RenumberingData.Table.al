table 50012 "Renumbering Data"
{

    fields
    {
        field(1; "Old No."; Code[20])
        {
        }
        field(2; "New No."; Code[20])
        {
        }
        field(3; Modified; Boolean)
        {
            Editable = false;
        }
        field(4; Invalid; Boolean)
        {
            Editable = false;
        }
        field(5; "Modified Tables"; Text[250])
        {
        }
        field(6; "Old Date"; Date)
        {
        }
        field(7; "New Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Old No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

