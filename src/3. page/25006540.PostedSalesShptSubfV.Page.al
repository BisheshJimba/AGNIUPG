page 25006540 "Posted Sales Shpt. Subf. V"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table111;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Type; Type)
                {
                    Visible = false;
                }
                field("Line Type"; "Line Type")
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
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                }
                field("No."; "No.")
                {
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    BlankZero = true;
                }
                field("Qty. Shipped Not Invoiced"; "Qty. Shipped Not Invoiced")
                {
                    Editable = false;
                    Visible = false;
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
                }
                field("Planned Shipment Date"; "Planned Shipment Date")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Visible = true;
                }
                field("Shipping Time"; "Shipping Time")
                {
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Outbound Whse. Handling Time"; "Outbound Whse. Handling Time")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
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
                field(Correction; Correction)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Kilometrage; Kilometrage)
                {
                    Visible = false;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = false;
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Order Tra&cking")
                {
                    Caption = 'Order Tra&cking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #130. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesShipmLines.PAGE.*/
                        ShowTracking;

                    end;
                }
                action("&Undo Shipment")
                {
                    Caption = '&Undo Shipment';
                    Image = Shipment;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #130. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesShipmLines.PAGE.*/
                        UndoShipmentPosting;

                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #130. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesShipmLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #130. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesShipmLines.PAGE.*/
                        _ShowLineComments;

                    end;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #130. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesShipmLines.PAGE.*/
                        _ShowItemTrackingLines;

                    end;
                }
                action("Item Invoice &Lines")
                {
                    Caption = 'Item Invoice &Lines';
                    Image = Invoice;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #130. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesShipmLines.PAGE.*/
                        _ShowItemSalesInvLines;

                    end;
                }
            }
        }
    }

    [Scope('Internal')]
    procedure ShowTracking()
    var
        ItemLedgEntry: Record "32";
        TempItemLedgEntry: Record "32" temporary;
        TrackingForm: Page "99000822";
    begin
        TESTFIELD(Type, Type::Item);
        IF "Item Shpt. Entry No." <> 0 THEN BEGIN
            ItemLedgEntry.GET("Item Shpt. Entry No.");
            TrackingForm.SetItemLedgEntry(ItemLedgEntry);
        END ELSE
            TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
              DATABASE::"Sales Shipment Line", 0, "Document No.", '', 0, "Line No.");

        TrackingForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure _ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;

    [Scope('Internal')]
    procedure ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;

    [Scope('Internal')]
    procedure UndoShipmentPosting()
    var
        SalesShptLine: Record "111";
    begin
        SalesShptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(SalesShptLine);
        CODEUNIT.RUN(CODEUNIT::"Undo Sales Shipment Line", SalesShptLine);
    end;

    [Scope('Internal')]
    procedure _ShowItemSalesInvLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemSalesInvLines;
    end;

    [Scope('Internal')]
    procedure ShowItemSalesInvLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemSalesInvLines;
    end;

    [Scope('Internal')]
    procedure _ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;

    [Scope('Internal')]
    procedure ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;
}

