page 25006196 "Posted Serv. Order Subf. EDMS"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Resource Cost Amount"
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"

    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table25006150;

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
                field("Job Type"; "Job Type")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field(Resources; Resources)
                {
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
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Tire Operation Type"; "Tire Operation Type")
                {
                }
                field("Vehicle Axle Code"; "Vehicle Axle Code")
                {
                }
                field("Tire Position Code"; "Tire Position Code")
                {
                }
                field("New Vehicle Axle Code"; "New Vehicle Axle Code")
                {
                    Visible = false;
                }
                field("New Tire Position Code"; "New Tire Position Code")
                {
                    Visible = false;
                }
                field("Tire Code"; "Tire Code")
                {
                }
                field("Minutes Per UoM"; "Minutes Per UoM")
                {
                    Visible = false;
                }
                field("Quantity (Hours)"; "Quantity (Hours)")
                {
                    Visible = false;
                }
                field("Resource Cost Amount"; "Resource Cost Amount")
                {
                }
                field("Scheme Code"; "Scheme Code")
                {
                    Editable = false;
                }
                field("Membership No."; "Membership No.")
                {
                    Editable = false;
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
                        ShowDimensions;
                    end;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        _ShowItemTrackingLines;
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
    procedure _ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;

    [Scope('Internal')]
    procedure ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;
}

