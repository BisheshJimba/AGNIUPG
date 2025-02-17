table 50011 "Sales Price Buffer"
{

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Editable = false;
            TableRelation = Item."No.";
        }
        field(2; "Sales Price"; Decimal)
        {
            Editable = false;
        }
        field(3; Invalid; Boolean)
        {
            Editable = false;
        }
        field(4; Processed; Boolean)
        {
            Editable = false;
        }
        field(6; "Sales Code"; Option)
        {
            Editable = false;
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;
        }
        field(7; Process; Boolean)
        {
            Editable = true;
        }
        field(50000; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50001; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(50002; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(50003; "Costing Method"; Option)
        {
            Caption = 'Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(50004; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(50005; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(50010; "Price/Profit Calculation"; Option)
        {
            Caption = 'Price/Profit Calculation';
            Editable = true;
            OptionCaption = 'Profit=Price-Cost,Price=Cost+Profit,No Relationship';
            OptionMembers = "Profit=Price-Cost","Price=Cost+Profit","No Relationship";
        }
        field(50011; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(50012; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(50013; "Make Code"; Code[10])
        {
        }
        field(50014; "Search Description"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

