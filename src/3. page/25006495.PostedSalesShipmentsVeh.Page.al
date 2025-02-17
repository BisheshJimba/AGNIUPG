page 25006495 "Posted Sales Shipments (Veh.)"
{
    Caption = 'Posted Sales Shipments';
    CardPageID = "Posted Sales Shipment";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Document';
    SourceTable = Table110;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    Visible = false;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    Visible = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    Visible = false;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    Visible = false;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Visible = false;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Order No."; "Order No.")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Visible = true;
                }
                field(LocationBeforeShipment; LocationBeforeShipment)
                {
                    Caption = 'Location Before Shipment';
                }
                field(ModelVersion; ModelVersion)
                {
                    Caption = 'Model Version';
                }
                field("User ID"; "User ID")
                {
                }
                field(VIN; VIN)
                {
                }
                field("No. Printed"; "No. Printed")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    Visible = false;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Bank LC No."; "Bank LC No.")
                {
                }
                field(SalesInvoiced; SalesInvoiced)
                {
                    Caption = 'Sales Invoiced';
                }
                field("Vehicle Delivered"; "Vehicle Delivered")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Shipment")
            {
                Caption = '&Shipment';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 396;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 67;
                                    RunPageLink = Document Type=CONST(Shipment),
                                  No.=FIELD(No.);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Track Package")
                {
                    Caption = '&Track Package';
                    Image = ServiceItemGroup;

                    trigger OnAction()
                    begin
                        StartTrackingSite;
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    /*
                    CurrPage.SETSELECTIONFILTER(SalesShptHeader);
                    SalesShptHeader.PrintRecords(TRUE);
                    */
                    SalesShptHeader.RESET;
                    SalesShptHeader.SETRANGE("No.","No.");
                    SalesShptHeader.SETRANGE("Document Profile","Document Profile");
                    REPORT.RUN(33020199,TRUE,TRUE,SalesShptHeader);

                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        SalesShptLine.RESET;
        SalesShptLine.SETRANGE("Document No.","No.");
        IF SalesShptLine.FINDFIRST THEN BEGIN
           ModelVersion := SalesShptLine."Model Version No.";
           SalesShptLine.CALCFIELDS(VIN);
           SalesShptLine.CALCFIELDS("Sales Invoiced");
           VIN := SalesShptLine.VIN;
           SalesInvoiced := SalesShptLine."Sales Invoiced";
        END;

        CLEAR(LocationBeforeShipment);
        ItemLedgEntry.RESET;
        //ItemLedgEntry.SETRANGE("Serial No.","Vehicle Serial No.");
        ItemLedgEntry.SETRANGE("Serial No.",SalesShptLine."Vehicle Serial No.");
        ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Purchase);
        ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Purchase Receipt");
        //ItemLedgEntry.SETFILTER("Location Code",'<>%1','INTRANSIT');
        //ItemLedgEntry.SETRANGE("Remaining Quantity",0);
        IF ItemLedgEntry.FINDFIRST THEN BEGIN
          LocationBeforeShipment := ItemLedgEntry."Location Code";
        END;
    end;

    trigger OnOpenPage()
    begin
        //EDMS>>
        FILTERGROUP(3);
        SETRANGE("Document Profile","Document Profile"::"Vehicles Trade");
        //EDMS<<
        FilterOnRecord;
    end;

    var
        SalesShptHeader: Record "110";
        VIN: Code[20];
        SalesShptLine: Record "111";
        ModelVersion: Code[20];
        SalesInvoiced: Boolean;
        LocationBeforeShipment: Code[20];
        ItemLedgEntry: Record "32";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;
}

