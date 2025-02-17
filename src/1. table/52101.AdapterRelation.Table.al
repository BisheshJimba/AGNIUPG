table 52101 "Adapter Relation"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Table No."; Integer)
        {
        }
        field(2; "Related Table No."; Integer)
        {
        }
        field(3; "Field No."; Integer)
        {
        }
        field(4; "Field Name/Value"; Text[250])
        {
        }
        field(5; "Related Field No."; Integer)
        {
        }
        field(6; "Related Field Name/Value"; Text[250])
        {
        }
        field(7; "Relation Type"; Text[30])
        {
        }
        field(8; "Relation Condition"; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.", "Related Table No.", "Related Field No.", "Relation Condition")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

