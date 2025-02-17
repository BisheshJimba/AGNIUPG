page 25006806 "Item Order Overview Setup"
{
    Caption = 'Item Order Overview Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006737;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Highlight Statuses"; "Highlight Statuses")
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

