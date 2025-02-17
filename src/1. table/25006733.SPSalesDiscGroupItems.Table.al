table 25006733 "SP Sales Disc. Group Items"
{
    Caption = 'SP Sales Disc. Group Items';
    LookupPageID = 25006809;

    fields
    {
        field(10; "Sales Disc. Group Code"; Code[10])
        {
            Caption = 'Sales Disc. Group Code';
        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item Category,Labor';
            OptionMembers = "Item Category",Labor;
        }
        field(30; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(Item Category)) "Item Category"
                            ELSE IF (Type=CONST(Labor)) "Service Labor";
        }
        field(40; "Max. Discount %"; Decimal)
        {
            Caption = 'Max. Discount %';
        }
    }

    keys
    {
        key(Key1; "Sales Disc. Group Code", Type, "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

