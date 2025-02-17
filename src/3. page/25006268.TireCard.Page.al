page 25006268 "Tire Card"
{
    Caption = 'Tire Card';
    PageType = Card;
    SourceTable = Table25006180;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Available; Available)
                {
                }
                field("Current Vehicle Serial No."; "Current Vehicle Serial No.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1101904009>")
            {
                Caption = '&Tire';
                action("&Entries")
                {
                    Caption = '&Entries';
                    Image = LedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006269;
                    RunPageLink = Tire Code=FIELD(Code);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}

