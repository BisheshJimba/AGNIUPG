page 33020467 "Posted Final Due Settlement"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020409;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Emp Settlement No."; "Emp Settlement No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Date of Joining"; "Date of Joining")
                {
                }
                field("Date of Release"; "Date of Release")
                {
                }
                field(Address; Address)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000012>")
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FinalSettlementRec.RESET;
                    FinalSettlementRec.SETRANGE("Emp Settlement No.", "Emp Settlement No.");
                    FinalSettlementRec.SETRANGE("Employee Code", "Employee Code");
                    IF FinalSettlementRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020340, TRUE, FALSE, FinalSettlementRec);
                    END;
                end;
            }
        }
    }

    var
        FinalSettlementRec: Record "33020409";
}

