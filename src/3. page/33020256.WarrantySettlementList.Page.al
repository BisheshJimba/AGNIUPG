page 33020256 "Warranty Settlement List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33020252;
    SourceTableView = SORTING(Credit Note No.)
                      WHERE(Settled = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PCR No."; "PCR No.")
                {
                }
                field(Year; Year)
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field("Credit Note No."; "Credit Note No.")
                {
                }
                field("Settled Date"; "Settled Date")
                {
                }
                field("Pre-Assigned No."; "Pre-Assigned No.")
                {
                }
                field(Apply; Apply)
                {

                    trigger OnValidate()
                    begin
                        TESTFIELD(Settled, FALSE);
                        IF Apply THEN
                            "Pre-Assigned No." := PreAssignNo1
                        ELSE
                            "Pre-Assigned No." := '';
                    end;
                }
                field(Settled; Settled)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000018>")
            {
                Caption = 'Apply All';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RecExideClaim: Record "33019886";
                begin
                    ModifyAll(TRUE, Rec, PreAssignNo1);
                end;
            }
            action("<Action1000000019>")
            {
                Caption = 'UnApply All';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RecExideClaim: Record "33019886";
                begin
                    ModifyAll(FALSE, Rec, PreAssignNo1);
                end;
            }
        }
    }

    var
        PreAssignNo1: Code[20];

    [Scope('Internal')]
    procedure SetPreAssignNo(PreAssignNo: Code[20])
    begin
        PreAssignNo1 := PreAssignNo;
    end;
}

