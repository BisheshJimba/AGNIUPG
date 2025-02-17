page 25006074 "Customer Serv. Statis. FactBox"
{
    Caption = 'Customer Service Statistics - Bill-to Customer';
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
            group(Sales)
            {
                Caption = 'Sales';
                field("Outstanding Orders SP (LCY)"; "Outstanding Orders SP (LCY)")
                {
                }
                field("Shipped Not Invoiced SP (LCY)"; "Shipped Not Invoiced SP (LCY)")
                {
                    Caption = 'Shipped Not Invd. (LCY)';
                }
                field("Outstanding Invoices SP (LCY)"; "Outstanding Invoices SP (LCY)")
                {
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field("Outst. Serv. Orders EDMS (LCY)"; "Outst. Serv. Orders EDMS (LCY)")
                {
                }
                field("Outst. Serv.Invoices EDMS(LCY)"; "Outst. Serv.Invoices EDMS(LCY)")
                {
                }
            }
            field("Credit Limit (LCY)"; "Credit Limit (LCY)")
            {
            }
            field("Balance Due (LCY)"; CalcOverdueBalance)
            {
                CaptionClass = FORMAT(STRSUBSTNO(Text000, FORMAT(WORKDATE)));

                trigger OnDrillDown()
                var
                    DtldCustLedgEntry: Record "379";
                    CustLedgEntry: Record "21";
                begin
                    DtldCustLedgEntry.SETFILTER("Customer No.", "No.");
                    COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                end;
            }
        }
    }

    actions
    {
    }

    var
        Text000: Label 'Overdue Amounts (LCY) as of %1';

    [Scope('Internal')]
    procedure ShowDetails()
    begin
        PAGE.RUN(PAGE::"Customer Card", Rec);
    end;
}

