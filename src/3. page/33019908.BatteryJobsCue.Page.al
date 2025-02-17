page 33019908 "Battery Jobs Cue"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table33019892;

    layout
    {
        area(content)
        {
            cuegroup(Current)
            {
                Caption = 'Current';
                field(BatteryList; BatteryList)
                {
                    Caption = 'Battery List';
                    Visible = false;
                }
                field("Opening Jobs"; "Opening Jobs")
                {
                    DrillDownPageID = "Open Job Cards";
                }
                field("Open Jobs"; "Open Jobs")
                {
                    Caption = 'Posted Open Jobs';
                    DrillDownPageID = "Posted Job List";
                }
                field("Pre Exide Claims"; "Pre Exide Claims")
                {
                    DrillDownPageID = "Pre Exide Claim List";
                    Visible = true;
                }
                field("Exide Claims"; "Exide Claims")
                {
                    Caption = 'Warranty Claims';
                    DrillDownPageID = "Exide Claim List";
                    Visible = true;
                }
                field("Issued Warranty"; "Issued Warranty")
                {
                    DrillDownPageID = "Issued Warranty";
                }
                field("All Posted Open Jobs"; "All Posted Open Jobs")
                {
                    DrillDownPageID = "All Open Jobs";
                    Visible = false;
                }

                actions
                {
                    action("New Job Card")
                    {
                        Caption = 'New Job Card';
                        RunObject = Page 33019885;
                        RunPageMode = Create;
                    }
                    action("<Action1102159021>")
                    {
                        Caption = 'Battery From Store';
                        RunObject = Page 33019929;
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup(History)
            {
                Caption = 'History';
                field(Recharged; Recharged)
                {
                    Caption = 'Recharged Job Cards';
                    DrillDownPageID = "Recharged Battery List";
                }
                field(Rejected; Rejected)
                {
                    Caption = 'Rejected Job Cards';
                    DrillDownPageID = "Rejected Job Card List";
                }
                field("Not Attend Jobs"; "Not Attend Jobs")
                {
                    DrillDownPageID = "QR Scan";
                }
                field("Pending Jobs"; "Pending Jobs")
                {
                    DrillDownPageID = "Pending Job Card List";
                }
                field(Issued; Issued)
                {
                    Caption = 'Issued Job Cards';
                    DrillDownPageID = "Issued Exide Claim List";
                }
                field("Posted Jobs List"; "Posted Jobs List")
                {
                    Caption = 'Posted Job Cards';
                    DrillDownPageID = "Posted Job Card List";
                }
                field("All Jobs"; "All Jobs")
                {
                    DrillDownPageID = "QR Scan Subform";
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
        END;
        FILTERGROUP(0);
    end;
}

