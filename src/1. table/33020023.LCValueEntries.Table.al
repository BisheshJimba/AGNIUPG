table 33020023 "LC Value Entries"
{

    fields
    {
        field(1; "LC Code"; Code[20])
        {
            TableRelation = "LC Details";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Insurance,Letter of Credit';
            OptionMembers = Insurance,"Letter of Credit";
        }
        field(4; "Charge (LCY)"; Decimal)
        {
        }
        field(5; "Value (LCY)"; Decimal)
        {
        }
        field(6; "Item Charge"; Boolean)
        {
            Editable = false;
        }
        field(7; "Document No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "LC Code", "Line No.", Type)
        {
            Clustered = true;
        }
        key(Key2; "LC Code", Type, "Item Charge")
        {
            SumIndexFields = "Charge (LCY)", "Value (LCY)";
        }
    }

    fieldgroups
    {
    }
}

