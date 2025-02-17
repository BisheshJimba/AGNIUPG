page 33019845 "Import Purchase Order"
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

    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Requisition';
    RefreshOnActivate = true;
    SourceTable = Table38;
    SourceTableView = WHERE(Document Type=FILTER(Order),
                            Import Purch. Order=CONST(Yes));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                    Visible = true;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                    end;
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {

                    trigger OnValidate()
                    begin
                        IF GETFILTER("Buy-from Vendor No.") = xRec."Buy-from Vendor No." THEN
                          IF "Buy-from Vendor No." <> xRec."Buy-from Vendor No." THEN
                            SETRANGE("Buy-from Vendor No.");

                        CurrPage.UPDATE;
                    end;
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor';
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies detailed information about the vendor on the selected purchase document.';

                    trigger OnValidate()
                    begin
                        IF GETFILTER("Buy-from Vendor No.") = xRec."Buy-from Vendor No." THEN
                          IF "Buy-from Vendor No." <> xRec."Buy-from Vendor No." THEN
                            SETRANGE("Buy-from Vendor No.");

                        CurrPage.UPDATE;
                    end;
                }
                field("Posting Description";"Posting Description")
                {
                }
                group("Buy-from")
                {
                    Caption = 'Buy-from';
                    field("Buy-from Address";"Buy-from Address")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address';
                        Importance = Additional;
                        ToolTip = 'Specifies the vendor''s buy-from address.';
                    }
                    field("Buy-from Address 2";"Buy-from Address 2")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address 2';
                        Importance = Additional;
                        ToolTip = 'Specifies an additional part of the vendor''s buy-from address.';
                    }
                    field("Buy-from Post Code";"Buy-from Post Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Post Code';
                        Importance = Additional;
                    }
                    field("Buy-from City";"Buy-from City")
                    {
                        ApplicationArea = Suite;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Buy-from Contact No.";"Buy-from Contact No.")
                    {
                        Caption = 'Contact No.';
                        Importance = Additional;
                    }
                }
                field("Buy-from Contact";"Buy-from Contact")
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date of the vendor''s invoice.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the posting date of the record.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the purchase invoice is due for payment.';
                }
                field("Vendor Invoice No.";"Vendor Invoice No.")
                {
                    ApplicationArea = Suite;
                    ShowMandatory = VendorInvoiceNoMandatory;
                    ToolTip = 'Specifies the vendor''s own invoice number.';
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies which purchaser is associated with the order.';

                    trigger OnValidate()
                    begin
                        PurchaserCodeOnAfterValidate;
                    end;
                }
                field("No. of Archived Versions";"No. of Archived Versions")
                {
                    Importance = Additional;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the item is ordered. It is calculated backwards from the Planned Receipt Date field in combination with the Lead Time Calculation field.';
                }
                field("Quote No.";"Quote No.")
                {
                    Importance = Additional;
                }
                field("Vendor Order No.";"Vendor Order No.")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor''s order number.';
                }
                field("Vendor Shipment No.";"Vendor Shipment No.")
                {
                }
                field("Vendor Invoice No. ";"Vendor Invoice No.")
                {
                    Caption = 'Vendor Invoice No./Date';
                }
                field("Purch. VAT No.";"Purch. VAT No.")
                {
                }
                field("Order Address Code";"Order Address Code")
                {
                    Importance = Additional;
                }
                field("Location Code";"Location Code")
                {
                }
                field("Accountability Center";"Accountability Center")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Importance = Additional;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    Importance = Additional;
                }
                field(Status;Status)
                {
                    Importance = Promoted;
                }
                field("Job Queue Status";"Job Queue Status")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = JobQueueUsed;
                }
                field("Deal Type Code";"Deal Type Code")
                {
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                }
                field("Service Order No.";"Service Order No.")
                {
                    Visible = ServiceDocument;
                }
                field("Order Type";"Order Type")
                {
                    Visible = ShowExportForVCM;
                }
                field("Import Invoice No.";"Import Invoice No.")
                {
                }
                field("Pragyapan Patra No.";"Pragyapan Patra No.")
                {
                    Caption = 'Pragyapan Patra No./Date';
                }
                field("Veh. Accesories Memo No.";"Veh. Accesories Memo No.")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                    Visible = VehAccDocument;
                }
                field("Accessories Total Amount";"Accessories Total Amount")
                {
                    DrillDown = true;
                    Lookup = true;
                    Style = Standard;
                    StyleExpr = TRUE;
                    Visible = VehAccDocument;
                }
                field(Remarks;Remarks)
                {
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                }
                field("Approved User ID";"Approved User ID")
                {
                }
                field("Import Purch. Order";"Import Purch. Order")
                {
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the currency of amounts on the purchase document.';

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ChangeExchangeRate);
                        IF "Posting Date" <> 0D THEN
                          ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date")
                        ELSE
                          ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                          VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                        PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                    end;
                }
                field(Narration;Narration)
                {
                }
                field("Total CBM";"Total CBM")
                {
                    Editable = false;
                }
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                field("Sys. LC No.";"Sys. LC No.")
                {
                }
                field("Bank LC No.";"Bank LC No.")
                {
                }
                field("LC Amend No.";"LC Amend No.")
                {
                    Caption = 'Amendment No.';
                    Importance = Promoted;
                }
            }
            part(PurchLines;54)
            {
                ApplicationArea = Suite;
                SubPageLink = Document No.=FIELD(No.);
                UpdatePropagation = Both;
                Visible = NOT VehicleTradeDocument;
            }
            part(PurchLinesVehicle;25006477)
            {
                SubPageLink = Document No.=FIELD(No.);
                Visible = VehicleTradeDocument;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
                }
                field("Prices Including VAT";"Prices Including VAT")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies whether the unit price on the line should be displayed including or excluding VAT.';

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which VAT business posting group was used when the VAT entry was posted.';
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code that represents the payment terms that apply to the purchase order.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how payment for the purchase document must be submitted.';
                }
                field("Transaction Type";"Transaction Type")
                {
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
                field("Payment Discount %";"Payment Discount %")
                {
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the last date on which the amount in the purchase order must be paid for the order to qualify for a payment discount.';
                }
                field("Location Code ";"Location Code")
                {
                    Importance = Promoted;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                }
                field("Payment Reference";"Payment Reference")
                {
                }
                field("Creditor No.";"Creditor No.")
                {
                }
                field("On Hold";"On Hold")
                {
                }
                field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
                {
                    Importance = Additional;
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    Importance = Additional;
                }
                field("Requested Receipt Date";"Requested Receipt Date")
                {
                }
                field("Promised Receipt Date";"Promised Receipt Date")
                {
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the customer that the items are shipped to directly from your vendor, as a drop shipment.';
                }
                field(Correction;Correction)
                {
                }
            }
            part("PurchLinesVehicle ";25006477)
            {
                Caption = 'PurchLinesVehicle';
                SubPageLink = Document No.=FIELD(No.);
                Visible = VehicleTradeDocument;
            }
            group("Shipping and Payment")
            {
                Caption = 'Shipping and Payment';
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    field("Ship-to Code";"Ship-to Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Code';
                    }
                    field("Ship-to Name";"Ship-to Name")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Name';
                        Importance = Additional;
                    }
                    field("Ship-to Address";"Ship-to Address")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address';
                        Importance = Additional;
                        ToolTip = 'Specifies the vendor''s buy-from address.';
                    }
                    field("Ship-to Address 2";"Ship-to Address 2")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address 2';
                        Importance = Additional;
                        ToolTip = 'Specifies an additional part of the vendor''s buy-from address.';
                    }
                    field("Ship-to Post Code";"Ship-to Post Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Post Code';
                        Importance = Additional;
                    }
                    field("Ship-to City";"Ship-to City")
                    {
                        ApplicationArea = Suite;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Ship-to Contact";"Ship-to Contact")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Contact';
                        Importance = Additional;
                    }
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                }
                group("Pay-to")
                {
                    Caption = 'Pay-to';
                    field("Pay-to Name";"Pay-to Name")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Name';
                        Importance = Promoted;
                    }
                    field("Pay-to Address";"Pay-to Address")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address';
                        Importance = Additional;
                        ToolTip = 'Specifies the vendor''s buy-from address.';
                    }
                    field("Pay-to Address 2";"Pay-to Address 2")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address 2';
                        Importance = Additional;
                        ToolTip = 'Specifies an additional part of the vendor''s buy-from address.';
                    }
                    field("Pay-to Post Code";"Pay-to Post Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Post Code';
                        Importance = Additional;
                    }
                    field("Pay-to City";"Pay-to City")
                    {
                        ApplicationArea = Suite;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Pay-to Contact No.";"Pay-to Contact No.")
                    {
                        Caption = 'Contact No.';
                        Importance = Additional;
                    }
                    field("Pay-to Contact";"Pay-to Contact")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Contact';
                        Importance = Additional;
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Specification";"Transaction Specification")
                {
                }
                field("Transport Method";"Transport Method")
                {
                }
                field("Entry Point";"Entry Point")
                {
                }
                field(Area;Area)
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
                field("Vendor Cr. Memo No.";"Vendor Cr. Memo No.")
                {
                }
            }
        }
        area(factboxes)
        {
            part(;9103)
            {
                ApplicationArea = Suite;
                SubPageLink = Table ID=CONST(38),
                              Document Type=FIELD(Document Type),
                              Document No.=FIELD(No.);
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(;9090)
            {
                Provider = PurchLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(ApprovalFactBox;9092)
            {
                Visible = false;
            }
            part(;9093)
            {
                SubPageLink = No.=FIELD(Buy-from Vendor No.);
                Visible = false;
            }
            part(;9094)
            {
                SubPageLink = No.=FIELD(Pay-to Vendor No.);
            }
            part(IncomingDocAttachFactBox;193)
            {
                ShowFilter = false;
                Visible = false;
            }
            part(;9095)
            {
                SubPageLink = No.=FIELD(Buy-from Vendor No.);
            }
            part(;9096)
            {
                SubPageLink = No.=FIELD(Pay-to Vendor No.);
                Visible = false;
            }
            part(;9100)
            {
                ApplicationArea = Suite;
                Provider = PurchLines;
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Line No.=FIELD(Line No.);
            }
            part(WorkflowStatus;1528)
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            part(;25006096)
            {
                Provider = PurchLines;
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Line No.=FIELD(Line No.);
                Visible = false;
            }
            systempart(;Links)
            {
                Visible = false;
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action(Dimensions)
                {
                    AccessByPermission = TableData 348=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        OpenPurchaseOrderStatistics;
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    RunObject = Page 26;
                                    RunPageLink = No.=FIELD(Buy-from Vendor No.);
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the vendor.';
                }
                action(Approvals)
                {
                    AccessByPermission = TableData 454=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "658";
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 66;
                                    RunPageLink = Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Receipts)
                {
                    ApplicationArea = Suite;
                    Caption = 'Receipts';
                    Image = PostedReceipts;
                    RunObject = Page 145;
                                    RunPageLink = Order No.=FIELD(No.);
                    RunPageView = SORTING(Order No.);
                }
                action(Invoices)
                {
                    ApplicationArea = Suite;
                    Caption = 'Invoices';
                    Image = Invoice;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    RunObject = Page 146;
                                    RunPageLink = Order No.=FIELD(No.);
                    RunPageView = SORTING(Order No.);
                }
                action(PostedPrepaymentInvoices)
                {
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page 146;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
                }
                action(PostedPrepaymentCrMemos)
                {
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page 147;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                separator()
                {
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    RunObject = Page 5774;
                                    RunPageLink = Source Document=CONST(Purchase Order),
                                  Source No.=FIELD(No.);
                    RunPageView = SORTING(Source Document,Source No.,Location Code);
                }
                action("Whse. Receipt Lines")
                {
                    Caption = 'Whse. Receipt Lines';
                    Image = ReceiptLines;
                    RunObject = Page 7342;
                                    RunPageLink = Source Type=CONST(39),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                    RunPageView = SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                }
                separator()
                {
                }
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment';
                    Image = Delivery;
                    action(Warehouse_GetSalesOrder)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Get &Sales Order';
                        Image = "Order";
                        RunObject = Codeunit 76;
                        ToolTip = 'Select the sales order that must be linked to the purchase order, for drop shipment. ';
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action("Get &Sales Order")
                    {
                        AccessByPermission = TableData 110=R;
                        Caption = 'Get &Sales Order';
                        Image = "Order";

                        trigger OnAction()
                        var
                            PurchHeader: Record "38";
                            DistIntegration: Codeunit "5702";
                        begin
                            PurchHeader.COPY(Rec);
                            DistIntegration.GetSpecialOrders(PurchHeader);
                            Rec := PurchHeader;
                        end;
                    }
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
                }
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
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                separator()
                {
                }
                action(Release)
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "415";
                    begin
                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Enabled = Status <> Status::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "415";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
                separator()
                {
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
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
                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData 24=R;
                    ApplicationArea = Suite;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    ToolTip = 'Calculate the discount that can be granted based on all lines in the purchase document.';

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                separator()
                {
                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    ApplicationArea = Suite;
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    Image = VendorCode;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "175";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator()
                {
                }
                action(CopyDocument)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RUNMODAL;
                        CLEAR(CopyPurchDoc);
                        IF GET("Document Type","No.") THEN;
                    end;
                }
                action(MoveNegativeLines)
                {
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;
                    Image = MoveNegativeLines;

                    trigger OnAction()
                    begin
                        CLEAR(MoveNegPurchLines);
                        MoveNegPurchLines.SetPurchHeader(Rec);
                        MoveNegPurchLines.RUNMODAL;
                        MoveNegPurchLines.ShowDocument;
                    end;
                }
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
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment';
                    Image = Delivery;
                    action(Functions_GetSalesOrder)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Get &Sales Order';
                        Image = "Order";
                        RunObject = Codeunit 76;
                        ToolTip = 'Select the sales order that must be linked to the purchase order, for drop shipment. ';
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action("Get &Sales Order")
                    {
                        AccessByPermission = TableData 110=R;
                        Caption = 'Get &Sales Order';
                        Image = "Order";

                        trigger OnAction()
                        var
                            PurchHeader: Record "38";
                            DistIntegration: Codeunit "5702";
                        begin
                            PurchHeader.COPY(Rec);
                            DistIntegration.GetSpecialOrders(PurchHeader);
                            Rec := PurchHeader;
                        end;
                    }
                }
                action("Archive Document")
                {
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("Send IC Purchase Order")
                {
                    AccessByPermission = TableData 410=R;
                    Caption = 'Send IC Purchase Order';
                    Image = IntercompanyOrder;

                    trigger OnAction()
                    var
                        ICInOutboxMgt: Codeunit "427";
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                          ICInOutboxMgt.SendPurchDoc(Rec,FALSE);
                    end;
                }
                separator()
                {
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Suite;
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "130";
                        begin
                            IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData 130=R;
                        ApplicationArea = Suite;
                        Caption = 'Select Incoming Document';
                        Image = SelectLineToApply;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "130";
                        begin
                            VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = CreateIncomingDocumentEnabled;
                        Image = Attach;
                        ToolTip = 'Create an incoming document from a file that you select from the disk. The file will be attached to the incoming document record.';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "133";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "130";
                        begin
                            IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                              IncomingDocument.RemoveLinkToRelatedRecord;
                            "Incoming Document Entry No." := 0;
                            MODIFY(TRUE);
                        end;
                    }
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                          ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "1535";
                    begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    end;
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Create &Whse. Receipt")
                {
                    AccessByPermission = TableData 7316=R;
                    Caption = 'Create &Whse. Receipt';
                    Image = NewReceipt;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "5751";
                    begin
                        GetSourceDocInbound.CreateFromPurchOrder(Rec);

                        IF NOT FIND('=><') THEN
                          INIT;
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    AccessByPermission = TableData 7340=R;
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;

                        IF NOT FIND('=><') THEN
                          INIT;
                    end;
                }
                separator()
                {
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Suite;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        SalesHeader: Record "36";
                        LclVehPurchMngt: Codeunit "33020012";
                    begin
                        //Calling functions in codeunit 33020011 to check VC No. and Tolerance Percentage.
                        IF VehicleTradeDocument THEN BEGIN
                           TESTFIELD("Sys. LC No.");
                        END;
                        TESTFIELD("Pragyapan Patra No."); //Amisha
                        
                        //***SM 25/06/2013 to create vehicle checklist at each receiving point***
                        //***SM 24/08/2013 shifted this code in codeunit 90
                        /*IF VehicleTradeDocument THEN BEGIN
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
                         */
                        
                        Post(CODEUNIT::"Purch.-Post (Yes/No)");

                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        PurchPostYesNo: Codeunit "91";
                    begin
                        PurchPostYesNo.Preview(Rec);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Suite;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        SalesHeader: Record "36";
                        LclVehPurchMngt: Codeunit "33020012";
                        PurchHdr: Record "38";
                        PurchLine: Record "39";
                    begin

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
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintPurchHeader(Rec);
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Batch Post Purchase Orders",TRUE,TRUE,Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("Remove From Job Queue")
                {
                    ApplicationArea = Suite;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    Visible = JobQueueVisible;

                    trigger OnAction()
                    begin
                        CancelBackgroundPosting;
                    end;
                }
                separator()
                {
                }
                group("Prepa&yment")
                {
                    Caption = 'Prepa&yment';
                    Image = Prepayment;
                    action("Prepayment Test &Report")
                    {
                        Caption = 'Prepayment Test &Report';
                        Ellipsis = true;
                        Image = PrepaymentSimulation;

                        trigger OnAction()
                        begin
                            ReportPrint.PrintPurchHeaderPrepmt(Rec);
                        end;
                    }
                    action(PostPrepaymentInvoice)
                    {
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "1535";
                            PurchPostYNPrepmt: Codeunit "445";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                              PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec,FALSE);
                        end;
                    }
                    action("Post and Print Prepmt. Invoic&e")
                    {
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "1535";
                            PurchPostYNPrepmt: Codeunit "445";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                              PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec,TRUE);
                        end;
                    }
                    action(PostPrepaymentCreditMemo)
                    {
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "1535";
                            PurchPostYNPrepmt: Codeunit "445";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                              PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec,FALSE);
                        end;
                    }
                    action("Post and Print Prepmt. Cr. Mem&o")
                    {
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "1535";
                            PurchPostYNPrepmt: Codeunit "445";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                              PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec,TRUE);
                        end;
                    }
                }
            }
            group(Print)
            {
                Caption = 'Print';
                Image = Print;
                action("&Print")
                {
                    ApplicationArea = Suite;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category10;
                    ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        PurchaseHeader := Rec;
                        CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                        PurchaseHeader.PrintRecords(TRUE);
                    end;
                }
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
                action(SendCustom)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Send';
                    Ellipsis = true;
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to send the document according to the vendor''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        PurchaseHeader := Rec;
                        CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                        PurchaseHeader.SendRecords;
                    end;
                }
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
    end;

    trigger OnAfterGetRecord()
    begin
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
        
        /*
        //Hiding Import Store Requisition.
        IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade","Document Profile"::"Spare Parts Trade"]) THEN
          ShowImportStrReq := FALSE
        ELSE
          ShowImportStrReq := TRUE;
        */
        
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

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnInit()
    var
        PurchasesPayablesSetup: Record "312";
    begin
        JobQueueUsed := PurchasesPayablesSetup.JobQueueActive;
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
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
        "Import Purch. Order" := TRUE;  //AGILE SRT 01-Aug-16
    end;

    trigger OnOpenPage()
    begin
        
        FilterOnRecord;
        SetDocNoVisible;
        
        /*
        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;
        */
        //EDMS >>
          FILTERGROUP(3);
          DocumentProfileFilter := GETFILTER("Document Profile");
          FILTERGROUP(0);
        //EDMS <<
        
        /*
        //Hiding Import Store Requisition. Sangam Shrestha on 30 Jan 2012.
        IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade","Document Profile"::"Spare Parts Trade"]) THEN
          ShowImportStrReq := FALSE
        ELSE
          ShowImportStrReq := TRUE;
        */
        
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

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF NOT DocumentIsPosted THEN
          EXIT(ConfirmCloseUnposted);
    end;

    var
        CopyPurchDoc: Report "492";
                          MoveNegPurchLines: Report "6698";
                          ReportPrint: Codeunit "228";
                          UserMgt: Codeunit "5700";
                          ArchiveManagement: Codeunit "5063";
                          PurchCalcDiscByType: Codeunit "66";
                          ChangeExchangeRate: Page "511";
    [InDataSet]

    JobQueueVisible: Boolean;
        [InDataSet]
        JobQueueUsed: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        VendorInvoiceNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        DocumentIsPosted: Boolean;
        OpenPostedPurchaseOrderQst: Label 'The order has been posted and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?';
        CreateIncomingDocumentEnabled: Boolean;
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

    local procedure Post(PostingCodeunitID: Integer)
    var
        PurchaseHeader: Record "38";
        InstructionMgt: Codeunit "1330";
    begin
        SendToPosting(PostingCodeunitID);

        DocumentIsPosted := NOT PurchaseHeader.GET("Document Type","No.");

        IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
          CurrPage.CLOSE;
        CurrPage.UPDATE(FALSE);

        IF PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" THEN
          EXIT;

        IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          ShowPostedConfirmationMessage;
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure PurchaserCodeOnAfterValidate()
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.UPDATE;
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit "1400";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Order,"No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        PurchasesPayablesSetup: Record "312";
    begin
        PurchasesPayablesSetup.GET;
        VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "1535";
    begin
        JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        OrderPurchaseHeader: Record "38";
        PurchInvHeader: Record "122";
        InstructionMgt: Codeunit "1330";
    begin
        IF NOT OrderPurchaseHeader.GET("Document Type","No.") THEN BEGIN
          PurchInvHeader.SETRANGE("No.","Last Posting No.");
          IF PurchInvHeader.FINDFIRST THEN
            IF InstructionMgt.ShowConfirm(OpenPostedPurchaseOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
              PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
        END;
    end;

    [Scope('Internal')]
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

