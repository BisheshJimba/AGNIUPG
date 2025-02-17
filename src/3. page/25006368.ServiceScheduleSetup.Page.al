page 25006368 "Service Schedule Setup"
{
    // 06.01.2015 EB.P7 Schedule.Web
    //   * Field "Use Schedule Web" removed
    // 
    // 13.07.2014 P7 Elva Baltic
    //   * Field "Use Schedule Web" added

    Caption = 'Service Schedule Setup';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006286;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Base Calendar Code"; "Base Calendar Code")
                {
                }
                field("Def. View Code"; "Def. View Code")
                {
                }
                field("Refresh Interval (ms)"; "Refresh Interval (ms)")
                {
                }
                field("Resource Name in Schedule"; "Resource Name in Schedule")
                {
                }
                field("Working Resource Color"; "Working Resource Color")
                {
                }
                field("Non-Working Resource Color"; "Non-Working Resource Color")
                {
                }
                field("Show Unavailable Time"; "Show Unavailable Time")
                {
                }
                field("Only Pers. Affect Doc. Status"; "Only Pers. Affect Doc. Status")
                {
                }
                field("Disable Unavail. Time Control"; "Disable Unavail. Time Control")
                {
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                field("Control Document Statuses"; "Control Document Statuses")
                {
                }
                field("Post Only When Finished"; "Post Only When Finished")
                {
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field("Planning Policy"; "Planning Policy")
                {
                }
                field("Serv. Document Alloc. Method"; "Serv. Document Alloc. Method")
                {
                }
                field("Replan Document"; "Replan Document")
                {
                }
                field("Handle Linked Entries"; "Handle Linked Entries")
                {
                }
                field("Min. Notability (Hours)"; "Min. Notability (Hours)")
                {
                }
                field("Control Skills"; "Control Skills")
                {
                }
                field("Control Labor Sequence"; "Control Labor Sequence")
                {
                }
                field("Allocation Time Step (Minutes)"; "Allocation Time Step (Minutes)")
                {
                }
            }
            group("Time Registration")
            {
                Caption = 'Time Registration';
                field("Break Standard Code"; "Break Standard Code")
                {
                }
                field("Break Reason Code"; "Break Reason Code")
                {
                }
                field("Dashboard Refresh in Minutes"; "Dashboard Refresh in Minutes")
                {
                }
                field("Dashboard Default Period"; "Dashboard Default Period")
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

    var
        [InDataSet]
        NonworkingDayColorEditable: Boolean;
}

