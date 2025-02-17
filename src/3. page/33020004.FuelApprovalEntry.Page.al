page 33020004 "Fuel Approval Entry"
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
                      WHERE(Document Type=CONST(Fuel Issue));

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
                        //Calling function to approve selected document - Fuel Issue.
                        GblDocAppvMngt.appFuelIssue(Rec);
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
                        //Calling function to delegate approval - Fuel Issue.
                        GblDocAppvMngt.delegateFuelIssue(Rec);
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
                        //Calling function to approve selected document - Fuel Issue.
                        GblDocAppvMngt.rejtFuelIssue(Rec);
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
                        LclFuelIssueCpn: Page "33019965";
                        LclFuelIssueStk: Page "33019967";
                        LclFuelIssueCsh: Page "33019969";
                        LclFuelIssueEntry: Record "33019963";
                    begin
                        CASE "Entry Type" OF
                            "Entry Type"::Coupon:
                                BEGIN
                                    LclFuelIssueEntry.RESET;
                                    LclFuelIssueEntry.SETRANGE("Document Type", "Entry Type");
                                    LclFuelIssueEntry.SETRANGE("No.", "Document No.");
                                    LclFuelIssueCpn.SETTABLEVIEW(LclFuelIssueEntry);
                                    LclFuelIssueCpn.RUNMODAL;
                                END;
                            "Entry Type"::Stock:
                                BEGIN
                                    LclFuelIssueEntry.RESET;
                                    LclFuelIssueEntry.SETRANGE("Document Type", "Entry Type");
                                    LclFuelIssueEntry.SETRANGE("No.", "Document No.");
                                    LclFuelIssueStk.SETTABLEVIEW(LclFuelIssueEntry);
                                    LclFuelIssueStk.RUNMODAL;
                                END;
                            "Entry Type"::Cash:
                                BEGIN
                                    LclFuelIssueEntry.RESET;
                                    LclFuelIssueEntry.SETRANGE("Document Type", "Entry Type");
                                    LclFuelIssueEntry.SETRANGE("No.", "Document No.");
                                    LclFuelIssueCsh.SETTABLEVIEW(LclFuelIssueEntry);
                                    LclFuelIssueCsh.RUNMODAL;
                                END;
                        END;
                    end;
                }
            }
        }
    }

    var
        GblDocAppvMngt: Codeunit "33019915";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance";
}

