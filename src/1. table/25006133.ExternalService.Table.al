table 25006133 "External Service"
{
    // 15.07.2008. EDMS P2
    //   * Changed field Comment property CalaFormula

    Caption = 'External Service';
    DataCaptionFields = "No.", Description;
    LookupPageID = 25006174;

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                    "Search Description" := Description;
                "Last Date Modified" := TODAY;
            end;
        }
        field(30; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(40; "Description 2"; Text[50])
        {
            Caption = 'Description 2';

            trigger OnValidate()
            begin
                "Last Date Modified" := TODAY;
            end;
        }
        field(50; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(60; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(70; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(80; Comment; Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE(Type = CONST(External Service),
                                                                   No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                 "Last Date Modified" := TODAY;
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(100;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(110;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                 "Last Date Modified" := TODAY;
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(120;"Vendor No.";Code[20])
        {
            Caption = 'Vendor Number';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(210;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(211;"Allow Tracking Nos.";Boolean)
        {
            Caption = 'Allow Tracking Nos.';
        }
        field(212;"Tracking Nos.";Code[20])
        {
            Caption = 'Tracking Nos.';
            TableRelation = "No. Series";
        }
        field(280;"Date Created";Date)
        {
            Caption = 'Date Created';
        }
        field(290;"Price Includes VAT";Boolean)
        {
            Caption = 'Price Includes VAT';
            Editable = false;

            trigger OnValidate()
            var
                VATPostingSetup: Record "325";
            begin
                IF "Price Includes VAT" THEN BEGIN
                  IF NOT VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group") THEN
                    FIELDERROR("VAT Bus. Posting Gr. (Price)");
                END;
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
        field(50000;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(50001;"Internal Service";Boolean)
        {
            Description = '//For Ex. Balkumari Workshop';
            Editable = false;
        }
        field(50002;"Accountability Center";Code[10])
        {
            Description = '//For BAW';
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          GetServSetup;
          ServSetup.TESTFIELD("External Service Nos.");
          NoSeriesMgt.InitSeries(ServSetup."External Service Nos.",ServSetup."External Service Nos.",
            0D,"No.",ServSetup."External Service Nos.");
        END;
         "Date Created":=WORKDATE;
         "VAT Bus. Posting Gr. (Price)" := '';
         "VAT Prod. Posting Group" := 'VAT13';

        //***SM 24-07-2013 to pass acc center in external service
        UserSetup.GET(USERID);
        AccCenter.RESET;
        AccCenter.SETRANGE(Code,UserSetup."Default Accountability Center");
        IF AccCenter.FIND('-') THEN BEGIN
           "Accountability Center" := AccCenter.Code;
        END;
    end;

    trigger OnModify()
    begin
         "Last Date Modified" := TODAY;
         "VAT Bus. Posting Gr. (Price)" := '';
         "VAT Prod. Posting Group" := 'VAT13';
    end;

    trigger OnRename()
    begin
         "Last Date Modified" := TODAY;
    end;

    var
        VATPostingSetup: Record "325";
        Text001: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        GLSetupRead: Boolean;
        GLSetup: Record "98";
        ServSetup: Record "25006120";
        NoSeriesMgt: Codeunit "396";
        HasServSetup: Boolean;
        UserSetup: Record "91";
        AccCenter: Record "33019846";

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        GetServSetup;
        ServSetup.TESTFIELD("External Service Nos.");
        IF NoSeriesMgt.SelectSeries(ServSetup."External Service Nos.",ServSetup."External Service Nos.",
          ServSetup."External Service Nos.") THEN
         BEGIN
          NoSeriesMgt.SetSeries("No.");
          EXIT(TRUE);
         END;
    end;

    [Scope('Internal')]
    procedure GetServSetup()
    begin
        IF NOT HasServSetup THEN BEGIN
          ServSetup.GET;
          HasServSetup := TRUE;
        END;
    end;
}

