page 33020382 "Employee Requisition Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table33020327;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vacany No."; "Vacany No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Department; Department)
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("New Position"; "New Position")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Experience Reqd."; "Experience Reqd.")
                {
                }
                field("Ideal Age"; "Ideal Age")
                {
                }
                field("No. of Openings"; "No. of Openings")
                {
                }
                field("Job Assigned Date"; "Job Assigned Date")
                {
                }
            }
            part(; 33020323)
            {
                SubPageLink = Vacancy No.=FIELD(Vacany No.);
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    //message('123');
                end;
            }
        }
    }
}

