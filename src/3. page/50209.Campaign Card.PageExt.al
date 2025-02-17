pageextension 50209 pageextension50209 extends "Campaign Card"
{
    // 2012.06.05 EDMS P8
    //   * added actions: prices and discounts
    Caption = '&Item';

    //Unsupported feature: Property Insertion (Name) on ""Campaign Card"(Page 5086)".

    Caption = '&Item';

    //Unsupported feature: Property Insertion (Name) on ""Campaign Card"(Page 5086)".

    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 35".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 37".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 38".


        //Unsupported feature: Property Modification (Level) on "Action 27".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 27".


        //Unsupported feature: Property Modification (Level) on "Action 28".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 28".

        addafter("Action 31")
        {
            action("Sales &Prices")
            {
                Caption = 'Sales &Prices';
                Image = SalesPrices;
                RunObject = Page 7002;
                RunPageLink = Sales Type=CONST(Campaign),
                              Sales Code=FIELD(No.);
                RunPageView = SORTING(Sales Type,Sales Code);
            }
            action("Sales &Line Discounts")
            {
                Caption = 'Sales &Line Discounts';
                Image = SalesLineDisc;
                RunObject = Page 7004;
                                RunPageLink = Sales Type=CONST(Campaign),
                              Sales Code=FIELD(No.);
                RunPageView = SORTING(Sales Type,Sales Code);
            }
            group("<Action1101904000>")
            {
                Caption = 'Sales &Prices';
                Image = SalesPrices;
            }
        }
        addfirst("Action 27")
        {
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
            group("<Action1101904001>")
            {
                Caption = 'Sales &Line Discounts';
                Image = SalesLineDisc;
            }
        }
        addfirst("Action 28")
        {
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

