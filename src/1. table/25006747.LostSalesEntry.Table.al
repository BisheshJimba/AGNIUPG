table 25006747 "Lost Sales Entry"
{
    Caption = 'Lost Sales Entry';
    LookupPageID = 25006858;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; Date; Date)
        {
            Caption = 'Date';
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(40; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(50; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE(Item Category Code=FIELD(Item Category Code));
        }
        field(60; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE(Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(70;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("Customer No.") THEN
                    "Customer Name" := Customer.Name;
            end;
        }
        field(80;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(90;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(100;"Reason Code";Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Lost Sales Reason";
        }
        field(110;"Reason Description";Text[150])
        {
            CalcFormula = Lookup("Lost Sales Reason".Description WHERE (Code=FIELD(Reason Code)));
            Caption = 'Reason Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;"Reason Description 2";Text[150])
        {
            CalcFormula = Lookup("Lost Sales Reason"."Description 2" WHERE (Code=FIELD(Reason Code)));
            Caption = 'Reason Description 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130;Priority;Option)
        {
            Caption = 'Priority';
            OptionCaption = ',Highest,High,Medium,Low,Lowest';
            OptionMembers = ,Highest,High,Medium,Low,Lowest;
        }
        field(150;Automatic;Boolean)
        {
            Caption = 'Automatic';
            Description = 'For example, on line deletion';
        }
        field(151;"Closing Remarks";Text[150])
        {
        }
        field(152;Close;Boolean)
        {
        }
        field(153;"Assigned User Id";Code[50])
        {
        }
        field(154;"Location Code";Code[50])
        {
        }
        field(155;"Customer Name";Text[70])
        {
        }
        field(156;Advance;Boolean)
        {
        }
        field(157;Quantity;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Customer: Record "18";
        Item: Record "27";
}

