table 33020524 "Combined Confirmed Detail"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Transfer Order,Sales Order';
            OptionMembers = " ","Transfer Order","Sales Order";
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Confirmed Date"; Date)
        {
        }
        field(4; "Confirmed Time"; Time)
        {
        }
        field(5; "Model Version No."; Code[20])
        {
        }
        field(6; "Location Code"; Code[10])
        {
        }
        field(7; "Line No."; Integer)
        {
        }
        field(8; "Variant Code"; Code[20])
        {
        }
        field(9; "Document Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Confirmed Date", "Confirmed Time")
        {
        }
    }

    fieldgroups
    {
    }
}

