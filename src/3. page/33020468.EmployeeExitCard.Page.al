page 33020468 "Employee Exit Card"
{
    SourceTable = Table33020410;

    layout
    {
        area(content)
        {
            group("Employee Information")
            {
                Caption = 'Employee Information';
                field("Exit No."; "Exit No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field(Desgination; Desgination)
                {
                    Editable = false;
                }
                field(Department; Department)
                {
                    Editable = false;
                }
                field(Company; Company)
                {
                }
                field("Joining Date"; "Joining Date")
                {
                }
                field("Date of Leaving"; "Date of Leaving")
                {
                }
                field("No. of years"; "No. of years")
                {
                }
            }
            group(Information)
            {
                Caption = 'Information';
                field("Position at time of Joining"; "Position at time of Joining")
                {
                    Caption = 'Position at the time of joining:';
                }
                field("No. of Promotion Since Joining"; "No. of Promotion Since Joining")
                {
                    Caption = 'No. of Promotions since joining:';
                }
                field("Areas/Funtion worked in"; "Areas/Funtion worked in")
                {
                    Caption = 'Areas / Functions worked in:';
                }
            }
            group("Type of Separation")
            {
                Caption = 'Type of Separation';
                field(Voluntary; Voluntary)
                {
                    Caption = 'Voluntary';
                }
                field("Voluntary Other"; "Voluntary Other")
                {
                    Caption = 'Voluntary-Others';
                }
                field(Involuntary; Involuntary)
                {
                    Caption = 'Involuntary';
                }
                field("Involuntary Other"; "Involuntary Other")
                {
                    Caption = 'Involuntary-Other';
                }
            }
            group("1. Explain in brief regarding your separation")
            {
                Caption = '1. Explain in brief regarding your separation';
                field("Explain Separation"; "Explain Separation")
                {
                }
            }
            group("2. What did you think of your supervisor on the following points:")
            {
                Caption = '2. What did you think of your supervisor on the following points:';
                field("Supervisor Consistent"; "Supervisor Consistent")
                {
                    Caption = 'Was consistently fair';
                }
                field("Supervisor Recognition"; "Supervisor Recognition")
                {
                    Caption = 'Provided recognition';
                }
                field("Supervisor Complaints"; "Supervisor Complaints")
                {
                    Caption = 'Resolved complaints';
                }
                field("Supervisor Sensitive"; "Supervisor Sensitive")
                {
                    Caption = 'Was sensitive to employees'' needs';
                }
                field("Supervisor Feedback"; "Supervisor Feedback")
                {
                    Caption = 'Provided feedback on performance';
                }
                field("Supervisor Receptive"; "Supervisor Receptive")
                {
                    Caption = 'Was receptive to open communication';
                }
                field("Supervisor Policies"; "Supervisor Policies")
                {
                    Caption = 'Followed Sipradi''s Policies';
                }
            }
            group("3. How would you rate the following?")
            {
                Caption = '3. How would you rate the following?';
                field("Rate Policies"; "Rate Policies")
                {
                    Caption = 'Sipradi''s Policies';
                }
                field("Rate System"; "Rate System")
                {
                    Caption = 'Systems';
                }
                field("Rate Management"; "Rate Management")
                {
                    Caption = 'Top Management / Supervisors';
                }
                field("Rate Colleages"; "Rate Colleages")
                {
                    Caption = 'Peers / Colleagues';
                }
                field("Rate Subordinate"; "Rate Subordinate")
                {
                    Caption = 'Subordinates';
                }
                field("Rate Cooperation"; "Rate Cooperation")
                {
                    Caption = 'Cooperations within your Department / Segment';
                }
                field("Rate other Dept"; "Rate other Dept")
                {
                    Caption = 'Cooperatio with other Departments';
                }
                field("Rate Training"; "Rate Training")
                {
                    Caption = 'Exposure to Training';
                }
                field("Rate Comp Performance"; "Rate Comp Performance")
                {
                    Caption = 'Company''s performance review system';
                }
                field("Rate Career Development"; "Rate Career Development")
                {
                    Caption = 'Career development / Advancement opportunities';
                }
                field("Rate Physical Working"; "Rate Physical Working")
                {
                    Caption = 'Physical working conditions';
                }
                field("Rate Comment"; "Rate Comment")
                {
                    Caption = 'Comments:';
                }
            }
            group("4. How did you feel about the employee benefits provided by the company?")
            {
                Caption = '4. How did you feel about the employee benefits provided by the company?';
                field("Emp Salary"; "Emp Salary")
                {
                    Caption = 'Salary';
                }
                field("Emp Incentives"; "Emp Incentives")
                {
                    Caption = 'Incentives';
                }
                field("Emp Paid Holidays"; "Emp Paid Holidays")
                {
                    Caption = 'Paid Holidays';
                }
                field("Emp Medical Plan"; "Emp Medical Plan")
                {
                    Caption = 'Medical Plan';
                }
                field("Emp Sick Leave"; "Emp Sick Leave")
                {
                    Caption = 'Sick Leave';
                }
                field("Emp Loan Facility"; "Emp Loan Facility")
                {
                    Caption = 'Loan Facility';
                }
                field("Emp Gratuity Plan"; "Emp Gratuity Plan")
                {
                    Caption = 'Gratuity Plan';
                }
            }
            group("5. What did you like most about your job?")
            {
                Caption = '5. What did you like most about your job?';
                field("Like most Job"; "Like most Job")
                {
                    Caption = 'Options';
                }
            }
            group("6. What did you like least about your job?")
            {
                Caption = '6. What did you like least about your job?';
                field("Like least Job"; "Like least Job")
                {
                    Caption = 'Options';
                }
            }
            group("7. Was the work you were doing approximately what you expected it would be?")
            {
                Caption = '7. Was the work you were doing approximately what you expected it would be?';
                field("Expected Y/N"; "Expected Y/N")
                {
                    Caption = 'Yes / No';
                }
                field("Expected Commet"; "Expected Commet")
                {
                    Caption = 'Comments';
                }
            }
            group("8. Was your workload usually:")
            {
                Caption = '8. Was your workload usually:';
                field(Workload; Workload)
                {
                    Caption = 'Workload';
                }
            }
            group("9. Is there anything the company could have done to prevent you from leaving?")
            {
                Caption = '9. Is there anything the company could have done to prevent you from leaving?';
                field("Prevent from Leaving"; "Prevent from Leaving")
                {
                    Caption = 'Options';
                }
            }
            group("10. Would you recommend the company to a friend as a good organization to work for?")
            {
                Caption = '10. Would you recommend the company to a friend as a good organization to work for?';
                field("Recommend to friend"; "Recommend to friend")
                {
                    Caption = 'Options';
                }
                field("Recomment to friend comment"; "Recomment to friend comment")
                {
                    Caption = 'Comments';
                }
            }
            group("11. What suggestions do you have to make Sipradi a better place to work?")
            {
                Caption = '11. What suggestions do you have to make Sipradi a better place to work?';
                field("Suggestion for better"; "Suggestion for better")
                {
                    Caption = 'Options';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        EmpExitRec.RESET;
                        EmpExitRec.SETRANGE("Exit No.", "Exit No.");
                        IF EmpExitRec.FINDFIRST THEN BEGIN
                            Posted := TRUE;
                            "Posted Date" := TODAY;
                            "Posted By" := USERID;
                        END;
                    END;
                end;
            }
        }
    }

    var
        ConfirmPost: Boolean;
        EmpExitRec: Record "33020410";
        text0001: Label 'Do you want to Post?';
}

