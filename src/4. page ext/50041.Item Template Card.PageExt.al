pageextension 50041 pageextension50041 extends "Item Template Card"
{
    // 08.02.2017 EB.P7 EDMS Upgrade 2017
    //   Added field group EDMS
    layout
    {
        addafter(Categorization)
        {
            group(EDMS)
            {
                Caption = 'EDMS';
                field("Item Type"; Rec."Item Type")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on ""Default Dimensions"(Action 24)".

    }
}

