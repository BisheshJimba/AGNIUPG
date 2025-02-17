page 25006526 "Vehicle Opt. Setup"
{
    Caption = 'Vehicle Option Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006389;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Functionality Activated"; "Functionality Activated")
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

