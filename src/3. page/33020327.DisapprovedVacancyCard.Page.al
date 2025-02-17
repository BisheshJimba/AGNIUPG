page 33020327 "Disapproved Vacancy Card"
{
    PageType = Card;
    SourceTable = Table33020327;
    SourceTableView = SORTING(Vacany No.)
                      ORDER(Ascending)
                      WHERE(Disapproved = CONST(Yes));

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
            group(Status)
            {
                field(Disapproved; Disapproved)
                {
                }
                field("Disapproved Date"; "Disapproved Date")
                {
                }
                field("Additional Disapproved Date"; "Additional Disapproved Date")
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
            group("<Action1102159023>")
            {
                Caption = 'Disapproved';
                action(Approve)
                {
                    Caption = 'Approve';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
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
            }
        }
    }

    var
        HRSetup: Record "5218";
        ConfirmClose: Boolean;
        ConfirmReopen: Boolean;
        ConfirmApprove: Boolean;
        ConfirmDisapprove: Boolean;
        UserSetup: Record "91";
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

