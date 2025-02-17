page 25006853 "Lost Sales Setup"
{
    Caption = 'Lost Sales Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006753;

    layout
    {
        area(content)
        {
            group("Automatic Registration")
            {
                Caption = 'Automatic Registration';
                field("On Service Doc. Deletion"; "On Service Doc. Deletion")
                {
                }
                field("On Sales Doc. Deletion"; "On Sales Doc. Deletion")
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

