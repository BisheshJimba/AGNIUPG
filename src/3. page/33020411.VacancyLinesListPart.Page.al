page 33020411 "Vacancy Lines ListPart"
{
    PageType = ListPart;
    SourceTable = Table33020381;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vacancy SubCode"; "Vacancy SubCode")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Position Code"; "Position Code")
                {
                }
                field(Position; Position)
                {
                }
                field("Dept Code"; "Dept Code")
                {
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
                field("No. of Opening"; "No. of Opening")
                {
                }
                field("Min. Qualification"; "Min. Qualification")
                {
                }
                field("Work Experience"; "Work Experience")
                {
                }
                field(EmployeeReqNo; EmployeeReqNo)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000013>")
            {
                Caption = 'Functions';
                action("<Action1000000014>")
                {
                    Caption = 'Show Applicant';
                    RunObject = Page 33020417;
                    RunPageLink = Vacancy Code=FIELD(Vacancy SubCode),
                                  Vacancy No.=FIELD(Vacancy No);

                    trigger OnAction()
                    begin
                        //message('123');
                    end;
                }
                action("Show ShortListed Applicant")
                {
                    Caption = 'Show ShortListed Applicant';
                    RunObject = Page 33020418;
                                    RunPageLink = Vacancy Code=FIELD(Vacancy SubCode),
                                  Vacancy No.=FIELD(Vacancy No);

                    trigger OnAction()
                    begin
                        //msg('123');
                    end;
                }
                action("<Action1000000015>")
                {
                    Caption = 'Applicant For Written Exam';
                    RunObject = Page 33020421;
                                    RunPageLink = Vacancy Code=FIELD(Vacancy SubCode),
                                  Vacancy No.=FIELD(Vacancy No);

                    trigger OnAction()
                    begin
                        //msg('123');
                    end;
                }
                action("<Action1000000016>")
                {
                    Caption = 'Applicant For Interview';
                    RunObject = Page 33020422;
                                    RunPageLink = Vacancy Code=FIELD(Vacancy SubCode),
                                  Vacancy No.=FIELD(Vacancy No);

                    trigger OnAction()
                    begin
                        //msg('123');
                    end;
                }
                action("Show Info")
                {
                    Caption = 'Show Info';
                    RunObject = Page 33020429;
                                    RunPageLink = Vacancy No.=FIELD(Vacancy No),
                                  Vacancy Code=FIELD(Vacancy SubCode);
                }
            }
        }
    }

    var
        ApplicationNew: Record "33020382";
        TotalEmployed: Integer;
        VacancyLines: Record "33020381";
}

