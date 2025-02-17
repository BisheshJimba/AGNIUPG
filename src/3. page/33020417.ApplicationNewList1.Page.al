page 33020417 "Application New List1"
{
    CardPageID = "Application New Card";
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
                field(ShortListed; ShortListed)
                {
                    Caption = 'ShortListed';
                }
                field(Interviewed; Interviewed)
                {
                    Caption = 'Interviewed';
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
                field(M_Faculty; M_Faculty)
                {
                    Caption = 'Master';
                }
                field(B_Faculty; B_Faculty)
                {
                    Caption = 'Bachelor';
                }
                field(I_Faculty; I_Faculty)
                {
                    Caption = 'Intermediate';
                }
                field(WE1_Duration; WE1_Duration)
                {
                    Caption = 'Work Experience';
                }
                field("Driving License"; "Driving License")
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
            group("<Action1000000014>")
            {
                Caption = 'Functions';
                action("<Action1000000015>")
                {
                    Caption = 'Short List Criteria';
                    Image = ShowMatrix;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33020419;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //msg('123');
                    end;
                }
                action(ShortList)
                {
                    Caption = 'ShortList';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //msg('123');
                        //IF CONFIRM(text0001,TRUE) THEN BEGIN
                        SetRecordSelection(ApplicationNew);
                        ApplicationNew.SETCURRENTKEY("Vacancy Code");
                        ApplicationNew.SETRANGE("Vacancy Code", "Vacancy Code");
                        IF ApplicationNew.FINDSET THEN BEGIN
                            REPEAT
                                ApplicationNew.ShortList := TRUE;
                                ApplicationNew."Written Exam" := TRUE;
                                ApplicationNew."Posted by- Shortlist" := USERID;
                                ApplicationNew."Posted Date- Shortlist" := TODAY;
                                ApplicationNew.MODIFY;
                            UNTIL ApplicationNew.NEXT = 0;
                        END;
                        MESSAGE(text0001);

                        //END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ApplicationNew.SETRANGE(ApplicationNew."Application No.", "Application No.");
        IF ApplicationNew.FINDFIRST THEN BEGIN
            ShortListed := ApplicationNew.ShortList;
            Interviewed := ApplicationNew.Interview;
        END;
    end;

    var
        ApplicationNew: Record "33020382";
        VacancyHeader: Record "33020380";
        VacancyLines: Record "33020381";
        text0001: Label 'The List of Applicants are shortlisted successfully!';
        ShortListed: Boolean;
        Interviewed: Boolean;

    [Scope('Internal')]
    procedure SetRecordSelection(var AppNew: Record "33020382")
    begin
        CurrPage.SETSELECTIONFILTER(AppNew);
    end;
}

