table 33020529 "Leave Encash Ledger"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type"."Leave Type Code";
        }
        field(4; "Register Date"; Date)
        {
            Editable = false;
        }
        field(5; "User Id"; Code[50])
        {
        }
        field(6; "Fiscal Year"; Code[10])
        {
        }
        field(7; "Encash Source"; Option)
        {
            Editable = false;
            OptionMembers = " ","Year End Encash",Resignation;
        }
        field(8; Days; Decimal)
        {
        }
        field(9; Type; Option)
        {
            OptionCaption = 'Earn,Encashed';
            OptionMembers = Earn,Encashed;
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

