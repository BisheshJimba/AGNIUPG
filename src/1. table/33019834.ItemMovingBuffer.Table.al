table 33019834 "Item Moving Buffer"
{
    Caption = 'Item Amount';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(2; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(3; "Amount 2"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount 2';
        }
        field(4; Rank; Option)
        {
            OptionCaption = ' ,A,B,C';
            OptionMembers = " ",A,B,C;
        }
        field(5; "Sales Qty."; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Amount, "Amount 2", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

