table 25006749 "Nonstock Item Price"
{
    // 16.02.2005 EDMS P1
    //  * Added code:
    //   OnInsert()
    //   OnModify()
    //   OnDelete()
    //   OnRename()
    // 
    // 
    // 13.08.2004 EDMS P1
    //  *Created field "Location Code"
    //  *Changed primary key:
    //     "Item No.,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity"
    //   + "Location Code"

    Caption = 'Nonstock Item Sales Price';
    LookupPageID = 7002;

    fields
    {
        field(1; "Nonstock Item Entry No."; Code[20])
        {
            Caption = 'Nonstock Item Entry No.';
            NotBlank = true;
            TableRelation = "Nonstock Item";

            trigger OnValidate()
            begin
                IF "Nonstock Item Entry No." <> xRec."Nonstock Item Entry No." THEN BEGIN
                    "Unit of Measure Code" := '';
                END;
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                    ERROR(Text000, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));

                IF CurrFieldNo = 0 THEN
                    EXIT;
            end;
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(7; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(8; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign;

            trigger OnValidate()
            var
                CustPriceGr: Record "6";
                Cust: Record "18";
                Campaign: Record "5071";
            begin
                IF "Sales Code" <> '' THEN BEGIN
                  CASE "Sales Type" OF
                    "Sales Type"::"All Customers":
                      ERROR(Text001,FIELDCAPTION("Sales Code"));
                    "Sales Type"::"Customer Price Group":
                      BEGIN
                        CustPriceGr.GET("Sales Code");
                        "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                        "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                        "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                        "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                      END;
                    "Sales Type"::Customer:
                      BEGIN
                        Cust.GET("Sales Code");
                        "Currency Code" := Cust."Currency Code";
                        "Price Includes VAT" := Cust."Prices Including VAT";
                        "Allow Line Disc." := Cust."Allow Line Disc.";
                      END;
                    "Sales Type"::Campaign:
                      BEGIN
                        Campaign.GET("Sales Code");
                        "Starting Date" := Campaign."Starting Date";
                        "Ending Date" := Campaign."Ending Date";
                      END;
                  END;
                END;
            end;
        }
        field(9;"Sales Type";Option)
        {
            Caption = 'Sales Type';
            InitValue = "All Customers";
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                IF "Sales Type" <> xRec."Sales Type" THEN
                  VALIDATE("Sales Code",'');
            end;
        }
        field(10;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(14;"Minimum Quantity";Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(15;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                IF CurrFieldNo = 0 THEN
                  EXIT;

                VALIDATE("Starting Date");
            end;
        }
        field(5400;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
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
        key(Key1;"Sales Type","Sales Code","Nonstock Item Entry No.","Starting Date","Currency Code","Unit of Measure Code","Minimum Quantity","Location Code","Ordering Price Type Code","Document Profile")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //16.02.2005 EDMS P1
         cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec,xRec,3);
    end;

    trigger OnInsert()
    begin
        TESTFIELD("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
         cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec,xRec,0);
    end;

    trigger OnModify()
    begin
        //16.02.2005 EDMS P1
         cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec,xRec,1);
    end;

    trigger OnRename()
    begin
        TESTFIELD("Nonstock Item Entry No.");

        //16.02.2005 EDMS P1
         cuSalesPriceCalcMgt.NonstockSalesPriceToItem(Rec,xRec,2);
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        cuSalesPriceCalcMgt: Codeunit "7000";

    [Scope('Internal')]
    procedure DefaultPriceLCYIncVAT(EntryNo: Code[20]): Decimal
    var
        SalesSetup: Record "311";
        VATPostSetup: Record "325";
    begin
        SETFILTER("Ending Date",'%1|>=%2',0D,WORKDATE);
        SETRANGE("Starting Date",0D,WORKDATE);
        SETRANGE("Nonstock Item Entry No.",EntryNo);
        SETRANGE("Sales Type","Sales Type"::"All Customers");
        SETRANGE("Sales Code",'');
        SETRANGE("Currency Code",'');
        IF FINDLAST THEN
         IF "Price Includes VAT" THEN
          EXIT(ROUND("Unit Price",0.01))
         ELSE BEGIN
          SalesSetup.GET;
          IF (SalesSetup."Def.S.Price VAT Bus.Post.Grp." <> '') AND (SalesSetup."Def.S.Price VAT Prod.Post.Grp." <> '') THEN
            VATPostSetup.GET(SalesSetup."Def.S.Price VAT Bus.Post.Grp.",SalesSetup."Def.S.Price VAT Prod.Post.Grp.");

          EXIT(ROUND("Unit Price" * (1 + VATPostSetup."VAT %"/100),0.01));
         END;
    end;
}

