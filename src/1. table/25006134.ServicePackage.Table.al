table 25006134 "Service Package"
{
    // 09.05.2008. EDMS P2
    //   * Added code Make Code - OnValidate

    Caption = 'Service Package';
    LookupPageID = 25006161;

    fields
    {
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;

            trigger OnValidate()
            var
                ServicePackageVersion: Record "25006135";
            begin
                //09.05.2008. EDMS P2>>
                IF "Make Code" <> xRec."Make Code" THEN BEGIN
                    ServicePackageVersion.RESET;
                    ServicePackageVersion.SETRANGE("Package No.", "No.");
                    IF ServicePackageVersion.FINDFIRST THEN
                        REPEAT
                            ServicePackageVersion.VALIDATE("Make Code", "Make Code");
                            ServicePackageVersion.MODIFY;
                        UNTIL ServicePackageVersion.NEXT = 0;
                END;
                //09.05.2008. EDMS P2<<
            end;
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = COPYSTR(UPPERCASE(xRec.Description), 1, 30)) OR ("Search Description" = '') THEN
                    "Search Description" := COPYSTR(Description, 1, 30);
            end;
        }
        field(40; "Search Description"; Code[30])
        {
            Caption = 'Search Description';
        }
        field(50; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(60; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            TableRelation = "Service Labor Group".Code WHERE(Make Code=FIELD(Make Code));

            trigger OnValidate()
            begin
                IF "Group Code" <> xRec."Group Code" THEN
                 VALIDATE("Subgroup Code",'');
            end;
        }
        field(70;"Subgroup Code";Code[10])
        {
            Caption = 'Subgroup Code';
            TableRelation = "Service Labor Subgroup".Code WHERE (Group Code=FIELD(Group Code),
                                                                 Make Code=FIELD(Make Code));
        }
        field(80;Comment;Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE (Type=CONST(Service Package),
                                                                   No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90;"Free of Charge";Boolean)
        {
            Caption = 'Free of Charge';
        }
        field(100;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(150;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(200;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Campaign Service Package,Service Package,Instruction';
            OptionMembers = "Campaign Service Package","Service Package",Instruction;
        }
        field(210;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(220;"Ending Date";Date)
        {
            Caption = 'Ending Date';
        }
        field(230;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF CurrFieldNo <> FIELDNO("Currency Code") THEN
                  UpdateCurrencyFactor
                ELSE BEGIN
                  IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    UpdateCurrencyFactor;
                   // RecreateSPLines(FIELDCAPTION("Currency Code"));
                  END ELSE
                    IF "Currency Code" <> '' THEN BEGIN
                      UpdateCurrencyFactor;
                      IF "Currency Factor" <> xRec."Currency Factor" THEN
                        ConfirmUpdateCurrencyFactor;
                    END;
                END;
            end;
        }
        field(240;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                  UpdateSPLines(FIELDCAPTION("Currency Factor"),FALSE);
            end;
        }
        field(250;"Prices Including VAT";Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                SalesLine: Record "37";
                Currency: Record "4";
                RecalculatePrice: Boolean;
            begin
                /*
                
                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                  SalesLine.SETRANGE("Document Type","Document Type");
                  SalesLine.SETRANGE("Document No.","No.");
                  SalesLine.SETFILTER("Unit Price",'<>%1',0);
                  SalesLine.SETFILTER("VAT %",'<>%1',0);
                  IF SalesLine.FIND('-') THEN BEGIN
                    RecalculatePrice :=
                      CONFIRM(
                        STRSUBSTNO(
                          Text024 +
                          Text026,
                          FIELDCAPTION("Prices Including VAT"),SalesLine.FIELDCAPTION("Unit Price")),
                        TRUE);
                    SalesLine.SetSalesHeader(Rec);
                
                    IF "Currency Code" = '' THEN
                      Currency.InitRoundingPrecision
                    ELSE
                      Currency.GET("Currency Code");
                
                    REPEAT
                      SalesLine.TESTFIELD("Quantity Invoiced",0);
                      SalesLine.TESTFIELD("Prepmt. Amt. Inv.",0); //08-05-2007 EDMS P3 PREPMT
                      IF NOT RecalculatePrice THEN BEGIN
                        SalesLine."VAT Difference" := 0;
                        SalesLine.InitOutstandingAmount;
                        VehPriceMgt.UpdAssemblyHdrField(Rec,SalesLine,FIELDNO("Prices Including VAT"));   //23.11.2007 EDMS P3
                      END ELSE BEGIN
                        IF "Prices Including VAT" THEN BEGIN
                          SalesLine."Unit Price" :=
                            ROUND(
                              SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF SalesLine.Quantity <> 0 THEN BEGIN
                            SalesLine."Line Discount Amount" :=
                              ROUND(
                                SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            SalesLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                          END;
                        END ELSE BEGIN
                          SalesLine."Unit Price" :=
                            ROUND(
                              SalesLine."Unit Price" / (1 + (SalesLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF SalesLine.Quantity <> 0 THEN BEGIN
                            SalesLine."Line Discount Amount" :=
                              ROUND(
                                SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            SalesLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                SalesLine."Inv. Discount Amount" / (1 + (SalesLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                          END;
                        END;
                        VehPriceMgt.ChkAssemblyHdrSalesLine(SalesLine) //23.11.2007 EDMS P3
                      END;
                      SalesLine.MODIFY;
                    UNTIL SalesLine.NEXT = 0;
                  END;
                END;
                */

            end;
        }
        field(300;"Fixed Prices and Discounts";Boolean)
        {
            Caption = 'Fixed Prices and Discounts';
        }
        field(310;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                TESTFIELD(Type,Type::"Campaign Service Package");
            end;
        }
        field(320;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(400;"Recall Campaign No.";Code[20])
        {
            Caption = 'Recall Campaign No.';
            TableRelation = "Recall Campaign";
        }
        field(50000;"Total Amount (Sanjivani)";Decimal)
        {
            Description = '//Used for Sanjivani';
        }
        field(50001;"Validity (Sanjivani)";DateFormula)
        {
            Description = '//Used for Sanjivani';
        }
        field(50002;"Limit Amount (Sanjivani)";Decimal)
        {
            Description = '//Used for Sanjivani';
        }
        field(50003;"Hide Discount Amount";Boolean)
        {
        }
        field(50004;"Hide Line Amount";Boolean)
        {
        }
        field(50005;"Customer Price Group";Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
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
        key(Key3;Type)
        {
        }
        key(Key4;"Recall Campaign No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SPVersion.RESET;
        SPVersion.SETRANGE("Package No.", "No.");
        SPVersion.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN
         BEGIN
          ServSetup.GET;
          ServSetup.TESTFIELD("Service Package Nos.");
          NoSeriesMgt.InitSeries(ServSetup."Service Package Nos.",ServSetup."Service Package Nos.",0D,"No.",
               ServSetup."Service Package Nos.");
         END;
         "Last Date Modified":=WORKDATE;
        UserSetup.GET(USERID);
        Location.GET(UserSetup."Default Location");
        Location.TESTFIELD("Default Price Group");
        "Customer Price Group" := Location."Default Price Group";
    end;

    var
        ServSetup: Record "25006120";
        CurrExchRate: Record "330";
        NoSeriesMgt: Codeunit "396";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text001: Label 'Do you want to update the exchange rate?';
        Text002: Label 'You have modified %1.\\';
        Text003: Label 'Do you want to update the lines?';
        SPVersion: Record "25006135";
        SPVersionSpec: Record "25006136";
        HasServSetup: Boolean;
        Location: Record "14";
        UserSetup: Record "91";

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        IF "Currency Code" <> '' THEN BEGIN
          CurrencyDate := WORKDATE;
          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        END ELSE
          "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        IF HideValidationDialog THEN
          Confirmed := TRUE
        ELSE
          Confirmed := CONFIRM(Text001,FALSE);
        IF Confirmed THEN
          VALIDATE("Currency Factor")
        ELSE
          "Currency Factor" := xRec."Currency Factor";
    end;

    [Scope('Internal')]
    procedure UpdateSPLines(ChangedFieldName: Text[100];AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        IF SPLinesExist AND AskQuestion THEN BEGIN
          Question := STRSUBSTNO(
            Text002 +
            Text003,ChangedFieldName);
          IF GUIALLOWED AND NOT DIALOG.CONFIRM(Question,TRUE) THEN
            EXIT
          ELSE
            UpdateLines := TRUE;
        END;
        IF SPLinesExist THEN BEGIN

          SPVersion.LOCKTABLE;
          SPVersionSpec.LOCKTABLE;
          MODIFY;

          SPVersion.RESET;
          SPVersion.SETRANGE("Package No.","No.");
          IF SPVersion.FINDSET THEN
            REPEAT
              SPVersionSpec.RESET;
              SPVersionSpec.SETRANGE("Package No.","No.");
              SPVersionSpec.SETRANGE("Version No.",SPVersion."Version No.");
              IF SPVersionSpec.FINDSET THEN
                REPEAT
                  CASE ChangedFieldName OF
                    FIELDCAPTION("Currency Factor") :
                      IF SPVersionSpec.Type <> SPVersionSpec.Type::" " THEN BEGIN
                        SPVersionSpec.VALIDATE("Unit Price");
                    END;
                  END;
                  SPVersionSpec.MODIFY(TRUE);
                UNTIL SPVersionSpec.NEXT = 0;
            UNTIL SPVersion.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure SPLinesExist(): Boolean
    var
        Res: Boolean;
    begin
        Res := FALSE;
        SPVersion.RESET;
        SPVersion.SETRANGE("Package No.","No.");
        IF SPVersion.FINDSET THEN
          REPEAT
            SPVersionSpec.RESET;
            SPVersionSpec.SETRANGE("Package No.","No.");
            SPVersionSpec.SETRANGE("Version No.",SPVersion."Version No.");
            Res := Res OR SPVersionSpec.FINDFIRST
          UNTIL SPVersion.NEXT = 0;
        EXIT(Res);
    end;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        GetServSetup;
        ServSetup.TESTFIELD("Labor Nos.");
        IF NoSeriesMgt.SelectSeries(ServSetup."Service Package Nos.",ServSetup."Service Package Nos.",ServSetup."Service Package Nos.") THEN
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

