table 33020368 "OutDoor Visits"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee Code"; Code[10])
        {
        }
        field(3; Department; Code[10])
        {
        }
        field(4; "Entry Date"; Date)
        {
        }
        field(5; "Add. Entry Date"; Code[10])
        {
        }
        field(6; "Type Plan"; Option)
        {
            OptionMembers = " ","ODD(Outdoor Duty)","ODT(Outdoor Training)","Professional Visit";
        }
        field(7; "From Date"; Date)
        {
        }
        field(8; "Add. From Date"; Code[10])
        {
        }
        field(9; "To Date"; Date)
        {
        }
        field(10; "Add. To Date"; Code[10])
        {
        }
        field(11; Place; Text[30])
        {
        }
        field(12; "Required Time"; Integer)
        {
        }
        field(13; Purpose; Text[30])
        {
        }
        field(14; "Mode Of Travel"; Option)
        {
            OptionMembers = " ",Air,Bus;
        }
        field(15; "Advance Amount"; Decimal)
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

