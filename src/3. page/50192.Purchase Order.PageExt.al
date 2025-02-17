pageextension 50192 pageextension50192 extends "Purchase Order"
{
    // 08.09.2014 Elva Baltic P8 #S0005 EDMS
    //   * Added <Purch. Reservation FactBox>
    // 
    // 19.05.2014 Elva Baltic P8 #S109 MMG7.00
    //   * Added field Deal Type Code
    // 
    // 27.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added FactBox:
    //     Reserv. for Purchase FactBox
    // 
    // 18.01.2013 EDMS P8
    //   * Added functions: "Get Service Order"
    Editable = false;

    //Unsupported feature: Property Insertion (Name) on ""Purchase Order"(Page 50)".

    PromotedActionCategories = 'New,Process,Report,Requisition';
    layout
    {
        modify(PurchLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 23".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 3".

        modify("Control 49")
        {
            Visible = false;
        }
        modify("Control 12")
        {
            Visible = false;
        }
        modify("Control 36")
        {
            Visible = false;
        }
        modify("Control 14")
        {
            Visible = false;
        }
        addafter("Control 6")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ShowMandatory = true;
            }
        }
        addafter("Control 62")
        {
            field("Order Date"; Rec."Order Date")
            {
            }
            field("Document Date"; Rec."Document Date")
            {
                Editable = false;
            }
            field("Posting Date"; Rec."Posting Date")
            {
            }
            field("Due Date"; Rec."Due Date")
            {
                Editable = false;
            }
        }
        addafter("Control 18")
        {
            field("Vendor Invoice No. "; Rec."Vendor Invoice No.")
            {
                Caption = 'Vendor Invoice No./Date';
            }
            field("Purch. VAT No."; "Purch. VAT No.")
            {
            }
        }
        addafter("Control 96")
        {
            field("Location Code"; Rec."Location Code")
            {
            }
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addafter("Control 7")
        {
            field("Deal Type Code"; "Deal Type Code")
            {
                Visible = false;
            }
            field("Reason Code"; Rec."Reason Code")
            {
            }
            field("Service Order No."; "Service Order No.")
            {
                Visible = ServiceDocument;
            }
            field("Order Type"; "Order Type")
            {
                Visible = ShowExportForVCM;
            }
            field("Import Invoice No."; "Import Invoice No.")
            {
            }
            field("Veh. Accesories Memo No."; "Veh. Accesories Memo No.")
            {
                Style = Standard;
                StyleExpr = TRUE;
                Visible = VehAccDocument;
            }
            field("Accessories Total Amount"; "Accessories Total Amount")
            {
                DrillDown = true;
                Lookup = true;
                Style = Standard;
                StyleExpr = TRUE;
                Visible = VehAccDocument;
            }
            field(Remarks; Remarks)
            {
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
            }
            field("Approved User ID"; "Approved User ID")
            {
            }
            field("Import Purch. Order"; "Import Purch. Order")
            {
            }
        }
        addafter("Control 119")
        {
            field(Narration; Narration)
            {
            }
            field("Procument Memo No."; "Procument Memo No.")
            {
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                Visible = "Veh&SpareTrade";
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("Bank LC No."; "Bank LC No.")
                {
                }
                field("LC Amend No."; "LC Amend No.")
                {
                    Caption = 'Amendment No.';
                    Importance = Promoted;
                }
            }
        }
        addafter(PurchLines)
        {
            part(PurchLinesVehicle; 25006477)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 191")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
        }
        addafter("Control 87")
        {
            field(Correction; Rec.Correction)
            {
            }
            part("PurchLinesVehicle "; 25006477)
            {
                Caption = 'PurchLinesVehicle';
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 83")
        {
            field("Shipping Agent Code"; "Shipping Agent Code")
            {
            }
        }
        addafter(WorkflowStatus)
        {
            part(; 25006096)
            {
                Provider = "60";
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Line No.=FIELD(Line No.);
                Visible = false;
            }
        }
        moveafter("Control 7";"Control 119")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 65".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 180".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 148".

        modify(Reopen)
        {
            PromotedCategory = Process;
        }


        //Unsupported feature: Code Insertion (VariableCollection) on "Post(Action 79).OnAction".

        //trigger (Variable: SalesHeader)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on "Post(Action 79).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Post(CODEUNIT::"Purch.-Post (Yes/No)");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //Calling functions in codeunit 33020011 to check VC No. and Tolerance Percentage.
            IF VehicleTradeDocument THEN BEGIN
               TESTFIELD("Sys. LC No.");
            END;




            //***SM 25/06/2013 to create vehicle checklist at each receiving point***
            //***SM 24/08/2013 shifted this code in codeunit 90
            {IF VehicleTradeDocument THEN BEGIN
              TESTFIELD("Sys. LC No.");
              PurchaseLine.RESET;
              purchaseline.setrange("document no.","no.");
              if purchaseline.findfirst then begin
              repeat
              ProcessCheckList.RESET;
              ProcessCheckList.SETRANGE("Source ID",PurchaseLine."Document No.");
              PurchaseLine.CALCFIELDS(VIN);
              ProcessCheckList.CALCFIELDS(VIN);
              ProcessCheckList.SETRANGE(VIN,PurchaseLine.VIN);
              IF NOT ProcessCheckList.FINDFIRST THEN
                 ERROR(NoChecklistCreated);
              //LclVehPurchMngt.CheckVCPurchLine(Rec);
              //LclVehPurchMngt.CheckVCWiseQty(Rec);
              //LclVehPurchMngt.CheckTolerancePercent(Rec);
              UNTIL PurchaseLine.NEXT = 0;
            END;
            end;
             }

            Post(CODEUNIT::"Purch.-Post (Yes/No)");
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on "Action 80.OnAction".

        //trigger (Variable: SalesHeader)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on "Action 80.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Post(CODEUNIT::"Purch.-Post + Print");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*

            //Calling functions in codeunit 33020011 to check VC No. and Tolerance Percentage.

            //***SM 25/06/2013 to create vehicle checklist at each receiving point***
            IF VehicleTradeDocument THEN BEGIN
              TESTFIELD("Sys. LC No.");
              ProcessCheckList.RESET;
              PurchaseLine.RESET;
              PurchaseLine.CALCFIELDS(VIN);
              ProcessCheckList.SETRANGE("Source ID",PurchaseLine."Document No.");
              ProcessCheckList.SETRANGE(VIN,PurchaseLine.VIN);
              REPEAT
              IF NOT ProcessCheckList.FINDFIRST THEN
                ERROR(NoChecklistCreated);

              //LclVehPurchMngt.CheckVCPurchLine(Rec);
              //LclVehPurchMngt.CheckVCWiseQty(Rec);
              //LclVehPurchMngt.CheckTolerancePercent(Rec);
              UNTIL PurchaseLine.NEXT =0;
            END;
            Post(CODEUNIT::"Purch.-Post + Print");
            */
        //end;
        addafter("Action 228")
        {
            action(getservord)
            {
                Caption = 'Get &Service Orders';

                trigger OnAction()
                var
                    DistIntegration: Codeunit "5702";
                    PurchHeader: Record "38";
                begin
                    PurchHeader.COPY(Rec);
                    DistIntegration.GetSpecialServiceOrders(PurchHeader);
                    Rec := PurchHeader;
                end;
            }
            action("Show &Order")
            {
                Caption = 'Show &Order';
            }
            group("&Vehicle")
            {
                Caption = '&Vehicle';
                action("Process Checklists")
                {
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
                }
            }
        }
        addfirst("Action 68")
        {
            action("<Action1000000014>")
            {
                Caption = 'Calculte TDS';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CalculateTDS(); //TDS2.00
                end;
            }
        }
        addafter(MoveNegativeLines)
        {
            action("<Action1102159007>")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = GblShowLCApp;

                trigger OnAction()
                begin
                    //Calling function to send approval request.
                    GblDocAppMngt.sendAppReqLC(DATABASE::"Purchase Header",GblDocType::LC,"No.");
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = GblShowLCApp;

                trigger OnAction()
                begin
                    //Calling function to cancel approval request.
                    GblDocAppMngt.cancelAppReqLC(DATABASE::"Purchase Header",GblDocType::LC,"No.")
                end;
            }
            separator()
            {
            }
            action(ImportIndent)
            {
                Caption = 'Import Indent';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    PurchHdr: Record "38";
                begin
                    /*PurchHdr.RESET;
                    PurchHdr.SETRANGE("Document Type","Document Type");
                    PurchHdr.SETRANGE("No.","No.");
                    ImportIndent.SETTABLEVIEW(PurchHdr);
                    ImportIndent.RUN;*/

                end;
            }
            action(ExportPO)
            {
                Caption = 'Export Purchase Order';
                Image = Export;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = ShowExportForVCM;

                trigger OnAction()
                var
                    PurchLine: Record "39";
                    ExportForVCM: XMLport "50001";
                begin
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type","Document Type");
                    PurchLine.SETRANGE("Document No.","No.");
                    ExportForVCM.SETTABLEVIEW(PurchLine);
                    ExportForVCM.RUN;
                end;
            }
            action(MergeLines)
            {
                Caption = 'Merge Purchase Lines';
                Image = Replan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowExportForVCM;

                trigger OnAction()
                var
                    SpareReqMgt: Codeunit "33019831";
                    PurchaseHeader: Record "38";
                begin
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("Document Type","Document Type");
                    PurchaseHeader.SETRANGE("No.","No.");
                    IF PurchaseHeader.FINDFIRST THEN
                      SpareReqMgt.MergePurchaseLines(PurchaseHeader);
                end;
            }
        }
        addafter("Action 201")
        {
            action("Procument Memo")
            {
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Proc: Record "130415";
                begin
                    Proc.GET(Rec."Procument Memo No.");
                    IF Proc.Posted THEN
                      PAGE.RUN(PAGE::"Posted Procurement Memo",Proc)
                    ELSE
                      PAGE.RUN(PAGE::"Procurement Memo",Proc);
                end;
            }
        }
        addafter("Action 82")
        {
            action("Print Lube PO")
            {
                Caption = 'Print Lube PO';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                    REPORT.RUNMODAL(50034,TRUE,FALSE,PurchaseHeader);
                end;
            }
        }
        addafter(SendCustom)
        {
            action("<Action1101904032>")
            {
                Caption = 'Print';
                Image = ServiceAgreement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchaseLine: Record "39";
                    DocMgt: Codeunit "25006000";
                    DocReport: Record "25006011";
                begin
                    PurchaseLine.RESET;
                    DocMgt.PrintCurrentDoc("Document Profile", 2, 1, DocReport);
                    DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchaseLine,FALSE);
                end;
            }
            action(Action1101904033)
            {
                Caption = 'Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchaseLine: Record "39";
                    DocMgt: Codeunit "25006000";
                    DocReport: Record "25006011";
                begin
                    PurchaseLine.RESET;
                    DocMgt.PrintCurrentDoc("Document Profile", 2, 1, DocReport);
                    DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchaseLine,TRUE);
                end;
            }
        }
    }

    var
        SalesHeader: Record "36";
        LclVehPurchMngt: Codeunit "33020012";

    var
        SalesHeader: Record "36";
        LclVehPurchMngt: Codeunit "33020012";
        PurchHdr: Record "38";
        PurchLine: Record "39";

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        [InDataSet]
        ShowImportStrReq: Boolean;
        GblDocAppMngt: Codeunit "33019915";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        [InDataSet]
        GblShowLCApp: Boolean;
        [InDataSet]
        ShowExportForVCM: Boolean;
        [InDataSet]
        ServiceDocument: Boolean;
        PurchaseHeader: Record "38";
        [InDataSet]
        VehAccDocument: Boolean;
        [InDataSet]
        "Veh&SpareTrade": Boolean;
        UserSetup: Record "91";
        PurchaseLine: Record "39";
        ProcessCheckList: Record "25006025";
        ImportFilter: Boolean;
        NoChecklistCreated: Label 'The delivery checklist has not been created.Please create the checklist for this vehicle.';


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
        /*
        SetControlAppearance;
        //EDMS >>
          VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
          SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
          ServiceDocument := "Document Profile" = "Document Profile"::Service;
        //EDMS >>

        //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
          "Veh&SpareTrade" := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                           ("Document Profile" = "Document Profile"::"Spare Parts Trade");
        //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****

        {
        //Hiding Import Store Requisition.
        IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade","Document Profile"::"Spare Parts Trade"]) THEN
          ShowImportStrReq := FALSE
        ELSE
          ShowImportStrReq := TRUE;
        }

        //Show/Hide Approval and cancellation request.
        IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade"]) THEN
          GblShowLCApp := TRUE
        ELSE
          GblShowLCApp := FALSE;

        // Sipradi-YS BEGIN >> Hiding Export of Purchase Order For VCM
        IF ("Document Profile" IN ["Document Profile"::"Spare Parts Trade"]) THEN
          ShowExportForVCM := TRUE
        ELSE
          ShowExportForVCM := FALSE;

        IF ("Document Profile" IN ["Document Profile"::Service]) THEN
          ServiceDocument := TRUE
        ELSE
          ServiceDocument := FALSE;

        IF "Veh. Accessories Document" THEN
          VehAccDocument := TRUE;
        // Sipradi-YS END >>
        */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Responsibility Center" := UserMgt.GetPurchasesFilter;

        IF (NOT DocNoVisible) AND ("No." = '') THEN
          SetBuyFromVendorFromFilter;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF UserMgt.DefaultResponsibility THEN
          "Responsibility Center" := UserMgt.GetPurchasesFilter()
        ELSE
          "Accountability Center" := UserMgt.GetPurchasesFilter();
        IF (NOT DocNoVisible) AND ("No." = '') THEN
          SetBuyFromVendorFromFilter;

        //EDMS >>
          CASE DocumentProfileFilter OF
            FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Vehicles Trade";
              VehicleTradeDocument := TRUE;
              "Veh&SpareTrade" := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
              ShowImportStrReq := TRUE;
            END;
            FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Spare Parts Trade";
              SparePartDocument := TRUE;
              "Veh&SpareTrade" := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
              ShowExportForVCM := TRUE;
            END;

            FORMAT("Document Profile"::Service): BEGIN
              "Document Profile" := "Document Profile"::Service;
              ServiceDocument := TRUE;
            END;
          END;
        //EDMS >>
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SetDocNoVisible;

        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*

        FilterOnRecord;
        SetDocNoVisible;
        {
        #3..7
        }
        //EDMS >>
          FILTERGROUP(3);
          DocumentProfileFilter := GETFILTER("Document Profile");
          FILTERGROUP(0);
        //EDMS <<

        {
        //Hiding Import Store Requisition. Sangam Shrestha on 30 Jan 2012.
        IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade","Document Profile"::"Spare Parts Trade"]) THEN
          ShowImportStrReq := FALSE
        ELSE
          ShowImportStrReq := TRUE;
        }

        IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade"]) THEN
          GblShowLCApp := TRUE
        ELSE
          GblShowLCApp := FALSE;

        // Sipradi-YS BEGIN >> Hiding Export of Purchase Order For VCM / Service Document
        IF ("Document Profile" IN ["Document Profile"::"Spare Parts Trade"]) THEN
          ShowExportForVCM := TRUE
        ELSE
          ShowExportForVCM := FALSE;
        IF ("Document Profile" IN ["Document Profile"::Service]) THEN
          ServiceDocument := TRUE
        ELSE
          ServiceDocument := FALSE;

        IF "Veh. Accessories Document" THEN
          VehAccDocument := TRUE;

        // Sipradi-YS END >>
        */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetPurchasesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;
}

