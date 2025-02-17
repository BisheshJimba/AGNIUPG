table 33020393 "Gate Pass Register"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; Employee; Code[10])
        {
        }
        field(3; "Gate Pass Date"; Decimal)
        {
        }
        field(4; "Gate Pass Start Time (Expted)"; Time)
        {
        }
        field(5; "Gate Pass End Time (Expted)"; Time)
        {
        }
        field(6; "Duration of Gate Pass (Expted)"; Decimal)
        {
        }
        field(7; "Gate Pass Start Time (Actual)"; Time)
        {
        }
        field(8; "Gate Pass End Time (Actual)"; Time)
        {
        }
        field(9; "Duration of Gate Pass (Actual)"; Decimal)
        {
        }
        field(10; "Reason For Gate Pass"; Text[30])
        {
        }
        field(11; "Reason For Delay"; Text[30])
        {
        }
        field(12; "Approvar Code"; Code[10])
        {
            TableRelation = Employee;
        }
        field(13; "Approval Date"; Date)
        {
        }
        field(14; "Approval Time"; Time)
        {
        }
        field(15; "Approval Document Type"; Option)
        {
            Description = '//Email,Hardcopy';
            OptionMembers = Email,Hardcopy;
        }
        field(16; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1),
                                                          Dimension Value Type=FILTER(Standard));
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

