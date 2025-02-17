page 33020449 "Trainee Card"
{
    PageType = Card;
    SourceTable = Table33020403;

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field("Marrital Status"; "Marrital Status")
                {
                }
                field("Ward No."; "Ward No.")
                {
                }
                field("VDC/ NP"; "VDC/ NP")
                {
                }
                field(District; District)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Education; Education)
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Complete Date"; "Complete Date")
                {
                }
                field(Durations; Durations)
                {
                }
                field(Designation; Designation)
                {
                }
                field("Direct Supervisor Code"; "Direct Supervisor Code")
                {
                }
                field("Direct Supervisor"; "Direct Supervisor")
                {
                }
                field("Job Title Code"; "Job Title Code")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("Department Code"; "Department Code")
                {
                }
                field(Department; Department)
                {
                }
                field("Branch Code"; "Branch Code")
                {
                }
                field(Branch; Branch)
                {
                }
                field(Remarks; Remarks)
                {
                }
                field(Company; Company)
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
            action("<Action1000000020>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TrainRec.SETRANGE(TrainRec."Entry No.", "Entry No.");
                    IF TrainRec.FINDFIRST THEN BEGIN
                        IF TrainRec.Posted = FALSE THEN BEGIN
                            TrainRec.Posted := TRUE;
                            TrainRec."Posted Date" := TODAY;
                            TrainRec."Posted By" := USERID;
                            TrainRec.MODIFY;
                            MESSAGE(text0001);
                        END ELSE BEGIN
                            MESSAGE(text0002);
                        END;
                    END;
                end;
            }
        }
    }

    var
        TrainRec: Record "33020403";
        text0001: Label 'Trainee Record Inserted Successfully!';
        text0002: Label 'Record Updated Successfully!!';
}

