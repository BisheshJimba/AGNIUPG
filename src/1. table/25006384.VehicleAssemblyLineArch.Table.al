table 25006384 "Vehicle Assembly Line Arch."
{
    // 11.04.2013 EDMS P8
    //   * Renamed field 'Manuf. Option Type' to 'Option Subtype'
    //   * Removed code from field 'Option Code'

    Caption = 'Vehicle Assembly Line Arch.';
    LookupPageID = 25006490;

    fields
    {
        field(5; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            Editable = false;
        }
        field(10; "Assembly ID"; Code[20])
        {
            Caption = 'Assembly ID';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option,Vehicle Base';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base";

            trigger OnValidate()
            var
                ModelVersion: Record "27";
            begin
                IF "Option Type" <> xRec."Option Type" THEN BEGIN
                    TESTFIELD("Option Code", '');
                END;

                IF "Option Type" = "Option Type"::"Vehicle Base" THEN
                    IF ModelVersion.GET("Model Version No.") THEN BEGIN
                        Description := ModelVersion.Description + ModelVersion."Description 2";
                        "Description 2" := '';
                    END;
            end;
        }
        field(60; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            TableRelation = IF (Option Type=CONST(Manufacturer Option)) "Manufacturer Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                                                                   Model Code=FIELD(Model Code),
                                                                                                                   Model Version No.=FIELD(Model Version No.))
                                                                                                                   ELSE IF (Option Type=CONST(Vehicle Base)) Item.No. WHERE (Item Type=CONST(Model Version))
                                                                                                                   ELSE IF (Option Type=CONST(Own Option)) "Own Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                                                                                                                                             Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                OwnOptions: Page "25006499";
                                ManOptions: Page "25006450";
            begin
            end;

            trigger OnValidate()
            var
                ManufacturerOptionCondition: Record "25006374";
                VehicleAssemblyLine: Record "25006380";
                ComesWith: Text[250];
            begin
            end;
        }
        field(70;"External Code";Code[20])
        {
            CalcFormula = Lookup("Manufacturer Option"."External Code" WHERE (Make Code=FIELD(Make Code),
                                                                              Model Code=FIELD(Model Code),
                                                                              Model Version No.=FIELD(Model Version No.),
                                                                              Option Code=FIELD(Option Code)));
            Caption = 'External Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(90;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(95;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;

            trigger OnLookup()
            var
                Item: Record "27";
            begin
                Item.SETCURRENTKEY("Item Type","Make Code","Model Code");
                Item.SETRANGE("Item Type",Item."Item Type"::"Model Version");
                Item.SETRANGE("Make Code","Make Code");
                Item.SETRANGE("Model Code","Model Code");
                IF PAGE.RUNMODAL(PAGE::"Item List",Item) = ACTION::LookupOK THEN //30.10.2012 EDMS
                  "Model Code" := Item."No.";
            end;
        }
        field(97;"Cost Amount";Decimal)
        {
            Caption = 'Cost Amount (LCY)';
        }
        field(100;"Sales Price";Decimal)
        {
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Sales Price"));
            Caption = 'Unit Price';
            Description = 'Unit price';

            trigger OnValidate()
            begin
                VALIDATE("Line Discount %");
            end;
        }
        field(110;Standard;Boolean)
        {
            Caption = 'Standard';
            Editable = false;
        }
        field(120;"Option Subtype";Option)
        {
            Caption = 'Option Subtype';
            Editable = false;
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(140;Description;Text[250])
        {
            Caption = 'Description';
        }
        field(150;"Description 2";Text[250])
        {
            Caption = 'Description 2';
        }
        field(160;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                GetAssemblyHeader;
                "Line Discount Amount" :=
                  ROUND("Sales Price" *
                          "Line Discount %" / 100,Currency."Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(170;"Line Discount Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                IF "Sales Price" <> 0 THEN
                  "Line Discount %" :=
                    ROUND(
                     "Line Discount Amount" / "Sales Price" * 100,
                      0.00001)
                ELSE
                  "Line Discount %" := 0;
                UpdateAmounts;
            end;
        }
        field(180;Amount;Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO(Amount));
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TESTFIELD("Sales Price");
                GetAssemblyHeader;
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                VALIDATE(
                  "Line Discount Amount",ROUND("Sales Price",Currency."Amount Rounding Precision") - Amount);
            end;
        }
        field(190;Posted;Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(200;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(230;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(240;"PDI Created";Boolean)
        {
            Caption = 'PDI Created';
        }
        field(250;"Version No.";Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1;"Serial No.","Assembly ID","Version No.","Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2;"Option Type","Option Subtype","Option Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        VehAssembly: Record "25006384";
    begin
        TESTFIELD("Model Code");
        TESTFIELD("Make Code");
        TESTFIELD("Model Version No.");
        TESTFIELD("Serial No.");
    end;

    trigger OnModify()
    var
        Released: Boolean;
        PurchHeader: Record "38";
        PurchLine: Record "39";
        SalesHeader: Record "36";
        SalesLine: Record "37";
    begin
        PurchLine.RESET;
        PurchLine.SETCURRENTKEY("Vehicle Serial No.","Vehicle Assembly ID");
        PurchLine.SETRANGE("Vehicle Serial No.","Serial No.");
        PurchLine.SETRANGE("Vehicle Assembly ID","Assembly ID");
        IF PurchLine.FINDSET THEN
         REPEAT
          PurchHeader.RESET;
          PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
          PurchHeader.TESTFIELD(Status,PurchHeader.Status::Open);
         UNTIL PurchLine.NEXT = 0;

        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("Vehicle Serial No.","Vehicle Assembly ID");
        SalesLine.SETRANGE("Vehicle Serial No.","Serial No.");
        SalesLine.SETRANGE("Vehicle Assembly ID","Assembly ID");
        IF SalesLine.FINDSET THEN
         REPEAT
          SalesHeader.RESET;
          SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
         UNTIL SalesLine.NEXT = 0;
    end;

    var
        TempVehicleAssembly: Record "25006384";
        VehAssemblyHeader: Record "25006383";
        Currency: Record "4";
        Text002: Label 'Option %1 is not compatible with option %2';
        Text003: Label 'Option %1 has to be used with option(s): \%2';

    [Scope('Internal')]
    procedure UpdateAmounts()
    var
        SalesAmount: Decimal;
    begin
        IF Amount <> "Sales Price" - "Line Discount Amount" THEN
          Amount := "Sales Price" - "Line Discount Amount";
    end;

    [Scope('Internal')]
    procedure IsPosted(VehAssembly: Record "25006380"): Boolean
    var
        VehOptLedg: Record "25006388";
    begin
        VehAssembly.TESTFIELD("Serial No.");
        VehAssembly.TESTFIELD("Assembly ID");

        VehOptLedg.RESET;
        VehOptLedg.SETCURRENTKEY("Vehicle Serial No.");
        VehOptLedg.SETRANGE("Vehicle Serial No.",VehAssembly."Serial No.");
        VehOptLedg.SETRANGE("Entry Type",VehOptLedg."Entry Type"::"Put On");
        VehOptLedg.SETRANGE(Open,TRUE);
        VehOptLedg.SETRANGE(Correction,FALSE);
        VehOptLedg.SETRANGE("Option Type",VehAssembly."Option Type");
        VehOptLedg.SETRANGE("Option Subtype",VehAssembly."Option Subtype");
        VehOptLedg.SETRANGE("Option Code",VehAssembly."Option Code");
        EXIT(NOT VehOptLedg.ISEMPTY);
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Vehicle Assembly Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesPricesIncVar: Integer;
    begin
        IF NOT VehAssemblyHeader.GET("Assembly ID") THEN BEGIN
          VehAssemblyHeader."Assembly ID" := '';
          VehAssemblyHeader.INIT;
        END;
        IF VehAssemblyHeader."Prices Including VAT" THEN
          SalesPricesIncVar := 1
        ELSE
          SalesPricesIncVar := 0;
        CLEAR(VehAssemblyHeader);

        EXIT('2,'+FORMAT(SalesPricesIncVar)+',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetAssemblyHeader()
    begin
        TESTFIELD("Assembly ID");
        IF "Assembly ID" <> VehAssemblyHeader."Assembly ID" THEN BEGIN
          IF NOT VehAssemblyHeader.GET("Assembly ID") THEN BEGIN
            VehAssemblyHeader.INIT;
            VehAssemblyHeader."Assembly ID" := "Assembly ID";
            VehAssemblyHeader.INSERT;
          END;

          IF VehAssemblyHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            VehAssemblyHeader.TESTFIELD("Currency Factor");
            Currency.GET(VehAssemblyHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure SetAssemblyHeader(NewVehAssemblyHeader: Record "25006383")
    begin
        VehAssemblyHeader := NewVehAssemblyHeader;

        IF NewVehAssemblyHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          NewVehAssemblyHeader.TESTFIELD("Currency Factor");
          Currency.GET(NewVehAssemblyHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    end;
}

