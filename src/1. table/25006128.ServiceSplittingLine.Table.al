table 25006128 "Service Splitting Line"
{
    // 18.12.2014 Elva Baltic P21 #E0003
    //   Modified procedure:
    //     CreateNewAllocApp
    // 
    // 12.12.2014 EB.P8
    //   New concept of split - lighter
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     CreateQuote
    // 
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     50010 "Create Quote"
    //   Added functions:
    //     CreateLinesForQuote
    //     CreateQuote
    //     DeleteDocQuote
    //   Modified function:
    //     ProceedDocSplit
    //     ChangeIncludeInfo
    //     GetAdjustedQtyShare (fix error with division by zero)
    // 
    // 04.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified functions:
    //     ProceedDocSplit (correct error with amounts, discounts lost)
    // 
    // 21.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified functions:
    //     ProceedDocSplit
    //     ApplyInsertAsWholeDoc
    //     ApplyInsertAsHeaderByServDoc
    //   Added field:
    //     50000 Include
    // 
    // 02.07.2013 EDMS P8
    //   * fix in main process
    // 
    // 08.04.2013 EDMS P8
    //   * FIX in ProceedDocSplit
    // 
    // Concept for process "Document split":
    //   Split Lines should repeat source document and not able delete or add manually!
    // 
    // "Temp. Document No." - is used to hold add split documents for the same one

    Caption = 'Service Splitting Line';
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order';
            OptionMembers = Quote,"Order","Return Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF "Temp. Document No." = GetSourceTempDocNo THEN
                    ERROR(Text008);
                GetCust("Sell-to Customer No.");
                IF Cust."Bill-to Customer No." <> '' THEN
                    VALIDATE("Bill-to Customer No.", Cust."Bill-to Customer No.")
                ELSE BEGIN
                    IF "Bill-to Customer No." = "Sell-to Customer No." THEN
                        SkipBillToContact := TRUE;
                    VALIDATE("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := FALSE;
                END;
                UpdateLines(FIELDCAPTION("Sell-to Customer No."), CurrFieldNo <> 0);
            end;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Description = 'Source Document No.';
            TableRelation = "Service Header EDMS".No. WHERE(Document Type=FIELD(Document Type));
        }
        field(4;"Line No.";Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Labor)) "Service Labor"
                            ELSE IF (Type=CONST(External Service)) "External Service";
        }
        field(7;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(8;"Temp. Document No.";Integer)
        {
            Caption = 'Temp. Document No.';
            Editable = false;

            trigger OnValidate()
            begin
                IF "Temp. Document No." = 0 THEN BEGIN
                //  ServiceSplittingLine := Rec;

                  IF Line THEN BEGIN
                    IF "Document No." = '' THEN BEGIN
                      ServiceSplittingLine.RESET;
                      IF ServiceSplittingLine.FINDLAST THEN BEGIN
                        "Document No." := ServiceSplittingLine."Document No.";
                        "Temp. Document No." := ServiceSplittingLine."Temp. Document No.";
                      END;
                    END ELSE BEGIN
                      ServiceSplittingLine.RESET;
                      //ServiceSplittingLine.SETRANGE(Line, FALSE);
                      ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
                      ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
                      IF ServiceSplittingLine.FINDLAST THEN
                        "Temp. Document No." := ServiceSplittingLine."Temp. Document No.";
                    END;
                  END ELSE BEGIN
                    IF "Document No." = '' THEN BEGIN
                      ServiceSplittingLine.RESET;
                      IF ServiceSplittingLine.FINDLAST THEN BEGIN
                        "Document No." := ServiceSplittingLine."Document No.";
                      END;
                    END;
                    ServiceSplittingLine.RESET;
                    //ServiceSplittingLine.SETRANGE(Line, FALSE);
                    ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
                    ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
                    IF ServiceSplittingLine.FINDLAST THEN
                      "Temp. Document No." := ServiceSplittingLine."Temp. Document No.";
                    "Temp. Document No." += 10000;
                  END;
                  IF "Temp. Document No." = 0 THEN
                    "Temp. Document No." := 10000;
                END;
            end;
        }
        field(9;"Temp. Line No.";Integer)
        {
            Caption = 'Temp. Line No.';
            Editable = false;

            trigger OnValidate()
            begin
                IF "Temp. Line No." = 0 THEN BEGIN
                  ServiceSplittingLine.RESET;
                  ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
                  ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
                  ServiceSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
                  IF ServiceSplittingLine.FINDLAST THEN
                    "Temp. Line No." := ServiceSplittingLine."Temp. Line No.";
                  "Temp. Line No." += 10000;
                END;
            end;
        }
        field(10;Line;Boolean)
        {
            Caption = 'Line';
        }
        field(11;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(12;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(13;"Unit of Measure";Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(16;"Outstanding Quantity";Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';
        }
        field(23;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(27;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(32;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(68;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer.No.;

            trigger OnValidate()
            begin
                IF "Temp. Document No." = GetSourceTempDocNo THEN
                  ERROR(Text008);
                GetCust("Bill-to Customer No.");
                "Currency Code" := Cust."Currency Code";
                UpdateLines(FIELDCAPTION("Bill-to Customer No."),CurrFieldNo <> 0);
            end;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77;"VAT Calculation Type";Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(89;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(91;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF "Temp. Document No." = GetSourceTempDocNo THEN
                  ERROR(Text008);
                UpdateLines(FIELDCAPTION("Currency Code"),CurrFieldNo <> 0);
            end;
        }
        field(96;Reserve;Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100;"Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(101;"System-Created Entry";Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';
        }
        field(104;"VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(105;"Inv. Disc. Amount to Invoice";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(106;"VAT Identifier";Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(109;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(110;"Prepmt. Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Line Amount"));
            Caption = 'Prepmt. Line Amount';
            MinValue = 0;
        }
        field(111;"Prepmt. Amt. Inv.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Editable = false;
        }
        field(112;"Prepmt. Amt. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. VAT';
            Editable = false;
        }
        field(113;"Prepayment Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            Editable = false;
        }
        field(114;"Prepmt. VAT Base Amt.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Base Amt.';
            Editable = false;
        }
        field(115;"Prepayment VAT %";Decimal)
        {
            Caption = 'Prepayment VAT %';
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(116;"Prepmt. VAT Calc. Type";Option)
        {
            Caption = 'Prepmt. VAT Calc. Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117;"Prepayment VAT Identifier";Code[10])
        {
            Caption = 'Prepayment VAT Identifier';
            Editable = false;
        }
        field(118;"Prepayment Tax Area Code";Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(119;"Prepayment Tax Liable";Boolean)
        {
            Caption = 'Prepayment Tax Liable';
        }
        field(120;"Prepayment Tax Group Code";Code[10])
        {
            Caption = 'Prepayment Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(121;"Prepmt Amt to Deduct";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt to Deduct"));
            Caption = 'Prepmt Amt to Deduct';
            MinValue = 0;
        }
        field(122;"Prepmt Amt Deducted";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt Deducted"));
            Caption = 'Prepmt Amt Deducted';
            Editable = false;
        }
        field(123;"Prepayment Line";Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(124;"Prepmt. Amount Inv. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. Incl. VAT';
            Editable = false;
        }
        field(5402;"Variant Code";Code[20])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }
        field(5403;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5405;Planned;Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;
        }
        field(5416;"Outstanding Qty. (Base)";Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5706;"Unit of Measure (Cross Ref.)";Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5709;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710;Nonstock;Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }
        field(5712;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5790;"Requested Delivery Date";Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5917;"Qty. to Consume";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume';
            DecimalPlaces = 0:5;
        }
        field(5918;"Quantity Consumed";Decimal)
        {
            Caption = 'Quantity Consumed';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5919;"Qty. to Consume (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume (Base)';
            DecimalPlaces = 0:5;
        }
        field(5920;"Qty. Consumed (Base)";Decimal)
        {
            Caption = 'Qty. Consumed (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002;"Customer Disc. Group";Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(7100;"Quantity Share % 1";Decimal)
        {
            Caption = 'Quantity Share % 1';

            trigger OnValidate()
            begin
                "New Quantity 1" := ROUND(Quantity * "Quantity Share % 1"/100, 0.001)
            end;
        }
        field(7110;"New Quantity 1";Decimal)
        {
            Caption = 'New Quantity 1';

            trigger OnValidate()
            begin
                "Quantity Share % 1" := "New Quantity 1"/Quantity*100
            end;
        }
        field(7120;"Quantity Share % 2";Decimal)
        {
            Caption = 'Quantity Share % 2';

            trigger OnValidate()
            begin
                "New Quantity 2" := ROUND(Quantity * "Quantity Share % 2"/100, 0.001)
            end;
        }
        field(7130;"New Quantity 2";Decimal)
        {
            Caption = 'New Quantity 2';

            trigger OnValidate()
            begin
                "Quantity Share % 2" := "New Quantity 2"/Quantity*100
            end;
        }
        field(7140;"Quantity Share % 3";Decimal)
        {
            Caption = 'Quantity Share % 3';

            trigger OnValidate()
            begin
                "New Quantity 3" := ROUND(Quantity * "Quantity Share % 3"/100, 0.001)
            end;
        }
        field(7150;"New Quantity 3";Decimal)
        {
            Caption = 'New Quantity 3';

            trigger OnValidate()
            begin
                "Quantity Share % 3" := "New Quantity 3"/Quantity*100
            end;
        }
        field(7160;"Quantity Share %";Decimal)
        {
            Caption = 'Quantity Share %';
            MinValue = 0;

            trigger OnValidate()
            begin
                "New Quantity" := ROUND(Quantity*"Quantity Share %"/100, 0.00001);
                DecimalTemp := ROUND(Quantity*"Quantity Share %"/100, 0.00001);
                IF "Quantity Share %" > 0 THEN BEGIN
                  "Amount Share %" := 0;
                  "New Amount" := 0;
                END;
                UpdateLines(FIELDCAPTION("Quantity Share %"),CurrFieldNo <> 0);
                /*
                IF NOT Line THEN BEGIN
                  IF "Quantity Share %" <> xRec."Quantity Share %" THEN BEGIN
                    IF CONFIRM(Text0001, TRUE) THEN BEGIN
                      ServiceSplittingLine.RESET;
                      ServiceSplittingLine.SETRANGE(Line, TRUE);
                      ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
                      ServiceSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
                      IF ServiceSplittingLine.FINDFIRST THEN BEGIN
                        REPEAT
                          ServiceSplittingLine.VALIDATE("Quantity Share %", "Quantity Share %");
                          ServiceSplittingLine.MODIFY;
                        UNTIL ServiceSplittingLine.NEXT = 0;
                      END;
                    END;
                  END;
                END;
                */

            end;
        }
        field(7170;"New Quantity";Decimal)
        {
            Caption = 'New Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF Quantity > 0 THEN
                  VALIDATE("Quantity Share %", ROUND(100*"New Quantity"/Quantity, 0.00001))
                ELSE
                  VALIDATE("Quantity Share %", 0);
            end;
        }
        field(7180;"Amount Share %";Decimal)
        {
            Caption = 'Amount Share';
            MinValue = 0;

            trigger OnValidate()
            begin
                //logic taken from Sales Line:
                GetHeader;
                "New Amount" := ROUND(Amount*"Amount Share %"/100, Currency."Amount Rounding Precision");
                IF "Amount Share %" > 0 THEN BEGIN
                  "Quantity Share %" := 0;
                  "New Quantity" := 0;
                END;
                UpdateLines(FIELDCAPTION("Amount Share %"),CurrFieldNo <> 0);
            end;
        }
        field(7190;"New Amount";Decimal)
        {
            Caption = 'New Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF Amount > 0 THEN BEGIN
                  GetHeader;
                  VALIDATE("Amount Share %", ROUND(100*"New Amount"/Amount, Currency."Amount Rounding Precision"));
                END ELSE
                  VALIDATE("Amount Share %", 0);
            end;
        }
        field(7200;"New Document No.";Code[20])
        {
            Caption = 'New Document No.';
            Description = 'supposed to be filled only at processing';
        }
        field(7210;Include;Boolean)
        {
            Caption = 'Include';

            trigger OnValidate()
            begin
                IF Include THEN BEGIN
                  VALIDATE("New Quantity", Quantity);
                  ChangeIncludeInfo(0);
                END ELSE BEGIN
                  VALIDATE("New Quantity", 0);
                  ChangeIncludeInfo(Quantity);
                END;
            end;
        }
        field(7220;"Create Quote";Boolean)
        {
            Caption = 'Create Quote';
        }
        field(60000;"External No.";Code[20])
        {
            Caption = 'External No.';
        }
        field(90200;"Planned Service Date";Date)
        {
            Caption = 'Planned Service Date';
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006014;"Product Subgroup Code";Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE (Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(25006015;Prepayment;Boolean)
        {
            Caption = 'Prepayment';
        }
        field(25006030;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006130;"External Serv. Tracking No.";Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006150;"Standard Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time (Hours)';
            DecimalPlaces = 0:5;
        }
        field(25006160;"Standard Time Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Standard Time Line No.';
            Editable = false;
        }
        field(25006170;"Vehicle Registration No.";Code[11])
        {
            CalcFormula = Lookup("Service Header EDMS"."Vehicle Registration No." WHERE (Document Type=FIELD(Document Type),
                                                                                         No.=FIELD(Document No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006190;"Model Code";Code[20])
        {
            CalcFormula = Lookup("Service Header EDMS"."Model Code" WHERE (Document Type=FIELD(Document Type),
                                                                           No.=FIELD(Document No.)));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Model.Code;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package".No.;
        }
        field(25006220;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006250;"Service Work Shift Code";Code[10])
        {
            Caption = 'Service Work Shift Code';
            TableRelation = "Service Package";
        }
        field(25006300;"Package Version No.";Integer)
        {
            Caption = 'Package Version No.';
            Editable = false;
            TableRelation = "Service Package Version"."Version No." WHERE (Package No.=FIELD(Package No.));
        }
        field(25006310;"Package Version Spec. Line No.";Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." WHERE (Package No.=FIELD(Package No.),
                                                                             Version No.=FIELD(Package Version No.));
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup("Service Header EDMS".VIN WHERE (Document Type=FIELD(Document Type),
                                                                  No.=FIELD(Document No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006600;"Sell-to Customer Bill %";Decimal)
        {
            Caption = 'Sell-to Customer Bill %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006610;"Sell-to Customer Bill Amount";Decimal)
        {
            Caption = 'Sell-to Customer Bill Amount';
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006800;"DMS Variable Field 25006800";Code[20])
        {
        }
        field(25006801;"DMS Variable Field 25006801";Code[20])
        {
        }
        field(25006802;"DMS Variable Field 25006802";Code[20])
        {
        }
        field(25007110;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007150;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job.No. WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007180;Split;Boolean)
        {
            Caption = 'Split';
        }
        field(25007190;Status;Code[10])
        {
            Caption = 'Status';
            TableRelation = "Service Work Status EDMS";
        }
        field(25007195;"BOM Item No.";Code[20])
        {
            Caption = 'BOM Item No.';
            TableRelation = Item;
        }
        field(25007220;"Sell-to Customer Name";Text[50])
        {
            CalcFormula = Lookup("Service Header EDMS"."Sell-to Customer Name" WHERE (Sell-to Customer No.=FIELD(Sell-to Customer No.)));
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
        }
        field(25007230;"Bill-to Name";Text[50])
        {
            CalcFormula = Lookup("Service Header EDMS"."Bill-to Name" WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Name';
            FieldClass = FlowField;
        }
        field(25007240;"Document Amount";Decimal)
        {
            CalcFormula = Sum("Service Splitting Line".Amount WHERE (Document Type=FIELD(Document Type),
                                                                     Document No.=FIELD(Document No.),
                                                                     Temp. Document No.=FIELD(Temp. Document No.),
                                                                     Include=CONST(Yes)));
            Caption = 'Document Amount';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Temp. Document No.",Line,"Temp. Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2;Line,"Document Type","Document No.","Temp. Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "99000886";
        ServiceHeader: Record "25006145";
        recSalesLine: Record "37";
        recSalesHeader: Record "36";
        recServOrderAlloc: Record "25006277";
        recResourceAlloc: Record "25006271";
        SIEAssgnt: Record "25006706";
        ItemJnlLine: Record "83";
    begin
        IF NOT Line THEN BEGIN
          ServiceSplittingLine.RESET;
          ServiceSplittingLine.SETRANGE(Line, TRUE);
          ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
          ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
          ServiceSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
          ServiceSplittingLine.DELETEALL;
        END;
    end;

    trigger OnInsert()
    var
        ServiceHeader: Record "25006145";
    begin
        VALIDATE("Temp. Document No.");
        VALIDATE("Temp. Line No.");
    end;

    var
        ServiceSplittingLine: Record "25006128";
        Text0001: Label 'Would you like to copy that value to lines?';
        ServiceSplittingHeader: Record "25006128";
        Currency: Record "4";
        Text0002: Label 'There is problem no initialise %1.';
        Text0003: Label 'There is nothing to process.';
        Text0004: Label 'Is not possible to find %1 record with %2.';
        GLSetup: Record "98";
        DecimalTemp: Decimal;
        ServiceHdr: Record "25006145";
        Text007: Label 'Exist Service Labor Allocation entry, which is not finished.';
        ServiceScheduleMgt: Codeunit "25006201";
        Text008: Label 'The field in that record is not allowed modify.';
        Cust: Record "18";
        SkipBillToContact: Boolean;
        Text031: Label 'You have modified %1.\\';
        Text032: Label 'Do you want to update the lines?';
        Text103: Label 'Would you like to delete created split prepare lines?';
        Text104: Label 'There is difference in amounts: in source document %1 %3, in split %2 %3. Are you sure to continue?';
        ServiceTransferMgt: Codeunit "25006010";
        TransferLineReserve: Codeunit "99000836";
        Text105: Label 'Exist Return Transfer Order, which is not posted!';
        Text106: Label 'Service Line No. %1 Transfered Quantity must be equal to zero!';
        Text107: Label 'Service Quote No. %1 was created! ';
        Text108: Label 'Created from Service Order No.%1';
        Text109: Label 'Resource is assigned to Labor No. %1!';
        Text110: Label 'Item No. %1 exist assigned Transfer Line!';

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        ServPricesIncVar: Integer;
        ServHeader: Record "25006145";
    begin
        IF NOT ServHeader.GET("Document Type","Document No.") THEN BEGIN
          ServHeader."No." := '';
          ServHeader.INIT;
        END;
        IF ServHeader."Prices Including VAT" THEN
          ServPricesIncVar := 1
        ELSE
          ServPricesIncVar := 0;
        CLEAR(ServHeader);
        EXIT('2,'+FORMAT(ServPricesIncVar)+',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Service Splitting Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    [Scope('Internal')]
    procedure ApplyInsertAsWholeDoc()
    var
        ServiceSplittingLineL: Record "25006128";
        TempDocNo: Integer;
    begin
        ServiceSplittingLineL.RESET;
        ServiceSplittingLineL.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLineL.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLineL.SETRANGE("Temp. Document No.", "Temp. Document No.");
        IF ServiceSplittingLineL.FINDFIRST THEN BEGIN
          VALIDATE("Temp. Document No.", 0);
          TempDocNo := "Temp. Document No.";
          REPEAT
            INIT;
            TRANSFERFIELDS(ServiceSplittingLineL);
            "Temp. Document No." := TempDocNo;
            VALIDATE("Temp. Line No.", 0);
            Include := FALSE;                                                           // 21.03.2014 Elva Baltic P21
            INSERT;
          UNTIL ServiceSplittingLineL.NEXT = 0;
          ServiceSplittingLineL.SETRANGE("Temp. Document No.", TempDocNo);
          ServiceSplittingLineL.SETRANGE(Line, FALSE);
          IF ServiceSplittingLineL.FINDFIRST THEN BEGIN
            ServiceSplittingLineL.VALIDATE("Quantity Share %", 0);
            ServiceSplittingLineL.VALIDATE("Amount Share %", 0);
            ServiceSplittingLineL.Include := FALSE;                                     // 21.03.2014 Elva Baltic P21
            ServiceSplittingLineL.MODIFY;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure ApplyInsertAsHeaderByServDoc(DocType: Integer;DocNo: Code[20])
    var
        ServiceHeader: Record "25006145";
        ServiceLine: Record "25006146";
        ServiceSplittingLineL: Record "25006128";
        TempDocNo: Integer;
        TempLineNo: Integer;
    begin
        IF ServiceHeader.GET(DocType, DocNo) THEN BEGIN
          ServiceLine.RESET;
          ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
          ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
          IF ServiceLine.FINDFIRST THEN BEGIN
            ServiceSplittingLineL.INIT;
            CopyFldsServH2SplitLine(ServiceHeader, ServiceSplittingLineL);
            ServiceSplittingLineL.VALIDATE(Line, FALSE);
            ServiceSplittingLineL.VALIDATE("Line No.", 0);
            ServiceSplittingLineL.VALIDATE("Document Type", DocType);
            ServiceSplittingLineL.VALIDATE("Document No.", DocNo);
            ServiceSplittingLineL.VALIDATE("Temp. Document No.", 0);
            ServiceSplittingLineL."Temp. Line No." := 0;
            ServiceSplittingLineL.INSERT(TRUE);
            TempDocNo := ServiceSplittingLineL."Temp. Document No.";
            REPEAT
              ServiceSplittingLineL.INIT;
              CopyFldsServL2SplitLine(ServiceLine, ServiceSplittingLineL);
              ServiceSplittingLineL."Temp. Document No." := TempDocNo;
              ServiceSplittingLineL."Temp. Line No." := 0;
              ServiceSplittingLineL.Line := TRUE;
              // Only Original Document Lines must be with Include = TRUE            // 21.03.2014 Elva Baltic P21
              IF ServiceSplittingLineL."Temp. Document No." = 10000 THEN             // 21.03.2014 Elva Baltic P21
                ServiceSplittingLineL.Include := TRUE;                               // 21.03.2014 Elva Baltic P21
              ServiceSplittingLineL.INSERT(TRUE);
            UNTIL ServiceLine.NEXT = 0;
            GET(ServiceSplittingLineL."Document Type", ServiceSplittingLineL."Document No.", ServiceSplittingLineL."Temp. Document No.",
              TRUE, ServiceSplittingLineL."Temp. Line No.");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure ProceedDocSplit()
    var
        ServiceHeader: Record "25006145";
        ServiceHeader2: Record "25006145";
        ServiceLine: Record "25006146";
        ServiceLine2: Record "25006146";
        ServiceLineDest: Record "25006146";
        ServiceLineSourceTmp: Record "25006146" temporary;
        FirstTempDocumentNo: Integer;
        PreviousTempDocumentNo: Integer;
        NewDestAllocationEntryNo: Integer;
        MessageText: Text[250];
        Text101: Label 'There are created additional documents with %1: %2';
        DocNoFilterString: Text[100];
        DocNoFilterString2: Text[100];
        SourceDocHours: Decimal;
        ServiceAllocEntry: Record "25006271";
        ServAllocEntryTmp: Record "25006271" temporary;
        ServAllocEntrySrcTmp: Record "25006271" temporary;
        ServAllocAppTmp: Record "25006277" temporary;
        ServAllocAppSrcTmp: Record "25006277" temporary;
        ServAllocEntryRemainTmp: Record "25006271" temporary;
        ServAllocAppRemainTmp: Record "25006277" temporary;
        ServAllocApp: Record "25006277" temporary;
        ServAllocAppOfEntryTmp: Record "25006277" temporary;
        SplittingHeaderRecNo: Integer;
        ServiceSplittingLineSource: Record "25006128";
        ServiceSplittingLineDest: Record "25006128";
        ShareToAdjustQtySrc: Decimal;
        ShareToAdjustQtyDest: Decimal;
        ShareOfLineInAlloc: Decimal;
        NewDocNo: Code[20];
        NewLineNo: Integer;
        NewLineQtyShare: Decimal;
        SrcAmt: Decimal;
        DstAmt: Decimal;
        DiffAmt: Decimal;
        LoopCurrCnt: Integer;
        SeparateFunctPars: Text[30];
        TransfHeader: Record "5740";
        TransferExist: Boolean;
        TransfHeader2: Record "5740";
        OldTransfLine: Record "5741";
        NewTransfLine: Record "5741";
        TrackingSpec: Record "336";
        NewInvoiceNo: Code[20];
        ServAllocApplNoAlloc: Record "25006277";
        OrigDocNo: Code[20];
        ServiceSplittingLineNoAlloc: Record "25006128";
        OrigDocType: Integer;
        ServAllocApplNoAllocToModify: Record "25006277";
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
    begin
        //at first do compare values
        
        //prepare source service line
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", "Document Type");
        ServiceLine.SETRANGE("Document No.", "Document No.");
        ServiceLine.SETRANGE(Type, ServiceLine.Type::Labor);
        ServiceLineSourceTmp.RESET;
        ServiceLineSourceTmp.DELETEALL;
        ServAllocEntrySrcTmp.RESET;
        ServAllocEntrySrcTmp.DELETEALL;
        ServAllocAppSrcTmp.RESET;
        ServAllocAppSrcTmp.DELETEALL;
        IF ServiceLine.FINDFIRST THEN
        REPEAT
          ServiceLineSourceTmp := ServiceLine;
          ServiceLineSourceTmp.INSERT;
        UNTIL ServiceLine.NEXT = 0;
        
        //12.12.2014 EB.P8 >>
        //ServiceAllocEntry.RESET;
        //ServiceAllocEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID");
        //ServiceAllocEntry.SETRANGE("Source Type", ServiceAllocEntry."Source Type"::"Service Document");
        //ServiceAllocEntry.SETRANGE("Source Subtype", ServiceAllocEntry."Source Subtype"::Order);
        //ServiceAllocEntry.SETRANGE("Source ID", "Document No.");
        ////Pending,In Progress,Finished,On Hold
        //ServiceAllocEntry.SETFILTER(Status, '%1|%2', ServiceAllocEntry.Status::"In Progress", ServiceAllocEntry.Status::"On Hold");
        //IF ServiceAllocEntry.FINDFIRST THEN
        //  ERROR(Text007);
        //12.12.2014 EB.P8 <<
        
        IF NOT ServiceHeader.GET("Document Type", "Document No.") THEN
          ERROR(Text0002, ServiceHeader.TABLECAPTION);
        
        // 21.03.2014 Elva Baltic P21 >>
        TransferExist := FALSE;
        TransfHeader.RESET;
        TransfHeader.SETCURRENTKEY("Source Type","Source Subtype","Source No.","Document Profile");
        TransfHeader.SETRANGE("Source Type",DATABASE::"Service Header EDMS");
        TransfHeader.SETRANGE("Source Subtype",1);
        TransfHeader.SETRANGE("Source No.",ServiceHeader."No.");
        TransfHeader.SETRANGE("Document Profile",TransfHeader."Document Profile"::Service);
        IF TransfHeader.FINDFIRST THEN BEGIN
          REPEAT
            IF TransfHeader."Transfer-from Code" = ServiceHeader."Location Code" THEN
              ERROR(Text105);
          UNTIL TransfHeader.NEXT = 0;
          TransferExist := TRUE;
        END;
        // 21.03.2014 Elva Baltic P21 <<
        
        //12.12.2014 EB.P8
        //here it seems no need to check for reservations, because it will ceck in delete process
        //...
        
        ServiceSplittingHeader.RESET;
        ServiceSplittingHeader.SETRANGE(Line, FALSE);
        ServiceSplittingHeader.SETRANGE("Document Type", "Document Type");
        ServiceSplittingHeader.SETRANGE("Document No.", "Document No.");
        
        // that part creates all "Service Header EDMS" + "Service Line EDMS"
        // and put correcr quantities
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE(Line, TRUE);
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.SETFILTER("Temp. Document No.", '<>%1', 0);                                     // 06.05.2014 Elva Baltic P21
        IF NOT ServiceSplittingLine.FINDFIRST THEN
          ERROR(Text0003);
        FirstTempDocumentNo := ServiceSplittingLine."Temp. Document No.";
        PreviousTempDocumentNo := FirstTempDocumentNo;
        DocNoFilterString := ''''+ServiceSplittingLine."Document No."+'''';
        DocNoFilterString2 := ''; // it stores the same filter but only without original document
        REPEAT
          // 21.03.2014 Elva Baltic P21 >>
          // Modification of Original document is transfered after new document creation due to reservation
          /*
          IF FirstTempDocumentNo = ServiceSplittingLine."Temp. Document No." THEN BEGIN
        
            // just modify values of lines - for original document
            IF NOT ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                ServiceSplittingLine."Line No.") THEN
              ERROR(Text0004, ServiceLine.TABLECAPTION, FORMAT(ServiceSplittingLine."Document Type") + ', ' +
                ServiceSplittingLine."Document No." + ', ' + FORMAT(ServiceSplittingLine."Line No."));
        
            ServiceLine.VALIDATE(Quantity, ServiceSplittingLine."New Quantity");
            ServiceLine.MODIFY;
        
          // modify allocation
          END ELSE BEGIN
          */
          // 21.03.2014 Elva Baltic P21 <<
        
          IF FirstTempDocumentNo <> ServiceSplittingLine."Temp. Document No." THEN BEGIN
            IF PreviousTempDocumentNo <> ServiceSplittingLine."Temp. Document No." THEN BEGIN
              // NEED CREATE HEADER RECORD AT FIRST
              ServiceHeader2.INIT;
              ServiceHeader2.VALIDATE("Document Type", ServiceHeader."Document Type");
              ServiceHeader2."No." :='';
              ServiceHeader2."No. Series" := '';
              ServiceHeader2.INSERT(TRUE);
        
              CopyHeaderComments(ServiceHeader,ServiceHeader2);
        
              ServiceSplittingHeader.SETRANGE("Temp. Document No.", ServiceSplittingLine."Temp. Document No.");
              ServiceSplittingHeader.FINDFIRST;
              ServiceSplittingHeader."New Document No." := ServiceHeader2."No.";
              ServiceSplittingHeader.MODIFY;
        
              ServiceHeader2.TRANSFERFIELDS(ServiceHeader,FALSE);
              IF ServiceHeader."Posting No." <> '' THEN
                ServiceHeader2.VALIDATE("Posting No.", ServiceHeader2."No.");
        
              ServiceHeader2."No." := ServiceSplittingHeader."New Document No.";
              ServiceHeader2.SetSkipVehicleChoose(TRUE);  //02.07.2013 EDMS P8
              IF ServiceHeader."Sell-to Customer No." <> ServiceSplittingHeader."Sell-to Customer No." THEN BEGIN
                ServiceHeader2."Sell-to Customer No." := '';
                ServiceHeader2."Bill-to Customer No." := '';
                ServiceHeader2.VALIDATE("Sell-to Customer No.", ServiceSplittingHeader."Sell-to Customer No.");
              END;
              IF ServiceHeader2."Bill-to Customer No." <> ServiceSplittingHeader."Bill-to Customer No." THEN BEGIN
                ServiceHeader2."Bill-to Customer No." := '';
                ServiceHeader2.VALIDATE("Bill-to Customer No.", ServiceSplittingHeader."Bill-to Customer No.");
              END;
              IF ServiceHeader."Currency Code" <> ServiceSplittingHeader."Currency Code" THEN BEGIN
                ServiceHeader2."Currency Code" := '';
                ServiceHeader2.VALIDATE("Currency Code", ServiceSplittingHeader."Currency Code");
              END;
              ServiceHeader2.MODIFY(TRUE);
              PreviousTempDocumentNo := ServiceSplittingLine."Temp. Document No.";
              IF MessageText <> '' THEN
                MessageText += ', ';
              MessageText += FORMAT(ServiceHeader2."No.");
              DocNoFilterString += '|'''+ ServiceHeader2."No." +'''';
              IF DocNoFilterString2 <> '' THEN
                DocNoFilterString2 += '|';
              DocNoFilterString2 += ''''+ ServiceHeader2."No." +'''';
            END;
            // create lines
            IF NOT ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                   ServiceSplittingLine."Line No.") THEN
              ERROR(Text0004, ServiceLine.TABLECAPTION, FORMAT(ServiceSplittingLine."Document Type") + ', ' +
                    ServiceSplittingLine."Document No." + ', ' + FORMAT(ServiceSplittingLine."Line No."));
            // IF (ServiceSplittingLine.Type = 0) OR                                            // 06.05.2014 Elva Baltic P21
            IF ServiceSplittingLine.Include                                                     // 15.09.2015 EB.P30
              // (ServiceSplittingLine.Type = 0) AND                                            // 06.05.2014 Elva Baltic P21
              // OR (ServiceSplittingLine."New Quantity" <> 0)                                  // 15.09.2015 EB.P30
            THEN BEGIN
        
              //IF ServiceLine.CalcTransferedQuantity <> 0 THEN                                   // 21.03.2014 Elva Baltic P21
              //  ERROR(Text106, ServiceLine."Line No.");                                         // 21.03.2014 Elva Baltic P21
        
              ServiceLine2.INIT;
              ServiceLine2.TRANSFERFIELDS(ServiceLine, FALSE);
              ServiceLine2."Document Type" := ServiceSplittingHeader."Document Type";
              ServiceLine2."Document No." := ServiceSplittingHeader."New Document No.";
              ServiceLine2."Line No." := ServiceSplittingLine."Line No.";
              ServiceLine2."Sell-to Customer No." := ServiceSplittingHeader."Sell-to Customer No.";
              ServiceLine2."Bill-to Customer No." := ServiceSplittingHeader."Bill-to Customer No.";
              ServiceLine2."Currency Code" := ServiceSplittingHeader."Currency Code";
              // 04.04.2014 Elva Baltic P21 >>
              /*
              ServiceLine2.VALIDATE("No.", ServiceSplittingLine."No.");
              ServiceLine2.VALIDATE("Location Code", ServiceSplittingLine."Location Code");
              ServiceLine2.VALIDATE(Quantity, ServiceSplittingLine."New Quantity");
              //ServiceLine2.VALIDATE("Unit Price", ServiceSplittingLine."Unit Price");
              */
              // 04.04.2014 Elva Baltic P21 <<
              ServiceLine2.Description := ServiceSplittingLine.Description;
              ServiceLine2.INSERT(TRUE);
              // set doc link to new created
              ServiceSplittingLine."New Document No." := ServiceSplittingHeader."New Document No.";
              ServiceSplittingLine.MODIFY;
        
        // 15.10.2015 EB.P30 >>
              ReservEntry.RESET;
              ReservEntry.SETRANGE("Source Type",DATABASE::"Service Line EDMS");
              ReservEntry.SETRANGE("Source Subtype",1);
              ReservEntry.SETRANGE("Source ID",ServiceHeader."No.");
              ReservEntry.SETRANGE("Source Ref. No.",ServiceLine2."Line No.");
              ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
              IF ReservEntry.FIND('-') THEN
                REPEAT
                  ReservEntry2.RESET;
                  ReservEntry2.GET(ReservEntry."Entry No.",TRUE);
                  IF ReservEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN BEGIN
                    ReservEntry."Source ID" := ServiceLine2."Document No.";
                    ReservEntry."Source Ref. No." := ServiceLine2."Line No.";
                    ReservEntry.MODIFY;
                  END;
                UNTIL ReservEntry.NEXT = 0;
        // 15.10.2015 EB.P30 <<
        
            END;
          END;
        UNTIL ServiceSplittingLine.NEXT = 0;
        ServiceSplittingHeader.SETRANGE("Temp. Document No.");
        
        // 21.03.2014 Elva Baltic P21 >>
        // Create Transfer Orders for New Service Orders
        IF TransferExist THEN BEGIN
          ServiceHeader2.RESET;
          ServiceHeader2.SETRANGE("Document Type", ServiceHeader."Document Type");
          ServiceHeader2.SETFILTER("No.", DocNoFilterString2);
          IF ServiceHeader2.FINDFIRST THEN
            REPEAT
              ServiceTransferMgt.CreateTransferOrderForSplit(ServiceHeader2);
            UNTIL ServiceHeader2.NEXT = 0;
        END;
        
        // Now adjust labor allocations of source document and create for new documents
        // Here main loop for all allocation events, idea is for each allocation go through split documents
        //  by define what line went to the new one. In details: For an allocation get all applications into temporary table then loop it,
        //   remove that application from temp
        //   find service line and depending on which document it is, do following:
        //    in case old document line - nothing;
        //    in case new document - create, as copy, new allocation and redefine application and
        //      check in temp is there other applications that should move onto new alloc (if yes then remove it and...).
        //      If on old allocation not left applications then delete it - better by OnDelete event.
        //    in case not found line, on header level - copy allocation and all applications;
        // lets review all records meaning:
        // ServiceSplittingHeader real data only filtered
        // ServAllocEntrySrcTmp temp data, rigth before the loop will fill it (all allocations assigned to source doc)
        // ServAllocAppSrcTmp temp data, rigth before the loop will fill it (all applications assigned to source doc)
        // ServAllocAppOfEntryTmp temp data, will be filled in loop it (all applications assigned to certain allocation)
        // ServiceSplittingLineSource real data, will be filtered in loop by previous split doc + first app of current alloc
        // ServiceSplittingLineDest real data, will be filtered in loop by current split doc + first app of current alloc
        // ServiceLineDest real data, will be positioned in loop by current split doc + first app of current alloc
        FindAllocationsOfLabor(ServiceSplittingHeader."Document Type", ServiceSplittingHeader."Document No.",
          -1, ServAllocEntrySrcTmp, ServAllocAppSrcTmp, 2, '1');
        IF ServAllocEntrySrcTmp.FINDFIRST THEN BEGIN
          REPEAT
            ServiceSplittingHeader.FINDFIRST;
            SplittingHeaderRecNo := 0;
            GetApplicationForAllocEntry(ServAllocEntrySrcTmp."Entry No.", ServAllocAppOfEntryTmp);
            IF ServAllocAppOfEntryTmp.FINDFIRST THEN BEGIN  // THERE could be situations that allocation has no applications
              FindFirstForApp(ServiceSplittingLineSource, ServAllocAppOfEntryTmp, ServiceSplittingHeader."Temp. Document No.");
        
        
              SeparateFunctPars := '';
              //we are not interested in first document - source document
              IF ServiceSplittingHeader.NEXT > 0 THEN BEGIN
                SplittingHeaderRecNo += 1;
                REPEAT  // here loop through ServiceSplittingHeader-s
                  SplittingHeaderRecNo += 1;
                  GetApplicationForAllocEntry(ServAllocEntrySrcTmp."Entry No.", ServAllocAppOfEntryTmp);  // repair content of that record for any reason
                  IF ServAllocAppOfEntryTmp.FINDFIRST THEN BEGIN
                    NewDestAllocationEntryNo := 0;
                    REPEAT // LOOP through ServAllocAppOfEntryTmp
                      IF ServAllocAppOfEntryTmp."Document Line No." = 0 THEN BEGIN // MEAN header
                        CreateNewAllocApp(ServAllocEntrySrcTmp, ServAllocAppOfEntryTmp, ServiceSplittingHeader."Document Type",
                        ServiceSplittingHeader."New Document No.", 0, NewDestAllocationEntryNo);
                      END ELSE BEGIN // MEAN service line but not header
                        IF FindFirstForApp(ServiceSplittingLineDest, ServAllocAppOfEntryTmp,
                        ServiceSplittingHeader."Temp. Document No.") THEN BEGIN  // that should return one record
                          // prepare destination part
                          IF ServiceSplittingLineDest."Line No." > 0 THEN // MEAN RECORD IS CORRECT
                            IF ServiceSplittingLineDest.Include THEN BEGIN
                              IF ServiceLineDest.GET(ServiceSplittingLineDest."Document Type", ServiceSplittingLineDest."Document No.",
                              ServiceSplittingLineDest."Line No.") THEN
                                CreateNewAllocApp(ServAllocEntrySrcTmp, ServAllocAppOfEntryTmp, ServiceSplittingHeader."Document Type",
                                ServiceSplittingHeader."New Document No.", ServiceLineDest."Line No.", NewDestAllocationEntryNo);
                            END;
                        END;
                      END;
                    UNTIL ServAllocAppOfEntryTmp.NEXT = 0;
                  END;
                UNTIL ServiceSplittingHeader.NEXT = 0;
              END;
            END;
          UNTIL ServAllocEntrySrcTmp.NEXT = 0;
        END;
        
        
        // Find Allocation Application Entries where Allocation Entry = 0
        ServiceSplittingHeader.FINDFIRST;
        OrigDocNo := ServiceSplittingHeader."Document No.";
        OrigDocType := ServiceSplittingHeader."Document Type";
        SplittingHeaderRecNo := 0;
        IF ServiceSplittingHeader.NEXT > 0 THEN BEGIN
          SplittingHeaderRecNo += 1;
          REPEAT  // here loop through ServiceSplittingHeader-s
            SplittingHeaderRecNo += 1;
            ServiceSplittingLineNoAlloc.RESET;
            ServiceSplittingLineNoAlloc.SETRANGE("Document No.", OrigDocNo);
            ServiceSplittingLineNoAlloc.SETRANGE("Document Type", OrigDocType);
            ServiceSplittingLineNoAlloc.SETRANGE(Line, TRUE);
            ServiceSplittingLineNoAlloc.SETRANGE("New Document No.",ServiceSplittingHeader."New Document No.");
            ServiceSplittingLineNoAlloc.SETRANGE(Include, TRUE);
            IF ServiceSplittingLineNoAlloc.FINDFIRST THEN
              REPEAT
                ServAllocApplNoAlloc.RESET;
                ServAllocApplNoAlloc.SETRANGE("Allocation Entry No.",0);
                ServAllocApplNoAlloc.SETRANGE("Document No.", OrigDocNo);
                ServAllocApplNoAlloc.SETRANGE("Document Type", OrigDocType);
                ServAllocApplNoAlloc.SETRANGE("Document Line No.", ServiceSplittingLineNoAlloc."Line No.");
                IF ServAllocApplNoAlloc.FINDFIRST THEN
                  REPEAT
                    ServAllocApplNoAllocToModify.INIT;
                    ServAllocApplNoAllocToModify.TRANSFERFIELDS(ServAllocApplNoAlloc);
                    ServAllocApplNoAllocToModify."Document No." := ServiceSplittingLineNoAlloc."New Document No.";
                    ServAllocApplNoAllocToModify."Document Line No." := ServiceSplittingLineNoAlloc."Line No.";
                    ServAllocApplNoAllocToModify.INSERT;
                  UNTIL ServAllocApplNoAlloc.NEXT = 0;
              UNTIL ServiceSplittingLineNoAlloc.NEXT = 0;
          UNTIL ServiceSplittingHeader.NEXT = 0;
        END;
        
        
        // modify values of lines - for original document
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE(Line, TRUE);
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.SETRANGE("Temp. Document No.", FirstTempDocumentNo);
        IF ServiceSplittingLine.FINDFIRST THEN
          REPEAT
            IF NOT ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                                   ServiceSplittingLine."Line No.") THEN
              ERROR(Text0004, ServiceLine.TABLECAPTION, FORMAT(ServiceSplittingLine."Document Type") + ', ' +
                    ServiceSplittingLine."Document No." + ', ' + FORMAT(ServiceSplittingLine."Line No."));
        
            // IF ServiceSplittingLine."New Quantity" = 0 THEN BEGIN                                            // 06.05.2014 Elva Baltic P21
            IF NOT ServiceSplittingLine.Include THEN BEGIN                                                      // 06.05.2014 Elva Baltic P21
              IF (ServiceSplittingLine.Type = ServiceSplittingLine.Type::Item) AND TransferExist THEN BEGIN     // 06.05.2014 Elva Baltic P21
                // Finding Old Transfer Line
                IF ServiceTransferMgt.FindTransferLine(ServiceLine, OldTransfLine) THEN BEGIN
                  // Finding New Transfer Line
                  ServiceLine2.RESET;
                  ServiceLine2.SETRANGE("Document Type", ServiceSplittingLine."Document Type");
                  ServiceLine2.SETFILTER("Document No.", DocNoFilterString2);
                  ServiceLine2.SETRANGE("Line No.", ServiceSplittingLine."Line No.");
                  IF ServiceLine2.FINDFIRST THEN BEGIN
                    IF ServiceTransferMgt.FindTransferLine(ServiceLine2, NewTransfLine) THEN
                      // Transfering Old Transfer Line reservation to New Transfer Line reservation
                      TransferLineReserve.TransferTransferToTransfer(OldTransfLine, NewTransfLine, ServiceLine2.Quantity,
                                                                     0, TrackingSpec);
                  END;
                END;
                // Delete Transfer Lines from Original Transfer Order
                ServiceTransferMgt.DeleteTransferLine(ServiceLine);
              END;
              ServiceLine.DELETE(TRUE);
            END;
            // 04.04.2014 Elva Baltic P21 >>
            /*
            ELSE BEGIN
              ServiceLine.VALIDATE(Quantity, ServiceSplittingLine."New Quantity");
              ServiceLine.MODIFY;
            END;
            */
            // 04.04.2014 Elva Baltic P21 <<
          UNTIL ServiceSplittingLine.NEXT = 0;
        
        /*
        // adjust reservations
        IF ServiceSplittingLine.FINDFIRST THEN BEGIN
          ServiceLine.RESET;
          ServiceLine.SETRANGE("Document Type", ServiceSplittingLine."Document Type");
          ServiceLine.SETFILTER("Document No.", DocNoFilterString);
          ServiceLine.SETRANGE(Type, ServiceSplittingLine.Type::Item);
          IF ServiceLine.FINDFIRST THEN BEGIN
            REPEAT
              IF ServiceLine."Document No." <> ServiceSplittingLine."Document No." THEN
              // do not proceed line of original document
                IF ServiceLine.Reserve <> ServiceLine.Reserve::Never THEN  //02.07.2013 EDMS P8
                  ServiceLine.AutoReserve;
            UNTIL ServiceLine.NEXT = 0;
          END;
        END;
        */
        // 21.03.2014 Elva Baltic P21 <<
        
        
        MESSAGE(Text101, ServiceHeader2.FIELDCAPTION("No."), MessageText);
        DeleteDocSplit;

    end;

    [Scope('Internal')]
    procedure CalcShareToAdjustQty(var ServAllocAppPar: Record "25006277";var ServiceSplittingLine: Record "25006128";var ServiceLine: Record "25006146") ShareToAdjustQty: Decimal
    var
        MainLineQtyShare: Decimal;
        ServLaborAllocationEntry: Record "25006271";
        QtyTotalOfApp: Decimal;
        MainAllocQty: Decimal;
        MainLineQty: Decimal;
    begin
        // it supposed to be ServAllocAppPar - temporary
        QtyTotalOfApp := 0;
        ShareToAdjustQty := 1;
        WITH ServAllocAppPar DO BEGIN
          FINDFIRST;
          MainLineQtyShare := ServiceSplittingLine."Quantity Share %";
          ServLaborAllocationEntry.GET("Allocation Entry No.");
          MainAllocQty := ServLaborAllocationEntry."Quantity (Hours)";
          IF ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
              "Document Line No.") THEN
            MainLineQty := ServiceLine.GetTimeQty;
          IF COUNT > 1 THEN BEGIN
            REPEAT
              IF ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                  "Document Line No.") THEN
                QtyTotalOfApp += ServiceLine.GetTimeQty;
            UNTIL NEXT = 0;
            ShareToAdjustQty := (MainAllocQty - (MainLineQty*MainAllocQty/QtyTotalOfApp)*
              (100 - MainLineQtyShare)/100) / MainAllocQty;
          END;
        END;
        //return value not in percents, but simple decimal
        EXIT(ShareToAdjustQty*100);
    end;

    [Scope('Internal')]
    procedure FindAllocationsOfLabor(DocType: Integer;DocNo: Code[20];LineNo: Integer;var ServAllocEntryTmp: Record "25006271" temporary;var ServAllocAppTmp: Record "25006277" temporary;TimeLine: Integer;ParamStr: Text[30])
    var
        ServiceAllocEntry: Record "25006271";
        ServLaborAllocApp: Record "25006277";
        doAvoidSplitEntries: Boolean;
    begin
        // ParamStr: first char is digit-flag, doAvoidSplitEntries("Applies-to Entry No.")
        ServAllocEntryTmp.RESET;
        ServAllocEntryTmp.DELETEALL;
        ServAllocAppTmp.RESET;
        ServAllocAppTmp.DELETEALL;
        IF STRLEN(ParamStr)>0 THEN
          EVALUATE(doAvoidSplitEntries, COPYSTR(ParamStr,1,1));


        ServLaborAllocApp.RESET;
        ServLaborAllocApp.SETRANGE("Document Type", DocType);
        ServLaborAllocApp.SETRANGE("Document No.", DocNo);
        ServLaborAllocApp.SETRANGE("Document Line No.", LineNo);
        IF LineNo < 0 THEN
          ServLaborAllocApp.SETRANGE("Document Line No.");
        IF TimeLine = 2 THEN
          ServLaborAllocApp.SETRANGE("Time Line")
        ELSE IF TimeLine = 1 THEN
          ServLaborAllocApp.SETRANGE("Time Line", TRUE)
        ELSE
          ServLaborAllocApp.SETRANGE("Time Line", FALSE);
        IF ServLaborAllocApp.FINDFIRST THEN BEGIN
          REPEAT
            IF ServiceAllocEntry.GET(ServLaborAllocApp."Allocation Entry No.") THEN BEGIN
              IF (doAvoidSplitEntries AND (ServiceAllocEntry."Applies-to Entry No."=0)) OR
                  (NOT doAvoidSplitEntries) THEN BEGIN
                IF NOT ServAllocEntryTmp.GET(ServLaborAllocApp."Allocation Entry No.") THEN BEGIN
                  ServAllocEntryTmp := ServiceAllocEntry;
                  ServAllocEntryTmp.INSERT;
                END;
                ServAllocAppTmp := ServLaborAllocApp;
                ServAllocAppTmp.INSERT;
              END;
            END;
          UNTIL ServLaborAllocApp.NEXT = 0;
        END
    end;

    [Scope('Internal')]
    procedure DeleteDocSplit()
    var
        ServiceHeader: Record "25006145";
        ServiceHeader2: Record "25006145";
        ServiceLine: Record "25006146";
        ServiceLine2: Record "25006146";
        FirstTempDocumentNo: Integer;
        LastTempDocumentNo: Integer;
    begin
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE(Line, FALSE);
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.DELETEALL(TRUE);
    end;

    local procedure GetHeader()
    begin
        TESTFIELD("Document No.");
        IF ServiceSplittingHeader.Line OR ("Document Type" <> ServiceSplittingHeader."Document Type") OR
            ("Temp. Document No." <> ServiceSplittingHeader."Temp. Document No.") THEN BEGIN
          ServiceSplittingHeader.SETRANGE(Line, FALSE);
          ServiceSplittingHeader.SETRANGE("Document Type", "Document Type");
          ServiceSplittingHeader.SETRANGE("Temp. Document No.", "Temp. Document No.");
          IF ServiceSplittingHeader.FINDFIRST THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            IF ServiceSplittingHeader."Currency Code" = '' THEN
              Currency.InitRoundingPrecision
            ELSE BEGIN
              //ServiceSplittingHeader.TESTFIELD("Currency Factor");
              Currency.GET(ServiceSplittingHeader."Currency Code");
              Currency.TESTFIELD("Amount Rounding Precision");
            END;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure GetSourceTempDocNo(): Integer
    var
        ServiceSplittingLine: Record "25006128";
    begin
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.SETRANGE(Line, FALSE);
        ServiceSplittingLine.FINDFIRST;
        EXIT(ServiceSplittingLine."Temp. Document No.");
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        IF NOT (("Document Type" = "Document Type"::Quote) AND (CustNo = '')) THEN BEGIN
          IF CustNo <> Cust."No." THEN
            Cust.GET(CustNo);
        END ELSE
          CLEAR(Cust);
    end;

    [Scope('Internal')]
    procedure GetApplicationForAllocEntry(EntryNo: Integer;var ServAllocAppOfEntryTmp: Record "25006277")
    var
        ServAllocApp: Record "25006277";
    begin
        ServAllocAppOfEntryTmp.RESET;
        ServAllocAppOfEntryTmp.DELETEALL;
        ServAllocApp.RESET;
        ServAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
        IF ServAllocApp.FINDFIRST THEN
        REPEAT
          ServAllocAppOfEntryTmp := ServAllocApp;
          ServAllocAppOfEntryTmp.INSERT
        UNTIL ServAllocApp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetQtyShareOfLineInAlloc(var ServAllocApp: Record "25006277";var ServiceLine: Record "25006146";DocType: Integer;DocNo: Code[20];LineNo: Integer) ShareOfLine: Decimal
    var
        QtyTotalOfApp: Decimal;
        MainAllocQty: Decimal;
        MainLineQty: Decimal;
        QtyOfApp: Integer;
        ServiceLineFilt: Record "25006146";
        ServAllocAppFilt: Record "25006277";
        ServiceLinePosit: Text[250];
        ServAllocAppPosit: Text[250];
    begin
        ServiceLinePosit := ServiceLine.GETPOSITION;
        ServiceLineFilt.COPYFILTERS(ServiceLine);
        ServAllocAppPosit := ServAllocApp.GETPOSITION;
        ServAllocAppFilt.COPYFILTERS(ServAllocApp);

        QtyTotalOfApp := 0;
        ShareOfLine := 1;
        IF ServAllocApp.FINDFIRST THEN BEGIN
          ServiceLine.GET(DocType, DocNo, LineNo);
          MainLineQty := ServiceLine.GetTimeQty;
          REPEAT
            IF ServiceLine.GET(DocType, DocNo, ServAllocApp."Document Line No.") THEN
              QtyTotalOfApp += ServiceLine.GetTimeQty;
            QtyOfApp += 1;
          UNTIL ServAllocApp.NEXT = 0;
          ShareOfLine := MainLineQty/QtyTotalOfApp;
        END;
        ServiceLine.COPYFILTERS(ServiceLineFilt);
        ServiceLine.SETPOSITION(ServiceLinePosit);
        ServAllocApp.COPYFILTERS(ServAllocAppFilt);
        ServAllocApp.SETPOSITION(ServAllocAppPosit);
        EXIT(ShareOfLine*100);
    end;

    [Scope('Internal')]
    procedure GetAdjustedQtyShare(var ServiceSplittingLine: Record "25006128";var ServiceLine: Record "25006146";var ServAllocApp: Record "25006277";var ServAllocEntry: Record "25006271";DocType: Integer;DocNo: Code[20];LineNo: Integer;EntryNo: Integer;TempDocNo: Integer) RetValue: Decimal
    var
        ServiceSplittingLineFilt: Record "25006128";
        ServiceLineFilt: Record "25006146";
        ServAllocAppFilt: Record "25006277";
        ServAllocEntryFilt: Record "25006271";
        ServiceSplittingLinePosit: Text[250];
        ServiceLinePosit: Text[250];
        ServAllocAppPosit: Text[250];
        ServAllocEntryPosit: Text[250];
        AllocationQty: Decimal;
        ShareQtyTotal: Decimal;
        ResultQty: Decimal;
        LinesTotalQty: Decimal;
    begin
        //return percentage
        ServiceSplittingLinePosit := ServiceSplittingLine.GETPOSITION;
        ServiceSplittingLineFilt.COPYFILTERS(ServiceSplittingLine);
        ServiceLinePosit := ServiceLine.GETPOSITION;
        ServiceLineFilt.COPYFILTERS(ServiceLine);
        ServAllocAppPosit := ServAllocApp.GETPOSITION;
        ServAllocAppFilt.COPYFILTERS(ServAllocApp);
        ServAllocEntryPosit := ServAllocEntry.GETPOSITION;
        ServAllocEntryFilt.COPYFILTERS(ServAllocEntry);


        ServAllocEntry.GET(EntryNo);
        AllocationQty := ServAllocEntry."Quantity (Hours)";
        ServAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
        ServAllocApp.FINDFIRST;
        REPEAT

          ServiceSplittingLine.SETRANGE("Document Type", DocType);
          ServiceSplittingLine.SETRANGE("Document No.", DocNo);
          ServiceSplittingLine.SETRANGE("Temp. Document No.", TempDocNo);
          IF ServAllocApp."Document Line No." > 0 THEN BEGIN
            ServiceSplittingLine.SETRANGE(Line, TRUE);
            ServiceSplittingLine.SETRANGE("Line No.", ServAllocApp."Document Line No.");
            ServiceLine.GET(DocType, DocNo, ServAllocApp."Document Line No.");
            ServiceSplittingLine.FINDFIRST;
            LinesTotalQty += ServiceLine.GetTimeQty;
            ShareQtyTotal += ServiceLine.GetTimeQty *ServiceSplittingLine."Quantity Share %"/100;
          END ELSE BEGIN
            ServiceSplittingLine.SETRANGE(Line, FALSE);
            ServiceSplittingLine.SETRANGE("Line No.");
            ServiceSplittingLine.FINDFIRST;
            LinesTotalQty := AllocationQty;
            ShareQtyTotal := AllocationQty*ServiceSplittingLine."Quantity Share %"/100;
          END;
        UNTIL ServAllocApp.NEXT = 0;
        IF LinesTotalQty = 0 THEN
          ResultQty := AllocationQty
        ELSE
          ResultQty := (AllocationQty/LinesTotalQty) * ShareQtyTotal;

        IF AllocationQty <> 0 THEN                                          // 06.05.2014 Elva Baltic P21
          RetValue := ResultQty/AllocationQty*100
        ELSE                                                                // 06.05.2014 Elva Baltic P21
          RetValue := 0;                                                    // 06.05.2014 Elva Baltic P21

        ServiceSplittingLine.COPYFILTERS(ServiceSplittingLineFilt);
        ServiceSplittingLine.SETPOSITION(ServiceSplittingLinePosit);
        ServiceLine.COPYFILTERS(ServiceLineFilt);
        ServiceLine.SETPOSITION(ServiceLinePosit);
        ServAllocApp.COPYFILTERS(ServAllocAppFilt);
        ServAllocApp.SETPOSITION(ServAllocAppPosit);
        ServAllocEntry.COPYFILTERS(ServAllocEntryFilt);
        ServAllocEntry.SETPOSITION(ServAllocEntryPosit);
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure UpdateLines(ChangedFieldName: Text[100];AskQuestion: Boolean)
    var
        ChangeLogMgt: Codeunit "423";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        Question: Text[250];
    begin
        IF Line THEN EXIT;
        IF NOT (ChangedFieldName IN
          [FIELDCAPTION("Sell-to Customer No."),
          FIELDCAPTION("Location Code"),
          FIELDCAPTION("Bill-to Customer No."),
          FIELDCAPTION("Currency Code"),
          FIELDCAPTION("Quantity Share %")]) THEN
            EXIT;

        IF AskQuestion THEN BEGIN
          Question := STRSUBSTNO(
              Text031 +
              Text032,ChangedFieldName);
          IF GUIALLOWED THEN
            IF NOT DIALOG.CONFIRM(Question,TRUE) THEN
              EXIT;
        END;

        ServiceSplittingLine.LOCKTABLE;
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE(Line, TRUE);
        ServiceSplittingLine.SETRANGE("Document Type","Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
        IF ServiceSplittingLine.FINDSET THEN
          REPEAT
            CASE ChangedFieldName OF
              FIELDCAPTION("Sell-to Customer No."):
                ServiceSplittingLine.VALIDATE("Sell-to Customer No.", "Sell-to Customer No.");
              FIELDCAPTION("Location Code"):
                ServiceSplittingLine.VALIDATE("Location Code", "Location Code");
              FIELDCAPTION("Bill-to Customer No."):
                ServiceSplittingLine.VALIDATE("Bill-to Customer No.", "Bill-to Customer No.");
              FIELDCAPTION("Currency Code"):
                ServiceSplittingLine.VALIDATE("Currency Code", "Currency Code");
              FIELDCAPTION("Quantity Share %"):
                ServiceSplittingLine.VALIDATE("Quantity Share %", "Quantity Share %");
            END;
            ServiceSplittingLine.MODIFY(TRUE);
          UNTIL ServiceSplittingLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateSplitingForDoc(var ServiceHeaderPar: Record "25006145")
    begin
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE(Line, FALSE);
        ServiceSplittingLine.SETRANGE("Document Type", ServiceHeaderPar."Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", ServiceHeaderPar."No.");
        IF NOT ServiceSplittingLine.FINDFIRST THEN
          ApplyInsertAsHeaderByServDoc(ServiceHeaderPar."Document Type", ServiceHeaderPar."No.");
        IF ServiceSplittingLine.COUNT < 2 THEN BEGIN
          ApplyInsertAsHeaderByServDoc(ServiceHeaderPar."Document Type", ServiceHeaderPar."No.");
          DocsShareMakeFirstFull;
        END;
        IF ServiceSplittingLine.FINDFIRST THEN BEGIN
          GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
            ServiceSplittingLine."Temp. Document No.", ServiceSplittingLine.Line, ServiceSplittingLine."Temp. Line No.");
        END;
    end;

    [Scope('Internal')]
    procedure CreateSpliting()
    var
        ServiceHeader: Record "25006145";
    begin
        EVALUATE("Document Type", GETFILTER("Document Type"));
        "Document No." := GETFILTER("Document No.");
        ServiceHeader.GET("Document Type", "Document No.");
        CreateSplitingForDoc(ServiceHeader);
    end;

    [Scope('Internal')]
    procedure DocsShareMakeEqual()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        WITH ServiceSplittingLine DO BEGIN
          IF FINDFIRST THEN BEGIN
            RecCount := COUNT;
            TotalUsedPercent := 0;
            REPEAT
              VALIDATE("Quantity Share %", ROUND(100/RecCount, 0.01));
              MODIFY;
              TotalUsedPercent += "Quantity Share %";
            UNTIL NEXT = 0;
            IF TotalUsedPercent <> 100 THEN BEGIN
              FINDLAST;
              VALIDATE("Quantity Share %", "Quantity Share %" + (100 - TotalUsedPercent));
              MODIFY;
            END;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure DocsShareMakeFirstFull()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        WITH ServiceSplittingLine DO BEGIN
          IF FINDFIRST THEN BEGIN
            RecCount := COUNT;
            VALIDATE("Quantity Share %", 100);
            MODIFY;
            IF NEXT <> 0 THEN
              REPEAT
                VALIDATE("Quantity Share %", 0);
                MODIFY;
              UNTIL NEXT = 0;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure OpenFormForServDoc(var ServiceHeaderPar: Record "25006145")
    var
        FormRunResult: Action;
    begin
        SETRANGE(Line, FALSE);
        SETRANGE("Document Type", ServiceHeaderPar."Document Type");
        SETRANGE("Document No.", ServiceHeaderPar."No.");
        PAGE.RUN(PAGE::"Service Splitting", Rec);
        //FormRunResult := PAGE.RUNMODAL(PAGE::"Service Splitting", Rec);
        SETRANGE(Line, FALSE);
        SETRANGE("Document Type", ServiceHeaderPar."Document Type");
        SETRANGE("Document No.", ServiceHeaderPar."No.");

        //IF FINDFIRST THEN
          //IF FormRunResult IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            //ProceedDocSplit;
        //  END ELSE
          //  IF CONFIRM(Text103, TRUE) THEN BEGIN
            //  DeleteDocSplit;
            //END;
    end;

    [Scope('Internal')]
    procedure CheckDocTotalAmount(var SourceDocAmount: Decimal;var DestDocAmount: Decimal) AmountDiff: Decimal
    var
        ServiceHeaderTmp: Record "25006145" temporary;
        ServiceLineTmp: Record "25006146" temporary;
        ServiceLine: Record "25006146";
        CurrLineNo: Integer;
        LinesCount: Integer;
    begin
        SourceDocAmount := 0;
        IF ServiceHdr.GET("Document Type", "Document No.") THEN BEGIN
          ServiceHdr.CALCFIELDS(Amount);
          IF ServiceHdr."Currency Factor" = 0 THEN
            ServiceHdr."Currency Factor" := 1;
        //  SourceDocAmount := ROUND(ServiceHdr.Amount/ServiceHdr."Currency Factor");
          WITH ServiceLine DO BEGIN
            RESET;
            SETRANGE("Document Type", ServiceHdr."Document Type");
            SETRANGE("Document No.", ServiceHdr."No.");
            IF FINDFIRST THEN
              REPEAT
                SourceDocAmount += ROUND(ServiceLine."Line Amount"/ServiceHdr."Currency Factor");
              UNTIL NEXT = 0;
          END;

          WITH ServiceHeaderTmp DO BEGIN
            RESET;
            DELETEALL;
            ServiceHeaderTmp := ServiceHdr;
            INSERT;
          END;
          WITH ServiceLineTmp DO BEGIN
            RESET;
            DELETEALL;
          END;

          ServiceSplittingHeader.RESET;
          ServiceSplittingHeader.SETRANGE(Line, FALSE);
          ServiceSplittingHeader.SETRANGE("Document Type", "Document Type");
          ServiceSplittingHeader.SETRANGE("Document No.", "Document No.");
          ServiceSplittingLine.RESET;
          ServiceSplittingLine.SETRANGE(Line, TRUE);
          ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
          ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
          IF NOT ServiceSplittingLine.FINDFIRST THEN
            ERROR(Text0003);
          LinesCount := ServiceSplittingLine.COUNT;
          DestDocAmount := 0;
          CurrLineNo := 0;
          REPEAT
            IF NOT ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
                  ServiceSplittingLine."Line No.") THEN
                ERROR(Text0004, ServiceLine.TABLECAPTION, FORMAT(ServiceSplittingLine."Document Type") + ', ' +
                  ServiceSplittingLine."Document No." + ', ' + FORMAT(ServiceSplittingLine."Line No."));

            ServiceSplittingHeader.SETRANGE("Temp. Document No.", ServiceSplittingLine."Temp. Document No.");
            ServiceSplittingHeader.FINDFIRST;

            ServiceLineTmp.INIT;
            ServiceLineTmp.TRANSFERFIELDS(ServiceLine, FALSE);
            ServiceLineTmp."Document Type" := ServiceSplittingHeader."Document Type";
            ServiceLineTmp."Document No." := ServiceSplittingHeader."Document No.";
            CurrLineNo += 10000;
            ServiceLineTmp."Line No." := CurrLineNo;
            ServiceLineTmp."Sell-to Customer No." := ServiceSplittingHeader."Sell-to Customer No.";
            ServiceLineTmp."Bill-to Customer No." := ServiceSplittingHeader."Bill-to Customer No.";
            ServiceLineTmp."Currency Code" := ServiceSplittingHeader."Currency Code";
            ServiceLineTmp.VALIDATE("No.", ServiceSplittingLine."No.");
            ServiceLineTmp.VALIDATE("Location Code", ServiceSplittingLine."Location Code");
            ServiceLineTmp.VALIDATE(Quantity, ServiceSplittingLine."New Quantity");
            ServiceLineTmp.VALIDATE("Unit Price", ServiceSplittingLine."Unit Price");
            ServiceLineTmp.INSERT(TRUE);
        //    ServiceLineTmp.MODIFY(TRUE);

            ServiceHeaderTmp.VALIDATE("Currency Code", ServiceSplittingHeader."Currency Code");
            IF ServiceHeaderTmp."Currency Factor" = 0 THEN
              ServiceHeaderTmp."Currency Factor" := 1;

            DestDocAmount += ROUND(ServiceLineTmp."Line Amount"/ServiceHeaderTmp."Currency Factor");
          UNTIL ServiceSplittingLine.NEXT = 0;
          AmountDiff := SourceDocAmount - DestDocAmount;
        END ELSE
          ERROR(Text0004, ServiceHdr.TABLECAPTION, FORMAT("Document Type") + ', ' + "Document No.");
        EXIT(AmountDiff);
    end;

    [Scope('Internal')]
    procedure FindFirstForApp(var ServiceSplittingLinePar: Record "25006128";ServLaborAllocApplicationPar: Record "25006277";TempDocNo: Integer): Boolean
    begin
        ServiceSplittingLinePar.SETRANGE("Document Type", ServLaborAllocApplicationPar."Document Type");
        ServiceSplittingLinePar.SETRANGE("Document No.", ServLaborAllocApplicationPar."Document No.");
        ServiceSplittingLinePar.SETRANGE("Temp. Document No.", TempDocNo);
        IF ServLaborAllocApplicationPar."Document Line No." > 0 THEN BEGIN
          ServiceSplittingLinePar.SETRANGE(Line, TRUE);
          ServiceSplittingLinePar.SETRANGE("Line No.", ServLaborAllocApplicationPar."Document Line No.");
        END ELSE BEGIN
          ServiceSplittingLinePar.SETRANGE(Line, FALSE);
          ServiceSplittingLinePar.SETRANGE("Line No.");
        END;
        EXIT(ServiceSplittingLinePar.FINDFIRST);
    end;

    [Scope('Internal')]
    procedure CopyFldsServL2SplitLine(ServiceLinePar: Record "25006146";var ServiceSplittingLinePar: Record "25006128"): Integer
    begin
        WITH ServiceLinePar DO BEGIN
          ServiceSplittingLinePar."Document Type" := "Document Type";
          ServiceSplittingLinePar."Document No." := "Document No.";
          ServiceSplittingLinePar."Sell-to Customer No." := "Sell-to Customer No.";
          ServiceSplittingLinePar."Line No." := "Line No.";
          ServiceSplittingLinePar.Type := Type;
          ServiceSplittingLinePar."No." := "No.";
          ServiceSplittingLinePar."Location Code" := "Location Code";
          ServiceSplittingLinePar.Description := Description;
          ServiceSplittingLinePar."Description 2" := "Description 2";
          ServiceSplittingLinePar."Unit of Measure" := "Unit of Measure";
          ServiceSplittingLinePar.Quantity := Quantity;
          ServiceSplittingLinePar."Outstanding Quantity" := "Outstanding Quantity";
          ServiceSplittingLinePar."Unit Price" := "Unit Price";
          ServiceSplittingLinePar."Unit Cost (LCY)" := "Unit Cost (LCY)";
          ServiceSplittingLinePar."VAT %" := "VAT %";
          ServiceSplittingLinePar."Line Discount %" := "Line Discount %";
          ServiceSplittingLinePar."Line Discount Amount" := "Line Discount Amount";
          ServiceSplittingLinePar.Amount := Amount;
          ServiceSplittingLinePar."Amount Including VAT" := "Amount Including VAT";
          ServiceSplittingLinePar."Allow Invoice Disc." := "Allow Invoice Disc.";
          ServiceSplittingLinePar."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          ServiceSplittingLinePar."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          ServiceSplittingLinePar."Bill-to Customer No." := "Bill-to Customer No.";
          ServiceSplittingLinePar."Inv. Discount Amount" := "Inv. Discount Amount";
          ServiceSplittingLinePar."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          ServiceSplittingLinePar."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          ServiceSplittingLinePar."VAT Calculation Type" := "VAT Calculation Type";
          ServiceSplittingLinePar."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
          ServiceSplittingLinePar."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
          ServiceSplittingLinePar."Currency Code" := "Currency Code";
          ServiceSplittingLinePar.Reserve := Reserve;
          ServiceSplittingLinePar."VAT Base Amount" := "VAT Base Amount";
          ServiceSplittingLinePar."Unit Cost" := "Unit Cost";
          ServiceSplittingLinePar."System-Created Entry" := "System-Created Entry";
          ServiceSplittingLinePar."Line Amount" := "Line Amount";
          ServiceSplittingLinePar."VAT Difference" := "VAT Difference";
          ServiceSplittingLinePar."Inv. Disc. Amount to Invoice" := "Inv. Disc. Amount to Invoice";
          ServiceSplittingLinePar."VAT Identifier" := "VAT Identifier";
          ServiceSplittingLinePar."Prepayment %" := "Prepayment %";
          ServiceSplittingLinePar."Prepmt. Line Amount" := "Prepmt. Line Amount";
          ServiceSplittingLinePar."Prepmt. Amt. Inv." := "Prepmt. Amt. Inv.";
          ServiceSplittingLinePar."Prepmt. Amt. Incl. VAT" := "Prepmt. Amt. Incl. VAT";
          ServiceSplittingLinePar."Prepayment Amount" := "Prepayment Amount";
          ServiceSplittingLinePar."Prepmt. VAT Base Amt." := "Prepmt. VAT Base Amt.";
          ServiceSplittingLinePar."Prepayment VAT %" := "Prepayment VAT %";
          ServiceSplittingLinePar."Prepmt. VAT Calc. Type" := "Prepmt. VAT Calc. Type";
          ServiceSplittingLinePar."Prepayment VAT Identifier" := "Prepayment VAT Identifier";
          ServiceSplittingLinePar."Prepayment Tax Area Code" := "Prepayment Tax Area Code";
          ServiceSplittingLinePar."Prepayment Tax Liable" := "Prepayment Tax Liable";
          ServiceSplittingLinePar."Prepayment Tax Group Code" := "Prepayment Tax Group Code";
          ServiceSplittingLinePar."Prepmt Amt to Deduct" := "Prepmt Amt to Deduct";
          ServiceSplittingLinePar."Prepmt Amt Deducted" := "Prepmt Amt Deducted";
          ServiceSplittingLinePar."Prepayment Line" := "Prepayment Line";
          ServiceSplittingLinePar."Prepmt. Amount Inv. Incl. VAT" := "Prepayment Amount Incl. VAT";
          ServiceSplittingLinePar."Variant Code" := "Variant Code";
          ServiceSplittingLinePar."Bin Code" := "Bin Code";
          ServiceSplittingLinePar."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          ServiceSplittingLinePar.Planned := Planned;
          ServiceSplittingLinePar."Unit of Measure Code" := "Unit of Measure Code";
          ServiceSplittingLinePar."Quantity (Base)" := "Quantity (Base)";
          ServiceSplittingLinePar."Outstanding Qty. (Base)" := "Outstanding Qty. (Base)";
          ServiceSplittingLinePar."Responsibility Center" := "Responsibility Center";
          ServiceSplittingLinePar."Unit of Measure (Cross Ref.)" := "Unit of Measure (Cross Ref.)";
          ServiceSplittingLinePar."Item Category Code" := "Item Category Code";
          ServiceSplittingLinePar.Nonstock := Nonstock;
          ServiceSplittingLinePar."Product Group Code" := "Product Group Code";
          ServiceSplittingLinePar."Requested Delivery Date" := "Requested Delivery Date";
          ServiceSplittingLinePar."Promised Delivery Date" := "Promised Delivery Date";
          ServiceSplittingLinePar."Qty. to Consume" := "Qty. to Consume";
          ServiceSplittingLinePar."Quantity Consumed" := "Quantity Consumed";
          ServiceSplittingLinePar."Qty. to Consume (Base)" := "Qty. to Consume (Base)";
          ServiceSplittingLinePar."Qty. Consumed (Base)" := "Qty. Consumed (Base)";
          ServiceSplittingLinePar."Allow Line Disc." := "Allow Line Disc.";
          ServiceSplittingLinePar."Customer Disc. Group" := "Customer Disc. Group";
          ServiceSplittingLinePar."External No." := "External No.";
          ServiceSplittingLinePar."Planned Service Date" := "Planned Service Date";
          ServiceSplittingLinePar."Deal Type Code" := "Deal Type Code";
          ServiceSplittingLinePar."Product Subgroup Code" := "Product Subgroup Code";
          ServiceSplittingLinePar.Prepayment := Prepayment;
          ServiceSplittingLinePar."Campaign No." := "Campaign No.";
          ServiceSplittingLinePar."External Serv. Tracking No." := "External Serv. Tracking No.";
          ServiceSplittingLinePar."Standard Time" := "Standard Time";
          ServiceSplittingLinePar."Standard Time Line No." := "Standard Time Line No.";
          ServiceSplittingLinePar."Vehicle Registration No." := "Vehicle Registration No.";
          ServiceSplittingLinePar."Model Code" := "Model Code";
          ServiceSplittingLinePar."Package No." := "Package No.";
          ServiceSplittingLinePar."Make Code" := "Make Code";
          ServiceSplittingLinePar."Service Work Shift Code" := "Service Work Shift Code";
          ServiceSplittingLinePar."Package Version No." := "Package Version No.";
          ServiceSplittingLinePar."Package Version Spec. Line No." := "Package Version Spec. Line No.";
          ServiceSplittingLinePar.VIN := VIN;
          ServiceSplittingLinePar."Vehicle Accounting Cycle No." := "Vehicle Accounting Cycle No.";
          ServiceSplittingLinePar."Sell-to Customer Bill %" := "Sell-to Customer Bill %";
          ServiceSplittingLinePar."Sell-to Customer Bill Amount" := "Sell-to Customer Bill Amount";
          ServiceSplittingLinePar."Ordering Price Type Code" := "Ordering Price Type Code";
          ServiceSplittingLinePar."DMS Variable Field 25006800" := "DMS Variable Field 25006800";
          ServiceSplittingLinePar."DMS Variable Field 25006801" := "DMS Variable Field 25006801";
          ServiceSplittingLinePar."DMS Variable Field 25006802" := "DMS Variable Field 25006802";
          ServiceSplittingLinePar."Contract No." := "Contract No.";
          ServiceSplittingLinePar."Job No." := "Job No.";
          ServiceSplittingLinePar.Split := Split;
          ServiceSplittingLinePar.Status := Status;
          ServiceSplittingLinePar."BOM Item No." := "BOM Item No.";
          ServiceSplittingLinePar."Sell-to Customer Name" := "Sell-to Customer Name";
          ServiceSplittingLinePar."Bill-to Name" := "Bill-to Name";
        END;
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure CopyFldsServH2SplitLine(ServiceHeaderPar: Record "25006145";var ServiceSplittingLinePar: Record "25006128"): Integer
    begin
        WITH ServiceHeaderPar DO BEGIN
          ServiceSplittingLinePar.INIT;
          ServiceSplittingLinePar."Document Type" := "Document Type";
          ServiceSplittingLinePar."Document No." := "No.";
          ServiceSplittingLinePar."Sell-to Customer No." := "Sell-to Customer No.";
          ServiceSplittingLinePar."Line No." := 0;
          ServiceSplittingLinePar.Type := 0;
          ServiceSplittingLinePar."No." := '';
          ServiceSplittingLinePar."Location Code" := "Location Code";
          ServiceSplittingLinePar.Description := Description;
          ServiceSplittingLinePar.Amount := Amount;
          ServiceSplittingLinePar."Amount Including VAT" := "Amount Including VAT";
          ServiceSplittingLinePar."Allow Invoice Disc." := "Allow Line Disc.";
          ServiceSplittingLinePar."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
          ServiceSplittingLinePar."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
          ServiceSplittingLinePar."Bill-to Customer No." := "Bill-to Customer No.";
          ServiceSplittingLinePar."Inv. Discount Amount" := "Invoice Discount Value";
          ServiceSplittingLinePar."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          ServiceSplittingLinePar."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          ServiceSplittingLinePar."Currency Code" := "Currency Code";
          ServiceSplittingLinePar."Prepayment %" := "Prepayment %";
          ServiceSplittingLinePar."Responsibility Center" := "Responsibility Center";
          ServiceSplittingLinePar."Customer Disc. Group" := "Customer Disc. Group";
          ServiceSplittingLinePar."External No." := "External Document No.";
          ServiceSplittingLinePar."Planned Service Date" := "Planned Service Date";
          ServiceSplittingLinePar."Deal Type Code" := "Deal Type";
          ServiceSplittingLinePar."Campaign No." := "Campaign No.";
          ServiceSplittingLinePar."External Serv. Tracking No." := "External Serv. Tracking No.";
          ServiceSplittingLinePar."Vehicle Registration No." := "Vehicle Registration No.";
          ServiceSplittingLinePar."Model Code" := "Model Code";
          ServiceSplittingLinePar."Make Code" := "Make Code";
          ServiceSplittingLinePar.VIN := VIN;
          ServiceSplittingLinePar."Vehicle Accounting Cycle No." := "Vehicle Accounting Cycle No.";
          ServiceSplittingLinePar.Split := Split;
          ServiceSplittingLinePar."Sell-to Customer Name" := "Sell-to Customer Name";
          ServiceSplittingLinePar."Bill-to Name" := "Bill-to Name";
        END;
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure ChangeIncludeInfo(NewQty: Decimal)
    begin
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.SETRANGE("Line No.", "Line No.");
        ServiceSplittingLine.SETFILTER("Temp. Document No.", '<>%1&<>%2', "Temp. Document No.", 0);
        ServiceSplittingLine.SETRANGE(Include, Include);
        IF ServiceSplittingLine.FINDFIRST THEN BEGIN
          ServiceSplittingLine.VALIDATE("New Quantity", NewQty);
          ServiceSplittingLine.Include := NOT Include;
          ServiceSplittingLine.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure CreateLinesForQuote(ServiceHeader: Record "25006145")
    var
        ServiceLine: Record "25006146";
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceLine.FINDSET THEN
          REPEAT
            ServiceSplittingLine.INIT;
            CopyFldsServL2SplitLine(ServiceLine, ServiceSplittingLine);
            ServiceSplittingLine.Line := TRUE;
            ServiceSplittingLine."Temp. Line No." := ServiceLine."Line No.";
            ServiceSplittingLine.INSERT;
          UNTIL ServiceLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateQuote()
    var
        ServiceHeaderQ: Record "25006145";
        ServiceHeader: Record "25006145";
        NextLineNo: Integer;
        ServiceLineQ: Record "25006146";
        ServiceLine: Record "25006146";
        ServiceAllocEntry: Record "25006271";
        TransferLine: Record "5741";
    begin
        IF NOT ServiceHeader.GET("Document Type", "Document No.") THEN
          ERROR(Text0002, ServiceHeader.TABLECAPTION);

        ServiceAllocEntry.RESET;
        ServiceAllocEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID");
        ServiceAllocEntry.SETRANGE("Source Type", ServiceAllocEntry."Source Type"::"Service Document");
        ServiceAllocEntry.SETRANGE("Source Subtype", ServiceAllocEntry."Source Subtype"::Order);
        ServiceAllocEntry.SETRANGE("Source ID", "Document No.");
        ServiceAllocEntry.SETFILTER(Status, '%1|%2', ServiceAllocEntry.Status::"In Progress", ServiceAllocEntry.Status::"On Hold");
        IF ServiceAllocEntry.FINDFIRST THEN
          ERROR(Text007);

        NextLineNo := 10000;
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.SETRANGE(Line, TRUE);
        ServiceSplittingLine.SETRANGE("Create Quote", TRUE);
        IF ServiceSplittingLine.FINDSET THEN BEGIN
          ServiceHeaderQ.INIT;
          ServiceHeaderQ."Document Type" := ServiceHeaderQ."Document Type"::Quote;
          ServiceHeaderQ.INSERT(TRUE);
          ServiceHeaderQ.TRANSFERFIELDS(ServiceHeader,FALSE);
          ServiceHeaderQ.MODIFY;

          ServiceLineQ.INIT;
          ServiceLineQ."Document Type" := ServiceHeaderQ."Document Type";
          ServiceLineQ."Document No." := ServiceHeaderQ."No.";
          ServiceLineQ."Line No." := NextLineNo;
          ServiceLineQ.Description := STRSUBSTNO(Text108, ServiceHeader."No.");
          ServiceLineQ.INSERT;
          REPEAT
            IF NOT ServiceLine.GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.", ServiceSplittingLine."Temp. Line No.") THEN
              ERROR(Text0004, ServiceLine.TABLECAPTION, FORMAT(ServiceSplittingLine."Document Type") + ', ' +
                    ServiceSplittingLine."Document No." + ', ' + FORMAT(ServiceSplittingLine."Line No."));

            IF ServiceLine.Type = ServiceLine.Type::Item THEN BEGIN
              IF ServiceLine.CalcTransferedQuantity <> 0 THEN
                ERROR(Text106, ServiceLine."Line No.");

              IF ServiceTransferMgt.FindTransferLine(ServiceLine, TransferLine) THEN
                ERROR(Text110, ServiceLine."No.");
            END;

            IF ServiceLine.Type = ServiceLine.Type::Labor THEN
              IF ServiceLine.GetResourceTextFieldValue <> '' THEN
                ERROR(Text109, ServiceLine."No.");

            NextLineNo := NextLineNo + 10000;
            ServiceLineQ.INIT;
            ServiceLineQ := ServiceLine;
            ServiceLineQ."Document Type" := ServiceHeaderQ."Document Type";
            ServiceLineQ."Document No." := ServiceHeaderQ."No.";
            ServiceLineQ."Line No." := NextLineNo;
            ServiceLineQ.INSERT(TRUE);
            ServiceLine.DELETE(TRUE);
          UNTIL ServiceSplittingLine.NEXT = 0;

          MESSAGE(Text107, ServiceHeaderQ."No.");
          DeleteDocQuote(ServiceHeader."Document Type", ServiceHeader."No.");
        END ELSE
          ERROR(Text0003);
    end;

    [Scope('Internal')]
    procedure DeleteDocQuote(DocType: Option Quote,"Order","Return Order";DocNo: Code[20])
    begin
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE(Line, TRUE);
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        ServiceSplittingLine.SETRANGE("Temp. Document No.", 0);
        ServiceSplittingLine.DELETEALL;
    end;

    [Scope('Internal')]
    procedure CreateNewAllocApp(ServLaborAllocationEntryPar: Record "25006271";ServLaborAllocApplicationPar: Record "25006277";DocType: Integer;DocNo: Code[20];LineNo: Integer;var NewAllocEntryNoPar: Integer)
    begin
        //ServiceScheduleMgt.CreateNewAllocEntry(StartingDateTime,ResourceNo,Hours,SourceType,SourceID,LineNo,ReasonCode,PlanningPolicy,FinishedHours,RemainingHours,Status)
        IF NewAllocEntryNoPar = 0 THEN
          NewAllocEntryNoPar := ServiceScheduleMgt.CreateNewAllocEntry(ServLaborAllocationEntryPar."Start Date-Time", ServLaborAllocationEntryPar."Resource No.",
            ServLaborAllocationEntryPar."Quantity (Hours)", DocType, DocNo, LineNo, ServLaborAllocationEntryPar."Reason Code",
            ServLaborAllocationEntryPar."Planning Policy", ServLaborAllocApplicationPar."Finished Quantity (Hours)",
            ServLaborAllocApplicationPar."Remaining Quantity (Hours)", ServLaborAllocationEntryPar.Status)
        ELSE
          ServiceScheduleMgt.CreateAppEntry(NewAllocEntryNoPar, DocType, DocNo, LineNo, ServLaborAllocationEntryPar."Resource No.",
            // ServLaborAllocApplicationPar."Finished Quantity (Hours)", ServLaborAllocApplicationPar."Remaining Quantity (Hours)", TRUE);   // 18.12.2014 Elva Baltic P21 #E0003
            ServLaborAllocApplicationPar."Finished Quantity (Hours)", ServLaborAllocApplicationPar."Remaining Quantity (Hours)", FALSE);     // 18.12.2014 Elva Baltic P21 #E0003
    end;

    local procedure CopyHeaderComments(ServiceHeaderSpl: Record "25006145";ServiceHeaderNew: Record "25006145")
    var
        ServCommentLine: Record "25006148";
        ServCommentLine2: Record "25006148";
    begin
        ServCommentLine.RESET;
        IF ServiceHeaderSpl."Document Type" = ServiceHeaderSpl."Document Type"::Order THEN
          ServCommentLine.SETRANGE(Type, ServCommentLine.Type::"Service Order")
        ELSE
          EXIT;
        ServCommentLine.SETRANGE("No.",ServiceHeaderSpl."No.");
        IF ServCommentLine.FIND('-') THEN
          REPEAT
            ServCommentLine2.INIT;
            ServCommentLine2.TRANSFERFIELDS(ServCommentLine);
            ServCommentLine2."No." := ServiceHeaderNew."No.";
            ServCommentLine2.INSERT;
          UNTIL ServCommentLine.NEXT = 0;
    end;
}

