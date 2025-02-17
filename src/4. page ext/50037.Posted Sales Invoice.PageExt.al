pageextension 50037 pageextension50037 extends "Posted Sales Invoice"
{
    // 27.05.2016 EB.P30 EDMS
    //   Added actions:
    //     Print
    //     Email
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 23.01.2013 EDMS P8
    //   * Added field: Resources

    //Unsupported feature: Property Insertion (Visible) on ""Posted Sales Invoice"(Page 132)".


    //Unsupported feature: Property Insertion (Name) on ""Posted Sales Invoice"(Page 132)".


    //Unsupported feature: Property Modification (Importance) on ""Posted Sales Invoice"(Page 132)".


    //Unsupported feature: Property Modification (Importance) on ""Posted Sales Invoice"(Page 132)".


    //Unsupported feature: Property Insertion (Permissions) on ""Posted Sales Invoice"(Page 132)".

    layout
    {
        modify(SalesInvLines)
        {

            //Unsupported feature: Property Insertion (SubPageView) on "SalesInvLines(Control 54)".

            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 12")
        {
            field("Dealer VIN"; Rec."Dealer VIN")
            {
            }
        }
        addafter("Control 68")
        {
            field(QR; compInfo."Phone Pay QR")
            {
                Editable = false;
            }
            field(Trip; Rec.Trip)
            {
            }
            field("Trip Start Date"; Rec."Trip Start Date")
            {
            }
            field("Trip Start Time"; Rec."Trip Start Time")
            {
            }
            field("Trip End Date"; Rec."Trip End Date")
            {
            }
            field("Trip End Time"; Rec."Trip End Time")
            {
            }
        }
        addafter("Control 86")
        {
            field(Kilometrage; Rec.Kilometrage)
            {
            }
        }
        addafter("Control 94")
        {
            field("GPD PO No."; Rec."GPD PO No.")
            {
                Importance = Additional;
            }
        }
        addafter("Control 10")
        {
            field("Accountability Center"; Rec."Accountability Center")
            {
            }
        }
        addafter("Control 92")
        {
            field("Forward Accountability Center"; Rec."Forward Accountability Center")
            {
            }
            field("Forward Location Code"; Rec."Forward Location Code")
            {
            }
            field("Tender Sales"; Rec."Tender Sales")
            {
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
            }
            field("Direct Sales Commission No."; Rec."Direct Sales Commission No.")
            {
            }
        }
        addafter("Control 76")
        {
            field("Financed By"; Rec."Financed By")
            {
                Editable = false;
            }
            field("Re-Financed By"; Rec."Re-Financed By")
            {
                Editable = false;
            }
            field("Financed Amount"; Rec."Financed Amount")
            {
                Editable = false;
            }
            field("Job Type"; Rec."Job Type")
            {
            }
            field("Invertor Serial No."; Rec."Invertor Serial No.")
            {
            }
            field("Province No."; Rec."Province No.")
            {
            }
            field("Insurance Type"; Rec."Insurance Type")
            {
                Editable = false;
            }
            field("Insurance Company Name"; Rec."Insurance Company Name")
            {
                Editable = false;
            }
            field("Insurance Policy Number"; Rec."Insurance Policy Number")
            {
                Editable = false;
            }
            group("Letter of Credit/Delivery Order")
            {
                Caption = 'Letter of Credit/Delivery Order';
                Visible = "Veh&SpareTrade";
                field("Sys. LC No."; Rec."Sys. LC No.")
                {
                }
                field("LC Amend No."; Rec."LC Amend No.")
                {
                }
            }
        }
        addafter("Control 83")
        {
            field("Phone No."; Rec."Phone No.")
            {
                Editable = false;
                Importance = Additional;
            }
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                Editable = false;
                Importance = Additional;
            }
        }
        addafter(SalesInvLines)
        {
            part(SalesInvLinesVehicle; 25006541)
            {
                SubPageLink = Document No.=FIELD(No.);
                    SubPageView = WHERE(Quantity=FILTER(<>0));
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 28")
        {
            field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
            {
                Editable = false;
            }
            field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
            {
                Editable = false;
            }
            field("Advance Payment";"Advance Payment")
            {
                Editable = false;
            }
        }
        addafter("Control 1907468901")
        {
            group(Service)
            {
                Caption = 'Service';
                field("Document Profile";"Document Profile")
                {
                    Editable = false;
                }
                field("Service Order No.";"Service Order No.")
                {
                    Editable = false;
                }
                field("Make Code";"Make Code")
                {
                    Editable = false;
                }
                field("Model Code";"Model Code")
                {
                    Editable = false;
                }
                field("Model Version No.";"Model Version No.")
                {
                    Editable = false;
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                }
                field(Resources;Resources)
                {
                    Editable = false;
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 57".



        //Unsupported feature: Code Modification on "CreateCreditMemo(Action 33).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec,SalesHeader);
            PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader);
            CurrPage.CLOSE;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec,SalesHeader);
            PAGE.RUN(PAGE::"Credit Note",SalesHeader);
            CurrPage.CLOSE;
            */
        //end;
        addafter(Print)
        {
            action("Letter Of Credit")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                       SalesInvHeader.RESET;
                       SalesInvHeader.SETRANGE("No.","No.");
                       IF SalesInvHeader.FINDFIRST THEN BEGIN
                         REPORT.RUNMODAL(33020210,TRUE,TRUE,SalesInvHeader);
                       END;
                end;
            }
        }
        addafter("Action 51")
        {
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Print Allottment Letter")
                {
                    Caption = 'Print Allottment Letter';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                        //REPORT.RUN(50041,TRUE,TRUE,SalesInvHeader);
                        REPORT.RUN(50022,TRUE,TRUE,SalesInvHeader);
                    end;
                }
                action("Print Insurance Letter")
                {
                    Caption = 'Print Insurance Letter';
                    Image = InsuranceLedger;

                    trigger OnAction()
                    begin
                        //MESSAGE('%1',"No.");
                        SalesCrMemo.RESET;
                        SalesCrMemo.SETRANGE("External Document No.","No.");
                        IF SalesCrMemo.FINDFIRST THEN BEGIN
                          ERROR('This invoice has been cancelled and cannot print Insurance Letter.');
                        END ELSE BEGIN
                          CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                          REPORT.RUN(50023,TRUE,TRUE,SalesInvHeader);
                        END;
                    end;
                }
                action(Print)
                {
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        //DocMgt.PrintCurrentDoc("Document Profile", 1, 9, DocReport);
                        //DocMgt.SelectSalesInvDocReport(DocReport, Rec);

                        CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                        IF NOT SalesInvHeader."Battery Document" THEN BEGIN
                          SalesInvHeader.PrintRecords2(TRUE);
                        END
                        ELSE
                          REPORT.RUN(50024,TRUE,FALSE,SalesInvHeader);
                    end;
                }
            }
            action("Print Battery Invoice")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    REPORT.RUN(50024,TRUE,FALSE,SalesInvHeader);
                end;
            }
            action()
            {
            }
            action("&Receipt")
            {
                Caption = '&Receipt';
                Enabled = ReceiptEnable;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //REPORT.RUN(33020025);
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.","No.");
                    REPORT.RUN(33020025,TRUE,TRUE,SalesInvHeader);
                end;
            }
            action("Fone Pay")
            {
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    QR: Page "33019806";
                begin
                    QR.RUN;
                end;
            }
            action("Defect And Complain")
            {
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DefectPage: Page "14125504";
                                    Defect: Record "14125606";
                begin
                    Defect.RESET;
                    Defect.SETRANGE("Service Order No.",Rec."Service Order No.");
                    DefectPage.SETTABLEVIEW(Defect);
                    DefectPage.RUN;
                end;
            }
            action("<Action49>")
            {
                Caption = '&Print Delivery Order';
                Ellipsis = true;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    Vehi: Record "33019823";
                    SalesShipmentLine: Record "111";
                begin
                    /*
                    CurrPage.SETSELECTIONFILTER(SalesShptHeader);
                    SalesShptHeader.PrintRecords(TRUE);
                    */
                    SalesShipmentLine.RESET;
                    SalesShipmentLine.SETRANGE("Document No.",Rec."No.");
                    IF SalesShipmentLine.FINDFIRST THEN BEGIN
                       IF Vehi.GET(SalesShipmentLine."Vehicle Serial No.") THEN;
                         Vehi.CALCFIELDS("Sales Invoice No."); //***SM 28-07-2013 sales invoice must be done before the vehicle delivery //v2
                         Vehi.TESTFIELD("Sales Invoice No.");//v2
                         Vehi.CALCFIELDS("Insurance Policy No.");
                         Vehi.TESTFIELD("Insurance Policy No.");//***SM 28-
                    END;
                    SalesShptHeader.RESET;
                    SalesShptHeader.SETRANGE("Order No.",Rec."Order No.");
                    SalesShptHeader.SETRANGE("Document Profile",Rec."Document Profile");
                    IF SalesShptHeader.FINDLAST THEN
                    REPORT.RUN(33020199,TRUE,TRUE,SalesShptHeader);

                end;
            }
            action("&Deliver Vehicle")
            {
                Caption = '&Deliver Vehicle';
                Image = MakeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SalesShptHeader.RESET;
                    SalesShptHeader.SETRANGE("Order No.",Rec."Order No.");
                    SalesShptHeader.SETRANGE("Document Profile",Rec."Document Profile");
                    IF SalesShptHeader.FINDLAST THEN
                      DeliverVehicle(SalesShptHeader);
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SalesCrMemo: Record "114";
        [InDataSet]
        ReceiptEnable: Boolean;
        [InDataSet]
        "Veh&SpareTrade": Boolean;
        Text01: Label 'This Commercial Invoice is not Posted. Please post it before printing the invoice.';
        compInfo: Record "79";
        SalesShptHeader: Record "110";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        DocExchStatusStyle := GetDocExchStatusStyle;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //***SM 15-08-2013 to make the lc no. visible in spare parts trade
        DocExchStatusStyle := GetDocExchStatusStyle;
        //EDMS >>
          IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN
             VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade"
          ELSE
          IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN
             VehicleTradeDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
        //EDMS >>

        //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
          "Veh&SpareTrade" := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                           ("Document Profile" = "Document Profile"::"Spare Parts Trade");
        //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SetSecurityFilterOnRespCenter;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        // SetSecurityFilterOnRespCenter;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        IsOfficeAddin := OfficeMgt.IsAvailable;

        FilterOnRecord;

        IF "Payment Method Code" <> '' THEN
           ReceiptEnable := TRUE;

        compInfo.GET;
        compInfo.CALCFIELDS("Phone Pay QR");
        */
    //end;

    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
                          Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.","No.");
        IF NOT GatepassHeader.FINDFIRST THEN
        BEGIN
          GatepassHeader.INIT;
          IF "Shortcut Dimension 2 Code" = '4010' THEN
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle GatePass"
          ELSE IF  "Shortcut Dimension 2 Code" IN ['2040','2070'] THEN
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle GatePass"
          ELSE IF  "Shortcut Dimension 2 Code" = '3000' THEN
            GatepassHeader."Document Type" := GatepassHeader."Document Type"::"Vehicle GatePass"
          ELSE
            ERROR(Text000);
          GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::Repair;
          GatepassHeader."External Document No." := "No.";
          GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        IF ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
          IF UserSetup."Allow View all Veh. Invoice" THEN
             SkipFilter := TRUE;
        IF NOT SkipFilter THEN BEGIN
          RespCenterFilter := UserMgt.GetSalesFilter();
            IF RespCenterFilter <> '' THEN BEGIN
              FILTERGROUP(2);
               IF UserMgt.DefaultResponsibility THEN
                  SETRANGE("Responsibility Center",RespCenterFilter)
              ELSE
                  SETRANGE("Accountability Center",RespCenterFilter);
              FILTERGROUP(0);
            END;
        END;
    end;

    procedure DeliverVehicle(var SalesShipmentHeader: Record "110")
    var
        Vehicle: Record "25006005";
        SalesShipmentLine: Record "111";
        Text000: Label 'Vehicle %1 is now delivered from the system.Please Report Print Vehicle Delivery';
        Vehi: Record "33019823";
    begin
        SalesShipmentLine.RESET;
        SalesShipmentLine.SETRANGE("Document No.",SalesShipmentHeader."No.");
        IF SalesShipmentLine.FINDFIRST THEN BEGIN
           Vehicle.RESET;
           Vehicle.SETRANGE("Serial No.",SalesShipmentLine."Vehicle Serial No.");
           Vehicle.FINDFIRST;
           IF Vehi.GET(SalesShipmentLine."Vehicle Serial No.") THEN;
             Vehi.CALCFIELDS("Sales Invoice No."); //***SM 28-07-2013 sales invoice must be done before the vehicle delivery //v2
             Vehi.TESTFIELD("Sales Invoice No.");//v2
             Vehi.CALCFIELDS("Insurance Policy No.");
             Vehi.TESTFIELD("Insurance Policy No.");//***SM 28-07-2013 ins. policy no. before the vehicle delivery //v2

           Vehicle."Vehicle Delivered" := TRUE;
           Vehicle."Vehicle Delivery Date" := TODAY;
           Vehicle.MODIFY;
           MESSAGE(Text000,Vehicle.VIN);
        END;

        SalesShipmentHeader."Vehicle Delivered" := TRUE;
        SalesShipmentHeader."Vehicle Delivery Date" := TODAY;
        SalesShipmentHeader.MODIFY;
    end;
}

