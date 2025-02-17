table 33020394 "Out Door Header"
{

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; "Employee Code"; Code[10])
        {
        }
        field(3; "Employee Name"; Text[30])
        {
        }
        field(4; "OD Start Date"; Date)
        {
        }
        field(5; "OD Start Time"; Time)
        {
        }
        field(6; "OD End Date"; Date)
        {
        }
        field(7; "OD End Time"; Time)
        {
        }
        field(8; "OD Type"; Option)
        {
            Description = '// Domestic,International';
            OptionMembers = Domestic,International;
        }
        field(9; "Mode of Visit"; Code[10])
        {
            TableRelation = "Gate Pass Register";
        }
        field(10; "Compnay Visited"; Text[30])
        {
        }
        field(11; "Visited Person"; Text[30])
        {
        }
        field(12; "Purpose of Visit"; Text[30])
        {
        }
        field(13; "No of Days"; Integer)
        {
        }
        field(14; "Advance Taken"; Decimal)
        {
        }
        field(15; "Approvar Id"; Code[10])
        {
        }
        field(16; "Approvar Name"; Code[10])
        {
        }
        field(17; "Approval Date"; Date)
        {
        }
        field(18; Posted; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

