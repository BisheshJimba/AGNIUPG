page 25006375 "Schedule Views"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 16.05.2013 EDMS P8
    //   * Added field "Time Grid Item Code"

    Caption = 'Schedule Views';
    PageType = List;
    SourceTable = Table25006282;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Resource Group"; "Resource Group")
                {
                }
                field("Period Type"; "Period Type")
                {
                }
                field("Start Date Formula"; "Start Date Formula")
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End Time"; "End Time")
                {
                }
                field("Time Grid Code"; "Time Grid Code")
                {
                    Visible = false;
                }
                field("Columns Parameter"; "Columns Parameter")
                {
                }
                field("Show as Columns"; "Show as Columns")
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
        SETRANGE(Code, FilterOnView);
    end;
}

