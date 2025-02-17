tableextension 50408 tableextension50408 extends "Sales Price"
{
    // 25.11.2015 EB.P7 #T017
    //   Trigger code moved to events
    // 
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve. Added key.
    // 
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Make Code added to the primary key
    fields
    {
        modify("Sales Code")
        {
            TableRelation = IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign;
        }
        modify("Sales Type")
        {
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,Markup,Assembly,Contract,Serv. Pack,Labor Price Group';

            //Unsupported feature: Property Modification (OptionString) on ""Sales Type"(Field 13)".

        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5700)".



        //Unsupported feature: Code Insertion on ""Unit Price"(Field 5)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF NOT "Price Includes VAT" THEN
              "Unit Price including VAT" := ROUND(("Unit Price"*"VAT%"/100.0 + "Unit Price"),0.01,'=')
            ELSE
              "Unit Price including VAT" := "Unit Price";
            //MODIFY;

            //***SM 05-08-2013 to calculate the price including VAT for vehicles not tractor
            SalesAndReceivableSetUp.GET;
            "VAT%" := SalesAndReceivableSetUp."Def. Sales VAT %";

            IF "VAT%" <> 0.0 THEN
               "Unit Price including VAT" := ROUND(("Unit Price"*"VAT%"/100.0 + "Unit Price"),0.01,'=')
            ELSE IF "VAT%" = 0.0 THEN
               "Unit Price including VAT" := "Unit Price";
            //***SM 05-08-2013 to calculate the price including VAT for vehicles not tractor
            */
        //end;


        //Unsupported feature: Code Insertion on ""Price Includes VAT"(Field 7)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF "Price Includes VAT" THEN
              TESTFIELD("VAT%",0);
            VALIDATE("Unit Price");
            */
        //end;
        field(50000;"Unit Price including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price including VAT';
            Editable = false;
            MinValue = 0;
        }
        field(50001;"Profit %";Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TESTFIELD("Actual Unit Price (NDP)");
                VALIDATE("Unit Price","Actual Unit Price (NDP)" + "Actual Unit Price (NDP)" * "Profit %"/100.0);
                //MODIFY;
            end;
        }
        field(50002;"Actual Unit Price (NDP)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Actual Unit Price (NDP)';
            MinValue = 0;

            trigger OnValidate()
            var
                item: Record "27";
            begin
                //Sipradi-YS Get Profit % for Local Parts

                SalesRecSetup.GET;
                item.GET("Item No.");
                IF STRPOS("Item No.",'L-') = 1 THEN BEGIN
                  VALIDATE("Profit %",SalesRecSetup."Profit % Local Parts");
                END
                ELSE IF MPGSetup.GET(item."Multiple Price Group (MPG)") THEN
                  VALIDATE("Profit %",MPGSetup."Factor (%)")
                ELSE
                  VALIDATE("Profit %",SalesRecSetup."NDP Factor (%)");

                IF "Profit %" <> 0 THEN
                  VALIDATE("Unit Price","Actual Unit Price (NDP)"/(1-"Profit %"/100.0))
                ELSE IF "Profit %" = 0 THEN
                  VALIDATE("Unit Price","Actual Unit Price (NDP)");

                //MODIFY;
            end;
        }
        field(50003;"Warranty Factor";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            MinValue = 0;
        }
        field(50004;"Dealer Discount %";Decimal)
        {
            MaxValue = 100;

            trigger OnValidate()
            begin
                "Dealer Discount Amount" := ROUND((("Dealer Discount %" * "Unit Price")/100.0),0.01,'=');
            end;
        }
        field(50005;"Dealer Discount Amount";Decimal)
        {

            trigger OnValidate()
            begin
                IF "Dealer Discount Amount" > "Unit Price" THEN
                  ERROR(Text101);
                "Dealer Discount %" := ROUND(("Dealer Discount Amount" * 100.0)/("Unit Price"),0.01,'=');
            end;
        }
        field(50006;"VAT%";Decimal)
        {

            trigger OnValidate()
            begin
                IF "VAT%" <> 0 THEN
                  TESTFIELD("Price Includes VAT",FALSE);
                VALIDATE("Unit Price");
            end;
        }
        field(50007;"Last Modified User";Text[100])
        {
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006002;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Make;
        }
        field(25006007;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006010;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only for Vehicle Trade';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));
        }
        field(25006120;"Source Type";Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(25006140;"Source Ref. No.";Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(25006373;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Only for Vehicle Trade';
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
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,7002,25006800';
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Item No.,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity"(Key)".

        key(Key1;"Item No.","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code","Unit of Measure Code","Minimum Quantity","Ordering Price Type Code","Location Code")
        {
            Clustered = true;
        }
        key(Key2;"Item No.","Make Code","Model Code","Model Version No.","Vehicle Serial No.","Document Profile")
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
        #1..5
        DealerIntegrationMgt.UpdateLastModificationDate("Item No."); //DI.17.05.12
        */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
        /*
        DealerIntegrationMgt.UpdateLastModificationDate("Item No."); //DI.17.05.12
        "Last Modified User" := USERID;
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
        #1..3
        DealerIntegrationMgt.UpdateLastModificationDate("Item No."); //DI.17.05.12
        */
    //end;

    procedure UpdatePriceIncludingVAT()
    var
        SalePrice: Record "7002";
        SalesAndReceiveSetup: Record "311";
    begin
        SalePrice.RESET;
        SalePrice.SETRANGE("Document Profile",SalePrice."Document Profile"::"Spare Parts Trade");
        SalePrice.SETFILTER("VAT%",'%1',0);
        IF SalePrice.FINDSET THEN BEGIN
          REPEAT
          SalesAndReceiveSetup.GET;
          SalesAndReceiveSetup.TESTFIELD("Def. Sales VAT %");
          SalePrice."VAT%" := SalesAndReceiveSetup."Def. Sales VAT %";
          SalePrice."Unit Price including VAT" := ROUND((SalePrice."Unit Price" * (1 + SalePrice."VAT%"/100)),0.01);
          SalePrice.MODIFY;
          UNTIL SalePrice.NEXT = 0;
        END;

        MESSAGE('Finished!');
    end;

    procedure UpdateLastModificationDate(ItemNo: Code[20])
    var
        Item: Record "27";
    begin
        Item.RESET;
        Item.SETRANGE("No.",ItemNo);
        IF Item.FINDFIRST THEN BEGIN
          Item."Last Date Modified" := TODAY;
          Item.MODIFY;
        END;
    end;

    var
        Text100: Label 'Don''t forget to set %1';
        SalesRecSetup: Record "311";
        MPGSetup: Record "33019844";
        Text101: Label 'Discount Amount cannot be greater than Unit Price.';
        SalesAndReceivableSetUp: Record "311";
        DealerIntegrationMgt: Codeunit "33020508";
}

