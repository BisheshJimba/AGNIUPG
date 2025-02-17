table 33020083 "Hire Purchase Day End Log"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Loan No."; Code[20])
        {
        }
        field(3; Remarks; Text[250])
        {
        }
        field(6; Date; Date)
        {
        }
        field(20; "Payment Amount"; Decimal)
        {
        }
        field(30; "Due Amount"; Decimal)
        {
        }
        field(50; "Loan Customer No."; Code[20])
        {
        }
        field(51; "Loan Customer Name"; Text[50])
        {
        }
        field(52; "Nominee Account No."; Code[20])
        {
        }
        field(53; "Nominee Account Name"; Text[50])
        {
        }
        field(54; Time; Time)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

