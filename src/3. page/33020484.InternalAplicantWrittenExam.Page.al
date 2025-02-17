page 33020484 "Internal Aplicant-Written Exam"
{
    CardPageID = "Internal-Applicant Card";
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
                    Editable = false;
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                    Editable = false;
                }
                field("Post Applied For"; "Post Applied For")
                {
                    Editable = false;
                }
                field("Employee Code"; "Employee Code")
                {
                    Editable = false;
                }
                field("First Name"; "First Name")
                {
                    Editable = false;
                }
                field("Middle Name"; "Middle Name")
                {
                    Editable = false;
                }
                field("Last Name"; "Last Name")
                {
                    Editable = false;
                }
                field(Nationality; Nationality)
                {
                    Editable = false;
                }
                field("Select for Written Exam"; "Select for Written Exam")
                {
                    Editable = false;
                }
                field("Select for Interview"; "Select for Interview")
                {
                    Editable = false;
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
            action("Select for Interview")
            {
                Caption = 'Select for Interview';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD("Written Marks");
                    IntAppRec.RESET;
                    IntAppRec.SETRANGE("Applicant No.", "Applicant No.");
                    IntAppRec.SETRANGE("Vacancy Code", "Vacancy Code");
                    IF IntAppRec.FINDFIRST THEN BEGIN
                        IntAppRec."Select for Interview" := TRUE;
                        IntAppRec."I- Posted by" := USERID;
                        IntAppRec."I- Posted Date" := TODAY;
                        IntAppRec.MODIFY;
                    END;
                end;
            }
            action("<Action1000000015>")
            {
                Caption = 'Remove from Interview';
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
                        IF IntAppRec."Select for Interview" = TRUE THEN BEGIN
                            IntAppRec."Select for Interview" := FALSE;
                            IntAppRec."I- Posted by" := USERID;
                            IntAppRec."I- Posted Date" := TODAY;
                            IntAppRec.MODIFY;
                        END;
                    END;
                end;
            }
        }
    }

    var
        IntAppRec: Record "33020416";
}

