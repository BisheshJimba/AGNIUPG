table 25006165 "Serv. Journal Line"
{
    // 12.06.2013 EDMS P8
    //   * Merged code with NAV2009
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 'Variable Field Run 1' - now it is decimal
    //   * added fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.', 'Plan No.'
    // 
    // 2012.04.12 EDMS P8
    //   * removed field "Resource No."(580)
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management, added fields:
    //   *   Vehicle Axle Code
    //   *   Tire Position Code
    //   *   Tire Code
    //   *   Tire Entry
    // 
    // 14.12.2011 EDMS P8
    //   * MATH DIVIDE must checked for zero before act
    // 
    // 07.11.2011 EDMS P8
    //   * VALIDATION triggers are recoded
    // 
    // 28.01.2010 EDMSB P2
    //   * Added field "Standard Time", "Campaign No.", "Amount Including VAT (LCY)"
    // 
    // 20.10.2008. EDMS P2
    //   * Added field "Deal Type Code"
    // 
    // 05.03.2008 EDMS P2
    //   * Added fields "Package No."
    //                  "Package Version No."
    //                  "Package Version Spec. Line No."
    // 
    // * Serial No. - onvalidate
    // Working with dimensions is disabled (need to think about how to realize it)
    // See another validates also

    Caption = 'Serv. Journal Line';

    fields
    {
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Serv. Journal Template";
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Serv. Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Usage,Sale,Info';
            OptionMembers = Usage,Sale,Info;
        }
        field(50; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Order,Invoice,Credit Memo,Blanket Order,Return Order,Payment,Refund';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order",Payment,Refund;
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(70; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                VALIDATE("Document Date", "Posting Date");
                IF "Posting Date" <> xRec."Posting Date" THEN BEGIN
                    InitRates;
                    "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
                    "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
                    "Inv. Discount Amount (LCY)" := ROUND("Inv. Discount Amount" / FCYRate, LCYRoundingPrecision);
                END;
            end;
        }
        field(80; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            begin
                Veh.GET("Vehicle Serial No.");
                Veh.CALCFIELDS("Model Commercial Name");

                Description := Veh."Model Commercial Name";

                Veh.TESTFIELD(Blocked, FALSE);

                "Make Code" := Veh."Make Code";
                "Model Code" := Veh."Model Code";
                "Model Version No." := Veh."Model Version No.";

                IF Item.GET("Model Version No.") THEN BEGIN
                    "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                    VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
                END;
                /*
                  CreateDim(
                    DATABASE::Make,"Make Code",
                    DATABASE::Model,"Model Code",
                    DATABASE::Job,"Job No.");
                */

            end;
        }
        field(90; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(100; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(110;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
                LookupMgt: Codeunit "25006003";
            begin
                recItem.RESET;
                IF LookupMgt.LookUpModelVersion(recItem,"Model Version No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recItem."No.");
            end;
        }
        field(115;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle";
        }
        field(120;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(130;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(140;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                ResUnitofMeasure: Record "205";
            begin
                VALIDATE(Quantity);
            end;
        }
        field(150;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                VALIDATE("Unit Cost");
                VALIDATE("Unit Price");

                UpdateQtyHours(0);
            end;
        }
        field(160;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                InitRates;
                "Total Cost" := ROUND(Quantity * "Unit Cost", LCYRoundingPrecision);
            end;
        }
        field(170;"Total Cost";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';

            trigger OnValidate()
            begin
                InitRates;
                IF "Unit Cost" = 0 THEN
                  IF Quantity <> 0 THEN
                    "Unit Cost" := ROUND("Total Cost" / Quantity, LCYRoundingPrecisionUnit);
            end;
        }
        field(180;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                InitRates;
                Amount := ROUND(Quantity * "Unit Price", RoundingPrecision);
                IF FCYRate <> 0 THEN
                  "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
            end;
        }
        field(190;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';

            trigger OnValidate()
            begin
                InitRates;
                IF "Unit Price" = 0 THEN BEGIN
                  IF Quantity <> 0 THEN
                    "Unit Price" := ROUND(Amount / Quantity, RoundingPrecisionUnit);
                  IF FCYRate <> 0 THEN
                    "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
                END;
            end;
        }
        field(191;"Discount %";Decimal)
        {
            Caption = 'Discount %';

            trigger OnValidate()
            begin
                InitRates;
                "Line Discount Amount" := ROUND(Quantity * "Discount %", RoundingPrecision);
                IF FCYRate <> 0 THEN
                  "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
            end;
        }
        field(192;"Line Discount Amount";Decimal)
        {
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                InitRates;
                IF "Discount %" = 0 THEN
                  IF Quantity <> 0 THEN BEGIN
                    "Discount %" := ROUND(("Line Discount Amount" / Quantity) * 100, RoundingPrecisionUnit);
                    IF FCYRate <> 0 THEN
                      "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
                  END;
            end;
        }
        field(193;"Line Discount Amount (LCY)";Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';

            trigger OnValidate()
            begin
                InitRates;
                IF ("Discount %" = 0) OR ("Line Discount Amount" = 0) THEN BEGIN
                  "Line Discount Amount" := ROUND("Line Discount Amount (LCY)" * FCYRate, LCYRoundingPrecision);
                  IF Quantity <> 0 THEN
                    "Discount %" := ROUND(("Line Discount Amount" / Quantity) * 100, RoundingPrecisionUnit);
                END;
            end;
        }
        field(195;"Inv. Discount Amount";Decimal)
        {
            Caption = 'Inv. Discount Amount';

            trigger OnValidate()
            begin
                InitRates;
                IF FCYRate <> 0 THEN
                  "Inv. Discount Amount (LCY)" := ROUND("Inv. Discount Amount" / FCYRate, LCYRoundingPrecision);
            end;
        }
        field(196;"Inv. Discount Amount (LCY)";Decimal)
        {
            Caption = 'Inv. Discount Amount (LCY)';

            trigger OnValidate()
            begin
                InitRates;
                IF "Line Discount Amount" = 0 THEN
                  "Line Discount Amount" := ROUND("Line Discount Amount (LCY)" * FCYRate, LCYRoundingPrecision);
            end;
        }
        field(197;"Amount Including VAT (LCY)";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(198;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(199;"Amount (LCY)";Decimal)
        {
            Caption = 'Amount (LCY)';

            trigger OnValidate()
            begin
                InitRates;
                IF Amount = 0 THEN
                  Amount := ROUND("Amount (LCY)" * FCYRate, LCYRoundingPrecision);
                IF "Unit Price" = 0 THEN
                  IF Quantity <> 0 THEN
                    "Unit Price" := ROUND(Amount / Quantity, RoundingPrecisionUnit);
            end;
        }
        field(200;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(210;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(220;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(230;Chargeable;Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(240;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(250;"Recurring Method";Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(260;"Expiration Date";Date)
        {
            Caption = 'Expiration Date';
        }
        field(270;"Recurring Frequency";DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(280;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(290;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(300;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(310;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(320;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(330;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(340;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(350;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Labor)) "Service Labor".No.
                            ELSE IF (Type=CONST(External Service)) "External Service";

            trigger OnLookup()
            var
                Item: Record "27";
                Labor: Record "25006121";
                ExternalService: Record "25006133";
                GLAccount: Record "15";
                ServiceHeader: Record "25006145";
                StandardText: Record "7";
                LookUpMgt: Codeunit "25006003";
            begin
                // ,G/L Account,Item,Labor,External Service
                CASE Type OF
                  Type::" ":
                    BEGIN
                      StandardText.RESET;
                      IF LookUpMgt.LookUpStandardText(StandardText,"No.") THEN
                       VALIDATE("No.",StandardText.Code);
                    END;

                  Type::"G/L Account":
                    BEGIN
                      GLAccount.RESET;
                      IF LookUpMgt.LookUpGLAccount(GLAccount,"No.") THEN
                       VALIDATE("No.",GLAccount."No.");
                    END;

                  Type::Item:
                    BEGIN
                      Item.RESET;
                      IF LookUpMgt.LookUpItemREZ(Item,"No.") THEN
                       VALIDATE("No.",Item."No.");
                    END;

                  Type::Labor:
                    BEGIN
                      Labor.RESET;
                      Labor.SETCURRENTKEY("Make Code");
                      Labor.SETFILTER("Make Code", '''''|%1', "Make Code");
                      IF LookUpMgt.LookUpLabor(Labor,"No.") THEN
                       VALIDATE("No.",Labor."No.");
                    END;

                  Type::"External Service":
                    BEGIN
                      ExternalService.RESET;
                      IF LookUpMgt.LookUpExternalService(ExternalService,"No.") THEN
                       VALIDATE("No.",ExternalService."No.");
                    END;
                END;
            end;

            trigger OnValidate()
            var
                ItemTranslation: Record "30";
                StandardText: Record "7";
                Language: Record "8";
            begin
                CASE Type OF
                  Type::" ":
                    BEGIN
                      StandardText.GET("No.");
                      Description := StandardText.Description;
                    END;

                  Type::"G/L Account":
                  BEGIN
                    GLAcc.GET("No.");
                    GLAcc.CheckGLAcc;
                    GLAcc.TESTFIELD("Direct Posting",TRUE);
                    Description := GLAcc.Name;

                    "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                    IF "Gen. Bus. Posting Group" = '' THEN
                      "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                  END;

                  Type::Item:
                  BEGIN
                    GetItem;
                    Item.TESTFIELD(Blocked,FALSE);
                    Item.TESTFIELD("Inventory Posting Group");
                    Item.TESTFIELD("Gen. Prod. Posting Group");
                    Language.SETCURRENTKEY("Windows Language ID");
                    Language.SETRANGE("Windows Language ID", WINDOWSLANGUAGE);
                    Language.FINDFIRST;
                    IF ItemTranslation.GET("No.","Model Version No.", Language.Code) THEN
                      Description := ItemTranslation.Description
                    ELSE
                      Description := Item.Description;

                    GetUnitCost;
                    "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                    "Unit of Measure Code" := Item."Sales Unit of Measure";
                  END;

                  Type::Labor:
                  BEGIN
                    Labor.GET("No.");
                    Labor.TESTFIELD(Blocked,FALSE);
                    Labor.TESTFIELD("Gen. Prod. Posting Group");
                    Labor.TESTFIELD("VAT Prod. Posting Group");

                    Description := Labor.Description;
                    //Get description from Service Labor Text
                    GetDescriptionFromLaborText("No.", "Vehicle Serial No.");

                    "Unit of Measure Code" := Labor."Unit of Measure Code";
                    "Gen. Prod. Posting Group" := Labor."Gen. Prod. Posting Group";

                    ServiceSetup.GET;
                    IF NOT ServiceSetup."Quantity Equals Standard Time" THEN
                      VALIDATE(Quantity, 1)
                    ELSE
                      GetStandardTime;
                  END;

                  Type::"External Service":
                  BEGIN
                    ExternalService.GET("No.");
                    ExternalService.TESTFIELD(Blocked,FALSE);
                    ExternalService.TESTFIELD("Gen. Prod. Posting Group");
                    ExternalService.TESTFIELD("VAT Prod. Posting Group");
                    Description := ExternalService.Description;
                    "Gen. Prod. Posting Group" := ExternalService."Gen. Prod. Posting Group";
                    "Unit of Measure Code" := ExternalService."Unit of Measure Code";
                  END;
                END;
                IF Type <> Type::" " THEN BEGIN
                  VALIDATE("Gen. Prod. Posting Group");
                  VALIDATE("Unit of Measure Code");
                END;

                CreateDim(
                  DimMgt.TypeToTableID5(Type),"No.",
                  0,'',
                  0,'',
                  0,'');

                GetVehicleVariableFields("Vehicle Serial No.");
            end;
        }
        field(360;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("Customer No.") THEN
                  IF "Gen. Bus. Posting Group" = '' THEN
                    "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
            end;
        }
        field(361;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("Bill-to Customer No.") THEN
                  "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
            end;
        }
        field(362;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                InitRates;
                IF FCYRate <> 0 THEN
                  IF "Unit Price" = 0 THEN BEGIN
                    "Amount (LCY)" := ROUND(Amount / FCYRate, LCYRoundingPrecision);
                    "Line Discount Amount (LCY)" := ROUND("Line Discount Amount" / FCYRate, LCYRoundingPrecision);
                    "Inv. Discount Amount (LCY)" := ROUND("Inv. Discount Amount" / FCYRate, LCYRoundingPrecision);
                    "Amount Including VAT (LCY)" := ROUND("Amount Including VAT" / FCYRate, LCYRoundingPrecision);
                  END;
            end;
        }
        field(390;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(400;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(410;"Pre-Assigned No.";Code[20])
        {
            Caption = 'Previous Document No.';
        }
        field(420;"Service Receiver";Code[10])
        {
            Caption = 'Service Receiver';
            TableRelation = Salesperson/Purchaser;
        }
        field(430;"Service Order Type";Code[10])
        {
            Caption = 'Service Order Type';
            TableRelation = "Service Order Type";
        }
        field(440;"Service Order No.";Code[20])
        {
            Caption = 'Service Order No.';
            TableRelation = "Service Header".No. WHERE (Document Type=CONST(Order));
        }
        field(450;"Cust. Ledger Entry No.";Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(460;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(570;Kilometrage;Integer)
        {
        }
        field(580;"Variable Field Run 2";Decimal)
        {
            CaptionClass = '7,25006165,580';
            Enabled = false;
        }
        field(590;"Variable Field Run 3";Decimal)
        {
            CaptionClass = '7,25006165,590';
            Enabled = false;
        }
        field(50056;"RV RR Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repeat Repair';
            OptionMembers = " ",Revisit,"Repeat Repair";
        }
        field(50057;"Quality Control";Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource;
        }
        field(50059;"Floor Control";Code[20])
        {
            Description = 'PSF';
            TableRelation = Resource;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
        }
        field(25006005;"Minutes Per UoM";Decimal)
        {
            Caption = 'Minutes Per UoM';

            trigger OnValidate()
            begin
                UpdateQtyHours(0);
            end;
        }
        field(25006006;"Quantity (Hours)";Decimal)
        {
            Caption = 'Quantity (Hours)';
        }
        field(25006030;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006100;"Vehicle Axle Code";Code[10])
        {
            Caption = 'Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25006110;"Tire Position Code";Code[10])
        {
            Caption = 'Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                Axle Code=FIELD(Vehicle Axle Code));
        }
        field(25006120;"Tire Code";Code[20])
        {
            Caption = 'Tire Code';
            TableRelation = Tire.Code;
        }
        field(25006125;"Tire Operation Type";Option)
        {
            Caption = 'Tire Operation Type';
            OptionCaption = ' ,Put on,Take off,Position Change';
            OptionMembers = " ","Put on","Take off","Position Change";
        }
        field(25006126;"New Vehicle Axle Code";Code[10])
        {
            Caption = 'New Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25006127;"New Tire Position Code";Code[10])
        {
            Caption = 'New Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                Axle Code=FIELD(Vehicle Axle Code));
        }
        field(25006150;"Standard Time";Decimal)
        {
            Caption = 'Standard Time';
            DecimalPlaces = 0:5;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package".No.;
        }
        field(25006276;"Warranty Claim No.";Code[20])
        {
            Caption = 'Warranty Claim No.';
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
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006165,25006800';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006800"),
                  "Make Code","Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006165,25006801';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006801"),
                  "Make Code","Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006165,25006802';
            Enabled = false;

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006802"),
                  "Make Code","Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006820;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
            Description = 'at begin holds line No. of order only';
            TableRelation = "Posted Serv. Order Line"."Line No." WHERE (Document No.=FIELD(Document No.));
        }
        field(25007240;"Plan No.";Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan".No. WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25007245;"Plan Stage Recurrence";Integer)
        {
            Caption = 'Plan Stage Recurrence';
        }
        field(25007250;"Plan Stage Code";Code[10])
        {
            Caption = 'Code';
            TableRelation = "Vehicle Service Plan Stage".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                     Plan No.=FIELD(Plan No.));
        }
        field(25007251;"Service Address Code";Code[10])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address";
        }
        field(25007252;"Service Address";Text[50])
        {
            Caption = 'Service Address';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020235;"Job Type";Code[20])
        {
        }
        field(33020236;"Description 2";Text[50])
        {
        }
        field(33020237;"Warranty Approved";Boolean)
        {
        }
        field(33020238;"Approved Date";Date)
        {
        }
        field(33020239;"Customer Verified";Boolean)
        {
        }
        field(33020242;"Service Type";Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,6th type service,7th type Service,8th type Service,Bonus,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service","6th type Service","7th type Service"," 8th type Service",Bonus,Other;

            trigger OnValidate()
            var
                NotAllowed: Label 'Job Category must be Under Warranty';
            begin
            end;
        }
        field(33020244;"Is Booked";Boolean)
        {
        }
        field(33020245;"Hour Reading";Decimal)
        {
        }
        field(33020246;"External Service Purchased";Boolean)
        {
        }
        field(33020247;"Next Service Date";Date)
        {
        }
        field(33020257;"Job Type (Service Header)";Code[20])
        {
        }
        field(33020258;"Job Category";Option)
        {
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020263;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020264;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020267;"Delay Reason Code";Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Additional Job,Parts Not Avilable,Parts Delay,Diagnosis And Troubleshooting,Customer Approval Delay,ERP Issue,Internet Issue';
            OptionMembers = " ","Additional Job","Parts Not Avilable","Parts Delay","Diagnosis And Troubleshooting","Customer Approval Delay","ERP Issue","Internet Issue";
        }
        field(33020268;"Resources PSF";Code[20])
        {
            Description = 'PSF';
        }
        field(33020269;"Revisit Repair Reason";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // 26.10.2012 EDMS <<
        /*
        DimMgt.DeleteJnlLineDim(
          DATABASE::"Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0);
        */
        // 26.10.2012 EDMS <<

    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        ServJnlTemplate.GET("Journal Template Name");
        ServJnlBatch.GET("Journal Template Name","Journal Batch Name");
        
        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        // 26.10.2012 EDMS >>
        /*
        DimMgt.InsertJnlLineDim(
          DATABASE::"Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        // 26.10.2012 EDMS <<

    end;

    var
        ServJnlTemplate: Record "25006163";
        ServJnlBatch: Record "25006164";
        ServJnlLine: Record "25006165";
        Veh: Record "25006005";
        Customer: Record "18";
        GLSetup: Record "98";
        GLAcc: Record "15";
        Labor: Record "25006121";
        UnitOfMeasure: Record "204";
        ResFindUnitCost: Codeunit "220";
        ResFindUnitPrice: Codeunit "221";
        NoSeriesMgt: Codeunit "396";
        DimMgt: Codeunit "408";
        GLSetupRead: Boolean;
        Item: Record "27";
        cuVFMgt: Codeunit "25006004";
        cuLookupMgt: Codeunit "25006003";
        ServiceSetup: Record "25006120";
        ExternalService: Record "25006133";
        Currency: Record "4";
        RoundingPrecision: Decimal;
        LCYRoundingPrecision: Decimal;
        RoundingPrecisionUnit: Decimal;
        LCYRoundingPrecisionUnit: Decimal;
        FCYRate: Decimal;

    [Scope('Internal')]
    procedure EmptyLine(): Boolean
    begin
        EXIT(Type=Type::" ");
    end;

    [Scope('Internal')]
    procedure SetUpNewLine(LastServJnlLine: Record "25006165")
    begin
        ServJnlTemplate.GET("Journal Template Name");
        ServJnlBatch.GET("Journal Template Name","Journal Batch Name");
        ServJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        ServJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        IF ServJnlLine.FINDFIRST THEN BEGIN
          "Posting Date" := LastServJnlLine."Posting Date";
          "Document Date" := LastServJnlLine."Posting Date";
          "Document No." := LastServJnlLine."Document No.";
        END ELSE BEGIN
          "Posting Date" := WORKDATE;
          "Document Date" := WORKDATE;
          IF ServJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(NoSeriesMgt);
            "Document No." := NoSeriesMgt.TryGetNextNo(ServJnlBatch."No. Series","Posting Date");
          END;
        END;
        "Recurring Method" := LastServJnlLine."Recurring Method";
        "Source Code" := ServJnlTemplate."Source Code";
        "Reason Code" := ServJnlBatch."Reason Code";
        "Posting No. Series" := ServJnlBatch."Posting No. Series";
    end;

    [Scope('Internal')]
    procedure CreateDim(Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20])
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.GetDefaultDimID(
          TableID,No,"Source Code",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    [Scope('Internal')]
    procedure InitRates()
    var
        CurrencyExchangeRate: Record "330";
    begin
        GetGLSetup;
        LCYRoundingPrecision := GLSetup."Amount Rounding Precision";
        LCYRoundingPrecisionUnit := GLSetup."Unit-Amount Rounding Precision";
        IF Currency.GET("Currency Code") THEN BEGIN
          RoundingPrecision := Currency."Amount Rounding Precision";
          RoundingPrecisionUnit := Currency."Unit-Amount Rounding Precision";
        END;
        IF RoundingPrecision = 0 THEN BEGIN
          RoundingPrecision := LCYRoundingPrecision;
          RoundingPrecisionUnit := LCYRoundingPrecisionUnit
        END;
        IF NOT (("Currency Code" = '') OR ("Currency Code" = GLSetup."LCY Code")) THEN
          FCYRate := CurrencyExchangeRate.ExchangeRate("Posting Date", "Currency Code")
        ELSE
          FCYRate := 1;
        IF FCYRate = 0 THEN
          FCYRate := 1;
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        EXIT(cuVFMgt.IsVFActive(DATABASE::"Serv. Journal Line",intFieldNo));
    end;

    local procedure GetItem()
    begin
        TESTFIELD("No.");
        IF "No." <> Item."No." THEN
          Item.GET("No.");
    end;

    local procedure GetUnitCost()
    var
        UOMMgt: Codeunit "5402";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
        VALIDATE("Unit Cost",Item."Unit Cost" * "Qty. per Unit of Measure");
    end;

    [Scope('Internal')]
    procedure GetStandardTime()
    var
        ServiceLaborStandardTime: Record "25006122";
        Vehicle: Record "25006005";
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "25006006";
        VFUsage2: Record "25006006";
        LookUpMgt: Codeunit "25006003";
        VariableField: Record "25006002";
    begin
        Vehicle.RESET;
        IF "Vehicle Serial No." <> '' THEN
          Vehicle.GET("Vehicle Serial No.");

        ServiceLaborStandardTime.SETFILTER("Labor No.","No.");
        IF  ServiceLaborStandardTime.ISEMPTY THEN
          EXIT;

        ServiceLaborStandardTime.SETFILTER("Make Code", '''''|%1', "Make Code");
        ServiceLaborStandardTime.SETFILTER("Model Code", '''''|%1', Vehicle."Model Code");

        ServiceLaborStandardTime.SETFILTER("Prod. Year From",'..%1',Vehicle."Production Year");
        ServiceLaborStandardTime.SETFILTER("Prod. Year To",'''''|%1..',Vehicle."Production Year");

        RecordRef2.OPEN(DATABASE::Vehicle);
        RecordRef2.GETTABLE(Vehicle);

        RecordRef1.OPEN(DATABASE::"Service Labor Standard Time");

        VFUsage1.RESET;
        VFUsage1.SETRANGE("Table No.",DATABASE::"Service Labor Standard Time");
        IF VFUsage1.FINDFIRST THEN
          REPEAT
            VFUsage2.RESET;
            VFUsage2.SETCURRENTKEY("Variable Field Code");
            VFUsage2.SETRANGE("Table No.",DATABASE::Vehicle);
            VFUsage2.SETRANGE("Variable Field Code",VFUsage1."Variable Field Code");
            IF VFUsage2.FINDFIRST THEN BEGIN
              VariableField.GET(VFUsage1."Variable Field Code");
              IF VariableField."Use In Filtering" THEN BEGIN
                FieldRef1 := RecordRef2.FIELD(VFUsage2."Field No.");
                RecordRef1.SETVIEW(ServiceLaborStandardTime.GETVIEW);
                FieldRef2 := RecordRef1.FIELD(VFUsage1."Field No.");
                FieldRef2.SETFILTER('''''|%1',FORMAT(FieldRef1.VALUE));
                ServiceLaborStandardTime.SETVIEW(RecordRef1.GETVIEW);
             END;
           END;
          UNTIL VFUsage1.NEXT = 0;

        IF ServiceLaborStandardTime.COUNT > 1 THEN BEGIN
          IF LookUpMgt.LookUpLaborStandardTime(ServiceLaborStandardTime,"Make Code","No.",0) THEN BEGIN
            VALIDATE(Quantity,ServiceLaborStandardTime."Standard Time (Hours)");
          END;
        END ELSE BEGIN
          IF ServiceLaborStandardTime.FINDFIRST THEN BEGIN
            VALIDATE(Quantity,ServiceLaborStandardTime."Standard Time (Hours)");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure GetDescriptionFromLaborText(LaborNo: Code[20];VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "25006006";
        ServLaborText: Record "25006175";
        VehicleLoc: Record "25006005";
        VariableValue: Text[30];
    begin
        ServLaborText.RESET;
        ServLaborText.SETRANGE("Service Labor No.", LaborNo);

        IF NOT VehicleLoc.GET(VehicleSerialNo) THEN
          EXIT;

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Labor Text");
        VariableFieldUsage.SETRANGE("Field No.", 25006800);
        IF VariableFieldUsage.FINDFIRST THEN BEGIN
          VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
          IF VariableValue <> '' THEN
            ServLaborText.SETRANGE("Variable Field 25006800", VariableValue);
        END;

        VariableFieldUsage.SETRANGE("Field No.", 25006801);
        IF VariableFieldUsage.FINDFIRST THEN BEGIN
          VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
          IF VariableValue <> '' THEN
            ServLaborText.SETRANGE("Variable Field 25006801", VariableValue);
        END;

        IF ServLaborText.FINDFIRST THEN BEGIN
          Description := ServLaborText.Description;
        END;
    end;

    [Scope('Internal')]
    procedure GetVariableValue(Vehicle: Record "25006005";"Field": Text[30]) FieldValue: Text[30]
    var
        RecordRef1: RecordRef;
        FieldRef1: FieldRef;
        VariableFieldUsage: Record "25006006";
    begin
        FieldValue := '';

        IF Field = '' THEN
          EXIT;

        RecordRef1.OPEN(DATABASE::Vehicle);
        RecordRef1.GETTABLE(Vehicle);
        VariableFieldUsage.RESET;
        VariableFieldUsage.SETCURRENTKEY("Variable Field Code");
        VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
        VariableFieldUsage.SETRANGE("Variable Field Code",Field);

        IF VariableFieldUsage.FINDFIRST THEN
         BEGIN
          FieldRef1 := RecordRef1.FIELD(VariableFieldUsage."Field No.");
          FieldValue := FieldRef1.VALUE;
         END;
        RecordRef1.SETTABLE(Vehicle);
    end;

    [Scope('Internal')]
    procedure GetVehicleVariableFields(VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        VehicleLoc: Record "25006005";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        VariableValue: Text[30];
    begin
        IF NOT VehicleLoc.GET(VehicleSerialNo) THEN
          EXIT;
        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Line EDMS");
        IF VariableFieldUsage.FINDFIRST THEN BEGIN
          REPEAT
            VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
            IF VariableValue <> '' THEN BEGIN
              CASE VariableFieldUsage."Field No." OF
                25006800: "Variable Field 25006800" := VariableValue;
                25006801: "Variable Field 25006801" := VariableValue;
                25006802: "Variable Field 25006802" := VariableValue;
              END;
            END;
          UNTIL VariableFieldUsage.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateQtyHours(CalledByFieldNo: Integer)
    begin
        IF CalledByFieldNo = 0 THEN
          CalledByFieldNo := CurrFieldNo;

        CASE Type OF
          Type::Item:
            BEGIN
              EXIT;
            END;
          Type::"External Service",Type::Labor:
           BEGIN
            IF CalledByFieldNo IN [FIELDNO("Unit of Measure Code"), FIELDNO(Quantity), FIELDNO("Minutes Per UoM"),
                FIELDNO("No.")] THEN BEGIN
              IF CalledByFieldNo IN [FIELDNO("Unit of Measure Code"), FIELDNO("No.")] THEN BEGIN
                IF UnitOfMeasure.GET("Unit of Measure Code") THEN
                  "Minutes Per UoM" := UnitOfMeasure."Minutes Per UoM";
              END;
              "Quantity (Hours)" := (Quantity * "Minutes Per UoM")/60;
            END;
           END;
        END;
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
}

