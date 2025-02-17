page 33020517 "Posted Salary Plan List"
{
    CardPageID = "Posted Salary Plan";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020512;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field(Month; Month)
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Bank Code"; "Bank Code")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action22>")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //
                end;
            }
            action("<Action27>")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action("&Salary Sheet")
            {
                Caption = '&Salary Sheet';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PostedSalaryHeader.RESET;
                    PostedSalaryHeader.SETRANGE("No.", "No.");
                    IF PostedSalaryHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(33020042, TRUE, FALSE, PostedSalaryHeader);
                end;
            }
        }
    }

    var
        PostedSalaryHeader: Record "33020512";
}

