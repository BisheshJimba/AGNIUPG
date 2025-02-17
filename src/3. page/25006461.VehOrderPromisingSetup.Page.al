page 25006461 "Veh. Order Promising Setup"
{
    Caption = 'Veh. Order Promising Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006394;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Order Promising Nos."; "Order Promising Nos.")
                {
                }
                field("Order Promising Template"; "Order Promising Template")
                {
                }
                field("Order Promising Worksheet"; "Order Promising Worksheet")
                {
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
    end;
}

