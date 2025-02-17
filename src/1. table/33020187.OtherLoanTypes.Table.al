table 33020187 "Other Loan Types"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

