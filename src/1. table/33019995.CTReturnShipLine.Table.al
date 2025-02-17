table 33019995 "CT Return Ship. Line"
{
    Caption = 'Courier Return Ship. Line';

    fields
    {
        field(2; "Document No."; Code[20])
        {
            TableRelation = "CT Return Ship. Header".No.;
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
        }
        field(13; Quantity; Decimal)
        {
        }
        field(16; "Quantity Returned"; Decimal)
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

