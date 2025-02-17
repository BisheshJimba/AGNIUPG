table 33019855 "Veh. Delivery Chklist Lines"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "S.No."; Integer)
        {
        }
        field(3; Particulars; Text[30])
        {
        }
        field(4; Status; Code[10])
        {
        }
        field(5; Remarks; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "S.No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

