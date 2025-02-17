page 33020447 "Intern Card"
{
    PageType = Card;
    SourceTable = Table33020402;

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
                field("College/ Institution Name"; "College/ Institution Name")
                {
                }
                field("VDC/ NP"; "VDC/ NP")
                {
                }
                field(District; District)
                {
                }
                field(Education; Education)
                {
                }
                field("Phone No."; "Phone No.")
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
                    Caption = 'Department Code';
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Branch Code"; "Branch Code")
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Complete Date"; "Complete Date")
                {
                }
                field("Duration (Months)"; "Duration (Months)")
                {
                }
                field(Attendance; Attendance)
                {
                }
                field(IDate; IDate)
                {
                }
                field(Report; Report)
                {
                }
                field("Experience Letter"; "Experience Letter")
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
            action("<Action1000000022>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    InternRec.SETRANGE(InternRec."Entry No.", "Entry No.");
                    IF InternRec.FINDFIRST THEN BEGIN
                        IF InternRec.Posted = FALSE THEN BEGIN
                            InternRec.Posted := TRUE;
                            InternRec."Posted Date" := TODAY;
                            InternRec."Posted By" := USERID;
                            InternRec.MODIFY;
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
        InternRec: Record "33020402";
        text0001: Label 'Intern record posted successfully!';
        text0002: Label 'Record Updated Successfully!!';
}

