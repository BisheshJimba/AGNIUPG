table 33020799 "FA Log Entries"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            TableRelation = "Fixed Asset".No.;
        }
        field(2; "Travel Date"; Date)
        {
        }
        field(3; "Request by Employee Name"; Text[70])
        {
        }
        field(4; "Travel Time"; Time)
        {
        }
        field(5; "Gatepass No."; Code[20])
        {
            TableRelation = "Gatepass Header"."Document No";
        }
        field(6; "Odometer Opening"; Decimal)
        {
        }
        field(7; "Travel Type"; Option)
        {
            OptionCaption = ' ,Business,Personal,Office';
            OptionMembers = " ",Business,Personal,Office;
        }
        field(8; "From Destination"; Text[70])
        {
        }
        field(9; "To Destination"; Text[70])
        {
        }
        field(10; Purpose; Text[250])
        {
        }
        field(11; "Driver Name"; Text[70])
        {
        }
        field(12; "Total Trip Distance"; Decimal)
        {
        }
        field(13; "Enter by User Name"; Code[50])
        {
        }
        field(14; "Fuel Quantity"; Decimal)
        {
        }
        field(15; "Memo No."; Code[20])
        {
        }
        field(16; "Maitainance Cost"; Decimal)
        {
        }
        field(17; "Fixed Asset No."; Code[20])
        {
            TableRelation = "Fixed Asset".No.;
        }
        field(18; "Employee No"; Code[20])
        {
            TableRelation = Employee;
        }
        field(19; "Odometer Ending"; Decimal)
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

