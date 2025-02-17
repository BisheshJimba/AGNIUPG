page 25006218 "Service Plan Template Stages"
{
    Caption = 'Service Plan Template Stages';
    DataCaptionFields = "Template Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006141;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Template Code"; "Template Code")
                {
                    Visible = false;
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Kilometrage; Kilometrage)
                {
                    Visible = false;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = false;
                }
                field("Service Interval"; "Service Interval")
                {
                }
                field("Package No."; "Package No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Plan Templ. Stage")
            {
                Caption = 'Plan Templ. Stage';
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page 25006248;
                    RunPageLink = Type = CONST(Plan Template Stage),
                                  Plan No.=FIELD(Template Code),
                                  Stage Code=FIELD(Code);
                }
            }
        }
    }
}

