page 25006057 "Service Advisor Role Center"
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
                part(; 25006058)
                {
                }
                systempart(; Outlook)
                {
                }
            }
            group()
            {
                part(; 9150)
                {
                }
                part(; 25006561)
                {
                }
                part(; 9152)
                {
                    Visible = false;
                }
                part(; 9175)
                {
                    Visible = false;
                }
                systempart(; MyNotes)
                {
                }
                part(; 681)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Pram Report Selector")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50067;
            }
            action("Act. Time by Post.Serv. Orders")
            {
                Caption = 'Act. Time by Post.Serv. Orders';
                Image = "Report";
                RunObject = Report 25006100;
            }
            action("Resource Service Times")
            {
                Caption = 'Resource Service Times';
                Image = "Report";
                RunObject = Report 25006006;
            }
            action("Finished Allocations by Types")
            {
                Caption = 'Finished Allocations by Types';
                Image = "Report";
                RunObject = Report 25006101;
            }
            action("Resource Usage")
            {
                Caption = 'Resource Usage';
                Image = "Report";
                RunObject = Report 25006131;
            }
            action("Service Ledger Entry Overview")
            {
                Caption = 'Service Ledger Entry Overview';
                Image = "Report";
                RunObject = Report 25006138;
            }
            action("Service Order Overview EDMS")
            {
                Caption = 'Service Order Overview EDMS';
                Image = "Report";
                RunObject = Report 25006139;
            }
            action("Service Documents")
            {
                Caption = 'Service Documents';
                Image = "Report";
                RunObject = Report 25006137;
            }
            action("Report Recall Services (Total)")
            {
                Caption = 'Report Recall Services (Total)';
                Image = "Report";
                RunObject = Report 25006026;
            }
        }
        area(embedding)
        {
            action("Service Quotes")
            {
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page 25006254;
            }
            action("Service Booking")
            {
                Caption = 'Service Booking';
                RunObject = Page 33020235;
            }
            action("Service Orders")
            {
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page 25006185;
            }
            action("<Action1101904016>")
            {
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page 25006175;
            }
            action("<Action15>")
            {
                Caption = 'Service Return Orders';
                Image = ReturnOrder;
                RunObject = Page 25006255;
            }
            action("<Action1101914016>")
            {
                Caption = 'Sales Cr.Memos';
                Image = CreditMemo;
                RunObject = Page 25006176;
            }
            action("<Action55>")
            {
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page 5052;
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page 22;
            }
            action("<Action57>")
            {
                Caption = 'Vehicles';
                Image = ItemLines;
                RunObject = Page 25006033;
            }
            action("<Action1101904005>")
            {
                Caption = 'Transfer Orders';
                Image = TransferOrder;
                RunObject = Page 25006217;
            }
            action("General Gatepass")
            {
                Caption = 'General Gatepass';
                RunObject = Page 50003;
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
                action("Closed Job")
                {
                    Caption = 'Closed Job';
                    RunObject = Page 25006258;
                }
            }
        }
        area(processing)
        {
            group("Service Document")
            {
                Caption = 'Service Document';
                action("Service Q&uote")
                {
                    Caption = 'Service Q&uote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25006198;
                    RunPageMode = Create;
                }
                action("Service &Order")
                {
                    Caption = 'Service &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25006183;
                    RunPageMode = Create;
                }
                action("<Action18>")
                {
                    Caption = 'Transfer &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 5740;
                    RunPageMode = Create;
                    RunPageView = SORTING(Document Profile)
                                  WHERE(Document Profile=CONST(Service));
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                action("Service Bookings")
                {
                    Caption = 'Service Bookings';
                    Image = Calendar;
                    RunObject = Page 25006899;
                }
                action("<TCard Planner>")
                {
                    Caption = 'TCard Planner';
                    Image = ResourcePlanning;
                    RunObject = Page 25006872;
                }
                action(Schedule)
                {
                    Caption = 'Schedule';
                    Image = Planning;
                    RunObject = Page 25006358;
                }
            }
            group("Time Registration")
            {
                Caption = 'Time Registration';
                action("Time Worksheet")
                {
                    Caption = 'Time Worksheet';
                    Image = PlanningWorksheet;
                    RunObject = Page 25006290;
                }
                action("Easy Clocking")
                {
                    Caption = 'Easy Clocking';
                    Image = Timesheet;
                    RunObject = Page 25006097;
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                action("<Action33>")
                {
                    Caption = 'Service Packages';
                    Image = Task;
                    RunObject = Page 25006161;
                }
                action("Page Service Target")
                {
                    Caption = 'Service Target';
                    Image = Forecast;
                    Promoted = true;
                    RunObject = Page 25006560;
                    RunPageMode = View;
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page 344;
                }
            }
        }
    }
}

