page 33020493 "HOD Staff Req Card"
{
    PageType = Card;
    SourceTable = Table33020422;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Requisition No."; "Requisition No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Job Title Code"; "Job Title Code")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("Branch Code"; "Branch Code")
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Supervisor Code"; "Supervisor Code")
                {
                }
                field("Supervisor Name"; "Supervisor Name")
                {
                }
                field(Segment; Segment)
                {
                }
                field("Date Required"; "Date Required")
                {
                }
                field("Nature of Manpower"; "Nature of Manpower")
                {
                }
                field("No. of Staff Required"; "No. of Staff Required")
                {
                }
                field("Duration (in months)"; "Duration (in months)")
                {
                }
                field("Brief Description of Duties"; "Brief Description of Duties")
                {
                }
                field(Qualifications; Qualifications)
                {
                }
                field(Experiences; Experiences)
                {
                }
                field("Skills and Qualities"; "Skills and Qualities")
                {
                }
                field(Requirement; Requirement)
                {

                    trigger OnValidate()
                    begin
                        IF Requirement = Requirement::Replacement THEN
                            Replacement := TRUE
                        ELSE
                            Replacement := FALSE;
                    end;
                }
                field("Staff Replaced"; "Staff Replaced")
                {
                }
                field("Staff Replaced Name"; "Staff Replaced Name")
                {
                }
                field("Reason for replacement"; "Reason for replacement")
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
            action("<Action1000000025>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD("Nature of Manpower");
                    TESTFIELD("No. of Staff Required");
                    ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        "HOD Posted" := TRUE;
                        "HOD Posted By" := USERID;
                        "HOD Posted Date" := TODAY;
                        MESSAGE(text0002);
                    END;
                end;
            }
        }
    }

    var
        ConfirmPost: Boolean;
        text0001: Label 'Do you want to Post?';
        text0002: Label 'Successfully Posted';
}

