table 33020372 "Promotion History"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee Code"; Code[20])
        {
        }
        field(3; "Employee Name"; Text[50])
        {
        }
        field(4; "Current Grade"; Code[10])
        {
        }
        field(5; "Current Designation"; Text[30])
        {
        }
        field(6; "Promoted Grade"; Code[10])
        {
        }
        field(7; "Promoted Designation"; Text[30])
        {
        }
        field(8; "Approved By"; Code[20])
        {
        }
        field(9; "Approver Name"; Text[30])
        {
        }
        field(10; "Approved Date"; Date)
        {
        }
        field(11; Promoted; Boolean)
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

