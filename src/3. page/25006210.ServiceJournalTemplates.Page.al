page 25006210 "Service Journal Templates"
{
    Caption = 'Service Journal Templates';
    PageType = List;
    SourceTable = Table25006163;

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
                field(Recurring; Recurring)
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Reason Code"; "Reason Code")
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
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                action(Batches)
                {
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page 25006206;
                    RunPageLink = Journal Template Name=FIELD(Name);
                }
            }
        }
    }
}

