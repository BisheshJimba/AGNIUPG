table 33019872 "Temp Service Reminder"
{

    fields
    {
        field(1; "Vehicle Serial No."; Code[20])
        {
        }
        field(2; "Next Service Date"; Date)
        {
        }
        field(3; VIN; Code[20])
        {
        }
        field(4; "Make Code"; Code[20])
        {
        }
        field(5; "Model Code"; Code[20])
        {
        }
        field(6; "Model Version No."; Code[20])
        {
        }
        field(7; "Engine No."; Code[20])
        {
        }
        field(8; Kilometrage; Decimal)
        {
        }
        field(50000; "Vehicle Reg. No."; Code[30])
        {
        }
        field(50001; "Last Visit Date"; Date)
        {
        }
        field(50002; "Accountability Center"; Code[20])
        {
            TableRelation = "Accountability Center".Code;
        }
        field(50003; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));
        }
    }

    keys
    {
        key(Key1; "Next Service Date", "Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

