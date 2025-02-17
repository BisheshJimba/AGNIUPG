tableextension 50346 tableextension50346 extends "Value Entry"
{
    // 17.03.2014 P18 #R098 MMG7.00
    //   Added key "Document No.,Posting Date,Item No.,Item Ledger Entry Type,Location Code"
    //   Added f-n GetCostAmt
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Item)) Item;
        }
        modify("Source Posting Group")
        {
            TableRelation = IF (Source Type=CONST(Customer)) "Customer Posting Group"
                            ELSE IF (Source Type=CONST(Vendor)) "Vendor Posting Group"
                            ELSE IF (Source Type=CONST(Item)) "Inventory Posting Group";
        }

        //Unsupported feature: Property Modification (Editable) on ""Order Type"(Field 90)".


        //Unsupported feature: Property Modification (Editable) on ""Order No."(Field 91)".


        //Unsupported feature: Property Modification (Editable) on ""Order Line No."(Field 92)".


        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".


        //Unsupported feature: Property Modification (Editable) on "Adjustment(Field 5818)".

        modify("No.")
        {
            TableRelation = IF (Type = CONST(Machine Center)) "Machine Center"
                            ELSE IF (Type=CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Resource)) Resource;
        }
        field(50001; "Import Invoice No."; Code[20])
        {
            TableRelation = "Purch. Inv. Header".No.;
        }
        field(50055; "Invertor Serial No."; Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(51000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version,Own Option,Material';
            OptionMembers = " ",Item,"Model Version","Own Option",Material;
        }
        field(25006670; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(25006671; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE(Item Category Code=FIELD(Item Category Code));
        }
        field(25006672; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE(Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(25006680;"Not To Post";Boolean)
        {
            Caption = 'Not To Post';
        }
    }
    keys
    {

        //Unsupported feature: Property Deletion (Enabled) on ""Item No.,Posting Date,Item Ledger Entry Type,Entry Type,Variance Type,Item Charge No.,Location Code,Variant Code,Global Dimension 1 Code,Global Dimension 2 Code,Source Type,Source No."(Key)".

        key(Key1;"Not To Post","Item Ledger Entry No.")
        {
        }
        key(Key2;"Item Ledger Entry Type","Item Category Code","Product Group Code","Location Code","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        {
            SumIndexFields = "Invoiced Quantity","Sales Amount (Actual)","Cost Amount (Actual)","Purchase Amount (Actual)";
        }
        key(Key3;"Location Code","Posting Date")
        {
        }
        key(Key4;"Document No.","Posting Date","Item No.","Item Ledger Entry Type","Location Code")
        {
        }
    }

    procedure GetCostAmt(): Decimal
    begin
        IF "Cost Amount (Actual)" = 0 THEN
          EXIT("Cost Amount (Expected)");
        EXIT("Cost Amount (Actual)");
    end;

    procedure AddBalanceExpectedCostBufEDMS(ValueEntry: Record "5802";NewAdjustedCost: Decimal;NewAdjustedCostACY: Decimal)
    begin
        IF ValueEntry."Expected Cost" OR
          (ValueEntry."Entry Type" <> ValueEntry."Entry Type"::"Direct Cost")
        THEN
          EXIT;

        RESET;
        SETRANGE("Applies-to Entry", ValueEntry."Entry No.");
        FIND;
        "Cost Amount (Expected)" := NewAdjustedCost;
        "Cost Amount (Expected) (ACY)" := NewAdjustedCostACY;
        MODIFY;

        RESET;
    end;
}

