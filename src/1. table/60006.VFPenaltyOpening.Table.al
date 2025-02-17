table 60006 "VF Penalty Opening"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; "Receipt No."; Code[20])
        {
        }
        field(3; "Receipt Date"; Date)
        {
        }
        field(4; "Delay Days"; Integer)
        {
        }
        field(5; "Calculated Penalty"; Decimal)
        {
        }
        field(6; Updated; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Receipt No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

