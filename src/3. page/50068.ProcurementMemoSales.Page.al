page 50068 "Procurement Memo Sales"
{
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
                    Editable = false;
                }
                field(Background; Background)
                {
                }
                field(Background1; Background1)
                {
                    MultiLine = true;
                    Visible = true;
                }
                field(Subject; Subject)
                {
                }
                field("Rejection Reason"; "Rejection Reason")
                {
                    Editable = RejectVisible;
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
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
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; 193)
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(creation)
        {
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
                        BudgetAnalysis.RESET;
                        BudgetAnalysis.SETRANGE("Memo No.", "Memo No.");
                        BudgetAnalysis.SETFILTER(Balance, '<0', BudgetAnalysis.Balance);
                        IF BudgetAnalysis.ISEMPTY THEN
                            SendApprovalRequest.OnSendDocForApproval(Rec)
                        ELSE
                            ERROR('Balance Should Be Greater Than Zero');
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
                action("Procurement Memo")
                {
                    Caption = 'Preview Procurement Memo';
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
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Procurement Type" := "Procurement Type"::Sales;
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(0);
        SETRANGE(Posted, FALSE);
        FILTERGROUP(10);
        IF Status IN [Status::Open, Status::Released] THEN
            RejectVisible := FALSE
        ELSE
            RejectVisible := TRUE;
    end;

    var
        SendApprovalRequest: Codeunit "25006201";
        BudgetAnalysis: Record "2000000";
        RejectVisible: Boolean;
        ProcurementMemo: Record "130415";
}

