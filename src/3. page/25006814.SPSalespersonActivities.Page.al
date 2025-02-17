page 25006814 "SP Salesperson Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006764;

    layout
    {
        area(content)
        {
            cuegroup("For Release")
            {
                Caption = 'For Release';
                field("Sales Quotes - Open"; "Sales Quotes - Open")
                {
                    DrillDownPageID = "Sales Quotes (SP)";
                }
                field("Sales Orders - Open"; "Sales Orders - Open")
                {
                    DrillDownPageID = "Sales Order List (SP)";
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
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                    action("New Sales Order")
                    {
                        Caption = 'New Sales Order';
                        RunObject = Page 42;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                }
            }
            cuegroup("Sales Orders Released Not Shipped")
            {
                Caption = 'Sales Orders Released Not Shipped';
                field("Ready to Ship"; "Ready to Ship")
                {
                    DrillDownPageID = "Sales Order List (SP)";
                }
                field("Partially Shipped"; "Partially Shipped")
                {
                    DrillDownPageID = "Sales Order List (SP)";
                }
                field(Delayed; Delayed)
                {
                    DrillDownPageID = "Sales Order List (SP)";
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
                    DrillDownPageID = "Sales Return Order List (SP)";
                }
                field("Sales Credit Memos - All"; "Sales Credit Memos - All")
                {
                    DrillDownPageID = "Sales Credit Memos (SP)";
                }

                actions
                {
                    action("New Sales Return Order")
                    {
                        Caption = 'New Sales Return Order';
                        RunObject = Page 6630;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                    action("New Sales Credit Memo")
                    {
                        Caption = 'New Sales Credit Memo';
                        RunObject = Page 44;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                }
            }
            cuegroup("Transfer Orders")
            {
                Caption = 'Transfer Orders';
                Visible = false;
                field("Receive from Branch"; "Receive from Branch")
                {
                    Caption = 'From Branch';
                    DrillDownPageID = "Transfer List";
                }
                field("Receive from Service"; "Receive from Service")
                {
                    Caption = 'From Service';
                    DrillDownPageID = "Transfer List";
                }
                field("Pending Shipment (Service)"; "Pending Shipment (Service)")
                {
                    Caption = 'To Service';
                    DrillDownPageID = "Transfer List";
                }
                field("Pending Shipment (Branch)"; "Pending Shipment (Branch)")
                {
                    Caption = 'To Branch';
                    DrillDownPageID = "Transfer List";
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

        IF UserSetup.GET(USERID) THEN
            SETFILTER("Location Filter", UserSetup."Default Location");
    end;

    var
        UserSetup: Record "91";
}

