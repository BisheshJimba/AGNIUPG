page 25006815 "SP Purchaser Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006765;

    layout
    {
        area(content)
        {
            cuegroup("Pre-arrival Follow-up on Purchase Orders")
            {
                Caption = 'Pre-arrival Follow-up on Purchase Orders';
                field("To Send or Confirm"; "To Send or Confirm")
                {
                    DrillDownPageID = "Purchase Order List SP";
                }
                field("Upcoming Orders"; "Upcoming Orders")
                {
                    DrillDownPageID = "Purchase Order List SP";
                }

                actions
                {
                    action("New Purchase Quote")
                    {
                        Caption = 'New Purchase Quote';
                        RunObject = Page 49;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                    action("New Purchase Order")
                    {
                        Caption = 'New Purchase Order';
                        RunObject = Page 50;
                        RunPageMode = Create;
                        RunPageView = SORTING(Document Profile)
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
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
                    DrillDownPageID = "Purchase Order List SP";
                }
                field("Purchase Return Orders - All"; "Purchase Return Orders - All")
                {
                    DrillDownPageID = "Purchase Return Order List SP";
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
                                      WHERE(Document Profile=CONST(Spare Parts Trade));
                    }
                }
            }
            cuegroup("Purchase Orders - Authorize for Payment")
            {
                Caption = 'Purchase Orders - Authorize for Payment';
                field("Not Invoiced"; "Not Invoiced")
                {
                    DrillDownPageID = "Purchase Order List SP";
                }
                field("Partially Invoiced"; "Partially Invoiced")
                {
                    DrillDownPageID = "Purchase Order List SP";
                }
            }
            cuegroup("Transfer Orders")
            {
                Caption = 'Transfer Orders';
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

        SETFILTER("Date Filter", '>=%1', WORKDATE);

        IF UserSetup.GET(USERID) THEN
            SETFILTER("Location Filter", UserSetup."Default Location");
    end;

    var
        UserSetup: Record "91";
}

