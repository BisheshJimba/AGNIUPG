page 25006482 "Posted Purch. Rcpt. Subf.(Veh)"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table121;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Line Type"; "Line Type")
                {
                }
                field(Type; Type)
                {
                    Visible = false;
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
                field("No."; "No.")
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
                    Visible = false;
                }
                field("Vehicle Status Code"; "Vehicle Status Code")
                {
                    Visible = false;
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
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    BlankZero = true;
                }
                field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                    Visible = false;
                }
                field("Promised Receipt Date"; "Promised Receipt Date")
                {
                    Visible = false;
                }
                field("Planned Receipt Date"; "Planned Receipt Date")
                {
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time")
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
                action("Order &Tracking")
                {
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #136. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchReceiptLines.PAGE.*/
                        ShowTracking;

                    end;
                }
                action("&Undo Item Receipt")
                {
                    Caption = '&Undo Item Receipt';
                    Image = Receipt;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #136. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchReceiptLines.PAGE.*/
                        UndoReceiptLine;

                    end;
                }
                action("<Action1000000000>")
                {
                    Caption = '&Undo GL Receipt';

                    trigger OnAction()
                    begin
                        UndoGLReceiptLine;
                    end;
                }
                action("<Action1000000001>")
                {
                    Caption = '&Undo Item Charge Receipt';

                    trigger OnAction()
                    begin
                        UndoItemChargeReceiptLine;
                    end;
                }
                action("<Action1000000002>")
                {
                    Caption = '&Undo External Service Receipt';

                    trigger OnAction()
                    begin
                        UndoExternalServiceReceiptLine;
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
                        //This functionality was copied from page #136. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchReceiptLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #136. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchReceiptLines.PAGE.*/
                        _ShowLineComments;

                    end;
                }
                action("Item Invoice &Lines")
                {
                    Caption = 'Item Invoice &Lines';
                    Image = Invoice;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #136. Unsupported part was commented. Please check it.
                        /*CurrPage.PurchReceiptLines.PAGE.*/
                        _ShowItemPurchInvLines;

                    end;
                }
            }
        }
    }

    var
        UndoPurchaseReceiptLine: Codeunit "5813";

    [Scope('Internal')]
    procedure ShowTracking()
    var
        ItemLedgEntry: Record "32";
        TempItemLedgEntry: Record "32" temporary;
        TrackingForm: Page "99000822";
    begin
        TESTFIELD(Type, Type::Item);
        IF "Item Rcpt. Entry No." <> 0 THEN BEGIN
            ItemLedgEntry.GET("Item Rcpt. Entry No.");
            TrackingForm.SetItemLedgEntry(ItemLedgEntry);
        END ELSE
            TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
              DATABASE::"Purch. Rcpt. Line", 0, "Document No.", '', 0, "Line No.");

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
    procedure UndoReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        CODEUNIT.RUN(CODEUNIT::"Undo Purchase Receipt Line", PurchRcptLine);
    end;

    [Scope('Internal')]
    procedure _ShowItemPurchInvLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemPurchInvLines;
    end;

    [Scope('Internal')]
    procedure ShowItemPurchInvLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemPurchInvLines;
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

    [Scope('Internal')]
    procedure UndoGLReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        UndoPurchaseReceiptLine.UndoGLRcptLine(PurchRcptLine);
    end;

    [Scope('Internal')]
    procedure UndoItemChargeReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        UndoPurchaseReceiptLine.UndoItemChargeRcptLine(PurchRcptLine);
    end;

    [Scope('Internal')]
    procedure UndoExternalServiceReceiptLine()
    var
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(PurchRcptLine);
        UndoPurchaseReceiptLine.UndoExternalService(PurchRcptLine);
    end;
}

