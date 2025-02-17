page 33020322 "Vacancy Card for HR"
{
    PageType = Card;
    SourceTable = Table33020327;
    SourceTableView = SORTING(Vacany No.)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(No),
                            Disapproved = CONST(No));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vacany No."; "Vacany No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
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
                field("Partner Name"; "Partner Name")
                {
                }
                field("Job Assigned Date"; "Job Assigned Date")
                {
                }
                field("Add. Job Assigned Date"; "Add. Job Assigned Date")
                {
                }
            }
            group("Requirement(s)")
            {
                Caption = 'Requirement(s)';
                part(; 33020323)
                {
                    SubPageLink = Vacancy No.=FIELD(Vacany No.);
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
            group("Approve/Disapprove")
            {
                Caption = 'Approve/Disapprove';
                action(Approve)
                {
                    Caption = 'Approve';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        //Code to Check for the System Restriction application in HR Setup and User Setup and process for approval.
                        HRSetup.GET;

                        IF HRSetup."Apply System Restriction" THEN BEGIN
                            UserSetup.GET(USERID);
                            IF UserSetup."Approval/Disapproval Authority" THEN BEGIN
                                ConfirmApprove := DIALOG.CONFIRM(Text002, FALSE);
                                IF ConfirmApprove THEN BEGIN
                                    IF NOT Closed THEN BEGIN
                                        Approved := TRUE;
                                        Disapproved := FALSE;
                                        VALIDATE("Approved Date", TODAY);
                                        "Approved By" := USERID;
                                        MODIFY;
                                    END ELSE
                                        ERROR(Text007);
                                END ELSE
                                    MESSAGE(Text004, USERID);
                            END ELSE
                                ERROR(Text009);
                        END ELSE BEGIN
                            ConfirmApprove := DIALOG.CONFIRM(Text002, FALSE);
                            IF ConfirmApprove THEN BEGIN
                                IF NOT Closed THEN BEGIN
                                    Approved := TRUE;
                                    Disapproved := FALSE;
                                    VALIDATE("Approved Date", TODAY);
                                    "Approved By" := USERID;
                                    MODIFY;
                                END ELSE
                                    ERROR(Text007);
                            END ELSE
                                MESSAGE(Text004, USERID);
                        END;
                    end;
                }
                action("<Action1102159048>")
                {
                    Caption = 'Disapprove';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        //Code to Check for the System Restriction application in HR Setup and User Setup and process for Disapproval.
                        HRSetup.GET;
                        IF HRSetup."Apply System Restriction" THEN BEGIN
                            UserSetup.GET(USERID);
                            IF UserSetup."Approval/Disapproval Authority" THEN BEGIN
                                ConfirmDisapprove := DIALOG.CONFIRM(Text003, FALSE);
                                IF ConfirmDisapprove THEN BEGIN
                                    IF NOT Closed THEN BEGIN
                                        Disapproved := TRUE;
                                        VALIDATE("Disapproved Date", TODAY);
                                        "Disapproved By" := USERID;
                                        MODIFY;
                                    END ELSE
                                        ERROR(Text007);
                                END ELSE
                                    MESSAGE(Text004, USERID);
                            END ELSE
                                ERROR(Text009);
                        END ELSE BEGIN
                            ConfirmDisapprove := DIALOG.CONFIRM(Text003, FALSE);
                            IF ConfirmDisapprove THEN BEGIN
                                IF NOT Closed THEN BEGIN
                                    Disapproved := TRUE;
                                    VALIDATE("Disapproved Date", TODAY);
                                    "Disapproved By" := USERID;
                                    MODIFY;
                                END ELSE
                                    ERROR(Text007);
                            END ELSE
                                MESSAGE(Text004, USERID);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*HRSetup.GET;
        IF HRSetup."Use Additional Date" THEN BEGIN
          CurrPage."Additional Opening Date".VISIBLE := TRUE;
          CurrPage."Add. Job Assigned Date".VISIBLE := TRUE;
        END ELSE BEGIN
          CurrPage."Additional Opening Date".VISIBLE := FALSE;
          CurrPage."Add. Job Assigned Date".VISIBLE := FALSE;
        END;
         */

    end;

    trigger OnOpenPage()
    begin
        /*HRSetup.GET;
        IF HRSetup."Use Additional Date" THEN BEGIN
          CurrPage."Additional Opening Date".VISIBLE := TRUE;
          CurrPage."Add. Job Assigned Date".VISIBLE := TRUE;
        END ELSE BEGIN
          CurrPage."Additional Opening Date".VISIBLE := FALSE;
          CurrPage."Add. Job Assigned Date".VISIBLE := FALSE;
        END;*/

    end;

    var
        HRSetup: Record "5218";
        ConfirmApprove: Boolean;
        ConfirmDisapprove: Boolean;
        UserSetup: Record "91";
        DateCaption: Text[80];
        Caption1: Text[80];
        Text000: Label 'Are you sure - Close?';
        Text001: Label 'Are you sure - Reopen?';
        Text002: Label 'Are you sure - Approve?';
        Text003: Label 'Are you sure - Disapprove?';
        Text004: Label 'Aborted by user - %1!';
        Text005: Label 'Vacancy not approved or disapproved. Please verify!';
        Text006: Label 'Vacancy was not closed!';
        Text007: Label 'Vacancy is closed. Please check status.';
        Text008: Label 'Was closed or Approved. Please check status.';
        Text009: Label 'You dont have Approval/Disapproval authority. Please contact your system administrator.';
}

