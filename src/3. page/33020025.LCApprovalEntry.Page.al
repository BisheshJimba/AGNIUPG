page 33020025 "LC Approval Entry"
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
                      WHERE(Document Type=CONST(LC));

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
                        //Calling function in CODEUNIT::"Doc. Approval Management" to approve selected document.
                        GblDocAppvMngt.appvLCReq(Rec);
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
                        //Calling function in CODEUNIT::"Doc. Approval Management" to delegate selected document.
                        GblDocAppvMngt.delegateLCAppReq(Rec);
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
                        //Calling function in CODEUNIT::"Doc. Approval Management" to reject selected document.
                        GblDocAppvMngt.rejtLCReq(Rec);
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
                    var
                        LclPurchHdr: Record "38";
                    begin
                        //Showing document - Purchase Order.
                        LclPurchHdr.RESET;
                        LclPurchHdr.SETFILTER("Document Type", 'Order');
                        LclPurchHdr.SETRANGE("No.", "Document No.");
                        PAGE.RUNMODAL(50, LclPurchHdr);
                    end;
                }
            }
        }
    }

    var
        GblDocAppvMngt: Codeunit "33019915";
}

