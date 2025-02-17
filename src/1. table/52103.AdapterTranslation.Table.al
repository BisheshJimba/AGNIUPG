table 52103 "Adapter Translation"
{
    DataPerCompany = false;

    fields
    {
        field(1; Type; Text[30])
        {
        }
        field(2; "Table No."; Integer)
        {
        }
        field(3; "Field No."; Integer)
        {
        }
        field(4; "Option Value"; Integer)
        {
        }
        field(5; "Language Code"; Code[10])
        {
        }
        field(6; Translation; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; Type, "Table No.", "Field No.", "Option Value", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

