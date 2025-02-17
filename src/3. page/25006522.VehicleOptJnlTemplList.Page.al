page 25006522 "Vehicle Opt. Jnl. Templ. List"
{
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Journal Template List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table25006385;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field("Form ID"; "Form ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Form Name"; "Form Name")
                {
                    DrillDown = false;
                    Visible = false;
                }
                field("Test Report ID"; "Test Report ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Test Report Name"; "Test Report Name")
                {
                    DrillDown = false;
                    Visible = false;
                }
                field("Posting Report ID"; "Posting Report ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Posting Report Name"; "Posting Report Name")
                {
                    DrillDown = false;
                    Visible = false;
                }
                field("Force Posting Report"; "Force Posting Report")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

