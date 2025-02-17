page 33020425 "Emp Req Card"
{
    Editable = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,View';
    SourceTable = Table33020379;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(EmpReqNo; EmpReqNo)
                {
                    Editable = false;
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Position Code"; "Position Code")
                {
                }
                field("Position Name"; "Position Name")
                {
                }
                field("No. of Position"; "No. of Position")
                {
                }
                field("Reason for Requirement"; "Reason for Requirement")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Remarks on Reason"; "Remarks on Reason")
                {
                }
                field("Posted By"; "Posted By")
                {
                    Caption = 'Posted By';
                }
                field("Posted Date"; "Posted Date")
                {
                }
            }
            group("For HR")
            {
                field("Budget Verification"; "Budget Verification")
                {
                }
                field("Remark by HR"; "Remark by HR")
                {
                }
                field("Checked By"; "Checked By")
                {
                    Visible = false;
                }
                field("Checked Date"; "Checked Date")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Minute No"; "Minute No")
                {
                }
                field("Remarks on Approval"; "Remarks on Approval")
                {
                }
            }
            group("Vacancy Info")
            {
                Caption = 'Vacancy Info';
                field(VacNo; VacNo)
                {
                    Caption = 'Vacancy No.';
                }
                field(VacSubCode; VacSubCode)
                {
                    Caption = 'Vacancy Code';
                }
                field(PostDate; PostDate)
                {
                    Caption = 'Posted Date';
                }
                field(PostedBY; PostedBY)
                {
                    Caption = 'Posted By';
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
            group("<Action1000000025>")
            {
                Caption = 'Functions';
                action("<Action1000000026>")
                {
                    Caption = 'Show All Applicants';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AllApplicants: Page "33020426";
                    begin
                        //msg('123');
                        ApplicationNew.RESET;
                        ApplicationNew.SETRANGE(ApplicationNew."Vacancy No.", VacNo);
                        // ApplicationNew.SETRANGE(ApplicationNew."Vacancy Code",VacSubCode);


                        //ShortListed.SetAllFilters(ApplicationNew);
                        CLEAR(AllApplicants);
                        AllApplicants.SETTABLEVIEW(ApplicationNew);
                        AllApplicants.RUNMODAL;
                    end;
                }
                action("<Action1000000027>")
                {
                    Caption = 'Short Listed Applicants';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AllApplicants: Page "33020426";
                    begin
                        //msg('123');
                        ApplicationNew.RESET;
                        ApplicationNew.SETRANGE(ApplicationNew."Vacancy No.", VacNo);
                        // ApplicationNew.SETRANGE(ApplicationNew."Vacancy Code",VacSubCode);
                        ApplicationNew.SETRANGE(ApplicationNew.Status, ApplicationNew.Status::Shortlist);

                        //ShortListed.SetAllFilters(ApplicationNew);
                        CLEAR(AllApplicants);
                        AllApplicants.SETTABLEVIEW(ApplicationNew);
                        AllApplicants.RUNMODAL;
                    end;
                }
                action("<Action1000000028>")
                {
                    Caption = 'Applicants For WrittenExam';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        AllApplicants: Page "33020426";
                    begin
                        //msg('123');
                        ApplicationNew.RESET;
                        ApplicationNew.SETRANGE(ApplicationNew."Vacancy No.", VacNo);
                        // ApplicationNew.SETRANGE(ApplicationNew."Vacancy Code",VacSubCode);
                        ApplicationNew.SETRANGE(ApplicationNew.Status, ApplicationNew.Status::Writtern);

                        //ShortListed.SetAllFilters(ApplicationNew);
                        CLEAR(AllApplicants);

                        AllApplicants.SETTABLEVIEW(ApplicationNew);
                        AllApplicants.RUNMODAL;
                    end;
                }
                action("<Action1000000029>")
                {
                    Caption = 'Applicants For Interview';
                    Image = ExportSalesPerson;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AllApplicants: Page "33020426";
                    begin
                        //msg('123');
                        ApplicationNew.RESET;
                        ApplicationNew.SETRANGE(ApplicationNew."Vacancy No.", VacNo);
                        //ApplicationNew.SETRANGE(ApplicationNew."Vacancy Code",VacSubCode);
                        ApplicationNew.SETRANGE(ApplicationNew.Status, ApplicationNew.Status::Interview);

                        //ShortListed.SetAllFilters(ApplicationNew);
                        AllApplicants.SETTABLEVIEW(ApplicationNew);
                        AllApplicants.RUNMODAL;
                    end;
                }
                action("Selected Applicant/s")
                {
                    Caption = 'Selected Applicant/s';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AllApplicants: Page "33020426";
                    begin
                        //msg('123');
                        ApplicationNew.RESET;
                        ApplicationNew.SETRANGE(ApplicationNew."Vacancy No.", VacNo);
                        // ApplicationNew.SETRANGE(ApplicationNew."Vacancy Code",VacSubCode);
                        ApplicationNew.SETRANGE(ApplicationNew.Status, ApplicationNew.Status::Converted);

                        //ShortListed.SetAllFilters(ApplicationNew);
                        CLEAR(AllApplicants);

                        AllApplicants.SETTABLEVIEW(ApplicationNew);
                        AllApplicants.RUNMODAL;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        VacancyLines.SETRANGE(VacancyLines.EmployeeReqNo, EmpReqNo);
        IF VacancyLines.FIND('-') THEN BEGIN
            VacNo := VacancyLines."Vacancy No";
            VacSubCode := VacancyLines."Vacancy SubCode";
            VacancyHeader.SETRANGE(VacancyHeader."Vacancy No", VacNo);
            IF VacancyHeader.FINDFIRST THEN BEGIN
                PostDate := VacancyHeader."Posted Date";
                PostedBY := VacancyHeader."Posted By";
            END;

        END;
    end;

    var
        UserSetup: Record "91";
        VacancyLines: Record "33020381";
        VacNo: Code[20];
        VacSubCode: Code[20];
        PostDate: Date;
        VacancyHeader: Record "33020380";
        PostedBY: Text[30];
        ApplicationNew: Record "33020382";
}

