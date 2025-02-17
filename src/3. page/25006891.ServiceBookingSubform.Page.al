page 25006891 "Service Booking Subform"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Res. Cost Amount Finished"
    //     "Res. Cost Amount Remaining"
    //     "Res. Cost Amount Total"
    // 
    // 13.05.2014 Elva Baltic P7 # MMG7.00
    //   * New field added "Amount Enter In Line No."
    // 
    // 30.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Commented code on triggers (don't need autoreserve):
    //     Location Code - OnValidate()
    //     Unit of Measure Code - OnValidate()
    //     Reserve - OnValidate()
    // 
    // 22.04.2014 Elva Baltic P7 # MMG7.00
    //   * New field added "Amount Enter In Line No."
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added Fields ShortcutDimCode[3]..[8]
    //   BlankZero property for field "Transfered Quantity"
    //   Added Code to
    //     OnAfterGetRecord()
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     OnDeleteRecord()
    // 
    // 28.03.2014 Elva baltic P18 #RX032 MMG7.00
    //   Added field "Unit Price Excluding VAT"
    // 
    // 22.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Visible=TRUE set for fields:
    //    - Standard Time
    //    - Transfered Quantity
    // 
    // 21.03.2014 Elva Baltic P7 #RX018 MMG7.00
    //   * Field "Print Item In Order" added
    // 
    // 18.03.2014 Elva Baltic P8 #S0006 MMG7.00
    //   * Added field: Symptom Code
    // 
    // 11.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed DecimalPlaces property to 0:5 for:
    //     Transfered Quantity
    //     Reserved Qty. on Warehouse
    //   Changed ReservedOnWarehouse Control StyleExpr property
    //   Added code to:
    //     OnAfterGetRecord()
    //   Commented code on trigger (don't need autoreserve):
    //     Quantity - OnValidate()
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 2012.04.02 EDMS P8
    //   * Added column Resources

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table25006146;
    SourceTableView = WHERE(Document Type=FILTER(Booking));

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
                field("External Serv. Tracking No.";"External Serv. Tracking No.")
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
                        // LocationCodeOnAfterValidate;                                     // 30.04.2014 Elva Baltic P21
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
                        // ReserveOnAfterValidate;                         // 30.04.2014 Elva Baltic P21
                    end;
                }
                field(Quantity;Quantity)
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        // QuantityOnAfterValidate;                        // 11.03.2014 Elva Baltic P21
                    end;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Transfered Quantity";CalcTransferedQuantity)
                {
                    BlankZero = true;
                    Caption = 'Transfered Quantity';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ShowTransferedQuantity
                    end;
                }
                field(ReservedOnWarehouse;CalcOutboundTransferRes)
                {
                    Caption = 'Reserved Qty. on Warehouse';
                    DecimalPlaces = 0:5;
                    StyleExpr = StyleTxt;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowOutboundTransferRes
                    end;
                }
                field(FullyReservedToInventory;FullyReservedToInventory)
                {
                    Caption = 'Fully Reserved To Inventory';
                    Visible = false;
                }
                field("Qty. to Return";"Qty. to Return")
                {
                    Visible = false;
                }
                field("Standard Time";"Standard Time")
                {
                }
                field("Finished Quantity (Hours)";"Finished Quantity (Hours)")
                {
                    Visible = false;
                }
                field("Remaining Quantity (Hours)";"Remaining Quantity (Hours)")
                {
                    Visible = false;
                }
                field(Resources;Resources)
                {
                    Caption = 'Resources';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SAVERECORD;
                        COMMIT;
                        RelatedResourcesList(Resources);
                        Resources := GetResourceTextFieldValue;
                        CurrPage.UPDATE;
                    end;

                    trigger OnValidate()
                    begin
                        SetResourceTextFieldValue(Resources);
                        Resources := GetResourceTextFieldValue;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        // UnitofMeasureCodeOnAfterValida;                                  // 30.04.2014 Elva Baltic P21
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
                field("Ordering Price Type Code";"Ordering Price Type Code")
                {
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
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
                field("Line Amount";"Line Amount")
                {
                    BlankZero = true;
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
                    Visible = false;
                }
                field("Vehicle Axle Code";"Vehicle Axle Code")
                {
                    Visible = false;
                }
                field("Tire Position Code";"Tire Position Code")
                {
                    DrillDown = true;
                    DrillDownPageID = "Vehicle Tire Positions";
                    Lookup = true;
                    LookupPageID = "Vehicle Tire Positions";
                    Visible = false;
                }
                field("Tire Code";"Tire Code")
                {
                    Visible = false;
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
                field(Status;Status)
                {
                    Visible = false;
                }
                field("Plan No.";"Plan No.")
                {
                    Visible = false;
                }
                field("Plan Stage Recurrence";"Plan Stage Recurrence")
                {
                    Visible = false;
                }
                field("Plan Stage Code";"Plan Stage Code")
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
                field("Purchasing Code";"Purchasing Code")
                {
                    Visible = false;
                }
                field("Special Order";"Special Order")
                {
                    Visible = false;
                }
                field("Symptom Code";"Symptom Code")
                {
                    Visible = false;
                }
                field("Planned Service Date";"Planned Service Date")
                {
                }
                field("Attached to Line No.";"Attached to Line No.")
                {
                    Visible = false;
                }
                field("Res. Cost Amount Finished";"Res. Cost Amount Finished")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Res. Cost Amount Remaining";"Res. Cost Amount Remaining")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Res. Cost Amount Total";"Res. Cost Amount Total")
                {
                    Editable = false;
                    Visible = false;
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
                action(Resources)
                {
                    Caption = 'Resources';
                    Image = CalculateRemainingUsage;

                    trigger OnAction()
                    begin
                        RelatedResourcesList(Resources);
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
                action("<Action1101904001>")
                {
                    Caption = 'Register Lost Sale';
                    Image = Register;

                    trigger OnAction()
                    begin
                        RegLostSales
                    end;
                }
                separator()
                {
                }
                action("<Action1101904002>")
                {
                    Caption = 'Move Lines';
                    Image = MoveUp;

                    trigger OnAction()
                    var
                        ServiceLine: Record "25006146";
                    begin
                        CurrPage.SETSELECTIONFILTER(ServiceLine);
                        MoveLines(ServiceLine);
                    end;
                }
                action("<Action1101904003>")
                {
                    Caption = 'Split Line';
                    Image = Splitlines;

                    trigger OnAction()
                    var
                        ServiceLine: Record "25006146";
                    begin
                        CurrPage.SETSELECTIONFILTER(ServiceLine);
                        SplitLine(ServiceLine);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode); //29.10.2012 EDMS
        Resources := GetResourceTextFieldValue;

        StyleTxt := GetReservationColor;                                  // 11.03.2014 Elva Baltic P21

        ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "99000832";
    begin
        CheckReservationCancelation;
        LostSalesMgt.OnServLineDelete(Rec);

        DeleteAssignedTransfLine;                                         // 28.03.2014 Elva Baltic P21
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetResourceTextFieldValue(Resources);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := xRec.Type;
        CLEAR(ShortcutDimCode);

        IF "Document No." <> '' THEN BEGIN
          ServiceHeader.GET("Document Type","Document No.");
          "Make Code" := ServiceHeader."Make Code";
        END;
        CLEAR(Resources);
        SetResourceTextFieldValue(Resources);
    end;

    var
        ServiceHeader: Record "25006145";
        SalesPriceCalcMgt: Codeunit "7000";
        PurchOrder: Page "50";
                        ShortcutDimCode: array [8] of Code[20];
                        Text001: Label 'You can not use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        LostSalesMgt: Codeunit "25006504";
        [InDataSet]
        Resources: Text;
        StyleTxt: Text[30];

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
    begin
        IF "Prepmt. Amt. Inv." <> 0 THEN
          ERROR(Text001);
        CODEUNIT.RUN(CODEUNIT::"Service-Explode BOM EDMS",Rec);
    end;

    [Scope('Internal')]
    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "38";
    begin
        TESTFIELD("Purchase Order No.");
        PurchHeader.SETRANGE("No.","Purchase Order No.");
        PurchOrder.SETTABLEVIEW(PurchHeader);
        PurchOrder.EDITABLE := FALSE;
        PurchOrder.RUN;
    end;

    [Scope('Internal')]
    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "38";
        PurchOrder: Page "50";
    begin
        TESTFIELD("Special Order Purchase No.");
        PurchHeader.SETRANGE("No.","Special Order Purchase No.");
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
    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure ShowNonstockItems()
    begin
        Rec.ShowNonstock;
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
        OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::"Service Order EDMS");
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
        ServLine.RESET;
        //CurrPage.SETSELECTIONFILTER(ServLine); it function work differently than in Nav2009
        IF FINDFIRST THEN
          REPEAT
            IF Type = Type::Item THEN BEGIN
              ServLine.GET("Document Type", "Document No.", "Line No.");
              ServLine.MARK(TRUE);
            END;
          UNTIL NEXT = 0;
        ServLine.MARKEDONLY(TRUE);
    end;
}

