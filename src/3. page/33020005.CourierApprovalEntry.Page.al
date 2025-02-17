page 33020005 "Courier Approval Entry"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019915;
    SourceTableView = SORTING(Entry No.)
                      ORDER(Ascending)
                      WHERE(Document Type=CONST(Courier));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Sequence No."; "Sequence No.")
                {
                }
                field("Sender ID"; "Sender ID")
                {
                }
                field("Approver ID"; "Approver ID")
                {
                }
                field(Status; Status)
                {
                }
                field("Date Time Sent for Approval"; "Date Time Sent for Approval")
                {
                }
                field("Last Modified By"; "Last Modified By")
                {
                }
                field("Last Date Time Modified"; "Last Date Time Modified")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function(s)")
            {
                Caption = 'Function(s)';
                action(ApproveDoc)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        MESSAGE('Function to approve document.');
                    end;
                }
                action(DelegateDoc)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        MESSAGE('Function to delegate document approval.');
                    end;
                }
                separator()
                {
                }
                action(RejectDocApproval)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        MESSAGE('Function to reject document approval.');
                    end;
                }
            }
        }
        area(navigation)
        {
            group("<Action1102159027>")
            {
                Caption = 'Show';
                action(ShowDoc)
                {
                    Caption = 'Document';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        MESSAGE('Function to show related document.');
                    end;
                }
            }
        }
    }
}

