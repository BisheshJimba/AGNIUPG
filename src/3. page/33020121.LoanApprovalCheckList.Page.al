page 33020121 "Loan Approval Check List"
{
    Caption = 'Loan Approval Check List';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020069;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Check List Code"; "Check List Code")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Is Mandatory?"; "Is Mandatory?")
                {
                }
                field("Application Status"; "Application Status")
                {
                }
                field("Is Accomplished?"; "Is Accomplished?")
                {
                }
                field(Exceptional; Exceptional)
                {
                }
                field("Bypassed By User"; "Bypassed By User")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&Print")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LoanApprovalChecklist: Report "33020077";
                    _LoanApprovalChecklist: Record "33020069";
                begin
                    _LoanApprovalChecklist.RESET;
                    _LoanApprovalChecklist.SETRANGE("Document Type", "Document Type");
                    _LoanApprovalChecklist.SETRANGE("Document No.", "Document No.");
                    CLEAR(LoanApprovalChecklist);
                    LoanApprovalChecklist.SETTABLEVIEW(_LoanApprovalChecklist);
                    LoanApprovalChecklist.RUNMODAL;
                end;
            }
        }
    }
}

