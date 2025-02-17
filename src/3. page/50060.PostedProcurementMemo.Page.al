page 50060 "Posted Procurement Memo"
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
                field(Background; Background)
                {
                }
                field(Background1; Background1)
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
            part(; 50059)
            {
                SubPageLink = Memo No.=FIELD(Memo No.);
            }
            part("<vendors>"; 50057)
            {
                Caption = 'Vendors';
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
            action("Make Purchase Order ")
            {
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SysMgt: Codeunit "50000";
                begin
                    IF Rec.Status <> Rec.Status::Released THEN
                        ERROR('Documnet must be released.');
                    SysMgt.insertPurchaseOrderFromProcument(Rec);
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

