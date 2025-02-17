page 25006207 "Serv. Journal Template List"
{
    Caption = 'Res. Journal Template List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
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
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                    Visible = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    Visible = false;
                }
                field("Form ID"; "Form ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Test Report ID"; "Test Report ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Posting Report ID"; "Posting Report ID")
                {
                    LookupPageID = Objects;
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

