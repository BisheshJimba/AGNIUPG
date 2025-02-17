table 25006121 "Service Labor"
{
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added CaptionML to field:
    //     "Labor Discount Group"

    Caption = 'Service Labor';
    DataCaptionFields = "No.", Description;
    DataPerCompany = false;
    DrillDownPageID = 25006152;
    LookupPageID = 25006152;

    fields
    {
        field(8; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    GetServSetup;
                    NoSeriesMgt.TestManual(ServSetup."Labor Nos.");
                END;
            end;
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make.Code;
        }
        field(40; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                    "Search Description" := Description;
                "Last Date Modified" := TODAY;
            end;
        }
        field(50; "Description 2"; Text[50])
        {
            Caption = 'Description 2';

            trigger OnValidate()
            begin
                "Last Date Modified" := TODAY;
            end;
        }
        field(60; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(70; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                "Last Date Modified" := TODAY;

                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                    IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") THEN
                        VALIDATE("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");

                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(80; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "Last Date Modified" := TODAY;
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(86; Comment; Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE(Type = CONST(Labor),
                                                                   No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                 "Last Date Modified" := TODAY;

                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(100;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                 "Last Date Modified" := TODAY;

                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(120;"Group Code";Code[10])
        {
            Caption = 'Group Code';
            TableRelation = "Service Labor Group".Code;

            trigger OnValidate()
            begin
                IF "Group Code" <> xRec."Group Code" THEN
                 VALIDATE("Subgroup Code",'');
            end;
        }
        field(130;"Subgroup Code";Code[10])
        {
            Caption = 'Subgroup Code';
            TableRelation = "Service Labor Subgroup".Code WHERE (Group Code=FIELD(Group Code));
        }
        field(150;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(160;"Free of Charge";Boolean)
        {
            Caption = 'Free of Charge';
        }
        field(180;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(200;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(280;"Date Created";Date)
        {
            Caption = 'Date Created';
        }
        field(290;"Price Includes VAT";Boolean)
        {
            Caption = 'Price Includes VAT';

            trigger OnValidate()
            var
                VATPostingSetup: Record "325";
            begin
                IF "Price Includes VAT" THEN BEGIN
                  IF NOT VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group") THEN
                      ERROR(
                        Text002,
                        FIELDCAPTION("VAT Bus. Posting Gr. (Price)"),
                        FIELDCAPTION("VAT Prod. Posting Group"));

                END;
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(300;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(310;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(320;"Price/Profit Calculation";Option)
        {
            Caption = 'Price/Profit Calculation';
            OptionCaption = 'Profit=Price-Cost,Price=Cost+Profit,No Relationship';
            OptionMembers = "Profit=Price-Cost","Price=Cost+Profit","No Relationship";

            trigger OnValidate()
            begin
                IF "Price Includes VAT" AND
                   ("Price/Profit Calculation" < "Price/Profit Calculation"::"No Relationship")
                THEN BEGIN
                  VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
                  CASE VATPostingSetup."VAT Calculation Type" OF
                    VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                      VATPostingSetup."VAT %" := 0;
                    VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                      ERROR(
                        Text001,
                        VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                        VATPostingSetup."VAT Calculation Type");
                  END;
                END ELSE
                  CLEAR(VATPostingSetup);

                CASE "Price/Profit Calculation" OF
                  "Price/Profit Calculation"::"Profit=Price-Cost":
                    IF "Unit Price" <> 0 THEN
                      "Profit %" :=
                        ROUND(
                          100 * (1 - "Unit Cost" / ("Unit Price" /
                          (1 + VATPostingSetup."VAT %" / 100))),0.00001)
                    ELSE
                      "Profit %" := 0;
                  "Price/Profit Calculation"::"Price=Cost+Profit":
                    IF "Profit %" < 100 THEN BEGIN
                      GetGLSetup;
                      "Unit Price" :=
                        ROUND(
                          ("Unit Cost" / (1 - "Profit %" / 100)) *
                          (1 + VATPostingSetup."VAT %" / 100),GLSetup."Unit-Amount Rounding Precision");
                    END;
                END;
            end;
        }
        field(330;"Profit %";Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0:5;
            MaxValue = 99.99999;

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(340;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                //  TestNoEntriesExist(FIELDCAPTION("Unit Cost"));
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(350;"Base Unit of Measure";Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                //TestNoOpenEntriesExist(FIELDCAPTION("Base Unit of Measure"));
            end;
        }
        field(360;"Price Group Code";Code[10])
        {
            Caption = 'Price Group Code';
            TableRelation = "Service Labor Price Group".No.;
        }
        field(370;"Labor Discount Group";Code[20])
        {
            Caption = 'Labor Discount Group';
            TableRelation = "Service Labor Discount Group";
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006121,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006121,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006121,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(33020235;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(33020236;"Standard Time (Hours)";Decimal)
        {
            CalcFormula = Lookup("Service Labor Standard Time"."Standard Time (Hours)" WHERE (Labor No.=FIELD(No.)));
            Caption = 'Standard Time (Hours)';
            FieldClass = FlowField;
        }
        field(33020237;"Washing/Greasing/Polishing";Boolean)
        {
        }
        field(33020238;"Model Version No.";Code[20])
        {
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=FILTER(Model Version));
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Make Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          GetServSetup;
          ServSetup.TESTFIELD("Labor Nos.");
          NoSeriesMgt.InitSeries(ServSetup."Labor Nos.",ServSetup."Labor Nos.",0D,"No.",ServSetup."Labor Nos.");
        END;
         "Date Created":=WORKDATE;
    end;

    trigger OnModify()
    begin
         "Last Date Modified" := TODAY;
    end;

    trigger OnRename()
    begin
         "Last Date Modified" := TODAY;
    end;

    var
        ServSetup: Record "25006120";
        NoSeriesMgt: Codeunit "396";
        VFMgt: Codeunit "25006004";
        LookUpMgt: Codeunit "25006003";
        DimMgt: Codeunit "408";
        GLSetup: Record "98";
        VATPostingSetup: Record "325";
        GenProdPostingGrp: Record "251";
        Text001: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        GLSetupRead: Boolean;
        HasServSetup: Boolean;
        Text002: Label 'Can''t find VAT Posting Setup. Please check fields %1 and %2.';

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        GetServSetup;
        ServSetup.TESTFIELD("Labor Nos.");
        IF NoSeriesMgt.SelectSeries(ServSetup."Labor Nos.",ServSetup."Labor Nos.",ServSetup."Labor Nos.") THEN
         BEGIN
          NoSeriesMgt.SetSeries("No.");
          EXIT(TRUE);
         END;
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Service Labor",intFieldNo));
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    [Scope('Internal')]
    procedure GetServSetup()
    begin
        IF NOT HasServSetup THEN BEGIN
          ServSetup.GET;
          HasServSetup := TRUE;
        END;
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Service Labor","No.",FieldNumber,ShortcutDimCode);
        MODIFY;
    end;
}

