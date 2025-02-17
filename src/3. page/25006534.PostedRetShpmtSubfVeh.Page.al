page 25006534 "Posted Ret. Shpmt Subf.(Veh.)"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table6651;

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
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    BlankZero = true;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                }
                field("Return Qty. Shipped Not Invd."; "Return Qty. Shipped Not Invd.")
                {
                    Editable = false;
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
                    Enabled = true;
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
                action("&Undo Return Shipment")
                {
                    Caption = '&Undo Return Shipment';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6650. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnShptLines.FORM.*/
                        UndoReturnShipment;

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
                        //This functionality was copied from page #6650. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnShptLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6650. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnShptLines.FORM.*/
                        _ShowLineComments;

                    end;
                }
                action("Item Credit Memo &Lines")
                {
                    Caption = 'Item Credit Memo &Lines';
                    Image = CreditMemo;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #6650. Unsupported part was commented. Please check it.
                        /*CurrPage.ReturnShptLines.FORM.*/
                        _ShowItemPurchCrMemoLines;

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
    procedure UndoReturnShipment()
    var
        ReturnShptLine: Record "6651";
    begin
        ReturnShptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(ReturnShptLine);
        CODEUNIT.RUN(CODEUNIT::"Undo Return Shipment Line", ReturnShptLine);
    end;

    [Scope('Internal')]
    procedure _ShowItemPurchCrMemoLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemPurchCrMemoLines;
    end;

    [Scope('Internal')]
    procedure ShowItemPurchCrMemoLines()
    begin
        TESTFIELD(Type, Type::Item);
        Rec.ShowItemPurchCrMemoLines;
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

