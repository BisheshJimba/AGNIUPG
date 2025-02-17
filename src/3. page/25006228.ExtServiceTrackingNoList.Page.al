page 25006228 "Ext. Service Tracking No. List"
{
    // 15.07.2008. EDMS P2
    //   * Opened field "Purchase Amount", "Sale Amount"

    Caption = 'Ext. Service Tracking No. List';
    CardPageID = "Ext. Service Tracking No. Card";
    DataCaptionFields = "External Service No.";
    PageType = List;
    SourceTable = Table25006153;

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("External Serv. Tracking No."; "External Serv. Tracking No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Purchase Amount"; "Purchase Amount")
                {
                }
                field("Sales Amount"; "Sales Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&External Serv. Tracking No.")
            {
                Caption = '&External Serv. Tracking No.';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    RunObject = Page 25006229;
                    RunPageLink = External Service No.=FIELD(External Service No.),
                                  External Serv. Tracking No.=FIELD(External Serv. Tracking No.);
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }
}

