page 60002 "Manpower Budget List"
{
    CardPageID = "Manpower Budget Card";
    Editable = false;
    PageType = List;
    SourceTable = Table60000;

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
                RunObject = Page 60000;
                RunPageLink = Fiscal Year=FIELD(Fiscal Year);
            }
        }
    }
}

