page 25006199 "Service Quote Subform EDMS"
{
    // 30.05.2016 EB.P7 #PAR28
    //   Added field:
    //     25006998Has Replacement
    //   Action added Apply Replacement
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added Fields ShortcutDimCode[3]..[8]
    //   Added Code to
    //     OnAfterGetRecord()
    // 
    // 28.03.2014 Elva baltic P18 #RX032 MMG7.00
    //   Added field "Unit Price Excluding VAT"
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Field "Resources" set VISIBLE=FALSE
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
    SourceTableView = WHERE(Document Type=FILTER(Quote));

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
                field("Has Replacement";"Has Replacement")
                {
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
                field("Description 2";"Description 2")
                {
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    Visible = false;

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
                field(Quantity;Quantity)
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                        CurrPage.UPDATE;
                    end;
                }
                field("Standard Time";"Standard Time")
                {
                    Visible = false;
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
                    Visible = false;

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
                field("Ordering Price Type Code";"Ordering Price Type Code")
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
                field("Minutes Per UoM";"Minutes Per UoM")
                {
                    Visible = false;
                }
                field("Customer Price Group";"Customer Price Group")
                {
                }
                field("Quantity (Hours)";"Quantity (Hours)")
                {
                    Visible = false;
                }
            }
            group()
            {
                group()
                {
                    field("Total Amount Excl. VAT";TotalServiceHeader.Amount)
                    {
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                    }
                    field("Total VAT Amount";VATAmount)
                    {
                        Caption = 'Total VAT';
                        Editable = false;
                    }
                    field("Total Amount Incl. VAT";TotalServiceHeader."Amount Including VAT")
                    {
                        Caption = 'Total Amount Incl. VAT';
                        DrillDown = false;
                        Editable = false;
                    }
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
                action("<Action1905968604>")
                {
                    Caption = 'Nonstoc&k Items';
                    Image = NonStockItem;

                    trigger OnAction()
                    begin
                        ShowNonstockItems;
                    end;
                }
                action("<Action1101904000>")
                {
                    Caption = 'Register Lost Sale';
                    Image = Register;

                    trigger OnAction()
                    begin
                        RegLostSales
                    end;
                }
            }
            action("Apply Replacement")
            {
                Caption = 'Apply Replacement';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "25006513";
                begin
                    //10.05.2016 EB.P7 #PAR_28 >>
                    ItemSubstSync.ReplaceServiceLineItemNo(Rec);
                    //10.05.2016 EB.P7 #PAR_28 <<
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculateServiceHeaderTotals(TotalServiceHeader,VATAmount,Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := GetResourceTextFieldValue;

        ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "99000832";
    begin
        LostSalesMgt.OnServLineDelete(Rec);
        /*
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          COMMIT;
          IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          ReserveSalesLine.DeleteLine(Rec);
        END;
        */
        
        DocumentTotals.CalculateServiceHeaderTotals(TotalServiceHeader,VATAmount,Rec);

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
        ShortcutDimCode: array [8] of Code[20];
        Text001: Label 'You can not use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        LostSalesMgt: Codeunit "25006504";
        [InDataSet]
        Resources: Text[250];
        TotalServiceHeader: Record "25006145";
        VATAmount: Decimal;
        DocumentTotals: Codeunit "25006018";

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

