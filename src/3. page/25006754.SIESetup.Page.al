page 25006754 "SIE Setup"
{
    Caption = 'SIE Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006701;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Synch. Interval (sec)"; "Synch. Interval (sec)")
                {
                }
                field("File Name"; "File Name")
                {
                }
                field("Automatic SIE Journal Posting"; "Automatic SIE Journal Posting")
                {
                }
                field("Automatic PutInTakeOut"; "Automatic PutInTakeOut")
                {
                }
                field("Automatic Assign"; "Automatic Assign")
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

