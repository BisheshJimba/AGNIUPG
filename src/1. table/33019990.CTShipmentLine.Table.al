table 33019990 "CT Shipment Line"
{
    Caption = 'Posted CT Shipment Line';

    fields
    {
        field(2; "Document No."; Code[20])
        {
            TableRelation = "CT Shipment Header".No.;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "POD No."; Code[20])
        {
        }
        field(5; "AWB No."; Code[20])
        {
        }
        field(6; "Packet No."; Code[20])
        {
            Description = 'Link with Item.';
        }
        field(7; Description; Text[50])
        {
        }
        field(8; "Packet Type"; Option)
        {
            Description = 'Have to consult with admin dept.';
            OptionCaption = 'Document,Item,Fixed Asset,Others';
            OptionMembers = Document,Item,"Fixed Asset",Others;
        }
        field(9; Weight; Decimal)
        {
        }
        field(10; Rate; Decimal)
        {
        }
        field(11; Amount; Decimal)
        {
        }
        field(12; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(13; Quantity; Decimal)
        {
        }
        field(14; "Quantity Shipped"; Decimal)
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

