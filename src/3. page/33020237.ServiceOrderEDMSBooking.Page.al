page 33020237 "Service Order EDMS - Booking"
{
    Caption = 'Vehicle Booking';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Vehicle Diagnosis/Checklist';
    RefreshOnActivate = true;
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=FILTER(Order));

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
                    Visible = false;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Sell-to Address";"Sell-to Address")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Sell-to Address 2";"Sell-to Address 2")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Sell-to City";"Sell-to City")
                {
                    Visible = false;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("No. of Archived Versions";"No. of Archived Versions")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Arrival Date";"Arrival Date")
                {
                }
                field("Arrival Time";"Arrival Time")
                {
                }
                field("Posting Date";"Posting Date")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Order Date";"Order Date")
                {
                    Importance = Additional;
                    Visible = true;
                }
                field("Order Time";"Order Time")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field(VIN;VIN)
                {
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                }
                field("Mobile No. for SMS";"Mobile No. for SMS")
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field(Kilometrage;Kilometrage)
                {
                    Importance = Additional;
                }
                field("Hour Reading";"Hour Reading")
                {
                    Importance = Additional;
                }
                field("Work Status Code";"Work Status Code")
                {
                    Editable = false;
                }
                field("Service Person";"Service Person")
                {
                    Caption = 'Service Advisor';
                    Importance = Additional;
                    Visible = false;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Accountability Center";"Accountability Center")
                {
                }
                field(Status;Status)
                {
                    Importance = Additional;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Promised Delivery Time";"Promised Delivery Time")
                {
                    Importance = Additional;
                }
                field("Booked on Date";"Booked on Date")
                {
                }
                field("Time Slot Booked";"Time Slot Booked")
                {
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Job Description";"Job Description")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field("Booked By";"Booked By")
                {
                }
            }
            part(ServiceLines;25006184)
            {
                SubPageLink = Document No.=FIELD(No.);
                Visible = false;
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                Visible = false;
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
                Visible = false;
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
            group(Details)
            {
                Caption = 'Details';
                Visible = false;
                field("Posting Date ";"Posting Date")
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
                field("No. of Archived Versions ";"No. of Archived Versions")
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
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Visible = false;
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
            part(;25006241)
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
            group("O&rder")
            {
                Caption = 'O&rder';
                action("<Action63>")
                {
                    Caption = '&Diagnosis';
                    Image = ViewComments;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                }
                action("Send SMS")
                {
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SendSMSBooking;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
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
                        ServiceSchedule.SetServiceHeader(Rec);
                        ServiceSchedule.RUN;
                    end;
                }
                action("<Action1102159007>")
                {
                    Caption = '&Diagnosis';
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                }
                action("<Action1102159008>")
                {
                    Caption = 'Inventory Checklists';
                    Image = PhysicalInventory;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Source ID=FIELD(No.);
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnServHeaderDelete(Rec);
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckCreditMaxBeforeInsert;
        VALIDATE("Work Status Code",'BOOKING');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Accountability Center" := UserMgt.GetSalesFilter();
        //"Responsibility Center" := UserMgt.GetSalesFilter();
        "Is Booked" := TRUE;
        "Booked By" := USERID;
    end;

    trigger OnOpenPage()
    var
        UserSetup: Record "91";
    begin
        FilterOnRecord;
        IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Accountability Center",UserMgt.GetSalesFilter());  //SM Agni
          FILTERGROUP(0);
        END;

        SETRANGE("Date Filter",0D,WORKDATE - 1);
    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        CopyServDoc: Report "25006135";
                         MoveNegSalesLines: Report "6699";
                         ReportPrint: Codeunit "228";
                         DocPrint: Codeunit "229";
                         ArchiveManagement: Codeunit "5063";
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
        Text101: Label 'Transfer Order is successfully created.';
        Text102: Label 'System changed values in Service Line field Planned Service Date.';
        ServInfoPaneMgt: Codeunit "25006104";
        LostSaleMgt: Codeunit "25006504";
        ChangeExchangeRate: Page "511";

    [Scope('Internal')]
    procedure UpdateAllowed(): Boolean
    begin
        IF CurrPage.EDITABLE = FALSE THEN
            ERROR(Text000);
        EXIT(TRUE);
    end;

    local procedure UpdateInfoPanel()
    var
        DifferSellToBillTo: Boolean;
    begin
        /*
        DifferSellToBillTo := "Sell-to Customer No." <> "Bill-to Customer No.";
        SalesHistoryBtnVisible := DifferSellToBillTo;
        BillToCommentPictVisible := DifferSellToBillTo;
        BillToCommentBtnVisible := DifferSellToBillTo;
        SalesHistoryStnVisible := SalesInfoPaneMgt.DocExist(Rec,"Sell-to Customer No.");
        IF DifferSellToBillTo THEN
          SalesHistoryBtnVisible := SalesInfoPaneMgt.DocExist(Rec,"Bill-to Customer No.")
        */

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
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        FILTERGROUP(2);
        IF UserSetup.GET(USERID) THEN BEGIN
            SETRANGE("Accountability Center", UserMgt.GetRespCenter(3, "Accountability Center"));
            //SETRANGE("Responsibility Center",UserMgt.GetRespCenter(3,"Responsibility Center"));
            IF UserProfileSetup.GET(UserSetup."Default User Profile Code") THEN
                SETRANGE("Location Code", UserProfileSetup."Def. Service Location Code");
        END;
        FILTERGROUP(0);
    end;
}

