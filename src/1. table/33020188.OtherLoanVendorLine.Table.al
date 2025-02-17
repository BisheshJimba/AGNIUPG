table 33020188 "Other Loan Vendor Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Repayment Date"; Date)
        {
        }
        field(3; "Repayment Installment"; Decimal)
        {
        }
        field(4; "Line No."; Integer)
        {
            BlankZero = true;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

