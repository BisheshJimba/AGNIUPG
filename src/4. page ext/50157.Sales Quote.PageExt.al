pageextension 50157 pageextension50157 extends "Sales Quote"
{
    // 11.07.2016 EB.P30 #T089
    //   Added fields:
    //     "Make Code"
    //     "Model Code"
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 29.04.2016 EB.P7 #WSH_23
    //   Added new action - Copy Sales Quote to Service Quote;
    // 
    // 12.06.2015 EB.P30 #043
    //   Added field:
    //     "Quote Applicable To Date"
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *"Deal Type" field moved to the general tab
    // 
    // 09.01.2014 EDMS P8
    //   * Use Rec.DefineProfileRange
    // 
    // 13.08.2013 EDMS P8
    //   * Removed fields VIN,
    // 
    // 01.07.2013 EDMS P8
    //   * added action 'Vehicle Assembly'
    // 
    // pram -
    // 1. Nepali Month
    Editable = Action;
    Caption = 'Copy Document';

    //Unsupported feature: Property Insertion (Name) on ""Sales Quote"(Page 41)".

    Editable = true;
    Editable = ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.;

    //Unsupported feature: Property Insertion (ApplicationArea) on ""Sales Quote"(Page 41)".

    Caption = 'Send by &Email';

    //Unsupported feature: Property Insertion (Name) on ""Sales Quote"(Page 41)".

    Editable = ENU=Prepare to mail the document. The Send Email window opens prefilled with the customer's email address so you can add or edit information.;

    //Unsupported feature: Property Insertion (ApplicationArea) on ""Sales Quote"(Page 41)".

    Editable = true;
    Editable = true;
    Editable = Process;
    Editable = true;
    Editable = false;
    Editable = false;
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (Level) on "Control 8".


        //Unsupported feature: Property Modification (Level) on "Control 163".


        //Unsupported feature: Property Modification (Level) on "Control 12".


        //Unsupported feature: Property Modification (Level) on "Control 15".


        //Unsupported feature: Property Modification (Level) on "Control 30".


        //Unsupported feature: Property Modification (Level) on "Control 118".


        //Unsupported feature: Property Modification (Level) on "Control 10".


        //Unsupported feature: Property Modification (Level) on "Control 103".


        //Unsupported feature: Property Modification (Level) on "Control 170".


        //Unsupported feature: Property Modification (Level) on "Control 108".


        //Unsupported feature: Property Modification (Level) on "Control 192".


        //Unsupported feature: Property Modification (Level) on "Control 106".


        //Unsupported feature: Property Modification (Level) on "Control 55".


        //Unsupported feature: Property Modification (Level) on "Control 57".

        modify(SalesLines)
        {

            //Unsupported feature: Property Modification (Name) on "SalesLines(Control 58)".

            Caption = 'SalesLines';
            Visible = false;

            //Unsupported feature: Property Insertion (PartType) on "SalesLines(Control 58)".

        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 11".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906127307".

        modify("Control 83")
        {
            Visible = false;
        }
        addafter("Control 6")
        {
            field("Deal Type Code"; "Deal Type Code")
            {
            }
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                Enabled = SelltoCustomerTemplateCodeEnab;
                Importance = Promoted;
                ShowMandatory = true;

                trigger OnValidate()
                var
                    ApplicationAreaSetup: Record "9178";
                begin
                    SelltoCustomerNoOnAfterValidat;

                    CurrPage.UPDATE;

                    IF ApplicationAreaSetup.IsFoundationEnabled THEN
                        SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                end;
            }
            field("Prospect Line No."; "Prospect Line No.")
            {
                Enabled = ProspectLineEnable;
                Importance = Promoted;
            }
            field("Forwarded PI Quotes"; "Forwarded PI Quotes")
            {
            }
            field("Order Type"; "Order Type")
            {
            }
            field("Swift Code"; "Swift Code")
            {
            }
            field("Total CBM"; "Total CBM")
            {
                Editable = false;
            }
        }
        addfirst("Control 8")
        {
            field("Sell-to Customer Template Code"; Rec."Sell-to Customer Template Code")
            {
                ApplicationArea = Basic, Suite;
                Enabled = EnableSellToCustomerTemplateCode;
                Importance = Additional;

                trigger OnValidate()
                begin
                    ActivateFields;
                    CurrPage.UPDATE;
                end;
            }
            field("Province No."; "Province No.")
            {
            }
        }
        addfirst("Control 118")
        {
            field("Quote Applicable To Date"; "Quote Applicable To Date")
            {
            }
            field("Dealer PO No."; "Dealer PO No.")
            {
                Editable = false;
            }
            field("Dealer VIN"; "Dealer VIN")
            {
            }
        }
        addfirst("Control 170")
        {
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addfirst("Control 192")
        {
            field("Forward Accountability Center"; "Forward Accountability Center")
            {
            }
            field("Forward Location Code"; "Forward Location Code")
            {
            }
        }
        addfirst("Control 106")
        {
            field("Financed By No."; "Financed By No.")
            {
            }
            field("Re-Financed By"; "Re-Financed By")
            {
            }
            field("External Document No."; Rec."External Document No.")
            {
            }
            field("Nepali Month"; "Nepali Month")
            {
                Editable = true;
            }
            group("Letter of Credit/Delivery Order")
            {
                Caption = 'Letter of Credit/Delivery Order';
                Visible = VehicleTradeDocument;
                field("Sys. LC No."; "Sys. LC No.")
                {
                    Caption = 'LC / DO No.';
                }
            }
            part(SalesLines; 95)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = NOT VehicleTradeDocument;
            }
            part(SalesLinesVeh; 25006486)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 55")
        {
            field("Phone No."; "Phone No.")
            {
                Importance = Additional;
            }
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                Importance = Additional;
            }
        }
        addafter(SalesLines)
        {
            part("SalesLinesVeh "; 25006486)
            {
                Caption = 'SalesLinesVeh';
                SubPageLink = Document No.=FIELD(No.);
                    Visible = false;
            }
        }
        addafter("Control 1907468901")
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                Visible = SparePartDocument;
                field("<Vehicle Serial No.2>"; "Vehicle Serial No.")
                {
                }
                field("<VIN2>"; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (Level) on "Action 59".


        //Unsupported feature: Property Modification (Image) on "Action 59".

        modify(Statistics)
        {

            //Unsupported feature: Property Modification (Name) on "Statistics(Action 61)".

            Caption = 'Get Recurring Sales Lines';

            //Unsupported feature: Property Modification (Image) on "Statistics(Action 61)".


            //Unsupported feature: Property Insertion (Ellipsis) on "Statistics(Action 61)".

            ToolTip = 'Get standard sales lines that are available to assign to customers.';
            ApplicationArea = Suite;
        }

        //Unsupported feature: Property Modification (Image) on "Action 63".

        modify(Print)
        {
            Caption = 'Co&mments';

            //Unsupported feature: Property Modification (Image) on "Print(Action 69)".


            //Unsupported feature: Property Insertion (RunObject) on "Print(Action 69)".


            //Unsupported feature: Property Insertion (RunPageLink) on "Print(Action 69)".

        }
        modify(Email)
        {
            Caption = 'Assembly Orders';

            //Unsupported feature: Property Modification (Image) on "Email(Action 9)".

        }
        modify(CopyDocument)
        {

            //Unsupported feature: Property Modification (Name) on "CopyDocument(Action 66)".

            Caption = '&Print';
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
            ApplicationArea = Basic, Suite;

            //Unsupported feature: Property Modification (Image) on "CopyDocument(Action 66)".

            Visible = NOT IsOfficeAddin;
        }
        modify(CalculateInvoiceDiscount)
        {
            Visible = false;
        }
        modify("Action 1900000004")
        {
            Visible = false;
        }


        //Unsupported feature: Code Insertion (VariableCollection) on "GetRecurringSalesLines(Action 61).OnAction".

        //trigger (Variable: StdCustSalesCode)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on "Statistics(Action 61).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        OnBeforeStatisticsAction(Rec,Handled);
        IF NOT Handled THEN BEGIN
          CalcInvDiscForHeader;
          COMMIT;
          PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
          SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
        END
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        */
        //end;

        //Unsupported feature: Property Deletion (ShortCutKey) on "Statistics(Action 61)".


        //Unsupported feature: Property Deletion (Promoted) on "Statistics(Action 61)".


        //Unsupported feature: Property Deletion (PromotedCategory) on "Statistics(Action 61)".


        //Unsupported feature: Property Deletion (RunObject) on "Action 63".


        //Unsupported feature: Property Deletion (RunPageLink) on "Action 63".

        modify(Print)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "Print(Action 69)".


        //Unsupported feature: Property Deletion (Ellipsis) on "Print(Action 69)".


        //Unsupported feature: Property Deletion (ToolTipML) on "Print(Action 69)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Print(Action 69)".


        //Unsupported feature: Property Deletion (Visible) on "Print(Action 69)".



        //Unsupported feature: Code Insertion (VariableCollection) on "Action 9.OnAction".

        //trigger (Variable: AssembleToOrderLink)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on "Email(Action 9).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CheckSalesCheckAllLinesHaveQuantityAssigned;
        IF NOT FIND THEN
          INSERT(TRUE);
        DocPrint.EmailSalesHeader(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        */
        //end;

        //Unsupported feature: Property Deletion (Name) on "Email(Action 9)".


        //Unsupported feature: Property Deletion (ToolTipML) on "Email(Action 9)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Email(Action 9)".


        //Unsupported feature: Property Deletion (Promoted) on "Email(Action 9)".


        //Unsupported feature: Property Deletion (PromotedIsBig) on "Email(Action 9)".


        //Unsupported feature: Property Deletion (PromotedCategory) on "Email(Action 9)".


        //Unsupported feature: Property Deletion (PromotedOnly) on "Email(Action 9)".

        modify(GetRecurringSalesLines)
        {
            Visible = false;
        }
        modify(CopyDocument)
        {
            Visible = false;
        }


        //Unsupported feature: Code Modification on ""Make Order"(Action 68).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
          CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Order (Yes/No)",Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        // CNY.CRM >>
        {IF ("Sell-to Contact No." <> '') AND ("Document Profile" = "Document Profile" :: "Vehicles Trade") THEN
          TESTFIELD("Prospect Line No.");
          }
        // CNY.CRM <<

        //ArchiveManagement.ArchiveSalesDocument(Rec); // CNY.CRM
        IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN BEGIN  //Min >>
          ShipToAddress.RESET;
          ShipToAddress.SETRANGE("Customer No.","Sell-to Customer No.");
          IF ShipToAddress.FINDFIRST THEN BEGIN
            //TESTFIELD("Ship-to Code");
            TESTFIELD("Ship-to Name");
            TESTFIELD("Ship-to Address");
            //TESTFIELD("Ship-to Address 2");
            TESTFIELD("Ship-to City");
            TESTFIELD("Province No.");
            END;
         END;
        recSalesHdr.COPY(Rec);

        IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
          CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Order (Yes/No)",Rec);
        */
        //end;


        //Unsupported feature: Code Modification on "Release(Action 115).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ReleaseSalesDoc.PerformManualRelease(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        // CNY.CRM >>
        IF ("Sell-to Contact No." <> '') AND ("Document Profile" = "Document Profile" :: "Vehicles Trade") THEN
          TESTFIELD("Prospect Line No.");
        // CNY.CRM <<

        ReleaseSalesDoc.PerformManualRelease(Rec);
        */
        //end;
        addfirst(processing)
        {
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
            }
            action(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F7';

                trigger OnAction()
                begin
                    Rec.CalcInvDiscForHeader;
                    COMMIT;
                    PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec);
                end;
            }
            action("<Action63>")
            {
                Caption = 'Terms && Conditions';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 33020234;
                RunPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
            }
            action(Forward)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Forward Sales';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ForwardSalesQuote(Rec);  //ratan 7.22.2020
                end;
            }
        }
        addafter(CalculateInvoiceDiscount)
        {
            action("<Action1000000018>")
            {
                Caption = 'Get Dealer Discount';
                Image = CalculateInvoiceDiscount;

                trigger OnAction()
                begin
                    ShowDiscounts
                end;
            }
        }
        addafter("Archive Document")
        {
            action("Copy Document to Service Quote")
            {
                Caption = 'Copy Document to Service Quote';
                Image = Copy;

                trigger OnAction()
                var
                    ServiceQuote: Record "25006145";
                begin
                    CopyDocMgt.CopySalesQuoteToServQuote(ServiceQuote,"No.");
                end;
            }
        }
        addafter("Action 64")
        {
            group("<Action223>")
            {
                Caption = '&Print';
                action("<Action1101904032>")
                {
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = VehPrint;

                    trigger OnAction()
                    var
                        SalesLine: Record "37";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                        SalesHeader: Record "36";
                    begin
                        /*SalesLine.RESET;
                        DocMgt.PrintCurrentDoc("Document Profile", 1, 0, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine,FALSE);
                        */
                        
                        IF Customer.GET("Sell-to Customer No.") THEN
                          IF Customer."Is Dealer" THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(SalesHeader);
                            REPORT.RUNMODAL(33020205,TRUE,FALSE,SalesHeader);
                          END ELSE BEGIN
                            SalesLine.RESET;
                            DocMgt.PrintCurrentDoc("Document Profile", 1, 0, DocReport);
                            DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine,FALSE);
                        END
                        ELSE BEGIN
                            SalesLine.RESET;
                            DocMgt.PrintCurrentDoc("Document Profile", 1, 0, DocReport);
                            DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine,FALSE);
                        END;

                    end;
                }
                action("School Proforma")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesHeader: Record "36";
                    begin
                        CurrPage.SETSELECTIONFILTER(SalesHeader);
                        REPORT.RUNMODAL(33020053, TRUE, TRUE, SalesHeader);
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
                        SalesLine: Record "37";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        SalesLine.RESET;
                        DocMgt.PrintCurrentDoc("Document Profile", 1, 0, DocReport);
                        DocMgt.SelectSalesDocReport(DocReport, Rec, SalesLine,TRUE);
                    end;
                }
                action(SparePartsPrint)
                {
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = SparePrint;

                    trigger OnAction()
                    var
                        SalesHeader: Record "36";
                    begin
                        IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN BEGIN //Min >>
                          ShipToAddress.RESET;
                          ShipToAddress.SETRANGE("Customer No.","Sell-to Customer No.");
                          IF ShipToAddress.FINDFIRST THEN BEGIN
                            //TESTFIELD("Ship-to Code");
                            TESTFIELD("Ship-to Name");
                            TESTFIELD("Ship-to Address");
                            //TESTFIELD("Ship-to Address 2");
                            TESTFIELD("Ship-to City");
                            TESTFIELD("Province No.");
                            END;
                         END;
                        CurrPage.SETSELECTIONFILTER(SalesHeader);
                        REPORT.RUNMODAL(33020211, TRUE, TRUE, SalesHeader);
                    end;
                }
                action("Get Student Fee Component")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = VisibleStudentFeeComp;

                    trigger OnAction()
                    begin
                        SalesLines.RESET;
                        SalesLines.SETRANGE("Document No.","No.");
                        SalesLines.SETRANGE("Document Type","Document Type");
                        SalesLines.DELETEALL;
                        InsertSalesQuotesLines;
                    end;
                }
            }
        }
        moveafter("Action 146";Print)
        moveafter("Action 69";CopyDocument)
        moveafter(Print;"Action 63")
        moveafter(Email;Statistics)
    }

    var
        StdCustSalesCode: Record "172";

    var
        AssembleToOrderLink: Record "904";

    var
        recSalesHdr: Record "36";


    //Unsupported feature: Property Modification (Id) on "SalesHeaderArchive(Variable 1006)".

    //var
        //>>>> ORIGINAL VALUE:
        //SalesHeaderArchive : 1006;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //SalesHeaderArchive : 100601;
        //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DocNoVisible(Variable 1001)".

    //var
        //>>>> ORIGINAL VALUE:
        //DocNoVisible : 1001;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //DocNoVisible : 1050;
        //Variable type has not been exported.

    var
        SingleInstanceMgt: Codeunit "25006001";
        [InDataSet]
        BilltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        SelltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        "Sell-to Customer No.Enable": Boolean;
        [InDataSet]
        "Bill-to Customer No.Enable": Boolean;

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        LostSaleMgt: Codeunit "25006504";
        TextDlg001: Label 'Default,Spare Parts Trade,Vehicles Trade';
        Selected: Integer;
        CopyDocMgt: Codeunit "6620";
        Text000: Label 'Unable to run this function while in View mode.';
        "-----------------CNY.CRM------": Integer;
        [InDataSet]
        ProspectLineEnable: Boolean;
        SalesPriceCalcMgt: Codeunit "7000";
        Customer: Record "18";
        "Nepali Month": Text[30];
        EnglishNepaliRec: Record "33020302";
        [InDataSet]
        VehPrint: Boolean;
        [InDataSet]
        SparePrint: Boolean;
        SalesHdr: Record "36";
        SchoolSalesQuotesLine: Record "33020184";
        SalesLines: Record "37";
        VisibleStudentFeeComp: Boolean;
        ShipToAddress: Record "222";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ActivateFields;
        SetControlAppearance;
        WorkDescription := GetWorkDescription;
        UpdateShipToBillToGroupVisibility
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //EDMS >>
          VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
          SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
        //EDMS >>

        #1..3
        UpdateShipToBillToGroupVisibility;
        //MIN for spare sales quotes 5/31/2019
        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
          VehPrint := TRUE;
          SparePrint := FALSE;
        END;
        IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN BEGIN
            SparePrint := TRUE;
            VehPrint := FALSE;
        END;
        IF COMPANYNAME = 'JOHN DEWEY H.S. SCHOOL' THEN //Min 4.22.2020
          VisibleStudentFeeComp := TRUE
        ELSE
          VisibleStudentFeeComp := FALSE;
        */
    //end;


    //Unsupported feature: Code Modification on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        LostSaleMgt.OnSalesHeaderDelete(Rec); //EDMS
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
        */
    //end;


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        EnableBillToCustomerNo := TRUE;
        EnableSellToCustomerTemplateCode := TRUE;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        EnableBillToCustomerNo := TRUE;
        EnableSellToCustomerTemplateCode := TRUE;

        // CNY.CRM
        ProspectLineEnable := TRUE;
        */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
        /*
        xRec.INIT;
        "Responsibility Center" := UserMgt.GetSalesFilter;
        IF (NOT DocNoVisible) AND ("No." = '') THEN
          SetSellToCustomerFromFilter;

        SetDefaultPaymentServices;
        SetControlAppearance;
        UpdateShipToBillToGroupVisibility;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        xRec.INIT;

        IF UserMgt.DefaultResponsibility THEN
          "Responsibility Center" := UserMgt.GetSalesFilter
        ELSE
          "Accountability Center" := UserMgt.GetSalesFilter;

        #3..8
        DefineProfileRange;
        //EDMS >>
          CASE DocumentProfileFilter OF
            FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Vehicles Trade";
              VehicleTradeDocument := TRUE;
            END;
            FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
              "Document Profile" := "Document Profile"::"Spare Parts Trade";
              SparePartDocument := TRUE;
            END;
          END;
        //EDMS >>

        //OnAfterGetCurrRecord;//29.01.2012 EDMS
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
          FILTERGROUP(0);
        END;

        ActivateFields;

        SetDocNoVisible;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        SetControlAppearance;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        FilterOnRecord;
        {
        #1..5
        }
        //EDMS >>
          FILTERGROUP(3);
          DocumentProfileFilter := GETFILTER("Document Profile");
          FILTERGROUP(0);
        //EDMS <<
        #6..11

        // CNY.CRM
        ProspectLineEnable := "Sell-to Contact No." <> '';

        //pram for school
        IF "Order Date" <> 0D THEN BEGIN
          EnglishNepaliRec.RESET;
          EnglishNepaliRec.SETRANGE("English Date", "Order Date");
          IF EnglishNepaliRec.FINDFIRST THEN
            "Nepali Month" := FORMAT(EnglishNepaliRec."Nepali Month");
          END;
        */
    //end;

    //Unsupported feature: ReturnValue Insertion (ReturnValue: <Blank>) (ReturnValueCollection) on "UpdateAllowed(PROCEDURE 1)".


    //Unsupported feature: Property Modification (Name) on "UpdatePaymentService(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "UpdatePaymentService(PROCEDURE 1)".

    //procedure UpdatePaymentService();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF CurrPage.EDITABLE = FALSE THEN BEGIN
          MESSAGE(Text000);
          EXIT(FALSE);
        END;
        EXIT(TRUE);
        */
    //end;

    local procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "1060";
    begin
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        ClearSellToFilter;
        ActivateFields;
        CurrPage.UPDATE;
    end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;

    procedure ShowDiscounts()
    var
        SalesLine: Record "37";
        Customer: Record "18";
    begin
        IF Customer.GET("Sell-to Customer No.") THEN BEGIN
          IF Customer."Is Dealer" THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            SalesLine.SETRANGE("Line Type",SalesLine."Line Type"::Vehicle);
            IF SalesLine.FINDSET THEN BEGIN
              SalesLine.TESTFIELD("Model Version No.");
              SalesLine.TESTFIELD("Unit Price");
              CLEAR(SalesPriceCalcMgt);
              SalesPriceCalcMgt.GetInvoiceDiscount(Rec,SalesLine);
            END;
           END;
        END;
    end;

    local procedure InsertSalesQuotesLines()
    begin
        SchoolSalesQuotesLine.RESET;
        SchoolSalesQuotesLine.SETCURRENTKEY("Document Type","Line No.","Customer No.");
        SchoolSalesQuotesLine.SETRANGE("Customer No.",Rec."Sell-to Customer No.");
        SchoolSalesQuotesLine.SETRANGE("Document Type","Document Type"::Quote);
        IF SchoolSalesQuotesLine.FINDFIRST THEN BEGIN
          REPEAT
            SalesLines.RESET;
            SalesLines."Line No." := SalesLines."Line No." + 10000;
            SalesLines.INIT;
            SalesLines."Document No." := Rec."No.";
            SalesLines."Document Type" := SchoolSalesQuotesLine."Document Type";
            SalesLines.Type := SchoolSalesQuotesLine.Type;
            SalesLines."No." := SchoolSalesQuotesLine."Component No.";
            SalesLines.Description := SchoolSalesQuotesLine.Description;
            SalesLines."Sell-to Customer No." := SchoolSalesQuotesLine."Customer No.";
            SalesLines.Quantity := SchoolSalesQuotesLine.Quantity;
            SalesLines."Location Code" := SchoolSalesQuotesLine."Location Code";
            SalesLines."Unit Price" := SchoolSalesQuotesLine."Unit Price";
            SalesLines."Line Amount" := SchoolSalesQuotesLine."Unit Price";
            SalesLines.INSERT(TRUE);
          UNTIL SchoolSalesQuotesLine.NEXT = 0;
          END;
    end;

    //Unsupported feature: Deletion (VariableCollection) on "UpdatePaymentService(PROCEDURE 1).PaymentServiceSetup(Variable 1000)".

}

