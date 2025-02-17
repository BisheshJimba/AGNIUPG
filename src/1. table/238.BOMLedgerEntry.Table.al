table 238 "BOM Ledger Entry"
{
    Caption = 'BOM Ledger Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Reference Type"; Option)
        {
            Caption = 'Reference Type';
            OptionCaption = 'Item,Resource';
            OptionMembers = Item,Resource;
        }
        field(3; "Reference Entry No."; Integer)
        {
            Caption = 'Reference Entry No.';
            TableRelation = if ("Reference Type" = const(Item)) "Item Ledger Entry"
            else if ("Reference Type" = const(Resource)) "Res. Ledger Entry";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Component,BOM';
            OptionMembers = Component,BOM;
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Reference Type", "Reference Entry No.", "Entry Type", "Posting Date")
        {
        }
    }
}

