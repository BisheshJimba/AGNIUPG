page 33020421 "Applicant For Written Exam"
{
    CardPageID = "Application New Card";
    Editable = true;
    PageType = List;
    SourceTable = Table33020382;
    SourceTableView = WHERE(Written Exam=CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; "Application No.")
                {
                    Editable = false;
                }
                field("Vacancy Code"; "Vacancy Code")
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
                field(Gender; Gender)
                {
                    Editable = false;
                }
                field(Interview; Interview)
                {
                    Caption = 'Interviewed';
                    Editable = false;
                }
                field(Nationality; Nationality)
                {
                    Editable = false;
                }
                field(Email; Email)
                {
                    Editable = false;
                }
                field(CellPhone; CellPhone)
                {
                    Editable = false;
                }
                field("Written Marks"; "Written Marks")
                {
                    Caption = 'Written Exam Marks';
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
            action("<Action1000000015>")
            {
                Caption = 'Select For Interview';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApplicationNew: Record "33020382";
                begin
                    SetRecordSelection(ApplicationNew);
                    ApplicationNew.SETCURRENTKEY("Vacancy Code");
                    ApplicationNew.SETRANGE("Vacancy Code", "Vacancy Code");
                    //ApplicationNew.SETRANGE(ApplicationNew."Application No.","Application No.");
                    IF ApplicationNew.FINDFIRST THEN BEGIN
                        REPEAT
                            ApplicationNew.Interview := TRUE;
                            ApplicationNew."Posted by- Interview" := USERID;
                            ApplicationNew."Posted Date- Interview" := TODAY;
                            ApplicationNew.MODIFY;
                        UNTIL ApplicationNew.NEXT = 0;
                    END;
                    MESSAGE(text0003);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ApplicationNew.SETRANGE(ApplicationNew."Application No.", "Application No.");
        IF ApplicationNew.FINDFIRST THEN BEGIN
            Interview := ApplicationNew.Interview;
        END;
    end;

    var
        text0003: Label 'Applicants Selected for Interview!';
        ApplicationNew: Record "33020382";
        Interview: Boolean;

    [Scope('Internal')]
    procedure SetRecordSelection(var AppNew: Record "33020382")
    begin
        CurrPage.SETSELECTIONFILTER(AppNew);
    end;
}

