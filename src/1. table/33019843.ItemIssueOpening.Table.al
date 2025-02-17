table 33019843 "Item Issue Opening"
{

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(3; "Issue Qty."; Decimal)
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Valid From"; Date)
        {
        }
        field(6; "Valid To"; Date)
        {
        }
        field(7; "Stock Qty"; Decimal)
        {
        }
        field(8; "Average Issue"; Decimal)
        {
        }
        field(10; PCT; Decimal)
        {
        }
        field(11; Class; Option)
        {
            OptionCaption = ' ,A,B,C';
            OptionMembers = " ",A,B,C;
        }
        field(12; "Spare Type"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Location Code", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

