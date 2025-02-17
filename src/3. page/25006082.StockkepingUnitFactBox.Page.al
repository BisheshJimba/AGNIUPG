page 25006082 "Stockkeping Unit FactBox"
{
    // 02.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Page CaptionML property

    Caption = 'Stockkeping Unit Details';
    PageType = CardPart;
    SourceTable = Table5700;

    layout
    {
        area(content)
        {
            field("Reorder Point"; "Reorder Point")
            {
            }
            field("Maximum Inventory"; "Maximum Inventory")
            {
            }
        }
    }

    actions
    {
    }
}

