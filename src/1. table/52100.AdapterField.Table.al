table 52100 "Adapter Field"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Table No."; Integer)
        {
        }
        field(2; "Table Name"; Text[30])
        {
        }
        field(3; "Field No."; Integer)
        {
        }
        field(4; "Field Name"; Text[30])
        {
        }
        field(5; "Field Type"; Text[30])
        {
        }
        field(6; "Field Class"; Text[30])
        {
        }
        field(7; "Data Per Company"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

