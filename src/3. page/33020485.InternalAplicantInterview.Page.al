page 33020485 "Internal Aplicant-Interview"
{
    CardPageID = "Internal App-Interview Card";
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
                field(Nationality; Nationality)
                {
                }
                field("Select for Written Exam"; "Select for Written Exam")
                {
                }
                field("Written Marks"; "Written Marks")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Rank data")
            {
                Caption = 'Rank data';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 33020342;

                trigger OnAction()
                begin
                    InterviewMarks.RESET;
                    InterviewMarks.SETRANGE("Vacancy Code", "Vacancy Code");
                    InterviewMarks.SETFILTER(Interviewer, 'Interviewer 1');
                    IF InterviewMarks.FINDFIRST THEN BEGIN
                        i := 1;
                        REPEAT
                            MESSAGE(InterviewMarks."Applicant No.");
                            temp := InterviewMarks."Total Marks";
                        //interviewMarks.NEXT;
                        //IF (temp > InterviewMarks."Total Marks") THEN



                        UNTIL InterviewMarks.NEXT = 0;
                    END;
                end;
            }
        }
    }

    var
        InternalRec: Record "33020415";
        Applicant: Code[20];
        InterviewMarks: Record "33020419";
        i: Integer;
        temp: Decimal;
}

