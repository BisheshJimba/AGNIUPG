page 33020185 "Veh. CC Approval Entry"
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
                      WHERE(Document Type=CONST(Vehicle Custom Clearance));

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
                        GblDocAppvMngt.appvVehCCReq(Rec);
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
                        GblDocAppvMngt.delegateVehCCAppReq(Rec);
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
                        GblDocAppvMngt.rejtVehCCReq(Rec);
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
                        LclCCMemoHdr: Record "33020163";
                        LclCCMemoCVD: Page "33020163";
                        LclCCMemoPCD: Page "33020169";
                    begin
                        CASE "Entry Type" OF
                            "Entry Type"::CVD:
                                BEGIN
                                    LclCCMemoHdr.RESET;
                                    LclCCMemoHdr.SETRANGE("Reference No.", "Document No.");
                                    LclCCMemoCVD.SETTABLEVIEW(LclCCMemoHdr);
                                    LclCCMemoCVD.RUNMODAL;
                                END;
                            "Entry Type"::PCD:
                                BEGIN
                                    LclCCMemoHdr.RESET;
                                    LclCCMemoHdr.SETRANGE("Reference No.", "Document No.");
                                    LclCCMemoPCD.SETTABLEVIEW(LclCCMemoHdr);
                                    LclCCMemoPCD.RUNMODAL;
                                END;
                        END;
                    end;
                }
            }
        }
    }

    var
        GblDocAppvMngt: Codeunit "33019915";
}

