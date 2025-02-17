page 25006041 "Process Checklist Setup"
{
    Caption = 'Process Checklist Setup';
    PageType = Card;
    SourceTable = Table25006009;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Process Checklist Nos."; "Process Checklist Nos.")
                {
                }
                field("PDI Nos."; "PDI Nos.")
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

