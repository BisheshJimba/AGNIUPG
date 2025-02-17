page 25006802 "Item Markup Restriction Groups"
{
    // 22.10.2007. EDMS P2
    //   * Added new field "Notice Type"

    Caption = 'Item Markup Restriction Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006761;

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
                field("Notification Type"; "Notification Type")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Markup Restrictions")
            {
                Caption = 'Markup Restrictions';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006803;
                RunPageLink = Group Code=FIELD(Code);
            }
        }
    }
}

