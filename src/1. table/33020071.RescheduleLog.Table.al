table 33020071 "Reschedule Log"
{
    DrillDownPageID = 33020084;
    LookupPageID = 33020084;

    fields
    {
        field(1; Date; Date)
        {
        }
        field(2; "Vehicle Finance No."; Code[20])
        {
            TableRelation = "Vehicle Finance Header";
        }
        field(3; "Installment No."; Integer)
        {
        }
        field(4; "Old Principal"; Decimal)
        {
        }
        field(5; "Old Interest Rate"; Decimal)
        {
        }
        field(6; "Old Tenure"; Integer)
        {
        }
        field(7; "Remaining Principal"; Decimal)
        {
        }
        field(8; "New Principal"; Decimal)
        {
        }
        field(9; "Total New Principal"; Decimal)
        {
        }
        field(10; "New Interest Rate"; Decimal)
        {
        }
        field(11; "New Tenure"; Integer)
        {
        }
        field(12; "Change in Principal"; Decimal)
        {
        }
        field(13; "Effective Date"; Date)
        {
        }
        field(20; "User ID"; Code[50])
        {
        }
        field(21; "Reason for Rescheduling"; Text[100])
        {
        }
        field(22; "Reschedule Type"; Option)
        {
            OptionMembers = EMI,Tenure;
        }
        field(23; "Prepayment Amount"; Decimal)
        {
        }
        field(24; "Check of Bank"; Text[50])
        {
        }
        field(25; "Deposited to Bank"; Code[20])
        {
            TableRelation = "Bank Account".No.;
        }
        field(26; "Check No."; Code[20])
        {
        }
        field(27; "Line No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Date, "Vehicle Finance No.", "Installment No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

