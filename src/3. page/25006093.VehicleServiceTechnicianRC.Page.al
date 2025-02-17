page 25006093 "Vehicle Service Technician RC"
{
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added Page Action:
    //     Page Contract List EDMS
    // 
    // 25.03.2014 Elva Baltic P18 #RX021 MMG7.00
    //   Added New Page Action "Archieved Service Quotes"
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *Changed LVI captions
    // 
    // 17.03.2014 Elva Baltic P8 #S0002 MMG7.00
    //   * Added R250025

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 25006100)
                {
                }
            }
            group()
            {
                part(; 25006097)
                {
                }
            }
            group()
            {
                part(; 25006561)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Service Orders")
            {
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page 25006185;
            }
            action("<Action57>")
            {
                Caption = 'Vehicles';
                Image = ItemLines;
                RunObject = Page 25006033;
            }
        }
        area(sections)
        {
            group("<Action1101904009>")
            {
                Caption = 'Catalogues';
                Image = ReferenceData;
                action("<Action1101904014>")
                {
                    Caption = 'Makes';
                    Image = Production;
                    RunObject = Page 25006014;
                }
                action(Models)
                {
                    Caption = 'Models';
                    Image = ListPage;
                    RunObject = Page 25006016;
                }
                action("<Action58>")
                {
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page 31;
                }
                action("<Action1101904010>")
                {
                    Caption = 'Nonstock Items';
                    Image = Item;
                    RunObject = Page 5726;
                }
                action("<Action1101904002>")
                {
                    Caption = 'Labors';
                    Image = Job;
                    RunObject = Page 25006152;
                }
                action("<Action1101904003>")
                {
                    Caption = 'External Services';
                    Image = ServiceItem;
                    RunObject = Page 25006174;
                }
                action("<Action1101904004>")
                {
                    Caption = 'Service Packages';
                    Image = ServiceItemGroup;
                    RunObject = Page 25006161;
                }
                action(Tires)
                {
                    Caption = 'Tires';
                    Image = Item;
                    RunObject = Page 25006267;
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Action60>")
                {
                    Caption = 'Posted Service Orders';
                    Image = PostedServiceOrder;
                    RunObject = Page 25006197;
                }
                action("<Action61>")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedPayment;
                    RunObject = Page 25006189;
                }
                action("<Action160>")
                {
                    Caption = 'Posted Service Return Orders';
                    Image = PostedReturnReceipt;
                    RunObject = Page 25006220;
                }
                action("<Action62>")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedCreditMemo;
                    RunObject = Page 25006190;
                }
                action("<Action137>")
                {
                    Caption = 'Posted Transfer Shipments';
                    Image = PostedShipment;
                    RunObject = Page 25006191;
                }
                action("<Action3>")
                {
                    Caption = 'Posted Transfer Receipts';
                    Image = PostedReceipts;
                    RunObject = Page 25006192;
                }
                action("Archieved Service Quotes")
                {
                    Caption = 'Archieved Service Quotes';
                    Image = PostedReceipts;
                    RunObject = Page 25006233;
                    RunPageView = WHERE(Document Type=CONST(Quote));
                }
            }
        }
    }
}

