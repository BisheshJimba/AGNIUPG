page 25006214 "Service Ret. Order Subf. EDMS"
{
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to (copy Resource modifications from Page 25006184):
    //     OnAfterGetRecord()
    //     OnNewRecord
    //     OnInsertRecord
    //     Resources - OnValidate()
    //     Resources - OnDrillDown()
    // 
    // 14.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added fields "Sell-to Customer Bill %", "Sell-to Customer Bill Amount"
    // 
    // 09.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added page action:
    //     <Action5> Dimensions
    //   Added fields:
    //     ShortcutDimCode[3]..[8]
    //   Added code to:
    //     OnAfterGetRecord()
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Appl.-from Item Entry
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table25006146;
    SourceTableView = WHERE(Document Type=FILTER(Return Order));

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Type;Type)
                {

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {

                    trigger OnAssistEdit()
                    begin
                        NoAssistEdit
                    end;
                }
                field("HS Code";"HS Code")
                {
                    Editable = false;
                }
                field("Variant Code";"Variant Code")
                {
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Description;Description)
                {
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field("Bin Code";"Bin Code")
                {
                    Visible = false;
                }
                field(Reserve;Reserve)
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate;
                    end;
                }
                field("Job Type";"Job Type")
                {
                }
                field(Quantity;Quantity)
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    BlankZero = true;
                }
                field(Resources;Resources)
                {
                    Caption = 'Resources';

                    trigger OnDrillDown()
                    begin
                        // 12.05.2014 Elva Baltic P21 >>
                        // ServiceScheduleMgt.RelatedResourcesList("Document Type", "Document No.", Type, "Line No.", Resources);
                        CurrPage.SAVERECORD;
                        COMMIT;
                        RelatedResourcesList(Resources);
                        Resources := GetResourceTextFieldValue;
                        CurrPage.UPDATE;
                        // 12.05.2014 Elva Baltic P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        // 12.05.2014 Elva Baltic P21 >>
                        // ServiceScheduleMgt.SetRelatedResources("Document Type", "Document No.", Type, "Line No.", Resources, 0);
                        // Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "Document No.", Type, "Line No.", 0);

                        SetResourceTextFieldValue(Resources);
                        Resources := GetResourceTextFieldValue;
                        // 12.05.2014 Elva Baltic P21 <<
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    BlankZero = true;
                }
                field("Line Amount";"Line Amount")
                {
                    BlankZero = true;
                }
                field("Line Discount %";"Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    Visible = false;
                }
                field("Prepayment %";"Prepayment %")
                {
                    Visible = false;
                }
                field("Prepmt. Line Amount";"Prepmt. Line Amount")
                {
                    Visible = false;
                }
                field("Prepmt. Amt. Inv.";"Prepmt. Amt. Inv.")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Prepmt Amt to Deduct";"Prepmt Amt to Deduct")
                {
                    Visible = false;
                }
                field("Prepmt Amt Deducted";"Prepmt Amt Deducted")
                {
                    Visible = false;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field(ShortcutDimCode[3];ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3,ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode[4];ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4,ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode[5];ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5,ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode[6];ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6,ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode[7];ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7,ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode[8];ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8,ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Document No.";"Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tire Operation Type";"Tire Operation Type")
                {
                }
                field("Vehicle Axle Code";"Vehicle Axle Code")
                {
                }
                field("Tire Position Code";"Tire Position Code")
                {
                    DrillDown = true;
                    DrillDownPageID = "Vehicle Tire Positions";
                    Lookup = true;
                    LookupPageID = "Vehicle Tire Positions";
                }
                field("Tire Code";"Tire Code")
                {
                }
                field("New Vehicle Axle Code";"New Vehicle Axle Code")
                {
                    Visible = false;
                }
                field("New Tire Position Code";"New Tire Position Code")
                {
                    Visible = false;
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Minutes Per UoM";"Minutes Per UoM")
                {
                    Visible = false;
                }
                field("Quantity (Hours)";"Quantity (Hours)")
                {
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                }
                field("Qty. to Return";"Qty. to Return")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailability(2);
                        end;
                    }
                }
                action("Reservation Entries")
                {
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        _ShowReservationEntries;
                    end;
                }
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
                action("Select Item Substitution")
                {
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        ShowItemSub;
                    end;
                }
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
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';
                    Image = OrderPromising;

                    trigger OnAction()
                    begin
                        OrderPromisingLine;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Get Price")
                {
                    Caption = 'Get Price';
                    Ellipsis = true;
                    Image = Price;

                    trigger OnAction()
                    begin
                        ShowPrices
                    end;
                }
                action("Get Li&ne Discount")
                {
                    Caption = 'Get Li&ne Discount';
                    Ellipsis = true;
                    Image = LineDiscount;

                    trigger OnAction()
                    begin
                        ShowLineDisc
                    end;
                }
                action("E&xplode BOM")
                {
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin
                        ExplodeBOM;
                    end;
                }
                action("&Reserve")
                {
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        _ShowReservation;
                    end;
                }
                action("Order &Tracking")
                {
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        ShowTracking;
                    end;
                }
                action("<Action1905968604>")
                {
                    Caption = 'Nonstoc&k Items';
                    Image = NonStockItem;

                    trigger OnAction()
                    begin
                        ShowNonstockItems;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode);//29.10.2012 EDMS
        // Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "Document No.", Type, "Line No.", 0);   // 12.05.2014 Elva Baltic P21
        Resources := GetResourceTextFieldValue;                                                                         // 12.05.2014 Elva Baltic P21

        ShowShortcutDimCode(ShortcutDimCode);                       // 09.04.2014 Elva Baltic P21
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "99000832";
    begin
        /*
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          COMMIT;
          IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          ReserveSalesLine.DeleteLine(Rec);
        END;
        */

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetResourceTextFieldValue(Resources);                                                                           // 12.05.2014 Elva Baltic P21
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := xRec.Type;
        CLEAR(ShortcutDimCode);
        CLEAR(Resources);

        SetResourceTextFieldValue(Resources);                                                                           // 12.05.2014 Elva Baltic P21
    end;

    var
        ServiceHeader: Record "25006145";
        SalesPriceCalcMgt: Codeunit "7000";
        ShortcutDimCode: array [8] of Code[20];
        Text001: Label 'You can not use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        [InDataSet]
        Resources: Text[250];
        ServiceScheduleMgt: Codeunit "25006201";

    [Scope('Internal')]
    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Service-Disc. EDMS (Yes/No)",Rec);
    end;

    [Scope('Internal')]
    procedure CalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Service-Calc. Discount EDMS",Rec);
    end;

    [Scope('Internal')]
    procedure ExplodeBOM()
    var
        PurchOrder: Page "50";
    begin
        IF "Prepmt. Amt. Inv." <> 0 THEN
          ERROR(Text001);
        CODEUNIT.RUN(CODEUNIT::"Service-Explode BOM EDMS",Rec);
    end;

    [Scope('Internal')]
    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "38";
        PurchOrder: Page "50";
    begin
        TESTFIELD("Purchase Order No.");
        PurchHeader.SETRANGE("No.","Purchase Order No.");
        PurchOrder.SETTABLEVIEW(PurchHeader);
        PurchOrder.EDITABLE := FALSE;
        PurchOrder.RUN;
    end;

    [Scope('Internal')]
    procedure _ShowReservation()
    begin
        FIND;
        Rec.ShowReservation;
    end;

    [Scope('Internal')]
    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        Rec.ItemAvailability(AvailabilityType);
    end;

    [Scope('Internal')]
    procedure _ShowReservationEntries()
    begin
        Rec.ShowReservationEntries(TRUE);
    end;

    [Scope('Internal')]
    procedure ShowItemSub()
    begin
        Rec.ShowItemSub;
    end;

    [Scope('Internal')]
    procedure ShowNonstockItems()
    begin
        //Rec.ShowNonstock;
    end;

    [Scope('Internal')]
    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;

    [Scope('Internal')]
    procedure ShowTracking()
    var
        TrackingForm: Page "99000822";
    begin
        TrackingForm.SetServiceLine(Rec);
        TrackingForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure ItemChargeAssgnt()
    begin
        //Rec.ShowItemChargeAssgnt;
    end;

    [Scope('Internal')]
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    [Scope('Internal')]
    procedure ShowPrices()
    begin
        ServiceHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetDMSServLinePrice(ServiceHeader,Rec);
    end;

    [Scope('Internal')]
    procedure ShowLineDisc()
    begin
        ServiceHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetDMSServLineLineDisc(ServiceHeader,Rec);
    end;

    [Scope('Internal')]
    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "99000880" temporary;
    begin
        OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::Job);
        OrderPromisingLine.SETRANGE("Source ID","Document No.");
        OrderPromisingLine.SETRANGE("Source Line No.","Line No.");
        PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Type = Type::Item;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        //InsertExtendedText(FALSE);
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        IF (Reserve = Reserve::Always) AND
           ("Outstanding Qty. (Base)" <> 0) AND
           ("Location Code" <> xRec."Location Code")
        THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure ReserveOnAfterValidate()
    begin
        IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure QuantityOnAfterValidate()
    var
        UpdateIsDone: Boolean;
    begin
        IF Type = Type::Item THEN
          CASE Reserve OF
            Reserve::Always:
              BEGIN
                CurrPage.SAVERECORD;
                AutoReserve;
                CurrPage.UPDATE(FALSE);
                UpdateIsDone := TRUE;
              END;
            Reserve::Optional:
              IF (Quantity < xRec.Quantity) AND (xRec.Quantity > 0) THEN BEGIN
                CurrPage.SAVERECORD;
                CurrPage.UPDATE(FALSE);
                UpdateIsDone := TRUE;
              END;
          END;

        IF (Type = Type::Item) AND
           (Quantity <> xRec.Quantity) AND
           NOT UpdateIsDone
        THEN
          CurrPage.UPDATE(TRUE);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        IF Reserve = Reserve::Always THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END;
    end;

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var ServLine: Record "25006146")
    begin
        CurrPage.SETSELECTIONFILTER(ServLine);
    end;
}

