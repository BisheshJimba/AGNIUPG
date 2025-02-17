page 33020383 "Manpower Budget List New"
{
    CardPageID = "Manpower Budget Card New";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,View';
    SourceTable = Table33020376;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit_Budget)
            {
                Caption = 'Edit Budget';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020391;
                RunPageLink = Fiscal Year=FIELD(Fiscal Year);
            }
        }
        area(navigation)
        {
            group("<Action1000000002>")
            {
                Caption = 'View';
                action("<Action1000000001>")
                {
                    Caption = 'Manpower Budget Variance';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 33020401;
                                    RunPageLink = Fiscal Year=FIELD(Fiscal Year);
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        //msg('123');
                    end;
                }
            }
        }
    }
}

