table 60014 "Update VF Calculated Penalty"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
        }
        field(2; "Loan No."; Code[20])
        {
        }
        field(3; "Installment No."; Integer)
        {
        }
        field(4; "Receipt No."; Code[20])
        {
        }
        field(5; "Penalty Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

