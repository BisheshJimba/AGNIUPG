page 33019934 "Battery Warranties List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33019886;
    SourceTableView = WHERE(Issued = CONST(Yes),
                            Settled = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Claim No."; "Claim No.")
                {
                    Editable = false;
                }
                field("Claim Date"; "Claim Date")
                {
                    Editable = false;
                }
                field("Issue Date"; "Issue Date")
                {
                    Editable = false;
                }
                field("Job Card No."; "Job Card No.")
                {
                    Editable = false;
                }
                field("Job Date"; "Job Date")
                {
                    Editable = false;
                }
                field("Battery Part No."; "Battery Part No.")
                {
                    Editable = false;
                }
                field("Battery Description"; "Battery Description")
                {
                    Editable = false;
                }
                field("Qty."; "Qty.")
                {
                    Editable = false;
                }
                field("NDP Rate"; "NDP Rate")
                {
                    Editable = false;
                }
                field("Claim Amount"; "Claim Amount")
                {
                    Editable = false;
                }
                field("Additional Amount"; "Additional Amount")
                {
                    Editable = false;
                }
                field("Scrap Amount"; "Scrap Amount")
                {
                    Editable = false;
                }
                field("Total Claim Amount"; "Total Claim Amount")
                {
                    Editable = false;
                }
                field("Pre-Assigned No."; "Pre-Assigned No.")
                {
                    Editable = false;
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
            action("UnApply All")
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

