page 25006073 "Serv. Hist. Bill EDMS FactBox"
{
    Caption = 'Bill-to Customer Service History';
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
            field("Bill-To No. of S. Quotes"; "Bill-To No. of S. Quotes")
            {
                Caption = 'Quotes';
                DrillDownPageID = "Service Quotes EDMS";
            }
            field("Bill-To No. of S. Orders"; "Bill-To No. of S. Orders")
            {
                Caption = 'Orders';
                DrillDownPageID = "Service Orders EDMS";
            }
            field("Bill-To No. of S. Invoices"; "Bill-To No. of S. Invoices")
            {
                Caption = 'Invoices';
                DrillDownPageID = "Sales Invoice List (Service)";
            }
            field("Bill-To No. of S. Ret. Orders"; "Bill-To No. of S. Ret. Orders")
            {
                Caption = 'Return Orders';
                DrillDownPageID = "Service Return Orders EDMS";
            }
            field("Bill-To No. of S. Credit Memos"; "Bill-To No. of S. Credit Memos")
            {
                Caption = 'Credit Memos';
                DrillDownPageID = "Sales Credit Memos (Service)";
            }
            field("Bill-To No. of S. Pstd. Shipm."; "Bill-To No. of S. Pstd. Shipm.")
            {
                Caption = 'Pstd. Shipments';
            }
            field("Bill-To No. of S. Pstd. Inv."; "Bill-To No. of S. Pstd. Inv.")
            {
                Caption = 'Pstd. Invoices';
                DrillDownPageID = "Posted Sales Invoices (Serv.)";
            }
            field("Bill-To No. of S.Pstd. Ret. R."; "Bill-To No. of S.Pstd. Ret. R.")
            {
                Caption = 'Pstd. Return Receipts';
                DrillDownPageID = "Posted Return Receipts";
            }
            field("Bill-To No. of S. Pstd. C.Mem."; "Bill-To No. of S. Pstd. C.Mem.")
            {
                Caption = 'Pstd. Credit Memos';
                DrillDownPageID = "Posted Sales Cr.Memos (Serv.)";
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

