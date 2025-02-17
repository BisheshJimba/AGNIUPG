table 33020074 "Vehicle Finance App. Lines"
{

    fields
    {
        field(1; "Application No."; Code[20])
        {
            TableRelation = "Vehicle Finance Header";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "EMI Mature Date"; Date)
        {
        }
        field(4; "EMI Amount"; Decimal)
        {
        }
        field(5; "Calculated Principal"; Decimal)
        {
        }
        field(6; "Calculated Interest"; Decimal)
        {
        }
        field(7; Balance; Decimal)
        {
        }
        field(8; "Installment No."; Integer)
        {
        }
        field(9; "Calculated Penalty"; Decimal)
        {
        }
        field(10; "Calculated Rebate"; Decimal)
        {
        }
        field(11; "Delay by No. of Days"; Decimal)
        {
        }
        field(12; "Principal Paid"; Decimal)
        {
        }
        field(13; "Interest Paid"; Decimal)
        {
        }
        field(14; "Penalty Paid"; Decimal)
        {
        }
        field(15; "Rebate Adjusted"; Decimal)
        {
        }
        field(16; "Actual Balance"; Decimal)
        {
        }
        field(17; "Insurance Paid"; Decimal)
        {
        }
        field(18; "Last Payment Date"; Date)
        {
        }
        field(19; "Line Cleared"; Boolean)
        {
        }
        field(20; "Duration of days fr Prev. Mnth"; Integer)
        {
        }
        field(21; "Remaining Principal Amount"; Decimal)
        {
        }
        field(22; "Last Payment Received Date"; Date)
        {
        }
        field(50; "Pending Interest"; Decimal)
        {
        }
        field(51; "Last Receipt No."; Code[20])
        {
        }
        field(52; "Interest Rate"; Decimal)
        {
        }
        field(53; "Temp Calculated Penalty"; Decimal)
        {
        }
        field(54; "Total Principal Paid"; Decimal)
        {
        }
        field(55; "Total Interest Paid"; Decimal)
        {
        }
        field(56; "Total Penalty Paid"; Decimal)
        {
        }
        field(50000; "Temp Penalty Delay Days"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Application No.", "Installment No.")
        {
            Clustered = true;
            SumIndexFields = "EMI Amount";
        }
        key(Key2; "Installment No.")
        {
            SumIndexFields = "EMI Amount";
        }
        key(Key3; "Line No.")
        {
            SumIndexFields = "EMI Amount";
        }
    }

    fieldgroups
    {
    }
}

