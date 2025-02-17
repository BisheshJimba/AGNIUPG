page 25006032 "Vehicle Card"
{
    // 16.02.2015 EB.P7 #T022
    //   Serial No. Hiding functionality added.
    // 
    // 16.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve: FIELD "Serv. Ledger Entry Exist" is removed by variable ServLedgerEntryExist!
    // 
    // 03.04.2014 Elva Baltic P15 # MMG7.00
    //   * Changed Reservation TAB Caption
    // 
    // 26.03.2014 Elva Baltic P18 #RX025 MMG7.00
    //   * Added Page Action "Vehicle Comments"
    // 
    // 04.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added field: "Fixed Asset No."
    // 
    // 03.03.2014 Elva Baltic P08 #S0016 MMG7.00
    //   * Translate captions of actions
    // 
    // 27.02.2014 Elva Baltic P15 #F016 MMG7.00
    //   * Added "Current Location Code"
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 14.09.2007. EDMS P2
    //   * Added Menu Item "Functions -> Item Order Overview"
    // 
    // 26.07.2007. EDMS P2
    //   * Added Menu Item "Service -> History"
    // 
    // 12.06.2007. EDMS P2
    //   * Added Menu Item Vehicle -> Guarantee Information

    Caption = 'Vehicle Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table25006005;
    SourceTableView = SORTING(VIN);

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Serial No."; "Serial No.")
                {
                    Editable = false;
                    Visible = SerialNoVisible;

                    trigger OnAssistEdit()
                    begin
                        CurrPage.UPDATE;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(VIN; VIN)
                {
                    Editable = allowmodifyall;
                }
                field(Port; Port)
                {
                }
                field("VC No."; "VC No.")
                {
                    Editable = false;
                }
                field("Make Code"; "Make Code")
                {
                    Editable = allowmodifyall;
                }
                field("Model Code"; "Model Code")
                {
                    Editable = allowmodifyall;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Editable = allowmodifyall;
                }
                field("Engine No."; "Engine No.")
                {
                    Editable = allowmodifyall;
                }
                field("Registration No."; "Registration No.")
                {
                }
                field(Blocked; Blocked)
                {
                    Editable = allowmodifyall;
                }
                field("Vehicle Driver"; "Vehicle Driver")
                {
                    Editable = allowmodifyregno;
                }
                field("Driver Contact"; "Driver Contact")
                {
                    Editable = allowmodifyregno;
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Next Vehicle Inspection Date"; "Next Vehicle Inspection Date")
                {
                }
                field("Namsari Date"; "Namsari Date")
                {
                }
                field("Status Code"; "Status Code")
                {
                }
                field("Namsari Date (BS)"; "Namsari Date (BS)")
                {
                }
                field(Inventory; Inventory)
                {
                }
                field("Production Year"; "Production Year")
                {
                }
                field("Commercial Invoice No."; "Commercial Invoice No.")
                {
                }
                field(Kilometrage; Kilometrage)
                {
                }
                field("Current Location of Vehicle"; "Current Location of Vehicle")
                {
                    Editable = false;
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("PP No."; "PP No.")
                {
                }
                field("Purchase Type"; "Purchase Type")
                {
                }
                field("PP Date"; "PP Date")
                {
                }
            }
            group(Specification)
            {
                Caption = 'Specification';
                Editable = allowmodifyregno;
                Visible = false;
                field("Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = VF25006800Visible;
                }
                field("Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = VF25006801Visible;
                }
                field("Variable Field 25006802"; "Variable Field 25006802")
                {
                    Visible = VF25006802Visible;
                }
                field("Variable Field 25006803"; "Variable Field 25006803")
                {
                    Visible = VF25006803Visible;
                }
                field("Variable Field 25006804"; "Variable Field 25006804")
                {
                    Visible = VF25006804Visible;
                }
                field("Variable Field 25006805"; "Variable Field 25006805")
                {
                    Visible = VF25006805Visible;
                }
                field("Variable Field 25006806"; "Variable Field 25006806")
                {
                    Visible = VF25006806Visible;
                }
                field("Variable Field 25006807"; "Variable Field 25006807")
                {
                    Visible = VF25006807Visible;
                }
                field("Variable Field 25006809"; "Variable Field 25006809")
                {
                    Visible = VF25006809Visible;
                }
                field("Variable Field 25006810"; "Variable Field 25006810")
                {
                    Visible = VF25006810Visible;
                }
                field("Variable Field 25006811"; "Variable Field 25006811")
                {
                    Visible = VF25006811Visible;
                }
                field("Variable Field 25006812"; "Variable Field 25006812")
                {
                    Visible = VF25006812Visible;
                }
                field("Variable Field 25006818"; "Variable Field 25006818")
                {
                    Visible = VF25006818Visible;
                }
                field("Variable Field 25006813"; "Variable Field 25006813")
                {
                    Visible = VF25006813Visible;
                }
                field("Variable Field 25006814"; "Variable Field 25006814")
                {
                    Visible = VF25006814Visible;
                }
                field("Variable Field 25006815"; "Variable Field 25006815")
                {
                    Visible = VF25006815Visible;
                }
                field("Variable Field 25006816"; "Variable Field 25006816")
                {
                    Visible = VF25006816Visible;
                }
                field("Variable Field 25006817"; "Variable Field 25006817")
                {
                    Visible = VF25006817Visible;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = VFRun2Visible;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = VFRun3Visible;
                }
            }
            group("Specification 2")
            {
                Caption = 'Specification 2';
                Editable = allowmodifyregno;
                Visible = false;
                field("Variable Field 25006819"; "Variable Field 25006819")
                {
                    Visible = VF25006819Visible;
                }
                field("Variable Field 25006820"; "Variable Field 25006820")
                {
                    Visible = VF25006820Visible;
                }
                field("Variable Field 25006821"; "Variable Field 25006821")
                {
                    Visible = VF25006821Visible;
                }
                field("Variable Field 25006822"; "Variable Field 25006822")
                {
                    Visible = VF25006822Visible;
                }
                field("Variable Field 25006823"; "Variable Field 25006823")
                {
                    Visible = VF25006823Visible;
                }
                field("Variable Field 25006824"; "Variable Field 25006824")
                {
                    Visible = VF25006824Visible;
                }
                field("Variable Field 25006825"; "Variable Field 25006825")
                {
                    Visible = VF25006825Visible;
                }
            }
            group("Agni Aastha Company")
            {
                Caption = 'Agni Aastha Company';
                Visible = ShowAgniAsthaCompany;
                field("Vehicle Price Calculation Date"; "Vehicle Price Calculation Date")
                {
                    Caption = 'Last Time Interest Apply Date';
                    Editable = false;
                }
                field("Purchase Amount"; "Purchase Amount")
                {
                    Caption = 'Purch. Amt. With Item Charge';
                    Editable = false;
                }
                field("Margin Amount"; "Margin Amount")
                {
                    Editable = false;
                }
                field("Interest Amount"; "Interest Amount")
                {
                    Editable = false;
                }
                field("Warranty Provision"; "Warranty Provision")
                {
                    Editable = EditWarantyInsuranceProvision;
                }
                field("Insurance Provision"; "Insurance Provision")
                {
                    Editable = EditWarantyInsuranceProvision;
                }
                field("First Month Interest"; "First Month Interest")
                {
                    Caption = '30 Days Interest';
                    Editable = false;
                }
                field("Sales Price"; "Sales Price")
                {
                    Caption = 'Total Sales Price';
                    Editable = false;
                }
            }
            part(VehicleContacts; 25006050)
            {
                Caption = 'Contacts';
                SubPageLink = Vehicle Serial No.=FIELD(Serial No.);
            }
            part(VehicleSalesPrice; 25006531)
            {
                Caption = 'Sales Price';
                SubPageLink = Item No.=FIELD(Model Version No.),
                              Make Code=FIELD(Make Code),
                              Model Code=FIELD(Model Code),
                              Model Version No.=FIELD(Model Version No.),
                              Vehicle Serial No.=FIELD(Serial No.),
                              Document Profile=CONST(Vehicles Trade);
            }
            part(;25006533)
            {
                SubPageLink = Vehicle Serial No.=FIELD(Serial No.);
            }
        }
        area(factboxes)
        {
            part(;25006252)
            {
                SubPageLink = Serial No.=FIELD(Serial No.);
                Visible = true;
            }
            part(;33020078)
            {
                SubPageLink = Vehicle Serial No.=FIELD(UPPERLIMIT(Serial No.));
                SubPageView = SORTING(Vehicle Serial No.,Line No.)
                              ORDER(Descending);
            }
            part(;25006262)
            {
                SubPageLink = Serial No.=FIELD(Serial No.);
                Visible = false;
            }
            part("Vehicle Pictures";25006047)
            {
                Caption = 'Vehicle Pictures';
                SubPageLink = Source Type=CONST(25006005),
                              Source Subtype=CONST(0),
                              Source ID=FIELD(Serial No.),
                              Source Ref. No.=CONST(0);
                SubPageView = SORTING(Source Type,Source Subtype,Source ID,Source Ref. No.,No.);
            }
            systempart(;Links)
            {
                Visible = true;
            }
            systempart(;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action103>")
            {
                Caption = '&Vehicle';
                action("<Action1000000025>")
                {
                    Caption = 'Membership Form';
                    RunObject = Page 33020106;
                }
                action("<Action1102159008>")
                {
                    Caption = 'Vehicle &History';

                    trigger OnAction()
                    var
                        Vehicles: Record "25006005";
                    begin
                        CurrPage.SETSELECTIONFILTER(Vehicles);
                        REPORT.RUNMODAL(33020241,TRUE,FALSE,Vehicles);
                    end;
                }
                action("Service Plans")
                {
                    Caption = 'Service Plans';
                    Image = ServiceHours;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006180;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("Process Checklists")
                {
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action1101904003>")
                {
                    Caption = 'Warranties';
                    Image = WarrantyLedger;
                    RunObject = Page 25006027;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                }
                action(VehicleComment)
                {
                    Caption = 'Vehicle Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Vehicle),
                                  No.=FIELD(Serial No.);
                }
                action("Process Price")
                {
                    Image = Recalculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowAgniAsthaCompany;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(Vehicle);
                        CLEAR(UpdateVehPrice);
                        UpdateVehPrice.SETTABLEVIEW(Vehicle);
                        UpdateVehPrice.RUN;
                    end;
                }
                group(Entries)
                {
                    Caption = 'Entries';
                    Image = Ledger;
                    action("<Action40>")
                    {
                        Caption = 'Service Ledger E&ntries';
                        Image = ServiceLedger;
                        ShortCutKey = 'Ctrl+F7';

                        trigger OnAction()
                        begin
                            ServOrdInfoPaneMgt.LookupServiceHistory2("Serial No.");
                        end;
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
                    action("<Action1101904011>")
                    {
                        Caption = 'Reservation Entries';
                        Image = ReservationLedger;

                        trigger OnAction()
                        begin
                            ShowVehReservationEntries(TRUE);
                        end;
                    }
                    action("Tire Entries")
                    {
                        Caption = 'Tire Entries';
                        Image = LedgerEntries;
                        RunObject = Page 25006269;
                                        RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                    }
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
                group(Lists)
                {
                    Caption = 'Lists';
                    Image = Administration;
                    action(Contacts)
                    {
                        Caption = 'Contacts';
                        Image = CustomerContact;
                        RunObject = Page 25006036;
                                        RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                    }
                    action(Accessories)
                    {
                        Caption = 'Accessories';
                        RunObject = Page 33020230;
                                        RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                        RunPageView = WHERE(Accessories Issued=FILTER(Yes));
                    }
                    action("<Action157>")
                    {
                        Caption = 'Options';
                        Image = CheckList;
                        RunObject = Page 25006528;
                                        RunPageLink = Vehicle Serial No.=FIELD(Serial No.),
                                      Open=FILTER(Yes);
                        RunPageView = SORTING(Vehicle Serial No.,Entry Type,Option Type,Option Code,Open);
                    }
                    action(Tires)
                    {
                        Caption = 'Tires';
                        Image = Item;
                        RunObject = Page 25006283;
                                        RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                    }
                    action(Axles)
                    {
                        Caption = 'Axles';
                        Image = ItemGroup;
                        RunObject = Page 25006276;
                                        RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                    }
                    action("<Action1101914011>")
                    {
                        Caption = 'Recall Campaigns';
                        Image = Campaign;
                        RunObject = Page 25006247;
                                        RunPageLink = VIN=FIELD(VIN);
                    }
                    action(Insurances)
                    {
                        Caption = 'Insurances';
                        Image = Insurance;
                        RunObject = Page 25006053;
                                        RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
                    }
                    action(Components)
                    {
                        Caption = 'Components';
                        Image = Components;
                        RunObject = Page 25006030;
                                        RunPageLink = Parent Vehicle Serial No.=FIELD(Serial No.);
                    }
                }
                action("<Action1101904007>")
                {
                    Caption = 'Item Order Overview';
                    Image = "Order";

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
                action("Register AMC")
                {
                    Caption = 'Register AMC';
                    RunObject = Page 33020241;
                                    RunPageLink = VIN Code=FIELD(VIN);
                }
                action("<Action1000000007>")
                {
                    Caption = 'Commission';
                }
                separator()
                {
                }
                action("<Action1000000009>")
                {
                    Caption = 'Change Booking';

                    trigger OnAction()
                    begin
                        BookingChange.RESET;
                        BookingChange.INIT;
                        BookingChange.INSERT(TRUE);
                        BookingChange.VALIDATE("No.");
                        BookingChange.VALIDATE("Previous Customer No.","Customer No.");
                        BookingChange.VIN := VIN;
                        BookingChange."Vehicle No." := "Serial No.";
                        BookingChange.Date := CURRENTDATETIME;
                        BookingChange.MODIFY;
                        PAGE.RUN(PAGE::"Booking Change Card");
                        MESSAGE(BookingChange."Vehicle No.");
                        MESSAGE(BookingChange.VIN);
                    end;
                }
                action("<Action1000000004>")
                {
                    Caption = 'Create PDI Form';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //PAGE.RUN(PAGE::"PDI List");
                        PDIHdr.RESET;
                        PDIHdr.INIT;
                        PDIHdr.INSERT(TRUE);
                        PDIHdr."Vehicle Serial No." := "Serial No.";
                        PDIHdr.VIN := VIN;
                        PDIHdr.Make := "Make Code";
                        PDIHdr.Model := "Model Code";
                        PDIHdr."Model Version No." := "Model Version No.";
                        PDIHdr."Registration No." := "Registration No.";
                        PDIHdr."Engine No." := "Engine No.";
                        PDIHdr."PDI Date" := TODAY;
                        PDIHdr.MODIFY;

                        MESSAGE('PDI Sheet has been generated');
                    end;
                }
                action("<Action1000000014>")
                {
                    Caption = 'PDI Forms';
                    RunObject = Page 33020058;
                                    RunPageLink = VIN=FIELD(VIN);

                    trigger OnAction()
                    begin
                        //PAGE.RUN(PAGE::"PDI List");
                    end;
                }
                action("<Action1000000015>")
                {
                    Caption = 'Create Veh. Delivery Checklist';
                    Visible = false;

                    trigger OnAction()
                    begin
                        VehChklistHdr.RESET;
                        VehChklistHdr.INIT;
                        VehChklistHdr.INSERT(TRUE);
                        VehChklistHdr.VIN := VIN;
                        VehChklistHdr.Model := "Model Code";
                        VehChklistHdr."Engine No." := "Engine No.";
                        VehChklistHdr.MODIFY;
                        MESSAGE('Vehicle Delivery Checklist has been generated');

                        VehChklistTemp.RESET;
                        VehChklistHdr.SETRANGE(VIN,VIN);
                        IF VehChklistTemp.FINDFIRST THEN BEGIN
                          REPEAT
                            VehDelChklist.INIT;
                            VehDelChklist."No." := VehChklistHdr."No.";
                            VehDelChklist."S.No." := VehChklistTemp."S.No.";
                            VehDelChklist.Particulars := VehChklistTemp.Particulars;
                            VehDelChklist.INSERT;
                          UNTIL VehChklistTemp.NEXT = 0;
                        END;

                        //PAGE.RUN(PAGE::"Veh. Delivery Chklist Card");
                    end;
                }
                action("<Action1000000016>")
                {
                    Caption = 'Veh. Delivery Checklists';
                    Visible = false;

                    trigger OnAction()
                    begin
                        PAGE.RUN(PAGE::"Veh. Delivery Chklist Card");
                    end;
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
                action(PageDimensionsAction)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                                    RunPageLink = Table ID=CONST(25006005),
                                  No.=FIELD(Serial No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("<Action1101904031>")
                {
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    RunObject = Page 25006022;
                                    RunPageLink = Vehicle Serial No.=FIELD(Serial No.);
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
            }
            group("<Action79>")
            {
                Caption = 'S&ales';
                action("<Action82>")
                {
                    Caption = 'Prices';
                    Image = SalesPrices;
                    RunObject = Page 25006543;
                                    RunPageLink = Item No.=FIELD(Model Version No.),
                                  Vehicle Serial No.=FIELD(Serial No.);
                }
                action("<Action80>")
                {
                    Caption = 'Line Discounts';
                    Image = SalesLineDisc;
                    RunObject = Page 25006544;
                                    RunPageLink = Type=CONST(Item),
                                  Code=FIELD(Model Version No.),
                                  Vehicle Serial No.=FIELD(Serial No.);
                }
                group("Vehicle Documents")
                {
                    Caption = 'Vehicle Documents';
                    Image = Document;
                    action(Quotes)
                    {
                        Caption = 'Quotes';
                        Image = Document;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSalesDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action("<Action1101904021>")
                    {
                        Caption = 'Orders';
                        Image = Document;

                        trigger OnAction()
                        begin
                            ShowSalesOrders
                        end;
                    }
                    action(SaleInvAction)
                    {
                        Caption = 'Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSalesDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action("<Action1101904025>")
                    {
                        Caption = 'Return Orders';
                        Image = ReturnOrder;

                        trigger OnAction()
                        begin
                            ShowSalesReturnOrders
                        end;
                    }
                    action("Posted Invoices")
                    {
                        Caption = 'Posted Invoices';
                        Image = PostedPayment;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action("Posted Credit Memos")
                    {
                        Caption = 'Posted Credit Memos';
                        Image = PostedCreditMemo;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(1, "Serial No.");
                        end;
                    }
                    action("Posted Shipments")
                    {
                        Caption = 'Posted Shipments';
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action("Posted Return Receipts")
                    {
                        Caption = 'Posted Return Receipts';
                        Image = ReturnReceipt;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedSalesDocOfVehicle(3, "Serial No.");
                        end;
                    }
                }
                group("Spare Parts Documents")
                {
                    Caption = 'Spare Parts Documents';
                    Image = Document;
                    action(SparePartsQuotesAction)
                    {
                        Caption = 'Quotes';
                        Image = Quote;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action(SparePartsOrdersAction)
                    {
                        Caption = 'Orders';
                        Image = "Order";

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(1, "Serial No.");
                        end;
                    }
                    action(SparePartsInvAction)
                    {
                        Caption = 'Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action(SparePartsRetAction)
                    {
                        Caption = 'Return Orders';
                        Image = ReturnOrder;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(3, "Serial No.");
                        end;
                    }
                    action("Posted Invoices")
                    {
                        Caption = 'Posted Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action("Posted Credit Memos")
                    {
                        Caption = 'Posted Credit Memos';
                        Image = PostedCreditMemo;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(1, "Serial No.");
                        end;
                    }
                    action("Posted Shipments")
                    {
                        Caption = 'Posted Shipments';
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action("Posted Return Receipts")
                    {
                        Caption = 'Posted Return Receipts';
                        Image = ReturnReceipt;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsPostedSalesDocOfVehicle(3, "Serial No.");
                        end;
                    }
                }
            }
            group("<Action84>")
            {
                Caption = '&Purchases';
                group("Vehicle Documents")
                {
                    Caption = 'Vehicle Documents';
                    Image = Document;
                    action(Quotes)
                    {
                        Caption = 'Quotes';
                        Image = Document;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPurchaseDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action(Orders)
                    {
                        Caption = 'Orders';
                        Image = Document;

                        trigger OnAction()
                        begin
                            ShowPurchOrders
                        end;
                    }
                    action(Invoices)
                    {
                        Caption = 'Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPurchaseDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action("Return Orders")
                    {
                        Caption = 'Return Orders';
                        Image = ReturnOrder;

                        trigger OnAction()
                        begin
                            ShowPurchReturnOrders
                        end;
                    }
                    action("Posted Invoices")
                    {
                        Caption = 'Posted Invoices';
                        Image = PostedPayment;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action("Posted Credit Memos")
                    {
                        Caption = 'Posted Credit Memos';
                        Image = PostedCreditMemo;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(1, "Serial No.");
                        end;
                    }
                    action("Posted Return Shipments")
                    {
                        Caption = 'Posted Return Shipments';
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action("Posted Receipts")
                    {
                        Caption = 'Posted Receipts';
                        Image = ReturnReceipt;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedPurchaseDocOfVehicle(3, "Serial No.");
                        end;
                    }
                }
                group("Spare Parts Documents")
                {
                    Caption = 'Spare Parts Documents';
                    Image = Document;
                    action(Quotes)
                    {
                        Caption = 'Quotes';
                        Image = Quote;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action(Orders)
                    {
                        Caption = 'Orders';
                        Image = "Order";

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(1, "Serial No.");
                        end;
                    }
                    action(Invoices)
                    {
                        Caption = 'Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action("Return Orders")
                    {
                        Caption = 'Return Orders';
                        Image = ReturnOrder;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowSPartsSalesDocOfVehicle(3, "Serial No.");
                        end;
                    }
                }
            }
            group("<Action179>")
            {
                Caption = 'Service';
                group("Actual Documents")
                {
                    Caption = 'Actual Documents';
                    Image = Sales;
                    action(Quotes)
                    {
                        Caption = 'Quotes';
                        Image = Document;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowServiceDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action("<Action1101924021>")
                    {
                        Caption = 'Orders';
                        Image = Document;

                        trigger OnAction()
                        begin
                            ShowServOrders
                        end;
                    }
                    action(ServInvAction)
                    {
                        Caption = 'Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowServiceDocOfVehicle(3, "Serial No.");
                        end;
                    }
                    action("<Action1101924025>")
                    {
                        Caption = 'Return Orders';
                        Image = ReturnOrder;

                        trigger OnAction()
                        begin
                            ShowServReturnOrders
                        end;
                    }
                }
                group("Posted Documents")
                {
                    Caption = 'Posted Documents';
                    Image = RegisteredDocs;
                    action(ServPostOrdAction)
                    {
                        Caption = 'Posted Orders';
                        Image = PostedServiceOrder;

                        trigger OnAction()
                        begin
                            //Order,Invoice,Credit Memo,Return Order
                            LookupMgt.ShowPostedServiceDocOfVehicle(0, "Serial No.");
                        end;
                    }
                    action(ServPostInvAction)
                    {
                        Caption = 'Posted Invoices';
                        Image = Invoice;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(1, "Serial No.");
                        end;
                    }
                    action(ServPostCrMemAction)
                    {
                        Caption = 'Posted Credit Memos';
                        Image = PostedMemo;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(2, "Serial No.");
                        end;
                    }
                    action(ServPostRetOrdAction)
                    {
                        Caption = 'Posted Return Orders';
                        Image = PostedReturnReceipt;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(3, "Serial No.");
                        end;
                    }
                    action("Posted Transfer Shipments")
                    {
                        Caption = 'Posted Transfer Shipments';
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(4, "Serial No.");
                        end;
                    }
                    action("Posted Transfer Receipts")
                    {
                        Caption = 'Posted Transfer Receipts';
                        Image = ReturnReceipt;

                        trigger OnAction()
                        begin
                            LookupMgt.ShowPostedServiceDocOfVehicle(5, "Serial No.");
                        end;
                    }
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
            action("Update KM")
            {
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    FilterPage: FilterPageBuilder;
                    Vehicle: Record "25006005";
                    NewKM: Decimal;
                    SysMgt: Codeunit "50000";
                begin
                    CLEAR(FilterPage);
                    FilterPage.ADDRECORD('Update KM',Vehicle);
                    FilterPage.ADDFIELD('Update KM',Vehicle."Previous KM");
                    FilterPage.PAGECAPTION := 'Update KM';
                    FilterPage.RUNMODAL;
                    Vehicle.SETVIEW(FilterPage.GETVIEW('Update KM'));
                    IF Vehicle.GETFILTER("Previous KM") <> '' THEN BEGIN
                      EVALUATE(NewKM,Vehicle.GETFILTER("Previous KM"));


                    Vehicle.RESET;
                    Vehicle.SETRANGE("Serial No.",Rec."Serial No.");
                    IF Vehicle.FINDFIRST THEN BEGIN
                      IF NOT CONFIRM('Do you want to update the kilometrage?',FALSE) THEN
                        EXIT;

                      SysMgt.insertIntoServiceLedger(Vehicle,NewKM);


                        MESSAGE('Updated.');
                     END;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CALCFIELDS("Serv. Ledger Entry Exist");
        ServLedgerEntryExist := "Serv. Ledger Entry Exist";
        //AGNI UPG 2009
        AllowModifyAll := FALSE;
        AllowModifyRegNo := FALSE;
        
        UserSetup.GET(USERID);
        IF UserSetup."Vehicle Modify Authority" = UserSetup."Vehicle Modify Authority"::All THEN BEGIN
            AllowModifyAll := TRUE;
            AllowModifyRegNo := TRUE;
          END
        ELSE IF UserSetup."Vehicle Modify Authority" = UserSetup."Vehicle Modify Authority"::Limited THEN BEGIN
            AllowModifyRegNo := TRUE;
        END;
        //CALCFIELDS("Custom Clearance Memo No.","Insurance Memo No.","Insurance Policy No.");
        //AGNI UPG 2009
        /*ItemLedgerEntry.RESET; //Min
        ItemLedgerEntry.SETRANGE(VIN,VIN);
        ItemLedgerEntry.SETRANGE("Entry Type",ItemLedgerEntry."Entry Type"::Purchase);
        IF ItemLedgerEntry.FINDFIRST THEN BEGIN
          ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
          "Purchase Amount" := ItemLedgerEntry."Cost Amount (Actual)";
          PurchAmount := ItemLedgerEntry."Cost Amount (Actual)";
          END;
        
        //Amisha 5/4/21
        PurchInvLine.RESET;
        PurchInvLine.SETRANGE(VIN,Rec.VIN);
        IF PurchInvLine.FINDFIRST THEN BEGIN
         InterestStartDate := CALCDATE('<45D>', PurchInvLine."Posting Date");
         NextDate := InterestStartDate;
          IF WORKDATE >= NextDate THEN BEGIN
            SalesReceivablesSetup.GET;
             "Interest Amount" := (PurchAmount* SalesReceivablesSetup."Interest Percentage" *15)/100;
             //purchaseamout := "Interest Amount";
             NextDate := CALCDATE('<15D>' , NextDate);
             MESSAGE(FORMAT(WORKDATE));
             MESSAGE(FORMAT(NextDate));
                 // (P*R*T)/100
          END;
        END;
        
        SalesReceivablesSetup.GET;
        "Margin Amount" := "Purchase Amount" * (SalesReceivablesSetup."Margin Percentage"/100);
        */

    end;

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    trigger OnOpenPage()
    begin
        SetSerialNoVisible;
        //AGNI UPG 2009
        CommissionRead := FALSE;
        UserSetup.GET(USERID);
        IF UserSetup."Can See Vehicle Commission" THEN
          CommissionRead := TRUE;
        //AGNI UPG 2009

        //Amisha 5/13/2021
        CompanyInformation.GET;
        IF CompanyInformation."Agni Astha Company" THEN
          ShowAgniAsthaCompany := TRUE;

        IF UserSetup."Can Edit Margin Interest Rate" THEN
          EditWarantyInsuranceProvision:= TRUE;

        AllowModifyAll := TRUE;
    end;

    var
        ServiceLedgerEntry: Record "25006167";
        LookupMgt: Codeunit "25006003";
        ServOrdInfoPaneMgt: Codeunit "25006104";
        [InDataSet]
        VF25006800Visible: Boolean;
        [InDataSet]
        VF25006801Visible: Boolean;
        [InDataSet]
        VF25006802Visible: Boolean;
        [InDataSet]
        VF25006803Visible: Boolean;
        [InDataSet]
        VF25006804Visible: Boolean;
        [InDataSet]
        VF25006805Visible: Boolean;
        [InDataSet]
        VF25006806Visible: Boolean;
        [InDataSet]
        VF25006807Visible: Boolean;
        [InDataSet]
        VF25006808Visible: Boolean;
        [InDataSet]
        VF25006809Visible: Boolean;
        [InDataSet]
        VF25006810Visible: Boolean;
        [InDataSet]
        VF25006811Visible: Boolean;
        [InDataSet]
        VF25006812Visible: Boolean;
        [InDataSet]
        VF25006813Visible: Boolean;
        [InDataSet]
        VF25006814Visible: Boolean;
        [InDataSet]
        VF25006815Visible: Boolean;
        [InDataSet]
        VF25006816Visible: Boolean;
        [InDataSet]
        VF25006817Visible: Boolean;
        [InDataSet]
        VF25006818Visible: Boolean;
        [InDataSet]
        VF25006819Visible: Boolean;
        [InDataSet]
        VF25006820Visible: Boolean;
        [InDataSet]
        VF25006821Visible: Boolean;
        [InDataSet]
        VF25006822Visible: Boolean;
        [InDataSet]
        VF25006823Visible: Boolean;
        [InDataSet]
        VF25006824Visible: Boolean;
        [InDataSet]
        VF25006825Visible: Boolean;
        [InDataSet]
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;
        ServLedgerEntryExist: Boolean;
        SerialNoVisible: Boolean;
        UserSetup: Record "91";
        [InDataSet]
        AllowModifyAll: Boolean;
        [InDataSet]
        AllowModifyRegNo: Boolean;
        [InDataSet]
        CommissionRead: Boolean;
        PDIHdr: Record "33019851";
        VehDelChklist: Record "33019855";
        VehChklistTemp: Record "33019853";
        VehChklistHdr: Record "33019854";
        BookingChange: Record "33019857";
        ItemLedgerEntry: Record "32";
        PurchInvLine: Record "123";
        Vehicle: Record "25006005";
        InterestStartDate: Date;
        AmountAfterInterest: Decimal;
        SalesReceivablesSetup: Record "311";
        PurchAmount: Decimal;
        NextDate: Date;
        PurchaseAmount: Decimal;
        UpdateVehPrice: Report "50068";
                            ShowAgniAsthaCompany: Boolean;
                            CompanyInformation: Record "79";
                            EditWarantyInsuranceProvision: Boolean;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        VF25006800Visible := IsVFActive(25006800);
        VF25006801Visible := IsVFActive(25006801);
        VF25006802Visible := IsVFActive(25006802);
        VF25006803Visible := IsVFActive(25006803);
        VF25006804Visible := IsVFActive(25006804);
        VF25006805Visible := IsVFActive(25006805);
        VF25006806Visible := IsVFActive(25006806);
        VF25006807Visible := IsVFActive(25006807);
        VF25006808Visible := IsVFActive(25006808);
        VF25006809Visible := IsVFActive(25006809);
        VF25006810Visible := IsVFActive(25006810);
        VF25006811Visible := IsVFActive(25006811);
        VF25006812Visible := IsVFActive(25006812);
        VF25006813Visible := IsVFActive(25006813);
        VF25006814Visible := IsVFActive(25006814);
        VF25006815Visible := IsVFActive(25006815);
        VF25006816Visible := IsVFActive(25006816);
        VF25006817Visible := IsVFActive(25006817);
        VF25006818Visible := IsVFActive(25006818);
        VF25006819Visible := IsVFActive(25006819);
        VF25006820Visible := IsVFActive(25006820);
        VF25006821Visible := IsVFActive(25006821);
        VF25006822Visible := IsVFActive(25006822);
        VF25006823Visible := IsVFActive(25006823);
        VF25006824Visible := IsVFActive(25006824);
        VF25006825Visible := IsVFActive(25006825);
        VFRun1Visible := IsVFActive(FIELDNO(Kilometrage));
        VFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        VFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    local procedure SetSerialNoVisible()
    var
        DocumentNoVisibility: Codeunit "1400";
    begin
        SerialNoVisible := DocumentNoVisibility.VehicleSerialNoIsVisible("Serial No.");
    end;
}

