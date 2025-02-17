page 33020184 "Veh. Insurance Approval Entry"
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
                      WHERE(Document Type=CONST(Vehicle Insurance));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
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
                        GblDocAppvMngt.appvVehInsReq(Rec);
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
                        GblDocAppvMngt.delegateVehInsAppReq(Rec);
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
                        GblDocAppvMngt.rejtVehInsReq(Rec);
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
                        LclInsMemoHdr: Record "33020165";
                        LclInsMemoCVD: Page "33020173";
                        LclInsMemoPCD: Page "33020179";
                    begin
                        CASE "Entry Type" OF
                            "Entry Type"::CVD:
                                BEGIN
                                    LclInsMemoHdr.RESET;
                                    LclInsMemoHdr.SETRANGE("Reference No.", "Document No.");
                                    LclInsMemoCVD.SETTABLEVIEW(LclInsMemoHdr);
                                    LclInsMemoCVD.RUNMODAL;
                                END;
                            "Entry Type"::PCD:
                                BEGIN
                                    LclInsMemoHdr.RESET;
                                    LclInsMemoHdr.SETRANGE("Reference No.", "Document No.");
                                    LclInsMemoPCD.SETTABLEVIEW(LclInsMemoHdr);
                                    LclInsMemoPCD.RUNMODAL;
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

