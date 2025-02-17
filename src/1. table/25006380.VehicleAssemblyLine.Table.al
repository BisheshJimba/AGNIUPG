table 25006380 "Vehicle Assembly Line"
{
    // 13.05.2016 EB.P7 #EQI_25
    //   Confirm added to insert linked options
    // 
    // 11.04.2013 EDMS P8
    //   * Renamed field 'Manuf. Option Type' to 'Option Subtype'

    Caption = 'Vehicle Assembly Line';
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
                IF ("Option Type" = "Option Type"::"Own Option") AND ("Option Subtype" <> "Option Subtype"::Option) THEN
                    ERROR(Text005, FORMAT("Option Type"::"Own Option"), FORMAT("Option Subtype"::Option));

                IF "Option Type" <> xRec."Option Type" THEN BEGIN
                    TESTFIELD("Option Code", '');
                END;

                IF "Option Type" = "Option Type"::"Vehicle Base" THEN
                    IF ModelVersion.GET("Model Version No.") THEN BEGIN
                        Description := ModelVersion.Description + ModelVersion."Description 2";
                        "Description 2" := '';
                    END;

                UpdateSalesPrice(FIELDNO("Option Type"));
                UpdatePurchasePrice(FIELDNO("Option Type"));
            end;
        }
        field(60; "Option Code"; Code[50])
        {
            Caption = 'Option Code';

            trigger OnLookup()
            var
                OwnOptions: Page "25006499";
                ManOptions: Page "25006450";
            begin
                CASE "Option Type" OF
                    "Option Type"::"Vehicle Base":
                        ;
                    "Option Type"::"Manufacturer Option":
                        BEGIN
                            ManOption.RESET;
                            ManOption.SETRANGE("Make Code", "Make Code");
                            ManOption.SETRANGE("Model Code", "Model Code");
                            ManOption.SETRANGE("Model Version No.", "Model Version No.");
                            ManOption.SETRANGE(Type, "Option Subtype");
                            CLEAR(ManOptions);
                            ManOptions.SETTABLEVIEW(ManOption);
                            IF "Option Code" <> '' THEN BEGIN
                                ManOption.SETRANGE("Option Code", "Option Code");
                                IF ManOption.FINDSET THEN;
                                ManOption.SETRANGE("Option Code");
                                ManOptions.SETRECORD(ManOption);
                            END;
                            ManOptions.LOOKUPMODE(TRUE);
                            IF ManOptions.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                ManOptions.GETRECORD(ManOption);
                                VALIDATE("Option Code", ManOption."Option Code");
                            END;
                        END;
                    "Option Type"::"Own Option":
                        BEGIN
                            OwnOption.RESET;
                            OwnOption.SETRANGE("Make Code", "Make Code");
                            OwnOption.SETRANGE("Model Code", "Model Code");
                            CLEAR(OwnOptions);
                            OwnOptions.SETTABLEVIEW(OwnOption);
                            OwnOptions.LOOKUPMODE(TRUE);
                            IF OwnOptions.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                OwnOptions.GETRECORD(OwnOption);
                                VALIDATE("Option Code", OwnOption."Option Code");
                            END;
                        END;
                END;
            end;

            trigger OnValidate()
            var
                ManufacturerOptionCondition: Record "25006374";
                VehicleAssemblyLine: Record "25006380";
                ComesWith: Text[250];
                CRLF: Text[2];
                ManufacturerOptionConditionTmp: Record "25006374" temporary;
                LineNo: Integer;
            begin
                CRLF := ' ';
                CRLF[1] := 13;
                CRLF[2] := 10;

                TempVehicleAssembly := Rec;
                INIT;

                "Make Code" := TempVehicleAssembly."Make Code";
                "Model Code" := TempVehicleAssembly."Model Code";
                "Model Version No." := TempVehicleAssembly."Model Version No.";
                "Option Type" := TempVehicleAssembly."Option Type";
                "Option Subtype" := TempVehicleAssembly."Option Subtype";
                "Option Code" := TempVehicleAssembly."Option Code";

                CASE "Option Type" OF
                    "Option Type"::"Manufacturer Option":
                        BEGIN
                            ManOption.RESET;
                            IF ManOption.GET("Make Code", "Model Code", "Model Version No.", "Option Subtype", "Option Code") THEN BEGIN
                                VALIDATE(Description, ManOption.Description);
                                VALIDATE("Description 2", ManOption."Description 2");
                                VALIDATE("Option Subtype", ManOption.Type);
                                VALIDATE(Standard, ManOption.Standard);
                            END;
                        END;
                    "Option Type"::"Own Option":
                        BEGIN
                            OwnOption.RESET;
                            IF OwnOption.GET("Make Code", "Model Code", "Option Code") THEN BEGIN
                                VALIDATE(Description, OwnOption.Description);
                                VALIDATE("Description 2", OwnOption."Description 2");
                            END;
                        END;
                END;

                VALIDATE(Posted, IsPosted(Rec));

                UpdateSalesPrice(FIELDNO("Option Code"));
                UpdatePurchasePrice(FIELDNO("Option Code"));

                IF "Option Type" = "Option Type"::"Manufacturer Option" THEN BEGIN
                    ComesWith := '';
                    VehicleAssemblyLine.RESET;
                    VehicleAssemblyLine.SETRANGE("Serial No.", "Serial No.");
                    VehicleAssemblyLine.SETRANGE("Assembly ID", "Assembly ID");
                    VehicleAssemblyLine.SETRANGE("Option Type", VehicleAssemblyLine."Option Type"::"Manufacturer Option");
                    VehicleAssemblyLine.SETRANGE("Option Subtype", "Option Subtype");

                    ManufacturerOptionCondition.RESET;
                    ManufacturerOptionCondition.SETRANGE("Make Code", "Make Code");
                    ManufacturerOptionCondition.SETRANGE("Model Code", "Model Code");
                    ManufacturerOptionCondition.SETRANGE("Model Version No.", "Model Version No.");
                    ManufacturerOptionCondition.SETRANGE("Option Type", "Option Subtype");
                    ManufacturerOptionCondition.SETRANGE("Option Code", "Option Code");
                    IF ManufacturerOptionCondition.FINDFIRST THEN
                        REPEAT
                            VehicleAssemblyLine.SETRANGE("Option Code", ManufacturerOptionCondition."Condition Option Code");
                            CASE ManufacturerOptionCondition."Condition Type" OF
                                ManufacturerOptionCondition."Condition Type"::"Only with":
                                    BEGIN
                                        IF NOT VehicleAssemblyLine.FINDFIRST THEN BEGIN
                                            IF ComesWith <> '' THEN
                                                ComesWith := ComesWith + CRLF;
                                            ManufacturerOptionCondition.CALCFIELDS("Condition Option Description");
                                            ComesWith := ComesWith + ManufacturerOptionCondition."Condition Option Code" + ' - ' + ManufacturerOptionCondition."Condition Option Description";
                                            ManufacturerOptionConditionTmp.INIT;
                                            ManufacturerOptionConditionTmp := ManufacturerOptionCondition;
                                            ManufacturerOptionConditionTmp.INSERT;
                                        END;
                                    END;
                                ManufacturerOptionCondition."Condition Type"::"Not with":
                                    BEGIN
                                        IF VehicleAssemblyLine.FINDFIRST THEN
                                            MESSAGE(STRSUBSTNO(Text002, "Option Code", ManufacturerOptionCondition."Condition Option Code"));
                                    END;
                            END;
                        UNTIL ManufacturerOptionCondition.NEXT = 0;
                    IF ComesWith <> '' THEN
                        IF DIALOG.CONFIRM(Text006, FALSE, "Option Code", CRLF + ComesWith) THEN BEGIN
                            ManufacturerOptionConditionTmp.RESET;
                            IF ManufacturerOptionConditionTmp.FINDFIRST THEN BEGIN
                                VehicleAssemblyLine.RESET;
                                VehicleAssemblyLine.SETRANGE("Serial No.", "Serial No.");
                                VehicleAssemblyLine.SETRANGE("Assembly ID", "Assembly ID");
                                VehicleAssemblyLine.FINDLAST;
                                LineNo := VehicleAssemblyLine."Line No.";
                                REPEAT
                                    LineNo += 10000;
                                    VehicleAssemblyLine.INIT;
                                    VehicleAssemblyLine."Line No." := LineNo;
                                    VehicleAssemblyLine.VALIDATE("Serial No.", "Serial No.");
                                    VehicleAssemblyLine.VALIDATE("Assembly ID", "Assembly ID");
                                    VehicleAssemblyLine.VALIDATE("Option Type", "Option Type");
                                    VehicleAssemblyLine.VALIDATE("Option Code", ManufacturerOptionConditionTmp."Condition Option Code");
                                    VehicleAssemblyLine."Make Code" := "Make Code";
                                    VehicleAssemblyLine."Model Code" := "Model Code";
                                    VehicleAssemblyLine."Model Version No." := "Model Version No.";
                                    ManufacturerOptionConditionTmp.CALCFIELDS("Condition Option Description");
                                    VehicleAssemblyLine."External Code" := ManufacturerOptionConditionTmp."Option External Code";


                                    ManOption.RESET;
                                    IF ManOption.GET("Make Code", "Model Code", "Model Version No.",
                                      ManufacturerOptionConditionTmp."Condition Option Type", ManufacturerOptionConditionTmp."Condition Option Code") THEN BEGIN
                                        VehicleAssemblyLine.VALIDATE(Description, ManOption.Description);
                                        VehicleAssemblyLine.VALIDATE("Description 2", ManOption."Description 2");
                                        VehicleAssemblyLine.VALIDATE("Option Subtype", ManOption.Type);
                                        VehicleAssemblyLine.VALIDATE(Standard, ManOption.Standard);
                                    END;

                                    VehicleAssemblyLine.UpdateSalesPrice(FIELDNO("Option Code"));
                                    VehicleAssemblyLine.UpdatePurchasePrice(FIELDNO("Option Code"));

                                    VehicleAssemblyLine.INSERT;
                                UNTIL ManufacturerOptionConditionTmp.NEXT = 0;

                            END;
                        END;
                END;
            end;
        }
        field(70; "External Code"; Code[20])
        {
            CalcFormula = Lookup("Manufacturer Option"."External Code" WHERE(Make Code=FIELD(Make Code),
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
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;

            trigger OnValidate()
            begin
                IF ("Option Type" = "Option Type"::"Own Option") AND ("Option Subtype" <> "Option Subtype"::Option) THEN
                  ERROR(Text005,FORMAT("Option Type"::"Own Option"),FORMAT("Option Subtype"::Option));
            end;
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

                VehPriceCalcMgt.UpdateSalesLineAmounts(Rec);
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
        field(250;"Direct Purchase Cost";Decimal)
        {

            trigger OnValidate()
            begin
                VALIDATE("Purchase Discount %");
            end;
        }
        field(260;"Purchase Discount %";Decimal)
        {

            trigger OnValidate()
            begin
                GetAssemblyHeader;
                "Purchase Discount Amount" :=
                  ROUND("Direct Purchase Cost" *
                          "Purchase Discount %" / 100,Currency."Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(270;"Purchase Discount Amount";Decimal)
        {
        }
        field(280;"Purchase Cost Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Serial No.","Assembly ID","Line No.")
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

    trigger OnDelete()
    begin
        VehPriceCalcMgt.UpdateSalesLineAmounts(Rec);
    end;

    trigger OnInsert()
    var
        VehAssembly: Record "25006380";
    begin
        TESTFIELD("Model Code");
        TESTFIELD("Make Code");
        TESTFIELD("Model Version No.");
        TESTFIELD("Serial No.");

        VehAssembly := Rec;

        IF "Option Type" = "Option Type"::"Vehicle Base" THEN BEGIN
          VehAssembly.SETRANGE("Option Type","Option Type"::"Vehicle Base" );
          VehAssembly.SETRANGE("Assembly ID","Assembly ID");
          VehAssembly.SETRANGE("Serial No.","Serial No.");
          IF VehAssembly.COUNT > 0 THEN ERROR(Text001,FORMAT("Option Type"))
        END;

        IF "Option Subtype" = "Option Subtype"::Color THEN BEGIN
          VehAssembly.SETRANGE("Option Subtype","Option Subtype"::Color);
          VehAssembly.SETRANGE("Assembly ID","Assembly ID");
          VehAssembly.SETRANGE("Serial No.","Serial No.");
          IF VehAssembly.COUNT > 0 THEN ERROR(Text004,FORMAT("Option Subtype"))
        END;

        IF "Option Subtype" = "Option Subtype"::Upholstery THEN BEGIN
          VehAssembly.SETRANGE("Option Subtype","Option Subtype"::Upholstery);
          VehAssembly.SETRANGE("Assembly ID","Assembly ID");
          VehAssembly.SETRANGE("Serial No.","Serial No.");
          IF VehAssembly.COUNT > 0 THEN ERROR(Text004,FORMAT("Option Subtype"))
        END;

        VehAssembly := Rec;
        VehPriceCalcMgt.UpdateSalesLineAmounts(VehAssembly);
        VehPriceCalcMgt.UpdatePurchLineAmounts(VehAssembly);
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
        ManOption: Record "25006370";
        OwnOption: Record "25006372";
        TempVehicleAssembly: Record "25006380";
        VehAssemblyHeader: Record "25006381";
        Currency: Record "4";
        VehPriceCalcMgt: Codeunit "25006301";
        Text001: Label 'It''s restricted to insert two lines of type %1';
        Text002: Label 'Option %1 is not compatible with option %2';
        Text003: Label 'Option %1 has to be used with option(s): \%2';
        Text004: Label 'It''s restricted to insert two lines of subtype %1';
        Text005: Label 'Option Type %1 has to be used with Option Subtype: \%2';
        Text006: Label 'Option "%1" can be used only with following option(s). Would you like to insert them now? \%2';

    [Scope('Internal')]
    procedure UpdateAmounts()
    var
        SalesAmount: Decimal;
    begin
        IF Amount <> "Sales Price" - "Line Discount Amount" THEN
          Amount := "Sales Price" - "Line Discount Amount";

        IF "Purchase Cost Amount" <> "Direct Purchase Cost" - "Purchase Discount Amount" THEN
          "Purchase Cost Amount" := "Direct Purchase Cost" - "Purchase Discount Amount";
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
        VehOptLedg.SETRANGE("Option Code",VehAssembly."Option Code");
        EXIT(NOT VehOptLedg.ISEMPTY);
    end;

    [Scope('Internal')]
    procedure UpdateSalesPrice(CalledByFieldNo: Integer)
    begin
        IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
          EXIT;

        VALIDATE("Sales Price",0);

        GetAssemblyHeader;

        VehPriceCalcMgt.FindAssemblyLineDisc(VehAssemblyHeader,Rec);
        VehPriceCalcMgt.FindAssemblyLinePrice(VehAssemblyHeader,Rec);

        VALIDATE("Sales Price");
    end;

    [Scope('Internal')]
    procedure UpdatePurchasePrice(CalledByFieldNo: Integer)
    begin
        IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
          EXIT;

        VALIDATE("Direct Purchase Cost",0);

        GetAssemblyHeader;

        VehPriceCalcMgt.FindAssemblyLinePurchaseDisc(VehAssemblyHeader,Rec);
        VehPriceCalcMgt.FindAssemblyLinePurchasePrice(VehAssemblyHeader,Rec);

        VALIDATE("Direct Purchase Cost");
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
    procedure SetAssemblyHeader(NewVehAssemblyHeader: Record "25006381")
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

