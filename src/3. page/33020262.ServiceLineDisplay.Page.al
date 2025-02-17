page 33020262 "Service Line (Display)"
{
    Caption = 'Service Orders';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=CONST(Order),
                            Job Closed=CONST(No));

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("No."; "No.")
                {
                    Caption = 'Job No';
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Service Person"; "Service Person")
                {
                }
                field("Job Type"; "Job Type")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Work Status Code"; "Work Status Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FilterOnRecord;
    end;

    var
        DocPrint: Codeunit "229";
        ReportPrint: Codeunit "228";
        Usage: Option "Order Confirmation","Work Order";
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        ServInfoPaneMgt: Codeunit "25006104";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        FILTERGROUP(2);
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Service Resp. Ctr. Filter EDMS" <> '' THEN
                SETRANGE("Responsibility Center", UserSetup."Service Resp. Ctr. Filter EDMS");
        END;
        FILTERGROUP(0);
    end;
}

