table 25006405 "Warranty Document Header"
{
    Caption = 'Warranty Document Header';
    DrillDownPageID = 25006406;
    LookupPageID = 25006406;

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(30; "Service Order Sequence No."; Integer)
        {
            Caption = 'Service Order Sequence No.';
        }
        field(40; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                // 23.04.2015 EDMS P21 >>
                // IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                OnLookupVIN;
                // 23.04.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);

                // 20.02.2015 EDMS P21 >>
                IF VIN = '' THEN BEGIN
                    VALIDATE("Vehicle Serial No.", '');
                    EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY(VIN);
                Vehicle.SETRANGE(VIN, VIN);
                IF Vehicle.FINDFIRST THEN BEGIN
                    IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                        VALIDATE("Vehicle Serial No.", Vehicle."Serial No.")
                END ELSE BEGIN
                    MessageLoc(STRSUBSTNO(Text137, Vehicle.TABLECAPTION, FIELDCAPTION(VIN), VIN), '');
                    //IF "Document Type" <> "Document Type"::Quote THEN
                    VIN := xRec.VIN;
                END;
                // 20.02.2015 EDMS P21 <<
            end;
        }
        field(50; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Registration No." = '' THEN BEGIN
                    VALIDATE("Vehicle Serial No.", '');
                    EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.", "Vehicle Registration No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                    IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                        VALIDATE("Vehicle Serial No.", Vehicle."Serial No.")
                END ELSE BEGIN
                    MessageLoc(STRSUBSTNO(Text131, "Vehicle Registration No."), '');
                    // 20.02.2015 EDMS P21 >>
                    //IF "Document Type" <> "Document Type"::Quote THEN
                    "Vehicle Registration No." := xRec."Vehicle Registration No.";
                    // 20.02.2015 EDMS P21 <<
                END;
            end;
        }
        field(60; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                Model: Record "25006001";
                DocumentMgt: Codeunit "25006000";
                FillCustomer: Boolean;
            begin
                IF "Vehicle Serial No." = '' THEN BEGIN
                    "Vehicle Registration No." := '';
                    "Make Code" := '';
                    "Model Code" := '';
                    "Model Version No." := '';                                // 20.02.2015 EDMS P21
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Status Code" := '';
                    "Model Commercial Name" := '';
                    //VALIDATE("Contract No.", '');                             // 15.04.2014 Elva Baltic P21
                    EXIT;
                END;

                Vehicle.GET("Vehicle Serial No.");
                Vehicle.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                Vehicle.TESTFIELD(Blocked, FALSE);  //08.05.2014 Elva Baltic P8 #S0084 MMG7.00


                VIN := Vehicle.VIN;
                VALIDATE("Vehicle Accounting Cycle No.", Vehicle."Default Vehicle Acc. Cycle No.");
                "Vehicle Registration No." := Vehicle."Registration No.";
                "Make Code" := Vehicle."Make Code";
                "Model Code" := Vehicle."Model Code";
                "Model Version No." := Vehicle."Model Version No.";         // 20.02.2015 EDMS P21
                "Vehicle Status Code" := Vehicle."Status Code";

                IF Model.GET("Make Code", "Model Code") THEN
                    "Model Commercial Name" := Model."Commercial Name"
                ELSE
                    "Model Commercial Name" := Vehicle."Model Commercial Name";


                //IF (Rec."Sell-to Customer No." = xRec."Sell-to Customer No.") AND NOT FindVehicle THEN
                //  FindVehicleCont;

                //UpdateVehicleContact;

                DocumentMgt.ShowVehicleComments("Vehicle Serial No.");

                CheckRecallCampaigns("Vehicle Serial No.");

                //29.09.2011 EDMS P8 >>
                //IF ("Vehicle Serial No." <> xRec."Vehicle Serial No.") AND (xRec."Vehicle Serial No." <> '') THEN
                //  TireManagement.ChangeVehicleInServiceHeader(Rec, xRec."Vehicle Serial No.", "Vehicle Serial No.");
                //29.09.2011 EDMS P8 <<

                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 >>
                //CreateDim(
                //  DATABASE::"Vehicle Status", "Vehicle Status Code",
                //  DATABASE::Customer,"Bill-to Customer No.",
                //  DATABASE::"Salesperson/Purchaser","Service Advisor",
                //  DATABASE::"Responsibility Center","Responsibility Center",
                //  DATABASE::"Deal Type","Deal Type",
                //  DATABASE::Make,"Make Code",
                //  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                //  DATABASE::"Payment Method","Payment Method Code",
                //  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                //  );
                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 <<

                //IF xRec."Vehicle Serial No." <> "Vehicle Serial No." THEN BEGIN               // 15.04.2014 Elva Baltic P21
                //  FindContract;                                                               // 15.04.2014 Elva Baltic P21
                //  SetHideValidationDialog(FALSE);                                             // 23.04.2015 EDMS P21
                //  RecreateDmsServLines(FIELDCAPTION("Vehicle Serial No."));                   // 16.03.2015 EDMS P21
                //END;
            end;
        }
        field(70; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(75; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recDimValue: Record "349";
            begin
                //CreateDim(
                //  DATABASE::"Vehicle Status", "Vehicle Status Code",
                //  DATABASE::Customer,"Bill-to Customer No.",
                //  DATABASE::"Salesperson/Purchaser","Service Advisor",
                //  DATABASE::"Responsibility Center","Responsibility Center",
                //  DATABASE::"Deal Type","Deal Type",
                //  //DATABASE::Vehicle,VIN,
                //  DATABASE::Make,"Make Code",
                //  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                //  DATABASE::"Payment Method","Payment Method Code",
                //  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                //  );

                //04.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                //RecreateDmsServLines(FIELDCAPTION("Vehicle Status Code"));
                //04.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(80; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);

                // 16.03.2015 EDMS P21 >>
                IF ("Make Code" <> xRec."Make Code") AND ("Model Code" <> '') THEN
                    VALIDATE("Model Code", '');
                // 16.03.2015 EDMS P21 <<
            end;
        }
        field(90; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(100;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                Item: Record "27";
            begin
                // 20.02.2015 EDMS P21 >>
                IF LookUpMgt.LookUpModelVersion(Item, "Model Version No.", "Make Code", "Model Code") THEN
                  VALIDATE("Model Version No.", Item."No.");
                // 20.02.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
            end;
        }
        field(110;"Model Commercial Name";Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE (Make Code=FIELD(Make Code),
                                                                Code=FIELD(Model Code)));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;"Variable Field Run 1";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006180';
            DecimalPlaces = 0:0;

            trigger OnValidate()
            begin
                TestVFRun1;
                CheckServicePlan(FIELDNO("Variable Field Run 1"));
            end;
        }
        field(130;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006255';

            trigger OnValidate()
            begin
                TestVFRun2;
                CheckServicePlan(FIELDNO("Variable Field Run 2"));
            end;
        }
        field(140;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006260';

            trigger OnValidate()
            begin
                TestVFRun3;
                CheckServicePlan(FIELDNO("Variable Field Run 3"));
            end;
        }
        field(150;"Claim Job Type";Code[20])
        {
            Caption = 'Claim Job Type';
            TableRelation = "Claim Job Type";
        }
        field(160;"Symptom Code";Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code EDMS".Code WHERE (Make Code=FIELD(Make Code));
        }
        field(170;"Recal Campaign Code";Code[20])
        {
            Caption = 'Recal Campaign';
            TableRelation = "Recall Campaign";
        }
        field(180;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF CurrFieldNo <> FIELDNO("Currency Code") THEN
                 UpdateCurrencyFactor
                ELSE
                 BEGIN
                  IF "Currency Code" <> xRec."Currency Code" THEN
                   BEGIN
                    UpdateCurrencyFactor;
                    //RecreateDmsServLines(FIELDCAPTION("Currency Code"));
                   END
                  ELSE
                   IF "Currency Code" <> '' THEN
                    BEGIN
                     UpdateCurrencyFactor;
                     IF "Currency Factor" <> xRec."Currency Factor" THEN
                      ConfirmUpdateCurrencyFactor;
                    END;
                 END;
            end;
        }
        field(185;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                //IF "Currency Factor" <> xRec."Currency Factor" THEN
                 //UpdateDMSServLines(FIELDCAPTION("Currency Factor"),FALSE);
            end;
        }
        field(190;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(200;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(210;"Posting Date";Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                NoSeries: Record "308";
            begin
                /*
                TestNoSeriesDate(
                  "Posting No.","Posting No. Series",
                  FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.","Prepayment No. Series",
                  FIELDCAPTION("Prepayment No."),FIELDCAPTION("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.","Prepmt. Cr. Memo No. Series",
                  FIELDCAPTION("Prepmt. Cr. Memo No."),FIELDCAPTION("Prepmt. Cr. Memo No. Series"));
                
                VALIDATE("Document Date","Posting Date");
                
                IF ("Document Type" IN ["Document Type"::"Return Order","Document Type"::Booking]) AND NOT ("Posting Date" = xRec."Posting Date")
                THEN
                 PriceMessageIfServLinesExist(FIELDCAPTION("Posting Date"));
                
                IF "Currency Code" <> '' THEN
                 BEGIN
                  UpdateCurrencyFactor;
                  IF "Currency Factor" <> xRec."Currency Factor" THEN
                   ConfirmUpdateCurrencyFactor;
                 END;
                */

            end;
        }
        field(220;"Document Date";Date)
        {
        }
        field(230;"Prices Including VAT";Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                Currency: Record "4";
                RecalculatePrice: Boolean;
                SalesHeader: Record "36";
                ServLine: Record "25006146";
                ServLineCopy: Record "25006146";
            begin
                /*
                TESTFIELD(Status,Status::Open);
                
                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                
                 SalesHeader.RESET;
                 SalesHeader.SETCURRENTKEY("Service Document No.");
                 SalesHeader.SETFILTER("Document Type",'%1|%2',SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::"Credit Memo");
                 SalesHeader.SETRANGE("Service Document No.","No.");
                 IF SalesHeader.FINDFIRST THEN
                  ERROR(Text101);
                
                  ServLine.SETRANGE("Document Type","Document Type");
                  ServLine.SETRANGE("Document No.","No.");
                  ServLine.SETFILTER("Unit Price",'<>%1',0);
                  ServLine.SETFILTER("VAT %",'<>%1',0);
                  IF ServLine.FINDFIRST THEN BEGIN
                    RecalculatePrice :=
                      ConfirmLoc(
                        STRSUBSTNO(
                          Text024 +
                          Text026,
                          FIELDCAPTION("Prices Including VAT"),ServLine.FIELDCAPTION("Unit Price")),
                        TRUE, '');
                    ServLine.SetServHeader(Rec);
                
                    IF "Currency Code" = '' THEN
                      Currency.InitRoundingPrecision
                    ELSE
                      Currency.GET("Currency Code");
                    ServLine.LOCKTABLE;
                    LOCKTABLE;
                    ServLine.FINDSET;
                    REPEAT
                      //27.08.2007. EDMS P2 >>
                      ServLine.TESTFIELD("Prepayment %", 0);
                      //27.08.2007. EDMS P2 <<
                
                      ServLineCopy := ServLine;
                      ServLine.TESTFIELD("Prepmt. Amt. Inv.",0); //08-05-2007 EDMS P3 PREPMT
                      IF NOT RecalculatePrice THEN BEGIN
                        ServLine."VAT Difference" := 0;
                        ServLine.InitOutstandingAmount;
                      END ELSE
                        IF "Prices Including VAT" THEN BEGIN
                          ServLine."Unit Price" :=
                            ROUND(
                              ServLine."Unit Price" * (1 + (ServLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF ServLine.Quantity <> 0 THEN BEGIN
                            ServLine."Line Discount Amount" :=
                              ROUND(
                                ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            ServLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                ServLine."Inv. Discount Amount" * (1 + (ServLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                            ServLine.UpdateAmounts
                
                          END;
                        END ELSE BEGIN
                          ServLine."Unit Price" :=
                            ROUND(
                              ServLine."Unit Price" / (1 + (ServLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF ServLine.Quantity <> 0 THEN BEGIN
                            ServLine."Line Discount Amount" :=
                              ROUND(
                                ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            ServLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                ServLine."Inv. Discount Amount" / (1 + (ServLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                            ServLine.UpdateAmounts
                          END;
                        END;
                      ServLine.MODIFY;
                    UNTIL ServLine.NEXT = 0;
                  END;
                END;
                */

            end;
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

    trigger OnDelete()
    var
        WarrantyDocumentLine: Record "25006406";
    begin
        WarrantyDocumentLine.RESET;
        WarrantyDocumentLine.SETRANGE("Document No.","No.");
        WarrantyDocumentLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        WarrantySetup.GET;

        IF "No." = '' THEN
         BEGIN
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
         END;

        InitRecord;
    end;

    var
        Vehicle: Record "25006005";
        HideValidationDialog: Boolean;
        EDMS001: Label '%1 cannot be less than in previous visit.';
        Text021: Label 'Do you want to update the exchange rate?';
        Text102: Label 'Pending service plan No. %1 exists for this vehicle.';
        Text121: Label 'The vehicle %1 %2, registration number %3,  VIN %4 exists in %5 other service orders.';
        Text131: Label 'There is no vehicle with Registration No. %1';
        Text137: Label 'There is no %1 with %2 %3';
        LookUpMgt: Codeunit "25006003";
        tcSER001: Label 'The vehicle %1 %2, registration number %3,  VIN %4 exists on another service order.';
        ServiceSetup: Record "25006120";
        Text130: Label 'There are one or more pending recall campaigns for VIN %1. Please check recall campaign details';
        WarrantySetup: Record "25006408";
        WarrantyHeader: Record "25006405";
        AppMgt: Codeunit "1";
        CurrExchRate: Record "330";
        CurrencyDate: Date;
        Confirmed: Boolean;
        NoSeriesMgt: Codeunit "396";
        Text051: Label 'The Warranty Document %1 already exists.';

    [Scope('Internal')]
    procedure InitRecord()
    var
        LocCodeFilterStr: Code[20];
        SingleQuote: Char;
    begin
        IF "Posting Date" = 0D THEN
          "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        EXIT(WarrantySetup."Warranty Document Nos.");
    end;

    local procedure TestNoSeries(): Boolean
    begin
        WarrantySetup.TESTFIELD("Warranty Document Nos.");
    end;

    [Scope('Internal')]
    procedure AssistEdit(OldWarrantyHeader: Record "25006405"): Boolean
    var
        WarrantyHeader2: Record "25006405";
    begin
        WITH WarrantyHeader DO BEGIN
          COPY(Rec);
          WarrantySetup.GET;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldWarrantyHeader."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            IF WarrantyHeader2.GET("No.") THEN
              ERROR(Text051,"No.");
            Rec := WarrantyHeader;
            EXIT(TRUE);
          END;
        END;
    end;

    [Scope('Internal')]
    procedure MessageLoc(MessageTxt: Text[1024];RunParStr: Text[1024])
    begin
        // RunParStr not used for now
        IF NOT HideValidationDialog THEN
          MESSAGE(MessageTxt);
    end;

    [Scope('Internal')]
    procedure ConfirmLoc(MessageTxt: Text[1024];ActiveButton: Boolean;RunParStr: Text[1024]): Boolean
    begin
        // RunParStr not used for now
        IF HideValidationDialog THEN
          EXIT(TRUE)
        ELSE
          EXIT(CONFIRM(MessageTxt,ActiveButton));
    end;

    [Scope('Internal')]
    procedure OnLookupVehicleRegistrationNo()
    begin
        IF "Vehicle Registration No." <> '' THEN BEGIN
          Vehicle.RESET;
          Vehicle.SETCURRENTKEY("Registration No.");
          Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
          IF Vehicle.FINDFIRST THEN;
          Vehicle.SETRANGE("Registration No.");
        END;

        IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
         VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
    end;

    [Scope('Internal')]
    procedure OnLookupVIN()
    var
        Vehicle: Record "25006005";
    begin
        IF LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") THEN
          VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
    end;

    [Scope('Internal')]
    procedure CheckRecallCampaigns(VehSerialNo: Code[20])
    var
        Vehicle: Record "25006005";
        RecallCampaignVeh: Record "25006172";
    begin
        Vehicle.RESET;
        IF NOT Vehicle.GET(VehSerialNo) THEN
         EXIT;

        ServiceSetup.GET;
        IF NOT ServiceSetup."Recall Campaign Warnings" THEN
         EXIT;

        RecallCampaignVeh.RESET;
        RecallCampaignVeh.SETRANGE(VIN,Vehicle.VIN);
        IF RecallCampaignVeh.FINDFIRST THEN
         REPEAT
          RecallCampaignVeh.CALCFIELDS("Active Campaign");
          IF (RecallCampaignVeh."Active Campaign") AND NOT RecallCampaignVeh.Serviced THEN
            MessageLoc(STRSUBSTNO(Text130,Vehicle.VIN), '');
         UNTIL RecallCampaignVeh.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure TestVFRun1()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        //14.09.2007. P2 >>
        IF "Variable Field Run 1" > 0 THEN BEGIN
          IF "Variable Field Run 1" < ServOrdInfoPaneMgt.CalcLastVisitVFRun1("Vehicle Serial No.") THEN
            MessageLoc(STRSUBSTNO(EDMS001, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE,'7,25006145,25006180')), '');
          TestVFRun1ForComponent;
        END;
        //14.09.2007. P2 <<
    end;

    [Scope('Internal')]
    procedure TestVFRun2()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        IF "Variable Field Run 2" > 0 THEN BEGIN
          IF "Variable Field Run 2" < ServOrdInfoPaneMgt.CalcLastVisitVFRun2("Vehicle Serial No.") THEN
            MessageLoc(STRSUBSTNO(EDMS001, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE,'7,25006145,25006255')), '');
          TestVFRun1ForComponent;
        END;
    end;

    [Scope('Internal')]
    procedure TestVFRun3()
    var
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        IF "Variable Field Run 3" > 0 THEN BEGIN
          IF "Variable Field Run 3" < ServOrdInfoPaneMgt.CalcLastVisitVFRun3("Vehicle Serial No.") THEN
            MessageLoc(STRSUBSTNO(EDMS001, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE,'7,25006145,25006260')), '');
          TestVFRun1ForComponent;
        END;
    end;

    [Scope('Internal')]
    procedure CheckServicePlan(FieldPar: Integer)
    var
        VehicleServicePlanStage: Record "25006132";
        PlanDateFormula: Code[20];
    begin
        IF "Vehicle Serial No." = '' THEN
          EXIT;
        ServiceSetup.GET;

        IF NOT ServiceSetup."Service Plan Notification" THEN
          EXIT;

        IF IsAchievedServPlanStageByField(FieldPar, VehicleServicePlanStage) THEN
          MessageLoc(STRSUBSTNO(Text102, VehicleServicePlanStage."Plan No."), '');
    end;

    [Scope('Internal')]
    procedure TestVFRun1ForComponent()
    var
        VehicleServicePlanStage: Record "25006132";
        ServOrdInfoPaneMgt: Codeunit "25006104";
        CompPendingPlanExists: Boolean;
    begin
        /*
        // for now do not check actual value
        ServiceSetup.GET;
        IF ServiceSetup."Notify About Components" THEN
          IF NOT (("Document Type" = LastModifiedRec."Document Type") AND ("No." = LastModifiedRec."No.")) THEN
            AboutComponentsNotified := FALSE;
          LastModifiedRec := Rec;
          IF NOT AboutComponentsNotified THEN BEGIN
            VehicleComponent.RESET;
            VehicleComponent.SETRANGE("Parent Vehicle Serial No.", "Vehicle Serial No.");
            IF VehicleComponent.FINDFIRST THEN
              REPEAT
                VehicleServicePlanStage.RESET;
                VehicleServicePlanStage.SETCURRENTKEY(Status,"Expected Service Date");
                VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
                VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", VehicleComponent."No.");
                CompPendingPlanExists := VehicleServicePlanStage.FINDFIRST;
              UNTIL ((VehicleComponent.NEXT = 0) OR CompPendingPlanExists);
              IF CompPendingPlanExists THEN BEGIN
                MessageLoc(Text132, '');
                AboutComponentsNotified := TRUE;
              END;
          END;
        */

    end;

    [Scope('Internal')]
    procedure IsAchievedServPlanStageByField(FieldPar: Integer;var VehicleServicePlanStage: Record "25006132"): Boolean
    var
        VehicleServicePlan: Record "25006126";
        PlanDateFormula: Code[20];
        MakeCheck: Boolean;
    begin
        ServiceSetup.GET;
        
        VehicleServicePlanStage.RESET;
        VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
        /*
        CASE FieldPar OF
          FIELDNO("Variable Field Run 1"):
            BEGIN
              IF ("Variable Field Run 1" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 1", 0.0000000001,
                                               "Variable Field Run 1" + ServiceSetup."Notify Before (VF Run 1)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 1" = 0) THEN
                  EXIT(FALSE);
            END;
          FIELDNO("Variable Field Run 2"):
            BEGIN
              IF ("Variable Field Run 2" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 2", 0.0000000001,
                                               "Variable Field Run 2" + ServiceSetup."Notify Before (VF Run 2)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 2" = 0) THEN
                  EXIT(FALSE);
            END;
          FIELDNO("Variable Field Run 3"):
            BEGIN
              IF ("Variable Field Run 3" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 3", 0.0000000001,
                                               "Variable Field Run 3" + ServiceSetup."Notify Before (VF Run 3)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 3" = 0) THEN
                  EXIT(FALSE);
            END;
          FIELDNO("Order Date"):
            BEGIN
              IF ("Order Date" = 0D) THEN
                EXIT(FALSE);
              //08.05.2013 EDMS P8 >>
              EXIT(IsAchievedServStageByInterval(VehicleServicePlanStage));
              //08.05.2013 EDMS P8 <<
              {
              PlanDateFormula := '-' +FORMAT(ServiceSetup."Notify Before (Date Formula)");
              VehicleServicePlanStage.SETRANGE("Expected Service Date",
                                               010101D,
                                               CALCDATE(ServiceSetup."Notify Before (Date Formula)","Order Date"));
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Expected Service Date" = 0D) THEN
                  EXIT(FALSE);
              }
            END;
        END;
        */
        EXIT(VehicleServicePlanStage.FINDFIRST);

    end;

    local procedure UpdateCurrencyFactor()
    begin
        IF "Currency Code" <> '' THEN BEGIN
          CurrencyDate := WORKDATE;
          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        END ELSE
          "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        Confirmed := ConfirmLoc(Text021, FALSE, '');
        IF Confirmed THEN
          VALIDATE("Currency Factor")
        ELSE
          "Currency Factor" := xRec."Currency Factor";
    end;
}

