pageextension 50210 pageextension50210 extends "Campaign List"
{
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 25".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 27".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 28".

        modify("Action 19")
        {
            Visible = false;
        }
        modify("Action 20")
        {
            Visible = false;
        }
        addafter("Action 34")
        {
            group("<Action1101904000>")
            {
                Caption = 'Sales &Prices';
                Image = SalesPrices;
                action("<Action27>")
                {
                    Caption = '&Item';
                    Image = SalesPrices;
                    RunObject = Page 7002;
                    RunPageLink = Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("<Action1101904002>")
                {
                    Caption = '&Nonstock';
                    Image = SalesPrices;
                    RunObject = Page 25006845;
                                    RunPageLink = Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                }
                action("&Model Version")
                {
                    Caption = '&Model Version';
                    Image = SalesPrices;
                    RunObject = Page 25006543;
                                    RunPageLink = Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                }
                action("&Labor")
                {
                    Caption = '&Labor';
                    Image = SalesPrices;
                    RunObject = Page 25006154;
                                    RunPageLink = Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                }
            }
            group("<Action1101904001>")
            {
                Caption = 'Sales &Line Discounts';
                Image = SalesLineDisc;
                action("<Action28>")
                {
                    Caption = '&Item';
                    Image = SalesLineDisc;
                    RunObject = Page 7004;
                                    RunPageLink = Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                    RunPageView = SORTING(Sales Type,Sales Code);
                }
                action("<Action1101914002>")
                {
                    Caption = '&Nonstock';
                    Image = SalesLineDisc;
                    RunObject = Page 25006846;
                                    RunPageLink = Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                }
                action("<Action1101904003>")
                {
                    Caption = '&Model Version';
                    Image = SalesLineDisc;
                    RunObject = Page 25006544;
                                    RunPageLink = Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                }
            }
        }
    }
}

