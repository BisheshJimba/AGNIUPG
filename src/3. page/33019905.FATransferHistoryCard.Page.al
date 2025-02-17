page 33019905 "FA Transfer History Card"
{
    PageType = Card;
    SourceTable = Table33019891;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("FA No."; "FA No.")
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                    Editable = false;
                }
                field("From Location Code"; "From Location Code")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Caption = 'From Location';
                    Editable = false;
                }
                field("To Location Code"; "To Location Code")
                {
                    Caption = 'To Location Code';
                    Editable = false;
                }
                field("To Description"; "To Description")
                {
                    Caption = 'To Location';
                    Editable = false;
                }
                field("From Responsible Emp"; "From Responsible Emp")
                {
                    Caption = 'From Employee Code';
                    Editable = false;
                }
                field("From Emp Description"; "From Emp Description")
                {
                    Caption = 'From Responsible Employee';
                    Editable = false;
                }
                field("To Responsible Emp"; "To Responsible Emp")
                {
                    Caption = 'To Employee Code';
                    Editable = false;
                }
                field("To Emp Description"; "To Emp Description")
                {
                    Caption = 'To Responsible Employee';
                    Editable = false;
                }
                field(Reason; Reason)
                {
                    Editable = false;
                    MultiLine = true;
                }
                field(Remarks; Remarks)
                {
                    Editable = false;
                    MultiLine = true;
                }
                field("User ID"; "User ID")
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart("<Notes>"; Notes)
            {
                Caption = 'Notes';
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("<Action1102159025>")
            {
                Caption = 'Printing';
                action("<Action1102159026>")
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //message('Test');

                        // to print
                        FATransfer.RESET;
                        FATransfer.SETRANGE(FATransfer."FA No.", "FA No.");
                        FATransfer.SETRANGE(FATransfer."From Location Code", "From Location Code");
                        REPORT.RUN(33019885, FALSE, TRUE, FATransfer);
                    end;
                }
            }
        }
    }

    var
        FATransfer: Record "33019891";
}

