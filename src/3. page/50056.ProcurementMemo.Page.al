page 50056 "Procurement Memo"
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
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field(Subject; Subject)
                {
                }
                field("Rejection Reason"; "Rejection Reason")
                {
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Advance Payment"; "Advance Payment")
                {
                }
                field(Background; Background)
                {
                    MultiLine = true;
                }
                field(Background1; Background1)
                {
                    MultiLine = true;
                    Visible = true;
                }
                field(VIN; VIN)
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
            }
            part(; 50059)
            {
                SubPageLink = Memo No.=FIELD(Memo No.);
                    Visible = true;
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
            action("Procurement Memo")
            {
                Caption = 'Preview Procurement Memo';
                Image = CreditMemo;
                Promoted = true;
                PromotedCategory = Process;
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
                action("Approval Requests")
                {
                    Image = ViewRegisteredOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        AppEntries: Record "454";
                    begin
                        AppEntries.RESET;
                        AppEntries.SETRANGE("Record ID to Approve", Rec.RECORDID);
                        AppEntries.SETRANGE("Document No.", Rec."Memo No.");
                        PAGE.RUN(PAGE::"Procument Approval Entries", AppEntries);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Procurement Type" := "Procurement Type"::Purchase;
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(0);
        SETRANGE(Posted, FALSE);
        FILTERGROUP(2);
        IF Status IN [Status::Open, Status::Released] THEN
            RejectVisible := FALSE
        ELSE
            RejectVisible := TRUE;
    end;

    var
        SendApprovalRequest: Codeunit "25006201";
        BudgetAnalysis: Record "2000000";
        [InDataSet]
        RejectVisible: Boolean;
        ProcurementMemo: Record "130415";
}

