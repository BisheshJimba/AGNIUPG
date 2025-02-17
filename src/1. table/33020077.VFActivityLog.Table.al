table 33020077 "VF Activity Log"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Loan No."; Code[20])
        {
            TableRelation = "Vehicle Finance Header"."Loan No.";
        }
        field(3; Date; Date)
        {
        }
        field(4; "User ID"; Code[50])
        {
        }
        field(5; "Activity Type"; Option)
        {
            OptionCaption = ' ,VIN Blocked,VIN Unblocked,Vehicle Captured,Vehicle Uncaptured,Loan Closed,Loan Reopen,Marked Defaulter,Unmarked Defaulter,Loan Disbursed,Transfered,Reversed,Wave Penalty,Undo Wave Penalty,Accidental';
            OptionMembers = " ","VIN Blocked","VIN Unblocked","Vehicle Captured","Vehicle Uncaptured","Loan Closed","Loan Reopen","Marked Defaulter","Unmarked Defaulter","Loan Disbursed",Transfered,Reversed,"Wave Penalty","Undo Wave Penalty",Accidental;
        }
        field(50000; Remarks; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

