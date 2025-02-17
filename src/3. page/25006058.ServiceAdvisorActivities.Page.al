page 25006058 "Service Advisor Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006177;

    layout
    {
        area(content)
        {
            cuegroup("Branch Selection")
            {
                Caption = 'Branch Selection';

                actions
                {
                    action("<Action1000000001>")
                    {
                        Caption = 'User Personalization';
                        RunObject = Page 9173;
                    }
                }
            }
            cuegroup("Service Orders")
            {
                Caption = 'Service Orders';
                field("Service Orders - Booking"; "Service Orders - Booking")
                {
                    Caption = 'Booking';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field("Service Orders - Inactive"; "Service Orders - Inactive")
                {
                    Caption = 'Inactive';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field("Service Orders - In Process"; "Service Orders - In Process")
                {
                    Caption = 'In Process';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field("Service Orders - Finished"; "Service Orders - Finished")
                {
                    Caption = 'Finished';
                    DrillDownPageID = "Service Orders EDMS";
                }

                actions
                {
                    action("New Service Quote")
                    {
                        Caption = 'New Service Quote';
                        RunObject = Page 25006198;
                        RunPageMode = Create;
                    }
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

    trigger OnAfterGetRecord()
    var
        ResourceTimeRegMgt: Codeunit "25006290";
        ServLaborAllocationEntry: Record "25006271";
        ServiceSetup: Record "25006120";
        StandardEvent: Record "25006272";
    begin
    end;

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
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetServiceFilterEDMS();
        IF RespCenterFilter <> '' THEN BEGIN
            IF UserMgt.DefaultResponsibility THEN
                SETFILTER("Responsibility Center", RespCenterFilter)
            ELSE
                SETFILTER("Accountability Center", RespCenterFilter);
        END;
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserProfileSetup.GET(UserSetup."Default User Profile Code") THEN
                SETRANGE(Location, UserProfileSetup."Def. Service Location Code");
        END;
    end;
}

