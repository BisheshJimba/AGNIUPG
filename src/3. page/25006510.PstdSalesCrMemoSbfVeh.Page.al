page 25006510 "Pstd Sales Cr.Memo Sbf.(Veh.)"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table115;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Type; Type)
                {
                }
                field("No."; "No.")
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
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                    Visible = true;
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
                field("Appl.-from Item Entry"; "Appl.-from Item Entry")
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
                        //This functionality was copied from page #134. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesCrMemoLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #134. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesCrMemoLines.FORM.*/
                        _ShowLineComments;

                    end;
                }
                action("Item Return Receipt &Lines")
                {
                    Caption = 'Item Return Receipt &Lines';
                    Image = ReturnReceipt;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #134. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesCrMemoLines.FORM.*/
                        _ShowItemReturnRcptLines;

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
    procedure _ShowItemReturnRcptLines()
    begin
        IF NOT (Type IN [Type::Item, Type::"Charge (Item)"]) THEN
            TESTFIELD(Type);
        Rec.ShowItemReturnRcptLines;
    end;

    [Scope('Internal')]
    procedure ShowItemReturnRcptLines()
    begin
        IF NOT (Type IN [Type::Item, Type::"Charge (Item)"]) THEN
            TESTFIELD(Type);
        Rec.ShowItemReturnRcptLines;
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

