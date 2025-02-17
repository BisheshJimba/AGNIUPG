page 25006809 "Spare Parts Sales Disc. Groups"
{
    Caption = 'Spare Parts Sales Disc. Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006732;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
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
        area(navigation)
        {
            group("Disc. Group")
            {
                Caption = 'Disc. Group';
                action(Items)
                {
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page 25006810;
                    RunPageLink = Sales Disc. Group Code=FIELD(Code);
                    RunPageView = SORTING(Sales Disc. Group Code,Type,No.);
                }
            }
        }
    }
}

