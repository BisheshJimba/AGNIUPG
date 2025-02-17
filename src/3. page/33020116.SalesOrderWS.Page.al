page 33020116 "Sales Order (WS)"
{
    Caption = 'Sales Order (WS)';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Vehicle Module';
    RefreshOnActivate = true;
    SourceTable = Table36;
    SourceTableView = WHERE(Document Type=FILTER(Order));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document Type";"Document Type")
                {
                }
                field("Dealer PO No.";"Dealer PO No.")
                {
                }
                field("Dealer Tenant ID";"Dealer Tenant ID")
                {
                }
                field("Dealer Line No.";"Dealer Line No.")
                {
                }
                field("Document Profile";"Document Profile")
                {
                }
                field("No.";"No.")
                {
                    Importance = Promoted;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    Importance = Promoted;
                }
                field("Sell-to Contact No.";"Sell-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Sell-to Customer Name 2";"Sell-to Customer Name 2")
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
                field("Document Date";"Document Date")
                {
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    Importance = Additional;
                }
                field("Quote No.";"Quote No.")
                {
                    Importance = Additional;
                }
                field("External Document No.";"External Document No.")
                {
                    Importance = Promoted;
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                }
                field("Salesperson Code";"Salesperson Code")
                {
                }
                field("Campaign No.";"Campaign No.")
                {
                    Importance = Additional;
                }
                field("Opportunity No.";"Opportunity No.")
                {
                    Importance = Additional;
                }
                field("External Document No. ";"External Document No.")
                {
                }
                field("Location Code";"Location Code")
                {
                    Editable = true;
                }
                field("Accountability Center";"Accountability Center")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    Importance = Additional;
                }
                field(Status;Status)
                {
                    Importance = Promoted;
                }
                field("Scheme Type";"Scheme Type")
                {
                }
                field("Financed By No.";"Financed By No.")
                {
                    Visible = false;
                }
                field(FinanceByName;FinanceByName)
                {
                    Caption = 'Finance By Name';
                    Editable = false;
                    Visible = false;
                }
                field("Re-Financed By";"Re-Financed By")
                {
                    Visible = false;
                }
                field("Financed Amount";"Financed Amount")
                {
                    Visible = false;
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Direct Sales";"Direct Sales")
                {
                }
                field("Booked Date";"Booked Date")
                {
                }
                field("Tender Sales";"Tender Sales")
                {
                }
                field("Direct Sales Commission No.";"Direct Sales Commission No.")
                {
                }
                field("Latest Flipped Date";"Latest Flipped Date")
                {
                    Editable = false;
                }
                field("Invertor Serial No.";"Invertor Serial No.")
                {
                }
                field("Order Type";"Order Type")
                {
                }
                field("Swift Code";"Swift Code")
                {
                }
                field("Dealer VIN";"Dealer VIN")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        /*IF "Location Code" = 'BIR-ST-TR' THEN BEGIN
          UserSetupRec.GET(USERID);
          UserSetupRec."Default Accountability Center" := 'BIR';
          UserSetupRec.MODIFY;
         END;
        IF "Location Code" = 'BRR-WH-LUB' THEN BEGIN
          UserSetupRec.GET(USERID);
          UserSetupRec."Default Accountability Center" := 'BRR';
          UserSetupRec.MODIFY;
        END;
        IF "Location Code" = 'BAN-WH-AUT' THEN BEGIN
          UserSetupRec.GET(USERID);
          UserSetupRec."Default Accountability Center" := 'BAN';
          UserSetupRec.MODIFY;
        END;
        */

    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        CopySalesDoc: Report "292";
                          MoveNegSalesLines: Report "6699";
                          ReportPrint: Codeunit "228";
                          DocPrint: Codeunit "229";
                          ArchiveManagement: Codeunit "5063";
                          SalesInfoPaneMgt: Codeunit "7171";
                          SalesSetup: Record "311";
                          UserMgt: Codeunit "5700";
                          Usage: Option "Order Confirmation","Work Order";
                          Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        [InDataSet]
        SalesHistoryBtnVisible: Boolean;
        [InDataSet]
        BillToCommentPictVisible: Boolean;
        [InDataSet]
        BillToCommentBtnVisible: Boolean;
        [InDataSet]
        SalesHistoryStnVisible: Boolean;
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        LostSaleMgt: Codeunit "25006504";
        Contact: Record "5050";
        PipelineHistory1: Record "33020198";
        PipelineHistory2: Record "33020198";
        SalesShipmentheader: Record "110";
        SalesHeader: Record "36";
        UserSetup: Record "91";
        FinanceByName: Text[250];
        ISVisible: Boolean;
        AccCenter: Record "33019846";
        SalesLine: Record "37";
        CustAllocation: Record "33019860";
        InsMemoLine: Record "33020166";
        InsMemoHdr: Record "33020165";
        RefNo: Code[20];
        CheckDate: Date;
        ExpiredInsMemo: Label 'The insurance date is expired. Please create a new Insurance Memo.';
        Vehicle: Record "25006005";
        TempSalesOrderNo: Code[20];
        TempCustomerNo: Code[20];
        TempSalesNoCustAllocation: Code[20];
        CustAllocation1: Record "33019860";
        NoAppliedEntries: Label 'There are no applied entries to swap the customers. Please choose the customer from customer alloctaion entries.';
        Customer: Record "18";
        SalesPriceCalcMgt: Codeunit "7000";
        SalesLine2: Record "37";
        [InDataSet]
        "Veh&SpareTrade": Boolean;
        TempQuoteNo: Code[20];
        ArchivedMessage: Label 'Document %1 has been archived';
        UserSetupRec: Record "91";
}

