page 50071 "Posted Procurement Memo Sales"
{
    Editable = false;
    SourceTable = Table130415;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Memo No."; "Memo No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field(Status; Status)
                {
                }
            }
            part(; 50059)
            {
                SubPageLink = Memo No.=FIELD(Memo No.);
            }
            part("<Customers>"; 50067)
            {
                Caption = 'Customers';
                SubPageLink = Memo No.=FIELD(Memo No.);
            }
            part("<Budget Analysis>"; 50062)
            {
                Caption = 'Budget Analysis';
                SubPageLink = Memo No.=FIELD(Memo No.);
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Procurement Memo")
            {
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ProcurementMemo.RESET;
                    ProcurementMemo.SETRANGE("Memo No.", "Memo No.");
                    IF ProcurementMemo.FINDFIRST THEN
                        REPORT.RUN(25006000, TRUE, FALSE, ProcurementMemo);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(0);
        SETRANGE(Posted, TRUE);
        FILTERGROUP(10);
    end;

    var
        ProcurementMemo: Record "130415";
}

