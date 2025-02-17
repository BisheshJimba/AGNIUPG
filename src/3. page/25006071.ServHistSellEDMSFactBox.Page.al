page 25006071 "Serv. Hist. Sell EDMS FactBox"
{
    Caption = 'Sell-to Customer Service History';
    PageType = CardPart;
    SourceTable = Table18;

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Caption = 'Customer No.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("No. of Serv. Quotes"; "No. of Serv. Quotes")
            {
                Caption = 'Quotes';
                DrillDownPageID = "Service Quotes EDMS";
            }
            field("No. of Serv. Orders"; "No. of Serv. Orders")
            {
                Caption = 'Orders';
                DrillDownPageID = "Service Orders EDMS";
            }
            field("No. of Serv. Invoices"; "No. of Serv. Invoices")
            {
                Caption = 'Invoices';
                DrillDownPageID = "Sales Invoice List (Service)";
            }
            field("No. of Serv. Return Orders"; "No. of Serv. Return Orders")
            {
                Caption = 'Return Orders';
                DrillDownPageID = "Service Return Orders EDMS";
            }
            field("No. of Serv. Credit Memos"; "No. of Serv. Credit Memos")
            {
                Caption = 'Credit Memos';
                DrillDownPageID = "Sales Credit Memos (Service)";
            }
            field("No. of Serv. Pstd. Shipments"; "No. of Serv. Pstd. Shipments")
            {
                Caption = 'Pstd. Shipments';
            }
            field("No. of Serv. Pstd. Invoices"; "No. of Serv. Pstd. Invoices")
            {
                Caption = 'Pstd. Invoices';
                DrillDownPageID = "Posted Sales Invoices (Serv.)";
            }
            field("No. of S.Pstd. Return Receipts"; "No. of S.Pstd. Return Receipts")
            {
                Caption = 'Pstd. Return Receipts';
                DrillDownPageID = "Posted Return Receipts";
            }
            field("No. of Serv. Pstd. Cr. Memos"; "No. of Serv. Pstd. Cr. Memos")
            {
                Caption = 'Pstd. Credit Memos';
                DrillDownPageID = "Posted Sales Cr.Memos (Serv.)";
            }
            field("No. of Active Contracts"; "No. of Active Contracts")
            {
                Caption = 'Active Contracts';
                DrillDownPageID = "Contract List EDMS";
            }
        }
    }

    actions
    {
    }

    [Scope('Internal')]
    procedure ShowDetails()
    begin
        PAGE.RUN(PAGE::"Customer Card", Rec);
    end;
}

