page 25006541 "Posted Sales Invoice Subf. V"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table113;

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
                field(ABC; ABC)
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
                field("Resources (Serv.)"; "Resources (Serv.)")
                {
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    Visible = false;
                }
                field("IC Partner Code"; "IC Partner Code")
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
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = ISVisible;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
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
                field("Forward Accountability Center"; "Forward Accountability Center")
                {
                }
                field("Forward Location Code"; "Forward Location Code")
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
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.PAGE.*/
                        _ShowLineComments;

                    end;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.PAGE.*/
                        _ShowItemTrackingLines;

                    end;
                }
                action("Item Shipment &Lines")
                {
                    Caption = 'Item Shipment &Lines';
                    Image = ShipmentLines;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.PAGE.*/
                        _ShowItemShipmentLines;

                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin

        UserSetup.GET(USERID);
        IF UserSetup."Can See Cost" THEN
            ISVisible := TRUE
        ELSE
            ISVisible := FALSE;
    end;

    var
        [InDataSet]
        ISVisible: Boolean;
        UserSetup: Record "91";

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
    procedure _ShowItemShipmentLines()
    begin
        IF NOT (Type IN [Type::Item, Type::"Charge (Item)"]) THEN
            TESTFIELD(Type);
        Rec.ShowItemShipmentLines;
    end;

    [Scope('Internal')]
    procedure ShowItemShipmentLines()
    begin
        IF NOT (Type IN [Type::Item, Type::"Charge (Item)"]) THEN
            TESTFIELD(Type);
        Rec.ShowItemShipmentLines;
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

