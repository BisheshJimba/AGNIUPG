page 25006507 "Vehicle Purchaser Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006396;

    layout
    {
        area(content)
        {
            cuegroup("Pre-arrival Follow-up on Purchase Orders")
            {
                Caption = 'Pre-arrival Follow-up on Purchase Orders';
                field("To Send or Confirm"; "To Send or Confirm")
                {
                    DrillDownPageID = "Purchase Order List (Veh.)";
                }
                field("Upcoming Orders"; "Upcoming Orders")
                {
                    DrillDownPageID = "Purchase Order List (Veh.)";
                }

                actions
                {
                    action("New Purchase Quote")
                    {
                        Caption = 'New Purchase Quote';
                        RunObject = Page 49;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Vehicles Trade));
                    }
                    action("New Purchase Order")
                    {
                        Caption = 'New Purchase Order';
                        RunObject = Page 50;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Vehicles Trade));
                    }
                    action("Edit Purchase Journal")
                    {
                        Caption = 'Edit Purchase Journal';
                        RunObject = Page 254;
                    }
                }
            }
            cuegroup("Post Arrival Follow-up")
            {
                Caption = 'Post Arrival Follow-up';
                field("Outstanding Purchase Orders"; "Outstanding Purchase Orders")
                {
                    DrillDownPageID = "Purchase Order List (Veh.)";
                }
                field("Purchase Return Orders - All"; "Purchase Return Orders - All")
                {
                    DrillDownPageID = "Purch. Rtrn Order List (Veh.)";
                }

                actions
                {
                    action(Navigate)
                    {
                        Caption = 'Navigate';
                        Image = Navigate;
                        RunObject = Page 344;
                    }
                    action("New Purchase Return Order")
                    {
                        Caption = 'New Purchase Return Order';
                        RunObject = Page 6640;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Vehicles Trade));
                    }
                }
            }
            cuegroup("Purchase Orders - Authorize for Payment")
            {
                Caption = 'Purchase Orders - Authorize for Payment';
                field("Not Invoiced"; "Not Invoiced")
                {
                    DrillDownPageID = "Purchase Order List (Veh.)";
                }
                field("Partially Invoiced"; "Partially Invoiced")
                {
                    DrillDownPageID = "Purchase Order List (Veh.)";
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

        SETFILTER("Date Filter", '>=%1', WORKDATE);
    end;
}

