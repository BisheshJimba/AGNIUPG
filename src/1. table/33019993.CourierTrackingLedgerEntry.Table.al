table 33019993 "Courier Tracking Ledger Entry"
{
    Caption = 'Courier Tracking Ledger Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Document Type"; Option)
        {
            OptionCaption = 'Shipment,Receipt,Return';
            OptionMembers = Shipment,Receipt,Return;
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(5; "Document Date"; Date)
        {
        }
        field(6; "Receipt Date"; Date)
        {
        }
        field(7; "Shipment Date"; Date)
        {
        }
        field(8; "Shipment Agent Code"; Code[10])
        {
        }
        field(9; "POD No."; Code[20])
        {
        }
        field(10; "AWB No."; Code[20])
        {
        }
        field(11; "Packet No."; Code[20])
        {
        }
        field(12; Description; Text[50])
        {
        }
        field(13; "Packet Type"; Option)
        {
            OptionCaption = 'Document,Item,Fixed Asset,Others';
            OptionMembers = Document,Item,"Fixed Asset",Others;
        }
        field(14; Weight; Decimal)
        {
        }
        field(15; Rate; Decimal)
        {
        }
        field(16; Amount; Decimal)
        {
        }
        field(17; Quantity; Decimal)
        {
        }
        field(18; "Quantity Shipped"; Decimal)
        {
        }
        field(19; "Quantity Received"; Decimal)
        {
        }
        field(20; "Quantity Returned"; Decimal)
        {
        }
        field(21; "User ID"; Code[50])
        {
        }
        field(22; Complete; Boolean)
        {
        }
        field(23; "Transfer From Code"; Code[10])
        {
        }
        field(24; "Transfer To Code"; Code[10])
        {
        }
        field(25; "Transfer From Department"; Code[20])
        {
        }
        field(26; "Transfer To Department"; Code[20])
        {
        }
        field(27; "Return Date"; Date)
        {
        }
        field(28; "Source Code"; Code[10])
        {
        }
        field(29; "Source Doc. No."; Code[20])
        {
        }
        field(30; "Shipment Method Code"; Code[10])
        {
        }
        field(31; "Canelled Shipment"; Boolean)
        {
            Description = 'Flag - returned shipment';
        }
        field(32; "Returned Date"; Date)
        {
        }
        field(33; "CT No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Shipment Agent Code", "Posting Date")
        {
        }
        key(Key3; "Transfer From Code", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

