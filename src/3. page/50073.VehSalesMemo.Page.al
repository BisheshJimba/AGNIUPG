page 50073 "Veh. Sales Memo"
{
    Editable = true;
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
            }
            part(; 50059)
            {
                SubPageLink = Memo No.=FIELD(Memo No.);
            }
            part("<Vehicles>"; 50078)
            {
                Caption = 'Vehicles';
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
                        REPORT.RUN(14125501, TRUE, FALSE, ProcurementMemo);
                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do You Want To Post', FALSE) THEN
                        EXIT;
                    IF Status = Status::Released THEN BEGIN
                        Posted := TRUE;
                        MODIFY(TRUE);
                    END ELSE
                        ERROR('Approval Process Has To Be Met');
                end;
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                action("Send Approval Request")
                {
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SendApprovalRequest.OnSendDocForApproval(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        CancelApprovalRequest: Codeunit "25006201";
                    begin
                        IF Status IN [Status::"Pending Approval"] THEN
                            CancelApprovalRequest.OnCancelDocForApproval(Rec);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Procurement Type" := "Procurement Type"::"Veh. Sales Memo";
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(0);
        SETRANGE(Posted, FALSE);
        FILTERGROUP(10);
    end;

    var
        ProcurementMemo: Record "130415";
        SendApprovalRequest: Codeunit "25006201";
}

