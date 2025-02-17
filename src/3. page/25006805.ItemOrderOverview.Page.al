page 25006805 "Item Order Overview"
{
    // 10.06.2014 Elva Baltic P8 #F0003 EDMS7.10
    //   * ADDED "Quantity Shipped"

    Caption = 'Item Order Overview';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SaveValues = true;
    SourceTable = Table25006730;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocProfileFilter; DocProfileFilter)
                {
                    Caption = 'Document Profile';
                    OptionCaption = ' ,Spare Part Sale,Vehicle Service,Transfer Order';

                    trigger OnValidate()
                    begin
                        SetSourceType(DocProfileFilter);
                    end;
                }
                field(DocNoFilter; DocNoFilter)
                {
                    Caption = 'Document No.';

                    trigger OnValidate()
                    begin
                        SetDocNo(DocNoFilter);
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    Caption = 'Date Filter';
                    OptionCaption = ' ,Spare Part Sale,Vehicle Service,Transfer Order';

                    trigger OnValidate()
                    var
                        DataBuffer: Record "25006004";
                    begin
                        DataBuffer.RESET;
                        DataBuffer.SETFILTER("Date Field 1", DateFilter);
                        DateFilter := DataBuffer.GETFILTER("Date Field 1");
                    end;
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field(SellToCustomerFilter; SellToCustomerFilter)
                {
                    Caption = 'Sell-to Customer No.';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin
                        SellToCustomerFilterOnAfterVal;
                    end;
                }
                field(BillToCustomerFilter; BillToCustomerFilter)
                {
                    Caption = 'Bill-to Customer No.';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin
                        BillToCustomerFilterOnAfterVal;
                    end;
                }
            }
            group(Item)
            {
                Caption = 'Item';
                field(ItemNoFilter; ItemNoFilter)
                {
                    Caption = 'Item No.';
                    TableRelation = Item;
                }
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
                field(VehicleFilter; VehSerialNoFilter)
                {
                    Caption = 'Vehicle Serial No.';
                    Editable = VehicleFilterEditable;
                    TableRelation = Vehicle;

                    trigger OnValidate()
                    begin
                        VehSerialNoFilterOnAfterValida;
                    end;
                }
                field(VehicleFilter1; VINNumber)
                {
                    Caption = 'VIN';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        VINNumberOnAfterValidate;
                    end;
                }
            }
            repeater()
            {
                Editable = false;
                field(ItemOrderOverviewMgt.GetSourceDescription(Rec);
                    ItemOrderOverviewMgt.GetSourceDescription(Rec))
                {
                    Caption = 'Source Description';

                    trigger OnDrillDown()
                    var
                        ReservEntry: Record "337";
                    begin
                        ReservEntry.RESET;
                        ReservEntry.SETCURRENTKEY("Source ID");
                        ReservEntry.SETRANGE("Source ID", "Document No.");
                        ReservEntry.SETRANGE("Source Type", "Document Profile");
                        ReservEntry.SETRANGE("Source Subtype", "Document Type");
                        ReservEntry.SETRANGE("Source Ref. No.", "Line No.");

                        PAGE.RUNMODAL(PAGE::"Reservation Entries", ReservEntry);
                    end;
                }
                field(ItemOrderOverviewMgt.GetSourceDescription2(Rec);
                    ItemOrderOverviewMgt.GetSourceDescription2(Rec))
                {
                    Caption = '2nd Level Source Description';

                    trigger OnDrillDown()
                    var
                        ReservationEntry: Record "337";
                        ReservationEntry2: Record "337";
                        ReservationEntry3: Record "337";
                        ReservationEntry4: Record "337";
                    begin
                        ReservationEntry.RESET;
                        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ReservationEntry.SETRANGE("Source ID", "Document No.");
                        ReservationEntry.SETRANGE("Source Ref. No.", "Line No.");
                        ReservationEntry.SETRANGE("Source Type", "Document Profile");
                        ReservationEntry.SETRANGE("Source Subtype", "Document Type");
                        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                        IF ReservationEntry.FINDFIRST THEN
                            REPEAT
                                IF ReservationEntry2.GET(ReservationEntry."Entry No.", TRUE) THEN BEGIN
                                    IF ReservationEntry2."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
                                        ReservationEntry3.RESET;
                                        ReservationEntry3.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                                        ReservationEntry3.SETRANGE("Source ID", ReservationEntry2."Source ID");
                                        ReservationEntry3.SETRANGE("Source Ref. No.", ReservationEntry2."Source Ref. No.");
                                        ReservationEntry3.SETRANGE("Source Type", ReservationEntry2."Source Type");
                                        ReservationEntry3.SETRANGE("Reservation Status", ReservationEntry3."Reservation Status"::Reservation);
                                        ReservationEntry3.SETRANGE(Positive, FALSE);
                                        IF ReservationEntry3.FINDFIRST THEN
                                            REPEAT
                                                ReservationEntry4.GET(ReservationEntry3."Entry No.", ReservationEntry3.Positive);
                                                ReservationEntry4.MARK(TRUE);
                                            UNTIL ReservationEntry3.NEXT = 0;
                                    END;
                                END;
                            UNTIL ReservationEntry.NEXT = 0;

                        ReservationEntry4.MARKEDONLY(TRUE);
                        PAGE.RUNMODAL(PAGE::"Reservation Entries", ReservationEntry4);
                    end;
                }
                field(ItemOrderOverviewMgt.CreateText("Document Profile");
                    ItemOrderOverviewMgt.CreateText("Document Profile"))
                {
                    Caption = 'Document Profile';
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                    Style = StandardAccent;
                    StyleExpr = StatusMark;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                }
                field("Reserved Qty. (Base)"; "Reserved Qty. (Base)")
                {
                    Visible = false;
                }
                field("Planned Avail. Date"; "Planned Avail. Date")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                    Visible = false;
                }
                field("Planned Delivery Date"; "Planned Delivery Date")
                {
                    Visible = false;
                }
                field("Planned Shipment Date"; "Planned Shipment Date")
                {
                    Visible = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Fi&nd")
            {
                Caption = 'Fi&nd';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FindRec
                end;
            }
            action("&Show")
            {
                Caption = '&Show';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowRec;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StatusMark := FALSE;
        IF IOOSetup."Highlight Statuses" THEN
            IF ItemOrderOverviewMgt.GetSourceDescription(Rec) = '' THEN
                StatusMark := TRUE;
    end;

    trigger OnInit()
    begin
        VehicleFilterEditable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        IOOSetup.GET;
        SetFilters;
    end;

    var
        ItemOrderOverviewMgt: Codeunit "25006500";
        SellToCustomerFilter: Code[20];
        BillToCustomerFilter: Code[20];
        ItemNoFilter: Code[20];
        VehSerialNoFilter: Code[20];
        VehSerialNoFilter2: Code[20];
        VINNumber: Code[20];
        DocNoFilter: Text[250];
        DocNoFilter2: Text[250];
        DateFilter: Text[100];
        DocProfileFilter: Option " ","Spare Part Sale","Vehicle Service","Transfer Order";
        DocProfileFilter2: Option " ","Spare Part Sale","Vehicle Service","Transfer Order";
        [InDataSet]
        VehicleFilterEditable: Boolean;
        [InDataSet]
        StatusMark: Boolean;
        IOOSetup: Record "25006737";

    [Scope('Internal')]
    procedure FindRec()
    begin
        ItemOrderOverviewMgt.FindRec(Rec, DocProfileFilter, DocNoFilter, SellToCustomerFilter,
                                     BillToCustomerFilter, ItemNoFilter, VehSerialNoFilter, DateFilter);
    end;

    local procedure SetDocNo(DocNo: Text[250])
    begin
        SETFILTER("Document No.", DocNo);
        DocNoFilter := GETFILTER("Document No.");
        ClearCustomerInformation;
    end;

    [Scope('Internal')]
    procedure ClearCustomerInformation()
    begin
        SellToCustomerFilter := '';
        BillToCustomerFilter := '';
    end;

    [Scope('Internal')]
    procedure ClearDocumentInformation()
    begin
        SETFILTER("Document No.", '');
        DocNoFilter := GETFILTER("Document No.");
    end;

    [Scope('Internal')]
    procedure GetVIN()
    var
        Vehicle: Record "25006005";
    begin
        IF Vehicle.GET(VehSerialNoFilter) THEN
            VINNumber := Vehicle.VIN
        ELSE
            VINNumber := '';
    end;

    [Scope('Internal')]
    procedure ShowRec()
    begin
        ItemOrderOverviewMgt.ShowRec(Rec);
    end;

    [Scope('Internal')]
    procedure GetRec(var ItemOrderEntry: Record "25006730")
    begin
        IF ItemOrderEntry.FINDFIRST THEN
            REPEAT
                Rec := ItemOrderEntry;
                INSERT;
            UNTIL ItemOrderEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SetSourceType(DocProfileFilter1: Option " ",Sale,Service)
    begin
        DocProfileFilter := DocProfileFilter1;

        IF DocProfileFilter = DocProfileFilter::"Spare Part Sale" THEN BEGIN
            VehSerialNoFilter := '';
            VINNumber := '';
            VehicleFilterEditable := FALSE;
        END ELSE
            VehicleFilterEditable := TRUE;
    end;

    [Scope('Internal')]
    procedure SetDocumentFilter(DocNoFilter1: Text[30])
    begin
        DocNoFilter2 := DocNoFilter1;
    end;

    [Scope('Internal')]
    procedure SetVehicleSerialNo(VehSerialNo: Code[20])
    begin
        VehSerialNoFilter2 := VehSerialNo;
    end;

    [Scope('Internal')]
    procedure SetSourceType2(DocProfileFilter1: Option " ",Sale,Service)
    begin
        DocProfileFilter2 := DocProfileFilter1;
    end;

    [Scope('Internal')]
    procedure SetFilters()
    begin
        IF DocProfileFilter2 > 0 THEN
            SetSourceType(DocProfileFilter2);

        IF DocNoFilter2 <> '' THEN BEGIN
            DocNoFilter := DocNoFilter2;
            ClearCustomerInformation;
        END;

        IF VehSerialNoFilter2 <> '' THEN BEGIN
            VehSerialNoFilter := VehSerialNoFilter2;
            GetVIN;
        END;
    end;

    local procedure BillToCustomerFilterOnAfterVal()
    begin
        ClearDocumentInformation
    end;

    local procedure SellToCustomerFilterOnAfterVal()
    begin
        ClearDocumentInformation
    end;

    local procedure VehSerialNoFilterOnAfterValida()
    begin
        DocProfileFilter := DocProfileFilter::"Vehicle Service";
        GetVIN
    end;

    local procedure VINNumberOnAfterValidate()
    begin
        DocProfileFilter := DocProfileFilter::"Vehicle Service";
    end;
}

