page 33020240 "Service Gate Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006177;

    layout
    {
        area(content)
        {
            cuegroup("Service Orders")
            {
                Caption = 'Service Orders';
                field("Service Orders - Booking"; "Service Orders - Booking")
                {
                    Caption = 'Booking';
                    DrillDownPageID = "Vehicle Booking List";
                }

                actions
                {
                    action("New Service Order")
                    {
                        Caption = 'New Service Order';
                        Image = Document;
                        RunObject = Page 25006183;
                        RunPageMode = Create;
                    }
                    action("<Action1>")
                    {
                        Caption = 'New Vehicle';
                        RunObject = Page 25006032;
                        RunPageMode = Create;
                    }
                    action("<Action3>")
                    {
                        Caption = 'Schedule';
                        RunObject = Page 25006358;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "91";
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;

        SETRANGE("Date Filter", 0D, WORKDATE);
        FilterOnRecord;
    end;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        FILTERGROUP(2);
        IF UserSetup.GET(USERID) THEN BEGIN
            SETRANGE("Responsibility Center", UserMgt.GetRespCenter(3, "Responsibility Center"));
            IF UserProfileSetup.GET(UserSetup."Default User Profile Code") THEN
                SETRANGE(Location, UserProfileSetup."Def. Service Location Code");
        END;
        FILTERGROUP(0);
    end;
}

