page 25006545 "Posted Return Receipt Subf. V"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table6661;

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
                field("Return Qty. Rcd. Not Invd."; "Return Qty. Rcd. Not Invd.")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Job No."; "Job No.")
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
                action("&Undo Return Receipt")
                {
                    Caption = '&Undo Return Receipt';
                    Image = ReturnReceipt;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        UndoReturnReceipt;

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
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        _ShowLineComments;

                    end;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        _ShowItemTrackingLines;

                    end;
                }
                action("Item Credit Memo &Lines")
                {
                    Caption = 'Item Credit Memo &Lines';
                    Image = CreditMemo;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6660. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnRcptLines.FORM.*/
                        _ShowItemSalesCrMemoLines;

                    end;
                }
            }
        }
    }

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
    procedure UndoReturnReceipt()
    var
        ReturnRcptLine: Record "6661";
    begin
        ReturnRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(ReturnRcptLine);
        CODEUNIT.RUN(CODEUNIT::"Undo Return Receipt Line", ReturnRcptLine);
    end;

    [Scope('Internal')]
    procedure _ShowItemSalesCrMemoLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemSalesCrMemoLines;
    end;

    [Scope('Internal')]
    procedure ShowItemSalesCrMemoLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemSalesCrMemoLines;
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

