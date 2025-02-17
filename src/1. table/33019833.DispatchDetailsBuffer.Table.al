table 33019833 "Dispatch Details Buffer"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
        }
        field(2; "Our Order No."; Code[20])
        {
        }
        field(3; "Received Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(4; "Vendor Order No."; Code[20])
        {
        }
        field(5; "Vendor Invoice No."; Code[20])
        {
        }
        field(6; "Ordered Qty."; Decimal)
        {
        }
        field(7; "Item No."; Code[20])
        {
            TableRelation = Item.No.;
        }
        field(9; Status; Option)
        {
            OptionCaption = ' ,Modified,Not Found';
            OptionMembers = " ",Modified,"Not Found";
        }
        field(10; "Outstanding Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(11; "Purchase Price"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Item No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Our Order No.")
        {
        }
    }

    fieldgroups
    {
    }
}

