tableextension 50412 tableextension50412 extends "Sales Price Worksheet"
{
    // 21.08.2015 EB.P30 #T0053
    //   Modified function CalcNewPrice
    // 
    // 19.08.2015 EB.P30 #T049
    //   Modified Trigger OnValidate for fields:
    //     "New Unit Price"
    //     "Unit Profit % (New)"
    // 
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Changed LVI caption for field "Current Unit Price"
    //   * Added functions
    //     CalcProfit, CalcSalesPrice, CalcProfitPercent
    // 
    // 14.04.2014 Elva Baltic P7 #x MMG7.00
    //   * New fields added
    // 
    // 17.02.2009 EDMS P1
    //   *Extension to Nonstock Items
    //   *New field - Type
    //   *Field Item No. renamed to No. and made dependant on type
    //   *Extended primary key
    //   *Modified function CalcCurrentPrice
    fields
    {
        modify("Item No.")
        {

            //Unsupported feature: Property Modification (Name) on ""Item No."(Field 1)".

            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Nonstock Item)) "Nonstock Item";
            Caption = 'No.';
        }
        modify("Sales Code")
        {
            TableRelation = IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign;
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Item Description"(Field 20)".

        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Nonstock Item)) "Unit of Measure";
        }
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5700)".

            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }


        //Unsupported feature: Code Modification on ""Item No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Item No." <> xRec."Item No." THEN BEGIN
              "Unit of Measure Code" := '';
              "Variant Code" := '';
            END;

            IF "Sales Type" = "Sales Type"::"Customer Price Group" THEN
              IF CustPriceGr.GET("Sales Code") AND
                 (CustPriceGr."Allow Invoice Disc." <> "Allow Invoice Disc.")
              THEN
                IF Item.GET("Item No.") THEN
                  "Allow Invoice Disc." := Item."Allow Invoice Disc.";

            CalcCurrentPrice(PriceAlreadyExists);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF "No." <> xRec."No." THEN BEGIN
            #2..9
                IF Item.GET("No.") THEN
            #11..13
            */
        //end;


        //Unsupported feature: Code Insertion on ""New Unit Price"(Field 6)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            // 19.08.2015 EB.P30 #T049 >>
            CalcProfit;
            // 19.08.2015 EB.P30 #T049 <<
            */
        //end;
        field(25006000;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,Nonstock Item';
            OptionMembers = Item,"Nonstock Item";
        }
        field(25006010;"Unit Cost";Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(25006020;"Unit Profit (Current)";Decimal)
        {
            Caption = 'Unit Profit (Current)';
        }
        field(25006030;"Unit Profit % (Current)";Decimal)
        {
            Caption = 'Unit Profit % (Current)';
        }
        field(25006040;"Unit Profit (New)";Decimal)
        {
            Caption = 'Unit Profit (New)';

            trigger OnValidate()
            begin
                //21.04.2014 Elva Baltic P1 #RX MMG7.00
                CalcSalesPrice;
                CalcProfit
                //21.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(25006050;"Unit Profit % (New)";Decimal)
        {
            Caption = 'Unit Profit % (New)';

            trigger OnValidate()
            begin
                //21.04.2014 Elva Baltic P1 #RX MMG7.00
                VALIDATE("New Unit Price",ROUND("Unit Cost" / (1 - "Unit Profit % (New)"/100),0.1));
                CalcProfit; // 19.08.2015 EB.P30 #T049
                //21.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006770;"Location Code";Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Starting Date,Ending Date,Sales Type,Sales Code,Currency Code,Item No.,Variant Code,Unit of Measure Code,Minimum Quantity"(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""Item No.,Variant Code,Unit of Measure Code,Minimum Quantity,Starting Date,Ending Date,Sales Type,Sales Code,Currency Code"(Key)".

        key(Key1;"Starting Date","Ending Date","Sales Type","Sales Code","Currency Code",Type,"No.","Variant Code","Unit of Measure Code","Minimum Quantity","Ordering Price Type Code","Location Code")
        {
            Clustered = true;
        }
        key(Key2;Type,"No.","Variant Code","Unit of Measure Code","Minimum Quantity","Starting Date","Ending Date","Sales Type","Sales Code","Currency Code")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "Sales Type" = "Sales Type"::"All Customers" THEN
          "Sales Code" := ''
        ELSE
          TESTFIELD("Sales Code");
        TESTFIELD("Item No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
        TESTFIELD("No.");
        */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
          TESTFIELD("Sales Code");
        TESTFIELD("Item No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
          TESTFIELD("Sales Code");
        TESTFIELD("No.");
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: NonstockSalesPrice) (VariableCollection) on "CalcCurrentPrice(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "CalcCurrentPrice(PROCEDURE 1)".

    //procedure CalcCurrentPrice();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesPrice.SETRANGE("Item No.","Item No.");
        SalesPrice.SETRANGE("Sales Type","Sales Type");
        SalesPrice.SETRANGE("Sales Code","Sales Code");
        SalesPrice.SETRANGE("Currency Code","Currency Code");
        SalesPrice.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        SalesPrice.SETRANGE("Starting Date",0D,"Starting Date");
        SalesPrice.SETRANGE("Minimum Quantity",0,"Minimum Quantity");
        SalesPrice.SETRANGE("Variant Code","Variant Code");
        IF SalesPrice.FINDLAST THEN BEGIN
          "Current Unit Price" := SalesPrice."Unit Price";
          "Price Includes VAT" := SalesPrice."Price Includes VAT";
        #12..16
          "Current Unit Price" := 0;
          PriceAlreadyExists := FALSE;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //17.02.2009 EDMS P1 >>
        CASE Type OF
         Type::Item: BEGIN
        //17.02.2009 EDMS P1 <<
           SalesPrice.SETRANGE("Item No.","No.");
        #2..8

           //17.02.2009 EDMS P1 >>
           SalesPrice.SETRANGE("Ordering Price Type Code","Ordering Price Type Code");
           SalesPrice.SETRANGE("Location Code","Location Code");
           //17.02.2009 EDMS P1 <<

        #9..19
        //17.02.2009 EDMS P1 >>
         END;
         Type::"Nonstock Item": BEGIN
           NonstockSalesPrice.SETRANGE("Nonstock Item Entry No.","No.");
           NonstockSalesPrice.SETRANGE("Sales Type","Sales Type");
           NonstockSalesPrice.SETRANGE("Sales Code","Sales Code");
           NonstockSalesPrice.SETRANGE("Currency Code","Currency Code");
           NonstockSalesPrice.SETRANGE("Unit of Measure Code","Unit of Measure Code");
           NonstockSalesPrice.SETRANGE("Starting Date",0D,"Starting Date");
           NonstockSalesPrice.SETRANGE("Minimum Quantity",0,"Minimum Quantity");
           NonstockSalesPrice.SETRANGE("Ordering Price Type Code","Ordering Price Type Code");
           NonstockSalesPrice.SETRANGE("Location Code","Location Code");
           IF NonstockSalesPrice.FIND('+') THEN BEGIN
             "Current Unit Price" := NonstockSalesPrice."Unit Price";
             "Price Includes VAT" := NonstockSalesPrice."Price Includes VAT";
             "Allow Line Disc." := NonstockSalesPrice."Allow Line Disc.";
             "Allow Invoice Disc." := NonstockSalesPrice."Allow Invoice Disc.";
             "VAT Bus. Posting Gr. (Price)" := NonstockSalesPrice."VAT Bus. Posting Gr. (Price)";
             PriceAlreadyExists := NonstockSalesPrice."Starting Date" = "Starting Date";
           END ELSE BEGIN
             "Current Unit Price" := 0;
             PriceAlreadyExists := FALSE;
           END;
         END;
        END;
        //17.02.2009 EDMS P1 <<
        */
    //end;

    procedure CalcNewPrice()
    var
        SalesPriceFactor: Record "25006754";
        ItemPriceGroup: Code[10];
        Factor: Decimal;
    begin
        IF "Unit Cost" = 0 THEN
          EXIT;

        CASE Type OF
          Type::Item:
            IF Item.GET("No.") THEN BEGIN
              ItemPriceGroup := Item."Item Price Group Code";
            END;
          Type::"Nonstock Item":
            IF NonstockItem.GET("No.") THEN BEGIN
              ItemPriceGroup := NonstockItem."Item Price Group Code";
            END;
        END;

        Factor := 0;
        SalesPriceFactor.RESET;
        SalesPriceFactor.SETFILTER(Code, '%1|%2', '', ItemPriceGroup);
        SalesPriceFactor.SETRANGE("Sales Type", "Sales Type");
        SalesPriceFactor.SETFILTER("Sales Code", '%1|%2', '', "Sales Code");
        IF SalesPriceFactor.FINDFIRST THEN
          REPEAT
            IF SalesPriceFactor."Sales Price Factor" > Factor THEN
              Factor := SalesPriceFactor."Sales Price Factor";
          UNTIL SalesPriceFactor.NEXT = 0;

        IF Factor <> 0 THEN
          VALIDATE("New Unit Price","Unit Cost" * Factor);                                      // 21.08.2015 EB.P30 #T0053
    end;

    procedure CalcProfit()
    begin
        "Unit Profit (New)" := "New Unit Price" - "Unit Cost";
        CalcProfitPercent;
    end;

    procedure CalcSalesPrice()
    begin
        "New Unit Price" := "Unit Cost" + "Unit Profit (New)";
    end;

    procedure CalcProfitPercent()
    begin
        IF "New Unit Price" <> 0 THEN
          "Unit Profit % (New)" := ROUND("Unit Profit (New)" / "New Unit Price" * 100,0.1)
        ELSE
          "Unit Profit % (New)" := 0;
    end;

    var
        NonstockItem: Record "5718";
}

