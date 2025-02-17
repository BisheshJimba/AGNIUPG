page 33020363 "Pending Training Requests"
{
    CardPageID = "Training Request Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020359;
    SourceTableView = WHERE(Approved = CONST(No),
                            Rejected = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tr. Req. No."; "Tr. Req. No.")
                {
                }
                field(Department; Department)
                {
                }
                field("Training Code"; "Training Code")
                {
                }
                field("Training Topic"; "Training Topic")
                {
                }
                field("Training Objective"; "Training Objective")
                {
                }
                field("Duration (days)"; "Duration (days)")
                {
                }
                field(ODT; ODT)
                {
                }
                field("Requested By"; "Requested By")
                {
                    Caption = 'Requested By';
                }
                field("Requested Date"; "Requested Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function(s)")
            {
                Caption = 'Function(s)';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = approvalSent;

                    trigger OnAction()
                    var
                        DocNotificationMgt: Codeunit "33019917";
                    begin
                        IF "Requested By" <> USERID THEN BEGIN
                            ConfirmApprove := DIALOG.CONFIRM(Text002, FALSE);
                            IF ConfirmApprove THEN BEGIN
                                Approved := TRUE;
                                Rejected := FALSE;
                                VALIDATE("Approved Date", TODAY);
                                "Approved By" := USERID;
                                MODIFY;
                                DocNotificationMgt.SendTrainingApprovedMailtoEmployee(Rec);  //SRT Feb 7th 2019
                                                                                             //TrainingReqHead.reset;

                                /* TrainingReqLine.SETRANGE("Tr. Req. No.","Tr. Req. No.");
                                TrainingReqLine.FIND('-');
                                    REPEAT
                                    IF (TrainingReqLine.Organization = '') THEN BEGIN
                                      TrainingRec.INIT;
                                      TrainingRec."Employee Code" := TrainingReqLine."Part. Employee";
                                      TrainingRec."Request No." := "Tr. Req. No.";
                                      TrainingRec.VALIDATE("Training Code","Training Code");
                                      TrainingRec."Training Topic" := "Training Topic";

                                      TrainingRec."From Date" := TrainingReqHead."From Date";
                                      TrainingRec."To Date" := TrainingReqHead."To Date";
                                      TrainingRec.INSERT;
                                    END;
                                    UNTIL TrainingReqLine.NEXT = 0;
                                    */

                            END ELSE BEGIN
                                MESSAGE(Text004, USERID);
                            END;
                        END;

                    end;
                }
                action(Disapprove)
                {
                    Caption = 'Disapprove';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = approvalSent;

                    trigger OnAction()
                    var
                        DocNotificationMgt: Codeunit "33019917";
                    begin
                        IF "Requested By" <> USERID THEN BEGIN
                            ConfirmDisapprove := DIALOG.CONFIRM(Text003, FALSE);
                            IF ConfirmDisapprove THEN BEGIN
                                Approved := FALSE;
                                Rejected := TRUE;
                                VALIDATE("Rejected Date", TODAY);
                                "Rejected By" := USERID;
                                MODIFY;
                                DocNotificationMgt.SendTrainingDisapprovedMailtoEmployee(Rec); //SRT Feb 7th 2019
                            END ELSE BEGIN
                                MESSAGE(Text004, USERID);
                            END;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF "Sent for Approval" THEN
            approvalSent := TRUE;
    end;

    var
        ConfirmApprove: Boolean;
        ConfirmDisapprove: Boolean;
        UserSetup: Record "91";
        Text002: Label 'Are you sure - Approve?';
        Text003: Label 'Are you sure - Disapprove?';
        Text004: Label 'Aborted by user - %1!';
        Text005: Label 'Vacancy not approved or disapproved. Please verify!';
        Text008: Label 'Was closed or Approved. Please check status.';
        Text009: Label 'You dont have Approval/Disapproval authority. Please contact your system administrator.';
        TrainingRec: Record "33020369";
        TrainingReqLine: Record "33020360";
        TrainingReqHead: Record "33020359";
        approvalSent: Boolean;
}

