page 25006017 "Object Picture Mgt. Setup"
{
    Caption = 'Picture Mgt. Setup';
    SourceTable = Table25006020;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Picture Nos."; Code)
                {
                    Caption = 'Picture Nos.';
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

