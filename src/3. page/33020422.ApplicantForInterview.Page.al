page 33020422 "Applicant For Interview"
{
    CardPageID = "Applicant Interview Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020382;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; "Application No.")
                {
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(Gender; Gender)
                {
                }
                field(Employed; Employed)
                {
                    Caption = 'Employed';
                }
                field(Nationality; Nationality)
                {
                }
                field(Email; Email)
                {
                }
                field(CellPhone; CellPhone)
                {
                }
                field("Interview Marks"; "Interview Marks")
                {
                }
                field("Written Marks"; "Written Marks")
                {
                }
                field("Offer Sent Date"; "Offer Sent Date")
                {
                }
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
            action("Convert To Interviewed")
            {

                trigger OnAction()
                var
                    Application: Record "33020330";
                begin
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ApplicationNew.SETRANGE(ApplicationNew."Application No.", "Application No.");
        IF ApplicationNew.FINDFIRST THEN BEGIN
            Employed := ApplicationNew.Employed;
        END;
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        SETRANGE(Status, Rec.Status::Interview);

        FILTERGROUP(0);
    end;

    var
        ApplicationNew: Record "33020382";
        Employed: Boolean;
}

