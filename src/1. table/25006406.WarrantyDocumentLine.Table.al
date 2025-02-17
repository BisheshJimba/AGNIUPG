table 25006406 "Warranty Document Line"
{
    Caption = 'Warranty Document Line';
    DrillDownPageID = 25006407;
    LookupPageID = 25006407;

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Warranty Document Header";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(40; "Service Order Line No."; Integer)
        {
            Caption = 'Service Order Line No.';
        }
        field(50; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";

            trigger OnValidate()
            var
                ServiceHeader: Record "25006145";
                recMarkup: Record "25006741";
                recItemDisc: Record "7004";
                recLabTransl: Record "25006127";
                recItemTransl: Record "30";
            begin
                TestStatusOpen;

                GetWarrantyHeader;
            end;
        }
        field(60; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Labor)) "Service Labor"
                            ELSE IF (Type=CONST(External Service)) "External Service";

            trigger OnLookup()
            var
                Item: Record "27";
                Labor: Record "25006121";
                ExternalService: Record "25006133";
                GLAccount: Record "15";
                ServiceHeader: Record "25006145";
                StandardText: Record "7";
            begin
                //ServiceHeader.GET("Document Type","Document No.");

                CASE Type OF
                    Type::" ":
                        BEGIN
                            StandardText.RESET;
                            IF LookUpMgt.LookUpStandardText(StandardText, "No.") THEN
                                VALIDATE("No.", StandardText.Code);
                        END;

                    Type::"G/L Account":
                        BEGIN
                            GLAccount.RESET;
                            IF LookUpMgt.LookUpGLAccount(GLAccount, "No.") THEN
                                VALIDATE("No.", GLAccount."No.");
                        END;

                    Type::Item:
                        BEGIN
                            Item.RESET;
                            IF LookUpMgt.LookUpItemREZ(Item, "No.") THEN
                                VALIDATE("No.", Item."No.");
                        END;

                    Type::Labor:
                        BEGIN
                            Labor.RESET;
                            Labor.SETCURRENTKEY("Make Code");
                            //Labor.SETFILTER("Make Code",'%1|''''',"Make Code");
                            IF LookUpMgt.LookUpLabor(Labor, "No.") THEN
                                VALIDATE("No.", Labor."No.");
                        END;

                    Type::"External Service":
                        BEGIN
                            ExternalService.RESET;
                            IF LookUpMgt.LookUpExternalService(ExternalService, "No.") THEN
                                VALIDATE("No.", ExternalService."No.");
                        END;
                END;
            end;

            trigger OnValidate()
            var
                Markup: Record "25006741";
                ItemDisc: Record "7004";
                LabTransl: Record "25006127";
                ItemTransl: Record "30";
                VariableFieldUsage: Record "25006006";
                NewItemNo: Code[20];
                PrepaymentMgt: Codeunit "441";
            begin
            end;
        }
        field(70; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF "No." = '' THEN
                    Type := Type::" ";
            end;
        }
        field(80; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                TransferLine: Record "5741";
            begin
                Amount := Quantity * "Unit Price";
                /*
                TestStatusOpen;
                // 03.04.2014 Elva Baltic P21 >>
                IF (Type = Type::Item) AND (Quantity < xRec.Quantity) AND ItemExists("No.") THEN BEGIN
                  IF (Quantity < CalcTransferedQuantity) THEN
                    ERROR(Text125);
                  CALCFIELDS("Reserved Qty. (Base)");
                  IF (Quantity < "Reserved Qty. (Base)") THEN BEGIN
                    ServiceTransferMgt.FindTransferLine(Rec, TransferLine);
                    ERROR(Text126, TransferLine."Document No.");
                  END;
                END;
                // 03.04.2014 Elva Baltic P21 <<
                
                "Quantity (Base)" := CalcBaseQty(Quantity);
                
                CheckSPackage(FIELDNO(Quantity), 0); //02.01.2008 EDMS P3
                
                IF Type <> Type::" " THEN
                 TESTFIELD("No.");
                
                IF Reserve <> Reserve::Always THEN
                  CheckItemAvailable(FIELDNO(Quantity));
                
                UpdateUnitPrice(FIELDNO(Quantity));
                UpdateAmounts;
                
                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN
                  InitOutstanding;
                
                IF Type = Type::Item THEN BEGIN
                  UpdateUnitPrice(FIELDNO(Quantity));
                  IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN
                    ReserveServiceLine.VerifyQuantity(Rec,xRec);
                END;
                
                UpdateQtyHours(FIELDNO(Quantity));
                */

            end;
        }
        field(90; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Price";
                /*
                TestStatusOpen;
                
                CheckSPackage(FIELDNO("Unit Price"), 0); //02.01.2008 EDMS P3
                
                VALIDATE("Line Discount %");
                */

            end;
        }
        field(100; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;

            trigger OnValidate()
            begin
                /*
                TestStatusOpen;
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                IF "VAT Calculation Type" IN ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"] THEN
                 "Amount Including VAT" := ROUND(Amount + Amount * "VAT %" / 100,Currency."Amount Rounding Precision");
                */

            end;
        }
        field(110; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

            trigger OnValidate()
            begin
                /*
                TestStatusOpen;
                
                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      Amount :=
                        ROUND(
                          "Amount Including VAT" /
                          (1 + (1 - ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                          Currency."Amount Rounding Precision");
                      "VAT Base Amount" :=
                        ROUND(Amount * (1 - ServiceHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      Amount := 0;
                      "VAT Base Amount" := 0;
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      ServiceHeader.TESTFIELD("VAT Base Discount %",0);
                      Amount :=
                        SalesTaxCalculate.ReverseCalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",ServiceHeader."Posting Date",
                          "Amount Including VAT","Quantity (Base)",ServiceHeader."Currency Factor");
                      IF Amount <> 0 THEN
                        "VAT %" :=
                          ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                      ELSE
                        "VAT %" := 0;
                      Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                      "VAT Base Amount" := Amount;
                    END;
                END;
                */

            end;
        }
        field(120; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(130; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time (Hours)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                /*
                // 25.02.2015 EDMS P21 >>
                UnitOfMeasure.GET("Unit of Measure Code");
                IF UnitOfMeasure."Minutes Per UoM" = 0 THEN
                  ERROR(STRSUBSTNO(Text127, UnitOfMeasure.FIELDCAPTION("Minutes Per UoM"), FIELDCAPTION("Unit of Measure Code"), "Unit of Measure Code"));
                // 25.02.2015 EDMS P21 <<
                
                VALIDATE(Quantity,"Standard Time");
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                UpdateUnitPrice(FIELDNO("Standard Time"));
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 <<
                */

            end;
        }
        field(140; "Symptom Code"; Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code EDMS".Code WHERE(Make Code=FIELD(Make Code));
        }
        field(150;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        WarrantyHeader: Record "25006405";
        Currency: Record "4";
        LookUpMgt: Codeunit "25006003";

    local procedure GetWarrantyHeader()
    begin
        TESTFIELD("Document No.");
        IF ("Document No." <> WarrantyHeader."No.") THEN BEGIN
          WarrantyHeader.GET("Document No.");
          IF WarrantyHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            WarrantyHeader.TESTFIELD("Currency Factor");
            Currency.GET(WarrantyHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
    end;

    local procedure TestStatusOpen()
    begin
        GetWarrantyHeader;
          IF Type <> Type::" " THEN
            WarrantyHeader.TESTFIELD(Status,WarrantyHeader.Status::Open);
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        ServPricesIncVar: Integer;
        ServHeader: Record "25006145";
    begin
        IF NOT WarrantyHeader.GET("Document No.") THEN BEGIN
          WarrantyHeader."No." := '';
          WarrantyHeader.INIT;
        END;
        IF WarrantyHeader."Prices Including VAT" THEN
          ServPricesIncVar := 1
        ELSE
          ServPricesIncVar := 0;
        CLEAR(WarrantyHeader);
        EXIT('2,'+FORMAT(ServPricesIncVar)+',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Warranty Document Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;
}

