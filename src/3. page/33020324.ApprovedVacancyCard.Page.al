page 33020324 "Approved Vacancy Card"
{
    PageType = Card;
    SourceTable = Table33020327;
    SourceTableView = SORTING(Vacany No.)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(Yes));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vacany No."; "Vacany No.")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Opening Date"; "Opening Date")
                {
                }
                field("Additional Opening Date"; "Additional Opening Date")
                {
                }
            }
            group(Benefits)
            {
                field("Provident Fund"; "Provident Fund")
                {
                }
                field("Citizenship Investment Trust"; "Citizenship Investment Trust")
                {
                }
                field("Travel Allowances"; "Travel Allowances")
                {
                }
                field("Daily Allowances"; "Daily Allowances")
                {
                }
                field("Dashain Bonus"; "Dashain Bonus")
                {
                }
                field("Leave Encashment"; "Leave Encashment")
                {
                }
                field(Overtime; Overtime)
                {
                }
                field("Life Insurance"; "Life Insurance")
                {
                }
                field("Medical Insurance"; "Medical Insurance")
                {
                }
                field("Disability Insurance"; "Disability Insurance")
                {
                }
                field("Paid Sick Leave"; "Paid Sick Leave")
                {
                }
                field("Paid Vacation"; "Paid Vacation")
                {
                }
                field(Loan; Loan)
                {
                }
                field("Profit Bonus"; "Profit Bonus")
                {
                }
                field("Pregnency Leave"; "Pregnency Leave")
                {
                }
                field("Paid Training Facility"; "Paid Training Facility")
                {
                }
            }
            group(Administration)
            {
                field("No. of Openings"; "No. of Openings")
                {
                }
                field(Department; Department)
                {
                }
                field("Vacancy Type"; "Vacancy Type")
                {
                }
                field("Job Locaiton"; "Job Locaiton")
                {
                }
                field(Partner; Partner)
                {
                }
                field("Job Assigned Date"; "Job Assigned Date")
                {
                }
                field("Add. Job Assigned Date"; "Add. Job Assigned Date")
                {
                }
            }
            group(Status)
            {
                field(Approved; Approved)
                {
                }
                field(Closed; Closed)
                {
                }
                field("Closing Date"; "Closing Date")
                {
                }
                field("Additional Closing Date"; "Additional Closing Date")
                {
                }
            }
            part("Requirement(s)"; 33020323)
            {
                Caption = 'Requirement(s)';
                SubPageLink = Vacancy No.=FIELD(Vacany No.);
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
            action(List)
            {
                Caption = 'List';
                RunObject = Page 33020326;
            }
            group("<Action1102159048>")
            {
                Caption = 'Approved';
                action("<Action1102159049>")
                {
                    Caption = 'Close';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ConfirmClose := DIALOG.CONFIRM(Text000, FALSE);
                        IF ConfirmClose THEN BEGIN
                            IF Approved OR Disapproved THEN BEGIN
                                Closed := TRUE;
                                VALIDATE("Closing Date", TODAY);
                                "Closed By" := USERID;
                                MODIFY;
                            END ELSE
                                ERROR(Text005);
                        END ELSE
                            MESSAGE(Text004, USERID);
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ConfirmReopen := DIALOG.CONFIRM(Text001, FALSE);
                        IF ConfirmReopen THEN BEGIN
                            IF Closed THEN BEGIN
                                Closed := FALSE;
                                Approved := FALSE;
                                VALIDATE("Reopened Date", TODAY);
                                MODIFY;
                            END ELSE
                                ERROR(Text006);
                        END ELSE
                            MESSAGE(Text004, USERID);
                    end;
                }
            }
        }
    }

    var
        HRSetup: Record "5218";
        ConfirmClose: Boolean;
        ConfirmReopen: Boolean;
        ConfirmApprove: Boolean;
        ConfirmDisapprove: Boolean;
        Text000: Label 'Are you sure - Close?';
        Text001: Label 'Are you sure - Reopen?';
        Text002: Label 'Are you sure - Approve?';
        Text003: Label 'Are you sure - Disapprove?';
        Text004: Label 'Aborted by user - %1!';
        Text005: Label 'Vacancy not approved or disapproved. Please verify!';
        Text006: Label 'Vacancy was not closed!';
        Text007: Label 'Vacancy is closed. Please check status.';
        Text008: Label 'Was closed or Approved. Please check status.';
}

