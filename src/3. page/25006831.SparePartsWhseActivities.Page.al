page 25006831 "Spare Parts Whse Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006766;

    layout
    {
        area(content)
        {
            cuegroup("Outbound - Today")
            {
                Caption = 'Outbound - Today';
                field("Released Sales Orders - Today"; "Released Sales Orders - Today")
                {
                    DrillDown = true;
                    DrillDownPageID = "Sales Order List (SP)";
                }
                field("Posted Sales Shipments - Today"; "Posted Sales Shipments - Today")
                {
                    DrillDownPageID = "Posted Sales Shipments";
                }

                actions
                {
                    action("New Transfer Order")
                    {
                        Caption = 'New Transfer Order';
                        RunObject = Page 5740;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                }
            }
            cuegroup("Inbound - Today")
            {
                Caption = 'Inbound - Today';
                field("Expected Purch. Orders - Today"; "Expected Purch. Orders - Today")
                {
                    DrillDownPageID = "Purchase Order List SP";
                }
                field("Posted Purch. Receipts - Today"; "Posted Purch. Receipts - Today")
                {
                    DrillDownPageID = "Posted Purchase Receipts";
                }

                actions
                {
                    action("New Purchase Order")
                    {
                        Caption = 'New Purchase Order';
                        RunObject = Page 50;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                }
            }
            cuegroup(Internal)
            {
                Caption = 'Internal';
                field("Inventory Picks - Today"; "Inventory Picks - Today")
                {
                    DrillDownPageID = "Inventory Picks";
                }
                field("Inventory Put-aways - Today"; "Inventory Put-aways - Today")
                {
                    DrillDownPageID = "Inventory Put-aways";
                }

                actions
                {
                    action("New Inventory Pick")
                    {
                        Caption = 'New Inventory Pick';
                        RunObject = Page 7377;
                        RunPageMode = Create;
                    }
                    action("New Inventory Put-away")
                    {
                        Caption = 'New Inventory Put-away';
                        RunObject = Page 7375;
                        RunPageMode = Create;
                    }
                    action("Edit Item Reclassification Journal")
                    {
                        Caption = 'Edit Item Reclassification Journal';
                        RunObject = Page 393;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;

        SETRANGE("Date Filter", 0D, WORKDATE);
        SETRANGE("Date Filter2", WORKDATE, WORKDATE);
    end;

    var
        WhseWMSCue: Record "9051";
        LocationCode: Text[1024];
}

