page 25006505 "Veh. Salesperson Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006395;

    layout
    {
        area(content)
        {
            cuegroup("For Release")
            {
                Caption = 'For Release';
                field("Sales Quotes - Open"; "Sales Quotes - Open")
                {
                    DrillDownPageID = "Sales Quotes (Veh.)";
                }
                field("Sales Orders - Open"; "Sales Orders - Open")
                {
                    DrillDownPageID = "Sales Order List (Veh.)";
                }

                actions
                {
                    action("New Sales Quote")
                    {
                        Caption = 'New Sales Quote';
                        Image = Quote;
                        RunObject = Page 41;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Vehicles Trade));
                    }
                    action("New Sales Order")
                    {
                        Caption = 'New Sales Order';
                        RunObject = Page 42;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Vehicles Trade));
                    }
                }
            }
            cuegroup("Sales Orders Released Not Shipped")
            {
                Caption = 'Sales Orders Released Not Shipped';
                field("Ready to Ship"; "Ready to Ship")
                {
                    DrillDownPageID = "Sales Order List (Veh.)";
                }
                field("Partially Shipped"; "Partially Shipped")
                {
                    DrillDownPageID = "Sales Order List (Veh.)";
                }
                field(Delayed; Delayed)
                {
                    DrillDownPageID = "Sales Order List (Veh.)";
                }

                actions
                {
                    action(Navigate)
                    {
                        Caption = 'Navigate';
                        Image = Navigate;
                        RunObject = Page 344;
                    }
                }
            }
            cuegroup(Returns)
            {
                Caption = 'Returns';
                field("Sales Return Orders - All"; "Sales Return Orders - All")
                {
                    DrillDownPageID = "Sales Return Order List (Veh.)";
                }
                field("Sales Credit Memos - All"; "Sales Credit Memos - All")
                {
                    DrillDownPageID = "Sales Credit Memos (Veh.)";
                }

                actions
                {
                    action("New Sales Return Order")
                    {
                        Caption = 'New Sales Return Order';
                        RunObject = Page 6630;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Vehicles Trade));
                    }
                    action("New Sales Credit Memo")
                    {
                        Caption = 'New Sales Credit Memo';
                        RunObject = Page 44;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Vehicles Trade));
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

        SETRANGE("Date Filter", 0D, WORKDATE - 1);
        SETFILTER("Date Filter2", '>=%1', WORKDATE);
    end;
}

