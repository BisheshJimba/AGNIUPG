page 25006213 "Service Return Order EDMS"
{
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed
    // 
    // 23.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 14.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added to General Group:
    //     Correction
    //   Added Group:
    //     Application
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Service Return Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=FILTER(Return Order));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                    end;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No.";"Sell-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Sell-to Address";"Sell-to Address")
                {
                    Importance = Additional;
                }
                field("Sell-to Address 2";"Sell-to Address 2")
                {
                    Importance = Additional;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    Importance = Additional;
                }
                field("Sell-to City";"Sell-to City")
                {
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    Importance = Additional;
                }
                field("No. of Archived Versions";"No. of Archived Versions")
                {
                    Importance = Additional;
                }
                field("Posting Date";"Posting Date")
                {
                }
                field("Order Date";"Order Date")
                {
                    Importance = Promoted;
                }
                field("Order Time";"Order Time")
                {
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                    Importance = Additional;
                }
                field(VIN;VIN)
                {
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field(Kilometrage;Kilometrage)
                {
                    Visible = IsVFRun1Visible;
                }
                field("Work Status Code";"Work Status Code")
                {
                }
                field("Service Person";"Service Person")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Importance = Additional;
                }
                field("<Correction2>";Correction)
                {
                }
                field(Status;Status)
                {
                    Importance = Promoted;
                }
            }
            part(ServiceLines;25006214)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    Importance = Additional;
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    Importance = Additional;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    Importance = Additional;
                }
                field("Bill-to City";"Bill-to City")
                {
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date";"Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                }
                field("Payment Method Code";"Payment Method Code")
                {
                }
                field("Prices Including VAT";"Prices Including VAT")
                {

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                          VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                }
                field("Transaction Type";"Transaction Type")
                {
                }
                field("Transaction Specification";"Transaction Specification")
                {
                }
                field("Transport Method";"Transport Method")
                {
                }
                field("Exit Point";"Exit Point")
                {
                }
                field(Area;Area)
                {
                }
            }
            group(Application)
            {
                Caption = 'Application';
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("<Posting Date2>";"Posting Date")
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field("Finished Quantity (Hours)";"Finished Quantity (Hours)")
                {
                }
                field("Remaining Quantity (Hours)";"Remaining Quantity (Hours)")
                {
                }
                field("Planning Policy";"Planning Policy")
                {
                }
                field("<No. of Archived Versions2>";"No. of Archived Versions")
                {
                }
                field("Deal Type";"Deal Type")
                {
                }
                field("Location Code";"Location Code")
                {
                }
                field("Vehicle Accounting Cycle No.";"Vehicle Accounting Cycle No.")
                {
                }
                field("Vehicle Status Code";"Vehicle Status Code")
                {
                }
                field("Vehicle Item Charge No.";"Vehicle Item Charge No.")
                {
                }
                field(Correction;Correction)
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                field("Prepayment %";"Prepayment %")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        Prepayment37OnAfterValidate;
                    end;
                }
                field("Compress Prepayment";"Compress Prepayment")
                {
                }
                field("Prepmt. Payment Terms Code";"Prepmt. Payment Terms Code")
                {
                }
                field("Prepayment Due Date";"Prepayment Due Date")
                {
                    Importance = Promoted;
                }
                field("Prepmt. Payment Discount %";"Prepmt. Payment Discount %")
                {
                }
                field("Prepmt. Pmt. Discount Date";"Prepmt. Pmt. Discount Date")
                {
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
            }
            group("Service Address")
            {
                Caption = 'Service Address';
                field("Service Address Code";"Service Address Code")
                {
                }
                field("Service Address Name";"Service Address Name")
                {
                }
                field("Service Address";"Service Address")
                {
                }
                field("Service Address 2";"Service Address 2")
                {
                }
                field("Service Address Post Code";"Service Address Post Code")
                {
                }
                field("Service Address City";"Service Address City")
                {
                }
                field("Service Address Contact";"Service Address Contact")
                {
                }
            }
        }
        area(factboxes)
        {
            part(;25006253)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
                Visible = true;
            }
            part(;9080)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
                Visible = true;
            }
            part(;9082)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                Visible = false;
            }
            part(;9084)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
                Visible = false;
            }
            part(;9087)
            {
                Provider = ServiceLines;
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Line No.=FIELD(Line No.);
                Visible = true;
            }
            part(;9089)
            {
                Provider = ServiceLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(;9092)
            {
                SubPageLink = Table ID=CONST(36),
                              Document Type=FIELD(Document Type),
                              Document No.=FIELD(No.),
                              Status=CONST(Open);
                Visible = false;
            }
            part(;9108)
            {
                Provider = ServiceLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(;9109)
            {
                Provider = ServiceLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(;9081)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                Visible = false;
            }
            systempart(;Links)
            {
                Visible = false;
            }
            systempart(;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Return O&rder")
            {
                Caption = 'Return O&rder';
                action("<Action61>")
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        //CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Service Order Statistics EDMS",Rec);
                    end;
                }
                action("<Action62>")
                {
                    Caption = 'Customer Card';
                    Image = EditLines;
                    RunObject = Page 21;
                                    RunPageLink = No.=FIELD(Sell-to Customer No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904005>")
                {
                    Caption = 'V&ehicle Card';
                    Image = EditLines;
                    RunObject = Page 25006033;
                                    RunPageLink = Serial No.=FIELD(Vehicle Serial No.);
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Service Return Order),
                                  No.=FIELD(No.);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("A&pprovals")
                {
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Service Header EDMS","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
                }
            }
            group(Transfers)
            {
                Caption = 'Transfers';
                action("Transfer Orders")
                {
                    Caption = 'Transfer Orders';
                    Image = Documents;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupRetOrdTransf(Rec)
                    end;
                }
                action("Transfer Shipments")
                {
                    Caption = 'Transfer Shipments';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupRetTransferShipment(Rec)
                    end;
                }
                action("Transfer Receipts")
                {
                    Caption = 'Transfer Receipts';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupRetTransferReceipt(Rec)
                    end;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "25006119";
                    begin
                        ReleaseServiceDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "25006119";
                    begin
                        ReleaseServiceDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("<Action67>")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopyServDoc.SetServOrdHeader(Rec);
                        CopyServDoc.RUNMODAL;
                        CLEAR(CopyServDoc);
                    end;
                }
                action("Archi&ve Document")
                {
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchiveServiceDocument(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("Insert Service Package")
                {
                    Caption = 'Insert Service Package';
                    Image = CopyFromTask;

                    trigger OnAction()
                    begin
                        InsertServPackage
                    end;
                }
                action("<Action1101904013>")
                {
                    Caption = 'Create Transfer Order';
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "25006146";
                        ServTransfMgt: Codeunit "25006010";
                    begin
                        CurrPage.ServiceLines.PAGE.SetRecSelectionFilter(ServLine);
                        ServTransfMgt.SetTransferLineSelection(ServLine);
                        IF ServTransfMgt.CreateTransferOrder(Rec) THEN  //ratan
                          MESSAGE(Text101);
                        //ServTransfMgt.CreateTransferOrder(Rec);
                        IF ServTransfMgt.GetServiceChangeInfo THEN
                          MESSAGE(Text102);
                    end;
                }
                action("Send SMS")
                {
                    Caption = 'Send SMS';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        SendSMS: Page "25006404";
                                     UserSetup: Record "91";
                                     SalespersonCode: Code[10];
                    begin
                        UserSetup.GET(USERID);
                        IF UserSetup."Salespers./Purch. Code" <> '' THEN
                          SalespersonCode := UserSetup."Salespers./Purch. Code"
                        ELSE
                          SalespersonCode := Rec."Service Person";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(3);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904031>")
                {
                    Caption = 'Schedule';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                    begin
                        ServiceSchedule.RUN;
                    end;
                }
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "99000880" temporary;
                    begin
                        OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::Job);
                        OrderPromisingLine.SETRANGE("Source ID","No.");
                        PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                action("<Action250>")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action251>")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        // IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //   IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //     ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //   ELSE BEGIN
                        //     IF ApprovalMgt.TestServPayment(Rec) THEN
                        //       ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //     ELSE
                              CODEUNIT.RUN(CODEUNIT::"Service-Post (Yes/No) EDMS",Rec);
                        //   END;
                        // END;
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        // IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //   IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //     ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //   ELSE BEGIN
                        //     IF ApprovalMgt.TestServPayment(Rec) THEN
                        //       ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //     ELSE
                              CODEUNIT.RUN(CODEUNIT::"Service-Post+Print EDMS",Rec);
                        //   END;
                        // END;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible := IsVFActive(FIELDNO(Kilometrage));
        //IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        //IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //"Responsibility Center" := UserMgt.GetSalesFilter; Agni UPG 2009
        IF NOT UserMgt.DefaultResponsibility THEN
          "Accountability Center" := UserMgt.GetServiceFilterEDMS()
        ELSE
          "Responsibility Center" := UserMgt.GetServiceFilterEDMS();
    end;

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;
        *///Agni UPG 2009
        FilterOnRecord;
        SETRANGE("Date Filter",0D,WORKDATE - 1);

    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        CopyServDoc: Report "25006135";
                         ReportPrint: Codeunit "228";
                         DocPrint: Codeunit "229";
                         ArchiveManagement: Codeunit "5063";
                         UserMgt: Codeunit "5700";
                         ApprovalEntries: Page "658";
                         ChangeExchangeRate: Page "511";
                         Usage: Option "Order Confirmation","Work Order";
                         Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        Text101: Label 'Transfer Order is successfully created.';
        Text102: Label 'System changed values in Service Line field Planned Service Date.';
        ServInfoPaneMgt: Codeunit "25006104";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;

    [Scope('Internal')]
    procedure UpdateAllowed(): Boolean
    begin
        IF CurrPage.EDITABLE = FALSE THEN
          ERROR(Text000);
        EXIT(TRUE);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.ServiceLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.UPDATE;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetServiceFilterEDMS();
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

