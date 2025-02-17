page 25006843 "Dead Stock Setup"
{
    Caption = 'Dead Stock Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006743;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Min. Dead Stock Rate"; "Min. Dead Stock Rate")
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

