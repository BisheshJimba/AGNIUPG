page 25006033 "Vehicle List"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified OnOpenPage(), Usert Profile Setup to Branch Profile Setup
    // 
    // 26.03.2014 Elva Baltic P18 #F011 MMG7.00
    //   Added Page Action "Dimensions"
    // 
    // 27.02.2014 Elva Baltic P15 #F016 MMG7.00
    //   * Modified "Current Location Code"

    Caption = 'Vehicle List';
    CardPageID = "Vehicle Card";
    Editable = true;
    PageType = List;
    SourceTable = Table25006005;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(VIN; VIN)
                {
                }
                field("Serial No."; "Serial No.")
                {
                }
                field(Port; Port)
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = true;
                }
                field("Registration No."; "Registration No.")
                {
                }
                field("Production Year"; "Production Year")
                {
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field("Status Code"; "Status Code")
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("PP No."; "PP No.")
                {
                }
                field("PP Date"; "PP Date")
                {
                }
                field("Purchase Type"; "Purchase Type")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                action("<Action1102159008>")
                {
                    Caption = 'Vehicle &History';

                    trigger OnAction()
                    var
                        Vehicles: Record "25006005";
                    begin
                        CurrPage.SETSELECTIONFILTER(Vehicles);
                        REPORT.RUNMODAL(33020241, TRUE, FALSE, Vehicles);
                    end;
                }
                action("<Action41>")
                {
                    Caption = 'Service Ledger E&ntries';
                    RunObject = Page 25006211;
                    RunPageLink = Entry Type=CONST(Usage),
                                  Vehicle Serial No.=FIELD(Serial No.);
                    RunPageView = SORTING(Vehicle Serial No.,Entry Type,Posting Date);
                    ShortCutKey = 'Ctrl+F7';
                }
                separator()
                {
                }
                action("<Action1101904016>")
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006072;
                                    RunPageLink = Serial No.=FIELD(Serial No.);
                }
                action("<Action96>")
                {
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page 5096;
                                    RunPageLink = System To-do Type=FILTER(Contact Attendee),
                                  Vehicle Serial No.=FIELD(Serial No.);
                    RunPageView = SORTING(Contact Company No.,Date,Contact No.,Closed);
                }
                separator()
                {
                }
                action("<Action1000000005>")
                {
                    Caption = 'Accessories';
                    RunObject = Page 33020230;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                    RunPageView = WHERE(Accessories Issued=FILTER(Yes));
                }
                action("<Action157>")
                {
                    Caption = 'Options';
                    Image = Reconcile;
                    RunObject = Page 25006528;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                    RunPageView = SORTING(Vehicle Serial No.,Entry Type,Option Type,Option Code,Open);
                }
                action("<Action1101904011>")
                {
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        ShowVehReservationEntries(TRUE);
                    end;
                }
                action("<Action1101904031>")
                {
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    RunObject = Page 25006022;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action1101904010>")
                {
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action1101904003>")
                {
                    Caption = 'Warranties';
                    Image = ListPage;
                    RunObject = Page 25006027;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action1101914011>")
                {
                    Caption = 'Recall Campaigns';
                    Image = ListPage;
                    RunObject = Page 25006247;
                                    RunPageLink = VIN=FIELD(VIN);
                }
                action("<Action1101904007>")
                {
                    Caption = 'Insurances';
                    Image = ListPage;
                    RunObject = Page 25006053;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("Count Records")
                {
                    Caption = 'Count Records';
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CountRec := COUNT;
                        MESSAGE('No. of records are %1 ',CountRec);
                    end;
                }
                action(PageDimensionsAction)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                                    RunPageLink = Table ID=CONST(25006005),
                                  No.=FIELD(Serial No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("<Page Object Picture>")
                {
                    Caption = '&Pictures';
                    Image = Picture;
                    RunObject = Page 25006059;
                                    RunPageLink = Source Type=CONST(25006005),
                                  Source Subtype=CONST(0),
                                  Source ID=FIELD(Serial No.),
                                  Source Ref. No.=CONST(0);
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(25006005,0,"Serial No.",0)
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904002>")
                {
                    Caption = 'Service Plans';
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006180;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("Item Order Overview")
                {
                    Caption = 'Item Order Overview';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    var
                        ItemOrderOverview: Page "25006805";
                    begin
                        ItemOrderOverview.SetSourceType2(2); //Service
                        ItemOrderOverview.SetVehicleSerialNo("Serial No.");
                        ItemOrderOverview.SetFilters;
                        ItemOrderOverview.FindRec;
                        ItemOrderOverview.RUN;
                    end;
                }
            }
            group(Contact)
            {
                Caption = 'Contact';
                action("<Action1101904013>")
                {
                    Caption = 'Contacts';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006036;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action95>")
                {
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page 5076;
                                    RunPageLink = Contact No.=FILTER(<>''),
                                  Vehicle Serial No.=FIELD(Serial No.);
                    RunPageView = SORTING(Vehicle Serial No.);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group("<Action79>")
            {
                Caption = 'S&ales';
                action("<Action82>")
                {
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    RunObject = Page 25006543;
                                    RunPageLink = Item No.=FIELD(Model Version No.),
                                  Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action80>")
                {
                    Caption = 'Sales Line Discounts';
                    Image = SalesLineDisc;
                    RunObject = Page 25006544;
                                    RunPageLink = Type=CONST(Item),
                                  Code=FIELD(Model Version No.),
                                  Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action1101904021>")
                {
                    Caption = 'Sales Orders';
                    Image = Document;

                    trigger OnAction()
                    begin
                        ShowSalesOrders
                    end;
                }
                action("<Action1101904025>")
                {
                    Caption = 'Sales Return Orders';
                    Image = ReturnOrder;

                    trigger OnAction()
                    begin
                        ShowSalesReturnOrders
                    end;
                }
            }
            group("<Action84>")
            {
                Caption = '&Purchases';
                action("<Action1101914021>")
                {
                    Caption = 'Purchase Orders';
                    Image = "Order";

                    trigger OnAction()
                    begin
                        ShowPurchOrders
                    end;
                }
                action("<Action1101914025>")
                {
                    Caption = 'Purchase Return Orders';
                    Image = ReturnOrder;

                    trigger OnAction()
                    begin
                        ShowPurchReturnOrders
                    end;
                }
            }
            group("<Action179>")
            {
                Caption = 'Service';
                action("<Action40>")
                {
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page 25006211;
                                    RunPageLink = Entry Type=CONST(Usage),
                                  Vehicle Serial No.=FIELD(Serial No.);
                    RunPageView = SORTING(Vehicle Serial No.,Entry Type,Posting Date);
                    ShortCutKey = 'Ctrl+F7';
                }
                action("<Action1101924021>")
                {
                    Caption = 'Service Orders';
                    Image = "Order";

                    trigger OnAction()
                    begin
                        ShowServOrders
                    end;
                }
                action("<Action1101924025>")
                {
                    Caption = 'Service Return Orders';
                    Image = ReturnOrder;

                    trigger OnAction()
                    begin
                        ShowServReturnOrders
                    end;
                }
            }
            group(Tires)
            {
                Caption = 'Tires';
                action(Axles)
                {
                    Caption = 'Axles';
                    Image = ListPage;
                    RunObject = Page 25006277;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action(Tires)
                {
                    Caption = 'Tires';
                    Image = ListPage;
                    RunObject = Page 25006269;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.),
                                  Open=CONST(Yes);
                }
            }
        }
        area(processing)
        {
            action("Create &Interact")
            {
                AccessByPermission = TableData 5062=R;
                Caption = 'Create &Interact';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateInteraction;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*//28.04.2014 Elva Baltic P8 #S0058 MMG7.00 >>
        VehicleContact.RESET;
        VehicleContact.SETRANGE("Vehicle Serial No.", "Serial No.");
        IF VehicleContact.FINDFIRST THEN BEGIN
          VehicleContact.CALCFIELDS("Contact Name");
          ContactName := VehicleContact."Contact Name";
        END ELSE
          ContactName := '';
        //28.04.2014 Elva Baltic P8 #S0058 MMG7.00 <<
        */
        //CALCFIELDS("Custom Clearance Memo No.","Insurance Memo No.","Insurance Policy No.");
        /*
        CLEAR(LocationBeforeShipment);
        //ItemLedgEntry.CALCFIELDS(VIN);
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE(VIN,VIN);
        ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Transfer);
        ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Transfer Shipment");
        ItemLedgEntry.SETFILTER("Location Code",'<>%1','INTRANSIT');
        ItemLedgEntry.SETRANGE("Remaining Quantity",0);
        IF ItemLedgEntry.FINDLAST THEN BEGIN
          LocationBeforeShipment := ItemLedgEntry."Location Code";
        END;
        
        
        CLEAR(LocationBeforeShipment);
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE("Serial No.","Serial No.");
        ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Purchase);
        ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Purchase Receipt");
        //ItemLedgEntry.SETFILTER("Location Code",'<>%1','INTRANSIT');
        //ItemLedgEntry.SETRANGE("Remaining Quantity",0);
        IF ItemLedgEntry.FINDFIRST THEN BEGIN
          LocationBeforeShipment := ItemLedgEntry."Location Code";
        END;
           */

    end;

    trigger OnInit()
    begin
        tCountVisible := TRUE;
        cCountVisible := TRUE;
    end;

    trigger OnOpenPage()
    begin
        IF UserProfileMgt.CurrProfileID <> '' THEN
         BEGIN
          IF recWorkPlace.GET(UserProfileMgt.CurrProfileID) THEN
           BEGIN
              IF recWorkPlace."Show Vehicle Count" THEN
               BEGIN
                cCountVisible := TRUE;
                tCountVisible := TRUE;
               END
              ELSE
               BEGIN
                cCountVisible := FALSE;
                tCountVisible := FALSE;
               END;
           END;
        END;
        
        FILTERGROUP(2);
        /*CompwiseMakeSetup.RESET;
        CompwiseMakeSetup.SETRANGE("Company Name",COMPANYNAME);
        IF CompwiseMakeSetup.FINDFIRST THEN BEGIN
           SETFILTER("Make Code",CompwiseMakeSetup."Make Code Filter");
        END; //Uncommentd by Amisha for make code wise vehicle filter
        */
        FILTERGROUP(0);

    end;

    var
        VehicleContact: Record "25006013";
        recWorkPlace: Record "25006067";
        [InDataSet]
        cCountVisible: Boolean;
        [InDataSet]
        tCountVisible: Boolean;
        PictureMgt: Codeunit "25006015";
        [InDataSet]
        ContactName: Text[50];
        UserProfileMgt: Codeunit "25006002";
        cuSingleInstanceMgt: Codeunit "25006001";
        CountRec: Integer;
        CompwiseMakeSetup: Record "33019876";
        LocationBeforeShipment: Code[20];
        ItemLedgEntry: Record "32";
        CompanyInformation: Record "79";
        Make: Record "25006000";
        MakeCodeFilter: Text[100];
        Vehicle: Record "25006005";
}

