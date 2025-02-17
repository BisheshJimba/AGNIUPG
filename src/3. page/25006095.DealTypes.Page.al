page 25006095 "Deal Types"
{
    Caption = 'Deal Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006068;

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
            group("Deal Type")
            {
                Caption = 'Deal Type';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = Table ID=CONST(25006068),
                                  No.=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = SalesPrices;
                    RunObject = Page 25006154;
                                    RunPageLink = Field130=FIELD(Code);
                    Visible = false;
                }
            }
        }
    }
}

