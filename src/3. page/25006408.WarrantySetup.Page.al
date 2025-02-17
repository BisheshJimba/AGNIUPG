page 25006408 "Warranty Setup"
{
    Caption = 'Warranty Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006408;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Warranty Document Nos."; "Warranty Document Nos.")
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

