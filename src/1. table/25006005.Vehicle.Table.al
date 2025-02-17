table 25006005 Vehicle
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified OnInsert(), Usert Profile Setup to Branch Profile Setup
    // 
    // 21.05.2014 Elva Baltic P8 #Exxx MMG7.00
    //   * Fix in TestNoOpenEntriesExist - to check previos model Version no.
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added to DropDown Field Group:
    //     "Registration No."
    // 
    // 11.10.2013 EDMS P8
    //   * Added check of open ledger entries
    // 
    // 05.06.2013 EDMS P15
    //    * Added Filter ["Make Code"|''] into following Lookup Pages:
    //        Field             Page
    //      - "Interior Code"   "Vehicle Interior"
    //      - "Body Color Code" "Body Color"
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management
    // 
    // 28.02.2008. EDMS P2
    //   * Added code Make Code - OnValidate, Model Code - OnValidate
    // 
    // 26.11.2007. EDMS P2
    //         * Changed Comment Flowfield condition
    // 
    // 16.08.2007. EDMS P2
    //   * Added code in trigger OnDelete
    // 
    // 07-08-2007 EDMS P3
    //   * Added fields "Company Contact No.","Contact Company Name","Contact Name"
    // 
    // 26.07.2007. EDMS P2
    //   * Added field "Vehicle Contact Phone No."
    // 
    // 18.07.2007. EDMS P2
    //   * Added code in trigger "Registration No." - OnValidate
    // 
    // 25.01.2007. DMS P2
    //   added new fields

    Caption = 'Vehicle';
    DataCaptionFields = "Serial No.", VIN;
    DataPerCompany = false;
    DrillDownPageID = 25006033;
    LookupPageID = 25006033;

    fields
    {
        field(4; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
                tcDMS001: Label 'You can not delete value of %1 field .';
                tcDMS002: Label 'Vehicle %1 %2 already exists.';
            begin
                IF (Rec."Serial No." = '') AND (xRec."Serial No." <> '') THEN
                    ERROR(tcDMS001, FIELDCAPTION("Serial No."));

                IF (Rec."Serial No." = '') AND (xRec."Serial No." = '') THEN
                    EXIT;
            end;
        }
        field(8; VIN; Code[20])
        {
            Caption = 'VIN';
            NotBlank = true;

            trigger OnValidate()
            begin
                CheckDublicates; //Checking for dublicates

                // mar 25, 2015 ZM
                /*
                "Make Code" := '';
                "Model Code" := '';
                "Model Version No." := '';
                "Variable Field 25006808" := '';
                */
                VINDecode.Decode2(Rec);
                VehChangeLogMgt.fRegisterChange(Rec, xRec, FIELDNO(VIN));

                //SM Agni
                VIN := DELCHR(VIN, '=', '-\/!|@|#|$|%_)(^*&');
                VIN := DELCHR(VIN, '=', ' ');
                //SM Agni

            end;
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;

            trigger OnValidate()
            begin
                //28.02.2008. EDMS P2 >>
                IF "Make Code" <> xRec."Make Code" THEN
                    VALIDATE("Model Code", '');
                //28.02.2008. EDMS P2 >>

                CheckSerialNoInItemLedgerEntry(FIELDCAPTION("Make Code")); // mar 25, 2015 ZM
            end;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE("Make Code" = FIELD("Make Code"));

            trigger OnValidate()
            begin
                //28.02.2008. EDMS P2 >>
                IF "Model Code" <> xRec."Model Code" THEN
                    VALIDATE("Model Version No.", '');
                //28.02.2008. EDMS P2 >>

                CheckSerialNoInItemLedgerEntry(FIELDCAPTION("Model Code"));  // mar 25, 2015 ZM
            end;
        }
        field(25; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." WHERE("Make Code" = FIELD("Make Code"),
                                            "Model Code" = FIELD("Model Code"),
                                            "Item Type" = CONST("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.RESET;
                IF LookupMgt.LookUpModelVersion(recItem, "Model Version No.", "Make Code", "Model Code") THEN
                    VALIDATE("Model Version No.", recItem."No.");
            end;

            trigger OnValidate()
            begin
                CheckSerialNoInItemLedgerEntry(FIELDCAPTION("Model Version No."));  // mar 25, 2015 ZM
                // assign var fields from 'Model Version Specification'
                IF xRec."Model Version No." <> '' THEN
                    IF "Model Version No." <> xRec."Model Version No." THEN
                        TestNoOpenEntriesExist(FIELDCAPTION("Model Version No."));  //11.10.2013 EDMS P8

                FillVariableFieldsFromSpecific;
            end;
        }
        field(30; "Model Commercial Name"; Text[50])
        {
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Model."Commercial Name" WHERE("Make Code" = FIELD("Make Code"),
                                                                Code = FIELD("Model Code")));
        }
        field(46; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Service Comment Line EDMS" WHERE(Type = CONST(Vehicle),
                                                                   "No." = FIELD("Serial No.")));
        }
        field(50; "Production Year"; Code[4])
        {
            Caption = 'Production Year';
        }
        field(70; "Registration No."; Code[30])
        {
            Caption = 'Registration No.';

            trigger OnValidate()
            var
                VehicleLoc: Record Vehicle;
                SalesLine: Record "Sales Line";
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
                GenJournalLine: Record "Gen. Journal Line";
                ItemJournalLine: Record "Item Journal Line";
                TransferLine: Record "Transfer Line";
                ServiceHeader: Record "Service Header EDMS";
            begin
                ServiceMgtSetup.GET;
                IF ServiceMgtSetup."Control Veh. Reg. No. Dubl." <> ServiceMgtSetup."Control Veh. Reg. No. Dubl."::No THEN BEGIN
                    IF ("Registration No." <> '') AND ("Registration No." <> xRec."Registration No.") THEN BEGIN
                        VehicleLoc.RESET;
                        VehicleLoc.SETCURRENTKEY("Registration No.");
                        VehicleLoc.SETRANGE("Registration No.", "Registration No.");
                        IF VehicleLoc.FINDFIRST THEN BEGIN
                            IF ServiceMgtSetup."Control Veh. Reg. No. Dubl." = ServiceMgtSetup."Control Veh. Reg. No. Dubl."::Warning THEN
                                MESSAGE(EDMS001)
                            ELSE
                                ERROR(EDMS001);
                        END;
                    END;
                END;

                IF "Registration No." <> xRec."Registration No." THEN BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Vehicle Serial No.", "Serial No.");
                    SalesLine.MODIFYALL("Vehicle Registration No.", "Registration No.");
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("Vehicle Serial No.", "Serial No.");
                    PurchaseHeader.MODIFYALL("Vehicle Registration No.", "Registration No.");
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Vehicle Serial No.", "Serial No.");
                    PurchaseLine.MODIFYALL("Vehicle Registration No.", "Registration No.");
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Vehicle Serial No.", "Serial No.");
                    GenJournalLine.MODIFYALL("Vehicle Registration No.", "Registration No.");
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Vehicle Serial No.", "Serial No.");
                    ItemJournalLine.MODIFYALL("Vehicle Registration No.", "Registration No.");
                    TransferLine.RESET;
                    TransferLine.SETRANGE("Vehicle Serial No.", "Serial No.");
                    TransferLine.MODIFYALL("Vehicle Registration No.", "Registration No.");
                    ServiceHeader.RESET;
                    ServiceHeader.SETRANGE("Vehicle Serial No.", "Serial No.");
                    ServiceHeader.MODIFYALL("Vehicle Registration No.", "Registration No.");
                END;

                VehChangeLogMgt.fRegisterChange(Rec, xRec, FIELDNO("Registration No."));
                //SM Agni
                "Registration No." := DELCHR("Registration No.", '=', '\/!|@|#|$|%_)(^*&');
                "Registration No." := DELCHR("Registration No.", '=', ' ');
                //SM Agni
            end;
        }
        field(150; "Status Code"; Code[20])
        {
            Caption = 'Status Code';
            Editable = true;
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recVehStatus: Record "Vehicle Status";
            begin
                IF recVehStatus.GET("Status Code") THEN
                    IF recVehStatus."Vehicle Status Group Code" <> '' THEN
                        VALIDATE("Status Group Code", recVehStatus."Vehicle Status Group Code");

                VehChangeLogMgt.fRegisterChange(Rec, xRec, FIELDNO("Status Code"));
            end;
        }
        field(154; "Status Group Code"; Code[20])
        {
            Caption = 'Vehicle Status Group Code';
            Editable = false;
            TableRelation = "Vehicle Status Group";
        }
        field(270; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(280; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(290; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(300; "Global Dimension 1 Code Filter"; Code[10])
        {
            Caption = 'Department Filter';
            FieldClass = FlowFilter;
        }
        field(310; "Global Dimension 2 Code Filter"; Code[10])
        {
            Caption = 'Make Filter';
            FieldClass = FlowFilter;
        }
        field(330; Kilometrage; Decimal)
        {
            CaptionClass = '7,25006005,330';
            DecimalPlaces = 0 : 0;
        }
        field(331; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006005,331';
        }
        field(332; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006005,332';
        }
        field(340; "Sales Date"; Date)
        {
            Caption = 'Sales Date';

            trigger OnValidate()
            begin
                CreateContactSheet;

                "Sales Date (BS)" := GblSTPLSysMngt.getNepaliDate("Sales Date");
            end;
        }
        field(670; Inventory; Decimal)
        {
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Serial No." = FIELD("Serial No.")));
        }
        field(730; Reserved; Boolean)
        {
            Caption = 'Reserved';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE("Vehicle Serial No." = FIELD("Serial No.")));
        }
        field(770; "Tracking Code"; Code[10])
        {
            Caption = 'Tracking Code';
            TableRelation = "Vehicle Tracking Code";

            trigger OnValidate()
            var
                recVehicleStatus: Record "Vehicle Tracking Code";
            begin
                IF recVehicleStatus.GET("Tracking Code") THEN BEGIN
                    "Tracking Description" := recVehicleStatus.Description;
                END
                ELSE BEGIN
                    "Tracking Description" := '';
                END;

                VehChangeLogMgt.fRegisterChange(Rec, xRec, FIELDNO("Tracking Code"));
            end;
        }
        field(780; "Tracking Description"; Text[30])
        {
            Caption = 'Vehicle Tracking Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Vehicle Tracking Code".Description WHERE(Code = FIELD("Tracking Code")));
        }
        field(790; "Parent Component"; Code[20])
        {
            Caption = 'Parent Component';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Vehicle Component"."Parent Vehicle Serial No." WHERE("No." = FIELD("Serial No."),
                                                                                        Active = CONST(true)));
        }
        field(800; Components; Boolean)
        {
            Caption = 'Components';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Vehicle Component" WHERE("Parent Vehicle Serial No." = FIELD("Serial No."),
                                                           Active = CONST(true)));
        }
        field(1100; "Body Color Code"; Code[20])
        {
            Caption = 'Body Color Code';
            TableRelation = "Body Color".Code;

            trigger OnLookup()
            var
                BodyColor: Record "Body Color";
            begin
                // 05.06.2013 EDMS P15 >>
                BodyColor.SETFILTER("Make Code", '%1|%2', "Make Code", '');
                IF PAGE.RUNMODAL(PAGE::"Body Colors", BodyColor) = ACTION::LookupOK THEN BEGIN
                    "Body Color Code" := BodyColor.Code;
                END;
                //05.06.2013 EDMS P15 <<
            end;
        }
        field(1200; "Interior Code"; Code[10])
        {
            Caption = 'Interior Code';
            TableRelation = "Vehicle Interior".Code;

            trigger OnLookup()
            var
                VehicleInterior: Record "Vehicle Interior";
            begin
                // 05.06.2013 EDMS P15 >>
                VehicleInterior.SETFILTER("Make Code", '%1|%2', "Make Code", '');
                IF PAGE.RUNMODAL(PAGE::"Vehicle Interiors", VehicleInterior) = ACTION::LookupOK THEN BEGIN
                    "Interior Code" := VehicleInterior.Code;
                END;
                //05.06.2013 EDMS P15 <<
            end;
        }
        field(2000; "Type Code"; Code[20])
        {
            Caption = 'Type Code';
            TableRelation = "Vehicle Type";
        }
        field(3000; "First Registration Date"; Date)
        {
            Caption = 'First Registration Date';

            trigger OnValidate()
            begin
                "First Registration Date (BS)" := GblSTPLSysMngt.getNepaliDate("First Registration Date");
            end;
        }
        field(3100; "Registration Certificate No."; Code[20])
        {
            Caption = 'Registration Certificate No.';
        }
        field(3200; "Serv. Ledger Entry Exist"; Boolean)
        {
            CalcFormula = Exist("Service Ledger Entry EDMS" WHERE(Vehicle Serial No.=FIELD(Serial No.),
                                                                   Posting Date=FIELD(Date Filter)));
            Caption = 'Serv. Ledger Entry Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3300;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(3400;"Fixed Asset No.";Code[20])
        {
            Caption = 'Fixed Asset No.';
            TableRelation = "Fixed Asset".No.;

            trigger OnValidate()
            begin
                //Reset Old fixed asset
                IF FixedAsset.GET(xRec."Fixed Asset No.") THEN BEGIN
                  FixedAsset."Vehicle Serial No." := '';
                  FixedAsset.MODIFY;
                END;
                //Set New fixed asset
                IF FixedAsset.GET("Fixed Asset No.") THEN BEGIN
                  FixedAsset."Vehicle Serial No." := "Serial No.";
                  FixedAsset.MODIFY;
                END;
            end;
        }
        field(3500;"Next Vehicle Inspection Date";Date)
        {
            Caption = 'Next Vehicle Inspection Date';
        }
        field(50000;"Custom Clearance Memo No.";Code[20])
        {
            CalcFormula = Lookup("CC Memo Line"."Reference No." WHERE (Chasis No.=FIELD(VIN)));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "CC Memo Header"."Reference No.";
        }
        field(50001;"Insurance Memo No.";Code[20])
        {
            CalcFormula = Max("Ins. Memo Line"."Reference No." WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003;"Insurance Policy No.";Code[50])
        {
            CalcFormula = Max("Vehicle Insurance"."Insurance Policy No." WHERE (Vehicle Serial No.=FIELD(UPPERLIMIT(Serial No.)),
                                                                                Cancelled=CONST(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004;"Item Charges Applied";Boolean)
        {
            CalcFormula = Exist("Value Entry" WHERE (Item No.=FIELD(Model Version No.),
                                                     Item Charge No.=FILTER(<>'')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005;"Sales Invoice No.";Code[20])
        {
            CalcFormula = Max("Sales Invoice Line"."Document No." WHERE (Vehicle Serial No.=FIELD(UPPERLIMIT(Serial No.))));
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                SalesInvHeader.RESET;
                SalesInvHeader.SETRANGE("No.","Sales Invoice No.");
                IF SalesInvHeader.FINDFIRST THEN
                  PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",SalesInvHeader);
            end;
        }
        field(50006;"Purchase Receipt Date";Date)
        {
            CalcFormula = Max("Item Ledger Entry"."Posting Date" WHERE (Serial No.=FIELD(Serial No.),
                                                                        Document Type=CONST(Purchase Receipt)));
            Description = 'Used to Calculate vehicle aging from the purchase receipt date in case of transfer//chandra (jet reports)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007;"Purchase Order Date";Date)
        {
            CalcFormula = Lookup("Item Ledger Entry"."Document Date" WHERE (Serial No.=FIELD(Serial No.),
                                                                            Document Type=CONST(Purchase Receipt)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008;"Ins. Payment Memo No.";Code[20])
        {
            CalcFormula = Max("Ins. Payment Memo Line".No. WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009;"Commission Posted";Boolean)
        {
            Editable = false;
        }
        field(50010;Registered;Boolean)
        {
            Editable = true;
        }
        field(50011;"Registration Amount";Decimal)
        {
            Editable = false;
        }
        field(50012;"Blocked by VFD";Boolean)
        {
            Description = 'Blocked by VFD for critical loan, do not generate service gatepass if this is true';
        }
        field(50050;"Purchase Invoice";Code[20])
        {
            CalcFormula = Max("Purch. Inv. Line"."Document No." WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50051;"Purchase Invoice Date";Date)
        {
            CalcFormula = Lookup("Purch. Inv. Line"."Posting Date" WHERE (Vehicle Serial No.=FIELD(Serial No.),
                                                                          Type=FILTER(Item)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50052;"Purchase Invoice Date (Real)";Date)
        {
        }
        field(50053;"Commercial Invoice No.";Code[20])
        {
        }
        field(50054;"Production Years";Code[4])
        {
        }
        field(50055;"Previous KM";Decimal)
        {
        }
        field(50056;"Updated By";Text[40])
        {
        }
        field(70001;"VAT Amount on Sales";Decimal)
        {
        }
        field(70002;"Sales Price After VAT";Decimal)
        {
        }
        field(25006379;"Default Vehicle Acc. Cycle No.";Code[20])
        {
            CalcFormula = Lookup("Vehicle Accounting Cycle".No. WHERE (Vehicle Serial No.=FIELD(Serial No.),
                                                                       Default=CONST(Yes)));
            Caption = 'Default Vehicle Acc. Cycle No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Vehicle Accounting Cycle";
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006005,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006800"),
                  "Make Code","Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006005,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006801"),
                  "Make Code","Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006005,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006802"),
                  "Make Code","Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006803;"Variable Field 25006803";Code[20])
        {
            CaptionClass = '7,25006005,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006803"),
                  "Make Code","Variable Field 25006803") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006803",VFOptions.Code);
                 END;
                VALIDATE("Engine No.","Variable Field 25006803");
            end;

            trigger OnValidate()
            begin
                "Engine No." := "Variable Field 25006803";
            end;
        }
        field(25006804;"Variable Field 25006804";Code[20])
        {
            CaptionClass = '7,25006005,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006804"),
                  "Make Code","Variable Field 25006804") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006804",VFOptions.Code);
                 END;
            end;
        }
        field(25006805;"Variable Field 25006805";Code[20])
        {
            CaptionClass = '7,25006005,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006805"),
                  "Make Code","Variable Field 25006805") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006805",VFOptions.Code);
                 END;
            end;
        }
        field(25006806;"Variable Field 25006806";Code[20])
        {
            CaptionClass = '7,25006005,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006806"),
                  "Make Code","Variable Field 25006806") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006806",VFOptions.Code);
                 END;
            end;
        }
        field(25006807;"Variable Field 25006807";Code[20])
        {
            CaptionClass = '7,25006005,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006807"),
                  "Make Code","Variable Field 25006807") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006807",VFOptions.Code);
                 END;
            end;
        }
        field(25006808;"Variable Field 25006808";Code[20])
        {
            CaptionClass = '7,25006005,25006808';
            Editable = false;

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006808"),
                  "Make Code","Variable Field 25006808") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006808",VFOptions.Code);
                 END;
            end;
        }
        field(25006809;"Variable Field 25006809";Code[20])
        {
            CaptionClass = '7,25006005,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006809"),
                  "Make Code","Variable Field 25006809") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006809",VFOptions.Code);
                 END;
            end;
        }
        field(25006810;"Variable Field 25006810";Code[20])
        {
            CaptionClass = '7,25006005,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006810"),
                  "Make Code","Variable Field 25006810") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006810",VFOptions.Code);
                 END;
            end;
        }
        field(25006811;"Variable Field 25006811";Code[20])
        {
            CaptionClass = '7,25006005,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006811"),
                  "Make Code","Variable Field 25006811") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006811",VFOptions.Code);
                 END;
            end;
        }
        field(25006812;"Variable Field 25006812";Code[20])
        {
            CaptionClass = '7,25006005,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006812"),
                  "Make Code","Variable Field 25006812") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006812",VFOptions.Code);
                 END;
            end;
        }
        field(25006813;"Variable Field 25006813";Code[20])
        {
            CaptionClass = '7,25006005,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006813"),
                  "Make Code","Variable Field 25006813") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006813",VFOptions.Code);
                 END;
            end;
        }
        field(25006814;"Variable Field 25006814";Code[20])
        {
            CaptionClass = '7,25006005,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006814"),
                  "Make Code","Variable Field 25006814") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006814",VFOptions.Code);
                 END;
            end;
        }
        field(25006815;"Variable Field 25006815";Code[20])
        {
            CaptionClass = '7,25006005,25006815';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006815"),
                  "Make Code","Variable Field 25006815") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006815",VFOptions.Code);
                 END;
            end;
        }
        field(25006816;"Variable Field 25006816";Code[20])
        {
            CaptionClass = '7,25006005,25006816';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006816"),
                  "Make Code","Variable Field 25006816") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006816",VFOptions.Code);
                 END;
            end;
        }
        field(25006817;"Variable Field 25006817";Code[20])
        {
            CaptionClass = '7,25006005,25006817';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006817"),
                  "Make Code","Variable Field 25006817") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006817",VFOptions.Code);
                 END;
            end;
        }
        field(25006818;"Variable Field 25006818";Code[20])
        {
            CaptionClass = '7,25006005,25006818';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006818"),
                  "Make Code","Variable Field 25006818") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006818",VFOptions.Code);
                 END;
            end;
        }
        field(25006819;"Variable Field 25006819";Code[20])
        {
            CaptionClass = '7,25006005,25006819';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006819"),
                  "Make Code","Variable Field 25006819") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006819",VFOptions.Code);
                 END;
            end;
        }
        field(25006820;"Variable Field 25006820";Code[20])
        {
            CaptionClass = '7,25006005,25006820';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006820"),
                  "Make Code","Variable Field 25006820") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006820",VFOptions.Code);
                 END;
            end;
        }
        field(25006821;"Variable Field 25006821";Code[20])
        {
            CaptionClass = '7,25006005,25006821';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006821"),
                  "Make Code","Variable Field 25006821") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006821",VFOptions.Code);
                 END;
            end;
        }
        field(25006822;"Variable Field 25006822";Code[20])
        {
            CaptionClass = '7,25006005,25006822';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006822"),
                  "Make Code","Variable Field 25006822") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006822",VFOptions.Code);
                 END;
            end;
        }
        field(25006823;"Variable Field 25006823";Code[20])
        {
            CaptionClass = '7,25006005,25006823';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006823"),
                  "Make Code","Variable Field 25006823") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006823",VFOptions.Code);
                 END;
            end;
        }
        field(25006824;"Variable Field 25006824";Code[20])
        {
            CaptionClass = '7,25006005,25006824';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006824"),
                  "Make Code","Variable Field 25006824") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006824",VFOptions.Code);
                 END;
            end;
        }
        field(25006825;"Variable Field 25006825";Code[20])
        {
            CaptionClass = '7,25006005,25006825';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions,DATABASE::Vehicle,FIELDNO("Variable Field 25006825"),
                  "Make Code","Variable Field 25006825") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006825",VFOptions.Code);
                 END;
            end;
        }
        field(33020011;"DRP No./ARE1 No.";Code[20])
        {
        }
        field(33020012;"Engine No.";Code[20])
        {

            trigger OnValidate()
            begin
                "Variable Field 25006803" := "Engine No.";

                //SM Agni
                "Engine No." := DELCHR("Engine No.",'=','-\/!|@|#|$|%_)(^*&');
                "Engine No." := DELCHR("Engine No.",'=',' ');
                //SM Agni
            end;
        }
        field(33020013;"AMC Registered";Boolean)
        {
            Editable = false;
        }
        field(33020014;"Current Location of VIN";Code[10])
        {
            TableRelation = Location;
        }
        field(33020015;"Sanjivani Registered";Boolean)
        {
        }
        field(33020016;"PP No.";Code[20])
        {
            Description = 'Pragyapan Patra';
            Editable = true;
        }
        field(33020017;"PP Date";Date)
        {
            Description = 'Pragyapan Patra Date';
            Editable = true;

            trigger OnValidate()
            begin
                "PP Date (BS)" := GblSTPLSysMngt.getNepaliDate("PP Date");
            end;
        }
        field(33020018;"Namsari Date";Date)
        {
            Description = 'Owenship date';

            trigger OnValidate()
            begin
                "Namsari Date (BS)" := GblSTPLSysMngt.getNepaliDate("Namsari Date");
            end;
        }
        field(33020019;"VC No.";Code[20])
        {
        }
        field(33020020;"Vehicle Driver";Text[100])
        {
        }
        field(33020021;"Driver Contact";Text[250])
        {
        }
        field(33020022;"Location After Sale";Code[10])
        {
            Editable = false;
            TableRelation = Location.Code;
        }
        field(33020023;"Vehicle Delivered";Boolean)
        {
        }
        field(33020024;"Vehicle Delivery Date";Date)
        {
        }
        field(33020025;"Total Commission Paid";Decimal)
        {
            CalcFormula = -Sum("G/L Entry".Amount WHERE (Document Class=CONST(Vendor),
                                                         G/L Account No.=CONST(205102),
                                                         Vehicle Serial No.=FIELD(Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020026;"Customer No.";Code[20])
        {
            Description = 'For Vehicle Reservation functionality @Agni';
            Editable = false;
            FieldClass = Normal;
            TableRelation = Customer;
        }
        field(33020027;"Sahamati Date";Date)
        {

            trigger OnValidate()
            begin
                "Sahamati Date (BS)" := GblSTPLSysMngt.getNepaliDate("Sahamati Date");
            end;
        }
        field(33020028;"Sahamati Location";Text[50])
        {
        }
        field(33020263;"Membership No.";Code[20])
        {
            CalcFormula = Lookup("Scheme Vehicle Tracking"."Membership Card No." WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020264;"Scheme Code";Code[20])
        {
            CalcFormula = Lookup("Scheme Vehicle Tracking"."Scheme Code" WHERE (Vehicle Serial No.=FIELD(Serial No.),
                                                                                Membership Card No.=FIELD(Membership No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020265;"Scheme Type";Option)
        {
            CalcFormula = Lookup("Scheme Vehicle Tracking".Status WHERE (Vehicle Serial No.=FIELD(Serial No.),
                                                                         Membership Card No.=FIELD(Membership No.)));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Primary,Secondary';
            OptionMembers = " ",Primary,Secondary;
        }
        field(33020501;"Current Location of Vehicle";Code[10])
        {
            CalcFormula = Lookup("Item Ledger Entry"."Location Code" WHERE (Serial No.=FIELD(Serial No.),
                                                                            Remaining Quantity=CONST(1),
                                                                            Open=CONST(Yes)));
            Description = 'Temporary Fix to know VIN Location before Sales as 33020014 field not working properly//chandra';
            FieldClass = FlowField;
        }
        field(33020502;"Sales Date (BS)";Code[10])
        {

            trigger OnValidate()
            begin
                "Sales Date" := GblSTPLSysMngt.getEngDate("Sales Date (BS)");
            end;
        }
        field(33020503;"First Registration Date (BS)";Code[10])
        {

            trigger OnValidate()
            begin
                "First Registration Date" := GblSTPLSysMngt.getEngDate("First Registration Date (BS)");
            end;
        }
        field(33020504;"Namsari Date (BS)";Code[10])
        {

            trigger OnValidate()
            begin
                "Namsari Date" := GblSTPLSysMngt.getEngDate("Namsari Date (BS)");
            end;
        }
        field(33020505;"Sahamati Date (BS)";Code[10])
        {

            trigger OnValidate()
            begin
                "Sahamati Date" := GblSTPLSysMngt.getEngDate("Sahamati Date (BS)");
            end;
        }
        field(33020506;"PP Date (BS)";Code[10])
        {

            trigger OnValidate()
            begin
                "PP Date" := GblSTPLSysMngt.getEngDate("PP Date (BS)");
            end;
        }
        field(33020507;"No. of times registered";Integer)
        {
        }
        field(33020508;"PDI Status";Option)
        {
            CalcFormula = Lookup("PDI Header".Status WHERE (VIN=FIELD(VIN)));
            Caption = 'PDI Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(33020509;"PDI Type";Option)
        {
            CalcFormula = Lookup("PDI Header"."PDI Type" WHERE (VIN=FIELD(VIN)));
            FieldClass = FlowField;
            OptionMembers = ,"Regular PDI","Accidental Repair";
        }
        field(33020510;"Variant Code";Code[20])
        {
            CalcFormula = Max("Item Ledger Entry"."Variant Code" WHERE (Serial No.=FIELD(Serial No.)));
            Description = 'Temporary Fix to know Variant Code as 33020019 field not working properly//chandra';
            FieldClass = FlowField;
        }
        field(33020511;"Next Service Date";Date)
        {
            CalcFormula = Max("Posted Serv. Order Header"."Next Service Date" WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020512;"Kilometrage SR";Decimal)
        {
            CalcFormula = Max("Posted Serv. Order Header".Kilometrage WHERE (Vehicle Serial No.=FIELD(Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020513;"Model Version No. 2";Code[20])
        {
        }
        field(33020514;"Accidental Vehicle";Boolean)
        {
        }
        field(33020515;"Accidental Under Insurance";Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                //to comment
                //UserSetup.GET(USERID);
                //UserSetup.TESTFIELD("Can modify Accidental Ins.");
            end;
        }
        field(33020516;"Preferred Service Location";Code[10])
        {
            TableRelation = Location.Code WHERE (Use As Service Location=CONST(Yes));
        }
        field(33020517;"Purchase Amount";Decimal)
        {
        }
        field(33020518;"Margin Amount";Decimal)
        {
        }
        field(33020519;"Interest Amount";Decimal)
        {
        }
        field(33020520;"Sales Price";Decimal)
        {
        }
        field(33020521;"Vehicle Price Calculation Date";Date)
        {
        }
        field(33020522;PreviousInterestAmount;Decimal)
        {
        }
        field(33020523;"Warranty Provision";Decimal)
        {
        }
        field(33020524;"Insurance Provision";Decimal)
        {
        }
        field(33020525;"First Month Interest";Decimal)
        {
        }
        field(33020526;"First Month Interest Calc Date";Date)
        {
            Editable = false;
        }
        field(33020527;Port;Code[20])
        {
        }
        field(33020528;Times;Integer)
        {
        }
        field(33020529;"Purchase Type";Option)
        {
            OptionCaption = ' ,PULLED, NEW, OLD';
            OptionMembers = " ",PULLED," NEW"," OLD";
        }
    }

    keys
    {
        key(Key1;"Serial No.")
        {
            Clustered = true;
        }
        key(Key2;"Make Code","Model Code","Model Version No.","Status Group Code")
        {
        }
        key(Key3;"Registration No.")
        {
        }
        key(Key4;VIN)
        {
        }
        key(Key5;"DRP No./ARE1 No.","Engine No.")
        {
        }
        key(Key6;"Purchase Invoice Date (Real)")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Serial No.",VIN,"Make Code","Model Code","Registration No.","DRP No./ARE1 No.","Engine No.")
        {
        }
    }

    trigger OnDelete()
    var
        ItemLedgerEntry: Record "32";
        SalesLine: Record "37";
        PurchLine: Record "39";
        ServiceHdr: Record "25006145";
    begin
        //ERROR(tcSER002);

        //16.08.2007. EDMS P2 >>
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Serial No.");
        ItemLedgerEntry.SETRANGE("Serial No.", "Serial No.");
        IF ItemLedgerEntry.FINDFIRST THEN
          ERROR(STRSUBSTNO(EDMS002, VIN));

        SalesLine.RESET;
        SalesLine.SETCURRENTKEY(Type, "Line Type", "Vehicle Serial No.");
        SalesLine.SETRANGE("Vehicle Serial No.", "Serial No.");
        IF SalesLine.FINDFIRST THEN
          ERROR(STRSUBSTNO(EDMS003, VIN));

        PurchLine.RESET;
        PurchLine.SETCURRENTKEY(Type, "Line Type", "Vehicle Serial No.");
        PurchLine.SETRANGE("Vehicle Serial No.", "Serial No.");
        IF PurchLine.FINDFIRST THEN
          ERROR(STRSUBSTNO(EDMS004, VIN));

        ServiceHdr.RESET;
        ServiceHdr.SETCURRENTKEY("Vehicle Serial No.");
        ServiceHdr.SETRANGE("Vehicle Serial No.", "Serial No.");
        IF ServiceHdr.FINDFIRST THEN
           ERROR(STRSUBSTNO(EDMS005, VIN));
        //16.08.2007. EDMS P2 <<
    end;

    trigger OnInsert()
    begin
        IF "Serial No." = '' THEN
         BEGIN
          AssignSerialNo;
          NewAccCycleNo;
         END;

        IF UserProfileMgt.CurrProfileID <> '' THEN
         BEGIN
          IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
           BEGIN
            IF "Make Code" = '' THEN
             BEGIN
              IF UserProfile."Default Make Code" <> '' THEN
               VALIDATE("Make Code",UserProfile."Default Make Code");
             END;
            IF "Status Code" = '' THEN
             BEGIN
              IF UserProfile."Default Vehicle Status" <> '' THEN
               VALIDATE("Status Code",UserProfile."Default Vehicle Status");
             END;

           END;
        END;
        "Status Code":='NEW';
        "Creation Date" := TODAY;
        // 29.09.2011 EDMS P8 >>
        TireManagement.GetVehicleAxleToEntry("Serial No.", '');
        // 29.09.2011 EDMS P8 <<
        "Last Date Modified" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
        // 29.09.2011 EDMS P8 >>
        TireManagement.GetVehicleAxleToEntry("Serial No.", '');
        // 29.09.2011 EDMS P8 <<
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        Model: Record 25006001;
        Customer: Record 18;
        VINDecode: Record 25006008;
        SingleInstanceMgt: Codeunit 25006001;
        UserProfile: Record 25006067;
        tcSER002: Label 'Can''t delete vehicle, it can only be replaced.';
        InventorySetup: Record 313;
        tcDMS001: Label 'VIN should be %1 char. long.';
        tcDMS002: Label 'VIN must not include ''%1'' char.';
        VehChangeLogMgt: Codeunit 25006009;
        LookupMgt: Codeunit 25006003;
        VFMgt: Codeunit 25006004;
        EDMS001: Label 'Registration No. already exist to other vehicle.';
        Cont: Record 5050;
        EDMS002: Label 'Vehicle %1 exist item ledger entries.';
        EDMS003: Label 'Vehicle %1 exist Sales entries.';
        EDMS004: Label 'Vehicle %1 exist Purchase entries.';
        EDMS005: Label 'Vehicle %1 exist Service entries.';
        Text102: Label 'Order Nr. %1: ';
        LicensePermission: Record 2000000043;
        UserSetup: Record 91;
        Salesperson: Record 13;
        TireManagement: Codeunit 25006125;
        Text019: Label 'You cannot change %1 because there are one or more open ledger entries for this item.';
        FixedAsset: Record 5600;
        ServiceMgtSetup: Record 25006120;
        UserProfileMgt: Codeunit 25006002;
        SalesInvHeader: Record 112;
        txtCharsToKeep: Text[30];
        PostSalesContact: Record 33019858;
        VehCont: Record 25006013;
        VehContact: Code[20];
        ContBussRelation: Record 5054;
        CustNo: Code[20];
        GblSTPLSysMngt: Codeunit 50000;
        Text1001: Label 'Vehicle Serial No. already exist in Item Ledger Entry. %1 has to be match with the same in Item Ledger Entry';

    [Scope('Internal')]
    procedure AssignSerialNo()
    var
        cuNoSeriesMgt: Codeunit 396;
        recPurchaseLine: Record 39;
        codSerialNos: Code[20];
        codNewSerialNo: Code[20];
        tcDMS001: Label '%1 is set already.';
    begin
        IF "Serial No." <> '' THEN
         ERROR(tcDMS001,FIELDCAPTION("Serial No."));

        InventorySetup.GET;
        InventorySetup.TESTFIELD("Vehicle Serial No. Nos.");
        codSerialNos := InventorySetup."Vehicle Serial No. Nos.";
        cuNoSeriesMgt.InitSeries(codSerialNos,codSerialNos,WORKDATE,codNewSerialNo,codSerialNos);

        VALIDATE("Serial No.",codNewSerialNo);
    end;

    [Scope('Internal')]
    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::Vehicle,FieldNo));
    end;

    [Scope('Internal')]
    procedure CheckDublicates()
    var
        recVehicle: Record 25006005;
        tcDMS001: Label 'VIN %1 already exists.';
    begin
        recVehicle.RESET;
        recVehicle.SETCURRENTKEY(VIN);
        recVehicle.SETRANGE(VIN,VIN);
        recVehicle.SETFILTER("Serial No.",'<>%1',"Serial No.");
        IF recVehicle.FINDFIRST THEN
         ERROR(tcDMS001,VIN);
    end;

    [Scope('Internal')]
    procedure NewAccCycleNo()
    var
        CycleNo: Code[20];
        cuVehAccCycle: Codeunit 25006303;
        VehAccCycle: Record 25006024;
        ApprAllowed: Boolean;
    begin
        LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
        LicensePermission.SETRANGE("Object Number",CODEUNIT::VehicleAccountingCycleMgt);
        LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");

        ApprAllowed := NOT LicensePermission.ISEMPTY;

        IF ApprAllowed THEN BEGIN

          //EDMS
          IF "Serial No." = '' THEN
            EXIT;

          CycleNo := cuVehAccCycle.GetNewCycleNo;

          VehAccCycle.INIT;
          VehAccCycle."No." := CycleNo;
          VehAccCycle.VALIDATE("Vehicle Serial No.","Serial No.");
          VehAccCycle.VALIDATE(Default,TRUE);
          VehAccCycle.INSERT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure GetAssemblyDescr(var SerialNo: Code[20]) Res: Text[1024]
    var
        VehAssembly: Record "25006380";
        Veh2: Record "25006005";
        VehOptLedger: Record "25006388";
        PurchLine: Record "39";
    begin
        IF Veh2.GET(SerialNo) THEN BEGIN
            VehOptLedger.SETCURRENTKEY("Vehicle Serial No.");
            VehOptLedger.SETRANGE("Vehicle Serial No.",Veh2."Serial No.");
            VehOptLedger.SETRANGE(Open,TRUE);
            IF VehOptLedger.FINDSET THEN
              REPEAT
                IF Res = '' THEN
                  Res := VehOptLedger."Option Code"
                ELSE
                  Res := Res + ' ' + VehOptLedger."Option Code"
              UNTIL VehOptLedger.NEXT = 0
        END ELSE BEGIN
          PurchLine.SETCURRENTKEY("Vehicle Serial No.","Vehicle Assembly ID");
          PurchLine.SETRANGE("Vehicle Serial No.",SerialNo);
          PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
          PurchLine.SETFILTER("Vehicle Assembly ID",'<>''''');
          IF PurchLine.FINDSET THEN
            REPEAT
              VehAssembly.SETRANGE("Serial No.",SerialNo);
              VehAssembly.SETRANGE("Assembly ID",PurchLine."Vehicle Assembly ID");
              IF VehAssembly.FINDSET THEN BEGIN
                REPEAT
                  IF Res = '' THEN
                    Res := STRSUBSTNO(Text102,PurchLine."Document No.") + VehOptLedger."Option Code"
                  ELSE
                    Res := Res + ' ' + VehOptLedger."Option Code"
                UNTIL VehAssembly.NEXT = 0;
                EXIT
              END;
            UNTIL PurchLine.NEXT = 0;
        END
    end;

    [Scope('Internal')]
    procedure GetLocation() LocationCode: Code[10]
    var
        ItemLedgerEntry: Record "32";
    begin
        ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code","Location Code","Item Tracking","Lot No.","Serial No.");
        ItemLedgerEntry.SETRANGE("Serial No.", "Serial No.");
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        IF ItemLedgerEntry.FINDFIRST THEN
          LocationCode := ItemLedgerEntry."Location Code";
        EXIT(LocationCode);
    end;

    [Scope('Internal')]
    procedure GetCurrentPrice() CurrPrice: Decimal
    var
        SalesPrice: Record "7002";
        Item: Record "27";
    begin
        SalesPrice.SETRANGE("Item No.", "Model Version No.");
        SalesPrice.SETRANGE("Make Code", "Make Code");
        SalesPrice.SETRANGE("Model Code", "Model Code");
        SalesPrice.SETRANGE("Vehicle Serial No.", "Serial No.");
        SalesPrice.SETRANGE("Document Profile", SalesPrice."Document Profile"::"Vehicles Trade");
        SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::"All Customers");
        SalesPrice.SETFILTER("Starting Date", '<=%1', WORKDATE);
        SalesPrice.SETFILTER("Ending Date", '''''|>=%1', WORKDATE);
        IF SalesPrice.FINDLAST THEN BEGIN
          CurrPrice := SalesPrice."Unit Price";
        END ELSE BEGIN
          SalesPrice.SETRANGE("Vehicle Serial No.",'');
          IF SalesPrice.FINDLAST THEN
            CurrPrice := SalesPrice."Unit Price"
          ELSE IF Item.GET("Model Version No.") THEN
            CurrPrice := Item."Unit Price";
        END;
    end;

    [Scope('Internal')]
    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit 25006316;
        VehReserveSalesLine: Codeunit 25006317;
        VehReservEntry: Record "25006392";
    begin
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReservEntry.SETRANGE("Vehicle Serial No.","Serial No.");
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Vehicle Reservation Entries",VehReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Vehicle Reservation Entries",VehReservEntry);
    end;

    [Scope('Internal')]
    procedure CreateInteraction()
    var
        SegmentLine: Record 5077 temporary;
        UserSetup: Record 91;
        PurchSlsPer: Record 13;
    begin
        SegmentLine.CreateInteractionFromVehicle(Rec);
    end;

    [Scope('Internal')]
    procedure ShowSalesOrders()
    var
        SalesHeader: Record 36;
        SalesLine: Record 37;
    begin
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Document Profile");
        SalesHeader.SETRANGE("Document Profile",SalesHeader."Document Profile"::"Vehicles Trade");

        SalesLine.RESET;
        SalesLine.SETCURRENTKEY(Type,"Line Type","Vehicle Serial No.");
        SalesLine.SETRANGE("Line Type",SalesLine."Line Type"::Vehicle);
        SalesLine.SETRANGE("Vehicle Serial No.","Serial No.");
        SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
        IF SalesLine.FINDFIRST THEN
         REPEAT
          IF SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN
           SalesHeader.MARK := TRUE;
         UNTIL SalesLine.NEXT = 0;

        SalesHeader.MARKEDONLY(TRUE);
        IF SalesHeader.COUNT = 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Sales Order",SalesHeader) = ACTION::None THEN;
        END ELSE BEGIN
          IF PAGE.RUNMODAL(PAGE::"Sales Order List (Veh.)",SalesHeader) = ACTION::None THEN;
        END;
    end;

    [Scope('Internal')]
    procedure ShowSalesReturnOrders()
    var
        SalesHeader: Record 36;
        SalesLine: Record 37;
    begin
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Document Profile");
        SalesHeader.SETRANGE("Document Profile",SalesHeader."Document Profile"::"Vehicles Trade");

        SalesLine.RESET;
        SalesLine.SETCURRENTKEY(Type,"Line Type","Vehicle Serial No.");
        SalesLine.SETRANGE("Line Type",SalesLine."Line Type"::Vehicle);
        SalesLine.SETRANGE("Vehicle Serial No.","Serial No.");
        SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Return Order");
        IF SalesLine.FINDFIRST THEN
         REPEAT
          IF SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN
           SalesHeader.MARK := TRUE;
         UNTIL SalesLine.NEXT = 0;

        SalesHeader.MARKEDONLY(TRUE);
        IF SalesHeader.COUNT = 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Sales Return Order",SalesHeader) = ACTION::None THEN;
        END ELSE BEGIN
          IF PAGE.RUNMODAL(PAGE::"Sales Return Order List (Veh.)",SalesHeader) = ACTION::None THEN;
        END;
    end;

    [Scope('Internal')]
    procedure ShowPurchOrders()
    var
        PurchHeader: Record 38;
        PurchLine: Record 39;
    begin
        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Profile");
        PurchHeader.SETRANGE("Document Profile",PurchHeader."Document Profile"::"Vehicles Trade");

        PurchLine.RESET;
        PurchLine.SETCURRENTKEY(Type,"Line Type","Vehicle Serial No.");
        PurchLine.SETRANGE("Line Type",PurchLine."Line Type"::Vehicle);
        PurchLine.SETRANGE("Vehicle Serial No.","Serial No.");
        PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
        IF PurchLine.FINDFIRST THEN
         REPEAT
          IF PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.") THEN
           PurchHeader.MARK := TRUE;
         UNTIL PurchLine.NEXT = 0;

        PurchHeader.MARKEDONLY(TRUE);
        IF PurchHeader.COUNT = 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Purchase Order",PurchHeader) = ACTION::None THEN;
        END ELSE BEGIN
          IF PAGE.RUNMODAL(PAGE::"Purchase Order List (Veh.)",PurchHeader) = ACTION::None THEN;
        END;
    end;

    [Scope('Internal')]
    procedure ShowPurchReturnOrders()
    var
        PurchHeader: Record 38;
        PurchLine: Record 39;
    begin
        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Profile");
        PurchHeader.SETRANGE("Document Profile",PurchHeader."Document Profile"::"Vehicles Trade");

        PurchLine.RESET;
        PurchLine.SETCURRENTKEY(Type,"Line Type","Vehicle Serial No.");
        PurchLine.SETRANGE("Line Type",PurchLine."Line Type"::Vehicle);
        PurchLine.SETRANGE("Vehicle Serial No.","Serial No.");
        PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::"Return Order");
        IF PurchLine.FINDFIRST THEN
         REPEAT
          IF PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.") THEN
           PurchHeader.MARK := TRUE;
         UNTIL PurchLine.NEXT = 0;

        PurchHeader.MARKEDONLY(TRUE);
        IF PurchHeader.COUNT = 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Purchase Return Order",PurchHeader) = ACTION::None THEN;
        END ELSE BEGIN
          IF PAGE.RUNMODAL(PAGE::"Purch. Rtrn Order List (Veh.)",PurchHeader) = ACTION::None THEN;
        END;
    end;

    [Scope('Internal')]
    procedure ShowServOrders()
    var
        ServiceHeader: Record 25006145;
    begin
        ServiceHeader.RESET;
        ServiceHeader.SETCURRENTKEY("Vehicle Serial No.");
        ServiceHeader.SETRANGE("Vehicle Serial No.","Serial No.");
        ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::Order);

        IF ServiceHeader.COUNT = 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Service Order EDMS",ServiceHeader) = ACTION::None THEN;
        END ELSE BEGIN
          IF PAGE.RUNMODAL(PAGE::"Service Orders EDMS",ServiceHeader) = ACTION::None THEN;
        END;
    end;

    [Scope('Internal')]
    procedure ShowServReturnOrders()
    var
        ServiceHeader: Record 25006145;
    begin
        ServiceHeader.RESET;
        ServiceHeader.SETCURRENTKEY("Vehicle Serial No.");
        ServiceHeader.SETRANGE("Vehicle Serial No.","Serial No.");
        ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::"Return Order");

        IF ServiceHeader.COUNT = 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Service Return Order EDMS",ServiceHeader) = ACTION::None THEN;
        END ELSE BEGIN
          IF PAGE.RUNMODAL(PAGE::"Service Return Orders EDMS",ServiceHeader) = ACTION::None THEN;
        END;
    end;

    [Scope('Internal')]
    procedure FillVariableFieldsFromSpecific()
    var
        VariableFieldUsage: Record 25006006;
        VariableFieldUsage2: Record 25006006;
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
        ModelVersionSpecification: Record 25006012;
    begin
        IF NOT ModelVersionSpecification.GET("Make Code", "Model Code", "Model Version No.") THEN
          EXIT;
        RecordRef.OPEN(DATABASE::"Model Version Specification");
        RecordRef.GETTABLE(ModelVersionSpecification);
        RecordRef2.OPEN(DATABASE::Vehicle);
        RecordRef2.GETTABLE(Rec);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Model Version Specification");
        IF VariableFieldUsage.FINDFIRST THEN
          REPEAT
            VariableFieldUsage2.RESET;
            VariableFieldUsage2.SETRANGE("Table No.", DATABASE::Vehicle);
            VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
            IF VariableFieldUsage2.FINDFIRST THEN BEGIN
              FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
              FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
              FieldRef2.VALUE(FieldRef.VALUE);
            END;
          UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(Rec);
    end;

    [Scope('Internal')]
    procedure GetCaptionClass(FldNo: Integer): Text[80]
    begin
        EXIT('7,25006005,'+FORMAT(FldNo));
    end;

    [Scope('Internal')]
    procedure TestNoOpenEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record 32;
    begin
        //21.05.2014 Elva Baltic P8 #Exxx MMG7.00 >>
        //ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE("Item No.", xRec."Model Version No.");
        ItemLedgEntry.SETRANGE("Serial No.", "Serial No.");
        //21.05.2014 Elva Baltic P8 #Exxx MMG7.00 <<
        ItemLedgEntry.SETRANGE(Open,TRUE);
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(
            Text019,
            CurrentFieldName);
    end;

    [Scope('Internal')]
    procedure CreateContactSheet()
    begin
        IF "Sales Date" <> 0D THEN BEGIN
            PostSalesContact.INIT;
            PostSalesContact."Registration No." := "Registration No.";
            PostSalesContact.VIN := VIN;
            PostSalesContact."Model Code" := "Model Code";
            PostSalesContact."Engine No." := "Engine No.";
            PostSalesContact."Sales Date" := "Sales Date";
            VehCont.RESET;
            VehCont.SETRANGE("Vehicle Serial No.","Serial No.");
            IF VehCont.FINDFIRST THEN BEGIN
               VehContact := VehCont."Contact No.";
               ContBussRelation.RESET;
               ContBussRelation.SETRANGE("Contact No.",VehContact);
               IF ContBussRelation.FINDFIRST THEN BEGIN
                  CustNo := ContBussRelation."No.";
               END;
            END;
            PostSalesContact.VALIDATE("Customer No.",CustNo);
            PostSalesContact."Contact Type" := PostSalesContact."Contact Type"::"7th Contact";
            PostSalesContact.INSERT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure CheckSerialNoInItemLedgerEntry(VehicleDetail: Text[30])
    var
        ItemLedgerEntry: Record 32;
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Serial No.","Serial No.");
        IF ItemLedgerEntry.FINDFIRST THEN
          MESSAGE(Text1001,VehicleDetail);
    end;
}

