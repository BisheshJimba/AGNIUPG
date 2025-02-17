page 33020137 "Prospect Pipeline History List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020198;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prospect No."; "Prospect No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("New Pipeline Code"; "New Pipeline Code")
                {
                }
                field("New Date"; "New Date")
                {
                }
                field("Old Date"; "Old Date")
                {
                }
                field("Old Pipeline Code"; "Old Pipeline Code")
                {
                }
                field("SalesPerson Code"; "SalesPerson Code")
                {
                }
                field(KIN; KIN)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000030>")
            {
                Caption = 'Update KIN';
                Image = EditList;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    UpdateKIN.GetLine(Rec);
                    UpdateKIN.RUN;
                end;
            }
        }
    }

    var
        UpdateKIN: Report "50053";
}

