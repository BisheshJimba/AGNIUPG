page 25006167 "Service No. Series Setup"
{
    // 04.02.2015 EB.P7 #T018 EDMS
    //   Page Created.

    Caption = 'Service No. Series Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    SourceTable = Table25006120;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                InstructionalText = 'To fill the Document No. field automatically, you must set up a number series.';
                field("Quote Nos."; "Quote Nos.")
                {
                    Visible = QuoteNosVisible;
                }
                field("Order Nos."; "Order Nos.")
                {
                    Visible = OrderNosVisible;
                }
                field("Return Order Nos."; "Return Order Nos.")
                {
                    Visible = ReturnOrderNosVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Setup)
            {
                Caption = 'Sales & Receivables Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 459;
            }
        }
    }

    var
        QuoteNosVisible: Boolean;
        OrderNosVisible: Boolean;
        ReturnOrderNosVisible: Boolean;

    [Scope('Internal')]
    procedure SetFieldsVisibility(DocType: Option Quote,"Order","Return Order")
    begin
        QuoteNosVisible := (DocType = DocType::Quote);
        OrderNosVisible := (DocType = DocType::Order);
        ReturnOrderNosVisible := (DocType = DocType::"Return Order");
    end;
}

