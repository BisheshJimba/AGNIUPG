table 33019989 "CT Shipment Header"
{
    Caption = 'Posted CT Shipment Header';
    LookupPageID = 33019984;

    fields
    {
        field(2; "No."; Code[20])
        {
        }
        field(3; "Transfer From Code"; Code[10])
        {
        }
        field(4; "Transfer To Code"; Code[10])
        {
        }
        field(5; "Transfer From Department"; Code[20])
        {
        }
        field(6; "Transfer To Department"; Code[20])
        {
        }
        field(8; "Posting Date"; Date)
        {
        }
        field(9; "Document Date"; Date)
        {
            Description = 'Internally used for change tracking';
        }
        field(10; "Transfer From Name"; Text[50])
        {
        }
        field(11; "Transfer From Address"; Text[50])
        {
        }
        field(12; "Transfer From Address 2"; Text[50])
        {
        }
        field(13; "Transfer From Post Code"; Code[10])
        {
            TableRelation = "Post Code".Code;
        }
        field(14; "Transfer From City"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(Transfer From Post Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Transfer From Contact"; Text[30])
        {
        }
        field(16; "Shipment Date"; Date)
        {
        }
        field(17; "Shipment Method Code"; Code[10])
        {
        }
        field(18; "Shipping Agent Code"; Code[10])
        {
        }
        field(19; "Shipping Time"; Time)
        {
        }
        field(20; "Transfer To Name"; Text[50])
        {
        }
        field(21; "Transfer To Address"; Text[50])
        {
        }
        field(22; "Transfer To Address 2"; Text[50])
        {
        }
        field(23; "Transfer To Post Code"; Code[10])
        {
            TableRelation = "Post Code".Code;
        }
        field(24; "Transfer To City"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(Transfer To Post Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Transfer To Contact"; Text[30])
        {
        }
        field(26; "Receipt Date"; Date)
        {
        }
        field(27; "Transaction Type"; Code[10])
        {
        }
        field(28; "Transport Method"; Code[10])
        {
        }
        field(29; "CT No."; Code[20])
        {
        }
        field(30; Insurance; Boolean)
        {
        }
        field(32; "User ID"; Code[50])
        {
        }
        field(33; "Responsibility Center"; Code[10])
        {
        }
        field(34; "Transfer No."; Code[20])
        {
            Description = 'Carried from Transfer Header';
        }
        field(35; Void; Boolean)
        {
            Description = 'If this document is returned then this flag is set to true';
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

