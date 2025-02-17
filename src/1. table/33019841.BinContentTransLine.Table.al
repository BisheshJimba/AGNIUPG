table 33019841 "Bin Content Trans. Line"
{

    fields
    {
        field(1; "Document No."; Integer)
        {
            TableRelation = "Bin Content Trans. Header".No.;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Ref No."; Text[100])
        {
        }
        field(5; "Rec Qty"; Decimal)
        {
        }
        field(6; "Rec Amt"; Decimal)
        {
        }
        field(7; "Issued Qty"; Decimal)
        {
        }
        field(8; "Issued Amt"; Decimal)
        {
        }
        field(9; "Bal Qty"; Decimal)
        {
        }
        field(10; "Date Filter"; Date)
        {
        }
        field(11; "Location Filter"; Code[10])
        {
        }
        field(12; "Item No. Filter"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

