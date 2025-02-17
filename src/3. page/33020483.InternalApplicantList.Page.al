page 33020483 "Internal Applicant List"
{
    CardPageID = "Internal-Applicant Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020416;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No."; "Applicant No.")
                {
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("Post Applied For"; "Post Applied For")
                {
                }
                field("Employee Code"; "Employee Code")
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
                field("Select for Written Exam"; "Select for Written Exam")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select for Written Exam")
            {
                Caption = 'Select for Written Exam';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IntAppRec.RESET;
                    IntAppRec.SETRANGE("Applicant No.", "Applicant No.");
                    IntAppRec.SETRANGE("Vacancy Code", "Vacancy Code");
                    IF IntAppRec.FINDFIRST THEN BEGIN
                        IntAppRec."Select for Written Exam" := TRUE;
                        IntAppRec."WE- Posted by" := USERID;
                        IntAppRec."WE- Posted Date" := TODAY;
                        IntAppRec.MODIFY;
                    END;
                end;
            }
            action("<Action1000000012>")
            {
                Caption = 'Remove from Written Exam';
                Image = RemoveContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IntAppRec.RESET;
                    IntAppRec.SETRANGE("Applicant No.", "Applicant No.");
                    IntAppRec.SETRANGE("Vacancy Code", "Vacancy Code");
                    IF IntAppRec.FINDFIRST THEN BEGIN
                        IF IntAppRec."Select for Written Exam" = TRUE THEN BEGIN
                            IntAppRec."Select for Written Exam" := FALSE;
                            IntAppRec."WE- Posted by" := USERID;
                            IntAppRec."WE- Posted Date" := TODAY;
                            IntAppRec.MODIFY;
                        END;
                    END;
                end;
            }
            action("<Action1000000013>")
            {
                Caption = 'Save Education and WorkExperience';
                Image = ImplementPriceChange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Deleting the existing Education from Table: "Education Line".
                    VacEducationRec.RESET;
                    VacEducationRec.SETRANGE("Applicant No.", "Applicant No.");
                    VacEducationRec.SETRANGE("Employee Code", "Employee Code");
                    IF VacEducationRec.FINDFIRST THEN BEGIN
                        REPEAT
                            EducationRec.RESET;
                            EducationRec.SETRANGE("Employee Code", "Employee Code");
                            IF EducationRec.FINDFIRST THEN BEGIN
                                EducationRec.DELETEALL;
                            END;
                        UNTIL VacEducationRec.NEXT = 0;
                    END;

                    //Inserting the value from "Vacancy Education Line" into the Table: "Education Line"
                    VacEducationRec.RESET;
                    VacEducationRec.SETRANGE("Applicant No.", "Applicant No.");
                    VacEducationRec.SETRANGE("Employee Code", "Employee Code");
                    IF VacEducationRec.FINDFIRST THEN BEGIN
                        REPEAT
                            EducationRec.RESET;
                            EducationRec.INIT;
                            EducationRec."Employee Code" := VacEducationRec."Employee Code";
                            EducationRec."Line No." := VacEducationRec."Line No.";
                            EducationRec.Degree := VacEducationRec.Degree;
                            EducationRec.Faculty := VacEducationRec.Faculty;
                            EducationRec."College/ Institution" := VacEducationRec."College/ Institution";
                            EducationRec."University/ Board" := VacEducationRec.University;
                            EducationRec."Percentage/ GPA" := VacEducationRec."Percentage/ GPA";
                            EducationRec."Passed Year" := VacEducationRec."Passed Year";
                            EducationRec.INSERT;
                        UNTIL VacEducationRec.NEXT = 0;
                    END;

                    // Deleting the existing WorkExperience from Table: "Work Experience Line"
                    VacWorkRec.RESET;
                    VacWorkRec.SETRANGE("Applicant No.", "Applicant No.");
                    VacWorkRec.SETRANGE("Employee Code", "Employee Code");
                    IF VacWorkRec.FINDFIRST THEN BEGIN
                        REPEAT
                            WorkRec.RESET;
                            WorkRec.SETRANGE("Employee Code", "Employee Code");
                            IF WorkRec.FINDFIRST THEN BEGIN
                                WorkRec.DELETEALL;
                            END;
                        UNTIL VacWorkRec.NEXT = 0;
                    END;

                    //Inserting the value from "Vacancy WorkExperience line" into Table: "Work Experience Line"
                    VacWorkRec.RESET;
                    VacWorkRec.SETRANGE("Applicant No.", "Applicant No.");
                    VacWorkRec.SETRANGE("Employee Code", "Employee Code");
                    IF VacWorkRec.FINDFIRST THEN BEGIN
                        REPEAT
                            WorkRec.RESET;
                            WorkRec.INIT;
                            WorkRec."Employee Code" := VacWorkRec."Employee Code";
                            WorkRec."Line No." := VacWorkRec."Line No.";
                            WorkRec.Organization := VacWorkRec.Organization;
                            WorkRec.Department := VacWorkRec.Department;
                            WorkRec.Position := VacWorkRec.Position;
                            WorkRec."Duration in Months" := VacWorkRec.Duration;
                            WorkRec.INSERT;
                        UNTIL VacWorkRec.NEXT = 0;
                    END;
                end;
            }
        }
    }

    var
        IntAppRec: Record "33020416";
        VacEducationRec: Record "33020417";
        VacWorkRec: Record "33020418";
        EducationRec: Record "33020420";
        WorkRec: Record "33020421";
}

