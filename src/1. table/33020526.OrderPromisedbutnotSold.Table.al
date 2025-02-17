table 33020526 "Order Promised but not Sold"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(6; "Created By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(50; "Make Code"; Code[20])
        {
            TableRelation = Make;
        }
        field(51; "Model Code"; Code[20])
        {
            TableRelation = Model;
        }
        field(52; "Model Version No."; Code[20])
        {
        }
        field(53; VIN; Code[20])
        {
        }
        field(54; "Confirmed Date"; Date)
        {
        }
        field(55; "Confirmed Time"; Time)
        {
        }
        field(56; "Allotment Date"; Date)
        {
        }
        field(57; "Allotment Time"; Time)
        {
        }
        field(58; "Vehicle Serial No."; Code[20])
        {
        }
        field(59; "Document Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

